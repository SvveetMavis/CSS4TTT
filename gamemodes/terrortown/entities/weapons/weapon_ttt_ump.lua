if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "ar2"

if CLIENT then
     SWEP.PrintName = "UMP"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_ump"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.Delay = 0.15
SWEP.Primary.Recoil = 1.7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Damage = 21
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 20
SWEP.Primary.ClipMax = 40
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Sound = Sound("Weapon_UMP45.Single")
SWEP.DeploySpeed = 0.8
SWEP.HeadshotMultiplier = 2

SWEP.AutoSpawnable = true
SWEP.Spawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-8.8, -14.381, 2.589)
SWEP.IronSightsAng = Vector(2, -0.36, -2.5)

---
-- Add some zoom to ironsights for this gun
-- @ignore
function SWEP:SecondaryAttack()
    if not self.IronSightsPos or self:GetNextSecondaryFire() > CurTime() then
        return
    end

    local bIronsights = not self:GetIronsights()

    self:SetIronsights(bIronsights)
    self:SetZoom(bIronsights)

    self:SetNextSecondaryFire(CurTime() + 0.3)
end

---
-- @ignore
function SWEP:PreDrop()
    self:SetIronsights(false)
    self:SetZoom(false)

    return BaseClass.PreDrop(self)
end

---
-- @ignore
function SWEP:Reload()
    if
        self:Clip1() == self.Primary.ClipSize
        or self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0
    then
        return
    end

    self:DefaultReload(ACT_VM_RELOAD)

    self:SetIronsights(false)
    self:SetZoom(false)
end

---
-- @ignore
function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)

    return true
end

hook.Add("TTTPlayerSpeedModifier", "UMMSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_ump" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.9
      else
        return 0.9
      end
    end
end )
