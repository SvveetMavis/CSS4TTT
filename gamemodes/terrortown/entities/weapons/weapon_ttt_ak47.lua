if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "ar2"

if CLIENT then
    SWEP.PrintName = "AK47"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_ak47"

end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.Delay = 0.12
SWEP.Primary.Recoil = 3.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Damage = 24
SWEP.Primary.Cone = 0.035
SWEP.Primary.ClipSize = 25
SWEP.Primary.ClipMax = 50
SWEP.Primary.DefaultClip = 25
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.DeploySpeed = 0.8
SWEP.HeadshotMultiplier = 2

SWEP.AutoSpawnable = true
SWEP.Spawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_ak47.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_ak47.mdl")
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-6.518, -4.646, 2.134)
SWEP.IronSightsAng = Vector(2.737, 0.158, 0)


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

hook.Add("TTTPlayerSpeedModifier", "AKSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_ak47" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.9
      else
        return 0.9
      end
    end
end )
