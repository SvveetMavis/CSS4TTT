if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "revolver"

if CLIENT then
    SWEP.PrintName = "USP"
    SWEP.Slot = 1

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_usp"
 
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_PISTOL
SWEP.spawnType = WEAPON_TYPE_PISTOL

SWEP.Primary.Recoil = 1.35
SWEP.Primary.Damage = 21
SWEP.Primary.Delay = 0.39
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 10
SWEP.Primary.ClipMax = 20
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = Sound("weapons/usp/usp_unsil-1.wav")
SWEP.DeploySpeed = 1.2
SWEP.HeadshotMultiplier    = 2

SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands = true
SWEP.ViewModel		= "models/weapons/cstrike/c_pist_usp.mdl"	
SWEP.WorldModel		= "models/weapons/w_pist_usp.mdl"
SWEP.idleResetFix = true

SWEP.IronSightsPos         = Vector( -5.91, -4, 2.84 )
SWEP.IronSightsAng         = Vector(-0.5, 0, 0)

hook.Add("TTTPlayerSpeedModifier", "USSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_usp" then
      if TTT2 then
        noLag[1] = noLag[1] * 1.2
      else
        return 1.2
      end
    end
end )
