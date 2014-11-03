local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
local OptionIndex = KF_Config.MiscCategoryCount
KF_Config.Options.args.Misc.args.FullValues = {
	type = 'toggle',
	name = function() return ' '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Full Values'] end,
	order = OptionIndex,
	desc = '',
	descStyle = 'inline',
	get = function() return KF.db.Modules.FullValues end,
	set = function(_, value)
		KF.db.Modules.FullValues = value
		
		E:GetModule('UnitFrames'):Update_AllFrames()
		
		E:StaticPopup_Show('CONFIG_RL')
	end
}