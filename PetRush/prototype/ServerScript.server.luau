-- ServerScript.server.luau
-- Mapa, monedas y contador de colección. Punto de entrada del servidor.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Configuración
local COIN_VALUE = 1
local RESPAWN_TIME = 5

-- Flag para asegurar que init solo se ejecuta una vez
local initialized = false

-- Crear Floor y SpawnLocation
local function setupMap()
	-- Crear el suelo anclado
	local floor = Instance.new("Part")
	floor.Name = "Floor"
	floor.Size = Vector3.new(100, 1, 100)
	floor.Position = Vector3.new(0, -3, 0)
	floor.Anchored = true
	floor.Material = Enum.Material.Concrete
	floor.Color = BrickColor.new("Sand").Color
	floor.Parent = Workspace

	-- Crear SpawnLocation
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "SpawnLocation"
	spawn.TeamColor = BrickColor.new("Medium stone grey")
	spawn.Size = Vector3.new(4, 2, 4)
	spawn.Position = Vector3.new(0, 5, 0)
	spawn.Anchored = true
	spawn.Parent = Workspace
end

-- Crear monedas
local function createCoins()
	local coinTemplate = Instance.new("Part")
	coinTemplate.Name = "Coin"
	coinTemplate.Size = Vector3.new(1, 1, 1)
	coinTemplate.Shape = Enum.PartType.Ball
	coinTemplate.Anchored = true
	coinTemplate.Material = Enum.Material.Neon
	coinTemplate.Color = BrickColor.new("Gold").Color
	coinTemplate.CanCollide = true

	-- Dar valor a la moneda mediante un valor de instancia
	local value = Instance.new("IntValue")
	value.Name = "Value"
	value.Value = COIN_VALUE
	value.Parent = coinTemplate

	-- Posicionar monedas en círculo
	local coinPositions = {}
	for i = 1, 20 do
		local angle = (i / 20) * math.pi * 2
		local radius = 10
		local x = math.cos(angle) * radius
		local z = math.sin(angle) * radius
		local pos = Vector3.new(x, 3 + math.random(-0.5, 0.5), z)

		local coin = coinTemplate:Clone()
		coin.CFrame = CFrame.new(pos)
		coin.Parent = Workspace
		table.insert(coinPositions, coin)
	end
	return coinPositions
end

-- Configurar jugador (líderstats y monedas) - idempotente
local function setupPlayer(player)
	-- Evitar configuración duplicada
	if player:FindFirstChild("leaderstats") then return end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coinsValue = Instance.new("IntValue")
	coinsValue.Name = "Coins"
	coinsValue.Value = 0
	coinsValue.Parent = leaderstats
end

-- Lógica de colección
local function onCoinTouched(coin, player)
	if not coin.Parent then return end

	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	local proximity = (coin.Position - character.PrimaryPart.Position).Magnitude
	if proximity > 5 then return end

	-- Evitar colección múltiple
	local alreadyCollected = coin:FindFirstChild("CollectedTag")
	if alreadyCollected then return end

	local tag = Instance.new("BoolValue")
	tag.Name = "CollectedTag"
	tag.Parent = coin

	-- Sumar moneda en servidor
	setupPlayer(player)

	local coins = player.leaderstats:FindFirstChild("Coins")
	if not coins then return end

	coins.Value = coins.Value + COIN_VALUE

	-- Ocultar moneda y reprogramar
	coin.Transparency = 1
	coin.CanCollide = false

	task.delay(RESPAWN_TIME, function()
		if coin and coin.Parent then
			coin.Transparency = 0
			coin.CanCollide = true
			if tag then tag:Destroy() end
		end
	end)
end

-- Conectar eventos
local function setupCoinCollection(coinPositions)
	for _, coin in pairs(coinPositions) do
		coin.Touched:Connect(function(hit)
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if player then
				onCoinTouched(coin, player)
			end
		end)
	end
end

-- Inicialización (solo una vez al iniciar el servidor)
local function init()
	if initialized then return end
	initialized = true

	setupMap()
	local coins = createCoins()
	setupCoinCollection(coins)

	print("Prototipo servidor inicializado - 20 monedas distribuidas")
end

-- Conectar cuando un jugador se une
-- Configura leaderstats al unirse Y aplica a jugadores ya presentes
Players.PlayerAdded:Connect(function(player)
	setupPlayer(player)
end)

-- Aplicar setup a jugadores ya en el servidor (al cargar el lugar)
for _, player in pairs(Players:GetPlayers()) do
	setupPlayer(player)
end

-- Ejecutar init una sola vez al cargar el servidor
init()