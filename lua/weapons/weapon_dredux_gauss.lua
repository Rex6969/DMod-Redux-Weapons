SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Gauss Cannon"
SWEP.Category = "DOOM"
SWEP.Spawnable = true

SWEP.Primary.TakeAmmo = 15
SWEP.Primary.Ammo = "ar2" --The ammo type will it use
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Spread = 0.05
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.TracerName = "dredux_tracer_gauss"
SWEP.Primary.Force = 10

SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Spawnable = true
if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID( "hud/icons/weapons/doom/gauss" )
end

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 42
SWEP.ViewModel			= "models/doom/weapons/gauss/gauss.mdl"
SWEP.WorldModel			= ""
SWEP.UseHands           = false

SWEP.IsDOOMModdableWeapon = false

SWEP.ZoomOffset = Vector( -5.4, -8, 0 )

----------------------------------------------------------------------------------------------------

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )
	
	self:NetworkVar( "Int", 0, "SelectedMod" )
	
	self:NetworkVar( "Float", 0, "Charge" )
	self:NetworkVar( "Float", 0, "IronSightMul" )

end

----------------------------------------------------------------------------------------------------

function SWEP:OnInitialize()

	if CLIENT then
	
		self.Reticle = {}
		self.Reticle[0] = Material("hud/delay/MTR50.png", "noclamp transparent smooth" )
		self.Reticle[1] = Material("hud/reticle/gs/ret_1.png", "noclamp transparent smooth" )
		self.Reticle[2] = Material("hud/reticle/gs/ret_2.png", "noclamp transparent smooth" )
		self.Reticle[3] = Material("hud/reticle/gs/ret_3.png", "noclamp transparent smooth" )
		self.Reticle[4] = Material("hud/reticle/gs/ret_4.png", "noclamp transparent smooth" )
		self.Reticle[5] = Material("hud/reticle/gs/ret_5.png", "noclamp transparent smooth" )
	
		self.Delay = {}
		for i = 0,22 do
			self.Delay[i] = Material("hud/reticle/gs/GSSMTR"..i..".png", "noclamp transparent smooth" )
		end
	
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon_heavy.ogg" )
	
	self:SetHoldType( "physgun" )
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	
	local vm = self:GetOwner():GetViewModel()
	self:PlayVMSequence( "bringup" )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:PrimaryAttack()

	if self:Ammo1() < self.Primary.TakeAmmo then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:PlayVMSequence( "dryfire" )
		return 
	end
	
	self.MuzzleEffect = "dredux_muzzleflash_gauss"
	self:MuzzleFlashEffect()
	
	if !self:GetActiveMod() then

		self:GetOwner():ViewPunch( Angle( -6, math.Rand( -1, 1 ), 0 ) )
		self:GetOwner():SetVelocity( self:GetOwner():GetAimVector() * -200 )

		self:EmitSound( "doom/weapons/gauss/gauss_fire.ogg" )
		
		self:PlayVMSequence( "shoot" )
		self:PlayVMSequenceWDelay( "shoot_delay", self:VMSequenceDuration() )
		
		local primary = table.Copy( self.Primary )
		primary.Damage = GetConVar( "dredux_dmg_gauss" ):GetInt()
		self:BulletAttack( primary )
		
		self:TakePrimaryAmmo( primary.TakeAmmo )
		
		self:SetNextPrimaryFire( CurTime() + 1.5 )
		self:SetNextSecondaryFire( CurTime() + 1.5 )
		
	elseif self:GetSelectedMod() == 2 then
	
		self:GetOwner():ViewPunch( Angle( -12, math.Rand( -1, 1 ), 0 ) )
		self:GetOwner():SetVelocity( self:GetOwner():GetAimVector() * -400 )
	
		self:EmitSound( "doom/weapons/gauss/gauss_fire_siege.ogg" )
		
		self:PlayVMSequence( "siegemode_fire" )
		self:PlayVMSequenceWDelay( "siegemode_fire_to_idle", self:VMSequenceDuration() + 0.5 )
		
		local primary = table.Copy( self.Primary )
		primary.Damage = GetConVar( "dredux_dmg_gauss_siege" ):GetInt()
		self:BulletAttack( primary )
		
		self:SetActiveMod( false )
		
		self:TakePrimaryAmmo( primary.TakeAmmo * 2 )
		
		self:SetNextPrimaryFire( CurTime() + 1.5 )
		self:SetNextSecondaryFire( CurTime() + 1.5 )
	
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:SecondaryAttack()

	if self:GetActiveMod() then return end

	if self:GetSelectedMod() == 1 then
	
		timer.Simple( 0.2, function() if IsValid( self ) then  self:GetOwner():SetFOV( 60, 0.2 ) end end )
		
		--self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_scope.ogg", nil, nil, nil, CHAN_WEAPON )
		
		self:SetNextPrimaryFire( CurTime() + 0.3 )
		self:SetActiveMod( true )
		self:SetIronSightMul( 0 ) 
		
	elseif self:GetSelectedMod() == 2 and self:Ammo1() >= 30 then
	
		self:PlayVMSequence( "siegemode_into" )
	
		self:EmitSoundWDelay( "doom/weapons/gauss/gauss_siege_into.ogg", nil, nil, nil, CHAN_WEAPON )
		
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetActiveMod( true )
		
	end
	self:SetNextSecondaryFire( CurTime() + 0.5 )

