-- CollectController.client.luau
-- Controlador para efectos visuales al recolectar objetos
-- Ubicación: StarterPlayer/StarterPlayerScripts/Controllers/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Collect = {}

-- Referencias
local Remotes = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Remotes")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Crear contenedor para efectos temporales
local EffectsContainer = Instance.new("Folder")
EffectsContainer.Name = "PetRushEffects"
EffectsContainer.Parent = Workspace

-- Función para crear número flotante
function Collect.ShowFloatText(position, text, color, duration)
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 120, 0, 40)
	billboard.StudsPerPixel = 100
	billboard.Adornee = EffectsContainer
	billboard.AlwaysOnTop = true
	billboard.Parent = Workspace
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 16
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = billboard
	
-- Animación de flotación
	local startTime = tick()
	local goalPosition = billboard.Position + UDim2.new(0, 0, -0.1, 0)
	
	task.spawn(function()
		while billboard.Parent and tick() - startTime < (duration or 2) do
			local progress = (tick() - startTime) / (duration or 2)
			local easeProgress = 1 - (1 - progress) ^ 3 -- Ease out cubic
			
			-- Mover hacia arriba y fade out
			billboard.Position = UDim2.new(0, 0, 0, -10 * easeProgress)
			textLabel.TextTransparency = progress
			textLabel.Size = UDim2.new(1 - progress * 0.2, 0, 1 - progress * 0.2, 0)
			
			task.wait(0.016)
		end
		
		if billboard then
			billboard:Destroy()
		end
	end)
	
	return billboard
end

-- Función para reproducir sonido de recolección
function Collect.PlayPickupSound(position)
	local sound = Instance.new("Sound")
	sound.Name = "PickupSound"
	sound.SoundId = "rbxassetid://183992972" -- Som Pop básico
	sound.Position = position
	sound.Volume = 0.5
	sound.Parent = Workspace
	sound:Play()
	
-- Auto-destruir después
	game:GetService("Debris"):AddItem(sound, 2)
end

-- Función para crear partículas simples
function Collect.CreateParticles(position, color)
	local particle = Instance.new("ParticleEmitter")
	particle.Name = "PickupParticles"
	particle.Texture = "rbxassetid://231642014" -- Partícula pequeña
	particle.Color = ColorSequence.new(color or Color3.fromRGB(255, 255, 0))
	particle.LightEmission = 0.5
	particle.Size = NumberSequence.new(0.5, 1.5)
	particle.Speed = NumberRange.new(2, 5)
	particle.Rate = 20
	particle.Lifetime = NumberRange.new(0.5, 1)
	particle.Parent = EffectsContainer
	
-- Posicionar en la posición
	local attachment = Instance.new("Attachment")
	attachment.Position = position
	attachment.Parent = Workspace
	particle.Parent = attachment
	
-- Limpiar después
	task.delay(1, function()
		if particle then particle:Destroy() end
		if attachment then attachment:Destroy() end
	end)
end

-- Función para mostrar confeti al subir de nivel (llamado desde Feedback)
function Collect.ShowConfetti()
	local confettiPart = Instance.new("Frame")
	confettiPart.Name = "Confetti"
	confettiPart.Size = UDim2.new(0, 50, 0, 20)
	confettiPart.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
	confettiPart.Position = UDim2.new(math.random(), 0, math.random(), 0)
	confettiPart.Parent = PlayerGui
	
	-- Rotar y mover
	game:GetService("TweenService"):Create(confettiPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {
		Rotation = 360,
		Position = UDim2.new(math.random(), 0, math.random(), 0)
	}):Play()
	
	game:GetService("Debris"):AddItem(confettiPart, 3)
end

return Collect