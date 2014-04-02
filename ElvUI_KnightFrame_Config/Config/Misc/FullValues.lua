local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2014. 4. 2
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF or not KF_Config then return end

KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
KF_Config.Options.args.Misc.args.FullValues = {
	type = 'toggle',
	name = function() return ' '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Full Values'] end,
	order = KF_Config.MiscCategoryCount,
	desc = '',
	descStyle = 'inline',
	get = function() return KF.db.Modules.FullValues end,
	set = function(_, value)
		KF.db.Modules.FullValues = value
		
		E:GetModule('UnitFrames'):Update_AllFrames()
		
		E:StaticPopup_Show('CONFIG_RL')
	end,
}