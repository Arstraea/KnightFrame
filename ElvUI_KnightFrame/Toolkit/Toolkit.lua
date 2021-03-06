﻿--Cache global variables
--Lua functions
local _G = _G
local unpack, select, pairs, type, next = unpack, select, pairs, type, next

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

--------------------------------------------------------------------------------
--<< KnightFrame : Toolkit		 											>>--
--------------------------------------------------------------------------------
function KF:Color_Value(InputText)
	return E:RGBToHex(unpack(E.media.rgbvaluecolor))..(InputText and InputText..'|r' or '')
end	


function KF:Color_Class(Class, InputText)
	return (Class and '|c'..RAID_CLASS_COLORS[Class].colorStr or '')..(InputText and InputText..'|r' or '')
end


function KF:TextSetting(self, Text, Style, ...)
	if Style and Style.Tag then
		self[Style.Tag] = self[Style.Tag] or self:CreateFontString(nil, 'OVERLAY', Style.Inherit)
		self = self[Style.Tag]
	else
		Style = Style or {}
		self.text = self.text or self:CreateFontString(nil, 'OVERLAY', Style.Inherit)
		self = self.text
	end
	
	self:FontTemplate(Style.Font and E.LSM:Fetch('font', Style.Font), Style.FontSize, Style.FontStyle)
	self:SetJustifyH(Style.directionH or 'CENTER')
	self:SetJustifyV(Style.directionV or 'MIDDLE')
	self:SetText(Text)
	
	if ... then
		self:Point(...)
	else
		self:SetInside()
	end
end


function KF:CompareTable(MainTable, TableToCompare, DB, Properties)
	--[[
		Properties = {
			ReplaceDifferentValue = boolean,
			DeleteSameValue = boolean,
		}
	]]
	local CreateTable
	
	for Index, Value in pairs(MainTable) do
		if type(Value) == 'table' and TableToCompare[Index] ~= nil and type(TableToCompare[Index]) == 'table' then
			CreateTable = nil
			
			if not DB[Index] then
				DB[Index] = {}
				CreateTable = true
			end
			
			KF:CompareTable(MainTable[Index], TableToCompare[Index], DB[Index], Properties)
			
			if CreateTable and not next(DB[Index]) then
				DB[Index] = nil
			end
		elseif TableToCompare[Index] == nil or Properties and Properties.ReplaceDifferentValue and (Value ~= TableToCompare[Index] or type(Value) ~= type(TableToCompare[Index])) then
			DB[Index] = Value
		elseif Properties and Properties.DeleteSameValue and TableToCompare[Index] == Value then
			DB[Index] = nil
		end
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
	elseif KF.UIParent.Panel and KF.UIParent.Panel[key] and KF.db.Modules.CustomPanel.Enable ~= false and KF.db.Modules.CustomPanel[key] and KF.db.Modules.CustomPanel[key].Enable == true then
		Panel = KF.UIParent.Panel[key]
		panelType = 'KF'
		panelTab = KF.UIParent.Panel[key].Tab
		IsTabEnabled = KF.db.Modules.CustomPanel[key].Tab.Enable
		panelDP = KF.UIParent.Panel[key].DP
		IsDPEnabled = KF.db.Modules.CustomPanel[key].DP.Enable
	end
	
	return Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled
end