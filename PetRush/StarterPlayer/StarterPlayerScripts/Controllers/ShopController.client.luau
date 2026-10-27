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

-- Creación de la interfaz de la tienda
function Shop.OpenShop()
	local shopGui = Instance.new("ScreenGui")
	shopGui.Name = "PetRushShop"
	shopGui.Parent = PlayerGui
	shopGui.ResetOnSpawn = false
	shopGui.IgnoreGuiInset = true

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 400, 0, 450)
	mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	mainFrame.BackgroundTransparency = 0.3
	mainFrame.BorderSizePixel = 0
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = mainFrame
	mainFrame.Parent = shopGui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "TIENDA"
	title.TextColor3 = Color3.fromRGB(255, 105, 180)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = mainFrame

	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -20, 1, -50)
	scrollFrame.Position = UDim2.new(0, 10, 0, 50)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
	scrollFrame.Parent = mainFrame

	local items = {
		{Name = "SpeedUpgrade", DisplayName = "Mejorar Velocidad", Price = GameConfig.Upgrades.Speed, RequiredLevel = 1, Type = "Upgrade"},
		{Name = "RadiusUpgrade", DisplayName = "Ampliar Alcance", Price = GameConfig.Upgrades.Radius, RequiredLevel = 1, Type = "Upgrade"},
		{Name = "CandyMultiplier", DisplayName = "Multiplicador de Caramelos", Price = GameConfig.Upgrades.CandyMultiplier, RequiredLevel = 1, Type = "Upgrade"},
		{Name = "PetColor1", DisplayName = "Color: Azul Neon", Price = 300, RequiredLevel = 3, Type = "Cosmetic"},
		{Name = "PetColor2", DisplayName = "Color: Rosa Neon", Price = 300, RequiredLevel = 5, Type = "Cosmetic"},
	}

	local yOffset = 0
	for _, item in pairs(items) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Name = item.Name .. "_Frame"
		itemFrame.Size = UDim2.new(1, -20, 0, 40)
		itemFrame.Position = UDim2.new(0, 10, 0, yOffset)
		itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		itemFrame.BackgroundTransparency = 0.5
		itemFrame.BorderSizePixel = 0
		itemFrame.Parent = scrollFrame

		UICorner:Clone().Parent = itemFrame

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = item.DisplayName
		nameLabel.TextColor3 = Color3.new(1, 1, 1)
		nameLabel.TextSize = 14
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.Parent = itemFrame

		local priceLabel = Instance.new("TextLabel")
		priceLabel.Size = UDim2.new(0.4, -10, 1, 0)
		priceLabel.Position = UDim2.new(0.6, 0, 0, 0)
		priceLabel.BackgroundTransparency = 1
		priceLabel.Text = "Precio: " .. item.Price .. " 💰"
		priceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		priceLabel.TextSize = 12
		priceLabel.Font = Enum.Font.Gotham
		priceLabel.Parent = itemFrame

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, 0, 1, 0)
		button.BackgroundTransparency = 1
		button.Text = ""
		button.Parent = itemFrame

		button.MouseButton1Click:Connect(function()
			Remotes.Client.OnPurchase:FireServer(item.Name)
		end)

		yOffset = yOffset + 45
	end

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

	closeButton.MouseButton1Click:Connect(function()
		shopGui:Destroy()
	end)

	print("ShopController tienda abierta")
	return Shop
end

return Shop
