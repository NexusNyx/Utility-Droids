AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Medical Droid"

ENT.Spawnable = true
ENT.Category = "Nexus: Utility"

if SERVER then
	function ENT:Initialize()
	    self:SetModel("models/props/starwars/medical/health_droid.mdl")
	    self:PhysicsInit(SOLID_VPHYSICS)
	    self:SetMoveType(MOVETYPE_VPHYSICS)
	    self:SetSolid(SOLID_VPHYSICS)
	    self:SetModelScale(self:GetModelScale())
	    self:SetUseType( SIMPLE_USE )
	    self:SetHealth( 100 )
	    self:SetMaxHealth( 100 )
	    local phys = self:GetPhysicsObject()

	    if phys:IsValid() then
	        phys:Wake()
	        phys:EnableMotion(false)
	    end
	end
	local BactaDelay = 0
	function ENT:Think()
		if self:Health() == 0 then 
		 	local effectdata = EffectData()
		 	self.NextSpark = self.NextSpark or 0
		 	if self.NextSpark < CurTime() then
				self.NextSpark = CurTime() + 0.1
				effectdata:SetOrigin( self:GetPos() + Vector(0, 0, 25))
				util.Effect( "StunstickImpact", effectdata )
			end
			return
		end
	 	if CurTime() < BactaDelay then return end
	 	for k,v in pairs(ents.FindInSphere( self:GetPos(), 100 )) do
	 		if v:IsPlayer() and v:Health() ~= v:GetMaxHealth() then
				v:ScreenFade( SCREENFADE.IN, Color( 0, 128, 255, 64 ), 0.5, 0 )
				self:EmitSound("everfall/equipment/bacta_bomb/bactabomb_corebass_distant_var_04.mp3", 75, 100, 1)
				v:SetHealth(math.Clamp( v:Health() + 10, 0, v:GetMaxHealth() )  )
		 	end
		end
	 	BactaDelay = CurTime() + 1
	end

	-- repairDatabase["medical_droid"] = function(fusionCutter, ent, trace)
	--     local hp = ent:Health()
 
	--     if hp < ent:GetMaxHealth() then
	--         ent:SetHealth(math.Clamp(hp + 10, 0, ent:GetMaxHealth()))
	--         return true
	--     else
	--         return false
	--     end
	-- end




	function ENT:OnTakeDamage(dmg)
	    self:TakePhysicsDamage( dmg )
	    if ( self:Health() <= 0 ) then return end
        local effectdata = EffectData()
        effectdata:SetOrigin( dmg:GetDamagePosition() )
        effectdata:SetEntity( self )
        util.Effect( "ElectricSpark", effectdata )
	    self:SetHealth( math.Clamp( self:Health() - dmg:GetDamage(), 0, self:GetMaxHealth() ) )
		if self:Health() <= 0 then
	        self:Ignite( 20, 250 )
		end
	end

end


if CLIENT then
	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	function ENT:Draw()
		cam.Start3D2D(self:GetPos(), Angle(0, RenderAngles().y - 90, 90), 0.25)
		
			draw.SimpleTextOutlined( "Medical Droid", "ON_Droids24", 0, -270, Color( 0, 191, 255 ), TEXT_ALIGN_CENTER, 0, 2, Color(0,0,0,0) )
			draw.SimpleTextOutlined( "Bacta Supply", "ON_Droids12", 0, -250, Color( 0, 191, 255 ), TEXT_ALIGN_CENTER, 0, 2, Color(0,0,0,0) )

		cam.End3D2D()
		cam.Start3D2D(self:GetPos(), Angle(0, 0, 0), 0.25)
			surface.DrawCircle( 0, 0, math.floor(math.sin( CurTime() * 5 ) * 5) + 450, 0, 191,255,255 )
		cam.End3D2D()
		self:DrawModel()
	end
	function ENT:DrawTranslucent( flags )
    	self:Draw( flags )
	end
end