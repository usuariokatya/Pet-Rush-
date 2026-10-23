-- PetFollowController.client.luau
-- Controlador para la mascota que sigue al jugador
-- Ubicación: StarterPlayer/StarterPlayerScripts/Controllers/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local PetFollow = {}

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Referencias a datos del jugador
local PlayerData = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Shared"):WaitForChild("PetData")
local Remotes = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Remotes")

-- Variable para rastrear la mascota equipada
local equippedPet = PlayerData.Get and PlayerData.Get(Player, "EquippedPet") or ""
local currentPetModel = nil

-- Tabla de mascotas disponibles (para referencia visual)
local PetColors = {
	Perro = Color3.fromRGB(255, 255, 0), -- Neon Yellow
	Gato = Color3.fromRGB(255, 180, 200), -- Neon Pink
	Conejo = Color3.fromRGB(100, 180, 255), -- Neon Blue
	Pinguino = Color3.fromRGB(0, 255, 255), -- Neon Cyan
	Dragón = Color3.fromRGB(255, 50, 50), -- Neon Red
}

-- Función para crear la parte de seguimiento de la mascota
function PetFollow.CreatePetPart(petName)
	-- Verificar si ya existe una mascota
	if currentPetModel then
		currentPetModel:Destroy()
	end
	
	local petInfo = PetData.AllPets and PetData.AllPets[petName] or {Color = "Yellow"}
	local color = PetColors[petName] or Color3.new(1, 1, 1)
	
	-- Crear una parte transparente que sigue al jugador
	local petPart = Instance.new("Part")
	petPart.Name = "Follower_" .. petName
	petPart.Anchored = false
	petPart.CanCollide = false
	petPart.Size = Vector3.new(1, 1, 1)
	petPart.Transparency = 0.6
	petPart.Color = color
	petPart.CanTouch = false
	petPart.Parent = Workspace
	
-- Agregar Billboard para nombre
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.StudsPerPixel = 100
	billboard.Adornee = petPart
	billboard.AlwaysOnTop = true
	billboard.Parent = petPart
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = petName
	textLabel.TextColor3 = color
	textLabel.TextSize = 14
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = billboard
	
-- Almacenar referencia
	currentPetModel = petPart
	
-- Iniciar bucle de seguimiento
	PetFollow.StartFollowing(petPart)
	
	return petPart
end

-- Bucle para que la mascota siga al jugador
function PetFollow.StartFollowing(petPart)
	task.spawn(function()
		while petPart and petPart.Parent and petPart.Name:find("Follower") do
			-- Obtener posición del personaje
			local targetPosition = HumanoidRootPart.Position + Vector3.new(0, 3, 0)
			
-- Mover la mascota hacia el jugador
			local distance = (targetPosition - petPart.Position).Magnitude
			
			if distance > 10 then -- Si está lejos, moverse
				local moveSpeed = 8
				local direction = (targetPosition - petPart.Position).Unit
				petPart.Position = petPart.Position + (direction * moveSpeed * task.wait())
			end
			
-- Mantener cerca del jugador
			if distance < 5 then
				petPart.Position = targetPosition - (direction * 3)
			end
			
			task.wait(0.1)
		end
	end)
end

-- Función para equipar una mascota
function PetEquipPet(petName)
-- Verificar si la mascota está desbloqueada
local isUnlocked = false
if PlayerData.Get then
	local pets = PlayerData.Get(Player, "Pets") or {}
	for _, name in pairs(pets) do
		if name == petName then
			isUnlocked = true
			break
		end
	end
end
	
	if not isUnlocked then
	-- Solicitar desbloqueo al servidor
		local Remotes = ReplicatedStorage:WaitForChild("PetRush"):WaitForChild("Remotes")
		Remotes.Client.OnEquipPet:FireServer(petName)
	end
	
-- Crear la parte de la mascota
	PetFollow.CreatePetPart(petName)
	
-- Actualizar datos del jugador
	if PlayerData.Set then
		PlayerData.Set(Player, "EquippedPet", petName)
	end
	
	print("Mascota equipada: " .. petName)
end

-- Conectar cuando el personaje del jugador cambia
Player.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	Humanoid = newCharacter:WaitForChild("Humanoid")
	HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
	
-- Reiniciar posición de la mascota
	if currentPetModel then
		currentPetModel.Position = HumanoidRootPart.Position + Vector3.new(0, 3, 0)
	end
end)

-- Escucha para equipar mascota desde el servidor
Remotes.Client.OnEquipPet.OnServerEvent:Connect(function(petName)
	PetFollow.PetEquipPet(petName)
end)

print("PetFollowController inicializado")
return PetFollow