if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "revolver"

if CLIENT then
    SWEP.PrintName = "Five-Seven"
    SWEP.Slot = 1

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_pistol"
    SWEP.IconLetter = "u"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_PISTOL
SWEP.spawnType = WEAPON_TYPE_PISTOL

SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 25
SWEP.Primary.Delay = 0.38
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 10
SWEP.Primary.ClipMax = 20
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = Sound("Weapon_FiveSeven.Single")
SWEP.DeploySpeed = 1.2

SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-5.95, -4, 2.799)
SWEP.IronSightsAng = Vector(0, 0, 0)

hook.Add("TTTPlayerSpeedModifier", "FiveSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_zm_pistol" then
      if TTT2 then
        noLag[1] = noLag[1] * 1.2
      else
        return 1.2
      end
    end
end )
