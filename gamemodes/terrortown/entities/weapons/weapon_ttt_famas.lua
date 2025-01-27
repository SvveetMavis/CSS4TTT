AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "FAMAS"
    SWEP.Slot = 2
    SWEP.Icon = "vgui/ttt/icon_famas"
end

SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "ar2"

SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Delay = 0.7
SWEP.Primary.Recoil = 0.25
SWEP.Primary.Cone = 0.024
SWEP.Primary.Damage = 23
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 15
SWEP.HeadshotMultiplier    = 2
SWEP.Primary.ClipMax = 30
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Sound = Sound("Weapon_FAMAS.Single")
SWEP.DeploySpeed = 0.8
SWEP.spawnType = WEAPON_TYPE_HEAVY

SWEP.Primary.BurstShots = 3 -- Number of bullets shot each burst.
SWEP.Primary.BurstInbetweenDelay = 0.10 -- The delay that's inbetween each shot of a burst.
SWEP.Primary.BurstDelay = 0.6 -- The delay between each burst.

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_famas.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_famas.mdl")

SWEP.IronSightsPos         = Vector(-6.40, 8, 1.35)
SWEP.IronSightsAng         = Vector(0, -0.45, -1.3)

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.InLoadoutFor = {nil}
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false


local function ClearNetVars(self)
	self:SetIronsights(false)
	self:SetBurstFiring(false)
	self:SetReloadEndTime(0.0)
	self:SetBurstShotsFired(0)
	self:SetBurstShotEndTime(0.0)
end

function SWEP:OnDrop()
	ClearNetVars(self)
end

function SWEP:Deploy()
	ClearNetVars(self)
	return true
end

function SWEP:SetupDataTables()
	-- Set to "0.0" if not reloading. Set to "Current time + (reload animation length)" when reloading.
	self:NetworkVar("Float", 0, "ReloadEndTime")
	-- Set to "true" if the "SWEP:Think()" function needs to do a burst fire.
	self:NetworkVar("Bool",  0, "BurstFiring")
	-- The number of shots already fired during the current burst. "0" no shots have been shot yet.
	self:NetworkVar("Int",   0, "BurstShotsFired")
	-- The time that the current shot being fired in the burst will be finished.
	self:NetworkVar("Float", 1, "BurstShotEndTime")
	
	self.BaseClass.SetupDataTables(self)
end

function SWEP:GetRandomViewpunchAngle()
	local recoil = self.Primary.Recoil
	local pitch  = math.Rand(-0.2, -0.1)
	local yaw    = math.Rand(-0.1,  0.1)
	local roll   = 0 --math.Rand(-0.3,  0.3) -- Roll is fun.

	return Angle(pitch * recoil, yaw * recoil, roll)
end


function SWEP:Reload()
    if (self:Clip1() == self.Primary.ClipSize or
        self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0) then
       return
    end
    self:DefaultReload(ACT_VM_RELOAD)
    self:SetIronsights(false)
    self:SetZoom(false)
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   local sights = self:GetIronsights()
 
   numbul = numbul or 1
   cone   = cone   or 0.035
 
   -- 35% accuracy bonus when sighting
   cone = sights and (cone * 0.65) or cone
 
   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self:GetOwner():GetShootPos()
   bullet.Dir    = self:GetOwner():GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 3
   bullet.Force  = 4
   bullet.Damage = dmg


 
   self:GetOwner():FireBullets( bullet )
   self:SendWeaponAnim(self.PrimaryAnim)
 
   -- Owner can die after firebullets, giving an error at muzzleflash
   if not IsValid(self:GetOwner()) or not self:GetOwner():Alive() then return end
 
   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
 
   if self:GetOwner():IsNPC() then return end
 
   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted() )) then
 
      recoil = sights and (recoil * 0.35) or recoil -- 0.35 recoil mulitplier when aiming down sights
 
      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
 
   end
end

---Burst fire function start
function SWEP:Think()
	self.BaseClass.Think(self)
	-- Deal with reloading shit.
	if self:GetReloadEndTime() ~= 0.0 then
		if self:GetReloadEndTime() <= CurTime() then
			self:SetReloadEndTime(0.0)
		else -- Still reloading, so let's return.
			return
		end
	end

	if not self:GetBurstFiring() then return end

	-- If not shot has been fired (BurstShotEndTime = 0.0) or our current
	-- shot's end-time has been passed.
	if self:GetBurstShotEndTime() <= CurTime() then
		local shotsFired = self:GetBurstShotsFired()
		if shotsFired >= self.Primary.BurstShots then
			-- Since we've fired all of our shots, we clean up.
			self:SetBurstShotsFired(0)
			self:SetBurstShotEndTime(0.0)
			self:SetBurstFiring(false)
			-- Delay until the next burst.
			self:SetNextSecondaryFire(CurTime() + self.Primary.BurstDelay)
			self:SetNextPrimaryFire(CurTime() + self.Primary.BurstDelay)
		elseif self:CanPrimaryAttack() then -- We still have shots to fire.
			self:FireShot()
			self:SetBurstShotsFired(shotsFired + 1)
			self:SetBurstShotEndTime(CurTime() + self.Primary.BurstInbetweenDelay)
		end
	end
end

function SWEP:PrimaryAttack(worldsnd)
	-- Let the "SWEP:Think()" function deal with the burst firing.
	if self:GetBurstFiring() then return end

	-- *click*
	if not self:CanPrimaryAttack() then
		self:SetNextSecondaryFire(CurTime() + self.Primary.BurstDelay)
		self:SetNextPrimaryFire(CurTime() + self.Primary.BurstDelay)
		return
	end

	self:SetBurstFiring(true)
end

-- This is basically the default TTT SWEP:PrimaryAttack() function.
function SWEP:FireShot(worldsnd)
	if not self:CanPrimaryAttack() then return end

	-- No idea where "worldsnd" is retrieved from...
	if not worldsnd then
		self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end

	self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())
	self:TakePrimaryAmmo(1)

	local owner = self.Owner
	if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

	owner:ViewPunch(self:GetRandomViewpunchAngle())
end

function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self:GetNextSecondaryFire() > CurTime() then return end

    local bIronsights = not self:GetIronsights()

    self:SetIronsights( bIronsights )

    if SERVER then
        self:SetZoom(bIronsights)
	end

    self:SetNextSecondaryFire( CurTime() + 0.3)
end

---Burst fire function end

function SWEP:SetZoom(state)
    if CLIENT then
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(64, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom( false )
    return true
end

function SWEP:PreDrop()
    self:SetIronsights(false)
    self:SetZoom( false )
    return self.BaseClass.PreDrop(self)
end

hook.Add("TTTPlayerSpeedModifier", "FamSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_famas" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.9
      else
        return 0.9
      end
    end
end )

