-- ServerScript.server.luau
-- Mapa, monedas, caramelos y mascotas. Punto de entrada del servidor.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Configuración
local COIN_VALUE = 1
local CANDY_VALUE = 1
local RESPAWN_TIME = 5

-- Configuración de la tienda
local SHOP_PRICES = {
	["ComboMultiplier"] = 100, -- Cuesta 100 Candies desbloquear multiplicador
}

-- Configuración de Huevos con rarezas definidas
local EGG_CONFIG = {
	["CommonEgg"] = {
		Name = "CaramelEgg",
		Description = "Huevo común con mascota básica",
		CostCoins = 50,
		CostCandies = 0,
		Rarities = {
			Common = 60,   -- 60% de probabilidad (suman 100% con Rare abajo)
			Rare = 40,     -- 40% de probabilidad
		},
	},
	["RareEgg"] = {
		Name = "PetalEgg",
		Description = "Huevo raro con mascota con rasgos especiales",
		CostCoins = 200,
		CostCandies = 0,
		Rarities = {
			Rare = 50,     -- 50% de probabilidad (suman 100% con Epic abajo)
			Epic = 50,     -- 50% de probabilidad
		},
	},
	["EpicEgg"] = {
		Name = "StarEgg",
		Description = "Huevo épico con mascota legendaria",
		CostCoins = 500,
		CostCandies = 0,
		Rarities = {
			Epic = 60,     -- 60% de probabilidad (suman 100% con Legendary abajo)
			Legendary = 40, -- 40% de probabilidad
		},
	},
}

-- Flag para asegurar que init solo se ejecuta una vez
local initialized = false

-- Tabla para rastrear mascotas y conexiones por jugador
local playerPets = {}

-- RemoteEvent para la tienda (se crea automáticamente si no existe)
local function getShopRemote()
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local remote = replicatedStorage:FindFirstChild("ShopRemote")
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = "ShopRemote"
		remote.Parent = replicatedStorage
	end
	return remote
