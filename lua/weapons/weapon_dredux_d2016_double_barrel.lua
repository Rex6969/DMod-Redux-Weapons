SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Super Shotgun"
SWEP.Category = "DOOM"

SWEP.Primary.Damage = 5
SWEP.Primary.TakeAmmo = 2
SWEP.Primary.Ammo = "buckshot" --The ammo type will it use
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Spread = 1.5
SWEP.Primary.NumberofShots = 20
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Force = 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Spawnable = true
if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID( "hud/icons/weapons/doom/dbshotgun" )
end

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 38
SWEP.ViewModel			= "models/doom/weapons/double_barrel/double_barrel.mdl"
SWEP.WorldModel			= "models/doom/weapons/double_barrel/double_barrel_3rd.mdl"
SWEP.UseHands           = false

SWEP.FirstDeploy = true
SWEP.IsEmpty = false

SWEP.IsDOOMWeapon = true
SWEP.IsDOOMModdableWeapon = false

SWEP.VMOffset = Vector() --Vector( 0.5, -8.5, -67 )
SWEP.ZoomOffset = Vector( -1.2, 2, 1 )


-- Weapon functions

function SWEP:OnInitialize()

	self:SetWeaponHoldType( "shotgun" )
	
	if CLIENT then
	
		self.Reticle = {}
		self.Reticle[1] = Material("hud/reticle/ssg/ret_1.png", "smooth" )
		self.Reticle[2] = Material("hud/reticle/ssg/ret_2.png", "smooth" )
		self.Reticle[3] = Material("hud/reticle/ssg/ret_3.png", "smooth" )
	
	end
	
end

----------------------------------------------------------------------------------------------------

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )
	self:NetworkVar( "Float", 0, "IronSightMul" )

end

----------------------------------------------------------------------------------------------------

function SWEP:OnThink()
	
	if ( self:GetActiveMod() && !self:GetOwner():KeyDown( IN_ATTACK2 ) && self:GetNextSecondaryFire() < CurTime() ) then
	
		self:PlayVMSequence( "idle" )
		self:EmitSound( "doom/weapons/shotgun/shotgun_aim_out.ogg", 70 )
		
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
		self:SetActiveMod( false )
		self:SetIronSightMul( 100 )
		
		self:GetOwner():SetFOV( 0, 0.2)
	
	end
	
	if self:GetActiveMod() then
		self:SetIronSightMul( math.Approach( self:GetIronSightMul(), 100, 5 ) )
	else
		self:SetIronSightMul( math.Approach( self:GetIronSightMul(), 0, 5 ) )
	end
	
end

----------------------------------------------------------------------------------------------------

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	self:SetNextSecondaryFire( CurTime() + 0.25 )
	
	if self.FirstDeploy and self:Ammo1() > 0 then
		self:PlayVMSequence( "intro" )
		self:EmitSound( "doom/weapons/ssg/ssg_intro.ogg" )
		self.FirstDeploy = false
	else
		self:PlayVMSequence( "bringup" )
	end
	
	self:SetActiveMod( false )
	self:SetIronSightMul( 0 )
	
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
	
	self.Primary.Damage = GetConVar( "dredux_dmg_supershotgun" ):GetInt() / 20
	
	if self:GetActiveMod() then
	
		self:SetActiveMod( false )
	
		self:SetIronSightMul( 100 )
		self:GetOwner():SetFOV( 0, 0.2)
		
		self:SetNextSecondaryFire( CurTime() + 1.55 )
		
		self.Primary.Spread = 1.2
		
	else
	
		self.Primary.Spread = 1.5
	
	end
	
	self.MuzzleEffect = "dredux_muzzleflash_shotgun"
	self:MuzzleFlashEffect( "muzzle_left" )
	self:MuzzleFlashEffect( "muzzle_right" )
	
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	
	self:BulletAttack()
	
	self:EmitSound( "doom/weapons/ssg/ssg_fire.ogg", 90, nil, nil, CHAN_WEAPON )
	
	self:PlayVMSequence( "shoot" )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:PlayVMSequenceWDelay( "shoot_reload", self:VMSequenceDuration() + 0.05 )
	self:PlayVMSequenceWDelay( "shoot_reload_out", self:VMSequenceDuration() + 0.05 + self:VMSequenceDuration( "shoot_reload" ) )
	
	self.Owner:ViewPunch( Angle( -10, 0, 0 ) )
	
	self:SetNextPrimaryFire( CurTime() + 1.55 )

end

----------------------------------------------------------------------------------------------------

function SWEP:SecondaryAttack()
	
	if not self:GetActiveMod() then
	
		self:PlayVMSequence( "idle_pose" )
		self:SetActiveMod( true )
		self:SetIronSightMul( 0 )
		
		self:GetOwner():SetFOV( self:GetOwner():GetFOV() - 12, 0.2)
		
		self:EmitSound( "doom/weapons/shotgun/shotgun_aim_out.ogg", 70 )
		
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
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

-- Crosshair

function SWEP:DoDrawCrosshair( x, y )

	self:DrawCrosshairElementRotated( 1, 2.3, 180, -4.35, 0, 255, 255, 255, 250 )
	self:DrawCrosshairElementRotated( 1, 2.3, 0, 4.35, 0, 255, 255, 255, 200 )
	
	self:DrawCrosshairElementRotated( 2, 9, 0, 0, -2.3, 255, 255, 255, 100 )
	self:DrawCrosshairElementRotated( 3, 9, 0, 0, 2.3, 255, 255, 255, 100 )
	
	return true
end
