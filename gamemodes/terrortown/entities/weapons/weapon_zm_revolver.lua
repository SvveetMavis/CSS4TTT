if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "revolver"

if CLIENT then
    SWEP.PrintName = "Deagle"
    SWEP.Slot = 1

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_deagle"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_DEAGLE
SWEP.spawnType = WEAPON_TYPE_PISTOL

SWEP.Primary.Ammo = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil = 7
SWEP.Primary.Damage = 37
SWEP.Primary.Delay = 0.7
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 7
SWEP.Primary.ClipMax = 14
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Sound = Sound("Weapon_Deagle.Single")
SWEP.DeploySpeed = 0.9

SWEP.HeadshotMultiplier = 2.703

SWEP.AutoSpawnable = true
SWEP.Spawnable = true
SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-6.361, -3.701, 2.15)
SWEP.IronSightsAng = Vector(0, 0, 0)
