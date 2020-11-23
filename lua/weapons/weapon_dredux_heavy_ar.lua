SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Heavy AR"
SWEP.Category = "DOOM"

SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Ammo = "smg1" --The ammo type will it use
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Spread = 0.4
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.TracerName = "dredux_tracer_har"
SWEP.Primary.Force = 0.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Spawnable = true
if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID( "hud/icons/weapons/doom/har" )
end

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true


SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/doom/weapons/heavy_ar/heavy_ar.mdl"
SWEP.WorldModel			= "models/doom/weapons/heavy_ar/heavy_ar_3rd.mdl"
SWEP.UseHands           = false

SWEP.IsDOOMWeapon = true

SWEP.ZoomOffset = Vector( -5.4, -8, 0 )

SWEP.NextRocketReload = CurTime()

function SWEP:OnInitialize()

	if CLIENT then
	
		self.Reticle = {}
		self.Reticle[0] = Material("hud/delay/MTR50.png", "smooth" )
		self.Reticle[1] = Material("hud/reticle/sg/ret_4.png", "smooth" )
		self.Reticle[2] = Material("hud/reticle/har/ret_1.png", "smooth" )
		self.Reticle[3] = Material("hud/reticle/har/ret_2.png", "smooth" )
		self.Reticle[4] = Material("hud/reticle/har/ret_3.png", "smooth" )
		self.Reticle[5] = Material("hud/reticle/har/ret_4.png", "smooth" )
		self.Reticle[6] = Material("hud/reticle/har/ret_5.png", "smooth" )
		self.Reticle[7] = Material("hud/reticle/har/ret_6.png", "smooth" )
		self.Reticle[8] = Material("hud/reticle/har/ret_7.png", "smooth" )
		self.Reticle[9] = Material("hud/reticle/har/ret_8.png", "smooth" )
		self.Reticle[10] = Material("hud/reticle/har/ret_9.png", "smooth" )
		self.Reticle[11] = Material("hud/reticle/har/ret_10.png", "smooth" )
		self.Reticle[13] = Material("hud/reticle/har/ret_12.png", "smooth" )
	
	end
	
	self.NextReload = CurTime()
	
	self:SetNumRockets( 6 )

end

----------------------------------------------------------------------------------------------------

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )
	
	self:NetworkVar( "Int", 0, "SelectedMod" )
	self:NetworkVar( "Int", 1, "NumRockets" )
	
	self:NetworkVar( "Float", 0, "IronSightMul" )

end

----------------------------------------------------------------------------------------------------

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	
	self:SetHoldType( "shotgun" )
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	
	local vm = self:GetOwner():GetViewModel()
	
	if self.FirstDeploy and self:Ammo1() > 0 then
		self:EmitSound( "doom/weapons/heavy_ar/har_intro.ogg" )
		self:PlayVMSequence( "intro" )
	else
		self:PlayVMSequence( "bringup" )
	end
	
	timer.Simple( 0.01, function()
	
		if !IsValid( self ) then return end
		if ( self:GetSelectedMod() == 1 ) then
			vm:SetBodygroup( 2, 1 )
		elseif ( self:GetSelectedMod() == 2 ) then
			vm:SetBodygroup( 2, 2 )
		end
	
		self:UpdateWMBodygroup()
	
	end)
	
	self:SetIronSightMul( 0 )
	self.NextRocketReload = CurTime() + 0.5
	
end

----------------------------------------------------------------------------------------------------

