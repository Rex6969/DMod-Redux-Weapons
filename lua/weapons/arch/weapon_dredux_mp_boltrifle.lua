SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Burst Rifle"
SWEP.Category = "DOOM Multiplayer"
SWEP.Spawnable = true

SWEP.Primary.Damage = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Ammo = "smg1" --The ammo type will it use
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Spread = 0.6
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Force = 0.1
SWEP.Primary.TracerName = "dredux_har_tracer"

SWEP.Slot = 3
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

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/doom/weapons/mp_bolt_rifle/mp_bolt_rifle.mdl"
SWEP.WorldModel			= "models/doom/weapons/mp_bolt_rifle/mp_bolt_rifle_3rd.mdl"
SWEP.UseHands           = false

SWEP.IsDOOMModdableWeapon = true
SWEP.IsDOOMWeapon = true

SWEP.NextBurst = CurTime()

SWEP.MuzzleEffect = "dredux_muzzleflash"

SWEP.ZoomOffset = Vector( 0, -2, 0 )

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )
	
	self:NetworkVar( "Int", 0, "Burst" )
	
	self:NetworkVar( "Float", 0, "IronSightMul" )

end

----------------------------------------------------------------------------------------------------

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	
	self:SetHoldType( "shotgun" )
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	
	local vm = self:GetOwner():GetViewModel()
	self:PlayVMSequence( "bringup" )
	
	self:SetBurst( 0 )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:PrimaryAttack()

	if self:Ammo1() < self.Primary.TakeAmmo then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:PlayVMSequence( "dryfire" )
		return 
	end

	if !self:GetActiveMod() then
	
		self:PlayVMSequence( "shoot_burst" )
		self:PlayVMSequenceWDelay( "shoot_burst_delay", self:VMSequenceDuration() )
	
		self:SetBurst( 3 )
		self.NextBurst = CurTime()
		
		self:TakePrimaryAmmo( 3 )
		
		self:SetNextPrimaryFire( CurTime() + 0.45 )
	
	else
	
		self:PlayVMSequence( "zoom_shoot_single" )
		self:PlayVMSequenceWDelay( "zoom_shoot_single_delay", self:VMSequenceDuration() )
		self:MuzzleFlashEffect()
		
		self:EmitSound( "doom/weapons/mp_bolt_rifle/boltrifle_fire_"..math.random( 2 )..".ogg" )
		
		local primary = table.Copy( self.Primary )
		primary.Damage = GetConVar( "dredux_dmg_mp_burstrifle" ):GetInt() * 2
		primary.Spread =	primary.Spread * 0.25
		self:BulletAttack( primary )
		
		self:TakePrimaryAmmo( 1 )
		
		self.Owner:SetViewPunchAngles( Angle( -2, math.random( -3, 3) * 0.1 , 0 ) )
		
		self:SetNextPrimaryFire( CurTime() + 0.3 )
	
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:SecondaryAttack()
	
	if not self:GetActiveMod() then
	
		self:PlayVMSequence( "zoom_idle" )
		self:SetActiveMod( true )
		self:SetIronSightMul( 0 )
		
		self.Primary.Automatic = false
		self.Primary.TakeAmmo = 1
		
		self:GetOwner():SetFOV( self:GetOwner():GetFOV() - 10, 0.2)
		
		self:EmitSound( "doom/weapons/mp_bolt_rifle/boltrifle_aim.ogg", 70 )
		
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:OnThink()
	
	if ( self:GetActiveMod() && !self:GetOwner():KeyDown( IN_ATTACK2 ) && self:GetNextSecondaryFire() < CurTime() ) then
	
		self:PlayVMSequence( "idle" )
		self:EmitSound( "doom/weapons/mp_bolt_rifle/boltrifle_aim_out.ogg", 70 )
		
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
		self:SetActiveMod( false )
		self:SetIronSightMul( 100 )
		
		self.Primary.Automatic = true
		self.Primary.TakeAmmo = 3
		
		self:GetOwner():SetFOV( 0, 0.2)
	
	end
	
	if self:GetActiveMod() then
		self:SetIronSightMul( math.Approach( self:GetIronSightMul(), 100, 10 ) )
	else
		self:SetIronSightMul( math.Approach( self:GetIronSightMul(), 0, 10 ) )
	end
	
	if self:GetBurst() > 1 and self.NextBurst < CurTime() then
	
		self:SetBurst( self:GetBurst() - 1 )
		self.NextBurst = CurTime() + 0.1
	
		local primary = table.Copy( self.Primary )
		primary.Damage = GetConVar( "dredux_dmg_mp_burstrifle" ):GetInt()
		primary.TracerName = ""
		self:BulletAttack( primary )
		
		self:MuzzleFlashEffect()
		
		self.Owner:SetViewPunchAngles( Angle( -1, math.random( -3, 3) * 0.1 , 0 ) )
		
		self:EmitSound( "doom/weapons/mp_bolt_rifle/boltrifle_fire_"..math.random( 2 )..".ogg", nil, nil, 0.8, CHAN_WEAPON )
	
	end
	
end

----------------------------------------------------------------------------------------------------

function SWEP:GetViewModelPosition( EyePos, EyeAng )
	
	local mul = self:GetIronSightMul()
	local Offset = self.ZoomOffset

	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + self.VMOffset.x * Right + self.ZoomOffset.x * Right * ( mul * 0.01 )
	EyePos = EyePos + self.VMOffset.y * Forward + self.ZoomOffset.y * Forward * ( mul * 0.01 )
	EyePos = EyePos + self.VMOffset.z * Up + self.ZoomOffset.z * Up * ( mul * 0.01 )

	return EyePos, EyeAng
	
end

----------------------------------------------------------------------------------------------------