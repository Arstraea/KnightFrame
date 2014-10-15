local E, L, V, P, G, _ = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--------------------------------------------------------------------------------
--<< KnightFrame : Misc OptionTable											>>--
--------------------------------------------------------------------------------
KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.Misc = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Misc']) end,
	order = 900,
	disabled = function() return DB.Enable == false end,
	args = {
		CreditSpace = {
			type = 'description',
			name = ' ',
			order = 998
		},
		Credit = {
			type = 'header',
			name = KF_Config.Credit,
			order = 999
		},
	}
}

KF_Config.MiscCategoryCount = 0