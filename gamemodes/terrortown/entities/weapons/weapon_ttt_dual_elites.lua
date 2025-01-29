if SERVER then
	AddCSLuaFile()
else
	LANG.AddToLanguage("english", "dual_elites_name", "Dual Elites")

	SWEP.PrintName = "dual_elites_name"
	SWEP.Slot = 1
	SWEP.Icon = "vgui/ttt/icon_dual_elites"
	SWEP.UseHands = true
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54
end


SWEP.Base = "weapon_tttbase"


SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Delay = 0.10
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Cone = 0.065
SWEP.Primary.Damage = 14
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 24
SWEP.Primary.ClipMax = 48
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Sound = Sound("Weapon_Elite.Single")
SWEP.idleResetFix = true
SWEP.DeploySpeed = 1.1
SWEP.HeadshotMultiplier = 2

SWEP.HoldType = "duel"
SWEP.ViewModel  = Model("models/weapons/cstrike/c_pist_elite.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_elite.mdl")


SWEP.Kind = WEAPON_PISTOL


SWEP.AutoSpawnable = true
SWEP.spawnType = WEAPON_TYPE_PISTOL

SWEP.AmmoEnt = "item_ammo_pistol_ttt"


SWEP.AllowDrop = true


SWEP.IsSilent = false


SWEP.NoSights = true

local leftShoot = false
local sparkle = CLIENT and CreateConVar("ttt_crazy_sparks", "0", FCVAR_ARCHIVE)

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if not self:CanPrimaryAttack() then
        return
    end

    self:EmitSound(self.Primary.Sound)

	if leftShoot then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		leftShoot = false
	else
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		leftShoot = false
	end

    self:TakePrimaryAmmo(1)
	
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

    local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
	
	if (game.SinglePlayer() and SERVER) or CLIENT then
        self:SetNWFloat("LastShootTime", CurTime())
    end

	if (IsValid(owner) and not owner:IsNPC() and owner.ViewPunch) then
		owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))
	end
end


function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if not self:CanPrimaryAttack() then
        return
    end

    self:EmitSound(self.Primary.Sound)

	if leftShoot then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		leftShoot = true
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		leftShoot = true
	end

    self:TakePrimaryAmmo(1)
	
	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

    local owner = self:GetOwner()
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
	
	if (game.SinglePlayer() and SERVER) or CLIENT then
        self:SetNWFloat("LastShootTime", CurTime())
    end

	if (IsValid(owner) and not owner:IsNPC() and owner.ViewPunch) then
		owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))
	end
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self:GetOwner():GetShootPos()
   bullet.Dir    = self:GetOwner():GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 4
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = 10
   bullet.Damage = dmg
   if CLIENT and sparkle:GetBool() then
      bullet.Callback = Sparklies
   end

   self:GetOwner():FireBullets( bullet )

   -- Owner can die after firebullets
   if (not IsValid(self:GetOwner())) or self:GetOwner():IsNPC() or (not self:GetOwner():Alive()) then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end

hook.Add("TTTPlayerSpeedModifier", "DualSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_dual_elites" then
      if TTT2 then
        noLag[1] = noLag[1] * 1.2
      else
        return 1.2
      end
    end
end )
