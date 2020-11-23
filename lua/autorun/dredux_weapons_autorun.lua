----------------------------------------------------------------------------------------------------
-- INIT
----------------------------------------------------------------------------------------------------

if !DModRedux then DModRedux = {} end

DModRedux.D2016Weapons = {}

include( "matproxy/dredux_weapons_matproxy.lua" )

----------------------------------------------------------------------------------------------------
-- INIT END
----------------------------------------------------------------------------------------------------

if SERVER then

	-- Shared
	
	CreateConVar( "dredux_enable_weaponmods", "0", FCVAR_ARCHIVE )

	-- Melee
	
	CreateConVar( "dredux_dmg_melee", "25", FCVAR_ARCHIVE )
	
	-- Fists
	
	CreateConVar( "dredux_dmg_fists", "25", FCVAR_ARCHIVE )

	-- Pistol

	CreateConVar( "dredux_dmg_pistol", "10", FCVAR_ARCHIVE ) -- Pistol damage
	CreateConVar( "dredux_dmg_pistol_charge_mul", "1", FCVAR_ARCHIVE ) -- Pistol damage
	
	-- Shotgun
	
	CreateConVar( "dredux_dmg_shotgun", "60", FCVAR_ARCHIVE ) -- Shotgun normal damage PER SHOT, NOT PER SINGLE PELLET
	CreateConVar( "dredux_dmg_shotgun_burst", "55", FCVAR_ARCHIVE ) -- Shotgun burst damage PER SHOT, NOT PER SINGLE PELLET
	CreateConVar( "dredux_dmg_shotgun_grenade", "80", FCVAR_ARCHIVE ) -- Shotgun grenade damage
	CreateConVar( "dredux_dmg_shotgun_grenade_sticky", "70", FCVAR_ARCHIVE ) -- Shotgun grenade damage
	
	-- Super Shotgun
	
	CreateConVar( "dredux_dmg_supershotgun", "100", FCVAR_ARCHIVE )
	
	-- Heavy AR
	
	CreateConVar( "dredux_dmg_har", "15", FCVAR_ARCHIVE )
	CreateConVar( "dredux_dmg_har_rocket", "45", FCVAR_ARCHIVE )
	
	PrecacheParticleSystem( "d_tinyrocket_trail" )
	PrecacheParticleSystem( "d_tracer_har" )
	
	-- Chaingun
	
	CreateConVar( "dredux_dmg_chaingun", "15", FCVAR_ARCHIVE )
	CreateConVar( "dredux_dmg_chaingun_turret", "12", FCVAR_ARCHIVE )
	
	-- Gauss
	
	CreateConVar( "dredux_dmg_gauss", "150", FCVAR_ARCHIVE )
	CreateConVar( "dredux_dmg_gauss_siege", "400", FCVAR_ARCHIVE )
	
	CreateConVar( "dredux_dmg_gauss_splash", "50", FCVAR_ARCHIVE )
	
	CreateConVar( "dredux_gaussjump", "1", FCVAR_ARCHIVE )
	
	-- MP Pistol
	
	CreateConVar( "dredux_dmg_mp_pistol", "10", FCVAR_ARCHIVE ) -- Pistol damage
	CreateConVar( "dredux_dmg_mp_pistol_charge_mul", "1", FCVAR_ARCHIVE ) -- Pistol damage
	
	-- MP Bolt Rifle
	
	CreateConVar( "dredux_dmg_mp_burstrifle", "8", FCVAR_ARCHIVE ) -- Pistol damage

	


end

















----------------------------------------------------------------------------------------------------
-- HOOKS
----------------------------------------------------------------------------------------------------

concommand.Add( "doom_melee", function( ply )

	local wep = ply:GetActiveWeapon()

	if ( wep.IsDOOMWeapon && wep:GetNextPrimaryFire() < CurTime() ) then
			wep:MeleeAttack()
	end

end )

hook.Add( "SetupMove", "DOOMWeaponModSlowDown", function( ply, mv )

	local wep = ply:GetActiveWeapon()
	
	if !wep.IsDOOMModdableWeapon then return end
	
	if wep:GetActiveMod() then
	
		local speed = mv:GetMaxClientSpeed()
		mv:SetMaxClientSpeed( speed * 0.5 )
	
	end

end)

----------------------------------------------------------------------------------------------------
-- INIT PARTICLES
----------------------------------------------------------------------------------------------------

game.AddParticles( "particles/doom_vfx_weapons.pcf" )

	-- PARTICLE PRECACHING

	PrecacheParticleSystem( "d_muzzleflash" )
	PrecacheParticleSystem( "d_pistol_muzzleflash" )
	
	-- PARTICLE PRECACHING END