function SWEP:OnThink()

	if !IsFirstTimePredicted() then return end

	if self:GetActiveMod() && ( ( !self:GetOwner():KeyDown( IN_ATTACK2 ) && self:GetNextSecondaryFire() < CurTime() ) || self:GetSelectedMod() == 2 and self:GetNumRockets() < 1 ) then
	
		self:PlayVMSequence( "idle" )
	
		self:GetOwner():SetFOV( 0, 0.2)
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
		if self:GetSelectedMod() == 1 then self:SetIronSightMul( 1 ) self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_scope_out.ogg", nil, nil, nil, CHAN_WEAPON ) end
		if self:GetSelectedMod() == 1 then self:SetIronSightMul( 2 ) self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_bburst_out.ogg", nil, nil, nil, CHAN_WEAPON ) end
		
		self:SetActiveMod( false )
	
	end
	
	if self:GetSelectedMod() == 2 and !self:GetActiveMod() then
	
		if self.NextRocketReload < CurTime() and self:GetNumRockets() < 6 then
		
			self.NextRocketReload = CurTime() + 0.33
			self:SetNumRockets( self:GetNumRockets() + 1 )
	
		end
	
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:PrimaryAttack()

	if not IsFirstTimePredicted() then return end

	if self:Ammo1() < self.Primary.TakeAmmo then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:PlayVMSequence( "dryfire" )
		return 
	end
	
	if self:GetSelectedMod() == 2 and self:GetActiveMod() then return self:RocketAttack() end

	self:PlayVMSequence( "shoot_1" )
	
	local primary = table.Copy( self.Primary )
	
	if !self:GetActiveMod() then
	
		self:EmitSound( "doom/weapons/heavy_ar/har_fire_"..math.random(3)..".ogg", nil,  math.random( 97, 103 ), 0.8, CHAN_VOICE_BASE )
		primary.Damage = GetConVar( "dredux_dmg_har" ):GetInt()
		
		self.Owner:SetViewPunchAngles( Angle( -1, math.random( -3, 3) * 0.1 , 0 ) )

		self:SetNextPrimaryFire( CurTime() + 0.2 )

	else
	
		self:EmitSound( "doom/weapons/heavy_ar/har_fire_scoped_"..math.random(3)..".ogg", nil,  nil, 0.8, CHAN_VOICE_BASE )
		primary.Damage = GetConVar( "dredux_dmg_har" ):GetInt()
		primary.Spread =	primary.Spread * 0.2
		
		self.Owner:SetViewPunchAngles( Angle( -0.25, math.random( -15, 15) * 0.01, 0 ) )
		
		self:SetNextPrimaryFire( CurTime() + 0.25 )
	
	end
	
	self.MuzzleEffect = "dredux_muzzleflash_har"
	self:MuzzleFlashEffect()

	self:BulletAttack( primary )
	self:TakePrimaryAmmo( 1 )

end

function SWEP:RocketAttack()

	if self:Ammo1() < 5 then return self:FinishRockets() end
	
	self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_fire_missile_"..math.random( 4 )..".ogg", nil, nil, nil, CHAN_VOICE_BASE )
	self:PlayVMSequence( "bburst_shoot_1" )
	
	self:ProjectileAttack( "proj_dmod_harrocket", ( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40 + self.Owner:GetRight()*8 + self.Owner:GetUp()*-8 ), 1800 )
	
	self.MuzzleEffect = "dredux_muzzleflash"
	self:MuzzleFlashEffect( "muzzle_rocket_"..( 7 - self:GetNumRockets() ) )
	
	self:SetNumRockets( self:GetNumRockets() - 1 )
	self:TakePrimaryAmmo( 5 )
	
	self:SetNextPrimaryFire( CurTime() + 0.2 )
	self:SetNextSecondaryFire( CurTime() + 0.5 )
	
	if self:GetNumRockets() < 1 then self:FinishRockets() end

end

function SWEP:FinishRockets()

	self:PlayVMSequence( "idle" )
	
	self:SetNextPrimaryFire( CurTime() + 0.5 )
	self:SetNextSecondaryFire( CurTime() + 0.2 )
		
	self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_bburst_out.ogg", nil, nil, nil, CHAN_WEAPON )

	self:SetActiveMod( false )
	self.NextRocketReload = CurTime() + 0.5

end

----------------------------------------------------------------------------------------------------

function SWEP:SecondaryAttack()

	if self:GetActiveMod() then return end

	if self:GetSelectedMod() == 1 then
	
		timer.Simple( 0.2, function() if IsValid( self ) then  self:GetOwner():SetFOV( 60, 0.2 ) end end )
		
		self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_scope.ogg", nil, nil, nil, CHAN_WEAPON )
		
		self:SetNextPrimaryFire( CurTime() + 0.3 )
		self:SetActiveMod( true )
		self:SetIronSightMul( 0 ) 
		
	elseif self:GetSelectedMod() == 2 and self:Ammo1() >= 5 and self:GetNumRockets() > 5 then
	
		self:PlayVMSequence( "bburst_into" )
	
		self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_bburst.ogg", nil, nil, nil, CHAN_WEAPON )
		self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_bburst.ogg", nil, nil, nil, CHAN_WEAPON, 0.2 )
		self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_bburst.ogg", nil, nil, nil, CHAN_WEAPON, 0.4 )
		
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetActiveMod( true )
		
	end
	self:SetNextSecondaryFire( CurTime() + 0.5 )

