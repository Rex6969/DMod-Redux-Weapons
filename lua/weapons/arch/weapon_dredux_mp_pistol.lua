SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "EMG Mark V Pistol"
SWEP.Category = "DOOM Multiplayer"
SWEP.Spawnable = true

SWEP.RenderGroup = RENDERGROUP_VIEWMODEL_TRANSLUCENT

SWEP.FirstDeploy = true

SWEP.IsDOOMModdableWeapon = true

SWEP.Primary.Damage = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Ammo = "ar2" --The ammo type will it use
SWEP.Primary.DefaultClip = 25
SWEP.Primary.Spread = 0.4
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Force = 0.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= "none"

SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 42
SWEP.ViewModel			= "models/doom/weapons/pistol/pistol.mdl"
SWEP.WorldModel		= "models/doom/weapons/pistol/mp_pistol_3rd.mdl"
SWEP.UseHands           = false

SWEP.VMOffset = Vector()
SWEP.ZoomOffset = Vector( 0, 5, -2 ) --Vector( 0.55, -8.5, -67 )

SWEP.IsDOOMWeapon = true
SWEP.IsDOOMModdableWeapon = true

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )
	
	self:NetworkVar( "Float", 0, "Delay" )
	self:NetworkVar( "Float", 1, "Charge" )
	self:NetworkVar( "Float", 2, "IronSightMul" )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:OnInitialize()

	PrecacheParticleSystem( "d_pistol_muzzleflash" )
	
	self:SetCharge( 0 )
	self:SetDelay( 0 )
	
	if CLIENT then
	
		self.Reticle = {}
		self.Reticle[0] = Material("hud/delay/MTR50.png", "noclamp transparent smooth" )
		self.Reticle[1] = Material("hud/reticle/ps/ret_4.png", "noclamp transparent smooth" )
		self.Reticle[2] = Material("hud/reticle/ps/ret_2.png", "noclamp transparent smooth" )
	
		self.Delay = {}
		for i = 1,52 do
			self.Delay[i] = Material("hud/charge2/cnt"..i..".png", "noclamp transparent smooth" )
		end
	
	end

end

----------------------------------------------------------------------------------------------------


function SWEP:OnThink()
	
	if ( self:GetActiveMod() && !self:GetOwner():KeyDown( IN_ATTACK2 ) && self:GetNextSecondaryFire() < CurTime() ) then
	
		self:PlayVMSequence( "charge_out" )
		self:EmitSound( "doom/weapons/pistol/pistol_charge_start.ogg", 70 )
		
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
		self:SetIronSightMul( 1 )
		
		self:SetActiveMod( false )
		
		self:GetOwner():SetFOV( 0, 0.2)
		self:SetHoldType( "pistol" )
	
	end
	
	if self:GetActiveMod() then
	
		if self:GetCharge() < 52 then
			self:SetCharge( math.Approach( self:GetCharge(), 52, 0.33 ) )
		end
		
	end
	
end

