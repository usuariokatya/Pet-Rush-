-- Shop.server.luau
-- Módulo para manejar la tienda del juego (mejoras con monedas del juego)
-- Ejecutarse en ServerScriptService/Systems

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Config = require(ReplicatedStorage.Shared.GameConfig)
local PlayerData = require(script.Parent.Parent.Parent.Parent .. ".PlayerData") -- Referencia compleja

local Shop = {}

-- Definir artículos disponibles en la tienda
Shop.Items = {
	-- Mejoras de velocidad
	SpeedUpgrade = {
		Name = "Mejorar Velocidad",
		Type = "Upgrade",
		Category = "Movement",
		Price = Config.Upgrades.Speed,
		RequiredLevel = 1,
		Description = "Aumenta la velocidad de movimiento",
	},
	
	-- Mejora de alcance de recogida
	RadiusUpgrade = {
		Name = "Ampliar Alcance",
		Type = "Upgrade",
		Category = "Collection",
		Price = Config.Upgrades.Radius,
		RequiredLevel = 1,
		Description = "Aumenta el alcance para recoger objetos",
	},
	
	-- Multiplicador de caramelos
	CandyMultiplier = {
		Name = "Multiplicador de Caramelos",
		Type = "Upgrade",
		Category = "Resources",
		Price = Config.Upgrades.CandyMultiplier,
		RequiredLevel = 1,
		Description = "Multiplica las recompensas de caramelos",
	},
	
	-- Color de mascota 1
	PetColor1 = {
		Name = "Color: Azul Neon",
		Type = "Cosmetic",
		Category = "Pets",
		Price = 300,
		RequiredLevel = 3,
		Description = "Cambia el color de tu mascota",
	},
	
	-- Color de mascota 2
	PetColor2 = {
		Name = "Color: Rosa Neon",
		Type = "Cosmetic",
		Category = "Pets",
		Price = 300,
		RequiredLevel = 5,
		Description = "Cambia el color de tu mascota a rosa",
	},
}

-- Verificar si el jugador puede comprar un artículo
function Shop.CanPurchase(player: Player, itemName: string): {canPurchase: boolean, reason: string}
	local item = Shop.Items[itemName]
	if not item then
		return {canPurchase = false, reason = "Artículo no encontrado"}
	end
	
-- Obtener datos del jugador
	local data = require(game.ServerScriptService.Systems.PlayerData)
	
-- Verificar nivel requerido
	local playerLevel = data.Get(player, "Level") or 1
	if playerLevel < item.RequiredLevel then
		return {canPurchase = false, reason = "Nivel requerido: " .. item.RequiredLevel}
	end
	
-- Verificar monedas suficientes
	local playerCoins = data.Get(player, "Coins") or 0
	if playerCoins < item.Price then
		return {canPurchase = false, reason = "Monedas insuficientes. Necesitas " .. item.Price}
	end
	
	return {canPurchase = true, reason = "Compra válida"}
end

-- Realizar una compra
function Shop.PurchaseItem(player: Player, itemName: string): boolean
	local purchaseResult = Shop.CanPurchase(player, itemName)
	
	if not purchaseResult.canPurchase then
		warn("Compra fallida para " .. player.Name .. ": " .. purchaseResult.reason)
		return false
	end
	
	local item = Shop.Items[itemName]
	
-- Descontar monedas
	local success = PlayerData.AddCoins(player, -item.Price)
	if not success then
		error("No se pudieron descontar las monedas")
		return false
	end
	
-- Aplicar efecto según tipo de artículo
	if item.Type == "Upgrade" then
		Shop.ApplyUpgrade(player, itemName, item)
	elseif item.Type == "Cosmetic" then
		-- Para cosméticos, notificar al cliente
		local Remotes = require(ReplicatedStorage.Shared.Remotes)
		Remotes.Server.ShowPet:FireClient(player, {
			petName = itemName,
			action = "purchased",
		})
	end
	
	print("Compra realizada por " .. player.Name .. ": " .. itemName)
	return true
end

-- Aplicar una mejora
function Shop.ApplyUpgrade(player: Player, itemName: string, item: table)
	local data = require(game.ServerScriptService.Systems.PlayerData)
	local playerLevel = data.Get(player, "Level") or 1
	
	if itemName == "SpeedUpgrade" then
	-- Registrar que el jugador tiene la mejora (podríamos guardar en datos)
		local currentSpeed = data.Get(player, "SpeedUpgradeLevel") or 0
		data.Set(player, "SpeedUpgradeLevel", currentSpeed + 1)
		
	-- Efecto inmediato: aumentar velocidad de caminata
		local character = player.Character
		if character then
			local hrp = character:FindFirstChild("HumanoidRootPart")
			local hum = character:FindFirstChild("Humanoid")
			if hum then
				-- Podemos modificar la velocidad base o dar un boost
				hum.WalkSpeed = hum.WalkSpeed + 10 -- +10 por nivel de mejora
			end
		end
		
		local Remotes = require(ReplicatedStorage.Shared.Remotes)
		Remotes.Server.ShowPet:FireClient(player, {
			action = "upgradeApplied",
			upgrade = "speed",
			newValue = hum.WalkSpeed,
		})
		
	elseif itemName == "RadiusUpgrade" then
		local currentRadius = data.Get(player, "CollectionRadius") or 5
		data.Set(player, "CollectionRadius", currentRadius + 5)
		
	-- Emitir evento de mejora desbloqueada
		local Remotes = require(ReplicatedStorage.Shared.Remotes)
		Remotes.Server.ShowCombo:FireClient(player, {
			action = "upgradeUnlocked",
			upgrade = "collection_radius",
		})
		
	elseif itemName == "CandyMultiplier" then
		local currentMultiplier = data.Get(player, "CandyMultiplierLevel") or 1
		data.Set(player, "CandyMultiplierLevel", currentMultiplier + 1)
	end
	
	print("Mejora aplicada por " .. player.Name .. ": " .. itemName)
	return true
end

return Shop