end

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

	-- Tabla para rastrear mascotas y conexiones por jugador
	playerPets[player] = {}

	-- Configurar conexiones para personaje
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

	-- Cuando el personaje reaparece, reinicializar la mascota visual
	local function onCharacterAdded(character)
		-- Posicionar la mascota visual sobre el humanoidrootpart
		local visualPet = character:FindFirstChild("VisualPet")
		if visualPet then
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				visualPet.CFrame = hrp.CFrame * CFrame.new(0, 2, 0)
			end
		end
		-- Also position the world pet if it exists
		local pet = character:FindFirstChild("StarterPet")
		if pet then
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
end

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

	-- Efectos visuales y auditivos al recoger
	-- Crear número flotante
	local floatValue = Instance.new("IntValue")
	floatValue.Name = "CoinValue"
	floatValue.Value = COIN_VALUE
	floatValue.Parent = coin

	-- Posicionar número flotante sobre la moneda
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CoinFloat"
	billboard.Size = UDim2.new(0, 50, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = coin

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	textLabel.TextScaled = true
	textLabel.Text = "+" .. COIN_VALUE
	textLabel.Parent = billboard

-- Reproducir sonido de colección (servidor)
	local sound = Instance.new("Sound")
	sound.Name = "CollectSound"
	sound.SoundId = "rbxassetid://45906511" -- Sound ID: moneda clásica
	sound.Parent = coin
	sound:Play()

	-- Eliminar efectos después de unos segundos
	task.delay(1, function()
		if billboard then billboard:Destroy() end
		if sound then sound:Destroy() end
		if floatValue then floatValue:Destroy() end
	end)

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

	-- Efectos visuales y auditivos al recoger
	-- Crear número flotante
	local floatValue = Instance.new("IntValue")
	floatValue.Name = "CandyValue"
	floatValue.Value = CANDY_VALUE
	floatValue.Parent = candy

	-- Posicionar número flotante sobre la caramelo
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CandyFloat"
	billboard.Size = UDim2.new(0, 50, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = candy

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
	textLabel.TextScaled = true
	textLabel.Text = "+" .. CANDY_VALUE
	textLabel.Parent = billboard

-- Reproducir sonido de colección (servidor)
	local sound = Instance.new("Sound")
	sound.Name = "CollectSound"
	sound.SoundId = "rbxassetid://311792765" -- Sound ID: sonido dulce
	sound.Parent = candy
	sound:Play()

	-- Eliminar efectos después de unos segundos
	task.delay(1, function()
		if billboard then billboard:Destroy() end
		if sound then sound:Destroy() end
		if floatValue then floatValue:Destroy() end
	end)

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

-- Función para procesar compra en la tienda
local function processShopPurchase(player, purchaseType)
	if purchaseType == "ComboMultiplier" then
		local candies = player.leaderstats:FindFirstChild("Candies")
		if not candies then return false, "No tienes Candies" end

		-- Validar que el jugador tenga suficientes candies
		if candies.Value < SHOP_PRICES["ComboMultiplier"] then
			return false, "No tienes suficientes Candies"
		end

		-- Descontar candies
		candies.Value = candies.Value - SHOP_PRICES["ComboMultiplier"]

		-- Aplicar multiplicador
		player.CookieMultiplier = 1.5 -- Multiplicador de combo

		return true, "Multiplicador desbloqueado: 1.5x"
	end

	return false, "Tipo de compra no válido"
end

-- Función para procesar compra de huevo
local function processEggPurchase(player, eggType)
	local egg = EGG_CONFIG[eggType]
	if not egg then return false, "Tipo de huevo no válido" end

	-- Verificar costo en monedas
	local coins = player.leaderstats:FindFirstChild("Coins")
	if not coins then return false, "Error: no hay leaderstats" end

	if coins.Value < egg.CostCoins then
		return false, "No tienes suficientes Coins para comprar este huevo"
	end

	-- Verificar costo en caramelos (si tiene costo)
	if egg.CostCandies then
		local candies = player.leaderstats:FindFirstChild("Candies")
		if not candies then return false, "Error: no hay Candies" end
		if candies.Value < egg.CostCandies then
			return false, "No tienes suficientes Candies para comprar este huevo"
		end
	end

	-- Descontar monedas
	coins.Value = coins.Value - egg.CostCoins

	-- Si tiene costo en caramelos, descontarlos también
	if egg.CostCandies then
		local candies = player.leaderstats:FindFirstChild("Candies")
		candies.Value = candies.Value - egg.CostCandies
	end

	-- Abrir huevo y determinar rareza
	local rarity = determineRarity(egg.Rarities)
	local petName = generatePetName(rarity)

	-- Dar mascota al jugador
	local result = givePetToPlayer(player, petName, rarity)

	return true, "¡Abriste un " .. egg.Name .. " y obtuviste una mascota " .. rarity .. "!"
end

-- Función para determinar rareza aleatoria basada en pesos
local function determineRarity(rarityTable)
	local totalWeight = 0
	for rarity, weight in pairs(rarityTable) do
		totalWeight = totalWeight + weight
	end

	local random = math.random(1, totalWeight)
	local currentWeight = 0

	for rarity, weight in pairs(rarityTable) do
		currentWeight = currentWeight + weight
		if random <= currentWeight then
			return rarity
		end
	end

	-- Fallback a Common
	return "Common"
end

-- Función para generar nombre de mascota basado en rareza
local function generatePetName(rarity)
	local baseNames = {
		Common = "Dulce",
		Rare = "Floral",
		Epic = "Estelar",
		Legendary = "Mítico"
	}

	local suffixes = {
		Common = {"Picotón", "Blando", "Pequeño"},
		Rare = {"Resplandeciente", "Veloz", "Coloreado"},
		Epic = {"Arcángel", "Mágico", "Divino"},
		Legendary = {"Sagrado", "Eterno", "Infinito"}
	}

	local base = baseNames[rarity]
	local suffix = suffixes[rarity][math.random(1, #suffixes[rarity])]

	return base .. " " .. suffix
end

-- Función para dar mascota al jugador
local function givePetToPlayer(player, petName, rarity)
	-- Crear carpeta de mascotas si no existe
	local petsFolder = player:FindFirstChild("Pets")
	if not petsFolder then
		petsFolder = Instance.new("Folder")
		petsFolder.Name = "Pets"
		petsFolder.Parent = player
	end

	-- Verificar si hay slot disponible (máximo 3 mascotas equipadas)
	local equippedCount = 0
	local maxSlots = 3
	for _, child in pairs(player.Pets:GetChildren()) do
		if child:IsA("StringValue") then
			equippedCount = equippedCount + 1
		end
	end

	if equippedCount >= maxSlots then
		-- Guardar en inventario (aún no implementado visualmente, solo lógica)
		local inventoryFolder = player:FindFirstChild("Inventory")
		if not inventoryFolder then
			inventoryFolder = Instance.new("Folder")
			inventoryFolder.Name = "Inventory"
			inventoryFolder.Parent = player
		end
		local petValue = Instance.new("StringValue")
		petValue.Name = petName .. "_" .. rarity
		petValue.Parent = inventoryFolder
		return "guardado_en_inventario"
	end

-- Crear mascota en la carpeta del jugador
	local petValue = Instance.new("StringValue")
	petValue.Name = "PetName"
	petValue.Value = petName .. " (" .. rarity .. ")"
	petValue.Parent = petsFolder

-- Equipar la mascota automáticamente
	player.leaderstats.EquippedPet.Value = petName

	return "equipado"
end

-- Función para procesar compra de huevo
local function processEggPurchase(player, eggType)
	local egg = EGG_CONFIG[eggType]
	if not egg then return false, "Tipo de huevo no válido" end

	-- Verificar costo en monedas
	local coins = player.leaderstats:FindFirstChild("Coins")
	if not coins then return false, "Error: no hay leaderstats" end

	if coins.Value < egg.CostCoins then
		return false, "No tienes suficientes Coins para comprar este huevo"
	end

	-- Verificar costo en caramelos (si tiene costo)
	if egg.CostCandies then
		local candies = player.leaderstats:FindFirstChild("Candies")
		if not candies then return false, "Error: no hay Candies" end
		if candies.Value < egg.CostCandies then
			return false, "No tienes suficientes Candies para comprar este huevo"
		end
	end

	-- Descontar monedas
	coins.Value = coins.Value - egg.CostCoins

	-- Si tiene costo en caramelos, descontarlos también
	if egg.CostCandies then
		local candies = player.leaderstats:FindFirstChild("Candies")
		candies.Value = candies.Value - egg.CostCandies
	end

	-- Abrir huevo y determinar rareza
	local rarity = determineRarity(egg.Rarities)
	local petName = generatePetName(rarity)

	-- Dar mascota al jugador
	local result = givePetToPlayer(player, petName, rarity)

	return true, "¡Abriste un " .. egg.Name .. " y obtuviste una mascota " .. rarity .. "!"
end

-- Función para determinar rareza aleatoria basada en pesos
local function determineRarity(rarityTable)
	local totalWeight = 0
	for rarity, weight in pairs(rarityTable) do
		totalWeight = totalWeight + weight
	end

	local random = math.random(1, totalWeight)
	local currentWeight = 0

	for rarity, weight in pairs(rarityTable) do
		currentWeight = currentWeight + weight
		if random <= currentWeight then
			return rarity
		end
	end

	-- Fallback a Common
	return "Common"
end

-- Función para generar nombre de mascota basado en rareza
local function generatePetName(rarity)
	local baseNames = {
		Common = "Dulce",
		Rare = "Floral",
		Epic = "Estelar",
		Legendary = "Mítico"
	}

	local suffixes = {
		Common = {"Picotón", "Blando", "Pequeño"},
		Rare = {"Resplandeciente", "Veloz", "Coloreado"},
		Epic = {"Arcángel", "Mágico", "Divino"},
		Legendary = {"Sagrado", "Eterno", "Infinito"}
	}

	local base = baseNames[rarity]
	local suffix = suffixes[rarity][math.random(1, #suffixes[rarity])]

	return base .. " " .. suffix
end

-- Función para dar mascota al jugador
local function givePetToPlayer(player, petName, rarity)
	-- Crear carpeta de mascotas si no existe
	local petsFolder = player:FindFirstChild("Pets")
	if not petsFolder then
		petsFolder = Instance.new("Folder")
		petsFolder.Name = "Pets"
		petsFolder.Parent = player
	end

	-- Verificar si hay slot disponible (máximo 3 mascotas equipadas)
	local equippedCount = 0
	local maxSlots = 3
	for _, child in pairs(player.Pets:GetChildren()) do
		if child:IsA("StringValue") then
			equippedCount = equippedCount + 1
		end
	end

	if equippedCount >= maxSlots then
		-- Guardar en inventario (aún no implementado visualmente, solo lógica)
		local inventoryFolder = player:FindFirstChild("Inventory")
		if not inventoryFolder then
			inventoryFolder = Instance.new("Folder")
			inventoryFolder.Name = "Inventory"
			inventoryFolder.Parent = player
		end
		local petValue = Instance.new("StringValue")
		petValue.Name = petName .. "_" .. rarity
		petValue.Parent = inventoryFolder
		return "guardado_en_inventario"
	end

-- Crear mascota en la carpeta del jugador
	local petValue = Instance.new("StringValue")
	petValue.Name = "PetName"
	petValue.Value = petName .. " (" .. rarity .. ")"
	petValue.Parent = petsFolder

-- Equipar la mascota automáticamente
	player.leaderstats.EquippedPet.Value = petName

	return "equipado"
end

-- Función para dar mascota inicial al jugador
local function giveStartingPet(player)
	-- Crear carpeta de mascotas si no existe
	local petsFolder = player:FindFirstChild("Pets")
	if not petsFolder then
		petsFolder = Instance.new("Folder")
		petsFolder.Name = "Pets"
		petsFolder.Parent = player
	end

	-- Crear la mascota inicial en la carpeta del jugador
	local petValue = Instance.new("StringValue")
	petValue.Name = "PetName"
	petValue.Value = "Puppy"
	petValue.Parent = petsFolder

	-- Equipar la mascota automaticamente
	player.leaderstats.EquippedPet.Value = "Puppy"

	-- Crear parte visual de la mascota que seguirá al jugador
	local visualPet = player:FindFirstChild("VisualPet")
	if not visualPet then
		visualPet = Instance.new("Part")
		visualPet.Name = "VisualPet"
		visualPet.Size = Vector3.new(2, 2, 2)
		visualPet.Shape = Enum.PartType.Ball
		visualPet.Anchored = false
		visualPet.Material = Enum.Material.Neon
		visualPet.Color = BrickColor.new("Medium stone grey").Color
		visualPet.CanCollide = false
		visualPet.Parent = player
	end

	-- Posicionar mascota visual al inicio
	local function positionVisualPet()
		local function onCharacterAdded(character)
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				visualPet.CFrame = hrp.CFrame * CFrame.new(0, 2, 0)
			end
		end
		player.CharacterAdded:Connect(onCharacterAdded)
		local character = player.Character
		if character then
			onCharacterAdded(character)
		end
	end
	positionVisualPet()

	-- Equipar la mascota automaticamente
	player.leaderstats.EquippedPet.Value = "Puppy"
end

-- Función para equipar la mascota
local function equipPet(player, petName)
	local equipped = player.leaderstats:FindFirstChild("EquippedPet")
	if not equipped then return end

	-- Evitar equipar la misma mascota dos veces
	if equipped.Value == petName then return end

	equipped.Value = petName
	print("Mascota equipada: " .. petName)

	-- Aquí podría ir lógica visual para mostrar la mascota
end

-- Función para desequipar la mascota
local function unequipPet(player)
	local equipped = player.leaderstats:FindFirstChild("EquippedPet")
	if not equipped then return end

	equipped.Value = ""
	print("Mascota desequipada")
end

-- Listeners de evento para la tienda vía RemoteEvent
local function onShopPurchase(player, purchaseType)
	local success, message = processShopPurchase(player, purchaseType)
	local remote = getShopRemote()
	-- Fire client with result
	if remote then
		remote:FireClient(player, success, message)
	end
	return success, message
end

Players.PlayerAdded:Connect(function(player)
	-- Inicializar datos del jugador
	setupPlayer(player)
	giveStartingPet(player)
end)

-- Aplicar setup a jugadores ya en el servidor (al cargar el lugar)
for _, player in pairs(Players:GetPlayers()) do
	setupPlayer(player)
	giveStartingPet(player)
end

-- Ejecutar init una sola vez al cargar el servidor
function init()
	-- Configurar mapa
	setupMap()

	-- Crear monedas y caramelos
	local coinPositions = createCoins()
	local candyPositions = createCandies()

	-- Conectar colecciones
	setupCoinCollection(coinPositions)
	setupCandyCollection(candyPositions)

	-- Crear mascota en el mundo
	createStarterPet()

	-- Marcar como inicializado
	initialized = true
end

-- Ejecutar init
init()