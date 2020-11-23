SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Chaingun"
SWEP.Category = "DOOM"

SWEP.Primary.Ammo = "none"

SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Ammo = "smg1" --The ammo type will it use
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Spread = 0.65
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.TracerName = "dredux_tracer_har"
SWEP.Primary.Force = 0.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= "none"

SWEP.Spawnable = true

SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 48
SWEP.ViewModel			= "models/doom/weapons/chaingun/chaingun.mdl"
SWEP.WorldModel			= "models/doom/weapons/chaingun/chaingun_3rd.mdl"
SWEP.UseHands           = false

SWEP.IsDOOMModdableWeapon = true
SWEP.IsDOOMWeapon = true

SWEP.FirstDeploy = true

SWEP.IsRotatingBarrels = false
SWEP.NextBarrelSound = CurTime()
SWEP.CurrentBarrel = 1
SWEP.OverHeat = false

function SWEP:OnInitialize()

	if CLIENT then
	
		self.Reticle = {}
		self.Reticle[0] = Material("hud/delay/MTR50.png", "smooth" )
		self.Reticle[1] = Material("hud/reticle/sg/ret_4.png", "smooth" )
		self.Reticle[2] = Material("hud/reticle/cg/ret_1.png", "smooth" )
			
		self.Delay = {}
		for i = 1,50 do
			self.Delay[i] = Material("hud/delay/MTR"..i..".png", "noclamp transparent smooth" )
		end
	
	end
	
	self.NextReload = CurTime()

end

----------------------------------------------------------------------------------------------------

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ActiveMod" )

	self:NetworkVar( "Int", 0, "SelectedMod" )
	self:NetworkVar( "Int", 1, "BarrelRot" )
	self:NetworkVar( "Int", 2, "BarrelRotTarget" )
	
	self:NetworkVar( "Float", 0, "BarrelSpeed" )
	self:NetworkVar( "Float", 1, "BarrelHeat" )

end

----------------------------------------------------------------------------------------------------

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	
	self:SetHoldType( "physgun" )
	self:SetNextPrimaryFire( CurTime() + 1 )
	
	local vm = self:GetOwner():GetViewModel()
	if self.FirstDeploy and self:Ammo1() > 0 then
		self:EmitSoundWDelay( "doom/weapons/chaingun/chaingun_intro.ogg", nil, nil, nil, CHAN_WEAPON, 0.4 )
		self:PlayVMSequence( "intro" )
		self.FirstDeploy = false
	else
		self:PlayVMSequence( "bringup" )
	end
	
	timer.Simple( 0.01, function()
	
		if IsValid( self ) then
		
			if self:GetSelectedMod() == 1 then
				vm:SetBodygroup( 2, 1 )
			elseif self:GetSelectedMod() == 2 then
				vm:SetBodygroup( 3, 1 )
				vm:SetBodygroup( 4, 1 )
			end
		
		
		self:UpdateWMBodygroup()
		end
	
	end)
	
	self:CallOnClient( "ResetBarrelRotation" )
	self:SetActiveMod( false )
	self:SetBarrelSpeed( 0 )
	
end

function SWEP:OnHolster( wep )

	self:CallOnClient( "ResetBarrelRotation" )
	
end

