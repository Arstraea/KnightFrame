-- Last Code Checking Date		: 2014. 6. 16
-- Last Code Checking Version	: 3.0_02
-- Last Testing ElvUI Version	: 6.9997

local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

function KF:DBConversions(Data)
	if Data.Layout then
		Data.Modules = Data.Modules or {}
		E:CopyTable(Data.Modules, Data.Layout)
		Data.Layout = nil
	end
	
	if Data.Extra_Functions then
		Data.Modules = Data.Modules or {}
		E:CopyTable(Data.Modules, Data.Extra_Functions)
		Data.Extra_Functions = nil
	end
	
	if Data.Modules then
		if Data.Modules.AuraTracker ~= nil then
			Data.Modules.SynergyTracker = Data.Modules.AuraTracker
			Data.Modules.AuraTracker = nil
		end
		
		if Data.Modules.RaidCooldown ~= nil then
			Data.Modules.SmartTracker = Data.Modules.RaidCooldown
			Data.Modules.RaidCooldown = nil
		end
	end
end