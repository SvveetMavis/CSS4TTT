if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "ar2"

if CLIENT then
    SWEP.PrintName = "AUG"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_aug"

end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.Delay = 0.09
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Damage = 14
SWEP.Primary.Cone = 0.022
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Sound = Sound("Weapon_AUG.Single")
SWEP.DeploySpeed = 0.8
SWEP.HeadshotMultiplier = 2
SWEP.Secondary.Sound = Sound("Default.Zoom")

SWEP.AutoSpawnable = true
SWEP.Spawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_aug.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_aug.mdl")
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(5, -15, -2)
SWEP.IronSightsAng = Vector(2.6, 1.37, 3.5)

function SWEP:SetZoom(state)
    if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
        if state then
            self:GetOwner():SetFOV(20, 0.3)
        else
            self:GetOwner():SetFOV(0, 0.2)
        end
    end
end

---
-- Add some zoom to ironsights for this gun
-- @ignore
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self:GetNextSecondaryFire() > CurTime() then return end
    
    local bIronsights = not self:GetIronsights()
    
    self:SetIronsights(bIronsights)
    
    self:SetZoom(bIronsights)
    
    if (CLIENT) then
        self:EmitSound(self.Secondary.Sound)
    end
    
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

if CLIENT then
    local scope = surface.GetTextureID("sprites/scope")

    ---
    -- @ignore
    function SWEP:DrawHUD()
        if self:GetIronsights() then
            surface.SetDrawColor(0, 0, 0, 255)

            local scrW = ScrW()
            local scrH = ScrH()

            local x = 0.5 * scrW
            local y = 0.5 * scrH
            local scope_size = scrH

            -- crosshair
            local gap = 80
            local length = scope_size

            surface.DrawLine(x - length, y, x - gap, y)
            surface.DrawLine(x + length, y, x + gap, y)
            surface.DrawLine(x, y - length, x, y - gap)
            surface.DrawLine(x, y + length, x, y + gap)

            gap = 0
            length = 50

            surface.DrawLine(x - length, y, x - gap, y)
            surface.DrawLine(x + length, y, x + gap, y)
            surface.DrawLine(x, y - length, x, y - gap)
            surface.DrawLine(x, y + length, x, y + gap)

            -- cover edges
            local sh = 0.5 * scope_size
            local w = x - sh + 2

            surface.DrawRect(0, 0, w, scope_size)
            surface.DrawRect(x + sh - 2, 0, w, scope_size)

            -- cover gaps on top and bottom of screen
            surface.DrawLine(0, 0, scrW, 0)
            surface.DrawLine(0, scrH - 1, scrW, scrH - 1)

            surface.SetDrawColor(255, 0, 0, 255)
            surface.DrawLine(x, y, x + 1, y + 1)

            -- scope
            surface.SetTexture(scope)
            surface.SetDrawColor(255, 255, 255, 255)

            surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
        else
            return BaseClass.DrawHUD(self)
        end
    end

    ---
    -- @ignore
    function SWEP:AdjustMouseSensitivity()
        return self:GetIronsights() and 0.3 or nil
    end
end
hook.Add("TTTPlayerSpeedModifier", "AugSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_aug" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.9
      else
        return 0.9
      end
    end
end )
