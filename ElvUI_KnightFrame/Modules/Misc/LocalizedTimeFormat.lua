local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

if type(L['KF_LocalizedTimeFormat']) == 'table' then
	local DefaultTimeFormat = E:CopyTable({}, E.TimeFormats)
	local isReplaced
	local A = E:GetModule('Auras')
	
	KF.Modules[#KF.Modules + 1] = 'LocalizedTimeFormats'
	KF.Modules.LocalizedTimeFormats = function(RemoveOrder)
		if not RemoveOrder and not isReplaced and KF.db.Modules.LocalizedeTimeFormat ~= false then
			E.TimeFormats = E:CopyTable({}, L['KF_LocalizedTimeFormat'])
			
			isReplaced = true
			
			A:UpdateHeader(ElvUIPlayerBuffs)
			A:UpdateHeader(ElvUIPlayerDebuffs)
		elseif isReplaced then
			E.TimeFormats = E:CopyTable({}, DefaultTimeFormat)
			
			isReplaced = nil
			
			if RemoveOrder ~= 'SwitchProfile' then
				A:UpdateHeader(ElvUIPlayerBuffs)
				A:UpdateHeader(ElvUIPlayerDebuffs)
			end
		end
	end
end