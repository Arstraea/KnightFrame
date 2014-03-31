local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2013. 9. 14
-- Last Code Checking Version	: 2.2_01
-- Last Testing ElvUI Version	: 6.48

if not KF or not KF_Config then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Misc OptionTable											>>--
--------------------------------------------------------------------------------
KF_Config.Options.args.Layout.args.Misc.args.Minimap = {
	type = 'toggle',
	name = function() return ' '..(KF.db.Enable ~= false and KF.db.Layout.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF.db.Layout.Enable ~= false and KF:Color_Value() or '')..L['Minimap Backdrop When FarmMode'] end,
	order = 1,
	desc = '',
	descStyle = 'inline',
	get = function() return KF.db.Layout.MinimapBackdropWhenFarmMode end,
	set = function(_, value)
		KF.db.Layout.MinimapBackdropWhenFarmMode = value
		
		KF.InitializeFunction['Layout']['MinimapBackdropWhenFarmMode']()
	end,
	width = 'full',
	disabled = function() return KF.db.Enable == false or KF.db.Layout.Enable == false end,
}