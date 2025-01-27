if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "crossbow"

if CLIENT then
    SWEP.PrintName = "H.U.G.E-249"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_m249"
    SWEP.IconLetter = "z"
end

SWEP.Base = "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AutoSpawnable = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M249
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.Damage = 9
SWEP.Primary.Delay = 0.04
SWEP.Primary.Cone = 0.14
SWEP.Primary.ClipSize = 150
SWEP.Primary.ClipMax = 150
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AirboatGun"
SWEP.Primary.Recoil = 1.9
SWEP.Primary.Sound = Sound("Weapon_m249.Single")
SWEP.DeploySpeed = 0.6


SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.idleResetFix = true

SWEP.HeadshotMultiplier = 2

SWEP.IronSightsPos = Vector(-5.96, -5.119, 2.349)
SWEP.IronSightsAng = Vector(0, 0, 0)

hook.Add("TTTPlayerSpeedModifier", "HugeSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_zm_sledge" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.7
      else
        return 0.7
      end
    end
end )
