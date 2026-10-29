-- HUDController.client.luau - Versión con creación garantizada de todos los elementos
-- Contador y display de monedas, caramelos y sistema de huevos

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
	frame.Size = UDim2.new(0, 280, 0, 140)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.5
	frame.Parent = screenGui
end

-- Asegurar que el Frame esté visible
frame.Visible = true

-- Crear los TextLabels para monedas y caramelos (siempre crear si no existen)
local coinsLabel = frame:FindFirstChild("CoinsLabel")
if not coinsLabel then
	coinsLabel = Instance.new("TextLabel")
	coinsLabel.Name = "CoinsLabel"
	coinsLabel.Size = UDim2.new(1, 0, 0.2, 0)
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
	candiesLabel.Size = UDim2.new(1, 0, 0.2, 0)
	candiesLabel.Position = UDim2.new(0, 0, 0.25, 0) -- Below coins label
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
	multiplierLabel.Size = UDim2.new(1, 0, 0.2, 0)
	multiplierLabel.Position = UDim2.new(0, 0, 0.5, 0) -- At the top middle
	multiplierLabel.BackgroundTransparency = 1
	multiplierLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	multiplierLabel.TextSize = 14
	multiplierLabel.Font = Enum.Font.SourceSans
	multiplierLabel.Text = "Multi: 1x"
	multiplierLabel.Parent = frame
end

-- Área para mensajes y huevos
local eggInfoLabel = frame:FindFirstChild("EggInfoLabel")
if not eggInfoLabel then
	eggInfoLabel = Instance.new("TextLabel")
	eggInfoLabel.Name = "EggInfoLabel"
	eggInfoLabel.Size = UDim2.new(1, 0, 0.3, 0)
	eggInfoLabel.Position = UDim2.new(0, 0, 0.75, 0) -- Below everything
	eggInfoLabel.BackgroundTransparency = 1
	eggInfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	eggInfoLabel.TextSize = 12
	eggInfoLabel.Font = Enum.Font.SourceSans
	eggInfoLabel.Text = "Haz clic en los huevos para intentar obtener mascotas"
	eggInfoLabel.Parent = frame
end

-- Asegurar que el texto de Coins sea visible inmediatamente
coinsLabel.Text = "Coins: 0"
candiesLabel.Text = "Candies: 0"
multiplierLabel.Text = "Multi: 1x"
eggInfoLabel.Text = "Haz clic en los huevos para intentar obtener mascotas"

-- Actualizar el texto cuando cambien los leaderstats
local function updateDisplay()
	local leaderstats = Player:FindFirstChild("leaderstats")
	if leaderstats then
		local coinsValue = leaderstats:FindFirstChild("Coins")
		local candiesValue = leaderstats:FindFirstChild("Candies")
		local multiValue = leaderstats:FindFirstChild("CookieMultiplier")
		local petMultiValue = leaderstats:FindFirstChild("PetMultiplier")

		if coinsValue then
			coinsLabel.Text = "Coins: " .. coinsValue.Value
		else
			coinsLabel.Text = "Coins: 0"
		end
		if candiesValue then
			candiesLabel.Text = "Candies: " .. candiesValue.Value
		else
			candiesLabel.Text = "Candies: 0"
		end
		if multiValue then
			local multiplier = multiValue.Value
			multiplierLabel.Text = "Multi: " .. multiplier .. "x"
		else
			multiplierLabel.Text = "Multi: 1x"
		end
		-- Mostrar multiplicador de mascotas
		if petMultiValue then
			local petMulti = petMultiValue.Value
			-- Calcular multiplicador total: producto de PetMultiplier × CookieMultiplier
			local cookieMulti = 1
			local cookieValue = leaderstats:FindFirstChild("CookieMultiplier")
			if cookieValue then
				cookieMulti = cookieValue.Value
			end
			local totalMulti = multiplier * cookieMulti * petMulti
			-- Redondear para evitar decimales extraños en display
			local displayMulti = math.round(totalMulti * 10) / 10
			multiplierLabel.Text = "Multi: " .. displayMulti .. "x"
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
	local petMultiValue = leaderstats:FindFirstChild("PetMultiplier")
	if candiesValue then
		candiesValue.Changed:Connect(updateDisplay)
	end
	if multiValue then
		multiValue.Changed:Connect(updateDisplay)
	end
	if petMultiValue then
		petMultiValue.Changed:Connect(updateDisplay)
	end
