local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2013. 9. 14
-- Last Code Checking Version	: 2.2_01
-- Last Testing ElvUI Version	: 6.48

if not KF or not KF_Config then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Top Panel OptionTable									>>--
--------------------------------------------------------------------------------
KF_Config.Options.args.Layout.args.TopPanel = {
	type = 'group',
	name = function() return '|cffffffff 3. '..KF:Color_Value(L['Top Panel']) end,
	order = 300,
	disabled = function() return KF.db.Enable == false or KF.db.Layout.Enable == false or KF.db.Layout.TopPanel.Enable == false end,
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(KF.db.Enable ~= false and KF.db.Layout.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF.db.Layout.Enable ~= false and KF:Color_Value() or '')..L['Top Panel'] end,
			order = 1,
			desc = '',
			descStyle = 'inline',
			get = function() return KF.db.Layout.TopPanel.Enable end,
			set = function(_, value)
				KF.db.Layout.TopPanel.Enable = value
				
				KF.InitializeFunction['Layout']['TopPanel']()
				
				if value == false then
					KF:CallbackFire('TopPanel_Delete')
				end
			end,
			width = 'full',
			disabled = function() return KF.db.Enable == false or KF.db.Layout.Enable == false end,
		},
		Space = {
			type = 'description',
			name = ' ',
			order = 2,
		},
		Height = {
			type = 'range',
			name = function() return ' '..(KF.db.Enable ~= false and KF.db.Layout.Enable ~= false and KF.db.Layout.TopPanel.Enable ~= false and KF:Color_Value() or '')..L['Height'] end,
			order = 3,
			desc = '',
			descStyle = 'inline',
			get = function()
				return KF.db.Layout.TopPanel.Height
			end,
			set = function(_, value)
				KF.db.Layout.TopPanel.Height = value
				
				KF_TopPanel:Point('BOTTOMRIGHT', KF.UIParent, 'TOPRIGHT', -6, -(2 + KF.db.Layout.TopPanel.Height))
			end,
			min = 0,
			max = 100,
			step = 1,
		},
		CreditSpace = {
			type = 'description',
			name = ' ',
			order = 998,
		},
		Credit = {
			type = 'header',
			name = KF_Config.Credit,
			order = 999,
		},
	},
}