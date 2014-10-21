local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if KF.Modules.MinimapBackdropWhenFarmMode then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	local OptionIndex = KF_Config.MiscCategoryCount
	KF_Config.Options.args.Misc.args.Minimap = {
		type = 'toggle',
		name = function() return ' '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Minimap Backdrop When FarmMode'] end,
		order = OptionIndex,
		desc = '',
		descStyle = 'inline',
		get = function() return DB.Modules.MinimapBackdropWhenFarmMode end,
		set = function(_, value)
			DB.Modules.MinimapBackdropWhenFarmMode = value
			
			KF.Modules.MinimapBackdropWhenFarmMode()
		end,
		width = 'full',
		disabled = function() return DB.Enable == false end
	}
end