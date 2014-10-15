local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if KF.Modules.LocalizedTimeFormats then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
	KF_Config.Options.args.Misc.args.LocalizedTimeFormats = {
		type = 'toggle',
		name = function() return ' '..(DB.Enable ~= false and KF:Color_Value() or '')..L['TimeFormat'] end,
		order = KF_Config.MiscCategoryCount,
		desc = '',
		descStyle = 'inline',
		get = function() return DB.Modules.LocalizedTimeFormat end,
		set = function(_, value)
			DB.Modules.LocalizedTimeFormat = value
			
			KF.Modules.LocalizedTimeFormats(not value)
		end,
	}
end