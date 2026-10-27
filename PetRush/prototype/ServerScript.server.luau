-- ServerScript.server.luau
-- Mapa, monedas, caramelos y mascotas. Punto de entrada del servidor.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Configuración
local COIN_VALUE = 1
local CANDY_VALUE = 1
local PET_VALUE = 1
local RESPAWN_TIME = 5

-- Flag para asegurar que init solo se ejecuta una vez
local initialized = false

-- Tabla para rastrear mascotas y conexiones por jugador
local playerPets = {}

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

-- Crear caramelos
local function createCandies()
	local candyTemplate = Instance.new("Part")
	candyTemplate.Name = "Candy"
	candyTemplate.Size = Vector3.new(1, 1, 1)
	candyTemplate.Shape = Enum.PartType.Ball
	candyTemplate.Anchored = true
	candyTemplate.Material = Enum.Material.Neon
	candyTemplate.Color = BrickColor.new("Red").Color
	candyTemplate.CanCollide = true

	-- Dar valor a la caramelo mediante un valor de instancia
	local value = Instance.new("IntValue")
	value.Name = "Value"
	value.Value = CANDY_VALUE
	value.Parent = candyTemplate

	-- Posicionar caramelos en cuadrícula
	local candyPositions = {}
	for i = 1, 10 do
		local x = (i - 1) % 5 * 3 - 5
		local y = math.floor((i - 1) / 5) * 3 + 3
		local z = 0
		local pos = Vector3.new(x, y, z)

		local candy = candyTemplate:Clone()
		candy.CFrame = CFrame.new(pos)
		candy.Parent = Workspace
		table.insert(candyPositions, candy)
	end
	return candyPositions
end

-- Crear mascota inicial en el mundo
local function createStarterPet()
	local petTemplate = Instance.new("Part")
	petTemplate.Name = "StarterPet"
	petTemplate.Size = Vector3.new(2, 2, 2)
	petTemplate.Shape = Enum.PartType.Ball
	petTemplate.Anchored = true
	petTemplate.Material = Enum.Material.Neon
	petTemplate.Color = BrickColor.new("Medium stone grey").Color
	petTemplate.CanCollide = false

	-- Dar valor a la mascota mediante un valor de instancia
	local petName = Instance.new("StringValue")
	petName.Name = "PetName"
	petName.Value = "Puppy"
	petName.Parent = petTemplate

	-- Posicionar mascota en el mundo
	petTemplate.CFrame = CFrame.new(0, 5, 0)
	petTemplate.Parent = Workspace
end

-- Configurar jugador (líderstats, mascota y datos) - idempotente
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

	local candiesValue = Instance.new("IntValue")
	candiesValue.Name = "Candies"
	candiesValue.Value = 0
	candiesValue.Parent = leaderstats

	local petValue = Instance.new("StringValue")
	petValue.Name = "EquippedPet"
	petValue.Value = ""
	petValue.Parent = leaderstats

	-- Configurar conexiones para esta personaje
	-- Limpiar mascota anterior al reaparecer
	local function onCharacterRemoving(character)
		-- Limpiar la mascota visual si existe en el personaje
		local pet = character:FindFirstChild("StarterPet")
		if pet then
			pet:Destroy()
		end
		-- Limpiar la conexión si existe
		if playerPets[player] then
			playerPets[player]:Disconnect()
			playerPets[player] = nil
		end
	end

	-- Cuando el personaje reaparece, reinicializar la mascota
	local function onCharacterAdded(character)
		-- Colocar la mascota sobre el personaje
		local pet = character:FindFirstChild("StarterPet")
		if pet then
			-- Posicionar la mascota sobre el humanoidrootpart
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				pet.CFrame = hrp.CFrame * CFrame.new(0, 2, 0)
			end
		end
	end

	-- Conectar eventos de personaje
	player.CharacterAdded:Connect(onCharacterAdded)
	-- Limpiar al salir
	player.CharacterRemoving:Connect(onCharacterRemoving)

	-- Configurar leaderstats
	leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coinsValue = Instance.new("IntValue")
	coinsValue.Name = "Coins"
	coinsValue.Value = 0
	coinsValue.Parent = leaderstats

	local candiesValue = Instance.new("IntValue")
	candiesValue.Name = "Candies"
	candiesValue.Value = 0
	candiesValue.Parent = leaderstats

	local petValue = Instance.new("StringValue")
	petValue.Name = "EquippedPet"
	petValue.Value = ""
	petValue.Parent = leaderstats

	-- Almacenar la conexión para limpieza futura
	playerPets[player] = player.CharacterAdded:Connect(onCharacterAdded)
	player.CharacterRemoving:Connect(function()
		if playerPets[player] then
			playerPets[player]:Disconnect()
			playerPets[player] = nil
		end
		if player.Character then
			local pet = player.Character:FindFirstChild("StarterPet")
			if pet then
				pet:Destroy()
			end
		end
	end)

