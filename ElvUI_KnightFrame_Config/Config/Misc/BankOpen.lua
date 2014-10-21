local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if KF.Modules.BankOpen and not IsAddOnLoaded('AdiBags') then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	local OptionIndex = KF_Config.MiscCategoryCount
	KF_Config.Options.args.Misc.args.BankOpen = {
		type = 'toggle',
		name = function() return ' '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Bank Open'] end,
		order = OptionIndex,
		desc = '',
		descStyle = 'inline',
		get = function() return DB.Modules.BankOpen end,
		set = function(_, value)
			DB.Modules.BankOpen = value
			
			KF.Modules.BankOpen(not value)
		end,
		disabled = function() return DB.Enable == false end
	}
end