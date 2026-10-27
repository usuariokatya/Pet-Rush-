-- Collectibles.server.luau
-- Módulo para manejar objetos recolectables (monedas, caramelos, huevos)
-- Ejecútese en ServerScriptService/Systems

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Config = require(ReplicatedStorage.Shared.GameConfig)
local Rewards = require(ReplicatedStorage.Shared.Rewards)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local Collectibles = {}

-- Crear un objeto recolectable
function Collectibles.CreateCollectible(position: Vector3, type: string, zoneName: string?)
	local className = "Part"
	local part = Instance.new(className)
	part.Name = type .. "_Collectible"
	part.Anchored = true
	part.CanCollide = true
	part.Size = Vector3.new(1, 1, 1)
	part.Position = position

	-- Protección de ciclo de vida: determinar el contenedor válido
	local mapBase = Workspace:FindFirstChild("PetRushMap") or Workspace
	local container = mapBase

	if zoneName then
		local zoneFolder = mapBase:FindFirstChild(zoneName)
		if zoneFolder and zoneFolder:IsA("Folder") then
			container = zoneFolder
		end
	end

	part.Parent = container

	-- Configurar según tipo
	if type == "Coin" then
		part.BrickColor = BrickColor.new("Neon Gold")
		part.Material = "Neon"
		part.Color = Color3.fromRGB(255, 215, 0)

		-- Agregar símbolo de moneda
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 50, 0, 50)
		billboard.StudsPerPixel = 100
		billboard.Adornee = part
		billboard.Parent = part

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "💰"
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextSize = 24
		textLabel.Parent = billboard

	elseif type == "Candy" then
		part.BrickColor = BrickColor.new("Neon Red")
		part.Material = "Neon"
		part.Color = Color3.fromRGB(255, 0, 0)

		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 50, 0, 50)
		billboard.StudsPerPixel = 100
		billboard.Adornee = part
		billboard.Parent = part

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "🍬"
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextSize = 24
		textLabel.Parent = billboard

	elseif type == "Egg" then
		part.BrickColor = BrickColor.new("Neon Egg Yellow")
		part.Material = "Neon"
		part.Color = Color3.fromRGB(255, 255, 0)

		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 60, 0, 60)
		billboard.StudsPerPixel = 100
		billboard.Adornee = part
		billboard.Parent = part

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "🥚"
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextSize = 20
		textLabel.Parent = billboard
	end

	-- Configurar tiempo de reaparición
	local respawnTime = math.random(Config.Respawn.Min * 100, Config.Respawn.Max * 100) / 100

	-- Detectar cuándo un jugador toca el objeto
	local touchedConn = part.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)

		if player then
			-- Validar que el objeto aún existe y no ha sido recogido
			if part and part.Parent then
				-- Calcular distancia y dar recompensas
				Collectibles.OnTouched(part, player, type, zoneName)

				-- Desconectar la conexión
				touchedConn:Disconnect()

			-- Eliminar el objeto físico
				part:Destroy()

-- Programar reaparición con fallback a Workspace
				task.delay(respawnTime, function()
				-- Usar contenedor original si aún existe, sino Workspace
				local safeContainer = container and container.Parent and container or Workspace
				if safeContainer then
					Collectibles.CreateCollectible(position, type, zoneName)
				end
			end)
		end
	end)

	return part
end

-- Manejar cuándo un jugador toca un objeto recolectable
function Collectibles.OnTouched(part: Part, player: Player, type: string, zoneName: string?)
	local Config = require(game.ReplicatedStorage.Shared.GameConfig)

	-- Determinar recompensas base según tipo
	local baseReward
	if type == "Coin" then
		baseReward = {
			Candy = Config.Points.CandyValue,
			Coins = Config.Points.CoinValue,
			XP = 5,
		}
	elseif type == "Candy" then
		baseReward = {
			Candy = Config.Points.CandyValue,
			Coins = 0,
			XP = 3,
		}
	elseif type == "Egg" then
		baseReward = {
			Candy = 0,
			Coins = Config.Points.EggReward,
			XP = 10,
		}
	else
		baseReward = {
			Candy = 0,
			Coins = 0,
			XP = 0,
		}
	end

