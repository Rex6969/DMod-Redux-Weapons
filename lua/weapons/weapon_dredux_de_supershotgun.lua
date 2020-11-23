SWEP.Base = "weapon_dredux_base"

SWEP.PrintName = "Super Shotgun ( Eternal )"
SWEP.Category = "DOOM Eternal"
SWEP.Spawnable = true

SWEP.Primary.Damage = 5
SWEP.Primary.TakeAmmo = 2
SWEP.Primary.Ammo = "buckshot" --The ammo type will it use
SWEP.Primary.DefaultClip = 22
SWEP.Primary.Spread = 1.5
SWEP.Primary.NumberofShots = 20
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Force = 1

SWEP.CSMuzzleFlashes = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
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
SWEP.ViewModel			= "models/doom_eternal/weapons/supershotgun/supershotgun.mdl"
SWEP.WorldModel			= "models/doom_eternal/weapons/supershotgun/supershotgun_3rd.mdl"
SWEP.UseHands           = false

SWEP.FirstDeploy = true
SWEP.IsEmpty = false

SWEP.Reticle = {}

SWEP.IsDOOMWeapon = false
SWEP.IsDOOMEternalSSG = true
SWEP.VMOffset = Vector( 0, -6, -62 )

SWEP.IsDOOMModdableWeapon = false

SWEP.ChainMaterial = Material( "effects/doom/custom/meathook_chain.png", "vertexlitgeneric noclamp transparent smooth" )


-- Hooks functions

hook.Add( "KeyPress", "MeathookRelease", function( ply, key )

	if not IsFirstTimePredicted() then return end

	local weapon = ply:GetActiveWeapon()
	
	if weapon.IsDOOMEternalSSG && weapon:GetMeathook() && key == IN_JUMP then
	
		local vel = ply:GetVelocity()
		
		timer.Simple( 0.005, function()
		
			if IsValid( ply ) then
				ply:SetVelocity( ply:GetUp() * 300 + vel:GetNormalized() * 100 )
			end
			
		end )
		
		weapon:PlayVMSequence( "meathook_out" )
		weapon:StopMeathook()
		
	end

	return false

end)

hook.Add( "OnNPCKilled", "MeathookMastery", function( NPC, attacker, inflictor )

	--print( NPC )

	--[[if attacker:IsPlayer() then
	
		print( mastery )
	
		local weapon = attacker:GetActiveWeapon()
		if not weapon.IsDOOMEternalSSG then return end
		
		--print( mastery )
		
		if weapon:GetMeathook() then
		
			local mastery =  attacker:GetNWInt( "DOOM_Eternal_SuperShotgun_Mastery", 0 )
			
			if mastery >= 25 && !weapon:GetMastery() then
				weapon:SetMastery( true )
			else
				attacker:SetNWInt( "DOOM_Eternal_SuperShotgun_Mastery", mastery + 1 ) 
			end
			
		end
	end]]
	
end )

-- Weapon functions


function SWEP:OnInitialize()

	self:SetWeaponHoldType( "shotgun" )
	
	if CLIENT then
	
		self.Reticle[1] = Material("hud/reticle/ssg_eternal/ret_1.png", "noclamp transparent smooth" )
		self.Reticle[2] = Material("hud/reticle/ssg_eternal/ret_2.png", "noclamp transparent smooth" )
		self.Reticle[3] = Material("hud/reticle/ssg_eternal/ret_3.png", "noclamp transparent smooth" )
		self.Reticle[4] = Material("hud/reticle/ssg_eternal/ret_4.png", "noclamp transparent smooth" )
		self.Reticle[5] = Material("hud/reticle/ssg_eternal/ret_5.png", "noclamp transparent smooth" )
		self.Reticle[6] = Material("hud/reticle/ssg_eternal/ret_6.png", "noclamp transparent smooth" )
		self.Reticle[7] = Material("hud/reticle/ssg_eternal/ret_7.png", "noclamp transparent smooth" )
	
	end
	
	self:SetMeathookReady( true )
	self:SetMeathook( false )
	self:SetMastery( false )
	
	if SERVER then
		util.PrecacheModel( "models/doom_eternal/weapons/supershotgun/chain_segment.mdl" )
		util.PrecacheModel( "models/doom_eternal/weapons/supershotgun/chain_meathook.mdl" )
	end
	
end

-- Think --

function SWEP:OnThink()
	
	if self:IsValid() then self:ProcessMeathook() end
	
end

-- Variables --