end

----------------------------------------------------------------------------------------------------

function SWEP:Reload()

	if IsFirstTimePredicted() then

		if ( self.NextReload < CurTime() && self:GetNextPrimaryFire() < CurTime() ) then 

			local vm = self:GetOwner():GetViewModel()

			if self:GetOwner():KeyDown( IN_USE ) then
			
				if self:GetSelectedMod() == 0 then return end
			
				vm:SetBodygroup( 2, 0 )
				
				self:SetSelectedMod( 0 )
				
				self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_switch_scope.ogg", nil, nil, nil, CHAN_WEAPON )
				self:PlayVMSequence( "bringup" )

			elseif ( self:GetSelectedMod() == 2 or self:GetSelectedMod() == 0 ) then
			
				vm:SetBodygroup( 2, 1 )
				
				self:SetSelectedMod( 1 )
				
				self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_switch_scope.ogg", nil, nil, nil, CHAN_WEAPON )
				self:PlayVMSequence( "switch_to_scope" )
				
			elseif ( self:GetSelectedMod() == 1 ) then
			
				vm:SetBodygroup( 2, 2 )
				
				self:SetSelectedMod( 2 )
				
				self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_switch_missiles.ogg", nil, nil, nil, CHAN_WEAPON )
				self:PlayVMSequence( "switch_to_bburst" )
				
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

function SWEP:OnClientThink()

	if self:GetSelectedMod() == 1 && self:GetActiveMod() then
		self:SetIronSightMul( math.Approach( self:GetIronSightMul(), 1, 0.08 ) )
	else
		self:SetIronSightMul( math.Approach( self:GetIronSightMul(), 0, 0.08 ) )
	end

end

function SWEP:GetViewModelPosition( EyePos, EyeAng )
	local mul = self:GetIronSightMul()
	local Offset = self.ZoomOffset

	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + self.VMOffset.x * Right + self.ZoomOffset.x * Right * mul
	EyePos = EyePos + self.VMOffset.y * Forward + self.ZoomOffset.y * Forward * mul
	EyePos = EyePos + self.VMOffset.z * Up + self.ZoomOffset.z * Up * mul
		
	if self:GetIronSightMul() >= 1 then
		EyePos = EyePos + -40 * Forward
	end

	return EyePos, EyeAng
	
end

function SWEP:AdjustMouseSensitivity()

	if self:GetIronSightMul() >= 1 then
		return 0.75
	else
		return 0
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:UpdateClientWBodygroup()

	self:SetBodygroup( 1, self:GetSelectedMod() )

end

----------------------------------------------------------------------------------------------------

