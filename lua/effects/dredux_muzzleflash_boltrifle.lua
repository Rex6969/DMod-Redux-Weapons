EFFECT.Material = {}
for i = 1, 4 do
	EFFECT.Material[ i ] = Material( "effects/dredux/muzzle/muzzle_e"..i..".png", "smooth" )
end

EFFECT.GlowMaterial = Material( "effects/dredux/flares/flare1.png", "smooth nocull" )
EFFECT.Size = 20

function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Weapon = data:GetEntity()
	self.Att = data:GetAttachment()	
	
	self:SetPos( self.Pos )
	
	self.RealPos = self:GetTracerShootPos(self.Pos, self.Weapon, self.Att)
	
	self.Time = 0
	self.RandomEffect = math.random( 4 )
	
	local muzzlelight = DynamicLight( self:EntIndex(), false )
	muzzlelight.Pos = self.RealPos
	muzzlelight.Size = 128
	muzzlelight.Decay = 4000
	muzzlelight.R = 255
	muzzlelight.G = 200
	muzzlelight.B = 50
	muzzlelight.Brightness = 4
	muzzlelight.DieTime = CurTime()+0.05
	
	debugoverlay.Cross( self.RealLightPos, 25, 1 )
	
	--[[local owner = self.Weapon:GetOwner()
	
	local muzEnt = ((owner != LocalPlayer()) or owner:ShouldDrawLocalPlayer()) && ent or owner:GetViewModel() -- From vj base, lol
	ParticleEffectAttach( "d_muzzleflash", PATTACH_POINT, muzEnt, 1 )]]

end

function EFFECT:Think()
	self.Time = self.Time + 0.015
	self.Size = self.Size + 5
	return self.Time < 0.025
end

function EFFECT:Render()

	local realpos = self:GetTracerShootPos( self.Pos, self.Weapon, self.Att)
	
	render.SetMaterial( self.Material[ self.RandomEffect ] )
	render.DrawSprite(realpos, self.Size, self.Size)
	
	render.SetMaterial( self.GlowMaterial )
	render.DrawSprite(realpos, self.Size * 2, self.Size * 2, Color( 255, 60, 0, 15 ) )
	
end