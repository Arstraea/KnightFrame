local E, L, V, P, G, _ = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--[[
if KF.Modules.TopPanel then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Top Panel OptionTable									>>--
	--------------------------------------------------------------------------------
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
	KF_Config.Options.args.Misc.args.TopPanel = {
		type = 'group',
		name = function() return ' '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Top Panel'] end,
		order = KF_Config.MiscCategoryCount,
		guiInline = true,
		args = {
			Enable = {
				type = 'toggle',
				name = function() return ' '..(DB.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Top Panel'] end,
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function() return DB.Modules.TopPanel.Enable end,
				set = function(_, value)
					DB.Modules.TopPanel.Enable = value
					
					KF.Modules.TopPanel()
					
					if value == false then
						KF:CallbackFire('TopPanel_Delete')
					end
				end,
				width = 'full',
				disabled = function() return DB.Enable == false end,
			},
			Space = {
				type = 'description',
				name = ' ',
				order = 2,
			},
			Height = {
				type = 'range',
				name = function() return ' '..(DB.Enable ~= false and DB.Modules.TopPanel.Enable ~= false and KF:Color_Value() or '')..L['Height'] end,
				order = 3,
				desc = '',
				descStyle = 'inline',
				get = function()
					return DB.Modules.TopPanel.Height
				end,
				set = function(_, value)
					DB.Modules.TopPanel.Height = value
					
					KF_TopPanel:Point('BOTTOMRIGHT', KF.UIParent, 'TOPRIGHT', -6, -(2 + DB.Modules.TopPanel.Height))
				end,
				min = 0,
				max = 100,
				step = 1,
				disabled = function() return DB.Enable == false or DB.Modules.TopPanel.Enable == false end,
			},
		},
	}
end
]]