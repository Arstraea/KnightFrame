local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2014. 4. 2
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF or not KF_Config then return end

if KF.Modules.ToggleWatchFrame then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
	KF_Config.Options.args.Misc.args.ToggleWatchFrame = {
		type = 'toggle',
		name = function() return ' '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Toggle WatchFrame'] end,
		order = KF_Config.MiscCategoryCount,
		desc = '',
		descStyle = 'inline',
		get = function() return KF.db.Modules.ToggleWatchFrame end,
		set = function(_, value)
			KF.db.Modules.ToggleWatchFrame = value
			
			KF.Modules.ToggleWatchFrame(not value)
		end,
	}
end