SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Combat Shotgun"
SWEP.Category = "DOOM"

SWEP.Primary.Damage = 6
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Ammo = "buckshot" --The ammo type will it use
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Spread = 1
SWEP.Primary.NumberofShots = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Force = 0.5

SWEP.Burst = {}
SWEP.Burst.Damage = 5
SWEP.Burst.Ammo = "buckshot" --The ammo type will it use
SWEP.Burst.Spread = 0.8
SWEP.Burst.NumberofShots = 10
SWEP.Burst.Recoil = 0.5
SWEP.Burst.Force = 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Spawnable = true

if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID( "hud/icons/weapons/doom/shotgun" )
end

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 40
SWEP.ViewModel			= "models/doom/weapons/shotgun/shotgun.mdl"
SWEP.WorldModel			= "models/doom/weapons/shotgun/shotgun_3rd.mdl"
SWEP.UseHands           = false

SWEP.PumpAnimations = {"shoot_delay","shoot_delay_alt1","shoot_delay_alt2","shoot_delay_alt3"}

SWEP.FirstDeploy = true
SWEP.IsEmpty = false

SWEP.Reticle = {}

SWEP.VMOffset = Vector() --Vector( 0.55, -8.5, -67 )

SWEP.IsDOOMWeapon = true

----------------------------------------------------------------------------------------------------
-- Weapon functions

function SWEP:OnInitialize()

	self:SetWeaponHoldType( "shotgun" )
	
	--[[if SERVER then
	
		self.StartLight1 = ents.Create( "light_dynamic" )
		self.StartLight1:SetKeyValue("brightness", "8")
		self.StartLight1:SetKeyValue("distance", "50")
		self.StartLight1:SetLocalPos( self:GetPos() )
		self.StartLight1:SetLocalAngles( self:GetAngles() )
		
		self.StartLight1:Fire("Color", "255 100 0")
		self.StartLight1:SetParent( self )
		self.StartLight1:Spawn()
		self.StartLight1:Activate()
		self.StartLight1:Fire( "SetParentAttachment", "muzzle_light" )
		self.StartLight1:Fire( "TurnOn" )
		self:DeleteOnRemove(self.StartLight1)
	
	end]]
	
	if CLIENT then
	
		self.Reticle = {}
		self.Reticle[0] = Material("hud/delay/MTR50.png", "noclamp transparent smooth" )
		self.Reticle[1] = Material("hud/reticle/sg/ret_1.png", "noclamp transparent smooth" )
		self.Reticle[2] = Material("hud/reticle/sg/ret_2.png", "noclamp transparent smooth" )
		self.Reticle[3] = Material("hud/reticle/sg/ret_3.png", "noclamp transparent smooth" )
		self.Reticle[4] = Material("hud/reticle/sg/ret_4.png", "noclamp transparent smooth" )
		self.Reticle[5] = Material("hud/reticle/ssg/ret_1.png", "noclamp transparent smooth" )
		self.Reticle[6] = Material("hud/reticle/sg/ret_6.png", "noclamp transparent smooth" )
		self.Reticle[7] = Material("hud/reticle/sg/ret_7.png", "noclamp transparent smooth" )
		self.Reticle[8] = Material("hud/reticle/sg/ret_8.png", "noclamp transparent smooth" )
		self.Reticle[9] = Material("hud/reticle/sg/ret_9.png", "noclamp transparent smooth" )
	
		self.Delay = {}
		for i = 1,50 do
			self.Delay[i] = Material("hud/delay/MTR"..i..".png", "noclamp transparent smooth" )
		end
	
	end
	
	self:SetActiveMod( false )
	self:SetSelectedMod( 0 )
	self:SetDelay( 0 )
	self:SetCharge( 0 )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )
	
	self:NetworkVar( "Int", 0, "SelectedMod" )
	self:NetworkVar( "Int", 1, "Charge" )
	
	self:NetworkVar( "Float", 0, "Delay" )

end

----------------------------------------------------------------------------------------------------
-- Think --

