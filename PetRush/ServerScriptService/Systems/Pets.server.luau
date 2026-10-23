-- Pets.server.luau
-- Módulo para gestionar mascotas que siguen al jugador y recogen objetos
-- Ejecutarse en ServerScriptService/Systems

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PetData = require(ReplicatedStorage.Shared.PetData)
local Collectibles = require(script.Parent.Parent.Parent.Parent .. ".Collectibles") -- Ruta relativa compleja, mejor ajustar

--[[
Nota: En un proyecto real, importar Collectibles requeriría una estructura de módulos
mejor definida. Por ahora, referencias básicas.
--]]

local Pets = {}

-- Tabla para rastrear mascotas seguidoras por jugador
local followParts = {}

-- Crear una parte de seguimiento para la mascota
function Pets.CreateFollowPart(player: Player, petName: string): Part
	local Config = require(ReplicatedStorage.Shared.GameConfig)
	local petInfo = PetData.GetPetInfo(petName)
	
	if not petInfo then
		warn("Información de mascota no encontrada: " .. petName)
		return nil
	end
	
	-- Creer una parte que representa a la mascota
	local followPart = Instance.new("Part")
	followPart.Name = "Pet_Follow_" .. petName
	followPart.Anchored = false
	followPart.CanCollide = false
	followPart.Size = Vector3.new(1, 1, 1)
	followPart.Transparency = 0.5
	followPart.Color = PetConfig.ColorFromName(petInfo.Color) or Color3.new(1, 1, 1)
	followPart.Parent = Workspace
	
	-- Agregar adornee para seguir al jugador
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.StudsPerPixel = 100
	billboard.Adornee = followPart
	billboard.AlwaysOnTop = true
	billboard.Parent = followPart
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = petInfo.Name .. " [" .. petInfo.Rarity .. "]"
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextSize = 12
	textLabel.Parent = billboard
	
-- Almacenar referencia
	followParts[player.UserId] = followPart
	
-- Conectar al bucle de actualización
	Pets.StartFollowing(player, followPart, petInfo)
	
	return followPart
end

-- Iniciar el bucle de seguimiento de la mascota
function Pets.StartFollowing(player: Player, followPart: Part, petInfo: table)
	-- Verificar que el jugador tiene un personaje
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	
	if not hrp then
		return
	end
	
	-- Bucle de actualización
	task.spawn(function()
		while followPart and followParts[player.UserId] == followPart do
			-- Mover la mascota hacia el jugador
			local distance = (hrp.Position - followPart.Position).Magnitude
			
			if distance > petInfo.FollowRange then
				-- Mover hacia el jugador a velocidad de mascota
				local speedMultiplier = petInfo.WalkSpeedMultiplier or 1.0
				local moveSpeed = 8 * speedMultiplier -- Velocidad base
				
				local direction = (hrp.Position - followPart.Position).Unit
				followPart.Position = followPart.Position + (direction * moveSpeed * task.wait())
			end
			
			-- Verificar objetos cercanos para recoger
			Collectibles.TryCollectNearby(player, followPart.Position)
			
			task.wait(0.1)
		end
	end)
	
	return true
end

-- Intentar recoger objetos cercanos
--[[
function Collectibles.TryCollectNearby(player, position)
	-- Buscar partes cercanas en el workspace
	local parts = Workspace:GetPartsInRegion3(Region3.new(position - Vector3.new(10, 10, 10), position + Vector3.new(10, 10, 10)))
	
	for _, part in pairs(parts) do
		if part.Name:find("Collectible") then
			-- Lógica de recogida simplificada
			-- En proyecto completo usaríamos el evento remoto
		end
	end
end
--]]

print("Módulo Pets.server.luau cargado - funcionalidad de mascotas disponible")

-- Nota: La creación real de mascotas y sus parts se hace desde el cliente
-- a través de RemoteEvents cuando el jugador las equipa

return Pets