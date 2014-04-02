local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2014. 4. 2
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF or not KF_Config then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Misc OptionTable											>>--
--------------------------------------------------------------------------------
KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.Misc = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Misc']) end,
	order = 900,
	disabled = function() return KF.db.Enable == false end,
	args = {
		CreditSpace = {
			type = 'description',
			name = ' ',
			order = 998,
		},
		Credit = {
			type = 'header',
			name = KF_Config.Credit,
			order = 999,
		},
	}
}


KF_Config.MiscCategoryCount = 0