function SWEP:OnThink()
	
	if ( self:GetActiveMod() && !self:GetOwner():KeyDown( IN_ATTACK2 ) && self:GetNextSecondaryFire() < CurTime() ) then
	
		self:SetActiveMod( false )
		self:PlayVMSequence( "idle" )
		self:EmitSound( "doom/weapons/shotgun/shotgun_aim_out.ogg" )
		
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
		self:GetOwner():GetViewModel():SetSkin( 0 )
		
		self:GetOwner():SetFOV( 0, 0.2)
	
	end
	
	if self:GetDelay() > 0 then
	
		self:SetDelay( math.Approach( self:GetDelay(), 0, 0.4 ) )
	
	end
	
end

----------------------------------------------------------------------------------------------------
-- Deployment --

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	self:SetWeaponHoldType( "shotgun" )
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	
	local vm = self:GetOwner():GetViewModel()
	if self.FirstDeploy and self:Ammo1() > 0 then
		self:PlayVMSequence( "bringup_accent_pump" )
		self:EmitSoundWDelay( "doom/weapons/shotgun/shotgun_pull.ogg", nil, 99, nil, CHAN_AUTO, 0.8, true )
		self:EmitSoundWDelay( "doom/weapons/shotgun/shotgun_push.ogg", nil, 99, nil, CHAN_AUTO, 1, true )
		self.FirstDeploy = false
	else
		self:PlayVMSequence( "bringup" )
	end
	
	timer.Simple( 0.1, function()
	
		if !IsValid( self ) then return end
	
		if ( self:GetSelectedMod() == 1 ) then
			vm:SetBodygroup( 3, 1 )
			vm:SetBodygroup( 4, 0 )
		elseif ( self:GetSelectedMod() == 2 ) then
			vm:SetBodygroup( 3, 0 )
			vm:SetBodygroup( 4, 1 )
		end
		
		self:UpdateWMBodygroup()
	
	end)
	
	self.NextReload = CurTime()
	
	self:SetDelay( self:GetDelay() / 2 )
	
end

----------------------------------------------------------------------------------------------------
-- Primary attack

function SWEP:PrimaryAttack()

	if not IsFirstTimePredicted() then return end

	if self:Ammo1() < self.Primary.TakeAmmo then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:PlayVMSequence( "dryfire" )
		return 
	end
	
	self.Primary.Damage = GetConVar( "dredux_dmg_shotgun" ):GetInt() / 10
	self.IsPlayingIntroAnimation = false
	
	if self:GetActiveMod() then
	
		if self:GetSelectedMod() == 1 then self:GrenadeAttack() else self:TripleBurstAttack() end
		
	else
		
		self:GetOwner():SetFOV( 0, 0.2)
		
		self.MuzzleEffect = "dredux_muzzleflash_shotgun"
		self:MuzzleFlashEffect()
			
		self:TakePrimaryAmmo( self.Primary.TakeAmmo )
		self:BulletAttack()
		
		self:EmitSound( "doom/weapons/shotgun/shotgun_fire_"..math.random(5)..".ogg", nil, 96, nil, CHAN_WEAPON )

		self:PlayVMSequence( "shoot" )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		self:PlayVMSequenceWDelay( "shoot_delay", self:VMSequenceDuration() )

		-- Sounds

		self:EmitSoundWDelay( "doom/weapons/shotgun/shotgun_pull.ogg", nil, 99, 0.5, CHAN_AUTO, 0.25 )
		self:EmitSoundWDelay( "doom/weapons/shotgun/shotgun_push.ogg", nil, 99, 0.5, CHAN_AUTO, 0.45 )
		
		-- Recoil
		
		self.Owner:ViewPunch( Angle( -7, 0, 0 ) )
		
		-- Timers
		
		self:SetNextPrimaryFire( CurTime() + 0.62 )
		self:SetNextSecondaryFire( CurTime() + 0.62 )
		
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:GrenadeAttack()

	self:GetOwner():SetFOV( 0, 0.2 )

	self.MuzzleEffect = "dredux_muzzleflash_shotgunpoprocket"
	self:MuzzleFlashEffect()
	
	self:EmitSound( "doom/weapons/shotgun/shotgun_fire_grenade.ogg", nil, nil, nil, CHAN_WEAPON )
	
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	self:ProjectileAttack( "proj_dmod_shotgungrenade", ( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40 + self.Owner:GetRight()*16.5 + self.Owner:GetUp()*1 ), 1800 )

	self:PlayVMSequence( "shootpoprocket" )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self.Owner:ViewPunch( Angle( -10, 0, 0 ) )
	
	self:SetNextPrimaryFire( CurTime() + 0.5 )
	
	self:SetDelay( 50 )
	
	self:SetActiveMod( false )

