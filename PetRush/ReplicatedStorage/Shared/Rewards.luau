-- Rewards.luau
-- Módulo para manejar recompensas y efectos al recoger objetos
-- Disponible en ReplicatedStorage/Shared

type RewardData = {
	Candy: number,
	Coins: number,
	XP: number,
	ComboMultiplier: number,
}

local Rewards = {}

-- Dar recompensas al jugador desde el servidor
function Rewards.GiveRewards(player: Player, reward: RewardData)
	-- Validar que el jugador existe
	if not player or not player:IsA("Player") then
		warn("Jugador inválido en Rewards.GiveRewards")
		return
	end
	
	-- Acceder a los datos del jugador (a través de módulo)
	local PlayerData = require(game.ServerScriptService:WaitForChild("Systems").PlayerData)
	
	-- Actualizar caramelos
	local currentCandy = PlayerData.Get(player, "Candy") or 0
	PlayerData.Set(player, "Candy", currentCandy + reward.Candy)
	
	-- Actualizar monedas
	local currentCoins = PlayerData.Get(player, "Coins") or 0
	PlayerData.Set(player, "Coins", currentCoins + reward.Coins)
	
	-- Actualizar XP
	local currentXP = PlayerData.Get(player, "XP") or 0
	local xpToAdd = reward.XP
	currentXP = currentXP + xpToAdd
	PlayerData.Set(player, "XP", currentXP)
	
	-- Verificar subida de nivel
	local Config = require(game.ReplicatedStorage.Shared.GameConfig)
	local level = PlayerData.Get(player, "Level") or 1
	local xpNeeded = Config.Levels.XPPerLevel + (level - 1) * Config.Levels.XPMultiplier
	
	if currentXP >= xpToAdd then
		local newLevel = level + 1
		PlayerData.Set(player, "Level", newLevel)
		
	-- Emitir evento al cliente para mostrar animación de nivel
		game.ReplicatedStorage.Remotes.GainXP:FireClient(player, {
			newLevel = PlayerData.Get(player, "Level"),
			totalXP = currentXP,
			xpNeeded = xpNeeded,
		})
	end
	
	-- Emitir puntos ganados
	game.ReplicatedStorage.Remotes.GainPoints:FireClient(player, {
		candy = reward.Candy,
		coins = reward.Coins,
	})
	
	-- Mostrar combo si es aplicable
	if reward.ComboMultiplier and reward.ComboMultiplier > 1 then
		game.ReplicatedStorage.Remotes.ShowCombo:FireClient(player, {
			 multiplier = reward.ComboMultiplier,
			duration = 3,
		})
	end
	
	return true
end

-- Calcular recompensas basadas en combo y zona
function Rewards.CalculateReward(baseReward: {Candy: number, Coins: number, XP: number}, 
    comboLevel: number, zoneName: string?)
	local Config = require(game.ReplicatedStorage.Shared.GameConfig)
	
	local multiplier = 1.0
	
	-- Aplicar multiplicador de combo
	if comboLevel and comboLevel > 1 then
		multiplier = multiplier + (math.min(comboLevel, Config.Combo.MaxMultiplier) - 1) * 0.5
	end
	
	-- Aplicar multiplicador de zona
	if zoneName then
		local zoneConfig = Config.Zones[zoneName]
		if zoneConfig then
			multiplier = multiplier * zoneConfig.Multiplier
		end
	end
	
	return {
		Candy = math.floor(baseReward.Candy * multiplier),
		Coins = math.floor(baseReward.Coins * multiplier),
		XP = math.floor(baseReward.XP * multiplier),
		ComboMultiplier = multiplier,
	}
end

return Rewards