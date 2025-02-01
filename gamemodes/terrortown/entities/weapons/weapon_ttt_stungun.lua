---
-- @class SWEP
-- @section weapon_ttt_stungun

if SERVER then
    AddCSLuaFile()
end

function SWEP:Initialize()
	self:SetColor(Color(0, 255, 255))

	return self.BaseClass.Initialize(self)
end


SWEP.HoldType = "ar2"

if CLIENT then
    SWEP.PrintName = "Proto. UMP"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "ump_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_stungun"

end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_STUN
SWEP.CanBuy = { ROLE_DETECTIVE }
SWEP.LimitedStock = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.Primary.Damage = 7
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 25
SWEP.Primary.ClipMax = 40
SWEP.Primary.DefaultClip = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Recoil = 1.4
SWEP.Primary.Sound = Sound("Weapon_UMP45.Single")

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"

SWEP.IronSightsPos = Vector(-8.735, -10, 4.039)
SWEP.IronSightsAng = Vector(-1.201, -0.201, -2)

SWEP.HeadshotMultiplier = 2
SWEP.DeploySpeed = 0.8


if CLIENT then
    ---
    -- @ignore
    function SWEP:PreDrawViewModel()
        render.SetColorModulation(0, 1, 1)
    end
    function SWEP:ViewModelDrawn()
        render.SetColorModulation(1, 1, 1)
    end

end




---
-- @ignore
function SWEP:ShootBullet(dmg, recoil, numbul, cone)
    local owner = self:GetOwner()
    local sights = self:GetIronsights()

    numbul = numbul or 1
    cone = cone or 0.01

    -- 10% accuracy bonus when sighting
    cone = sights and (cone * 0.9) or cone

    local bullet = {}
    bullet.Num = numbul
    bullet.Src = owner:GetShootPos()
    bullet.Dir = owner:GetAimVector()
    bullet.Spread = Vector(cone, cone, 0)
    bullet.Tracer = 4
    bullet.Force = 5
    bullet.Damage = dmg

    bullet.Callback = function(att, tr, dmginfo)
        if SERVER or (CLIENT and IsFirstTimePredicted()) then
            local ent = tr.Entity
            if (not tr.HitWorld) and IsValid(ent) then
                local edata = EffectData()

                edata:SetEntity(ent)
                edata:SetMagnitude(1.6)
                edata:SetScale(1.6)

                util.Effect("TeslaHitBoxes", edata)

                if SERVER and ent:IsPlayer() then
                    local eyeang = ent:EyeAngles()

                    local j = 1
                    eyeang.pitch = math.Clamp(eyeang.pitch + math.Rand(-j, j), -90, 90)
                    eyeang.yaw = math.Clamp(eyeang.yaw + math.Rand(-j, j), -90, 90)
                    ent:SetEyeAngles(eyeang)
                end
            end
        end
    end

    owner:FireBullets(bullet)
    self:SendWeaponAnim(self.PrimaryAnim)

    -- Owner can die after firebullets, giving an error at muzzleflash
    if not IsValid(owner) or not owner:Alive() then
        return
    end

    owner:MuzzleFlash()
    owner:SetAnimation(PLAYER_ATTACK1)

    if owner:IsNPC() then
        return
    end

    if
        (game.SinglePlayer() and SERVER)
        or ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())
    then
        -- reduce recoil if ironsighting
        recoil = sights and (recoil * 0.75) or recoil

        local eyeang = owner:EyeAngles()
        eyeang.pitch = eyeang.pitch - recoil
        owner:SetEyeAngles(eyeang)
    end
end

hook.Add("TTTPlayerSpeedModifier", "ProtoSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_stungun" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.9
      else
        return 0.9
      end
    end
end )

