SWEP.Base = "weapon_base"

SWEP.Author = "Rex"
SWEP.Contact = ""
SWEP.Purpose = "Rip and Tear!"
SWEP.Instructions = "Aim and pull the trigger. R to change weapon mods. RMB to use them."
SWEP.Category = "DOOM"

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.IsPlayingIntroAnimation = true

SWEP.Primary.ClipSize = -1
SWEP.VMOffset = Vector()

SWEP.IsDOOMModdableWeapon = true

SWEP.MuzzleEffect = "dredux_muzzleflash"
SWEP.NextReload = CurTime()

----------------------------------------------------------------------------------------------------
-- Weapon functions
----------------------------------------------------------------------------------------------------

function SWEP:Initialize()
	self.FirstDeploy = true
	self:OnInitialize()
	return
end

function SWEP:Equip( ent )
end

function SWEP:OnInitialize()
	return
end

function SWEP:Think()
	self:OnThink()
	self:CallOnClient( "OnClientThink" )
	return
end

function SWEP:Deploy()
	self:SetNWBool( "ActiveWeapon", true )
	self:OnDeploy()
	self.FirstDeploy = false
	return
end

function SWEP:Holster( wep, arg )

	if self:GetNWBool( "ActiveWeapon", false ) then 
		self:OnHolster()
		self:SetNWBool( "ActiveWeapon", false )
		timer.Simple( 0.05, function()
			if IsValid( wep ) and SERVER then self:GetOwner():SelectWeapon( wep:GetClass() ) end
		end)
		return false
	else
		return true
	end
	
end

function SWEP:PrimaryAttack()
	return
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Reload()
	return
end

----------------------------------------------------------------------------------------------------

function SWEP:OnInitialize() return end
function SWEP:OnClientThink() return end
function SWEP:OnThink() return end
function SWEP:OnDeploy() return end
function SWEP:OnHolster() return true end

----------------------------------------------------------------------------------------------------

function SWEP:MuzzleFlashEffect( att )

	if IsFirstTimePredicted() then
		local fx = EffectData()
		fx:SetEntity(self)
		fx:SetOrigin(self.Owner:GetShootPos())
		att = att and self:LookupAttachment( att ) or 1
		fx:SetAttachment( att )
		util.Effect(self.MuzzleEffect, fx)
	end
	
end

function SWEP:UpdateWMBodygroup()

	if SERVER then self:CallOnClient( "UpdateWMBodygroup" ) end
	self:SetBodygroup( 0, self:GetSelectedMod() )
	
end

function SWEP:GetSelectedMod()
	return 0
end

----------------------------------------------------------------------------------------------------

SWEP.MeleeAnim = "range_melee_shove"

function SWEP:MeleeAttack()

	local owner = self:GetOwner()

	--owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, self:GetSequenceActivity( self:LookupSequence( self.MeleeAnim ) ), true )
	self:CallOnClient( "PlayMeleeGesture" )
	
	self:PlayVMSequence( "melee_1" )

	self:EmitSound( "doom/weapons/Melee Swing "..math.random( 3 )..".ogg" )
	owner:ViewPunch( Angle( -5, math.random( 5, 4 ), 0 ) )
	
	local dmg = GetConVar( "dredux_dmg_fists" ):GetInt()
	local hitent = owner:TraceHullAttack( owner:GetShootPos(), owner:GetShootPos() + owner:GetAimVector() * 80, Vector( -10, -10, -10 ), Vector( 10, 10, 10 ), dmg + math.random( 0, 5 ), DMG_CLUB, 2, false )
	
	debugoverlay.Cross( owner:GetShootPos() + owner:GetAimVector() * 50, 25, 1 )
	
	if IsValid( hitent ) then
	
		self:EmitSound( "doom/weapons/Melee Hit Wall "..math.random( 2 )..".ogg" )
		print( hitent:GetClass() )
	
	end
	
	self:OnMeleeAttack()
	
	self:SetNextPrimaryFire( CurTime() + 0.7 )

end

function SWEP:OnMeleeAttack() return end

function SWEP:PlayMeleeGesture()
	self:GetOwner():AnimRestartGesture( 1, ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND, true )
end

----------------------------------------------------------------------------------------------------
-- OBSOLETE
----------------------------------------------------------------------------------------------------

function SWEP:GetViewModelPosition( EyePos, EyeAng )

	local Offset
	local Mul = 1.0
	
	Offset = self.VMOffset
	EyePos = self:GetCustomEyePos( EyePos, EyeAng, Offset )
	
	return EyePos, EyeAng
	
end

----------------------------------------------------------------------------------------------------

function SWEP:GetCustomEyePos( EyePos, EyeAng, Offset )

	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + Offset.x * Right
	EyePos = EyePos + Offset.y * Forward
	EyePos = EyePos + Offset.z * Up

	return EyePos

end

----------------------------------------------------------------------------------------------------
-- Shared utility functions
----------------------------------------------------------------------------------------------------

