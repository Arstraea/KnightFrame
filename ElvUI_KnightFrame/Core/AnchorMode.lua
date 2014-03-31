local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 4
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade AnchorMode's Popup and Add KnightFrame Mode		>>--
--------------------------------------------------------------------------------
-- Original Code (Version)		: ElvUI(6.94)
-- Original Code Location		: ElvUI\Core\Config.lua

local selectedValue = 'ALL'

local function ConfigMode_OnClick(self)
	selectedValue = self.value
	E:ToggleConfigMode(false, self.value)
	UIDropDownMenu_SetSelectedValue(ElvUIMoverPopupWindowDropDown, self.value)
end

hooksecurefunc(E, 'CreateMoverPopup', function()
	UIDropDownMenu_Initialize(ElvUIMoverPopupWindowDropDown, function()
		local info = UIDropDownMenu_CreateInfo()
		info.func = ConfigMode_OnClick
		
		for _, configMode in ipairs(E.ConfigModeLayouts) do
			info.text = E.ConfigModeLocalizedStrings[configMode]
			info.value = configMode
			UIDropDownMenu_AddButton(info)
		end
		
		-- Blank
		info.text = ' '
		info.value = nil
		info.disabled = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info)
		
		-- Add KnightFrame Mode
		info.text = KF:Color_Value('       [Knight Frame]')
		info.disabled = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info)
		
		info.text = KF:Color_Value('1. ')..ALL
		info.value = 'KF'
		info.disabled = nil
		info.notCheckable = nil
		UIDropDownMenu_AddButton(info)
		
		info.text = KF:Color_Value('2. ')..L['DataTexts']
		info.value = 'KF_Datatext'
		UIDropDownMenu_AddButton(info)
		
		UIDropDownMenu_SetSelectedValue(ElvUIMoverPopupWindowDropDown, selectedValue)
	end)
end)