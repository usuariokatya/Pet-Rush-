-- HUDController.client.luau
-- Controlador de la interfaz de usuario para Pet Rush!
-- Muestra monedas, caramelos, nivel, XP, combo y mascota

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local HUD = {}
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuración de la UI
local HUDGui = Instance.new("ScreenGui")
HUDGui.Name = "PetRushHUD"
HUGGui.Parent = PlayerGui
HUGGui.IgnoreGuiInset = true
HUGGui.ScreenInsets = Enum.ScreenInsets.None
HUGGui.ResetOnSpawn = false

-- Hacer la GUI responsive para móvil y PC
function HUD.MakeResponsive(gui)
	gui.Parent = PlayerGui
	gui.IgnoreGuiInset = true
	
	-- Ajustar al tamaño de la pantalla
	local function UpdateSize()
		local scale = math.min(1, (Workspace.CurrentCamera.ViewportSize.X / 1080), (Workspace.CurrentCamera.ViewportSize.Y / 608))
		gui.SizeConstraint = Enum.SizeConstraint.RelativeXY
		gui.Scale = scale
	end
	
	UpdateSize()
	Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateSize)
end

-- Crear el contenedor principal del HUD
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHUD"
MainFrame.Size = UDim2.new(0, 350, 0, 80)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
-- Bordes redondeados
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame
MainFrame.Parent = HUDGui

-- Título del juego
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PET RUSH!"
TitleLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Sección de monedas
local CoinsFrame = Instance.new("Frame")
CoinsFrame.Name = "CoinsSection"
CoinsFrame.Size = UDim2.new(0, 80, 0, 50)
CoinsFrame.Position = UDim2.new(0, 10, 0, 30)
CoinsFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
CoinsFrame.BackgroundTransparency = 0.2
CoinsFrame.BorderSizePixel = 0
UICorner:Clone().Parent = CoinsFrame
CoinsFrame.Parent = MainFrame

local CoinsIcon = Instance.new("TextLabel")
CoinsIcon.Size = UDim2.new(0, 30, 0, 30)
CoinsIcon.Position = UDim2.new(0, 5, 0, 5)
CoinsIcon.BackgroundTransparency = 1
CoinsIcon.Text = "💰"
CoinsIcon.TextColor3 = Color3.new(1, 1, 1)
CoinsIcon.TextSize = 20
CoinsIcon.Parent = CoinsFrame

local CoinsAmount = Instance.new("TextLabel")
CoinsAmount.Name = "CoinsValue"
CoinsAmount.Size = UDim2.new(1, -10, 1, 0)
CoinsAmount.Position = UDim2.new(0, 35, 0, 0)
CoinsAmount.BackgroundTransparency = 1
CoinsAmount.Text = "0"
CoinsAmount.TextColor3 = Color3.new(1, 1, 1)
CoinsAmount.TextSize = 14
CoinsAmount.Font = Enum.Font.Gotham
CoinsAmount.Parent = CoinsFrame

-- Sección de caramelos
local CandyFrame = Instance.new("Frame")
CandyFrame.Name = "CandySection"
CandyFrame.Size = UDim2.new(0, 80, 0, 50)
CandyFrame.Position = UDim2.new(0, 100, 0, 30)
CandyFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
CandyFrame.BackgroundTransparency = 0.2
CandyFrame.BorderSizePixel = 0
UICorner:Clone().Parent = CandyFrame
CandyFrame.Parent = MainFrame

local CandyIcon = Instance.new("TextLabel")
CandyIcon.Size = UDim2.new(0, 30, 0, 30)
CandyIcon.Position = UDim2.new(0, 5, 0, 5)
CandyIcon.BackgroundTransparency = 1
CandyIcon.Text = "🍬"
CandyIcon.TextColor3 = Color3.new(1, 1, 1)
CandyIcon.TextSize = 20
CandyIcon.Parent = CandyFrame