function SWEP:OnRemove()

	self:CallOnClient( "ResetBarrelRotation" )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:OnThink()

	local barrel_speed = self:GetBarrelSpeed()
	local heat = self:GetBarrelHeat()
	
	if heat > 0 then self:SetBarrelHeat( math.Clamp( heat - 0.005, 0, 1 ) ) end
	
	if heat >= 1 then
			self.OverHeat = true
	elseif heat == 0 then
		self.OverHeat = false
	end
		
	
	if !self:GetActiveMod() then
	
		if ( ( self:GetOwner():KeyDown( IN_ATTACK ) && self:Ammo1() > 0 ) && !( barrel_speed <= 0 && self:GetNextPrimaryFire() > CurTime() ) ) || ( self:GetSelectedMod() == 1 && ( self:GetOwner():KeyDown( IN_ATTACK2 ) ) ) then
			self:SetBarrelSpeed( math.Clamp( barrel_speed + 0.01, 0.1, 1 ) )
		elseif ( !self:GetOwner():KeyDown( IN_ATTACK ) || self:Ammo1() <= 0 ) then
			self:SetBarrelSpeed( math.Clamp( barrel_speed - 0.01, 0, 1 ) )
		end
	
	
		if barrel_speed > 0.25 and !self.IsRotatingBarrels then
		
			self.IsRotatingBarrels = true
			self:EmitSound( "doom/weapons/chaingun/chaingun_barrel_loop_start.ogg", nil, nil, nil, CHAN_WEAPON )
			self.NextBarrelSound = CurTime() + 0.6

		elseif barrel_speed <= 0.25 and self.IsRotatingBarrels then
		
			self.IsRotatingBarrels = false
			self:EmitSound( "doom/weapons/chaingun/chaingun_barrel_loop_end.ogg", nil, nil, nil, CHAN_WEAPON )
		
		end
		
		if self.IsRotatingBarrels and self.NextBarrelSound < CurTime() then
		
			self:EmitSound( "doom/weapons/chaingun/chaingun_barrel_loop.ogg", nil, nil, nil, CHAN_WEAPON )
			self.NextBarrelSound = CurTime() + 1
		
		end
		
	else
	
		local is_shooting = self:CanShootTurret()
		
		if !self:GetOwner():KeyDown( IN_ATTACK2 ) && self:GetNextSecondaryFire() < CurTime() then
		
			self:SetActiveMod( false )
			self:SetBarrelSpeed( 0 )
			
			self:EmitSoundWDelay( "doom/weapons/chaingun/chaingun_turret_out.ogg" )
			self:PlayVMSequence( "turretmode_out" )
	
			self:CallOnClient( "ResetBarrelRotation" )
			
			self:SetNextPrimaryFire( CurTime() + 0.6 )
			self:SetNextSecondaryFire( CurTime() + 0.5 )
		
		end
		
		if is_shooting and !self.IsRotatingBarrels then
		
			self.IsRotatingBarrels = true
			self:EmitSound( "doom/weapons/chaingun/chaingun_turret_start.ogg", nil, nil, nil, CHAN_WEAPON )
			self.NextBarrelSound = CurTime() + 0.8

		elseif !is_shooting and self.IsRotatingBarrels then
		
			self.IsRotatingBarrels = false
			self:EmitSound( "doom/weapons/chaingun/chaingun_turret_end.ogg", nil, nil, nil, CHAN_WEAPON )
		
		end
		
		if self.IsRotatingBarrels and self.NextBarrelSound < CurTime() then
		
			self:EmitSound( "doom/weapons/chaingun/chaingun_turret_loop.ogg", nil, nil, nil, CHAN_WEAPON )
			self.NextBarrelSound = CurTime() + 2.1
		
		end
	
	end
	
end

function SWEP:CanShootTurret()
	return self:GetOwner():KeyDown( IN_ATTACK ) && self:Ammo1() > 0 && self:GetNextSecondaryFire() < CurTime() && !self.OverHeat
end

----------------------------------------------------------------------------------------------------

