if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "revolver"

if CLIENT then
    SWEP.PrintName = "Silenced USP"
    SWEP.Slot = 1

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "sipistol_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_silenced"
    SWEP.IconLetter = "a"
end

SWEP.Base = "weapon_tttbase"

SWEP.Primary.Recoil = 1.35
SWEP.Primary.Damage = 14
SWEP.Primary.Delay = 0.38
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 10
SWEP.Primary.ClipMax = 5
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Sound = Sound("Weapon_USP.SilencedShot")
SWEP.Primary.SoundLevel = 35
SWEP.DeploySpeed = 1.3
SWEP.HeadshotMultiplier = 6

SWEP.Kind = WEAPON_PISTOL
SWEP.CanBuy = { ROLE_TRAITOR } -- only traitors can buy
SWEP.WeaponID = AMMO_SIPISTOL

SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.IsSilent = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp_silencer.mdl"
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(-5.91, -4, 2.84)
SWEP.IronSightsAng = Vector(-0.5, 0, 0)

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED
SWEP.IdleAnim = ACT_VM_IDLE_SILENCED

---
--@ignore
function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
    return BaseClass.Deploy(self)
end

---
-- We were bought as special equipment, and we have an extra to give
--@ignore
function SWEP:WasBought(buyer)
    if IsValid(buyer) then -- probably already self:GetOwner()
        buyer:GiveAmmo(20, "Pistol")
    end
end

hook.Add("TTTPlayerSpeedModifier", "SipSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_sipistol" then
      if TTT2 then
        noLag[1] = noLag[1] * 1.2
      else
        return 1.2
      end
    end
end )
