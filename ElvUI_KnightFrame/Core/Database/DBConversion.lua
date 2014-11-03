local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

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
			local NeedErase
			for DatatextName in pairs(Data.Modules.FloatingDatatext) do
				if type(Data.Modules.FloatingDatatext[DatatextName]) == 'table' and Data.Modules.FloatingDatatext[DatatextName].Display then
					NeedErase = 0
					
					for Mode, datatextType in pairs(Data.Modules.FloatingDatatext[DatatextName].Display) do
						if datatextType == 'DPS Utility |cff2eb7e4(KF)' then
							NeedErase = NeedErase + 1
							
							Data.Modules.FloatingDatatext[DatatextName].Display[Mode] = ''
						elseif datatextType ~= '0' and datatextType ~= '' then
							NeedErase = NeedErase - 1
						end
					end
					
					if NeedErase > 0 then
						Data.Modules.FloatingDatatext[DatatextName] = nil
					end
				end
			end
		end
	end
end