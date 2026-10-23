-- GameConfig.luau
-- Configuración compartida para Pet Rush!
-- Todas las tablas son readonly desde el servidor para seguridad

type GameConfig = {
	-- Recompensas básicas
	Points: {
		CandyValue: number,
		CoinValue: number,
		EggReward: number, -- Valor base por huevo
	},
	
	-- XP por nivel
	Levels: {
		XPPerLevel: number, -- XP base necesario para nivel 1
		XPMultiplier: number, -- Multiplicador por cada nivel
	},
	
	-- Precios de mejoras
	Upgrades: {
		Speed: number, -- Precio de mejora de velocidad
		Radius: number, -- Precio de mejora alcance recogida
		CandyMultiplier: number, -- Precio de multiplicador caramelos
	},
	
	-- Mascotas iniciales
	StartingPets: {
		-- Nombres de mascotas iniciales
		["Perro"] = {
			Color: "Neon Yellow",
			Rarity: "Common",
		},
		["Gato"] = {
			Color: "Neon Pink", 
			Rarity: "Common",
		},
	},
	
	-- Tiempo de reaparición de objetos (en segundos)
	Respawn: {
		Min: number,
		Max: number,
	},
	
	-- Multiplicador máximo de combo
	Combo: {
		MaxMultiplier: number,
		TimeBeforeDecay: number, -- Segundos sin recoger para que el combo deca
	},
	
	-- Zonas y requisitos
	Zones: {
		["Pradera"] = {
			RequiredLevel: number,
			RequiredCoins: number,
			Multiplier: number, -- Multiplicador de recompensas
		},
		["Bosque Dulce"] = {
			RequiredLevel: number,
			RequiredCoins: number,
			Multiplier: number,
		},
		["Cueva Arcoíris"] = {
			RequiredLevel: number,
			RequiredCoins: number,
			Multiplier: number,
		},
	},
}

-- Configuración global
local Config: GameConfig = {
	-- Recompensas
	Points = {
		CandyValue = 1,
		CoinValue = 5,
		EggReward = 10,
	},
	
	-- XP por nivel
	Levels = {
		XPPerLevel = 100,
		XPMultiplier = 25, -- Cada nivel requiere 25 XP más que el anterior
	},
	
	-- Precios de mejoras
	Upgrades = {
		Speed = 100,
		Radius = 150,
		CandyMultiplier = 200,
	},
	
	-- Mascotas iniciales
	StartingPets = {
		Perro = {
			Color = "Neon Yellow",
			Rarity = "Common",
		},
		Gato = {
			Color = "Neon Pink",
			Rarity = "Common",
		},
		Conejo = {
			Color = "Neon Blue",
			Rarity = "Uncommon",
		},
		Pinguino = {
			Color = "Neon Cyan",
			Rarity = "Rare",
		},
		Dragón = {
			Color = "Neon Red",
			Rarity = "Legendary",
		},
	},
	
	-- Tiempo de reaparición
	Respawn = {
		Min = 5,
		Max = 10,
	},
	
	-- Combo
	Combo = {
		MaxMultiplier = 3,
		TimeBeforeDecay = 10,
	},
	
	-- Zonas
	Zones = {
		Pradera = {
			RequiredLevel = 1,
			RequiredCoins = 0,
			Multiplier = 1.0,
		},
		BosqueDulce = {
			RequiredLevel = 5,
			RequiredCoins = 500,
			Multiplier = 1.5,
		},
		CuevaArcoiris = {
			RequiredLevel = 10,
			RequiredCoins = 2000,
			Multiplier = 2.0,
		},
	},
}

return Config