end

----------------------------------------------------------------------------------------------------

function SWEP:TripleBurstAttack()

	if self:GetCharge() < 3 then return end
	
	self.Primary.Damage = GetConVar( "dredux_dmg_shotgun_burst" ):GetInt() / 10

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.MuzzleEffect = "dredux_muzzleflash_shotgun"
	
	timer.Simple( 0, function() if IsValid( self ) then self:TripleBurstShot() self:MuzzleFlashEffect() end end)
	timer.Simple( 0.12, function() if IsValid( self ) then self:TripleBurstShot() self:MuzzleFlashEffect() end end)
	timer.Simple( 0.24, function() if IsValid( self ) then self:TripleBurstShot() self:MuzzleFlashEffect() end end)
	timer.Simple( 0.36, function()
		if IsValid( self ) then 
		
			self:GetOwner():SetFOV( 0, 0.2) 
			self:PlayVMSequenceWDelay( "idle", self:VMSequenceDuration() ) 
			
			self:SetActiveMod( false )
			self:SetDelay( 50 ) 
			
			self:GetOwner():GetViewModel():SetSkin( 0 )
			
		end 
	end)

end

----------------------------------------------------------------------------------------------------

function SWEP:TripleBurstShot()
	
	self:PlayVMSequence( "shootburst" )
	
	self:EmitSound( "doom/weapons/shotgun/shotgun_fire_burst_"..math.random(3)..".ogg" )
	
	self:BulletAttack( self.Burst )
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	self.Owner:ViewPunch( Angle( -2, 0, 0 ) )

end

----------------------------------------------------------------------------------------------------

function SWEP:SecondaryAttack()

	if self:GetActiveMod() then return end
	if self:GetDelay() > 0 then return end

	if ( self:GetSelectedMod() == 2 && self:Ammo1() >= 3 ) then
	
		self:PlayVMSequence( "idle_burst" )
		
		local vm = self:GetOwner():GetViewModel()
		
		timer.Simple( 0, function() if IsValid( self ) && self:GetActiveMod() then self:SetCharge( 0 ) vm:SetSkin( 0 ) end end)
		timer.Simple( 0.1, function() if IsValid( self ) && self:GetActiveMod() then self:SetCharge( 1 ) vm:SetSkin( 1 ) end end)
		timer.Simple( 0.2, function() if IsValid( self ) && self:GetActiveMod() then self:SetCharge( 2 ) vm:SetSkin( 2 ) end end)
		timer.Simple( 0.3, function() if IsValid( self ) && self:GetActiveMod() then self:SetCharge( 3 ) vm:SetSkin( 3 ) end end)
		
		self:SetActiveMod( true )
		self:EmitSound( "doom/weapons/shotgun/shotgun_beep.ogg" )
		
		self:GetOwner():SetFOV( self:GetOwner():GetFOV() - 5, 0.2)
		
		self:SetNextPrimaryFire( CurTime() + 0.1 )
	
	elseif ( self:GetSelectedMod() == 1 && self:Ammo1() >= 1 ) then
	
		self:PlayVMSequence( "idle_grenade" )
		self:SetActiveMod( true )
		self:EmitSound( "doom/weapons/shotgun/shotgun_aim_grenade.ogg" )
		
		self:GetOwner():SetFOV( self:GetOwner():GetFOV() - 10, 0.2)
		
		self:SetNextPrimaryFire( CurTime() + 0.1 )
	
	end
	
	self:SetNextSecondaryFire( CurTime() + 0.2 )

end

----------------------------------------------------------------------------------------------------

