local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (KF and KF.Modules and (KF.Modules.CharacterArmory or KF.Modules.InspectArmory) and KF_Config) then return end

KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.Armory = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Armory']) end,
	order = 100 + OptionIndex,
	args = {
		
	}
}