function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "MeathookReady" )
	self:NetworkVar( "Bool", 1, "Meathook" )
	self:NetworkVar( "Entity", 2, "MeathookEntity" )
	
	self:NetworkVar( "Entity", 3, "MeathookEnd" )
	
	self:NetworkVar( "Bool", 10, "Mastery" )

end

-- Deployment --

function SWEP:OnDeploy()

	if not IsFirstTimePredicted() then return end
	self:EmitSound( "doom/weapons/switch_weapon.ogg" )
	
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	self:SetNextSecondaryFire( CurTime() + 0.25 )
	
	if self.FirstDeploy and self:Ammo1() > 0 then
		self:EmitSound( "doom_eternal/weapons/supershotgun/ssg_intro.ogg" )
		self:PlayVMSequence( "intro" )
		self.FirstDeploy = false
	else
		self:EmitSound( "doom/weapons/switch_weapon.ogg" )
		self:PlayVMSequence( "bringup" )
	end
	
	self:StopMeathook()
	
end

function SWEP:OnHolster()
	self:StopMeathook()
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
	
	if self:GetMeathook() then self:StopMeathook() end
	
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	self.Primary.Damage = GetConVar( "dredux_dmg_supershotgun" ):GetInt() / 20
	
	self:BulletAttack()
	
	self:EmitSoundWDelay( "doom_eternal/weapons/supershotgun/ssg_fire.ogg", 160, nil, nil, CHAN_WEAPON, 0.07 )
	--self:EmitSound( "doom/weapons/ssg/ssg_fire.ogg", 90, nil, nil, CHAN_WEAPON )
	
	self.MuzzleEffect = "dredux_muzzleflash_shotgun"
	self:MuzzleFlashEffect( "muzzle_left" )
	self:MuzzleFlashEffect( "muzzle_right" )
	
	self:PlayVMSequence( "meathook_out" )
	self:PlayVMSequence( "shoot" )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:PlayVMSequenceWDelay( "shoot_reload", self:VMSequenceDuration() + 0.05 )
	
	self.Owner:ViewPunch( Angle( -10, 0, 0 ) )
	
	self:SetNextPrimaryFire( CurTime() + 1.45 )
	self:SetNextSecondaryFire( CurTime() + 1.45 )
	
end

-- Meathook

function SWEP:SecondaryAttack()

	if ( !self:GetMeathookReady() || self:GetMeathook() ) then return end
	
	self:BeginMeathook()
	
	self:SetNextSecondaryFire( CurTime() + 0.1 )
	
end

function SWEP:BeginMeathook()

	local vm = self.Owner:GetViewModel()
	local aim = self.Owner:GetAimVector()
	local pos = self.Owner:GetShootPos()

	local owner = self:GetOwner()

	local trdata = {}
	trdata.start = pos
	trdata.endpos = pos + aim * 1500
	trdata.mins = Vector( -20, -20, -20 )
	trdata.maxs = Vector( 20, 20, 20 )
	trdata.filter = { self.Owner, game.GetWorld() }

	local direction = util.TraceHull( trdata )
	
	debugoverlay.Cross( direction.HitPos, 25, 25, 10 )
	
	if ( !direction.Hit ) then return end
	local direction_normal = ( direction.HitPos - pos ):GetNormalized()
	local dist = 1500 * direction.Fraction 

	if ( direction.Entity:IsNPC() || direction.Entity:IsNextBot() || direction.Entity:IsPlayer() ) then

		if !SERVER then return end

		self:SetMeathookReady( false )
		self:SetMeathook( true )
		self:SetMeathookEntity(  direction.Entity )
		
		-- Owner physics
		owner:SetGravity( 0.5 )
		owner:SetVelocity( direction_normal * 50 + owner:GetVelocity():GetNormalized() * 50 )
		
		-- Hook entity
		
		local hook = ents.Create( "prop_dynamic" )
		hook:SetModel( "models/doom_eternal/weapons/supershotgun/chain_meathook.mdl" )
		hook:SetModelScale( 1 )
		hook:SetPos( direction.HitPos )
		hook:SetParent( direction.Entity )
		hook:SetAngles( direction_normal:Angle() )
		
		self.Chain = ents.Create( "ent_dmod_meathook" )
		self.Chain:SetOwner( self:GetOwner() )
		self.Chain:Activate()
		self.Chain:Spawn()
		self:DeleteOnRemove( self.Chain )
		
		self:PlayVMSequence( "meathook_into" )
		
		if self:GetMastery() then direction.Entity:Ignite( 5 ) end
		
		self:DeleteOnRemove( hook )
		self:SetMeathookEnd( hook )
		
	end

