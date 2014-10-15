local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if KF.Modules.ExpRepDisplay then
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	
	local Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled
	
	
	local function NameColor(Color)
		return DB.Enable ~= false and DB.Modules.ExpRepDisplay.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
	end
	
	
	KF_Config.Options.args.Misc.args.ExpRepDisplay = {
		type = 'group',
		name = function() return ' '..(DB.Enable ~= false and KF:Color_Value() or '')..L['ExpRep Display'] end,
		order = KF_Config.MiscCategoryCount,
		guiInline = true,
		disabled = function() return DB.Enable == false or DB.Modules.ExpRepDisplay.Enable == false end,
		args = {
			Enable = {
				type = 'toggle',
				name = function() return ' '..(DB.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(DB.Enable ~= false and KF:Color_Value() or '')..L['ExpRep Display'] end,
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function() return DB.Modules.ExpRepDisplay.Enable end,
				set = function(_, value)
					DB.Modules.ExpRepDisplay.Enable = value
					
					KF.Modules.ExpRepDisplay(not value)
				end,
				width = 'full',
				disabled = function() return DB.Enable == false end
			},
			Space = {
				type = 'description',
				name = ' ',
				order = 2
			},
			EmbedPanel = {
				type = 'select',
				name = function() return ' '..NameColor()..L['Frame To Embed'] end,
				order = 3,
				desc = '',
				descStyle = 'inline',
				get = function() return DB.Modules.ExpRepDisplay.EmbedPanel or '' end,
				set = function(_, value)
					if value == '' then
						DB.Modules.ExpRepDisplay.EmbedPanel = nil
					else
						DB.Modules.ExpRepDisplay.EmbedPanel = value
					end
					
					KF.Modules.ExpRepDisplay()
				end,
				values = function()
					local List = { [''] = NameColor('ceff00')..L['Please Select'] }
					
					for panelName, IsPanelData in pairs(DB.Modules.CustomPanel) do
						if type(IsPanelData) == 'table' and IsPanelData.Enable ~= false and (IsPanelData.Tab.Enable or IsPanelData.DP.Enable) then
							List[panelName] = panelName
						end
					end
					
					return List
				end
			},
			EmbedLocation = {
				type = 'select',
				name = function()
					Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled = KF:GetPanelData(DB.Modules.ExpRepDisplay.EmbedPanel)
					
					return ' '..((IsTabEnabled or IsDPEnabled) and NameColor() or '')..L['Embed Location']
				end,
				order = 4,
				desc = '',
				descStyle = 'inline',
				get = function()
					if IsTabEnabled or IsDPEnabled then
						return DB.Modules.ExpRepDisplay.EmbedLocation == 'Tab' and '1' or DB.Modules.ExpRepDisplay.EmbedLocation == 'DP' and '2' or DB.Modules.ExpRepDisplay.EmbedLocation or ''
					else
						DB.Modules.ExpRepDisplay.EmbedLocation = nil
						return ''
					end
				end,
				set = function(_, value)
					if value == '' then
						DB.Modules.ExpRepDisplay.EmbedLocation = nil
					else
						value = value == '1' and 'Tab' or 'DP'
						
						DB.Modules.ExpRepDisplay.EmbedLocation = value
					end
					
					if Panel and not Panel.HiddenByToggled and (IsTabEnabled and not panelTab:IsShown() or IsDPEnabled and not panelDP:IsShown()) then
						KF:Create_CustomPanel(DB.Modules.ExpRepDisplay.EmbedPanel)
					end
					
					KF.Modules.ExpRepDisplay()
				end,
				values = function()
					local List = { [''] = NameColor('712633')..NONE, }
					
					if IsTabEnabled then
						List[''] = NameColor('ceff00')..L['Please Select']
						List['1'] = L['Panel Tab']
					end
					
					if IsDPEnabled then
						List[''] = NameColor('ceff00')..L['Please Select']
						List['2'] = L['Data Panel']
					end
					
					return List
				end,
			},
		}
	}
	
	-- Callbacks
	-- Toggle by custom panel's enable
	KF:RegisterCallback('CustomPanel_Toggle', function(_, value)
		KF.Modules.ExpRepDisplay(value)
	end, 'ExpRepDisplay_DisabledCustomPanel')
	
	-- Replace embeded panel key
	KF:RegisterCallback('CustomPanel_RewritePanelName', function(_, OldName, NewName)
		if DB.Modules.ExpRepDisplay.EmbedPanel and DB.Modules.ExpRepDisplay.EmbedPanel == OldName then
			DB.Modules.ExpRepDisplay.EmbedPanel = NewName
		end
	end, 'ExpRepDisplay_ReplacePanelName')
	
	-- Update by panel's changing
	KF:RegisterCallback('CustomPanel_PanelSettingChanged', function(_, panelName)
		if DB.Modules.ExpRepDisplay.EmbedPanel and DB.Modules.ExpRepDisplay.EmbedPanel == panelName then
			KF.Modules.ExpRepDisplay()
		end
	end, 'ExpRepDisplay_UpdateSetting')
	
	-- Clear setting when embeded panel was deleted
	KF:RegisterCallback('CustomPanel_Delete', function(_, panelName)
		if DB.Modules.ExpRepDisplay.EmbedPanel == panelName then
			DB.Modules.ExpRepDisplay.EmbedPanel = nil
			DB.Modules.ExpRepDisplay.EmbedLocation = nil
			
			KF.Modules.ExpRepDisplay()
		end
	end, 'ExpRepDisplay_ClearEmbedSetting')
end