local CandyAmount = Instance.new("TextLabel")
CandyAmount.Name = "CandyValue"
CandyAmount.Size = UDim2.new(1, -10, 1, 0)
CandyAmount.Position = UDim2.new(0, 35, 0, 0)
CandyAmount.BackgroundTransparency = 1
CandyAmount.Text = "0"
CandyAmount.TextColor3 = Color3.new(1, 1, 1)
CandyAmount.TextSize = 14
CandyAmount.Font = Enum.Font.Gotham
CandyAmount.Parent = CandyFrame

-- Barra de XP
local XPBarBackground = Instance.new("Frame")
XPBarBackground.Name = "XPBarBackground"
XPBarBackground.Size = UDim2.new(0, 150, 0, 10)
XPBarBackground.Position = UDim2.new(0, 190, 0, 35)
XPBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
XPBarBackground.BackgroundTransparency = 0.3
XPBarBorder.Size = UDim2.new(1, 0, 1, 0)
XPBarBorder.BackgroundColor3 = Color3.new(1, 1, 1)
XPBarBorder.BackgroundTransparency = 1
XPBarBorder.Parent = XPBarBackground

local XPBarFill = Instance.new("Frame")
XPBarFill.Name = "XPBarFill"
XPBarFill.Size = UDim2.new(0, 0, 1, 0)
XPBarFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
XPBarFill.BackgroundTransparency = 0
XPBarFill.Parent = XPBarBackground

XPBarBackground.Parent = MainFrame
XPBarFill.Parent = XPBarBackground

-- Nivel
local LevelLabel = Instance.new("TextLabel")
LevelLabel.Name = "LevelLabel"
LevelLabel.Size = UDim2.new(0, 50, 0, 20)
LevelLabel.Position = UDim2.new(0, 190, 0, 55)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Text = "Nivel: 1"
LevelLabel.TextColor3 = Color3.new(1, 1, 1)
LevelLabel.TextSize = 12
LevelLabel.Font = Enum.Font.Gotham
LevelLabel.Parent = MainFrame

-- Combo display
local ComboFrame = Instance.new("Frame")
ComboFrame.Name = "ComboFrame"
ComboFrame.Size = UDim2.new(0, 60, 0, 25)
ComboFrame.Position = UDim2.new(1, -70, 0, 10)
ComboFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
ComboFrame.BackgroundTransparency = 0.3
ComboFrame.BorderSizePixel = 0
UICorner:Clone().Parent = ComboFrame
ComboFrame.Parent = MainFrame

local ComboText = Instance.new("TextLabel")
ComboText.Size = UDim2.new(1, 0, 1, 0)
ComboText.BackgroundTransparency = 1
ComboText.Text = "COMBO x1"
ComboText.TextColor3 = Color3.new(1, 1, 1)
ComboText.TextSize = 12
ComboText.Font = Enum.Font.GothamBold
ComboText.Parent = ComboFrame

MainFrame.Parent = HUDGui

-- Función para actualizar las monedas
function HUD.UpdateCoins(amount)
	local coinsLabel = MainFrame:WaitForChild("CoinsSection"):WaitForChild("CoinsValue")
	coinsLabel.Text = tostring(amount)
	
-- Animación suave
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
	local tween = TweenService:Create(coinsLabel, tweenInfo, {TextTransparency = 0})
	tween:Play()
end

-- Función para actualizar los caramelos
function HUD.UpdateCandy(amount)
	local candyLabel = MainFrame:WaitForChild("CandySection"):WaitForChild("CandyValue")
	candyLabel.Text = tostring(amount)
	
-- Efecto de brillo al ganar
	if tonumber(amount) > 0 then
		candyLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		task.delay(0.5, function()
			candyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		end)
	end
end

-- Función para actualizar la barra de XP
function HUD.UpdateXP(currentXP, totalXP, level)
	local xpBarFill = MainFrame:WaitForChild("XPBar"):WaitForChild("XPBarFill")
	
-- Calcular porcentaje
	local xpNeeded = 100 + (level - 1) * 25 -- Fórmula simplificada
	local progress = math.min(currentXP / xpNeeded, 1)
	
-- Actualizar ancho de la barra
	xpBarFill.Size = UDim2.new(progress, 0, 1, 0)
	
