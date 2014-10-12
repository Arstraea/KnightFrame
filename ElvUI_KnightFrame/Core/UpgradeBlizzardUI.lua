﻿-- Last Code Checking Date		: 2014. 6. 16
-- Last Code Checking Version	: 3.0_02
-- Last Testing ElvUI Version	: 6.9997

local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Fix UnitPopup											>>--
--------------------------------------------------------------------------------
hooksecurefunc('UnitPopup_HideButtons', function(...)
	local Type = UIDROPDOWNMENU_INIT_MENU.which
	local Name = UIDROPDOWNMENU_INIT_MENU.name
	local Realm = UIDROPDOWNMENU_INIT_MENU.server
	
	for index, value in ipairs(UnitPopupMenus[UIDROPDOWNMENU_MENU_VALUE] or UnitPopupMenus[Type]) do
		if (value == 'WHISPER' or value == 'IGNORE' or value == 'INSPECT' or value == 'TARGET' or value == 'SET_FOCUS' or value == 'REPORT_PLAYER') and Name == E.myname and not (Realm and Realm ~= Info.myrealm) then
			UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
		end
	end
end)