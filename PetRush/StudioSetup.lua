-- StudioSetup.lua
-- Script para crear la estructura física de Pet Rush! en Roblox Studio
-- Ejecutar este script mientras Studio está en modo Play

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")

-- 1. Crear estructura del mapa en Workspace
local function createMapStructure()
	local mapFolder = Instance.new("Folder")
	mapFolder.Name = "PetRushMap"
	mapFolder.Parent = Workspace
	
	-- Suelo
	local ground = Instance.new("Part")
	ground.Name = "Ground"
	ground.Size = Vector3.new(200, 5, 200)
	ground.Position = Vector3.new(0, 2.5, 0)
	ground.Anchored = true
	ground.Parent = mapFolder
	
	-- Área de spawn
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "SpawnArea"
	spawn.Position = Vector3.new(0, 2, 0)
	spawn.Size = Vector3.new(10, 5, 10)
	spawn.Color = BrickColor.new("Bright blue").Color
	spawn.Anchored = true
	spawn.Parent = mapFolder
	
	-- Zonas de colección
	local zonesFolder = Instance.new("Folder")
	zonesFolder.Name = "Zones"
	zonesFolder.Parent = mapFolder
	
	-- Pradera (zona inicial)
	local meadow = Instance.new("Part")
	meadow.Name = "Meadow"
	meadow.Size = Vector3.new(100, 5, 100)
	meadow.Position = Vector3.new(50, 2.5, 0)
	meadow.Anchored = true
	meadow.Parent = zonesFolder
	
	-- Bosque Dulce
	local forest = Instance.new("Part")
	forest.Name = "CandyForest"
	forest.Size = Vector3.new(100, 5, 100)
	forest.Position = Vector3.new(-50, 2.5, 0)
	forest.Anchored = true
	forest.Parent = zonesFolder
	
	-- Cueva Arcoíris
	local cave = Instance.new("Part")
	cave.Name = "RainbowCave"
	cave.Size = Vector3.new(100, 5, 100)
	cave.Position = Vector3.new(0, 2.5, 100)
	cave.Anchored = true
	cave.Parent = zonesFolder
	
	-- Collectibles (monedas y caramelos)
	local collectiblesFolder = Instance.new("Folder")
	collectiblesFolder.Name = "Collectibles"
	collectiblesFolder.Parent = mapFolder
	
	-- Crear 20 monedas
	for i = 1, 20 do
		local coin = Instance.new("Part")
		coin.Name = "Coin_" .. i
		coin.Size = Vector3.new(1, 1, 1)
		coin.Position = Vector3.new(math.random(-80, 80), 3, math.random(-80, 80))
		coin.Anchored = true
		coin.BrickColor = BrickColor.new("Neon Gold")
		coin.Material = "Neon"
		coin.Parent = collectiblesFolder
		
		-- Billboard para símbolo
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 50, 0, 50)
		billboard.StudsPerPixel = 100
		billboard.Adornee = coin
		billboard.Parent = coin
		
		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, 0, 1, 0)
		text.BackgroundTransparency = 1
		text.Text = "💰"
		text.TextColor3 = Color3.new(1, 1, 1)
		text.TextSize = 24
		text.Parent = billboard
	end
	
	-- Crear 20 caramelos
	for i = 1, 20 do
		local candy = Instance.new("Part")
		candy.Name = "Candy_" .. i
		candy.Size = Vector3.new(1, 1, 1)
		candy.Position = Vector3.new(math.random(-80, 80), 3, math.random(-80, 80))
		candy.Anchored = true
		candy.BrickColor = BrickColor.new("Neon Red")
		candy.Material = "Neon"
		candy.Parent = collectiblesFolder
		
		-- Billboard para símbolo
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 50, 0, 50)
		billboard.StudsPerPixel = 100
		billboard.Adornee = candy
		billboard.Parent = candy
		
		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, 0, 1, 0)
		text.BackgroundTransparency = 1
		text.Text = "🍬"
		text.TextColor3 = Color3.new(1, 1, 1)
		text.TextSize = 24
		text.Parent = billboard
	end
