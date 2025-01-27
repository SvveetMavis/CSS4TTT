AddCSLuaFile()

if CLIENT then
   SWEP.PrintName = "Magnum"
   SWEP.Slot = 2
   SWEP.Icon = "vgui/ttt/icon_revolver"
end

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "revolver"

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Delay = 1.4
SWEP.Primary.Recoil = 16
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 65
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 12
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Sound = Sound( "Weapon_357.Single" )
SWEP.HeadshotMultiplier    = 3.8463
SWEP.DeploySpeed = 0.90
SWEP.Primary.SoundLevel    = 150

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 56
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel	= "models/weapons/w_357.mdl"

SWEP.IronSightsPos = Vector ( -4.7, -3.96, 0.5 )
SWEP.IronSightsAng = Vector ( 0.214, -0.25, 1.9 )

SWEP.Kind = WEAPON_PISTOL

SWEP.AutoSpawnable = true

SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.AllowDrop = true

SWEP.IsSilent = false

SWEP.NoSights = false

hook.Add("TTTPlayerSpeedModifier", "MagSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_magnum" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.9
      else
        return 0.9
      end
    end
end )
