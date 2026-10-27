-- HUDController.client.luau
-- Contador y display de monedas y caramelos en la pantalla

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
	frame.Size = UDim2.new(0, 200, 0, 80)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.5
	frame.Parent = screenGui
end

-- Crear los TextLabels para monedas y caramelos
local coinsLabel = frame:FindFirstChild("CoinsLabel")
if not coinsLabel then
	coinsLabel = Instance.new("TextLabel")
	coinsLabel.Name = "CoinsLabel"
	coinsLabel.Size = UDim2.new(1, 0, 0.5, 0)
	coinsLabel.Position = UDim2.new(0, 0, 0, 0)
	coinsLabel.BackgroundTransparency = 1
	coinsLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Gold color for coins
	coinsLabel.TextSize = 18
	coinsLabel.Font = Enum.Font.SourceSans
	coinsLabel.Text = "Coins: 0"
	coinsLabel.Parent = frame
end

local candiesLabel = frame:FindFirstChild("CandiesLabel")
if not candiesLabel then
	candiesLabel = Instance.new("TextLabel")
	candiesLabel.Name = "CandiesLabel"
	candiesLabel.Size = UDim2.new(1, 0, 0.5, 0)
	candiesLabel.Position = UDim2.new(0, 0, 0.5, 0) -- Below coins label
	candiesLabel.BackgroundTransparency = 1
	candiesLabel.TextColor3 = Color3.fromRGB(255, 105, 180) -- Pink/red color for candies
	candiesLabel.TextSize = 18
	candiesLabel.Font = Enum.Font.SourceSans
	candiesLabel.Text = "Candies: 0"
	candiesLabel.Parent = frame
end

-- También podría mostrar el multiplicador
local multiplierLabel = frame:FindFirstChild("MultiplierLabel")
if not multiplierLabel then
	multiplierLabel = Instance.new("TextLabel")
	multiplierLabel.Name = "MultiplierLabel"
	multiplierLabel.Size = UDim2.new(1, 0, 0.5, 0)
	multiplierLabel.Position = UDim2.new(0, 0, 0.75, 0) -- At the bottom
	multiplierLabel.BackgroundTransparency = 1
	multiplierLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	multiplierLabel.TextSize = 14
	multiplierLabel.Font = Enum.Font.SourceSans
	multiplierLabel.Text = "Multi: 1x"
	multiplierLabel.Parent = frame
end

-- Actualizar el texto cuando cambien los leaderstats
local function updateDisplay()
	local leaderstats = Player:FindFirstChild("leaderstats")
	if leaderstats then
		local coinsValue = leaderstats:FindFirstChild("Coins")
		local candiesValue = leaderstats:FindFirstChild("Candies")
		local multiValue = leaderstats:FindFirstChild("CookieMultiplier")

		if coinsValue then
			coinsLabel.Text = "Coins: " .. coinsValue.Value
		end
		if candiesValue then
			candiesLabel.Text = "Candies: " .. candiesValue.Value
		end
		if multiValue then
			local multiplier = multiValue.Value
			multiplierLabel.Text = "Multi: " .. multiplier .. "x"
		end
	end
end

-- Conectar a los cambios de leaderstats
local leaderstats = Player:FindFirstChild("leaderstats")
if leaderstats then
	leaderstats.Changed:Connect(updateDisplay)
	-- También actualizar Candies y Multiplier inicialmente
	local candiesValue = leaderstats:FindFirstChild("Candies")
	local multiValue = leaderstats:FindFirstChild("CookieMultiplier")
	if candiesValue then
		candiesValue.Changed:Connect(updateDisplay)
	end
	if multiValue then
		multiValue.Changed:Connect(updateDisplay)
	end
end

-- También actualizar inmediatamente al cargar
updateDisplay()