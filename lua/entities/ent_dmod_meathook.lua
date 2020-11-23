ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.ChainMaterial = Material( "effects/dredux/meathook_chain.png", "noclamp transparent smooth" )

function ENT:Initialize( )

	self:SetModel( "models/hunter/misc/sphere025x025.mdl" )
	self:SetPos( self:GetOwner():GetShootPos() )
	self:SetParent( self:GetOwner():GetActiveWeapon() )
	
	self:EmitSound( "doom_eternal/weapons/supershotgun/ssg_meathook_fire.ogg", nil, nil, nil, CHAN_WEAPON )

end

function ENT:Think()

	self:SetPos( self:GetOwner():GetShootPos() )

end

function ENT:OnRemove()

	self:EmitSound( "doom_eternal/weapons/supershotgun/ssg_meathook_detach.ogg", nil, nil, nil, CHAN_WEAPON )

end

function ENT:Draw()

	local owner = self:GetOwner()

	if IsValid( owner ) and IsValid( owner:GetActiveWeapon() ) then

		local startpos = owner:GetShootPos() + owner:GetRight() * 8 + owner:GetUp() * -10
		local _end = owner:GetActiveWeapon():GetMeathookEnd()
		local endpos = _end:GetPos() + _end:GetForward()*-10
		local dist = ( startpos - endpos ):Length()

		if IsValid( _end ) then

			local endpos = _end:GetPos() + _end:GetForward()*-10
			
			render.SetMaterial( self.ChainMaterial	)
			render.DrawBeam( startpos, endpos, 1.5, 0, dist / 40, Color( 200, 180, 100 ) )
			
		end
		
	else
	
		self:Remove()
		
	end

end

AddCSLuaFile()