end

-- También actualizar inmediatamente al cargar
updateDisplay()

-- Crear botones de huevos (después de las etiquetas)
-- Botón Huevos Comunes
local commonEggButton = frame:FindFirstChild("CommonEggButton")
if not commonEggButton then
	commonEggButton = Instance.new("TextButton")
	commonEggButton.Name = "CommonEggButton"
	commonEggButton.Size = UDim2.new(0, 100, 0, 25)
	commonEggButton.Position = UDim2.new(0, 5, 0.82, 0)
	commonEggButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	commonEggButton.BackgroundTransparency = 0.3
	commonEggButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	commonEggButton.TextSize = 11
	commonEggButton.Font = Enum.Font.SourceSans
	commonEggButton.Text = "CaramelEgg (50C) - Common:60%/Rare:40%"
	commonEggButton.Parent = frame
end

-- Conectar clic a la compra de huevos comunes
commonEggButton.MouseButton1Click:Connect(function()
	local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
	if remote then
		remote:FireServer("BuyCommonEgg")
	end
end)

-- Botón Huevos Raros
local rareEggButton = frame:FindFirstChild("RareEggButton")
if not rareEggButton then
	rareEggButton = Instance.new("TextButton")
	rareEggButton.Name = "RareEggButton"
	rareEggButton.Size = UDim2.new(0, 100, 0, 25)
	rareEggButton.Position = UDim2.new(0, 110, 0.82, 0)
	rareEggButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	rareEggButton.BackgroundTransparency = 0.3
	rareEggButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	rareEggButton.TextSize = 11
	rareEggButton.Font = Enum.Font.SourceSans
	rareEggButton.Text = "PetalEgg (200C) - Rare:50%/Epic:50%"
	rareEggButton.Parent = frame
end

-- Conectar clic a la compra de huevos raros
rareEggButton.MouseButton1Click:Connect(function()
	local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
	if remote then
		remote:FireServer("BuyRareEgg")
	end
end)

-- Botón Huevos Épicos
local epicEggButton = frame:FindFirstChild("EpicEggButton")
if not epicEggButton then
	epicEggButton = Instance.new("TextButton")
	epicEggButton.Name = "EpicEggButton"
	epicEggButton.Size = UDim2.new(0, 100, 0, 25)
	epicEggButton.Position = UDim2.new(0, 215, 0.82, 0)
	epicEggButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	epicEggButton.BackgroundTransparency = 0.3
	epicEggButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	epicEggButton.TextSize = 11
	epicEggButton.Font = Enum.Font.SourceSans
	epicEggButton.Text = "StarEgg (500C) - Epic:60%/Legendary:40%"
	epicEggButton.Parent = frame
end

-- Conectar clic a la compra de huevos épicos
epicEggButton.MouseButton1Click:Connect(function()
	local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
	if remote then
		remote:FireServer("BuyEpicEgg")
	end
end)

-- Escuchar respuesta de la compra desde el servidor
local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
if remote then
	remote.OnClientEvent:Connect(function(success, message)
		if success then
			-- Mostrar mensaje de éxito
			eggInfoLabel.Text = message
			print("Compra exitosa: " .. message)
			-- Actualizar el multiplicador en el HUD
			updateDisplay()
		else
			-- Mostrar mensaje de error
			eggInfoLabel.Text = message
			print("Error en compra: " .. message)
		end
	end)
end

-- Panel de mascotas equipadas e inventario
local petPanel = frame:FindFirstChild("PetPanel")
if not petPanel then
	petPanel = Instance.new("Frame")
	petPanel.Name = "PetPanel"
	petPanel.Size = UDim2.new(1, 0, 0.3, 0)
	petPanel.Position = UDim2.new(0, 0, 0.85, 0)
	petPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	petPanel.BackgroundTransparency = 0.5
	petPanel.Parent = frame
end