function SWEP:GetTableValue( tbl )
	if not tbl then return end
	return tbl[math.random( #tbl ) ]
end

function SWEP:GetVMAttachment( att )
	local vm = self.Owner:GetViewModel( )
	return vm:GetAttachment( vm:LookupAttachment( att ) )
end

function SWEP:CanPlayAnimation()
	return self.NextAnimation < CurTime()
end

function SWEP:IsInCone(ent, angle )
	local selfpos = self:GetOwner():GetShootPos()
	local forward = self:GetOwner():GetAimVector()
	return (selfpos + forward):DrG_Degrees(ent:GetPos(), selfpos) <= angle/2
end

----------------------------------------------------------------------------------------------------
-- Animations
----------------------------------------------------------------------------------------------------

function SWEP:PlayVMSequence( seq, restrict )
	if !self:GetNWBool( "ActiveWeapon", false ) then return end
	local vm = self.Owner:GetViewModel( )
	vm:SendViewModelMatchingSequence( vm:LookupSequence( seq ) )
	local delay = CurTime() + self:VMSequenceDuration( seq  )
	self.NextAnimation = delay + 0.5
	self.NextIdleAnimation = delay + 0.5
	if restrict then
		self:SetNextPrimaryFire( delay )
	end
end

function SWEP:PlayVMSequenceWDelay( seq, delay, restrict )
	local delay = delay or 0
	self.NextAnimation = delay + 0.5
	self.NextIdleAnimation = delay + 0.5
	timer.Simple( delay, function()
		if IsValid( self ) and self:GetNWBool( "ActiveWeapon", false ) then
			self:PlayVMSequence( seq, restrict )
		end
	end)
end

function SWEP:VMSequenceDuration( seq, restrict )
	if not IsValid( self ) then return 0 end 
	local vm = self.Owner:GetViewModel( )
	local seq = seq or self:GetSequence()
	return vm:SequenceDuration( vm:LookupSequence( seq ) )
end

----------------------------------------------------------------------------------------------------
-- Sounds
----------------------------------------------------------------------------------------------------

function SWEP:EmitSoundWDelay( soundName, soundLevel, pitchPercent, volume, channel, delay, IsIntroSound )
	local delay = delay or 0
	timer.Simple( delay, function()
		if ( IsIntroSound && !self.IsPlayingIntroAnimation ) then return end
		if IsValid( self ) and self:GetNWBool( "ActiveWeapon", false ) then
			self:EmitSound(soundName, soundLevel, pitchPercent, volume, channel )
		end
	end)
end

----------------------------------------------------------------------------------------------------
-- Attack functions
----------------------------------------------------------------------------------------------------

-- Bullet Attack

function SWEP:BulletAttack( tbl, func )

	if !self:GetNWBool( "ActiveWeapon", false ) then return end

	local tbl = tbl or self.Primary
	local bullet = {} 
	bullet.Num = tbl.NumberofShots 
	bullet.Src = self.Owner:GetShootPos() 
	bullet.Dir = self.Owner:GetAimVector() 
	
	if tbl.Spread then 
		bullet.Spread = Vector( tbl.Spread*0.1 , tbl.Spread*0.1, 0) 
	else
		bullet.Spread = Vector( tbl.SpreadY*0.1 , 0, tbl.SpreadX*0.1) 
	end
	
	bullet.Tracer = 1
	bullet.TracerName = tbl.TracerName or "tracer"
	bullet.Force = tbl.Force 
	bullet.Damage = tbl.Damage 
	bullet.AmmoType = tbl.Ammo 
	bullet.Callback = func or function( ent, tr, dmg ) return true end
	self.Owner:FireBullets( bullet ) 
	
end

-- Projectile Attack

function SWEP:ProjectileAttack( proj, att, vel )
	
	if !self:GetNWBool( "ActiveWeapon", false ) then return end
	
	if CLIENT then return end
	
	local proj = proj or "rpg_missile"
	
	local vm = self.Owner:GetViewModel()
	local aim = self.Owner:GetAimVector()
	local pos = self.Owner:GetShootPos()

	local trdata = {}
	trdata.start = pos
	trdata.endpos = pos + aim * 10000
	trdata.filter = self.Owner

	local targ = util.TraceLine( trdata )
	if !targ.Hit then 
		vel = aim:GetNormalized() * vel 
	else
		vel = ( targ.HitPos - att ):GetNormalized() * vel
	end
	
	--debugoverlay.Cross( targ.HitPos, 10, 3 )
	--debugoverlay.Cross( pos + targ.HitPos:GetNormalized() + Vector( 0, 0, 10 ), 10, 3 )

	local cur_proj = ents.Create( proj )
	cur_proj:SetPos( att )
	cur_proj:SetAngles( vel:Angle() )
	cur_proj:SetOwner( self.Owner )
	
	cur_proj:Spawn()
	cur_proj:Activate()
	
	local phys = cur_proj:GetPhysicsObject()
	if IsValid( phys ) then
		phys:SetVelocity( vel )
	end
end

----------------------------------------------------------------------------------------------------
-- HUD drawing functions
----------------------------------------------------------------------------------------------------

function SWEP:DrawCrosshairElementRotated( index, size, ang, x, y, r, g, b, a, flipx )

	surface.SetMaterial( self.Reticle[index] )
	surface.SetDrawColor( r || 255, g || 255, b || 255, a || 200 )
	local w = ScrW()
	local h = ScrH()
	surface.DrawTexturedRectRotated( w*0.5 + w*x*0.01, h*0.5 + w*y*0.01, w*size*0.01, w*size*0.01, ang )

end

function SWEP:DrawScreenOverlay( index, size, r, g, b, a )

	surface.SetMaterial( self.Reticle[index] )
	surface.SetDrawColor( r || 255, g || 255, b || 255, a || 200 )
	local w = ScrW()
	local h = ScrH()
	surface.DrawTexturedRectRotated( w*0.5, h*0.5, h * size, h, 0 )

end

function SWEP:DrawDelay( index, size, r, g, b, a )

	surface.SetMaterial( self.Delay[index] )
	surface.SetDrawColor( r || 255, g || 255, b || 255, a || 200 )
	local w = ScrW()
	local h = ScrH()
	surface.DrawTexturedRectRotated( w*0.5, h*0.5, w*size, w*size, 0 )

end


function SWEP:DrawHUD3DSprite( index, size, pos, r, g, b, a, flipx )

	render.SetMaterial( self.Reticle[index] )
	render.DrawSprite( pos, size, size, 0, Color( r, g, b, a ) )

end