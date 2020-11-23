EFFECT.Material = {}
for i = 0, 32 do
	EFFECT.Material[ i ] = Material( "effects/dredux/dexplo/exp_a"..i..".png", "smooth nocull" )
end

EFFECT.GlowMaterial = Material( "effects/dredux/flares/flare1.png", "smooth nocull" )
EFFECT.Size = math.random( 45, 60 )

function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self:SetPos( self.Pos )
	
	self.Time = 0
	self.Frame = 0
	
	local light = DynamicLight( self:EntIndex(), false )
	light.Pos = self.Pos
	light.Size = 128
	light.Decay = 4096
	light.R = 255
	light.G = 150
	light.B = 50
	light.Brightness = 6
	light.DieTime = CurTime()+0.1
	
	local emitter = ParticleEmitter(self.Pos)
	
	for i = 1, 2 do
	
		local particle = emitter:Add( "particles/smokey",self.Pos)
		particle:SetVelocity( Vector( math.random( -20, 20 ) , math.random(-20, 20 ) , math.random( -20, 20 ) ) )
		particle:SetDieTime( math.Rand( 1, 2 ) )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 10 )
		particle:SetStartSize( math.random( 30, 40 ) )
		particle:SetEndSize( math.random( 30,40 ) )
		particle:SetRoll( math.random( 0, 360 ) )
		particle:SetRollDelta( math.random( -0.2, 0.2 ) )
		particle:SetColor( 50, 50, 50 )
		particle:SetGravity( Vector(0, 0, 0 ) )
		particle:SetAirResistance( 15 )
		
	end
	
	self.MainParticle = emitter:Add( "effects/dredux/dexplo/exp_a0", self.Pos )
	self.MainParticle:SetVelocity( Vector( math.random( -20, 20 ) , math.random(-20, 20 ) , math.random( -20, 20 ) ) )
	self.MainParticle:SetDieTime( 2 )
	self.MainParticle:SetStartSize( math.random( 25, 30 ) )
	self.MainParticle:SetEndSize( math.random( 50, 60 ) )
	self.MainParticle:SetColor( 255, 255, 240 )
	self.MainParticle:SetRoll( math.random( 0, 360 ) )
	self.MainParticle:SetGravity( Vector(0, 0, 0 ) )
	self.MainParticle:SetAirResistance( 15 )
	
	emitter:Finish()

end

function EFFECT:Think()

	self.Size = self.Size + 1
	
	self.Frame = self.Frame + 1.2
	
	self.MainParticle:SetMaterial( self.Material[ math.Clamp( math.ceil( self.Frame ), 0, 32 ) ] )
	
	return self.Frame < 32
	
end

function EFFECT:Render()

	local realpos = self:GetTracerShootPos( self.Pos, self.Weapon, self.Att)
	
	if self.Frame < 10 then
		render.SetMaterial( self.GlowMaterial )
		render.DrawSprite(realpos, self.Size * 2, self.Size * 2, Color( 255, 60, 0, 15 ) )
	end
	
end