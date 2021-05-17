if CLIENT then
	surface.CreateFont( "ON_Droids24", {
		font = "neuropol", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 24,
		weight = 500,
		blursize = 0,
		scanlines = 3,
	} )
	surface.CreateFont( "ON_Droids12", {
		font = "neuropol", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 12,
		weight = 500,
		blursize = 0,
		scanlines = 3,
	} )
else
	repairDatabase["droids"] = function(fusionCutter, ent, trace)
	    local hp = ent:Health()
 		
 		if ent:GetClass() == "gonk_droid" or ent:GetClass() == "medical_droid" then
		    if hp < ent:GetMaxHealth() then
		        ent:SetHealth(math.Clamp(hp + 10, 0, ent:GetMaxHealth()))
		        return true
		    end
		else
			return false
		end
	end
end