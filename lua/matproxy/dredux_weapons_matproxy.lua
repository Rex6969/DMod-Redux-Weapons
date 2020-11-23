AddCSLuaFile()

matproxy.Add({
	name = "dredux_TurretHeat",
	init = function( self, mat, values )
		self.ResultTo = values.resultvar
	end,
	bind = function( self, mat, ent )
		if ( !IsValid( ent )) then return end
		local heat = ent:GetOwner():GetActiveWeapon():GetBarrelHeat()
		mat:SetFloat( self.ResultTo, heat * 2 - 0.5 )
	end
})