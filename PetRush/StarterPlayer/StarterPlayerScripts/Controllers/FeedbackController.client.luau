-- FeedbackController.client.luau
-- Efectos visuales y de sonido para Pet Rush!
-- Números flotantes, sonidos, partículas, confeti, mensajes

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local Feedback = {}

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Remotes")

-- Contenedor para efectos
local Effects = Instance.new("Folder")
Effects.Name = "PetRushFeedbackEffects"
Effects.Parent = Workspace

-- Números flotantes al recoger
function Feedback.ShowGain(rewardData)
-- Crear parte flotante
	local floatPart = Instance.new("Part")
	floatPart.Size = Vector3.new(1, 1, 1)
	floatPart.Transparency = 1
	floatPart.CanCollide = false
	floatPart.Anchored = true
	
-- Posicionar sobre el personaje
	local character = Player.Character or Player.CharacterAdded:Wait()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
		floatPart.CFrame = hrp.CFrame * CFrame.new(0, 2, 0)
	end
	floatPart.Parent = Workspace
	
-- Crear GUI para el texto
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.new(0, 150, 0, 50)
	gui.StudsPerPixel = 100
	gui.Adornee = floatPart
	gui.Parent = floatPart
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	
-- Determinar qué texto mostrar basándose en los datos
	local displayText = ""
	local color = Color3.new(1, 1, 1)
	
	if rewardData.candy then
		displayText = "+" .. rewardData.candy .. " 🍬"
		color = Color3.fromRGB(255, 100, 100)
	elseif rewardData.coins then
		displayText = "+" .. rewardData.coins .. " 💰"
		color = Color3.fromRGB(255, 215, 0)
	end
	
	if rewardData.total then
		displayText = displayText .. " (Total: " .. rewardData.total .. ")"
	end
	
	textLabel.Text = displayText
	textLabel.TextColor3 = color
	textLabel.TextSize = 14
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = gui
	
-- Animación: subir y fade out
	game:GetService("TweenService"):Create(gui, TweenInfo.new(2, Enum.EasingStyle.Quad), {
		Position = gui.Position + UDim2.new(0, 0, -0.5, 0),
		Opacity = 0
	}):Play()
	
-- Limpiar después de 2.5 segundos
	task.delay(2.5, function()
		if floatPart and floatPart.Parent then
			floatPart:Destroy()
		end
	end)
end

-- Sonido "pop" básico
function Feedback.PlayPopSound()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://183992972" -- Sound ID de pop
	sound.Volume = 0.8
	sound.Parent = Workspace
	sound:Play()
	
	game:GetService("Debris"):AddItem(sound, 1)
end

-- Partículas al recoger
function Feedback.CreateParticles(position)
	local particle = Instance.new("ParticleEmitter")
	particle.Texture = "rbxassetid://231642014"
	particle.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 100, 100))
	particle.LightEmission = 0.5
	particle.Size = NumberSequence.new(1, 2)
	particle.Speed = NumberRange.new(3, 6)
	particle.Rate = 25
	particle.Lifetime = NumberRange.new(0.8, 1.2)
	particle.VelocitySpread = 180
	particle.Position = position
	particle.Parent = Effects
	
-- Limpiar después
	task.delay(1.5, function()
		if particle then particle:Destroy() end
	end)
end

-- Confeti al subir de nivel
function Feedback.ShowLevelUp(levelData)
-- Número flotante grande
	Feedback.ShowGain({
		candy = 0,
		coins = 0,
		total = levelData.totalXP or 0,
	})-- Confeti visual
	Feedback.ShowConfetti()
	
-- Sonido de celebración
	Feedback.PlayPopSound()
	
-- Mostrar mensaje de nivel up
	local playerGui = Player:WaitForChild("PlayerGui")
	local message = Instance.new("TextLabel")
	message.Name = "LevelUpMessage"
	message.Size = UDim2.new(0, 300, 0, 50)
	message.Position = UDim2.new(0.5, -150, 0.5, -25)
message.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
message.BackgroundTransparency = 0.5
message.Text = "¡NIVEL " .. tostring(levelData.newLevel) .. "! +50 💰"
message.TextColor3 = Color3.fromRGB(255, 215, 0)
message.TextSize = 18
message.Font = Enum.Font.GothamBold
message.Parent = playerGui
message.Parent = playerGui
	
-- Animación de entrada y salida
	game:GetService("TweenService"):Create(message, TweenInfo.new(1, Enum.EasingStyle.Quad), {
		Position = UDim2.new(0.5, -150, 0.4, -25),
		BackgroundTransparency = 1,
		TextTransparency = 0
	}):Play()
	
	task.delay(3, function()
		if message and message.Parent then
			message:Destroy()
		end
	end)