-- Color según progreso
	if progress > 0.8 then
		xpBarFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Rosa/rosa
	elseif progress > 0.5 then
		xpBarFill.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Naranja
	else
		xpBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Amarillo
	end
end

-- Función para actualizar el nivel
function HUD.UpdateLevel(level)
	local levelLabel = MainFrame:WaitForChild("LevelLabel")
	levelLabel.Text = "Nivel: " .. tostring(level)
end

-- Función para actualizar el combo
function HUD.UpdateCombo(comboLevel, multiplier)
	local comboText = MainFrame:WaitForChild("ComboFrame"):WaitForChild("ComboText")
	
-- Mostrar combo
	if comboLevel > 1 then
		comboText.Text = "COMBO x" .. tostring(math.floor(multiplier))
		-- Animación de parpadeo
		comboText.TextColor3 = Color3.fromRGB(255, 215, 0)
	else
		comboText.Text = "COMBO x1"
		comboText.TextColor3 = Color3.fromRGB(200, 200, 200)
	end
end

-- Función para actualizar la mascota equipada
function HUD.UpdatePet(petName, petRarity)
-- Crear o actualizar el ícono de mascota
	local petIcon = MainFrame:FindFirstChild("PetIcon")
	if not petIcon then
		petIcon = Instance.new("TextLabel")
		petIcon.Name = "PetIcon"
		petIcon.Size = UDim2.new(0, 25, 0, 25)
		petIcon.Position = UDim2.new(1, -130, 0, 10)
		petIcon.BackgroundTransparency = 1
		petIcon.TextSize = 12
		petIcon.Font = Enum.Font.Gotham
		petIcon.Parent = MainFrame
	end
	
	petIcon.Text = petName:sub(1, 1) .. "[" .. petRarity:sub(1,1) .. "]"
	petIcon.TextColor3 = Color3.fromRGB(255, 100, 255)
end

-- Botones de la interfaz
function HUD.CreateButtons()
-- Botón Tienda
local shopButton = Instance.new("TextButton")
shopButton.Name = "ShopButton"
shopButton.Size = UDim2.new(0, 100, 0, 30)
shopButton.Position = UDim2.new(1, -110, 0, 50)
shopButton.BackgroundColor3 = Color3.fromRGB(255, 180, 100)
shopButton.BackgroundTransparency = 0.3
shopButton.BorderSizePixel = 0
UICorner:Clone().Parent = shopButton
shopButton.Parent = HUDGui

local shopText = Instance.new("TextLabel")
shopText.Size = UDim2.new(1, 0, 1, 0)
shopText.BackgroundTransparency = 1
shopText.Text = "TIENDA"
shopText.TextColor3 = Color3.new(1, 1, 1)
shopText.TextSize = 11
shopText.Font = Enum.Font.GothamBold
shopText.Parent = shopButton

-- Botón Mascotas
local petsButton = Instance.new("TextButton")
petsButton.Name = "PetsButton"
petsButton.Size = UDim2.new(0, 100, 0, 30)
petsButton.Position = UDim2.new(1, -210, 0, 50)
petsButton.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
petsButton.BackgroundTransparency = 0.3
petsButton.BorderSizePixel = 0
UICorner:Clone().Parent = petsButton
petsButton.Parent = HUDGui

local petsText = Instance.new("TextLabel")
petsText.Size = UDim2.new(1, 0, 1, 0)
petsText.BackgroundTransparency = 1
petsText.Text = "MASCOTAS"
petsText.TextColor3 = Color3.new(1, 1, 1)
petsText.TextSize = 11
petsText.Font = Enum.Font.GothamBold
petsText.Parent = petsButton

-- Conectar eventos de los botones
shopButton.MouseButton1Click:Connect(function()
-- Remotear al servidor para abrir tienda
	print("Tienda abierta")
end)

petsButton.MouseButton1Click:Connect(function()
-- Remotear para ver mascotas
	print("Mascotas abierta")
end)

-- Hacer el HUD responsive
HUD.MakeResponsive(HUDGui)

print("HUDController creado y configurado")
return HUD