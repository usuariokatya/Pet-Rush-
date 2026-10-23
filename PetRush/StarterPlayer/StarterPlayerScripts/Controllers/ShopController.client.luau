-- ShopController.client.luau
-- Controlador de la tienda del juego (mejoras y cosméticos con monedas)
-- Ubicación: StarterPlayer/StarterPlayerScripts/Controllers/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Shop = {}

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Referencias a módulos y remotos
local Remotes = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Remotes")
local GameConfig = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Shared"):WaitForChild("GameConfig")
local PlayerData = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Shared"):WaitForChild("PetData")
local ShopModule = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("ServerScriptService"):WaitForChild("Systems"):WaitForChild("Shop")

-- Creación de la interfaz de la tienda
function Shop.OpenShop()
-- Crear ScreenGui para la tienda
local shopGui = Instance.new("ScreenGui")
shopGui.Name = "PetRushShop"
shopGui.Parent = PlayerGui
shopGui.ResetOnSpawn = false
shopGui.IgnoreGuiInset = true

-- Fondo principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 450)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
UICorner:Clone().Parent = mainFrame
mainFrame.Parent = shopGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "TIENDA"
title.TextColor3 = Color3.fromRGB(255, 105, 180)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Lista de artículos
local items = ShopModule.Items or {
	{Name = "Mejorar Velocidad", Price = 100, RequiredLevel = 1, Type = "Upgrade"},
	{Name = "Ampliar Alcance", Price = 150, RequiredLevel = 1, Type = "Upgrade"},
	{Name = "Multiplicador de Caramelos", Price = 200, RequiredLevel = 1, Type = "Upgrade"},
	{Name = "Color: Azul Neon", Price = 300, RequiredLevel = 3, Type = "Cosmetic"},
	{Name = "Color: Rosa Neon", Price = 300, RequiredLevel = 5, Type = "Cosmetic"},
}

local scrollFrame = Instance.new("ScrollFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

-- Crear botones para cada artículo
local yOffset = 0
for _, item in pairs(items) do
	local itemFrame = Instance.new("Frame")
	itemFrame.Size = UDim2.new(1, -20, 0, 40)
	itemFrame.Position = UDim2.new(0, 10, 0, yOffset)
	itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	itemFrame.BackgroundTransparency = 0.5
	itemFrame.BorderSizePixel = 0
	itemFrame.Parent = scrollFrame
	
	UICorner:Clone().Parent = itemFrame
	
-- Nombre del artículo
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = item.Name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.Parent = itemFrame
	
-- Precio
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Size = UDim2.new(0.4, -10, 1, 0)
	priceLabel.Position = UDim2.new(0.6, 0, 0, 0)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Text = "Precio: " .. item.Price .. " 💰"
	priceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	priceLabel.TextSize = 12
	priceLabel.Font = Enum.Font.Gotham
	priceLabel.Parent = itemFrame
	
-- Nivel requerido
	local levelLabel = Instance.new("TextLabel")
	levelLabel.Size = UDim2.new(0.4, -10, 1, 0)
	levelLabel.Position = UDim2.new(0.6, 0, 0, 0) -- Esto se superpondrá, ajustar
	levelLabel.BackgroundTransparency = 1
	levelLabel.Text = "Nivel req: " .. item.RequiredLevel
	levelLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	levelLabel.TextSize = 10
	levelLabel.Font = Enum.Font.Gotham
	levelLabel.Parent = itemFrame
	
	yOffset = yOffset + 45
end

-- Botón Cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 100, 0, 30)
closeButton.Position = UDim2.new(0.5, -50, 1, -40)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.BackgroundTransparency = 0.3
closeButton.BorderSizePixel = 0
closeButton.Text = "CERRAR"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 14
UICorner:Clone().Parent = closeButton
closeButton.Parent = shopGui

-- Conectar botón de cerrar
closeButton.MouseButton1Click:Connect(function()
	shopGui:Destroy()
end)

-- Conectar compra de artículos
for _, item in pairs(items) do
-- Encontrar el frame correspondiente y conectar
-- (Simplificado - en el proyecto completo habría tags o names identificadores)
end

print("ShopController tienda abierta")
return Shop