function SWEP:Reload()

	if IsFirstTimePredicted() then

		if ( self.NextReload < CurTime() && self:GetNextPrimaryFire() < CurTime() ) then 

			local vm = self:GetOwner():GetViewModel()

			if self:GetOwner():KeyDown( IN_USE ) then
			
				if self:GetSelectedMod() == 0 then return end
			
				vm:SetBodygroup( 3, 0 )
				vm:SetBodygroup( 4, 0 )
				
				self:SetSelectedMod( 0 )

				self:EmitSoundWDelay( "doom/weapons/shotgun/shotgun_switch_grenade.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )
				self:PlayVMSequence( "switch_to_poprockets" )

			elseif ( self:GetSelectedMod() == 2 or self:GetSelectedMod() == 0 ) then
			
				vm:SetBodygroup( 3, 1 )
				vm:SetBodygroup( 4, 0 )
				
				self:SetSelectedMod( 1 )
				
				self:EmitSoundWDelay( "doom/weapons/shotgun/shotgun_switch_grenade.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )
				self:PlayVMSequence( "switch_to_poprockets" )
				
			elseif ( self:GetSelectedMod() == 1 ) then
			
				vm:SetBodygroup( 3, 0 )
				vm:SetBodygroup( 4, 1 )
				
				self:SetSelectedMod( 2 )				
				self:EmitSoundWDelay( "doom/weapons/shotgun/shotgun_switch_burst.ogg", nil, nil, nil, CHAN_AUTO, 0.5 )
				self:PlayVMSequence( "switch_to_tripleburst" )
				
			end
			
			self.Owner:SetAnimation( PLAYER_RELOAD )
			self:UpdateWMBodygroup()
			
			self.NextReload = CurTime() + 2.5
			self:SetNextPrimaryFire( CurTime() + 2.2 )
			self:SetNextSecondaryFire( CurTime() + 2.2 )
			
		end
		
	end

end

----------------------------------------------------------------------------------------------------

if CLIENT then

	SWEP.XHair0Scale = 6
	SWEP.XHairScale = 4.75
	
	SWEP.XHairX = 2.2
	SWEP.XHairY = 2

end

function SWEP:UpdateClientWBodygroup()

	self:SetBodygroup( 0, self:GetSelectedMod() )

end

-- Crosshair

function SWEP:OnClientThink()

	local mod =  self:GetSelectedMod()
	local active =  self:GetActiveMod()
	
	if mod == 1 then
	
		if !active then
		
			self.XHair0Scale = math.Approach( self.XHair0Scale, 7, 0.2 )
			self.XHairScale = math.Approach( self.XHairScale, 4.75, 0.1 )
			
			self.XHairX = math.Approach( self.XHairX, 2.2, 0.2 )
			self.XHairY = math.Approach( self.XHairY, 2, 0.1 )
			
		else
		
			self.XHair0Scale = math.Approach( self.XHair0Scale, 8.2, 0.2 )
			self.XHairScale = math.Approach( self.XHairScale, 5.75, 0.1 )
			
			self.XHairX = math.Approach( self.XHairX, 0.8, 0.2 )
			self.XHairY = math.Approach( self.XHairY, 2.4, 0.1 )
		
		end
	
	elseif mod == 2 then
	
		if !active then
		
			self.XHair0Scale = math.Approach( self.XHair0Scale, 7, 0.2 )
			self.XHairScale = math.Approach( self.XHairScale, 4.75, 0.1 )
			
			self.XHairX = math.Approach( self.XHairX, 2.4, 0.2 )
			self.XHairY = math.Approach( self.XHairY, 2, 0.1 )
		
		else
		
			self.XHair0Scale = math.Approach( self.XHair0Scale, 8.2, 0.2 )
			self.XHairScale = math.Approach( self.XHairScale, 5.75, 0.1 )
			
			self.XHairX = math.Approach( self.XHairX, 1.6, 0.2 )
			self.XHairY = math.Approach( self.XHairY, 2.4, 0.1 )
		
		end
	
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:DoDrawCrosshair( x, y )

	local mod =  self:GetSelectedMod()
	local active =  self:GetActiveMod()

	self:DrawCrosshairElementRotated( 0, self.XHair0Scale, 0, 0, 0, 255, 255, 255, 10 )

	if mod == 0 then

		self.XHairScale = 5
		self.XHair0Scale = 7
		
		self:DrawCrosshairElementRotated( 1, self.XHairScale, 0, 0, -self.XHairY, 255, 255, 255, 100 )
		self:DrawCrosshairElementRotated( 2, self.XHairScale, 0, 0, self.XHairY, 255, 255, 255, 100 )
		
	elseif mod == 1 then

		if !active then
			
			self:DrawCrosshairElementRotated( 3, 1.2, 180, self.XHairX, 0, 255, 255, 255, 200 )
			self:DrawCrosshairElementRotated( 3, 1.2, 0, -self.XHairX, 0, 255, 255, 255, 200 )
			
			self:DrawCrosshairElementRotated( 1, self.XHairScale, 0, 0, -self.XHairY, 255, 255, 255, 100 )
			self:DrawCrosshairElementRotated( 2, self.XHairScale, 0, 0, self.XHairY, 255, 255, 255, 100 )
			
		else
			
			self:DrawCrosshairElementRotated( 4, 2, 180, self.XHairX, 0, 255, 255, 255, 200 )
			self:DrawCrosshairElementRotated( 4, 2, 0, -self.XHairX, 0, 255, 255, 255, 200 )
			
			self:DrawCrosshairElementRotated( 1, self.XHairScale, 0, 0, -self.XHairY, 255, 150, 50, 100 )
			self:DrawCrosshairElementRotated( 2, self.XHairScale, 0, 0, self.XHairY, 255, 150, 50, 100 )
			
		end
	
	elseif mod == 2 then
	
		self:DrawCrosshairElementRotated( 5, 2, 0, self.XHairX, 0, 255, 255, 255, 200 )
		self:DrawCrosshairElementRotated( 5, 2, 180, -self.XHairX, 0, 255, 255, 255, 200 )
	
		if !active then
			
			self:DrawCrosshairElementRotated( 1, self.XHairScale, 0, 0, -self.XHairY, 255, 255, 255, 100 )
			self:DrawCrosshairElementRotated( 2, self.XHairScale, 0, 0, self.XHairY, 255, 255, 255, 100 )
			
		else
		
			self:DrawCrosshairElementRotated( 6 + self:GetCharge(), self.XHairScale + 4, 0, 0, 0, 255, 255, 255, 200 )
			
			self:DrawCrosshairElementRotated( 1, self.XHairScale, 0, 0, -self.XHairY, 255, 150, 50, 100 )
			self:DrawCrosshairElementRotated( 2, self.XHairScale, 0, 0, self.XHairY, 255, 150, 50, 100 )
			
		end
	
	end

	if self:GetDelay() > 0 then
	
		self:DrawDelay( math.ceil( self:GetDelay() ), 0.07, 255, 0, 0, 200 )
		
	end
	
	return true
end

----------------------------------------------------------------------------------------------------
-- GRENADE ENTITY
----------------------------------------------------------------------------------------------------

local Grenade = {}

	Grenade.Type = "anim"
	Grenade.Base = "proj_drg_default"
	
	Grenade.Models = {"models/Items/AR2_Grenade.mdl"}
	Grenade.Gravity = true
	Grenade.OnContactEffects = {"d_rpgrocket_explosion"}
	Grenade.OnContactDecals = {"Scorch"}
	Grenade.OnContactDelete = 0
	
	function Grenade:CustomInitialize()
		--ParticleEffectAttach( "d_rpgrocket_trail", 1, self, 0)
		self:DynamicLight( Color( 255, 160, 50 ), 400, 0.75 )
		if SERVER then
			util.SpriteTrail( self, 0, Color( 255, 160, 50, 100 ), false, 10, 0, 0.4, 1 / ( 10 + 0 ) * 0.5, "trails/smoke" )
		end
	end
	
	function Grenade:OnContact( ent )
	
		self:EmitSound( "doom/weapons/shotgun/shotgun_grenade_explode"..math.random( 3 )..".ogg", 100, nil, nil, CHAN_WEAPON )
		util.ScreenShake( self:GetPos(), 50, 5, 0.5, 200 )
		
		local dmg = GetConVar( "dredux_dmg_shotgun_grenade" ):GetInt() + math.random( -5, 5 )
		
		self:DealDamage( ent,  dmg, DMG_BLAST )
		self:RadiusDamage( dmg , DMG_BLAST, 100, function(ent) return ent end)
	end
	
	function Grenade:Draw()
	
		self:DrawModel()
	
	end

	scripted_ents.Register( Grenade, "proj_dmod_shotgungrenade" )
