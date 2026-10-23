-- Levels.server.luau
-- Módulo para manejar el sistema de niveles y progreso
-- Ejecutarse en ServerScriptService/Systems

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Config = require(ReplicatedStorage.Shared.GameConfig)
local PlayerData = require(script.Parent.Parent.Parent.Parent .. ".PlayerData")

local Levels = {}

-- Obtener el XP necesario para un nivel específico
function Levels.GetXPNeeded(level: number): number
	local Config = require(ReplicatedStorage.Shared.GameConfig)
	local xpPerLevel = Config.Levels.XPPerLevel
	local xpMultiplier = Config.Levels.XPMultiplier
	
	return xpPerLevel + (level - 1) * xpMultiplier
end

-- Obtener el nivel actual basado en XP
function Levels.GetLevelFromXP(xp: number): number
	local level = 1
	local totalXP = 0
	
	while true do
		local needed = Levels.GetXPNeeded(level)
		if totalXP + needed > xp then
			return level
		end
		totalXP = totalXP + needed
		level = level + 1
		
		-- Evitar bucle infinito en niveles muy altos
		if level > 1000 then
			return level
		end
	end
end

-- Añadir XP al jugador y verificar nivel
function Levels.AddXP(player: Player, amount: number): {leveledUp: boolean, newLevel: number, totalXP: number, xpNeeded: number}
	local data = require(game.ServerScriptService.Systems.PlayerData)
	local currentXP = data.Get(player, "XP") or 0
	local currentLevel = data.Get(player, "Level") or 1
	
	local newXP = currentXP + amount
	local xpNeeded = Levels.GetXPNeeded(currentLevel)
	local leveledUp = false
	local newLevel = currentLevel
	
-- Bucle para verificar múltiples subidas de nivel
	while newXP >= xpNeeded do
		newXP = newXP - xpNeeded
		newLevel = newLevel + 1
		leveledUp = true
		
	-- Dar bonificación por subir de nivel
		local bonusCoins = 50
		PlayerData.AddCoins(player, bonusCoins)
		
	-- Actualizar XP (puede ser menor que el necesario después de restar)
		xpNeeded = Levels.GetXPNeeded(newLevel)
	end
	
-- Actualizar los datos del jugador
	data.Set(player, "XP", newXP)
	data.Set(player, "Level", newLevel)
	
-- Devolver información
	return {
		leveledUp = leveledUp,
		newLevel = newLevel,
		totalXP = newXP,
		xpNeeded = xpNeeded,
		bonusCoins = leveledUp and 50 or 0,
	}
end

-- Verificar si el jugador puede acceder a una zona
function Levels.CanAccessZone(player: Player, zoneName: string): boolean
	local Config = require(ReplicatedStorage.Shared.GameConfig)
	local zoneConfig = Config.Zones[zoneName]
	
	if not zoneConfig then
		return false
	end
	
	local playerLevel = data.Get(player, "Level") or 1
	
	return playerLevel >= zoneConfig.RequiredLevel
end

-- Verificar si el jugador tiene suficientes monedas para algo
function Levels.HasEnoughCoins(player: Player, amount: number): boolean
	local data = require(game.ServerScriptService.Systems.PlayerData)
	local coins = data.Get(player, "Coins") or 0
	return coins >= amount
return Levels