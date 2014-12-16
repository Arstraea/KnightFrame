local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Fix UnitPopup											>>--
--------------------------------------------------------------------------------
hooksecurefunc('UnitPopup_HideButtons', function(...)
	local Type = UIDROPDOWNMENU_INIT_MENU.which
	local Name = UIDROPDOWNMENU_INIT_MENU.name
	local Realm = UIDROPDOWNMENU_INIT_MENU.server
	
	for index, value in ipairs(UnitPopupMenus[UIDROPDOWNMENU_MENU_VALUE] or UnitPopupMenus[Type]) do
		if (value == 'WHISPER' or value == 'IGNORE' or value == 'INSPECT' or value == 'TARGET' or value == 'SET_FOCUS' or value == 'REPORT_PLAYER') and Name == E.myname and not (Realm and Realm ~= Info.MyRealm) then
			UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0
		end
	end
end)


InterfaceOptionsFrame:SetMovable(true)
InterfaceOptionsFrame:HookScript('OnMouseDown', function(self)
	self:StartMoving()
	self:SetUserPlaced(false)
end)
InterfaceOptionsFrame:HookScript('OnMouseUp', function(self)
	self:StopMovingOrSizing()
end)


KF:RegisterEventList('ADDON_LOADED', function(Event, AddOnName)
	if AddOnName == 'Blizzard_GarrisonUI' then
		GarrisonMissionFrame:SetMovable(true)
		GarrisonMissionFrame:HookScript('OnMouseDown', function(self)
			self:StartMoving()
			self:SetUserPlaced(false)
		end)
		GarrisonMissionFrame:HookScript('OnMouseUp', function(self)
			self:StopMovingOrSizing()
		end)
		
		KF:UnregisterEventList('ADDON_LOADED', 'GarrisonUpgrade')
	end
end, 'GarrisonUpgrade')