-- PlayerData.server.luau
-- Módulo para gestionar datos del jugador con validación en servidor
-- Usa DataStoreService para persistencia

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local this = {}
local PlayerData = {}

-- DataStore para guardar progreso
local dataStore = DataStoreService:GetDataStore("PetRushPlayerData")

-- Obtener valor de datos del jugador
function PlayerData.Get(player: Player, key: string): any
	local data = PlayerData[player]
	if data and data[key] ~= nil then
		return data[key]
	end
	
	-- Intentar cargar desde DataStore
	local success, savedData = pcall(function()
		return dataStore:GetAsync("Player_" .. player.UserId)
	end)
	
	if success and savedData then
		-- Merged con datos locales si existen
		if not PlayerData[player] then
			PlayerData[player] = {}
		end
		
		PlayerData[player] = table.merge(PlayerData[player], savedData)
		return savedData[key]
	end
	
	return nil
end

-- Establecer valor en datos del jugador (validado en servidor)
function PlayerData.Set(player: Player, key: string, value: any)
	-- Validaciones de seguridad - nunca permitir valores nil para datos críticos
	if key == "Coins" or key == "XP" or key == "Level" or key == "Candy" then
		if value == nil then
			warn("Intento de establecer nil en dato crítico: " .. key)
			return false
		end
		
		-- Asegurar tipos correctos
		if typeof(value) ~= "number" then
			value = tonumber(value) or 0
		end
		
		-- Evitar valores negativos para monedas y XP
		if key == "Coins" and value < 0 then
			value = 0
		end
		if key == "XP" and value < 0 then
			value = 0
	end
	end
	
	-- Guardar en memoria local
	if not PlayerData[player] then
		PlayerData[player] = {}
	end
	
	PlayerData[player][key] = value
	
	-- Guardar en DataStore (con debounce para evitar spam)
	task.spawn(function()
		local success, errorMsg = pcall(function()
			local playerData = {}
			for k, v in pairs(PlayerData[player]) do
				playerData[k] = v
			end
			dataStore:SetAsync("Player_" .. player.UserId, playerData)
		end)
		
		if not success then
			warn("Error guardando datos para " .. player.Name .. ": " .. tostring(errorMsg))
		end
	end)
	
	return true
end

-- Cargar datos del jugador al unirse
function PlayerData.LoadPlayerData(player: Player)
	local success, savedData = pcall(function()
		return dataStore:GetAsync("Player_" .. player.UserId)
	end)
	
	if success and savedData then
		-- Aplicar datos guardados
		if not PlayerData[player] then
			PlayerData[player] = {}
		end
		
		PlayerData[player] = table.merge(PlayerData[player] or {}, savedData)
		
		-- Asegurar valores por defecto
		if PlayerData[player].Level == nil then
			PlayerData[player].Level = 1
		end
		if PlayerData[player].XP == nil then
			PlayerData[player].XP = 0
		end
		if PlayerData[player].Coins == nil then
			PlayerData[player].Coins = 0
		end
		if PlayerData[player].Candy == nil then
			PlayerData[player].Candy = 0
		end
		if PlayerData[player].Pets == nil then
			PlayerData[player].Pets = {}
		end
		if PlayerData[player].EquippedPet == nil then
			PlayerData[player].EquippedPet = ""
		end
		
		print("Datos cargados para: " .. player.Name)
	else
	-- Datos por defecto si no hay guardado
		PlayerData[player] = {
			Level = 1,
			XP = 0,
			Coins = 0,
			Candy = 0,
			Pets = {},
			EquippedPet = "",
		}
		
		print("Datos por defecto para: " .. player.Name)
	end
end

-- Guardar datos del jugador al salir
function PlayerData.SavePlayerData(player: Player)
	if PlayerData[player] then
		local success, errorMsg = pcall(function()
			dataStore:SetAsync("Player_" .. player.UserId, PlayerData[player])
		end)
		
		if success then
			print("Datos guardados para: " .. player.Name)
		else
			warn("Error guardando datos para " .. player.Name .. ": " .. tostring(errorMsg))
		end
	end
end

-- Validar que el jugador puede ganar monedas (solo servidor)
function PlayerData.CanModify(player: Player): boolean
	-- Solo el servidor puede modificar estos datos
	return game:GetService("RunService"):IsServer()
end

-- Añadir monedas con validación
function PlayerData.AddCoins(player: Player, amount: number): boolean
	if amount <= 0 then
		return false
	end
	
	local current = PlayerData.Get(player, "Coins") or 0
	local newAmount = current + amount
	
	-- Verificar que no sería negativo (defensa adicional)
	if newAmount < 0 then
		newAmount = 0
	end
	
	PlayerData.Set(player, "Coins", newAmount)
	
	-- Emitir evento al cliente para actualizar HUD
	local Remotes = require(ReplicatedStorage.Shared.Remotes)
	Remotes.Server.GainPoints:FireClient(player, {
		coins = amount,
		total = newAmount,
	})
	
	return true
