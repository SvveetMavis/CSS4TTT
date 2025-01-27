if SERVER then
    AddCSLuaFile()
end

SWEP.HoldType = "smg"

if CLIENT then
    SWEP.PrintName = "MP7"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_smg"
    SWEP.IconLetter = "l"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.Damage = 9
SWEP.Primary.Delay = 0.05
SWEP.Primary.Cone = 0.040
SWEP.Primary.ClipSize = 20
SWEP.Primary.ClipMax = 40
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Recoil = 1.15
SWEP.Primary.Sound = Sound("Weapon_SMG1.Single")
SWEP.DeploySpeed = 0.9
SWEP.HeadshotMultiplier = 1.8

SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/c_smg1.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg1.mdl")
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-6.39, -3.32, 1.05)



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

function SWEP:Reload()
    if (self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0) then return end
    self:DefaultReload(self.ReloadAnim)
    self:EmitSound("Weapon_SMG1.Reload")
    self:SetIronsights(false)
end
