EFFECT.Material = Material( "effects/dredux/muzzle/muzzle_a2.png", "smooth" )

function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Weapon = data:GetEntity()
	self.Att = data:GetAttachment()	
	
	self:SetPos( self.Pos )
	
	self.RealPos = self:GetTracerShootPos(self.Pos, self.Weapon, self.Att)
	self.RealLightPos = self:GetTracerShootPos(self.RealPos, self.Weapon, 2)
	self.Time = 0
	self.Size = 12
	
	self.RealPos = self:GetTracerShootPos(self.Pos, self.Weapon, self.Att)
	self.Time = 0
	
	local muzzlelight = DynamicLight( self:EntIndex(), false )
	muzzlelight.Pos = self.Pos
	muzzlelight.Size = 128
	muzzlelight.Decay = 4096
	muzzlelight.R = 50
	muzzlelight.G = 200
	muzzlelight.B = 255
	muzzlelight.Brightness = 6
	muzzlelight.DieTime = CurTime()+0.1
	
	
end

function EFFECT:Think()
	self.Time = self.Time + FrameTime()
	self.Size = self.Size + 1
	return self.Time < 0.05
end

function EFFECT:Render()

	local realpos = self:GetTracerShootPos(self.Pos, self.Weapon, self.Att)

	render.SetMaterial(self.Material)
	render.DrawSprite(realpos, self.Size, self.Size)
	
end