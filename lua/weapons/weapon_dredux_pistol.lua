SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Pistol"
SWEP.Category = "DOOM"
SWEP.Spawnable = true

SWEP.FirstDeploy = true

SWEP.IsDOOMModdableWeapon = true

SWEP.Primary.Damage = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Ammo = "none" --The ammo type will it use
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Spread = 0.6
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
SWEP.WorldModel		= "models/doom/weapons/pistol/pistol_3rd.mdl"
SWEP.UseHands           = false

SWEP.VMOffset = Vector() --Vector( 0.55, -8.5, -67 )

SWEP.IsDOOMWeapon = true
SWEP.IsDOOMModdableWeapon = true

SWEP.MuzzleEffect = "dredux_muzzleflash_pistol"

----------------------------------------------------------------------------------------------------

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )
	
	self:NetworkVar( "Float", 0, "Delay" )
	self:NetworkVar( "Float", 1, "Charge" )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:OnInitialize()

	PrecacheParticleSystem( "d_pistol_muzzleflash" )
	
	self:SetCharge( 0 )
	self:SetDelay( 0 )
	
	if CLIENT then
	
		self.Reticle = {}
		self.Reticle[0] = Material("hud/delay/MTR50.png", "noclamp transparent smooth" )
		self.Reticle[1] = Material("hud/reticle/ps/ret_1.png", "noclamp transparent smooth" )
		self.Reticle[2] = Material("hud/reticle/ps/ret_2.png", "noclamp transparent smooth" )
		self.Reticle[3] = Material("hud/reticle/ps/ret_3.png", "noclamp transparent smooth" )
	
		self.Delay = {}
		for i = 1,50 do
			self.Delay[i] = Material("hud/delay/MTR"..i..".png", "noclamp transparent smooth" )
		end
	
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:OnThink()
	
	if ( self:GetActiveMod() && !self:GetOwner():KeyDown( IN_ATTACK2 ) && self:GetNextSecondaryFire() < CurTime() ) then
	
		self:PlayVMSequence( "charge_out" )
		self:EmitSound( "doom/weapons/pistol/pistol_charge_start.ogg", 70 )
		
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
		self:SetActiveMod( false )
		
		self:GetOwner():SetFOV( 0, 0.2)
		self:SetHoldType( "pistol" )
	
	end
	
	if self:GetActiveMod() then
	
		if self:GetCharge() < 50 then
			self:SetCharge( math.Approach( self:GetCharge(), 50, 0.33 ) )
		end
	
	else
	
		if self:GetDelay() > 0 then
			self:SetDelay( math.Approach( self:GetDelay(), 0, 0.4 ) )
		end
		
	end
	
end

----------------------------------------------------------------------------------------------------

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	
	local vm = self:GetOwner():GetViewModel()
	if self.FirstDeploy then
	
		self:PlayVMSequence( "intro" )
		
		self:EmitSound( "doom/weapons/pistol/pistol_intro.ogg" )
		
		self.FirstDeploy = false
		
	else
		self:PlayVMSequence( "bringup" )
	end
	
	timer.Simple( 0.01, function()
		if IsValid( self ) then 
			vm:SetBodygroup( 1, 0 )
		end
	end)
	
	self:SetHoldType( "pistol" )
	
	self:SetDelay( self:GetDelay() / 2 )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:PrimaryAttack()

	self.Primary.Damage = GetConVar( "dredux_dmg_pistol" ):GetInt()
	self:CallOnClient( "IncreaseXHairScale" )
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if !self:GetActiveMod() then

		self:PlayVMSequence( "shoot" )
		
		self:EmitSound( "doom/weapons/pistol/wpn_pistol_sp_fire_0"..math.random(4)..".ogg" )
		
		self.Owner:ViewPunch( Angle( -3, 0, 0 ) )
		
		self:BulletAttack()
		
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		
	else
	
		self:PlayVMSequence( "charge_shoot2" )
		self:PlayVMSequenceWDelay( "charge_shoot2_delay", self:VMSequenceDuration() )
		
		self:EmitSound( "doom/weapons/pistol/wpn_pistol_sp_fire_charged_0"..math.random(4)..".ogg", 90 )
		
		self.Owner:ViewPunch( Angle( -5, 0, 0 ) )
		
		local tbl = table.Copy( self.Primary )
		tbl.Damage = tbl.Damage + ( self:GetCharge() *  GetConVar( "dredux_dmg_pistol_charge_mul" ):GetFloat() )
		tbl.Spread = tbl.Spread * 0.25
	
		self:BulletAttack( tbl )
		self:SetNextPrimaryFire( CurTime() + 1.2 )
		self:SetNextSecondaryFire( CurTime() + 1.4 )
		
		self:SetDelay( 80 )
		self:SetActiveMod( false )
		
		timer.Simple( 1.2, function()
		
			if IsValid( self ) then
				
				self:PlayVMSequence( "charge_out" )
				self:GetOwner():SetFOV( 0, 0.2)
				self:SetHoldType( "pistol" )
				
				self:EmitSound( "doom/weapons/pistol/pistol_charge_start.ogg", 70 )
				
			end
			
		end)
		
	end
	
	self:MuzzleFlashEffect()
	
	--[[local edata = EffectData()
	edata:SetEntity( self )
	util.Effect( "dredux_pistol_muzzleflash", edata )]]

end

----------------------------------------------------------------------------------------------------

function SWEP:SecondaryAttack()

	if self:GetActiveMod() or self:GetDelay() > 0 then return end

	self:PlayVMSequence( "charge_into" )
	self:EmitSound( "doom/weapons/pistol/pistol_charge.ogg", 70 )
		
	self:SetCharge( 0 )
	
	self:SetActiveMod( true )
	self:SetNextPrimaryFire( CurTime() + 0.2 )
	self:SetNextSecondaryFire( CurTime() + 0.2 )
	
	self:GetOwner():SetFOV( self:GetOwner():GetFOV() - 8, 0.2)
	self:SetHoldType( "revolver" )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:IncreaseXHairScale()
	self.XHairScale = 3.5
end

----------------------------------------------------------------------------------------------------

if CLIENT then

	SWEP.XHairScale = 2.5

end

function SWEP:OnClientThink()

	local active = self:GetActiveMod()
	
	if !active then
		self.XHairScale = math.Approach( self.XHairScale, 2.5, 0.2 )
	else
		self.XHairScale = math.Approach( self.XHairScale, 5, 0.2 )
	end

end

function SWEP:DoDrawCrosshair()
	
	local active = self:GetActiveMod()
	
	if !active then
	
		self:DrawCrosshairElementRotated( 1, self.XHairScale, 0, 0, 0, 255, 255, 255, 255 )
	
		if self:GetDelay() > 0 then
			
			self:DrawCrosshairElementRotated( 0, 6, 0, 0, 0, 255, 255, 255, 5 )
			local delay = math.ceil( math.Clamp( self:GetDelay(), 1, 50 ) )
			self:DrawDelay( delay, 0.06, 255, 0, 0, 255 )
		end
		
	else
	
		self:DrawCrosshairElementRotated( 3, self.XHairScale, 0, 0, 0, 255, 255, 255, 40 )
		self:DrawCrosshairElementRotated( 2, 1.5, 0, 0, 0, 255, 255, 255, 255 )
	
		if self:GetCharge() > 0 then
		
			self:DrawCrosshairElementRotated( 0, 6, 0, 0, 0, 255, 255, 255, 5 )
			self:DrawDelay( math.ceil( self:GetCharge() ), 0.06, 80, 180, 255, 255 )
		
		end
	
	end
	
	return true

end