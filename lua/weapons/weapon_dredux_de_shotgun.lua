SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Combat Shotgun ( Eternal )"
SWEP.Category = "DOOM Eternal"
SWEP.Spawnable = true

SWEP.Primary.Damage = 6
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Ammo = "buckshot" --The ammo type will it use
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Spread = 0.8
SWEP.Primary.NumberofShots = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Force = 0.5

SWEP.Burst = {}
SWEP.Burst.Damage = 5
SWEP.Burst.TakeAmmo = 1
SWEP.Burst.Ammo = "buckshot" --The ammo type will it use
SWEP.Burst.Spread = 1
SWEP.Burst.NumberofShots = 10
SWEP.Burst.Force = 0.5

SWEP.CSMuzzleFlashes = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 50
SWEP.ViewModel			= "models/doom_eternal/weapons/shotgun/shotgun.mdl"
SWEP.WorldModel			= "models/doom_eternal/weapons/shotgun/shotgun_3rd.mdl"
SWEP.UseHands           = false

SWEP.FirstDeploy = true
SWEP.IsEmpty = false

SWEP.Reticle = {}

SWEP.IsDOOMWeapon = false
SWEP.VMOffset = Vector( 0, -6, -62 )

SWEP.ZoomOffset = Vector()
SWEP.ZoomAngle = Angle()

SWEP.ZoomOffset_Grenade = Vector( 0, 0, 10 )
SWEP.ZoomAngle_Grenade = Angle()

SWEP.NextGrenadeReload = CurTime()

-- Weapon functions

function SWEP:OnInitialize()

	self:SetWeaponHoldType( "shotgun" )

	if CLIENT then

		self.Reticle[0] = Material("hud/reticle/tr_1.png", "noclamp transparent smooth" )
		self.Reticle[1] = Material("hud/reticle/sg_eternal/ret_1.png", "noclamp transparent smooth" )
		self.Reticle[2] = Material("hud/reticle/sg_eternal/ret_2.png", "noclamp transparent smooth" )
		self.Reticle[3] = Material("hud/reticle/sg_eternal/ret_3.png", "noclamp transparent smooth" )
		self.Reticle[4] = Material("hud/reticle/sg_eternal/ret_4.png", "noclamp transparent smooth" )
		self.Reticle[5] = Material("hud/reticle/sg_eternal/ret_5.png", "noclamp transparent smooth" )
		self.Reticle[6] = Material("hud/reticle/sg_eternal/ret_6.png", "noclamp transparent smooth" )
		self.Reticle[7] = Material("hud/reticle/sg_eternal/ret_7.png", "noclamp transparent smooth" )

	end
	
	self:SetActiveMod( false )
	self:SetSelectedMod( 0 )
	self:SetGrenadesLeft( 3 )

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )

	self:NetworkVar( "Int", 0, "SelectedMod" )
	self:NetworkVar( "Int", 1, "GrenadesLeft" )
	self:NetworkVar( "Int", 2, "XHairRotTarget" )
	self:NetworkVar( "Int", 3, "XHairRot" )
	
	self:NetworkVar( "Float", 0, "IronSightMul" )

end

-- Think --

