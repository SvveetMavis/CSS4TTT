if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "revolver"

if CLIENT then
    SWEP.PrintName = "Glock"
    SWEP.Slot = 1

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_glock"
    SWEP.IconLetter = "c"
end

SWEP.Base = "weapon_tttbase"

SWEP.Primary.Recoil = 1.3
SWEP.Primary.Damage = 11
SWEP.Primary.Delay = 0.10
SWEP.Primary.Cone = 0.038
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 40
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = Sound("Weapon_Glock.Single")
SWEP.DeploySpeed = 1.2

SWEP.AutoSpawnable = true

SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_GLOCK
SWEP.spawnType = WEAPON_TYPE_PISTOL

SWEP.HeadshotMultiplier = 2

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-5.79, -3.9982, 2.8289)

hook.Add("TTTPlayerSpeedModifier", "GLockSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_glock" then
      if TTT2 then
        noLag[1] = noLag[1] * 1.3
      else
        return 1.3
      end
    end
end )
