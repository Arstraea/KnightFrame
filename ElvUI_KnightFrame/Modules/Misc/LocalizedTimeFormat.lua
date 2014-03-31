local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 6
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent and L['KF_LocalizedTimeFormat'] then
	local DefaultTimeFormat = E:CopyTable({}, E.TimeFormats)
	local isReplaced
	local A = E:GetModule('Auras')
	
	KF.Modules[#KF.Modules + 1] = 'LocalizedTimeFormats'
	KF.Modules['LocalizedTimeFormats'] = function(RemoveOrder)
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