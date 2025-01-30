if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "ar2"

if CLIENT then
    SWEP.PrintName = "M16"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 64

    SWEP.Icon = "vgui/ttt/icon_m16"
    SWEP.IconLetter = "w"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.Delay = 0.19
SWEP.Primary.Recoil = 1.9
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Damage = 23
SWEP.Primary.Cone = 0.038
SWEP.Primary.ClipSize = 15
SWEP.Primary.ClipMax = 30
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Sound = Sound("Weapon_M4A1.Single")
SWEP.DeploySpeed = 0.8
SWEP.HeadshotMultiplier = 2.7

SWEP.AutoSpawnable = true
SWEP.Spawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.idleResetFix = true

SWEP.IronSightsPos         = Vector(-7.677, -9.2, 0.55)
SWEP.IronSightsAng         = Vector(2.95, -1.4, -3.7)

---
-- @ignore
function SWEP:SetZoom(state)
    local owner = self:GetOwner()

    if not IsValid(owner) or not owner:IsPlayer() then
        return
    end

    if state then
        owner:SetFOV(62, 0.5)
    else
        owner:SetFOV(0, 0.2)
    end
end

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

hook.Add("TTTPlayerSpeedModifier", "MSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_m16" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.9
      else
        return 0.9
      end
    end
end )
