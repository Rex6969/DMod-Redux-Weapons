EFFECT.SparkMaterial = {}
EFFECT.BeamMaterial = Material( "effects/dredux/beam/beam_02.png", "smooth" )
for i = 1, 3 do
	EFFECT.SparkMaterial[ i ] = Material( "effects/dredux/sparks/sparks_b"..i..".png", "smooth" )
end

function EFFECT:Init( data )

	self.Pos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Weapon = data:GetEntity()
	self.Att = data:GetAttachment()	
	
	self:SetPos( self.Pos )
	

	self.RealPos = self:GetTracerShootPos(self.Pos, self.Weapon, self.Att )
	
	self.Time = 0
	self.TextureEnd = ( self.Pos - self.EndPos ):Length() * 0.001
	
	self.TrailSize = 40
	self.Alpha = 255
	
	self.SphereSize = 10
	self.SphereAlpha = 255
	
	local data = EffectData()
	data:SetOrigin( self.EndPos )
	util.Effect( "cball_bounce", data )
	
	local light = DynamicLight( self:EntIndex(), false )
	light.Pos = self.EndPos
	light.Size = 512
	light.Decay = 4096
	light.R = 50
	light.G = 200
	light.B = 255
	light.Brightness = 6
	light.DieTime = CurTime()+0.05
	
	local emitter = ParticleEmitter( self.EndPos )
	
	for i = 1,3 do
	
		local particle = emitter:Add( "particle/smokesprites_000"..math.random( 9 ), self.EndPos )
		particle:SetVelocity( Vector( math.random( -60, 60 ) , math.random(-60, 60 ) , math.random( -60, 60 ) ) )
		particle:SetDieTime( math.Rand( 1, 2 ) )
		particle:SetStartAlpha( 30 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 80, 90 ) )
		particle:SetEndSize( math.random( 125, 140 ) )
		particle:SetRoll( math.random( 0, 360 ) )
		particle:SetRollDelta( math.random( -0.4, 0.4 ) )
		particle:SetColor( 50, 150, 255 )
		particle:SetGravity( Vector(0, 0, 0 ) )
		particle:SetAirResistance( 15 )
		
	end
	
	emitter:Finish()

end

function EFFECT:Think()

	self.Time = self.Time + 1
	
	self.TrailSize = self.TrailSize + 5
	self.SphereSize = self.SphereSize + 20
	
	self.SphereAlpha = math.Clamp( self.SphereAlpha - 40, 0, 255 )
	self.Alpha = math.Clamp( self.Alpha - 10, 0, 255 )
	
	return self.Time < 25

end

function EFFECT:Render()

	render.SetMaterial( self.BeamMaterial )
	render.DrawBeam( self.RealPos, self.EndPos, self.TrailSize, 0, self.TextureEnd, Color( 100, 200, 255, self.Alpha ) )
	
	render.SetColorMaterial()
	render.DrawSphere( self.EndPos, self.SphereSize, 20, 20, Color( 100, 200, 255, self.SphereAlpha ) )

	return true

end