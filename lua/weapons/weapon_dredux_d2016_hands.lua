SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Fists"
SWEP.Category = "DOOM"
SWEP.Spawnable = true

SWEP.Primary.Ammo = "none"

SWEP.Slot = 0
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
SWEP.ViewModelFOV		= 42
SWEP.ViewModel			= "models/doom/weapons/hands/hands.mdl"
SWEP.WorldModel			= ""
SWEP.UseHands           = false

SWEP.IsDOOMModdableWeapon = false

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	
	self:SetHoldType( "fists" )
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	
	local vm = self:GetOwner():GetViewModel()
	self:PlayVMSequence( "bringup" )
	
end

function SWEP:PrimaryAttack()

	local owner = self:GetOwner()

	--owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, self:GetSequenceActivity( self:LookupSequence( self.MeleeAnim ) ), true )
	
	local hand = math.random( 2 )
	
	if hand == 1 then 
		self:PlayVMSequence( self:GetTableValue( { "meleeleft", "meleeleft2" } ) )
		owner:ViewPunch( Angle( -5, math.random( -5, -4 ), 0 ) )
	else
		self:PlayVMSequence( self:GetTableValue( { "meleeright", "meleeright2" } ) )
		owner:ViewPunch( Angle( -5, math.random( 5, 4 ), 0 ) )
	end
	
	
	owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, self:GetSequenceActivity( self:LookupSequence( self.MeleeAnim ) ), true )
	self:CallOnClient( "PlayMeleeGesture" )

	self:EmitSound( "doom/weapons/Melee Swing "..math.random( 3 )..".ogg" )
	
	local dmg = GetConVar( "dredux_dmg_fists" ):GetInt()
	local hitent = owner:TraceHullAttack( owner:GetShootPos(), owner:GetShootPos() + owner:GetAimVector() * 80, Vector( -10, -10, -10 ), Vector( 10, 10, 10 ), dmg + math.random( 0, 5 ), DMG_CLUB, 2, false )
	--debugoverlay.Cross( owner:GetShootPos() + owner:GetAimVector() * 50, 25, 1 )
	
	if IsValid( hitent ) then
		self:EmitSound( "doom/weapons/Melee Hit Wall "..math.random( 2 )..".ogg" )
	end
	
	self:OnMeleeAttack()
	self:SetNextPrimaryFire( CurTime() + 0.5 )
	self:SetNextSecondaryFire( CurTime() + 0.5 )

end

function SWEP:SecondaryAttack()

	self:PrimaryAttack()

end

