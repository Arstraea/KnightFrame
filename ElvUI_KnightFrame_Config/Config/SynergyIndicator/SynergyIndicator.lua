local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.SynergyIndicator = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Synergy Indicator']) end,
	order = 100 + OptionIndex,
	disabled = function() return DB.Enable == false end,
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(DB.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Synergy Indicator'] end,
			order = 1,
			desc = '',
			descStyle = 'inline',
			get = function() return DB.Modules.SynergyIndicator.Enable end,
			set = function(_, value)
				DB.Modules.SynergyIndicator.Enable = value
				
				KF.Modules.SynergyIndicator()
			end,
			width = 'full',
		},
		Space = {
			type = 'description',
			name = ' ',
			order = 2,
		},
		Height = {
			type = 'range',
			name = function() return ' '..(DB.Enable ~= false and DB.Modules.SynergyIndicator.Enable ~= false and KF:Color_Value() or '')..L['Height'] end,
			order = 3,
			desc = '',
			descStyle = 'inline',
			get = function()
				return DB.Modules.SynergyIndicator.TopPanel_Height
			end,
			set = function(_, value)
				DB.Modules.SynergyIndicator.TopPanel_Height = value
				
				KF_SynergyIndicator:Point('BOTTOMRIGHT', KF.UIParent, 'TOPRIGHT', -6, -(2 + DB.Modules.SynergyIndicator.TopPanel_Height))
			end,
			min = 0,
			max = 100,
			step = 1,
			disabled = function() return DB.Enable == false or DB.Modules.SynergyIndicator.Enable == false end,
		},
	}
}