end

-- Confeti visual
function Feedback.ShowConfetti()
	for i = 1, 20 do
		task.spawn(function()
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(math.random(0.5, 1.5), 0, math.random(0.5, 1.5), 0)
			frame.Position = UDim2.new(math.random(), 0, math.random(), 0)
			frame.BackgroundColor3 = Color3.fromRGB(
				math.random(200, 255),
				math.random(50, 200),
				math.random(200, 255)
			)
			frame.Rotation = math.random(-360, 360)
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Parent = PlayerGui
			
			game:GetService("TweenService"):Create(frame, TweenInfo.new(3, Enum.EasingStyle.Linear), {
				Rotation = frame.Rotation + 360,
				Position = UDim2.new(math.random(), 0, math.random(), 0),
				BackgroundTransparency = 1
			}):Play()
			
			task.delay(3, function()
				if frame and frame.Parent then
					frame:Destroy()
				end
			end)
		end)
	end
end

-- Mensaje al desbloquear mascota
function Feedback.ShowPetAction(actionData)
	local messageType = actionData.action or "message"
	
	local messages = {
		unlocked = "¡Mascota desbloqueada: " .. (actionData.petName or "Mascota") .. "!",
		equipped = "Mascota equipada: " .. (actionData.petName or "Mascota"),
		purchased = "¡Cosmético comprado!"
	}
	
	local msg = Instance.new("TextLabel")
	msg.Name = "PetActionMessage"
	msg.Size = UDim2.new(0, 250, 0, 40)
	msg.Position = UDim2.new(0.5, -125, 0.8, 0)
	msg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
	msg.BackgroundTransparency = 0.5
	msg.Text = messages[messageType] or "Acción completada"
	msg.TextColor3 = Color3.fromRGB(255, 255, 255)
	msg.TextSize = 14
	msg.Font = Enum.Font.GothamBold
	msg.Parent = PlayerGui
	
-- Animación
	game:GetService("TweenService"):Create(msg, TweenInfo.new(1, Enum.EasingStyle.Quad), {
		Position = UDim2.new(0.5, -125, 0.7, 0),
		BackgroundTransparency = 1,
		TextTransparency = 0
	}):Play()
	
	task.delay(2, function()
		if msg and msg.Parent then
			msg:Destroy()
		end
	end)
end

-- Mensaje al desbloquear zona
function Feedback.ShowZoneUnlock(zoneData)
	local message = Instance.new("TextLabel")
	message.Name = "ZoneUnlockMessage"
	message.Size = UDim2.new(0, 280, 0, 45)
	message.Position = UDim2.new(0.5, -140, 0.7, 0)
	message.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
	message.BackgroundTransparency = 0.5
	message.Text = "¡Zona desbloqueada: " .. (zoneData.zoneName or "Zona") .. "!"
	message.TextColor3 = Color3.fromRGB(255, 105, 180)
	message.TextSize = 14
	message.Font = Enum.Font.GothamBold
	message.Parent = PlayerGui
	
-- Animación
	game:GetService("TweenService"):Create(message, TweenInfo.new(1, Enum.EasingStyle.Quad), {
		Position = UDim2.new(0.5, -140, 0.6, 0),
		BackgroundTransparency = 1,
		TextTransparency = 0
	}):Play()
	
	task.delay(2.5, function()
		if message and message.Parent then
			message:Destroy()
		end
	end)
end

-- Inicializar conexiones remotas
function Feedback.Init()
-- Conectar eventos del cliente para efectos
	local remotes = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Remotes")
	
-- Escuchar ganancias desde el servidor
	remotes.Client.GainPoints.OnClientEvent:Connect(function(data)
		Feedback.ShowGain(data)
		Feedback.PlayPopSound()
	end)
	
-- Escuchar nivel up
	remotes.Client.GainXP.OnClientEvent:Connect(function(data)
		Feedback.ShowLevelUp(data)
	end)
	
-- Escuchar desbloqueo de mascota
	remotes.Client.ShowPet.OnClientEvent:Connect(function(data)
		Feedback.ShowPetAction(data)
	end)
	
-- Escuchar desbloqueo de zona
	remotes.Client.UnlockZone.OnClientEvent:Connect(function(data)
		Feedback.ShowZoneUnlock(data)
	end)
end

-- Inicializar al cargar
task.wait(0.5)
Feedback.Init()

return Feedback