function SWEP:OnThink()

	if ( self:GetActiveMod() && ( !self:GetOwner():KeyDown( IN_ATTACK2 ) || self:Ammo1() < 1 ) && self:GetNextSecondaryFire() < CurTime() ) then

		self:SetIronSightMul( 0 )
		
		if self:GetSelectedMod() == 1 then
		
			self:PlayVMSequence( "idle" )
			self:EmitSound( "doom_eternal/weapons/shotgun/shotgun_aim_grenade.ogg", 70 )
			
			self:GetOwner():SetFOV( 0, 0.5 )
			
			self:SetNextSecondaryFire( CurTime() + 0.2 )
			
		else
		
			self:PlayVMSequence( "burst_to_idle" )
			self:EmitSound( "doom_eternal/weapons/shotgun/shotgun_aim_fullauto.ogg", 70 )
			
			self:SetNextSecondaryFire( CurTime() + 0.5 )
			self:GetOwner():SetFOV( 0, 0.5 )
			
			self.Primary.Automatic = false
		
		end
		
		self:ResetXHairRot()
		self:SetActiveMod( false )
		
	end
	
	if !self:GetActiveMod() && self:GetGrenadesLeft() < 3 && self.NextGrenadeReload < CurTime() then
	
		if not IsFirstTimePredicted() then return end
	
		self:SetGrenadesLeft( self:GetGrenadesLeft() + 1 )
		self.NextGrenadeReload = CurTime() + 2.5
		
		self:EmitSound( "doom_eternal/weapons/shotgun/shotgun_grenade_reload_passive.ogg", 70, nil, nil, CHAN_AUTO )
		
	end

	--self:GetOwner():GetViewModel():SetBodygroup( 3, 1 )

end

-- Deployment --

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )

	self:SetNextPrimaryFire( CurTime() + 0.25 )
	self:SetNextSecondaryFire( CurTime() + 0.25 )

	if self.FirstDeploy && self:Ammo1() > 0 then
		self:PlayVMSequence( "intro" )
		self:EmitSoundWDelay( "doom_eternal/weapons/shotgun/shotgun_intro.ogg", 160, nil, nil, CHAN_WEAPON, 0.5 )
		self.FirstDeploy = false
	else
		self:PlayVMSequence( "bringup" )
	end

	timer.Simple( 0.1, function()
	
		if !IsValid( self ) then return end
		local vm = self:GetOwner():GetViewModel()
	
		if ( self:GetSelectedMod() == 1 ) then
			vm:SetBodygroup( 3, 1 )
		elseif ( self:GetSelectedMod() == 2 ) then
			vm:SetBodygroup( 3, 2 )
		end
	
	end)

	self.NextReload = CurTime()

end

-- Primary attack

function SWEP:PrimaryAttack()

	if not IsFirstTimePredicted() then return end

	if self:Ammo1() < self.Primary.TakeAmmo then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:PlayVMSequence( "dryfire" )
		return
	end

	if self:GetActiveMod() then
	
		if self:GetSelectedMod() == 1 then self:GrenadeAttack() else self:BurstAttack() end
		
	else

		self:TakePrimaryAmmo( self.Primary.TakeAmmo )

		self.Primary.Damage = GetConVar( "dredux_dmg_shotgun" ):GetInt() / 10
		self:BulletAttack()

		self:EmitSound( "doom_eternal/weapons/shotgun/shotgun_fire_"..math.random( 1, 3 )..".ogg", 90, nil, nil, CHAN_WEAPON )

		self.MuzzleEffect = "dredux_muzzleflash_shotgun"
		self:MuzzleFlashEffect( "muzzle" )

		self:PlayVMSequence( "shoot" )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		self:PlayVMSequenceWDelay( "shoot_delay", self:VMSequenceDuration() )

		self.Owner:ViewPunch( Angle( -10, 0, 0 ) )

		self:SetNextPrimaryFire( CurTime() + 0.8 )
		
	end

end

