
EFFECT.Material = {}
for i = 1,3 do
	EFFECT.Material[ i ] = Material( "effects/dredux/muzzle/muzzle_b"..i..".png", "smooth" )
end

EFFECT.GlowMaterial = Material( "effects/dredux/flares/flare1.png", "smooth" )
EFFECT.Size = 10
EFFECT.LightSize = 128

function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Weapon = data:GetEntity()
	self.Att = data:GetAttachment()	
	
	self:SetPos( self.Pos )
	
	self.RealPos = self:GetTracerShootPos(self.Pos, self.Weapon, self.Att)
	self.RealLightPos = self:GetTracerShootPos(self.RealPos, self.Weapon, 2)
	self.Time = 0
	
	local muzzlelight = DynamicLight( self:EntIndex(), false )
	muzzlelight.Pos = self.RealLightPos
	muzzlelight.Size = 128
	muzzlelight.Decay = 4096
	muzzlelight.R = 255
	muzzlelight.G = 150
	muzzlelight.B = 50
	muzzlelight.Brightness = 4
	muzzlelight.DieTime = CurTime()+0.1

end

function EFFECT:Think()
	self.Time = self.Time + 0.015
	self.Size = self.Size + 2
	return self.Time < 0.05
end


function EFFECT:Render()

	local realpos = self:GetTracerShootPos( self.Pos, self.Weapon, self.Att)

	render.SetMaterial( self.Material[ math.random( 3 ) ] )
	render.DrawSprite(realpos, self.Size, self.Size)
	
	render.SetMaterial( self.GlowMaterial )
	render.DrawSprite(realpos, self.Size * 2, self.Size * 2, Color( 255, 60, 0, 10 ) )
	
end