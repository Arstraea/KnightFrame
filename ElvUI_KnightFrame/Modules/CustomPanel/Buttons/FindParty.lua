--Cache global variables
--Lua functions
local _G = _G
local unpack, select = unpack, select

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
local GetAddOnInfo = GetAddOnInfo
local ToggleFrame = ToggleFrame
local EnableAddOn = EnableAddOn
local InCombatLockdown = InCombatLockdown
local ReloadUI = ReloadUI

--------------------------------------------------------------------------------
--<< KnightFrame : Panel - FindParty Button									>>--
--------------------------------------------------------------------------------
local Check_FindParty = IsAddOnLoaded('Findparty')
local _, _, _, _, IsMissing = GetAddOnInfo('Findparty')

KF.UIParent.Button.Findparty = {
	Text = (Check_FindParty and '' or '|cff828282')..'P',
	
	OnClick = function(Button, pressedButton)
		if Check_FindParty then
			GameTooltip:Hide()
			
			ToggleFrame(FP_Frame)
			
			Button.text:SetText(KF.UIParent.Button.Findparty.Text)
		elseif IsMissing ~= 'MISSING' then
			GameTooltip:Hide()
			
			EnableAddOn('Findparty')
			
			if InCombatLockdown() then
				E:StaticPopup_Show('CONFIG_RL')
			else
				ReloadUI()
			end
		end
	end
}