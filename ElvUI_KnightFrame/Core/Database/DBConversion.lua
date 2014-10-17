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
		
		if Data.Modules.FloatingDatatext then
			for datatextName in pairs(Data.Modules.FloatingDatatext) do
				if Data.Modules.FloatingDatatext[datatextName].Display then
					local needErase = 0
					
					for Mode, datatextType in pairs(Data.Modules.FloatingDatatext[datatextName].Display) do
						if datatextType == 'DPS Utility |cff2eb7e4(KF)' then
							needErase = needErase + 1
							
							Data.Modules.FloatingDatatext[datatextName].Display[Mode] = ''
						elseif datatextType ~= '0' and datatextType ~= '' then
							needErase = needErase - 1
						end
					end
					
					if needErase > 0 then
						Data.Modules.FloatingDatatext[datatextName] = nil
					end
				end
			end
		end
	end
end