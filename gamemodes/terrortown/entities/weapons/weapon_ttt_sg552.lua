AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Commando-52"
    SWEP.Slot = 2
    SWEP.Icon = "vgui/ttt/icon_sg552"
end

SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "ar2"

SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Delay = 0.12
SWEP.Primary.DelayScoped = 1.35
SWEP.Primary.Recoil = 2.34
SWEP.Primary.Cone = 0.075
SWEP.Primary.Damage = 21
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 15
SWEP.Primary.ClipMax = 15
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Sound = Sound("Weapon_SG552.Single")
SWEP.Secondary.Sound = Sound("Default.Zoom")
SWEP.DeploySpeed = 0.75 -- new value: takes more time to deploy
SWEP.HeadshotMultiplier = 2

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 56
SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_sg552.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_sg552.mdl")

SWEP.IronSightsPos = Vector(5, -15, -2)
SWEP.IronSightsAng = Vector(2.6, 1.37, 3.5)

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.InLoadoutFor = {nil}
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false

function SWEP:SetZoom(state)
    if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
        if state then
            self:GetOwner():SetFOV(20, 0.3)
        else
            self:GetOwner():SetFOV(0, 0.2)
        end
    end
end

function SWEP:PrimaryAttack(worldsnd)
    self.BaseClass.PrimaryAttack(self.Weapon, worldsnd)
    self:SetNextSecondaryFire(CurTime() + 0.1)
	local dIronsights = self:GetIronsights()
	local ddelay
	if dIronsights then
		ddelay = self.Primary.DelayScoped
	else
		ddelay = self.Primary.Delay
	end
	
	self:SetNextPrimaryFire( CurTime() + ddelay )
end

-- Add some zoom to ironsights for this gun
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

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   local sights = self:GetIronsights()
 
   numbul = numbul or 1
   cone   = cone   or 0.02
 

   cone = sights and (cone * 0.17) or cone
 
   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self:GetOwner():GetShootPos()
   bullet.Dir    = self:GetOwner():GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.Force  = 2
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
 
      recoil = sights and (recoil * 0.75) or recoil -- 0.75 recoil mulitplier when aiming down sights
 
      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
 
   end
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
	local att = dmginfo:GetAttacker()
	if not IsValid(att) then
		return 1.3
	end

	local dist = victim:GetPos():Distance(att:GetPos())

	local dIronsights = self:GetIronsights()
	
	if dIronsights and (dist > 700) then --scoped headshot from long range does way more damage
		return 4
	elseif dIronsights and (dist > 200) then --scoped headshot from medium range does extra damage
		return 2.5
	else
		return 1.4
	end
		
end


function SWEP:Reload()
    if (self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0) then return end
    self:DefaultReload(ACT_VM_RELOAD)
    self:SetIronsights(false)
    self:SetZoom(false)
end

function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

if CLIENT then
    local scope = surface.GetTextureID("sprites/scope")
    function SWEP:DrawHUD()
        if self:GetIronsights() then
            surface.SetDrawColor(0, 0, 0, 255)
            
            local scrW = ScrW()
            local scrH = ScrH()
            
            local x = scrW / 2.0
            local y = scrH / 2.0
            local scope_size = scrH
            
            -- Crosshair
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
            
            -- Cover edges
            local sh = scope_size / 2
            local w = (x - sh) + 2
            surface.DrawRect(0, 0, w, scope_size)
            surface.DrawRect(x + sh - 2, 0, w, scope_size)
            
            -- Cover gaps on top and bottom of screen
            surface.DrawLine(0, 0, scrW, 0)
            surface.DrawLine(0, scrH - 1, scrW, scrH - 1)
            
            surface.SetDrawColor(255, 0, 0, 255)
            surface.DrawLine(x, y, x + 1, y + 1)
            
            -- Scope
            surface.SetTexture(scope)
            surface.SetDrawColor(255, 255, 255, 255)
            
            surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
        else
            return self.BaseClass.DrawHUD(self)
        end
    end
    
    function SWEP:AdjustMouseSensitivity()
        return (self:GetIronsights() and 0.2) or nil
    end
end

hook.Add("TTTPlayerSpeedModifier", "SGSpeed" , function(ply, _, _, noLag )
    local wep=ply:GetActiveWeapon()
    if wep and IsValid(wep) and wep:GetClass()=="weapon_ttt_sg552" then
      if TTT2 then
        noLag[1] = noLag[1] * 0.9
      else
        return 0.9
      end
    end
end )
