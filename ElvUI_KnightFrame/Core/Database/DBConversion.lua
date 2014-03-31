local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 24
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return end

function KF:DBConversions(DB)
	if DB.Layout then
		DB.Modules = DB.Modules or {}
		E:CopyTable(DB.Modules, DB.Layout)
		DB.Layout = nil
	end
	
	if DB.Extra_Functions then
		DB.Modules = DB.Modules or {}
		E:CopyTable(DB.Modules, DB.Extra_Functions)
		DB.Extra_Functions = nil
	end
	
	if DB.Modules then
		if DB.Modules.AuraTracker ~= nil then
			DB.Modules.SynergyTracker = DB.Modules.AuraTracker
			DB.Modules.AuraTracker = nil
		end
	end
end