function SWEP:DoDrawCrosshair()

	--[[if self:GetActiveMod() then
		if self:GetCharge() > 0 then
			self:DrawDelay( math.ceil( self:GetCharge() ), 0.07, 255, 255, 255, 150 )
		end
	end]]
	
	local mod = self:GetSelectedMod()
	local active = self:GetActiveMod()
	local scoped = self:GetIronSightMul() == 1

	if !active or mod == 2 then
	
		self:DrawCrosshairElementRotated( 2, 1.8, 0, 0, 0, 255, 255, 255, 15 )
		
		self:DrawCrosshairElementRotated( 1, 0.5, 0, 0, -0.9, 255, 255, 255, 255 )
		self:DrawCrosshairElementRotated( 1, 0.5, 90, -0.9, 0, 255, 255, 255, 255 )
		self:DrawCrosshairElementRotated( 1, 0.5, 270, 0.95, 0, 255, 255, 255, 255 )
		self:DrawCrosshairElementRotated( 1, 0.5, 180, 0, 0.95, 255, 255, 255, 255 )
		
	end
	
	if mod == 1 and scoped then
	
		self:DrawScreenOverlay( 3, 2, 255, 255, 255, 255 )
		
		self:DrawCrosshairElementRotated( 4, 12, 0, 0, 0, 255, 255, 255, 140 )
		
		self:DrawCrosshairElementRotated( 5, 75, 0, 0, 0, 255, 255, 255, 60 )
		self:DrawCrosshairElementRotated( 6, 62, 0, 0, 0, 255, 255, 255, 60 )
		
		self:DrawCrosshairElementRotated( 7, 12, 0, -12, 0, 255, 255, 255, 60 )
		self:DrawCrosshairElementRotated( 8, 12, 0, 12, 0, 255, 255, 255, 60 )
		
		self:DrawCrosshairElementRotated( 9, 50, 0, 0, 0, 255, 255, 255, 10 )
		
		self:DrawCrosshairElementRotated( 10, 8, 0, -26, -4, 255, 255, 255, 5 )
		self:DrawCrosshairElementRotated( 11, 8, 0, 26, -4, 255, 255, 255, 5 )
		
	elseif mod == 2 then
	
		local missiles = self:GetNumRockets()
		local XColor = active && Color( 50, 255, 50 ) ||  Color( 255, 50, 50 )
		local ToDraw = active && missiles || 6 - missiles
		if ToDraw >= 1 then self:DrawCrosshairElementRotated( 13, 1, 0, -2, 1, XColor.r, XColor.g, XColor.b, 200 ) end
		if ToDraw >= 2 then self:DrawCrosshairElementRotated( 13, 1, 0, 2, 1, XColor.r, XColor.g, XColor.b, 200 ) end
		if ToDraw >= 3 then self:DrawCrosshairElementRotated( 13, 1, 0, -2, 0, XColor.r, XColor.g, XColor.b, 200 ) end
		if ToDraw >= 4 then self:DrawCrosshairElementRotated( 13, 1, 0, 2, 0, XColor.r, XColor.g, XColor.b, 200 ) end
		if ToDraw >= 5 then self:DrawCrosshairElementRotated( 13, 1, 0, -2, -1, XColor.r, XColor.g, XColor.b, 200 ) end
		if ToDraw >= 6 then self:DrawCrosshairElementRotated( 13, 1, 0, 2, -1, XColor.r, XColor.g, XColor.b, 200 ) end
		
	end
	
	--self:DrawCrosshairElementRotated( 2, 0.4, 0, 0, 0, 255, 255, 255, 200 )
	
	return true

end

----------------------------------------------------------------------------------------------------
-- ROCKET ENTITY
----------------------------------------------------------------------------------------------------

local HARRocket = {}

	HARRocket.Type = "anim"
	HARRocket.Base = "proj_drg_default"
	
	HARRocket.Models = {"models/Items/AR2_Grenade.mdl"}
	HARRocket.Gravity = false
	HARRocket.OnContactDecals = {"FadingScorch"}
	HARRocket.OnContactDelete = 0
	
	function HARRocket:CustomInitialize()
	
		ParticleEffectAttach( "d_tinyrocket_trail", 1, self, 0)
		self:DynamicLight( Color( 255, 160, 50 ), 200, 0.75 )
		
		if SERVER then
			
			local phys = self:GetPhysicsObject()
			if IsValid( phys ) then
				phys:SetVelocity( self:GetVelocity() + VectorRand() * 450 ) 
			end
		
		end
		
	end
	
	function HARRocket:OnContact( ent )
	
		self:EmitSound( "doom/weapons/heavy_ar/har_missile_explo_"..math.random( 4 )..".ogg", 100, nil, nil, CHAN_AUTO )
		util.ScreenShake( self:GetPos(), 5, 5, 0.5, 100 )
		
		local data = EffectData()
		data:SetOrigin( self:GetPos() )
		util.Effect( "dredux_explosion_tiny", data )
		
		local dmg = GetConVar( "dredux_dmg_har_rocket" ):GetInt() + math.random( -5, 5 )
		
		self:DealDamage( ent,  dmg, DMG_BLAST )
		self:RadiusDamage( dmg , DMG_BLAST, 50, function(ent) return ent end)
		
	end
	
	function HARRocket:Think()
	
		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:SetVelocity( self:GetVelocity() + VectorRand() * 150 ) 
		end
	
	end
	
	
	function HARRocket:Draw()
	
		self:DrawModel()
	
	end

	scripted_ents.Register( HARRocket, "proj_dmod_harrocket" )

