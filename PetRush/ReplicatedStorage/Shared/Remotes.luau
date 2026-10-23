-- Remotes.luau
-- Eventos remotos para sincronización cliente-servidor
-- Usar desde ReplicatedStorage/Shared

-- Eventos que el cliente puede invocar al servidor
local Remotes = {}

-- Evento: Notificar al servidor que se recogió un objeto
Remotes.OnCollect = Instance.new("RemoteEvent")
Remotes.OnCollect.Name = "OnCollect"
Remotes.OnCollect.Parent = game:GetService("ReplicatedStorage")

-- Evento: Comprar en la tienda
Remotes.OnPurchase = Instance.new("RemoteEvent")
Remotes.OnPurchase.Name = "OnPurchase"
Remotes.OnPurchase.Parent = game:GetService("ReplicatedStorage")

-- Evento: Equipar mascota
Remotes.OnEquipPet = Instance.new("RemoteEvent")
Remotes.OnEquipPet.Name = "OnEquipPet"
Remotes.OnEquipPet.Parent = game:GetService("ReplicatedStorage")

-- Evento: Desbloquear zona
Remotes.OnUnlockZone = Instance.new("RemoteEvent")
Remotes.OnUnlockZone.Name = "OnUnlockZone"
Remotes.OnUnlockZone.Parent = game:GetService("ReplicatedStorage")

-- Eventos que el servidor envía al cliente
-- Notificación de ganancias
Remotes.GainPoints = Instance.new("RemoteEvent")
Remotes.GainPoints.Name = "GainPoints"
Remotes.GainPoints.Parent = game:GetService("ReplicatedStorage")

Remotes.GainXP = Instance.new("RemoteEvent")
Remotes.GainXP.Name = "GainXP"
Remotes.GainXP.Parent = game:GetService("ReplicatedStorage")

Remotes.ShowCombo = Instance.new("RemoteEvent")
Remotes.ShowCombo.Name = "ShowCombo"
Remotes.ShowCombo.Parent = game:GetService("ReplicatedStorage")

Remotes.UnlockZone = Instance.new("RemoteEvent")
Remotes.UnlockZone.Name = "UnlockZone"
Remotes.UnlockZone.Parent = game:GetService("ReplicatedStorage")

Remotes.ShowPet = Instance.new("RemoteEvent")
Remotes.ShowPet.Name = "ShowPet"
Remotes.ShowPet.Parent = game:GetService("ReplicatedStorage")

-- Tableaux para acceso fácil
return {
	Client = {
		OnCollect = Remotes.OnCollect,
		OnPurchase = Remotes.OnPurchase,
		OnEquipPet = Remotes.OnEquipPet,
		OnUnlockZone = Remotes.OnUnlockZone,
	},
	Server = {
		GainPoints = Remotes.GainPoints,
		GainXP = Remotes.GainXP,
		ShowCombo = Remotes.ShowCombo,
		UnlockZone = Remotes.UnlockZone,
		ShowPet = Remotes.ShowPet,
	},
}