local equippedPetLabel = petPanel:FindFirstChild("EquippedPetLabel")
if not equippedPetLabel then
	equippedPetLabel = Instance.new("TextLabel")
	equippedPetLabel.Name = "EquippedPetLabel"
	equippedPetLabel.Size = UDim2.new(1, 0, 0.3, 0)
	equippedPetLabel.Position = UDim2.new(0, 0, 0, 0)
	equippedPetLabel.BackgroundTransparency = 1
	equippedPetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	equippedPetLabel.TextSize = 12
	equippedPetLabel.Font = Enum.Font.SourceSans
	equippedPetLabel.Text = "Mascota equipada: Ninguna"
	equippedPetLabel.Parent = petPanel
end

local inventoryLabel = petPanel:FindFirstChild("InventoryLabel")
if not inventoryLabel then
	inventoryLabel = Instance.new("TextLabel")
	inventoryLabel.Name = "InventoryLabel"
	inventoryLabel.Size = UDim2.new(1, 0, 0.3, 0)
	inventoryLabel.Position = UDim2.new(0, 0, 0.35, 0)
	inventoryLabel.BackgroundTransparency = 1
	inventoryLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	inventoryLabel.TextSize = 11
	inventoryLabel.Font = Enum.Font.SourceSans
	inventoryLabel.Text = "Inventario: (vacío)"
	inventoryLabel.Parent = petPanel
end

local function updatePetPanel()
	local leaderstats = Player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	-- Actualizar mascota equipada
	local equippedValue = leaderstats:FindFirstChild("EquippedPet")
	if equippedValue and equippedValue.Value ~= "" then
		equippedPetLabel.Text = "Mascota equipada: " .. equippedValue.Value
	else
		equippedPetLabel.Text = "Mascota equipada: Ninguna"
	end

	-- Actualizar inventario
	local petsFolder = Player:FindFirstChild("Pets")
	local inventoryFolder = Player:FindFirstChild("Inventory")
	local inventoryText = "Inventario: "
	if inventoryFolder then
		local petCount = 0
		for _, child in pairs(inventoryFolder:GetChildren()) do
			if child:IsA("StringValue") then
				petCount = petCount + 1
			end
		end
		inventoryText = inventoryText .. petCount .. " mascota(s) en inv."
	else
		inventoryText = inventoryText .. "(vacío)"
	end
	inventoryLabel.Text = inventoryText
end

-- Conectar actualizaciones
local leaderstats = Player:FindFirstChild("leaderstats")
if leaderstats then
	leaderstats.Changed:Connect(updatePetPanel)
	local pets = Player:FindFirstChild("Pets")
	if pets then
		pets.Changed:Connect(updatePetPanel)
	end
	local inventory = Player:FindFirstChild("Inventory")
	if inventory then
		inventory.Changed:Connect(updatePetPanel)
	end
end

-- Actualizar panel al cargar
updatePetPanel()

-- Botones de equipar/desequipar
local equipButton = petPanel:FindFirstChild("EquipButton")
if not equipButton then
	equipButton = Instance.new("TextButton")
	equipButton.Name = "EquipButton"
	equipButton.Size = UDim2.new(0, 80, 0, 20)
	equipButton.Position = UDim2.new(0.1, 0, 0.75, 0)
	equipButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	equipButton.BackgroundTransparency = 0.3
	equipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	equipButton.TextSize = 11
	equipButton.Font = Enum.Font.SourceSans
	equipButton.Text = "Equipar"
	equipButton.Parent = petPanel
end

local unequipButton = petPanel:FindFirstChild("UnequipButton")
if not unequipButton then
	unequipButton = Instance.new("TextButton")
	unequipButton.Name = "UnequipButton"
	unequipButton.Size = UDim2.new(0, 80, 0, 20)
	unequipButton.Position = UDim2.new(0.1, 0, 0.82, 0)
	unequipButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	unequipButton.BackgroundTransparency = 0.3
	unequipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	unequipButton.TextSize = 11
	unequipButton.Font = Enum.Font.SourceSans
	unequipButton.Text = "Desequipar"
	unequipButton.Parent = petPanel
end

