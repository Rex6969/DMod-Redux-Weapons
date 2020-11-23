EFFECT.Material = {}
for i = 1, 3 do
	EFFECT.Material[ i ] = Material( "effects/dredux/muzzle/muzzle_d"..i..".png", "smooth" )
end

EFFECT.GlowMaterial = Material( "effects/dredux/flares/flare1.png", "smooth nocull" )
EFFECT.Size = 40

function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Weapon = data:GetEntity()
	self.Att = data:GetAttachment()	
	
	self:SetPos( self.Pos )
	
	self.RealPos = self:GetTracerShootPos( self.Pos, self.Weapon, self.Att )
	
	self.Time = 0
	self.Size = self.Size + math.random( -5, 5 )
	
	local muzzlelight = DynamicLight( self:EntIndex(), false )
	muzzlelight.Pos = self.RealPos
	muzzlelight.Size = 128
	muzzlelight.Decay = 2000
	muzzlelight.R = 255
	muzzlelight.G = 160
	muzzlelight.B = 50
	muzzlelight.Brightness = 6
	muzzlelight.DieTime = CurTime()+0.05
	
	--[[local owner = self.Weapon:GetOwner()
	
	local muzEnt = ((owner != LocalPlayer()) or owner:ShouldDrawLocalPlayer()) && ent or owner:GetViewModel() -- From vj base, lol
	ParticleEffectAttach( "d_muzzleflash", PATTACH_POINT, muzEnt, 1 )]]

end

function EFFECT:Think()
	self.Time = self.Time + 0.015
	self.Size = self.Size + 10
	return self.Time < 0.035
end

function EFFECT:Render()

	local realpos = self:GetTracerShootPos( self.Pos, self.Weapon, self.Att)
	
	render.SetMaterial( self.Material[ math.random( 3 ) ] )
	render.DrawSprite(realpos, self.Size, self.Size, Color( 255, 240, 230, 255 ) )
	
	render.SetMaterial( self.GlowMaterial )
	render.DrawSprite(realpos, self.Size * 2, self.Size * 2, Color( 255, 60, 0, 10 ) )
	
end

