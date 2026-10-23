-- PetData.luau
-- Datos y configuración de mascotas
-- Disponible en ReplicatedStorage/Shared

type PetInfo = {
	Name: string,
	Color: string,
	Rarity: string, -- Common, Uncommon, Rare, Legendary
	WalkSpeedMultiplier: number,
	FollowRange: number,
}

local PetData = {}

-- Configuración de todas las mascotas
PetData.AllPets = {
	Perro = {
		Name = "Perro",
		Color = "Neon Yellow",
		Rarity = "Common",
		WalkSpeedMultiplier = 1.0,
		FollowRange = 20,
	},
	Gato = {
		Name = "Gato",
		Color = "Neon Pink",
		Rarity = "Common",
		WalkSpeedMultiplier = 1.0,
		FollowRange = 20,
	},
	Conejo = {
		Name = "Conejo",
		Color = "Neon Blue",
		Rarity = "Uncommon",
		WalkSpeedMultiplier = 1.1,
		FollowRange = 25,
	},
	Pinguino = {
		Name = "Pinguino",
		Color = "Neon Cyan",
		Rarity = "Rare",
		WalkSpeedMultiplier = 1.15,
		FollowRange = 30,
	},
	Dragón = {
		Name = "Dragón",
		Color = "Neon Red",
		Rarity = "Legendary",
		WalkSpeedMultiplier = 1.2,
		FollowRange = 35,
	},
}

-- Mascotas desbloqueadas por defecto al empezar
function PetData.GetStartingPets(): {PetInfo}
	local Config = require(game.ReplicatedStorage.Shared.GameConfig)
	local startingPets: {PetInfo} = {}
	
	for name, info in pairs(Config.StartingPets) do
		local petInfo = PetData.AllPets[name]
		if petInfo then
			table.insert(startingPets, petInfo)
		else
-- Si la mascota no está en la tabla completa, crear una básica
			table.insert(startingPets, {
				Name = name,
				Color = info.Color,
				Rarity = info.Rarity,
				WalkSpeedMultiplier = 1.0,
				FollowRange = 20,
			})
		end
	end
	
	return startingPets
end

-- Obtener información de una mascota por nombre
function PetData.GetPetInfo(petName: string): PetInfo
	local pet = PetData.AllPets[petName]
	if pet then
		return pet
	end
	
-- Retornar mascota por defecto si no existe
	return {
		Name = petName,
		Color = "White",
		Rarity = "Common",
		WalkSpeedMultiplier = 1.0,
		FollowRange = 20,
	}
end

-- Verificar si una mascota está desbloqueada (en datos del jugador)
function PetData.IsUnlocked(player: Player, petName: string): boolean
	local data = require(game.ServerScriptService:WaitForChild("Systems").PlayerData)
	local unlocked = data.Get(player, "Pets") or {}
	
	for _, name in pairs(unlocked) do
		if name == petName then
			return true
		end
	end
	
	return false
end

-- Verificar si una mascota es elegible para ser mascota inicial
function PetData.IsStartingPet(petName: string): boolean
	local Config = require(game.ReplicatedStorage.Shared.GameConfig)
	return Config.StartingPets[petName] ~= nil
end

return PetData