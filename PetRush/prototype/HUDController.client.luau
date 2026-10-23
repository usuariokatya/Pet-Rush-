-- HUDController.client.luau
-- Contador y display de monedas en la pantalla

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Crear o obtener el ScreenGui existente
local screenGui = PlayerGui:FindFirstChild("CoinHUD")
if not screenGui then
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CoinHUD"
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = PlayerGui
end

-- Crear el Frame de fondo
local frame = screenGui:FindFirstChild("Frame")
if not frame then
	frame = Instance.new("Frame")
	frame.Name = "Frame"
	frame.Size = UDim2.new(0, 150, 0, 50)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.5
	frame.Parent = screenGui
end

-- Crear el TextLabel para mostrar monedas
local textLabel = frame:FindFirstChild("TextLabel")
if not textLabel then
	textLabel = Instance.new("TextLabel")
	textLabel.Name = "TextLabel"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 18
	textLabel.Font = Enum.Font.SourceSans
	textLabel.Text = "Coins: 0"
	textLabel.Parent = frame
end

-- Actualizar el texto cuando cambien los leaderstats
local function updateCoinDisplay()
	local leaderstats = Player:FindFirstChild("leaderstats")
	if leaderstats then
		local coinsValue = leaderstats:FindFirstChild("Coins")
		if coinsValue then
			textLabel.Text = "Coins: " .. coinsValue.Value
		end
	end
end

-- Conectar al cambio de monedas
local coinsValue = Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Coins")
if coinsValue then
	coinsValue.Changed:Connect(updateCoinDisplay)
end

-- También actualizar inmediatamente al cargar
updateCoinDisplay()