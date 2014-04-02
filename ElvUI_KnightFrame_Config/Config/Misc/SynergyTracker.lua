local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2014. 4. 2
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF or not KF_Config then return end

if KF.Modules.SynergyTracker then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
	KF_Config.Options.args.Misc.args.SynergyTracker = {
		type = 'toggle',
		name = function() return ' '..(KF.db.Enable ~= false and KF.db.Modules.TopPanel.Enable ~= false and KF:Color_Value() or '')..L['Synergy Tracker'] end,
		order = KF_Config.MiscCategoryCount,
		desc = '',
		descStyle = 'inline',
		get = function() return KF.db.Modules.SynergyTracker end,
		set = function(_, value)
			KF.db.Modules.SynergyTracker = value
			
			KF.Modules.SynergyTracker(not value)
		end,
		disabled = function() return KF.db.Enable == false or KF.db.Modules.TopPanel.Enable == false end,
	}
end