end

----------------------------------------------------------------------------------------------------

function SWEP:Reload()

	print( reload )

	--[[if IsFirstTimePredicted() then

		if ( self.NextReload < CurTime() && self:GetNextPrimaryFire() < CurTime() ) then 

			local vm = self:GetOwner():GetViewModel()

			if self:GetOwner():KeyDown( IN_USE ) then
			
				if self:GetSelectedMod() == 0 then return end
			
				vm:SetBodygroup( 2, 0 )
				
				self:SetSelectedMod( 0 )
				
				self:EmitSoundWDelay( "doom/weapons/gauss/gauss_switch_siege.ogg", nil, nil, nil, CHAN_WEAPON )
				self:PlayVMSequence( "switch_to_siege" )

			elseif ( self:GetSelectedMod() == 2 or self:GetSelectedMod() == 0 ) then
			
				vm:SetBodygroup( 2, 1 )
				vm:SetBodygroup( 3, 0 )
				
				self:SetSelectedMod( 1 )
				
				self:EmitSoundWDelay( "doom/weapons/gauss/gauss_switch_chargedsniper.ogg", nil, nil, nil, CHAN_WEAPON, 0.6 )
				self:PlayVMSequence( "switch_to_sniper" )
				
			elseif ( self:GetSelectedMod() == 1 ) then
			
				vm:SetBodygroup( 2, 0 )
				vm:SetBodygroup( 4, 1 )
				
				self:SetSelectedMod( 2 )
				
				self:EmitSoundWDelay( "doom/weapons/gauss/gauss_switch_siege.ogg", nil, nil, nil, CHAN_WEAPON, 0.6 )
				self:PlayVMSequence( "switch_to_siege" )
				
			end
			
			self.Owner:SetAnimation( PLAYER_RELOAD )
			self:UpdateWMBodygroup()
			
			self.NextReload = CurTime() + 2.5
			self:SetNextPrimaryFire( CurTime() + 2.2 )
			self:SetNextSecondaryFire( CurTime() + 2.2 )
			
		end
		
	end]]

end

----------------------------------------------------------------------------------------------------

function SWEP:OnThink()

	if !IsFirstTimePredicted() then return end

	if self:GetActiveMod() && ( ( !self:GetOwner():KeyDown( IN_ATTACK2 ) && self:GetNextSecondaryFire() < CurTime() ) ) then
	
		self:PlayVMSequence( "idle" )
	
		self:GetOwner():SetFOV( 0, 0.5 )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
		if self:GetSelectedMod() == 1 then self:SetIronSightMul( 1 ) self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_scope_out.ogg", nil, nil, nil, CHAN_WEAPON ) end
		if self:GetSelectedMod() == 1 then self:PlayVMSequence( "siegemode_out" ) self:SetIronSightMul( 2 ) self:EmitSoundWDelay( "doom/weapons/heavy_ar/har_aim_bburst_out.ogg", nil, nil, nil, CHAN_WEAPON ) end
		
		self:SetActiveMod( false )
	
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


----------------------------------------------------------------------------------------------------

function SWEP:DoDrawCrosshair()

	--[[if self:GetActiveMod() then
		if self:GetCharge() > 0 then
			self:DrawDelay( math.ceil( self:GetCharge() ), 0.07, 255, 255, 255, 150 )
		end
	end]]
	
	local xhairx = 2.35
	local xhairy = 1
	
	self:DrawCrosshairElementRotated( 1, 1.5, 0, -xhairx, -xhairy, 255, 255, 255, 200 )
	self:DrawCrosshairElementRotated( 2, 1.5, 0, xhairx, -xhairy, 255, 255, 255, 200 )
	self:DrawCrosshairElementRotated( 3, 1.5, 0, -xhairx, xhairy, 255, 255, 255, 200 )
	self:DrawCrosshairElementRotated( 4, 1.5, 0, xhairx, xhairy, 255, 255, 255, 200 )
	
	self:DrawCrosshairElementRotated( 5, 1, 0, 0, 0, 255, 255, 255, 200 )
	
	--self:DrawCrosshairElementRotated( 2, 0.4, 0, 0, 0, 255, 255, 255, 200 )
	
	return true

end