EFFECT.Material = Material( "effects/dredux/muzzle/muzzle_a2.png", "smooth" )
EFFECT.Material2 = Material( "effects/dredux/ground_ripple2.png", "smooth" )

function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Weapon = data:GetEntity()
	self.Att = data:GetAttachment()	
	
	self:SetPos( self.Pos )
	
	self.RealPos = self:GetTracerShootPos( self.Pos, self.Weapon, 1 )
	
	self.Time = 0
	self.Size = 50
	
	self.Time = 0
	
	debugoverlay.Cross( self.Pos, 25, 10 )
	
	local muzzlelight = DynamicLight( self:EntIndex(), false )
	muzzlelight.Pos = self.RealPos
	muzzlelight.Size = 256
	muzzlelight.Decay = 4096
	muzzlelight.R = 50
	muzzlelight.G = 200
	muzzlelight.B = 255
	muzzlelight.Brightness = 6
	muzzlelight.DieTime = CurTime() + 0.05
	
end

function EFFECT:Think()

	self.Time = self.Time + 1
	self.Size = self.Size + 30
	return self.Time < 3
	
end

function EFFECT:Render()

	local realpos = self:GetTracerShootPos( self.Pos, self.Weapon, 1 )

	render.SetMaterial( self.Material )
	render.DrawSprite( realpos, self.Size, self.Size)
	
	render.SetMaterial( self.Material2 )
	render.DrawSprite( realpos, self.Size*2, self.Size*2,  Color( 100, 200, 255, 100 ))
	
end