-- Aplicar multiplicador de combo y zona
	local comboMultiplier = 1.0
	local playerData = require(game.ServerScriptService.Systems.PlayerData)

	-- Verificar combo (usar último tiempo de recogida)
	local lastTime = Collectibles._lastCollectTime[player.UserId] or 0
	local currentTime = tick()
	local timeSinceLast = currentTime - lastTime

	-- Configuración de combo
	local maxCombo = Config.Combo.MaxMultiplier
	local decayTime = Config.Combo.TimeBeforeDecay

	if timeSinceLast < decayTime then
		-- Aún hay combo activo, incrementarlo
		Collectibles._comboLevel[player.UserId] = (Collectibles._comboLevel[player.UserId] or 1) + 1
		comboMultiplier = math.min((Collectibles._comboLevel[player.UserId] or 1) / math.max(maxCombo, 1), maxCombo)
	else
		-- Reiniciar combo
		Collectibles._comboLevel[player.UserId] = 1
	end

	Collectibles._lastCollectTime[player.UserId] = currentTime

-- Calcular recompensas finales con multipliers
	local finalReward = Rewards.CalculateReward(baseReward, Collectibles._comboLevel[player.UserId], zoneName)

-- Dar recompensas al jugador
	Rewards.GiveRewards(player, finalReward)

-- Mostrar combo en HUD si cambió
	if Collectibles._comboLevel[player.UserId] and Collectibles._comboLevel[player.UserId] > 1 then
		Remotes.Server.ShowCombo:FireClient(player, {
			multiplier = comboMultiplier,
			duration = 3,
		})
	end

-- Efectos visuales y de sonido
-- Crear número flotante
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local floatPart = Instance.new("Part")
		floatPart.Size = Vector3.new(1, 1, 1)
		floatPart.Transparency = 1
		floatPart.CanCollide = false
		floatPart.Anchored = true
		floatPart.CFrame = hrp.CFrame * CFrame.new(0, 2, 0)
		floatPart.Parent = Workspace

		local floatGui = Instance.new("BillboardGui")
		floatGui.Size = UDim2.new(0, 100, 0, 50)
		floatGui.StudsPerPixel = 100
		floatGui.Adornee = floatPart
		floatGui.Parent = floatPart

		local floatText = Instance.new("TextLabel")
		floatText.Size = UDim2.new(1, 0, 1, 0)
		floatText.BackgroundTransparency = 1

		-- Determinar qué texto mostrar
		if type == "Coin" then
			floatText.Text = "+" .. finalReward.Coins .. " 💰"
		elseif type == "Candy" then
			floatText.Text = "+" .. finalReward.Candy .. " 🍬"
		elseif type == "Egg" then
			floatText.Text = "+" .. finalReward.Coins .. " 🥚"
		end

		floatText.TextColor3 = Color3.new(1, 1, 1)
		floatText.TextSize = 14
		floatText.Parent = floatGui

-- Eliminar la parte visual después de unos segundos
		game:GetService("Debris"):AddItem(floatPart, 3)
	end

	print("Objeto recolectado por " .. player.Name .. ": " .. type)
end

-- Inicializar sistemas para un jugador
function Collectibles.InitPlayer(player: Player)
	-- Inicializar tablas de seguimiento para este jugador
	if not Collectibles._lastCollectTime[player.UserId] then
		Collectibles._lastCollectTime[player.UserId] = 0
	end
	if not Collectibles._comboLevel[player.UserId] then
		Collectibles._comboLevel[player.UserId] = 1
	end

	print("Sistema de recogida inicializado para: " .. player.Name)
end

-- Conectar cuando el personaje de un jugador se añade
function Collectibles.OnCharacterAdded(character: Model, player: Player)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		hrp = character:WaitForChild("HumanoidRootPart")
	end

	-- El combo se reinicia si el personaje muere o reaparece
	Collectibles._lastCollectTime[player.UserId] = tick()
end

-- Tabla estática para rastreo (se reinicia al reiniciar servidor)
Collectibles._lastCollectTime = {}
Collectibles._comboLevel = {}

return Collectibles