function SWEP:Reload()

	if IsFirstTimePredicted() then

		if ( self.NextReload < CurTime() && self:GetNextPrimaryFire() < CurTime() ) then 

			local vm = self:GetOwner():GetViewModel()
			self:CallOnClient( "ResetBarrelRotation" )

			if self:GetOwner():KeyDown( IN_USE ) then
			
				if self:GetSelectedMod() == 0 then return end
			
				vm:SetBodygroup( 2, 0 )
				vm:SetBodygroup( 3, 0 )
				vm:SetBodygroup( 4, 0 )
				
				self:SetSelectedMod( 0 )

				self:SetBodygroup( 1, 0 )
				
				self:EmitSoundWDelay( "doom/weapons/chaingun/chaingun_switch_turret.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )
				self:PlayVMSequence( "switch_to_turret" )

			elseif ( self:GetSelectedMod() == 2 or self:GetSelectedMod() == 0 ) then
			
				vm:SetBodygroup( 2, 1 )
				vm:SetBodygroup( 3, 0 )
				vm:SetBodygroup( 4, 0 )
				
				self:SetSelectedMod( 1 )
				self:SetBodygroup( 0, 1 )
				
				self:EmitSoundWDelay( "doom/weapons/chaingun/chaingun_switch_gatling.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )
				self:PlayVMSequence( "switch_to_gatling" )
				
			elseif ( self:GetSelectedMod() == 1 ) then
			
				vm:SetBodygroup( 2, 0 )
				vm:SetBodygroup( 3, 1 )
				vm:SetBodygroup( 4, 1 )
				
				self:SetSelectedMod( 2 )
				self:SetBodygroup( 0, 2 )
				
				self:EmitSoundWDelay( "doom/weapons/chaingun/chaingun_switch_turret.ogg", nil, nil, nil, CHAN_AUTO, 0.6 )
				self:PlayVMSequence( "switch_to_turret" )
				
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

	local vm = self:GetOwner():GetViewModel()
	if !IsValid( vm ) || !self:GetNWBool( "ActiveWeapon", false ) then return end

	if !self:GetActiveMod() then

		self:SetBarrelRot( math.Approach( self:GetBarrelRot(), self:GetBarrelRotTarget(), 10 * self:GetBarrelSpeed() ) )

		if self:GetSelectedMod() ~= 2 then
			local bone = vm:LookupBone( "base_barrel_jnt" )
			if bone then vm:ManipulateBoneAngles( bone, Angle( 0, 0, self:GetBarrelRot() ) ) end
		else
			local bone = vm:LookupBone( "mod_turret_barrel_jnt" )
			if bone then vm:ManipulateBoneAngles( bone, Angle( 0, 0, self:GetBarrelRot() ) ) end
		end
		
		if self:GetNextPrimaryFire() > CurTime() and self:CanShootTurret() then vm:ManipulateBoneAngles( vm:LookupBone( "base_mag_ring_jnt" ), Angle( 0, 0, -self:GetBarrelRot() ) ) end
		
	else

		if self:CanShootTurret() then
			self:SetBarrelRot( math.Approach( self:GetBarrelRot(), self:GetBarrelRotTarget(), 20 ) )

			vm:ManipulateBoneAngles( vm:LookupBone( "mod_turret_barrel_1_jnt" ), Angle( 0, 0, self:GetBarrelRot() ) )
			vm:ManipulateBoneAngles( vm:LookupBone( "mod_turret_barrel_2_jnt" ), Angle( 0, 0, -self:GetBarrelRot() ) )
			vm:ManipulateBoneAngles( vm:LookupBone( "mod_turret_barrel_3_jnt" ), Angle( 0, 0, self:GetBarrelRot() ) )
		end
		
	end

end

----------------------------------------------------------------------------------------------------

function SWEP:ResetBarrelRotation()

	self:SetBarrelRot( 0 )
	self:SetBarrelRotTarget( 0 )
	
	local vm = self:GetOwner():GetViewModel()
	if IsValid( vm ) then
		vm:ManipulateBoneAngles( vm:LookupBone( "base_barrel_jnt" ), Angle( 0, 0, 0 ) )
		vm:ManipulateBoneAngles( vm:LookupBone( "mod_turret_barrel_jnt" ), Angle( 0, 0, 0 ) )
		vm:ManipulateBoneAngles( vm:LookupBone( "mod_turret_barrel_1_jnt" ), Angle( 0, 0, 0 ) )
		vm:ManipulateBoneAngles( vm:LookupBone( "mod_turret_barrel_2_jnt" ), Angle( 0, 0, 0 ) )
		vm:ManipulateBoneAngles( vm:LookupBone( "mod_turret_barrel_3_jnt" ), Angle( 0, 0, 0 ) )
	
		vm:ManipulateBoneAngles( vm:LookupBone( "base_mag_ring_jnt" ), Angle( 0, 0, 0 ) )
	end
	
end

----------------------------------------------------------------------------------------------------

function SWEP:PrimaryAttack()

	if self:Ammo1() < self.Primary.TakeAmmo then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:PlayVMSequence( "dryfire" )
		return 
	end
	
	if self:GetActiveMod() then return self:TurretAttack() end

	self:PlayVMSequence( "shoot_1" )
	
	local primary = table.Copy( self.Primary )
	primary.Damage = GetConVar( "dredux_dmg_chaingun" ):GetInt()
	primary.Spread = math.Clamp( self:GetBarrelSpeed() , 0.2, 0.8 ) 
	
	self.Owner:SetViewPunchAngles( Angle( -2, math.random( -6, 6) * 0.1 , 0 ) )
	
	self.MuzzleEffect = "dredux_muzzleflash_chaingun"
	self:MuzzleFlashEffect()
	
	self:EmitSound( "doom/weapons/chaingun/chaingun_fire.ogg", 80, math.random( 95, 105 ), 0.8, CHAN_VOICE_BASE )
	
	self:BulletAttack( primary )
	self:TakePrimaryAmmo( 1 )
	
	self:SetBarrelRotTarget( self:GetBarrelRotTarget() + 120 )
	
	self:SetNextPrimaryFire( CurTime() + math.Clamp( ( 0.1 / self:GetBarrelSpeed() ), 0.1, 0.5 ) )
	
end

----------------------------------------------------------------------------------------------------

function SWEP:TurretAttack()

	if self.OverHeat then return end
	
	self:PlayVMSequence( "shoot_turret_1" )
	
	self:SetBarrelHeat( self:GetBarrelHeat() + 0.03 )
	self:SetBarrelRotTarget( self:GetBarrelRotTarget() + 120 )
	
	local primary = table.Copy( self.Primary )
	primary.Damage = GetConVar( "dredux_dmg_chaingun_turret" ):GetInt()
	primary.Spread = 0.9
	--primary.TracerName = "none"
	
	self.Owner:SetViewPunchAngles( Angle( -1, math.Rand( -5, 5) * 0.1 , 0 ) )
	
	self:CallOnClient( "ChangeTurretBarrel" )
	self:BulletAttack( primary )
	self:TakePrimaryAmmo( 1 )
	
	self.MuzzleEffect = "dredux_chaingun_turret_muzzleflash"
	self:MuzzleFlashEffect()

	self:SetNextPrimaryFire( CurTime() + 0.035 )

end

function SWEP:ChangeTurretBarrel()
	self.CurrentBarrel = self.CurrentBarrel < 3 && self.CurrentBarrel + 1 || 1
end

----------------------------------------------------------------------------------------------------

function SWEP:SecondaryAttack()

	if self:GetSelectedMod() == 1 then
	
		self:SetBarrelRotTarget( self:GetBarrelRotTarget() + 120 )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		
	elseif self:GetSelectedMod() == 2 and !self:GetActiveMod() then
	
		self:EmitSoundWDelay( "doom/weapons/chaingun/chaingun_turret_into.ogg" )
		self:PlayVMSequence( "turretmode_into" )
	
		self:SetActiveMod( true )
		
		self:SetBarrelSpeed( 0 )
	
		self:CallOnClient( "ResetBarrelRotation" )
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetNextSecondaryFire( CurTime() + 0.5 )
		
	end

end

----------------------------------------------------------------------------------------------------

--[[if CLIENT then

	--local WorldModel = ClientsideModel( SWEP.WorldModel )
	
	--WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
	
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			self:FollowBone( self:GetOwner(), "ValveBiped"

            self:SetupBones()
			
		else
		
			self:SetPos(self:GetPos())
			self:SetAngles(self:GetAngles())
			
		end

		self:DrawModel()
		
	end
	
end]]

----------------------------------------------------------------------------------------------------

function SWEP:DoDrawCrosshair()

	local mod = self:GetSelectedMod()
	local active = self:GetActiveMod()
	
	self:DrawCrosshairElementRotated( 1, 0.75, 0, 0, -2.55, 180, 180, 180, 200 )
	self:DrawCrosshairElementRotated( 1, 1, 90, -2.5, 0, 180, 180, 180, 200 )
	self:DrawCrosshairElementRotated( 1, 1, 90, 2.6, 0, 180, 180, 180, 200 )
	self:DrawCrosshairElementRotated( 1, 1, 180, 0, 2.55, 180, 180, 180, 200 )

	self:DrawCrosshairElementRotated( 0, 6, 0, 0, 0, 200, 200, 200, 200 )

	if !active && self:GetBarrelSpeed() > 0 then
		self:DrawDelay( math.Clamp( math.ceil( self:GetBarrelSpeed() * 50 ), 1, 50 ), 0.06, 120, 255, 120, 255 )
	elseif active && self:GetBarrelHeat() > 0 then
		self:DrawDelay( math.Clamp( math.ceil( self:GetBarrelHeat() * 50 ), 1, 50 ), 0.06, 255, 0, 0, 255 )
	end

	return true

end