-- Lógica de colección de monedas
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

-- Lógica de colección de caramelos
local function onCandyTouched(candy, player)
	if not candy.Parent then return end

	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	local proximity = (candy.Position - character.PrimaryPart.Position).Magnitude
	if proximity > 5 then return end

	-- Evitar colección múltiple
	local alreadyCollected = candy:FindFirstChild("CollectedTag")
	if alreadyCollected then return end

	local tag = Instance.new("BoolValue")
	tag.Name = "CollectedTag"
	tag.Parent = candy

	-- Sumar caramelo en servidor
	setupPlayer(player)

	local candies = player.leaderstats:FindFirstChild("Candies")
	if not candies then return end

	candies.Value = candies.Value + CANDY_VALUE

	-- Ocultar caramelo y reprogramar
	candy.Transparency = 1
	candy.CanCollide = false

	task.delay(CANDY_RESPAWN_TIME, function()
		if candy and candy.Parent then
			candy.Transparency = 0
			candy.CanCollide = true
			if tag then tag:Destroy() end
		end
	end)
end

-- Conectar eventos de monedas
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

-- Conectar eventos de caramelos
local function setupCandyCollection(candyPositions)
	for _, candy in pairs(candyPositions) do
		candy.Touched:Connect(function(hit)
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if player then
				onCandyTouched(candy, player)
			end
		end)
	end
end

-- Crear mascota inicial en el mundo
local function createStarterPet()
	local petTemplate = Instance.new("Part")
	petTemplate.Name = "StarterPet"
	petTemplate.Size = Vector3.new(2, 2, 2)
	petTemplate.Shape = Enum.PartType.Ball
	petTemplate.Anchored = true
	petTemplate.Material = Enum.Material.Neon
	petTemplate.Color = BrickColor.new("Medium stone grey").Color
	petTemplate.CanCollide = false

	-- Dar valor a la mascota mediante un valor de instancia
	local petName = Instance.new("StringValue")
	petName.Name = "PetName"
	petName.Value = "Puppy"
	petName.Parent = petTemplate

	-- Posicionar mascota en el mundo
	petTemplate.CFrame = CFrame.new(0, 5, 0)
	petTemplate.Parent = Workspace
end

-- Inicialización (solo una vez al iniciar el servidor)
local function init()
	if initialized then return end
	initialized = true

	setupMap()
	local coins = createCoins()
	setupCoinCollection(coins)

	local candies = createCandies()
	setupCandyCollection(candies)

	createStarterPet()

	print("Prototipo servidor inicializado - 20 monedas, 10 caramelos y mascota inicial")
end

-- Conectar cuando un jugador se une
-- Configura leaderstats y mascota al unirse Y aplica a jugadores ya presentes
Players.PlayerAdded:Connect(function(player)
	setupPlayer(player)
	-- Dar mascota inicial al unirse
	local success, err = pcall(giveStartingPet, player)
	if not success then
		warn("Error giving starting pet: " .. tostring(err))
	end
end)

-- Aplicar setup a jugadores ya en el servidor (al cargar el lugar)
for _, player in pairs(Players:GetPlayers()) do
	setupPlayer(player)
	-- Dar mascota inicial a jugadores ya presentes
	local success, err = pcall(giveStartingPet, player)
	if not success then
		warn("Error giving starting pet to existing player: " .. tostring(err))
	end
end)

-- Ejecutar init una sola vez al cargar el servidor
init()
