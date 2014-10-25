﻿local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Toolkit		 											>>--
--------------------------------------------------------------------------------
function KF:Color_Value(InputText)
	return E:RGBToHex(E.media.rgbvaluecolor[1], E.media.rgbvaluecolor[2], E.media.rgbvaluecolor[3])..(InputText and InputText..'|r' or '')
end	


function KF:Color_Class(Class, InputText)
	return (Class and '|c'..RAID_CLASS_COLORS[Class].colorStr or '')..(InputText and InputText..'|r' or '')
end


function KF:TextSetting(self, Text, Style, ...)
	if Style and Style.Tag then
		self[Style.Tag] = self[Style.Tag] or self:CreateFontString(nil, 'OVERLAY')
		self = self[Style.Tag]
	else
		Style = Style or {}
		self.text = self.text or self:CreateFontString(nil, 'OVERLAY')
		self = self.text
	end
	
	self:FontTemplate(Style.Font and E.LSM:Fetch('font', Style.Font), Style.FontSize, Style.FontOutline)
	self:SetJustifyH(Style.directionH or 'CENTER')
	self:SetJustifyV(Style.directionV or 'MIDDLE')
	self:SetText(Text)
	
	if ... then
		self:Point(...)
	else
		self:SetInside()
	end
end


function KF:GetPanelData(key)
	local Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled
	
	if (key == 'LeftChatPanel' and (E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'LEFT') or key == 'RightChatPanel' and (E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'RIGHT')) and _G[key] then
		Panel = _G[key]
		panelType = 'ElvUI'
		IsTabEnabled = E.db.chat.panelTabBackdrop
		
		if key == 'LeftChatPanel' then
			panelTab = LeftChatTab
			panelDP = LeftChatDataPanel
			IsDPEnabled = E.db.datatexts.leftChatPanel
		else
			panelTab = RightChatTab
			panelDP = RightChatDataPanel
			IsDPEnabled = E.db.datatexts.rightChatPanel
		end
	elseif KF.UIParent.Panel and KF.UIParent.Panel[key] and DB.Modules.CustomPanel.Enable ~= false and DB.Modules.CustomPanel[key] and DB.Modules.CustomPanel[key].Enable == true then
		Panel = KF.UIParent.Panel[key]
		panelType = 'KF'
		panelTab = KF.UIParent.Panel[key].Tab
		IsTabEnabled = DB.Modules.CustomPanel[key].Tab.Enable
		panelDP = KF.UIParent.Panel[key].DP
		IsDPEnabled = DB.Modules.CustomPanel[key].DP.Enable
	end
	
	return Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled
end