-- Conectar clic Equipar
equipButton.MouseButton1Click:Connect(function()
	local leaderstats = Player:FindFirstChild("leaderstats")
	if not leaderstats then return end
	local equipped = leaderstats:FindFirstChild("EquippedPet")
	if not equipped then return end
	local currentPet = equipped.Value
	if currentPet == "" then
		local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
		if remote then
			remote:FireServer("EquipPet", "")
		end
	else
		local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
		if remote then
			remote:FireServer("EquipPet", currentPet)
		end
	end
end)

-- Conectar clic Desequipar
unequipButton.MouseButton1Click:Connect(function()
	local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
	if remote then
		remote:FireServer("UnequipPet", "")
	end
end)

-- Botón Tienda: Slot Extra
local extraSlotButton = petPanel:FindFirstChild("ExtraSlotButton")
if not extraSlotButton then
	extraSlotButton = Instance.new("TextButton")
	extraSlotButton.Name = "ExtraSlotButton"
	extraSlotButton.Size = UDim2.new(0, 100, 0, 25)
	extraSlotButton.Position = UDim2.new(0, 5, 0.90, 0)
	extraSlotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	extraSlotButton.BackgroundTransparency = 0.3
	extraSlotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	extraSlotButton.TextSize = 11
	extraSlotButton.Font = Enum.Font.SourceSans
	extraSlotButton.Text = "Extra Slot (300C) - Desbloquea 4ª mascota"
	extraSlotButton.Parent = petPanel
end

-- Sistema de 3 Habilidades con cooldown visible
-- Activables por teclado o botones HUD

-- Configuración de habilidades
local SkillConfig = {
    -- Imán: atrae monedas y caramelos hacia el jugador
    Magnet = {
        Name = "Magnet",
        Cooldown = 30, -- segundos
        CostCoins = 0,
        CostCandies = 0,
        Description = "Atrae monedas y caramelos hacia ti por 10 segundos"
    },
    -- Botas Veloces: aumenta velocidad de movimiento
    SpeedBoost = {
        Name = "SpeedBoost",
        Cooldown = 45, -- segundos
        Duration = 10, -- segundos que dura el efecto
        CostCoins = 100,
        CostCandies = 50,
        Description = "Aumenta velocidad en 50% por 10s"
    },
    -- Poción Double Reward: duplica recompensas por 30 segundos
    DoubleReward = {
        Name = "DoubleReward",
        Cooldown = 60, -- segundos
        Duration = 30, -- segundos que dura el efecto
        CostCoins = 200,
        CostCandies = 100,
        Description = "Duplica monedas y caramelos por 30s"
    }
}

-- Estado actual de habilidades
local skillState = {
    [SkillConfig.Magnet.Name] = {
        active = false,
        cooldownRemaining = 0,
        endTime = 0
    },
    [SkillConfig.SpeedBoost.Name] = {
        active = false,
        cooldownRemaining = 0,
        endTime = 0
    },
    [SkillConfig.DoubleReward.Name] = {
        active = false,
        cooldownRemaining = 0,
        endTime = 0
    }
}