end

function SWEP:ProcessMeathook()

	local owner = self:GetOwner()
	local ent = self:GetMeathookEntity()
	local meathook = self:GetMeathookEnd()

	if !self:GetMeathook() || !ent then return end

	if SERVER then

		local selfpos = self:GetOwner():GetPos()
		local target = self:GetMeathookEntity():NearestPoint( selfpos )

		if ( !IsValid( ent ) || !IsValid( meathook ) || !self:IsInCone( ent, owner:GetFOV() - 20 ) || !self:VisibleVec( meathook:GetPos() ) || selfpos:DistToSqr( target ) < 100^2 || selfpos:DistToSqr( target ) > 1000^2 ) then
			self:PlayVMSequence( "meathook_out" )
			self:StopMeathook()
		end
	
	end
	
	if SERVER and IsValid( meathook ) then
	
		local owner = self:GetOwner()
		
		local pos = meathook:GetPos()
		local direction_normal = ( pos - owner:GetPos() ):GetNormalized()
		
		if owner:IsOnGround() then
		
			local Velocity = owner:GetVelocity()
			owner:SetVelocity( -Velocity )
			owner:SetVelocity( direction_normal * 80 + Velocity:GetNormalized() * 5 )
			
		else
		
			local Velocity = owner:GetVelocity()
			owner:SetVelocity( -Velocity )
			owner:SetVelocity( direction_normal * 20 + Velocity:GetNormalized() * 2 )
		end
	
	end
	
end

function SWEP:StopMeathook()

	if IsValid( self ) and self:GetMeathook() then

		self:SetMeathook( false )
		
		if IsValid( self.MeathookChain ) then self.MeathookChain:Remove() end
		
		self:GetOwner():SetGravity( 1 )
		self:GetOwner():SetVelocity( self:GetOwner():GetVelocity():GetNormalized() * 50 )
		timer.Simple( 3, function() if self:IsValid() then self:SetMeathookReady( true ) end end)
		
		self:EmitSound( "doom_eternal/weapons/supershotgun/ssg_meathook_detach.ogg", nil, nil, nil, CHAN_WEAPON )
		
		if SERVER then
			if IsValid( self:GetMeathookEnd() ) then self:GetMeathookEnd():Remove() end
			if IsValid( self.Chain ) then self.Chain:Remove() end
		end
		
	end
	
end

-- Bone scaler

function SWEP:SetVMeathHook( set )

	local vm = self:GetOwner():GetViewModel()
	vm:ManipulateBoneScale( vm:LookupBone( "hooktip_part01_md" ), set )
	vm:ManipulateBoneScale( vm:LookupBone( "hooktip_hooktipleft_md" ), set )
	vm:ManipulateBoneScale( vm:LookupBone( "hooktip_hooktipright_md" ), set )
	

end

-- Crosshair

SWEP.HookOffsetX = 0.4
SWEP.HookOffsetY = 2.5

function SWEP:OnClientThink()

	if ( self:GetMeathookReady() || self:GetMeathook() ) then

		self.HookOffsetY = math.Approach( self.HookOffsetY, 2.5, 0.5 )
		self.HookOffsetX = math.Approach( self.HookOffsetX, 0.4, 0.5 )
		
	else

		self.HookOffsetY = math.Approach( self.HookOffsetY, 0, 0.5 )
		self.HookOffsetX = math.Approach( self.HookOffsetX, 3, 0.5 )
		
	end

end

function SWEP:DoDrawCrosshair( x, y )

	if ( self:GetMeathookReady() || self:GetMeathook() ) then
	
		self:DrawCrosshairElementRotated( 1, 12, 0, 0, 0, 170, 200, 50, 255 )
		
		self:DrawCrosshairElementRotated( 2, 1.8, 0, -self.HookOffsetX, self.HookOffsetY, 170, 200, 50, 255 )
		self:DrawCrosshairElementRotated( 3, 1.8, 0, self.HookOffsetX, self.HookOffsetY, 170, 200, 50, 255 )
		
	else

		self:DrawCrosshairElementRotated( 1, 12, 0, 0, 0, 255, 50, 50, 100 )
		
		self:DrawCrosshairElementRotated( 2, 1.8, 0, -self.HookOffsetX, self.HookOffsetY, 255, 50, 50, 255 )
		self:DrawCrosshairElementRotated( 3, 1.8, 0, self.HookOffsetX, self.HookOffsetY, 255, 50, 50, 255 )
		
	end
	
	return true
	
end