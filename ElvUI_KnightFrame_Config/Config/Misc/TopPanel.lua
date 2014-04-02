local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2014. 4. 2
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF or not KF_Config then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Top Panel OptionTable									>>--
--------------------------------------------------------------------------------
if KF.Modules.TopPanel then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
	KF_Config.Options.args.Misc.args.TopPanel = {
		type = 'group',
		name = function() return ' '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Top Panel'] end,
		order = KF_Config.MiscCategoryCount,
		guiInline = true,
		args = {
			Enable = {
				type = 'toggle',
				name = function() return ' '..(KF.db.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Top Panel'] end,
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function() return KF.db.Modules.TopPanel.Enable end,
				set = function(_, value)
					KF.db.Modules.TopPanel.Enable = value
					
					KF.Modules.TopPanel()
					
					if value == false then
						KF:CallbackFire('TopPanel_Delete')
					end
				end,
				width = 'full',
				disabled = function() return KF.db.Enable == false end,
			},
			Space = {
				type = 'description',
				name = ' ',
				order = 2,
			},
			Height = {
				type = 'range',
				name = function() return ' '..(KF.db.Enable ~= false and KF.db.Modules.TopPanel.Enable ~= false and KF:Color_Value() or '')..L['Height'] end,
				order = 3,
				desc = '',
				descStyle = 'inline',
				get = function()
					return KF.db.Modules.TopPanel.Height
				end,
				set = function(_, value)
					KF.db.Modules.TopPanel.Height = value
					
					KF_TopPanel:Point('BOTTOMRIGHT', KF.UIParent, 'TOPRIGHT', -6, -(2 + KF.db.Modules.TopPanel.Height))
				end,
				min = 0,
				max = 100,
				step = 1,
				disabled = function() return KF.db.Enable == false or KF.db.Modules.TopPanel.Enable == false end,
			},
		},
	}
end