if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "revolver"

if CLIENT then
    SWEP.PrintName = "P228"
    SWEP.Slot = 1

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_p228"

end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_PISTOL
SWEP.spawnType = WEAPON_TYPE_PISTOL

SWEP.Primary.Recoil = 0.5
SWEP.Primary.Damage = 24
SWEP.Primary.Delay = 0.42
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 12
SWEP.Primary.ClipMax = 20
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = Sound("Weapon_P228.Single")
SWEP.DeploySpeed = 1.2
SWEP.HeadshotMultiplier    = 2

SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_p228.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_p228.mdl")
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-5.961, -9.214, 2.839)
SWEP.IronSightsAng = Vector(-0.2, 0.09, 0.4)

hook.Add("TTTPlayerSpeedModifier", "P2Speed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_p228" then
      if TTT2 then
        noLag[1] = noLag[1] * 1.2
      else
        return 1.2
      end
    end
end )
