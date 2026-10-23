-- Zones.server.luau
-- Módulo para manejar zonas con diferentes recompensas y requisitos
-- Ejecutarse en ServerScriptService/Systems

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Config = require(ReplicatedStorage.Shared.GameConfig)
local Levels = require(script.Parent.Parent.Parent.Parent .. ".Levels")

local Zones = {}

-- Configuración de zonas (definida en GameConfig.luau)
-- Zonas disponibles: Pradera, Bosque Dulce, Cueva Arcoíris

-- Verificar si una zona está desbloqueada para el jugador
function Zones.IsZoneUnlocked(player: Player, zoneName: string): boolean
	local Config = require(ReplicatedStorage.Shared.GameConfig)
	local zoneConfig = Config.Zones[zoneName]
	
	if not zoneConfig then
		return false
	end
	
-- Verificar requisitos de nivel
	local playerLevel = (require(game.ServerScriptService.Systems.PlayerData)).Get(player, "Level") or 1
	if playerLevel < zoneConfig.RequiredLevel then
		return false
	end
	
-- Verificar requisitos de monedas
	local playerCoins = (require(game.ServerScriptService.Systems.PlayerData)).Get(player, "Coins") or 0
	if zoneConfig.RequiredCoins > 0 and playerCoins < zoneConfig.RequiredCoins then
		return false
	end
	
	return true
end

-- Obtener el multiplicador de recompensas para una zona
function Zones.GetZoneMultiplier(zoneName: string): number
	local Config = require(ReplicatedStorage.Shared.GameConfig)
	local zoneConfig = Config.Zones[zoneName]
	
	if zoneConfig then
		return zoneConfig.Multiplier
	end
	
	return 1.0 -- Zona por defecto
end

-- Obtener todas las zonas disponibles
function Zones.GetAllZones()
	local Config = require(ReplicatedStorage.Shared.GameConfig)
	return Config.Zones
end

-- Obtener información de zona visible para HUD
function Zones.GetZoneInfo(player: Player): {zoneName: string, isUnlocked: boolean, multiplier: number}
	local zones = Zones.GetAllZones()
	local currentZone = "Pradera" -- Zona por defecto
	local isUnlocked = true
	local multiplier = 1.0
	
	for zoneName, zoneConfig in pairs(zones) do
		if Zones.IsZoneUnlocked(player, zoneName) then
			-- Esta zona está desbloqueada y tiene el mejor multiplicador
			isUnlocked = true
			multiplier = zoneConfig.Multiplier
			currentZone = zoneName
		end
	end
	
	return {
		zoneName = currentZone,
		isUnlocked = isUnlocked,
		multiplier = multiplier,
	}
end

return Zones