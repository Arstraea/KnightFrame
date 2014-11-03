local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--------------------------------------------------------------------------------
--<< KnightFrame : 1440x900 Install Data - DevilUI							>>--
--------------------------------------------------------------------------------
--[[
KF_Config.Install_Layout_Data['DevilUI']['1440x900'] = {
	
}

KF_Config.Install_Profile_Data['DevilUI']['1440x900'] = function()
	SetCVar('mapQuestDifficulty', 1)
	SetCVar('ShowClassColorInNameplate', 1)
	SetCVar('screenshotQuality', 10)
	SetCVar('chatMouseScroll', 1)
	SetCVar('chatStyle', 'classic')
	SetCVar('WholeChatWindowClickable', 0)
	SetCVar('ConversationMode', 'inline')
	SetCVar('showTutorials', 0)
	SetCVar('UberTooltips', 1)
	SetCVar('threatWarning', 3)
	SetCVar('alwaysShowActionBars', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('SpamFilter', 0)
	SetCVar('Sound_EnableSoundWhenGameIsInBG', 1)
	SetCVar('uiScale', 0.75)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()
end
]]