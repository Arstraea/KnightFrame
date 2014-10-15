local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent then
	local function SpellAlert(...)
		local _, _, eventType, _, userGUID, userName, userFlag, _, destGUID, destName, destFlag, _, spellID = ...
		
		if bit.band(userFlag, (COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE)) == 0 then return end
		
		
	end
	
	
	KF.UpdateFunction['SpellAlert'] = function(RemoveOrder)
		if not RemoveOrder and KF.db.Extra_Functions.SpellAlert.Enable ~= false then
			KF:RegisterEventList('COMBAT_LOG_EVENT_UNFILTERED', SpellAlert, 'SpellAlert')
		else
			KF:UnregisterEventList('COMBAT_LOG_EVENT_UNFILTERED', 'SpellAlert')
		end
	end
end