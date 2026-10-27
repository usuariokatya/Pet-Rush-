-- ClientMain.client.luau
-- Script principal del cliente que inicializa todos los controladores
-- Ubicación: StarterPlayer/StarterPlayerScripts/PetRushClient/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Client = {}

-- Referencias a módulos
local PetRushFolder = ReplicatedStorage:WaitForChild("PetRush")
local Remotes = PetRushFolder:WaitForChild("Remotes")
local GameConfig = PetRushFolder:WaitForChild("Shared"):WaitForChild("GameConfig")
local PlayerData = PetRushFolder:WaitForChild("Shared"):WaitForChild("PetData")
local Rewards = PetRushFolder:WaitForChild("Shared"):WaitForChild("Rewards")
local HUDController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.HUDController)
local CollectController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.CollectController)
local PetFollowController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.PetFollowController)
local ShopController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.ShopController)
local FeedbackController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FeedbackController)

-- Variable para tracking del combo local
local currentCombo = 0
local lastCollectTime = 0

-- Función cuando el jugador se une
function Client.OnPlayerAdded(player)
	-- Cargar datos del jugador
	PlayerData.LoadPlayerData(player)

	-- Configurar HUD
	HUDController.CreateHUD()

	-- Actualizar HUD con datos iniciales
	HUDController.UpdateStats(player)

	-- Conectar eventos remotos
	-- Evento de recolección
	Remotes.Client.OnCollect.OnClientEvent:Connect(function(rewardData)
		-- Efectos visuales y de sonido
		FeedbackController.ShowGain(rewardData)

		-- Actualizar combo
		local currentTime = tick()
		local timeSinceLast = currentTime - lastCollectTime

		if currentTime - lastCollectTime < GameConfig.Combo.TimeBeforeDecay then
			currentCombo = math.min(currentCombo + 1, GameConfig.Combo.MaxMultiplier)
		else
			currentCombo = 1
		end
		lastCollectTime = currentTime

		-- Calcular multiplier de combo
		local comboMultiplier = currentCombo / GameConfig.Combo.MaxMultiplier
		comboMultiplier = 1 + (comboMultiplier - 1) * 0.5 -- Escalado suave

		-- Actualizar HUD con combo
		HUDController.UpdateCombo(currentCombo, comboMultiplier)
	end)

	-- Evento de ganancia de XP
	Remotes.Client.GainXP.OnClientEvent:Connect(function(data)
		FeedbackController.ShowLevelUp(data)
	end)

	-- Evento de ganancia de puntos
	Remotes.Client.GainPoints.OnClientEvent:Connect(function(data)
		-- Actualizar estadísticas en HUD
		if data.coins then
			HUDController.UpdateCoins(data.total or data.coins)
		end
		if data.candy then
			HUDController.UpdateCandy(data.total or data.candy)
		end
	end)

	-- Evento de mascota desbloqueada
	Remotes.Client.ShowPet.OnClientEvent:Connect(function(data)
		FeedbackController.ShowPetAction(data)
	end)

	-- Evento de zona desbloqueada
	Remotes.Client.UnlockZone.OnClientEvent:Connect(function(data)
		FeedbackController.ShowZoneUnlock(data)
	end)

	print("ClientMain inicializado para: " .. player.Name)
end

-- Conectar cuándo un jugador se une
Players.PlayerAdded:Connect(Client.OnPlayerAdded)

-- Manejar el jugador actual si ya se unió
local localPlayer = Players.LocalPlayer
if localPlayer then
	Client.OnPlayerAdded(localPlayer)
end

-- Bucle de actualización del HUD (FPS counter opcional, etc.)
task.spawn(function()
	while true do
		task.wait(1)
	end
end)

return Client
