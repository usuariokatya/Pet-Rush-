-- HUDController.client.luau
-- Controlador de la interfaz de usuario para Pet Rush!
-- Muestra monedas, caramelos, nivel, XP, combo y mascota

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local HUD = {}
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local HUDGui = nil
local MainFrame = nil
local CoinsLabel = nil
local CandyLabel = nil
local LevelLabel = nil
local XPBarFill = nil
local ComboText = nil

-- Función para crear la UI
function HUD.CreateHUD()
	HUDGui = Instance.new("ScreenGui")
	HUDGui.Name = "PetRushHUD"
	HUDGui.Parent = PlayerGui
	HUDGui.IgnoreGuiInset = true
	HUDGui.ResetOnSpawn = false

	MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainHUD"
	MainFrame.Size = UDim2.new(0, 350, 0, 80)
	MainFrame.Position = UDim2.new(0, 10, 0, 10)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	MainFrame.BackgroundTransparency = 0.5
	MainFrame.BorderSizePixel = 0

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = MainFrame
	MainFrame.Parent = HUDGui

	-- Título
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, 0, 0, 25)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = "PET RUSH!"
	TitleLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
	TitleLabel.TextSize = 18
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Parent = MainFrame

	-- Monedas
	local CoinsFrame = Instance.new("Frame")
	CoinsFrame.Name = "CoinsSection"
	CoinsFrame.Size = UDim2.new(0, 80, 0, 50)
	CoinsFrame.Position = UDim2.new(0, 10, 0, 30)
	CoinsFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
	CoinsFrame.BackgroundTransparency = 0.2
	UICorner:Clone().Parent = CoinsFrame
	CoinsFrame.Parent = MainFrame

	CoinsLabel = Instance.new("TextLabel")
	CoinsLabel.Name = "CoinsValue"
	CoinsLabel.Size = UDim2.new(1, -35, 1, 0)
	CoinsLabel.Position = UDim2.new(0, 35, 0, 0)
	CoinsLabel.BackgroundTransparency = 1
	CoinsLabel.Text = "0"
	CoinsLabel.TextColor3 = Color3.new(1, 1, 1)
	CoinsLabel.TextSize = 14
	CoinsLabel.Font = Enum.Font.Gotham
	CoinsLabel.Parent = CoinsFrame

	local CoinsIcon = Instance.new("TextLabel")
	CoinsIcon.Size = UDim2.new(0, 30, 0, 30)
	CoinsIcon.Position = UDim2.new(0, 5, 0, 5)
	CoinsIcon.BackgroundTransparency = 1
	CoinsIcon.Text = "💰"
	CoinsIcon.TextSize = 20
	CoinsIcon.Parent = CoinsFrame

	-- Caramelos
	local CandyFrame = Instance.new("Frame")
	CandyFrame.Name = "CandySection"
	CandyFrame.Size = UDim2.new(0, 80, 0, 50)
	CandyFrame.Position = UDim2.new(0, 100, 0, 30)
	CandyFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	CandyFrame.BackgroundTransparency = 0.2
	UICorner:Clone().Parent = CandyFrame
	CandyFrame.Parent = MainFrame

	CandyLabel = Instance.new("TextLabel")
	CandyLabel.Name = "CandyValue"
	CandyLabel.Size = UDim2.new(1, -35, 1, 0)
	CandyLabel.Position = UDim2.new(0, 35, 0, 0)
	CandyLabel.BackgroundTransparency = 1
	CandyLabel.Text = "0"
	CandyLabel.TextColor3 = Color3.new(1, 1, 1)
	CandyLabel.TextSize = 14
	CandyLabel.Font = Enum.Font.Gotham
	CandyLabel.Parent = CandyFrame

	local CandyIcon = Instance.new("TextLabel")
	CandyIcon.Size = UDim2.new(0, 30, 0, 30)
	CandyIcon.Position = UDim2.new(0, 5, 0, 5)
	CandyIcon.BackgroundTransparency = 1
	CandyIcon.Text = "🍬"
	CandyIcon.TextSize = 20
	CandyIcon.Parent = CandyFrame

	-- XP Bar
	local XPBarBackground = Instance.new("Frame")
	XPBarBackground.Name = "XPBarBackground"
	XPBarBackground.Size = UDim2.new(0, 150, 0, 10)
	XPBarBackground.Position = UDim2.new(0, 190, 0, 35)
	XPBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	XPBarBackground.Parent = MainFrame

	XPBarFill = Instance.new("Frame")
	XPBarFill.Name = "XPBarFill"
	XPBarFill.Size = UDim2.new(0, 0, 1, 0)
	XPBarFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
	XPBarFill.Parent = XPBarBackground

	-- Level
	LevelLabel = Instance.new("TextLabel")
	LevelLabel.Name = "LevelLabel"
	LevelLabel.Size = UDim2.new(0, 50, 0, 20)
	LevelLabel.Position = UDim2.new(0, 190, 0, 55)
	LevelLabel.BackgroundTransparency = 1
	LevelLabel.Text = "Nivel: 1"
	LevelLabel.TextColor3 = Color3.new(1, 1, 1)
	LevelLabel.TextSize = 12
	LevelLabel.Font = Enum.Font.Gotham
	LevelLabel.Parent = MainFrame

	-- Combo
	local ComboFrame = Instance.new("Frame")
	ComboFrame.Name = "ComboFrame"
	ComboFrame.Size = UDim2.new(0, 60, 0, 25)
	ComboFrame.Position = UDim2.new(1, -70, 0, 10)
	ComboFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
	ComboFrame.BackgroundTransparency = 0.3
	UICorner:Clone().Parent = ComboFrame
	ComboFrame.Parent = MainFrame

	ComboText = Instance.new("TextLabel")
	ComboText.Size = UDim2.new(1, 0, 1, 0)
	ComboText.BackgroundTransparency = 1
	ComboText.Text = "COMBO x1"
	ComboText.TextColor3 = Color3.new(1, 1, 1)
	ComboText.TextSize = 12
	ComboText.Font = Enum.Font.GothamBold
	ComboText.Parent = ComboFrame

	print("HUD created successfully")
end

function HUD.UpdateCoins(amount)
	if CoinsLabel then CoinsLabel.Text = tostring(amount) end
end

function HUD.UpdateCandy(amount)
	if CandyLabel then CandyLabel.Text = tostring(amount) end
end

function HUD.UpdateXP(currentXP, totalXP, level)
	if XPBarFill then
		local progress = math.clamp(currentXP / totalXP, 0, 1)
		XPBarFill.Size = UDim2.new(progress, 0, 1, 0)
	end
	HUD.UpdateLevel(level)
end

function HUD.UpdateLevel(level)
	if LevelLabel then LevelLabel.Text = "Nivel: " .. tostring(level) end
end

function HUD.UpdateCombo(comboLevel, multiplier)
	if ComboText then
		ComboText.Text = "COMBO x" .. tostring(math.floor(multiplier))
	end
end

-- Integración con datos del servidor
function HUD.UpdateStats(player)
	-- En un sistema real, pediríamos los datos al servidor.
	-- Aquí simulamos la actualización inicial.
	-- Nota: El servidor ya envía Remotes.GainPoints para actualizaciones en tiempo real.
end

return HUD
