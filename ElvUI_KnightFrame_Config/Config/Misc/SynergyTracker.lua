local E, L, V, P, G, _ = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--[[
if KF.Modules.SynergyTracker then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
	KF_Config.Options.args.Misc.args.SynergyTracker = {
		type = 'toggle',
		name = function() return ' '..(DB.Enable ~= false and DB.Modules.TopPanel.Enable ~= false and KF:Color_Value() or '')..L['Synergy Tracker'] end,
		order = KF_Config.MiscCategoryCount,
		desc = '',
		descStyle = 'inline',
		get = function() return DB.Modules.SynergyTracker end,
		set = function(_, value)
			DB.Modules.SynergyTracker = value
			
			KF.Modules.SynergyTracker(not value)
		end,
		disabled = function() return DB.Enable == false or DB.Modules.TopPanel.Enable == false end,
	}
end]]