-- ClientMain.client.luau
-- Script principal del cliente que inicializa todos los controladores
-- Ubicación: StarterPlayer/StarterPlayerScripts/PetRushClient/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Client = {}

-- Referencias a módulos
local Remotes = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Remotes")
local GameConfig = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Shared"):WaitForChild("GameConfig")
local PlayerData = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Shared"):WaitForChild("PetData")
local Rewards = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Shared"):WaitForChild("Rewards")
local HUDController = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("HUDController")
local CollectController = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("CollectController")
local PetFollowController = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("PetFollowController")
local ShopController = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("ShopController")
local FeedbackController = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("FeedbackController")

-- Variable para tracking del combo local
local currentCombo = 0
local lastCollectTime = 0

-- Función cuando el jugador se une
function Client.OnPlayerAdded(player)
	-- Cargar datos del jugador
	PlayerData.LoadPlayerData(player)
	
-- Configurar HUD
	HUDController.CreateHUD(player)
	
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
		HUDController.UpdateStats(player)
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

-- Dar datos iniciales al cliente para el HUD
-- Esto se maneja en el servidor, pero podemos configurar listeners aquí

-- Bucle de actualización del HUD (FPS counter opcional, etc.)
task.spawn(function()
	while true do
		task.wait(1)
	-- Actualizar temporizadores, etc.
	end
end)

return Client