end

-- 2. Configurar ReplicatedStorage
local function setupReplicatedStorage()
	local ps = Instance.new("Folder")
	ps.Name = "PetRush"
	ps.Parent = ReplicatedStorage
	
	local shared = Instance.new("Folder")
	shared.Name = "Shared"
	shared.Parent = ps
	
	-- Crear archivos de configuración (usando ModuleScripts)
	local function createModule(scriptName, content)
		local script = Instance.new("Script")
		script.Name = scriptName
		script.Parent = shared
		-- Escribiríamos el contenido Lua aquí
		return script
	end
	
	-- GameConfig
	local gcScript = Instance.new("LocalScript")
	gcScript.Name = "GameConfig"
	gcScript.Parent = shared
	
	-- Remotes
	local remotesScript = Instance.new("LocalScript")
	remotesScript.Name = "Remotes"
	remotesScript.Parent = shared
	
	-- PetData
	local petDataScript = Instance.new("LocalScript")
	petDataScript.Name = "PetData"
	petDataScript.Parent = shared
	
	-- Rewards
	local rewardsScript = Instance.new("LocalScript")
	rewardsScript.Name = "Rewards"
	rewardsScript.Parent = shared
end

-- 3. Configurar ServerScriptService
local function setupServerScriptService()
	local petRushServer = Instance.new("Folder")
	petRushServer.Name = "PetRushServer"
	petRushServer.Parent = ServerScriptService
	
	local systems = Instance.new("Folder")
	systems.Name = "Systems"
	systems.Parent = petRushServer
	
	-- Scripts principales y sistemas
	local function createServerScript(scriptName, path)
		local script = Instance.new("Script")
		script.Name = scriptName
		script.Parent = systems
		-- Ruta al archivo Lua correspondiente
		return script
	end
	
	local mainScript = Instance.new("Script")
	mainScript.Name = "Main"
	mainScript.Parent = petRushServer
	
	createServerScript("PlayerData", "PlayerData.server.luau")
	createServerScript("Collectibles", "Collectibles.server.luau")
	createServerScript("Pets", "Pets.server.luau")
	createServerScript("Shop", "Shop.server.luau")
	createServerScript("Levels", "Levels.server.luau")
	createServerScript("Zones", "Zones.server.luau")
end

-- 4. Configurar StarterPlayer
local function setupStarterPlayer()
	local playerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")
	local petRushClient = Instance.new("Folder")
	petRushClient.Name = "PetRushClient"
	petRushClient.Parent = playerScripts
	
	local controllers = Instance.new("Folder")
	controllers.Name = "Controllers"
	controllers.Parent = petRushClient
	
	-- ClientMain
	local clientMain = Instance.new("LocalScript")
	clientMain.Name = "ClientMain"
	clientMain.Parent = petRushClient
	
	-- Controladores HUD
	local hudController = Instance.new("LocalScript")
	hudController.Name = "HUDController"
	hudController.Parent = controllers
	
	-- CollectController
	local collectController = Instance.new("LocalScript")
	collectController.Name = "CollectController"
	collectController.Parent = controllers
	
	-- PetFollowController
	local petFollowController = Instance.new("LocalScript")
	petFollowController.Name = "PetFollowController"
	petFollowController.Parent = controllers
	
	-- ShopController
	local shopController = Instance.new("LocalScript")
	shopController.Name = "ShopController"
	shopController.Parent = controllers
	
	-- FeedbackController
	local feedbackController = Instance.new("LocalScript")
	feedbackController.Name = "FeedbackController"
	feedbackController.Parent = controllers
end

-- Ejecutar todas las configuraciones
createMapStructure()
setupReplicatedStorage()
setupServerScriptService()
setupStarterPlayer()

print("Estructura de Pet Rush! creada en Studio")