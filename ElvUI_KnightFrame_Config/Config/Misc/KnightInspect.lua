local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if KF.Modules.KnightInspect then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
	KF_Config.Options.args.Misc.args.KnightInspect = {
		type = 'toggle',
		name = function() return ' '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Knight Inspect'] end,
		order = KF_Config.MiscCategoryCount,
		desc = '',
		descStyle = 'inline',
		get = function() return DB.Modules.KnightInspect.Enable end,
		set = function(_, value)
			DB.Modules.KnightInspect.Enable = value
			
			KF.Modules.KnightInspect(not value)
		end,
	}
end