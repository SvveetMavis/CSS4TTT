if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "ar2"

if CLIENT then
    SWEP.PrintName = "Silenced TMP"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

     SWEP.Icon = "vgui/ttt/icon_tmp"
    SWEP.IconLetter = "l"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.Damage = 9
SWEP.Primary.Delay = 0.08
SWEP.Primary.Cone = 0.040
SWEP.Primary.ClipSize = 15
SWEP.Primary.ClipMax = 40
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Recoil = 1.15
SWEP.Primary.Sound = Sound("Weapon_SMG1.Single")
SWEP.DeploySpeed = 1.1
SWEP.HeadshotMultiplier = 5
SWEP.IsSilent = true

SWEP.AutoSpawnable = false
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/cstrike/c_smg_tmp.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg_tmp.mdl")
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector (-6.896, -10.653, 2.134)
SWEP.IronSightsAng = Vector (2.253, 0.209, 0.07)



---
-- @ignore
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
    local att = dmginfo:GetAttacker()

    if not IsValid(att) then
        return 2
    end

    local dist = victim:GetPos():Distance(att:GetPos())
    local d = math.max(0, dist - 150)

    -- decay from 3.2 to 1.7
    return 1.7 + math.max(0, 1.5 - 0.002 * (d ^ 1.25))
end


hook.Add("TTTPlayerSpeedModifier", "TMSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_siltmp" then
      if TTT2 then
        noLag[1] = noLag[1] * 1.1
      else
        return 1.1
      end
    end
end )
