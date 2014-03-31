local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 26
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Fix UnitPopup											>>--
	--------------------------------------------------------------------------------
	hooksecurefunc('UnitPopup_HideButtons', function(...)
		local Type = UIDROPDOWNMENU_INIT_MENU.which
		local Name = UIDROPDOWNMENU_INIT_MENU.name
		local Realm = UIDROPDOWNMENU_INIT_MENU.server
		
		for index, value in ipairs(UnitPopupMenus[UIDROPDOWNMENU_MENU_VALUE] or UnitPopupMenus[Type]) do
			if (value == 'WHISPER' or value == 'IGNORE' or value == 'INSPECT' or value == 'TARGET' or value == 'SET_FOCUS' or value == 'REPORT_PLAYER') and Name == E.myname and not (Realm and Realm ~= E.myrealm) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
			end
		end
	end)
end