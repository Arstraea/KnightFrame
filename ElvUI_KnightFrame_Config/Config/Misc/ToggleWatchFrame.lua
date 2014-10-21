local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if KF.Modules.ToggleWatchFrame then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	local OptionIndex = KF_Config.MiscCategoryCount
	KF_Config.Options.args.Misc.args.ToggleWatchFrame = {
		type = 'toggle',
		name = function() return ' '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Toggle WatchFrame'] end,
		order = OptionIndex,
		desc = '',
		descStyle = 'inline',
		get = function() return DB.Modules.ToggleWatchFrame end,
		set = function(_, value)
			DB.Modules.ToggleWatchFrame = value
			
			KF.Modules.ToggleWatchFrame(not value)
		end
	}
end