-- Crear o actualizar el marco de habilidades en el HUD
local function createSkillsFrame()
    local frame = script.Parent:FindFirstChild("SkillsFrame")
    if frame then
        frame:Destroy()
    end
    
    local skillsFrame = Instance.new("Frame")
    skillsFrame.Name = "SkillsFrame"
    skillsFrame.Size = UDim2.new(0, 300, 0, 120)
    skillsFrame.Position = UDim2.new(0, 10, 0, 160)
    skillsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    skillsFrame.BackgroundTransparency = 0.5
    skillsFrame.Parent = script.Parent
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.SourceSans
    title.Text = "Habilidades (Cooldown)"
    title.Parent = skillsFrame
    
    -- Botón Imán
    local magnetButton = Instance.new("TextButton")
    magnetButton.Name = "MagnetButton"
    magnetButton.Size = UDim2.new(0, 90, 0, 25)
    magnetButton.Position = UDim2.new(0, 5, 0, 30)
    magnetButton.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    magnetButton.BackgroundTransparency = 0.3
    magnetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    magnetButton.TextSize = 11
    magnetButton.Font = Enum.Font.SourceSans
    magnetButton.Text = "Imán"
    magnetButton.Parent = skillsFrame
    
    -- Cooldown del Imán
    local magnetCooldown = Instance.new("TextLabel")
    magnetCooldown.Name = "MagnetCooldown"
    magnetCooldown.Size = UDim2.new(0, 90, 0, 15)
    magnetCooldown.Position = UDim2.new(0, 5, 0, 55)
    magnetCooldown.BackgroundTransparency = 1
    magnetCooldown.TextColor3 = Color3.fromRGB(200, 200, 200)
    magnetCooldown.TextSize = 10
    magnetCooldown.Font = Enum.Font.SourceSans
    magnetCooldown.Text = "Listo"
    magnetCooldown.Parent = skillsFrame
    
    -- Botón Botas Veloces
    local speedButton = Instance.new("TextButton")
    speedButton.Name = "SpeedButton"
    speedButton.Size = UDim2.new(0, 90, 0, 25)
    speedButton.Position = UDim2.new(0, 105, 0, 30)
    speedButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    speedButton.BackgroundTransparency = 0.3
    speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedButton.TextSize = 11
    speedButton.Font = Enum.Font.SourceSans
    speedButton.Text = "Botas"
    speedButton.Parent = skillsFrame
    
    -- Cooldown de Botas
    local speedCooldown = Instance.new("TextLabel")
    speedCooldown.Name = "SpeedCooldown"
    speedCooldown.Size = UDim2.new(0, 90, 0, 15)
    speedCooldown.Position = UDim2.new(0, 105, 0, 55)
    speedCooldown.BackgroundTransparency = 1
    speedCooldown.TextColor3 = Color3.fromRGB(200, 200, 200)
    speedCooldown.TextSize = 10
    speedCooldown.Font = Enum.Font.SourceSans
    speedCooldown.Text = "Listo"
    speedCooldown.Parent = skillsFrame
    
    -- Botón Double Reward
    local doubleButton = Instance.new("TextButton")
    doubleButton.Name = "DoubleButton"
    doubleButton.Size = UDim2.new(0, 90, 0, 25)
    doubleButton.Position = UDim2.new(0, 210, 0, 30)
    doubleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    doubleButton.BackgroundTransparency = 0.3
    doubleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    doubleButton.TextSize = 11
    doubleButton.Font = Enum.Font.SourceSans
    doubleButton.Text = "Double"
    doubleButton.Parent = skillsFrame
    
    -- Cooldown Double Reward
    local doubleCooldown = Instance.new("TextLabel")
    doubleCooldown.Name = "DoubleCooldown"
    doubleCooldown.Size = UDim2.new(0, 90, 0, 15)
    doubleCooldown.Position = UDim2.new(0, 210, 0, 55)
    doubleCooldown.BackgroundTransparency = 1
    doubleCooldown.TextColor3 = Color3.fromRGB(200, 200, 200)
    doubleCooldown.TextSize = 10
    doubleCooldown.Font = Enum.Font.SourceSans
    doubleCooldown.Text = "Listo"
    doubleCooldown.Parent = skillsFrame
    
    -- Conectar botones
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
    
    -- Función para actualizar cooldowns en el cliente
    local function updateSkillCooldowns()
        for name, state in pairs(skillState) do
            if state.active then
                local now = tick()
                if now >= state.endTime then
                    -- Efecto terminado
                    state.active = false
                    state.cooldownRemaining = state.cooldown
                    -- Remover efecto del jugador
                    if name == SkillConfig.Magnet.Name then
                        -- Remover partículas de imán
                    elseif name == SkillConfig.SpeedBoost.Name then
                        -- Restaurar velocidad normal
                        local character = Player.Character
                        if character then
                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            local hum = character:FindFirstChild("Humanoid")
                            if hum then
                                hum.WalkSpeed = 16 -- velocidad base
                            end
                        end
                    elseif name == SkillConfig.DoubleReward.Name then
                        -- Restaurar multiplicador normal
                        local leaderstats = Player:FindFirstChild("leaderstats")
                        if leaderstats then
                            local multi = leaderstats:FindFirstChild("PetMultiplier")
                            if multi then
                                multi.Value = 1
                            end
                        end
                    end
                else
                    -- Todavía en efecto o en enfriamiento
                    state.cooldownRemaining = math.max(0, math.ceil(state.endTime - now))
                end
            end
        end
    end
    
    -- Actualizar cooldowns cada segundo
    while true do
        task.wait(1)
        updateSkillCooldowns()
    end
    
    -- Botón Imán - activar/desactivar
    magnetButton.MouseButton1Click:Connect(function()
        local state = skillState[SkillConfig.Magnet.Name]
        if state.cooldownRemaining <= 0 then
            -- Activar habilidad
            state.active = true
            state.endTime = tick() + SkillConfig.Magnet.Duration
            
            -- Efecto visual: crear partículas alrededor del jugador
            local character = Player.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Crear ParticleEmitter para imán
                    local pe = Instance.new("ParticleEmitter")
                    pe.Rate = 5
                    pe.Lifetime = NumberRange.new(2, 5)
                    pe.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
                    pe.Size = NumberSequence.new(2, 4)
                    pe.Parent = hrp
                    
                    -- Quitar después de un tiempo
                    task.delay(SkillConfig.Magnet.Duration, function()
                        if pe and pe.Parent then
                            pe:Destroy()
                        end
                    end)
                end
            end
            
            -- Poner en cooldown
            state.cooldownRemaining = SkillConfig.Magnet.Cooldown
        else
            print("Habilidad " .. SkillConfig.Magnet.Name .. " en cooldown: " .. state.cooldownRemaining .. "s")
        end
    end)
    
    -- Botón Botas Veloces
    speedButton.MouseButton1Click:Connect(function()
        local state = skillState[SkillConfig.SpeedBoost.Name]
        if state.cooldownRemaining <= 0 then
            -- Activar habilidad
            state.active = true
            state.endTime = tick() + SkillConfig.SpeedBoost.Duration
            
            -- Aumentar velocidad
            local character = Player.Character
            if character then
                local hum = character:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = 24 -- 50% más rápido
                end
            end
            
            -- Poner en cooldown
            state.cooldownRemaining = SkillConfig.SpeedBoost.Cooldown
        else
            print("Habilidad " .. SkillConfig.SpeedBoost.Name .. " en cooldown: " .. state.cooldownRemaining .. "s")
        end
    end)
    
    -- Botón Double Reward
    doubleButton.MouseButton1Click:Connect(function()
        local state = skillState[SkillConfig.DoubleReward.Name]
        if state.cooldownRemaining <= 0 then
            -- Activar habilidad
            state.active = true
            state.endTime = tick() + SkillConfig.DoubleReward.Duration
            
            -- Duplicar multiplicador
            local leaderstats = Player:FindFirstChild("leaderstats")
            if leaderstats then
                local multi = leaderstats:FindFirstChild("PetMultiplier")
                if multi then
                    multi.Value = multi.Value * 2
                end
            end
            
            -- Poner en cooldown
            state.cooldownRemaining = SkillConfig.DoubleReward.Cooldown
        else
            print("Habilidad " .. SkillConfig.DoubleReward.Name .. " en cooldown: " .. state.cooldownRemaining .. "s")
        end
    end)
end

-- Conectar cuando el ScreenGui se cargue
local screenGui = Player:WaitForChild("PlayerGui"):FindFirstChild("CoinHUD")
if screenGui then
    createSkillsFrame(script.Parent)
end

-- Comunicación con servidor para validación de habilidades
local function activateSkillServer(skillName)
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
    if remote then
        remote:FireServer("ActivateSkill", skillName)
    end
end

-- Escuchar confirmación del servidor
local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
if remote then
    remote.OnClientEvent:Connect(function(success, message, skillName)
        if success then
            print("Habilidad activada: " .. skillName .. " - " .. message)
            -- El efecto ya se aplica en el cliente al hacer clic
        else
            print("Error al activar habilidad " .. skillName .. ": " .. message)
        end
    end)
end

print("Skills system loaded")



-- Conectar clic Extra Slot
extraSlotButton.MouseButton1Click:Connect(function()
	local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ShopRemote")
	if remote then
		remote:FireServer("ExtraPetSlot", "")
	end
end)