----------------------------------------------------------------------------------------------------

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	
	self:SetHoldType( "pistol" )
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	
	local vm = self:GetOwner():GetViewModel()
	self:PlayVMSequence( "bringup" )
	
	timer.Simple( 0.01, function()
		if IsValid( self ) then 
			vm:SetBodygroup( 1, 1 )
			vm.RenderGroup = RENDERGROUP_VIEWMODEL_TRANSLUCENT
		end
		
	end)
	
	self:SetIronSightMul( 0 )
	
	self:SetDelay( self:GetDelay() / 2 )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:PrimaryAttack()

	if self:Ammo1() < self.Primary.TakeAmmo then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:PlayVMSequence( "dryfire" )
		return 
	end

	self.Primary.Damage = GetConVar( "dredux_dmg_mp_pistol" ):GetInt()
	self:CallOnClient( "IncreaseXHairScale" )
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if !self:GetActiveMod() then

		self:PlayVMSequence( "shoot" )
		
		self:EmitSound( "doom/weapons/mp_pistol/pistol_fire.ogg", 90, math.random( 95, 105 ) )
		
		self.Owner:ViewPunch( Angle( -3, 0, 0 ) )
		
		self:BulletAttack()
		
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		
	else
	
		--self:PlayVMSequence( "charge_shoot2_centered" )
		self:PlayVMSequenceWDelay( "charge_shoot2_delay_centered", self:VMSequenceDuration() )
		
		self:EmitSound( "doom/weapons/mp_pistol/pistol_fire_charged_"..math.random(3)..".ogg", 90 )
		
		self.Owner:ViewPunch( Angle( -5, 0, 0 ) )
		
		local tbl = table.Copy( self.Primary )
		tbl.Damage = tbl.Damage + ( self:GetCharge() * GetConVar( "dredux_dmg_mp_pistol_charge_mul" ):GetFloat() )
		tbl.Spread = tbl.Spread * 0.5
		
		self:BulletAttack( tbl )
		self:SetNextPrimaryFire( CurTime() + 1.2 )
		self:SetNextSecondaryFire( CurTime() + 1 )
		
		self:SetCharge( -25 )
		
		timer.Simple( 1, function()
		
			if IsValid( self ) then
				
				self:EmitSound( "doom/weapons/pistol/pistol_charge.ogg", 70 )
				
			end
			
		end)
		
	end
	
	self:TakePrimaryAmmo( 1 )
	self.MuzzleEffect = "dredux_muzzleflash"
	self:MuzzleFlashEffect()

end

----------------------------------------------------------------------------------------------------

function SWEP:GetViewModelPosition( EyePos, EyeAng )

	if self:GetActiveMod() then
		self:SetIronSightMul( math.Approach( self:GetIronSightMul(), 1, 0.1 ) )
	else
		self:SetIronSightMul( math.Approach( self:GetIronSightMul(), 0, 0.1 ) )
	end
	
	local mul = self:GetIronSightMul()
	local Offset = self.ZoomOffset

	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + self.VMOffset.x * Right + self.ZoomOffset.x * Right * mul
	EyePos = EyePos + self.VMOffset.y * Forward + self.ZoomOffset.y * Forward * mul
	EyePos = EyePos + self.VMOffset.z * Up + self.ZoomOffset.z * Up * mul

	return EyePos, EyeAng
	
end

----------------------------------------------------------------------------------------------------

function SWEP:SecondaryAttack()

	if self:Ammo1() < 1 then return end
	if self:GetActiveMod() or self:GetDelay() > 0 then return end

	self:PlayVMSequence( "charge_into_centered" )
	self:EmitSound( "doom/weapons/pistol/pistol_charge.ogg", 70 )
		
	self:SetCharge( 0 )
	
	self:SetIronSightMul( 1 )
	
	self:SetActiveMod( true )
	self:SetNextPrimaryFire( CurTime() + 0.2 )
	self:SetNextSecondaryFire( CurTime() + 0.2 )
	
	self:GetOwner():SetFOV( self:GetOwner():GetFOV() - 5, 0.2)
	self:SetHoldType( "revolver" )
	
	--self.MuzzleEffect = "dredux_mppistol_fire"
	--self:MuzzleFlashEffect( "1" )

end

----------------------------------------------------------------------------------------------------

function SWEP:IncreaseXHairScale()
	self.XHairScale = 4.5
end

if CLIENT then

	SWEP.XHairScale = 3.5

end

function SWEP:OnClientThink()

	local active = self:GetActiveMod()
	
	self.XHairScale = math.Approach( self.XHairScale, 3.5, 0.2 )

end


function SWEP:DoDrawCrosshair()

	if self:GetActiveMod() then
		if self:GetCharge() > 0 then
			self:DrawDelay( math.ceil( self:GetCharge() ), 0.07, 255, 255, 255, 150 )
		end
	end
	
	self:DrawCrosshairElementRotated( 1, self.XHairScale, 0, 0, 0, 255, 255, 255, 200 )
	self:DrawCrosshairElementRotated( 1, self.XHairScale, 120, 0, 0, 255, 255, 255, 200 )
	self:DrawCrosshairElementRotated( 1, self.XHairScale, 239, 0, 0, 255, 255, 255, 200 )
	
	--self:DrawCrosshairElementRotated( 2, 0.4, 0, 0, 0, 255, 255, 255, 200 )
	
	return true

end








