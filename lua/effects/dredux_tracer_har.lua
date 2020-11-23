EFFECT.SparkMaterial = {}
EFFECT.SmokeTrail = Material( "effects/dredux/beam/wispy_smoke_ribbon"..math.random(2)..".png", "smooth" )
for i = 1, 3 do
	EFFECT.SparkMaterial[ i ] = Material( "effects/dredux/sparks/sparks_b"..i..".png", "smooth" )
end

function EFFECT:Init( data )

	self.Pos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Weapon = data:GetEntity()
	self.Att = data:GetAttachment()	
	
	self:SetPos( self.Pos )
	
	if self.Weapon:GetClass() == "weapon_dredux_chaingun" && self.Weapon:GetActiveMod() then 
		self.RealPos = self:GetTracerShootPos(self.Pos, self.Weapon, 1 + self.Weapon.CurrentBarrel )
	else
		self.RealPos = self:GetTracerShootPos(self.Pos, self.Weapon, self.Att )
	end
	
	if self.Weapon:GetClass() == "weapon_dredux_heavy_ar" then
		self.HasSmokeTrail = true
	end
	
	self.Time = 0
	self.TextureEnd = ( self.Pos - self.EndPos ):Length() * 0.001 + math.Rand( 0, 1 )
	self.SmokeSize = 4
	self.SmokeAlpha = 0
	
	util.ParticleTracerEx( "d_tracer_har", self.RealPos, self.EndPos, false, 0, -1 )
	
	local data = EffectData()
	data:SetOrigin( self.EndPos )
	util.Effect( "MetalSpark", data )
	util.Effect( "MetalSpark", data )
	
	local emitter = ParticleEmitter( self.EndPos )
	
	local particle = emitter:Add( "particles/smokey", self.EndPos )
	particle:SetVelocity( Vector( math.random( -20, 20 ) , math.random(-20, 20 ) , math.random( -20, 20 ) ) )
	particle:SetDieTime( math.Rand( 1, 2 ) )
	particle:SetStartAlpha( 200 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 10, 20 ) )
	particle:SetEndSize( math.random( 25, 30 ) )
	particle:SetRoll( math.random( 0, 360 ) )
	particle:SetRollDelta( math.random( -0.2, 0.2 ) )
	particle:SetColor( 60, 60, 60 )
	particle:SetGravity( Vector(0, 0, 0 ) )
	particle:SetAirResistance( 15 )
	
	emitter:Finish()

end

function EFFECT:Think()

	self.Time = self.Time + 1
	self.SmokeSize = self.SmokeSize + 0.35
	self.SmokeAlpha =  self.Time < 5 && math.Clamp( self.SmokeAlpha + 20, 0, 60 ) || math.Clamp( self.SmokeAlpha - 2.5, 0, 255 )
	return self.Time < 40

end

function EFFECT:Render()

	if self.HasSmokeTrail then

		render.SetMaterial( self.SmokeTrail )
		render.DrawBeam( self.RealPos, self.EndPos, self.SmokeSize, 0, self.TextureEnd, Color( 150, 150, 150, self.SmokeAlpha  ) )

	end

	return true

end