function SWEP:GrenadeAttack()

	self:PlayVMSequence( "shootpoprocket" )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:EmitSound( "doom_eternal/weapons/shotgun/shotgun_fire_grenade.ogg", 90, nil, nil, CHAN_WEAPON )
	self.Owner:ViewPunch( Angle( -5, 0, 0 ) )	
	
	self.MuzzleEffect = "dredux_muzzleflash_shotgunpoprocket"
	self:MuzzleFlashEffect( "muzzle" )
	
	self:ProjectileAttack( "proj_dmod_shotgungrenade_eternal", ( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40 + self.Owner:GetRight()*16.5 + self.Owner:GetUp()*1 ), 1800 )
	
	self.NextGrenadeReload = CurTime() + 2
	
	self:SetGrenadesLeft( self:GetGrenadesLeft() - 1 )
	
	if self:GetGrenadesLeft() > 0 then
	
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		
	else
	
		self:EmitSoundWDelay( "doom_eternal/weapons/shotgun/shotgun_grenade_reload.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )
		
		self:PlayVMSequenceWDelay( "poprockets_reload", self:VMSequenceDuration() )
		
		self:SetActiveMod( false )
		self:GetOwner():SetFOV( 0, 0.2)
		self.NextGrenadeReload = CurTime() + 2.5
		
		self:SetNextPrimaryFire( CurTime() + 1 )
		self:SetNextSecondaryFire( CurTime() + 2 )
	
	end

end

function SWEP:BurstAttack()

	self:PlayVMSequence( "shoot" )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self.MuzzleEffect = "dredux_muzzleflash_shotgun"
	self:MuzzleFlashEffect( "muzzle" )
	
	self:SetXHairRotTarget( self:GetXHairRotTarget() + 120 )
	
	self:PlayVMSequence( "shoot_fullauto" )
	--self:PlayVMSequenceWDelay( "shoot_fullauto_delay", self:VMSequenceDuration() )
	
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	
	self.Burst.Damage = GetConVar( "dredux_dmg_shotgun" ):GetInt() / 10
	self:BulletAttack( self.Burst )
	
	self:EmitSound( "doom_eternal/weapons/shotgun/shotgun_fire_fullauto_"..math.random(4)..".ogg", 90, nil, nil, CHAN_WEAPON )
	self.Owner:ViewPunch( Angle( -5, 0, 0 ) )
	
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	self:SetNextSecondaryFire( CurTime() + 0.5 )

end

function SWEP:SecondaryAttack()

	if self:GetActiveMod() then return end

	if ( self:GetSelectedMod() == 2 && self:Ammo1() >= 1 ) then
	
		self:PlayVMSequence( "idle_to_burst" )
		self:SetActiveMod( true )
		
		self:EmitSound( "doom_eternal/weapons/shotgun/shotgun_aim_fullauto.ogg" )
		
		self:GetOwner():SetFOV( self:GetOwner():GetFOV() - 5, 0.5)
		
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		
		self.Primary.Automatic = true
		
		self:ResetXHairRot()
		self:SetXHairRotTarget( 360 )
	
	elseif ( self:GetSelectedMod() == 1 && self:Ammo1() >= 1 && self:GetGrenadesLeft() > 0 ) then
	
		self:PlayVMSequence( "idle_grenade" )
		self:SetActiveMod( true )

		self:EmitSound( "doom_eternal/weapons/shotgun/shotgun_aim_grenade.ogg" )
		
		self:GetOwner():SetFOV( self:GetOwner():GetFOV() - 5, 0.2)
		
		self:SetNextPrimaryFire( CurTime() + 0.1 )
	
	end
	
	self:SetNextSecondaryFire( CurTime() + 0.1 )

end

function SWEP:Reload()

	if SERVER && IsFirstTimePredicted() then

		if ( self.NextReload < CurTime() && self:GetNextPrimaryFire() < CurTime() ) then

			local vm = self:GetOwner():GetViewModel()

			if self:GetOwner():KeyDown( IN_USE ) then

				if self:GetSelectedMod() == 0 then return end

				vm:SetBodygroup( 3, 0 )
				self:SetSelectedMod( 0 )
				self:EmitSoundWDelay( "doom/weapons/shotgun/shotgun_switch_grenade.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )
				self:PlayVMSequence( "switch_to_poprockets" )

			elseif ( self:GetSelectedMod() == 2 or self:GetSelectedMod() == 0 ) then

				vm:SetBodygroup( 3, 1 )
				self:SetSelectedMod( 1 )

				self:EmitSoundWDelay( "doom_eternal/weapons/shotgun/shotgun_switch_grenade.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )

				self:PlayVMSequence( "switch_to_poprockets" )

			elseif ( self:GetSelectedMod() == 1 ) then

				vm:SetBodygroup( 3, 2 )
				self:SetSelectedMod( 2 )

				self:EmitSoundWDelay( "doom_eternal/weapons/shotgun/shotgun_switch_fullauto.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )

				self:PlayVMSequence( "switch_to_poprockets" )
			end

			self.NextReload = CurTime() + 2
			self:SetNextPrimaryFire( CurTime() + 1/5 )
			self:SetNextSecondaryFire( CurTime() + 1.5 )

		end

	end

end

function SWEP:ResetXHairRot()

	self:SetXHairRot( 0 )
	self:SetXHairRotTarget( 0 )
	
end

function SWEP:OnClientThink()

	self:SetXHairRot( math.Approach( self:GetXHairRot(), self:GetXHairRotTarget(), 10 ) )

end

function SWEP:DoDrawCrosshair( x, y )

	if self:GetSelectedMod() == 0 then

		self:DrawCrosshairElementRotated( 1, 4.5, 0, 0, -1.8, 170, 200, 50, 255 )
		self:DrawCrosshairElementRotated( 1, 4.5, 180, 0, 1.8, 170, 200, 50, 255 )
		
	elseif self:GetSelectedMod() == 1 then
	
		self:DrawCrosshairElementRotated( 3, 6.5, 0, 0, 0, 170, 200, 30, 255 )
		self:DrawCrosshairElementRotated( 3, 6.5, 120, 0, 0, 170, 200, 30, 255 )
		self:DrawCrosshairElementRotated( 3, 6.5, 240, 0, 0, 170, 200, 30, 255 )
		
		local gren = self:GetGrenadesLeft()
		
		if !self:GetActiveMod() then
		
			self:DrawCrosshairElementRotated( 4, 8, 0, 0, 0, 255, 255, 255, 40 )
			self:DrawCrosshairElementRotated( 4, 8, 120, 0, 0, 255, 255, 255, 40 )
			self:DrawCrosshairElementRotated( 4, 8, 240, 0, 0, 255, 255, 255, 40 )
			
			if gren > 2 then
				self:DrawCrosshairElementRotated( 6, 6.5, 120, 0, 0, 170, 200, 50, 255 )
			else
				self:DrawCrosshairElementRotated( 6, 6.5, 120, 0, 0, 255, 255, 255, 20 )
			end
			
			if gren > 1 then
				self:DrawCrosshairElementRotated( 6, 6.5, 0, 0, 0, 170, 200, 50, 255 )
			else
				self:DrawCrosshairElementRotated( 6, 6.5, 0, 0, 0, 255, 255, 255, 20 )
			end
			
			if gren > 0 then
				self:DrawCrosshairElementRotated( 6, 6.5, 240, 0, 0, 170, 200, 50, 255 )
			else
				self:DrawCrosshairElementRotated( 6, 6.5, 240, 0, 0, 255, 255, 255, 20 )
			end
			
			
		else
		
			if gren > 2 then
				self:DrawCrosshairElementRotated( 5, 7, 120, 0, 0, 170, 200, 50, 255 )
			else
				self:DrawCrosshairElementRotated( 5, 7, 120, 0, 0, 255, 255, 255, 30 )
			end
			
			if gren > 1 then
				self:DrawCrosshairElementRotated( 5, 7, 0, 0, 0, 170, 200, 50, 255 )
			else
				self:DrawCrosshairElementRotated( 5, 7, 0, 0, 0, 255, 255, 255, 30 )
			end
			
			if gren > 0 then
				self:DrawCrosshairElementRotated( 5, 7, 240, 0, 0, 170, 200, 50, 255 )
			else
				self:DrawCrosshairElementRotated( 5, 7, 240, 0, 0, 255, 255, 255, 30 )
			end
		
		end
	
	elseif self:GetSelectedMod() == 2 then

		if !self:GetActiveMod() then
			
			self:DrawCrosshairElementRotated( 3, 6.5, 0, 0, 0, 170, 200, 30, 255 )
			self:DrawCrosshairElementRotated( 3, 6.5, 120, 0, 0, 170, 200, 30, 255 )
			self:DrawCrosshairElementRotated( 3, 6.5, 240, 0, 0, 170, 200, 30, 255 )
			
			self:DrawCrosshairElementRotated( 7, 7, 0, 0, 0, 170, 200, 50, 80 )
			self:DrawCrosshairElementRotated( 7, 7, 120, 0, 0, 170, 200, 50, 80 )
			self:DrawCrosshairElementRotated( 7, 7, 240, 0, 0, 170, 200, 50, 80 )
			
		else
			
			local rot = self:GetXHairRot()
			
			self:DrawCrosshairElementRotated( 3, 6.5, rot, 0, 0, 170, 200, 30, 255 )
			self:DrawCrosshairElementRotated( 3, 6.5, 120 + rot, 0, 0, 170, 200, 30, 255 )
			self:DrawCrosshairElementRotated( 3, 6.5, 240 + rot, 0, 0, 170, 200, 30, 255 )
			
			self:DrawCrosshairElementRotated( 7, 7, rot, 0, 0, 170, 200, 50, 255 )
			self:DrawCrosshairElementRotated( 7, 7, 120 + rot, 0, 0, 170, 200, 50, 255 )
			self:DrawCrosshairElementRotated( 7, 7, 240 + rot, 0, 0, 170, 200, 50, 255 )
		
		end

	end
	
	return true
end

local Grenade = {}

	Grenade.Type = "anim"
	Grenade.Base = "proj_drg_default"
	
	Grenade.Models = {"models/Items/AR2_Grenade.mdl"}
	Grenade.Gravity = true
	--Grenade.OnContactEffects = {"d_rpgrocket_explosion"}
	Grenade.OnContactDecals = {"Scorch"}
	Grenade.OnContactDelete = 1
	
	PrecacheParticleSystem( "d_rpgrocket_explosion" )
	
	function Grenade:CustomInitialize()
		--ParticleEffectAttach( "d_rpgrocket_trail", 1, self, 0)
		self:DynamicLight( Color( 255, 120, 0 ), 400, 0.75 )
		if SERVER then
			util.SpriteTrail( self, 0, Color( 250, 100, 0, 200 ), false, 15, 0, 0.2, 1 / ( 15 + 0 ) * 0.5, "trails/smoke" )
		end
		
		self.IsAttached = false
		
	end
	
	function Grenade:OnContact( ent )

		if !self.IsAttached then

			if !ent:IsWorld() then self:SetParent( ent ) end
			
			self:SetVelocity( Vector( 0, 0, 0 ) )
			self:SetMoveType( MOVETYPE_NONE )
			self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			
			local phys = self:GetPhysicsObject()
			if IsValid( phys ) then
				phys:EnableGravity( false )
			end
			
		end
		
		self.IsAttached = true
		
		timer.Simple( 1, function()
		
			if self:IsValid() then
			
				ParticleEffect( "d_rpgrocket_explosion", self:GetPos(), self:GetAngles() )
			
				self:EmitSound( "doom/weapons/shotgun/shotgun_grenade_explode"..math.random( 3 )..".ogg", 100, nil, nil, CHAN_WEAPON )
				util.ScreenShake( self:GetPos(), 50, 5, 0.5, 200 )
				self:RadiusDamage( GetConVar( "dredux_dmg_shotgun_grenade_sticky" ):GetInt() + math.random( -5, 5 ) , DMG_BLAST, 150 )
				
			end
			
		end)
		
	end

	scripted_ents.Register( Grenade, "proj_dmod_shotgungrenade_eternal" )
