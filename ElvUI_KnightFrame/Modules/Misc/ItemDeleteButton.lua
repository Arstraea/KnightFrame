﻿--Cache global variables
--Lua functions
local _G = _G
local unpack, select = unpack, select

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local CreateFrame = CreateFrame
local DELETE_ITEM_CONFIRM_STRING = DELETE_ITEM_CONFIRM_STRING
local DeleteCursorItem = DeleteCursorItem
local IsShiftKeyDown = IsShiftKeyDown

--------------------------------------------------------------------------------
--<< KnightFrame : Create Delete Item Button in confirm popup				>>--
--------------------------------------------------------------------------------
KF.InitializeFunction.DeleteButton = function()
	CreateFrame('Button', 'DeleteConfirm_AutoTypingButton')
	DeleteConfirm_AutoTypingButton:Size(62, 24)
	DeleteConfirm_AutoTypingButton:EnableMouse(true)
	DeleteConfirm_AutoTypingButton:SetTemplate('Default', true)
	KF:TextSetting(DeleteConfirm_AutoTypingButton, DELETE_ITEM_CONFIRM_STRING, { FontSize = 10, FontStyle = 'OUTLINE' })
	DeleteConfirm_AutoTypingButton:SetScript('OnHide', function(self)
		self:SetParent(nil)
		self:ClearAllPoints()
		self.text:SetTextColor(1, 1, 1)
		self.text:Point('CENTER', self)
		
		self:Hide()
	end)
	DeleteConfirm_AutoTypingButton:SetScript('OnEnter', function(self) self.text:SetTextColor(unpack(E.media.rgbvaluecolor)) end)
	DeleteConfirm_AutoTypingButton:SetScript('OnLeave', function(self) self.text:SetTextColor(1, 1, 1) end)
	DeleteConfirm_AutoTypingButton:SetScript('OnMouseDown', function(self) self.text:Point('CENTER', self, 0, -2) end)
	DeleteConfirm_AutoTypingButton:SetScript('OnMouseUp', function(self) self.text:Point('CENTER', self) end)
	DeleteConfirm_AutoTypingButton:SetScript('OnClick', function(self)
		local editBox = select(2, self:GetPoint())
		
		if editBox:GetText() ~= DELETE_ITEM_CONFIRM_STRING then
			editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
		else
			DeleteCursorItem()
		end
	end)
	DeleteConfirm_AutoTypingButton:SetScript('OnEvent', function(self)
		local frame
		
		for i = 1, STATICPOPUP_NUMDIALOGS do
			frame = _G['StaticPopup'..i]
			
			if frame.which == 'DELETE_GOOD_ITEM' then
				self:SetParent(frame)
				self:Point('LEFT', _G['StaticPopup'..i..'EditBox'], 'RIGHT', 6, 0)
				
				self:Show()
				
				if IsShiftKeyDown() then
					frame = select(2, self:GetPoint())
					
					frame:SetText(DELETE_ITEM_CONFIRM_STRING)
					frame:SetFocus()
				end
				return
			end
		end
	end)
	DeleteConfirm_AutoTypingButton:RegisterEvent('DELETE_ITEM_CONFIRM')
end