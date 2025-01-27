if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "ar2"

if CLIENT then
    SWEP.PrintName = "MP5 Navy"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_mp5"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.Damage = 21
SWEP.Primary.Delay = 0.075
SWEP.Primary.Cone = 0.09
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Recoil = 0.95
SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single")
SWEP.DeploySpeed = 0.9

SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/cstrike/c_smg_mp5.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg_mp5.mdl")
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-5.361, -7.381, 1.589)
SWEP.IronSightsAng = Vector(2, -0.03, -0.65)


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