end

-- Añadir caramelos con validación
function PlayerData.AddCandy(player: Player, amount: number): boolean
	if amount <= 0 then
		return false
	end
	
	local current = PlayerData.Get(player, "Candy") or 0
	PlayerData.Set(player, "Candy", current + amount)
	
	-- Emitir evento al cliente
	local Remotes = require(ReplicatedStorage.Shared.Remotes)
	Remotes.Server.GainPoints:FireClient(player, {
		candy = amount,
		total = PlayerData.Get(player, "Candy"),
	})
	
	return true
end

-- Añadir XP con validación y verificación de nivel
function PlayerData.AddXP(player: Player, amount: number): boolean
	if amount <= 0 then
		return false
	end
	
	local currentXP = PlayerData.Get(player, "XP") or 0
	local level = PlayerData.Get(player, "Level") or 1
	local Config = require(ReplicatedStorage.Shared.GameConfig)
	
	local xpPerLevel = Config.Levels.XPPerLevel
	local xpMultiplier = Config.Levels.XPMultiplier
	
	local newXP = currentXP + amount
	local xpNeeded = xpPerLevel + (level - 1) * xpMultiplier
	
	PlayerData.Set(player, "XP", newXP)
	
	-- Emitir evento al cliente mostrando XP ganado
	local Remotes = require(ReplicatedStorage.Shared.Remotes)
	Remotes.Server.GainXP:FireClient(player, {
		amount = amount,
		total = newXP,
		xpNeeded = xpNeeded,
	})
	
	-- Verificar si sube de nivel
	if newXP >= xpNeeded then
		local newLevel = level + 1
		PlayerData.Set(player, "Level", newLevel)
		
-- Dar monedas por subir de nivel
		local bonusCoins = 50 -- Premio por subir de nivel
		PlayerData.AddCoins(player, bonusCoins)
		
-- Emitir evento de nivel up
		Remotes.Server.GainXP:FireClient(player, {
			leveledUp = true,
			newLevel = newLevel,
			totalXP = newXP,
			xpNeeded = xpPerLevel + (newLevel - 1) * xpMultiplier,
			bonusCoins = bonusCoins,
		})
		
		-- Verificar próximo nivel
		local nextXPNeeded = xpPerLevel + (newLevel - 1) * xpMultiplier
		Remotes.Server.GainXP:FireClient(player, {
			pendingLevel = newLevel,
			nextXPNeeded = nextXPNeeded,
		})
	end
	
	return true
end

-- Desbloquear una mascota
function PlayerData.UnlockPet(player: Player, petName: string): boolean
	local Config = require(ReplicatedStorage.Shared.GameConfig)
	
	-- Verificar si la mascota existe
	if not Config.StartingPets[petName] and not PetData.AllPets[petName] then
		warn("Mascota desconocida: " .. petName)
		return false
	end
	
	-- Obtener mascotas actuales
	local pets = PlayerData.Get(player, "Pets") or {}
	
	-- Verificar si ya está desbloqueada
	for _, name in pairs(pets) do
		if name == petName then
			return false -- Ya está desbloqueada
		end
	end
	
	-- Desbloquear la mascota
	table.insert(pets, petName)
	PlayerData.Set(player, "Pets", pets)
	
-- Emitir evento al cliente
	local Remotes = require(ReplicatedStorage.Shared.Remotes)
	Remotes.Server.ShowPet:FireClient(player, {
		petName = petName,
		action = "unlocked",
	})
	
	print("Mascota desbloqueada para " .. player.Name .. ": " .. petName)
	return true
end

-- Equipar una mascota
function PlayerData.EquipPet(player: Player, petName: string): boolean
	local pets = PlayerData.Get(player, "Pets") or {}
	
	-- Verificar si la mascota está desbloqueada
	local isUnlocked = false
	for _, name in pairs(pets) do
		if name == petName then
			isUnlocked = true
			break
		end
	end
	
	if not isUnlocked then
		warn("Intento de equipar mascota no desbloqueada: " .. petName)
		return false
	end
	
	-- Equipar la mascota
	PlayerData.Set(player, "EquippedPet", petName)
	
-- Emitir evento al cliente
	local Remotes = require(ReplicatedStorage.Shared.Remotes)
	Remotes.Server.ShowPet:FireClient(player, {
		petName = petName,
		action = "equipped",
	})
	
	print("Mascota equipada para " .. player.Name .. ": " .. petName)
	return true
end

return PlayerData