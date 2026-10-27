-- Main.server.luau
-- Script principal del servidor que inicializa todos los sistemas
-- Ejecútese automáticamente en ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Cargar configuración
local Config = require(ReplicatedStorage.Shared.GameConfig)

-- Cargar módulos de sistemas
local PlayerData = require(script.Parent.Systems.PlayerData)
local Collectibles = require(script.Parent.Systems.Collectibles)
local Pets = require(script.Parent.Systems.Pets)
local Levels = require(script.Parent.Systems.Levels)
local Shop = require(script.Parent.Systems.Shop)
local Zones = require(script.Parent.Systems.Zones)

-- Tabla para rastrear cuándo cada jugador recogió por última vez
local lastCollectTime = {}

-- Función para inicializar a un jugador cuando se une
local function onPlayerAdded(player: Player)
	print("Jugador se unió: " .. player.Name)

	-- Cargar datos guardados
	PlayerData.LoadPlayerData(player)

	-- Configurar sistemas para este jugador
	Collectibles.InitPlayer(player)
	Pets.InitPlayer(player)

	-- Conectar evento de salida para guardar datos
	player.AncestryChanged:Connect(function(_, _)
		if not player.Parent then
			-- Guardar datos al salir
			PlayerData.SavePlayerData(player)
			print("Datos guardados para: " .. player.Name)
		end
	end)
end

-- Función para inicializar cuando el jugador carga el personaje
local function onCharacterAdded(character: Model)
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- Pequeño wait para asegurar que los datos estén cargados
	task.wait(0.5)

	-- Configurar recogida en el personaje
	Collectibles.OnCharacterAdded(character, player)

	-- Configurar mascota siguiente
	Pets.OnCharacterAdded(character, player)
end

-- Conectar eventos
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(player)
	-- Guardar datos al salir
	PlayerData.SavePlayerData(player)
	print("Jugador se fue: " .. player.Name)
end)

-- Manejar compras de la tienda
local Remotes = require(ReplicatedStorage.Shared.Remotes)
Remotes.Client.OnPurchase.OnServerEvent:Connect(function(player, itemName)
	if Shop.PurchaseItem(player, itemName) then
		print("Compra exitosa: " .. itemName .. " para " .. player.Name)
	else
		print("Compra fallida para " .. player.Name)
	end
end)

Players.PlayerCharacterAdded:Connect(onCharacterAdded)

-- Dar recompensas iniciales al unirse
task.spawn(function()
	for _, player in pairs(Players:GetPlayers()) do
		PlayerData.Set(player, "Coins", 50) -- Moneda inicial
		PlayerData.Set(player, "Level", 1)
		PlayerData.Set(player, "XP", 0)
		PlayerData.Set(player, "Candy", 0)

		-- Desbloquear mascotas iniciales
		-- Note: PetData needs to be available here
		local PetData = require(ReplicatedStorage.Shared.PetData)
		local startingPets = PetData.GetStartingPets()
		local unlockedPets = {}
		for _, pet in ipairs(startingPets) do
			table.insert(unlockedPets, pet.Name)
		end
		PlayerData.Set(player, "Pets", unlockedPets)
		PlayerData.Set(player, "EquippedPet", unlockedPets[1] or "")

		print("Datos iniciales configurados para: " .. player.Name)
	end
end)

print("Main.server.luau - Sistemas inicializados")
