local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if KF.Modules.ExpRepDisplay then
	local Panel, PanelType, PanelTab, IsTabEnabled, PanelDP, IsDPEnabled
	
	
	local function NameColor(Color)
		return KF.db.Enable ~= false and KF.db.Modules.ExpRepDisplay.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
	end
	
	
	KF_Config.MiscCategoryCount = KF_Config.MiscCategoryCount + 1
	local OptionIndex = KF_Config.MiscCategoryCount
	KF_Config.Options.args.Misc.args.ExpRepDisplay = {
		type = 'group',
		name = function() return ' '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['ExpRep Display'] end,
		order = OptionIndex,
		guiInline = true,
		disabled = function() return KF.db.Enable == false or KF.db.Modules.ExpRepDisplay.Enable == false end,
		args = {
			Enable = {
				type = 'toggle',
				name = function() return ' '..(KF.db.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['ExpRep Display'] end,
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function() return KF.db.Modules.ExpRepDisplay.Enable end,
				set = function(_, value)
					KF.db.Modules.ExpRepDisplay.Enable = value
					
					KF.Modules.ExpRepDisplay(not value)
				end,
				width = 'full',
				disabled = function() return KF.db.Enable == false end
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
				get = function() return KF.db.Modules.ExpRepDisplay.EmbedPanel or '' end,
				set = function(_, value)
					if value == '' then
						KF.db.Modules.ExpRepDisplay.EmbedPanel = nil
					else
						KF.db.Modules.ExpRepDisplay.EmbedPanel = value
					end
					
					KF.Modules.ExpRepDisplay()
				end,
				values = function()
					local List = { [''] = NameColor('ceff00')..L['Please Select'] }
					
					for PanelName, LocalizedName in pairs({ LeftChatPanel = 'Left Chat', RightChatPanel = 'Right Chat' }) do
						_, _, _, IsTabEnabled, _, IsDPEnabled = KF:GetPanelData(PanelName)
						
						if IsTabEnabled or ISDPEnabled then
							List[PanelName] = L[LocalizedName]
						end
					end
					
					for PanelName, IsPanelData in pairs(KF.db.Modules.CustomPanel) do
						if type(IsPanelData) == 'table' and IsPanelData.Enable ~= false and (IsPanelData.Tab.Enable or IsPanelData.DP.Enable) then
							List[PanelName] = PanelName
						end
					end
					
					return List
				end
			},
			EmbedLocation = {
				type = 'select',
				name = function()
					Panel, PanelType, PanelTab, IsTabEnabled, PanelDP, IsDPEnabled = KF:GetPanelData(KF.db.Modules.ExpRepDisplay.EmbedPanel)
					
					return ' '..((IsTabEnabled or IsDPEnabled) and NameColor() or '')..L['Embed Location']
				end,
				order = 4,
				desc = '',
				descStyle = 'inline',
				get = function()
					if IsTabEnabled or IsDPEnabled then
						return KF.db.Modules.ExpRepDisplay.EmbedLocation == 'Tab' and '1' or KF.db.Modules.ExpRepDisplay.EmbedLocation == 'DP' and '2' or KF.db.Modules.ExpRepDisplay.EmbedLocation or ''
					else
						KF.db.Modules.ExpRepDisplay.EmbedLocation = nil
						return ''
					end
				end,
				set = function(_, value)
					if value == '' then
						KF.db.Modules.ExpRepDisplay.EmbedLocation = nil
					else
						value = value == '1' and 'Tab' or 'DP'
						
						KF.db.Modules.ExpRepDisplay.EmbedLocation = value
					end
					
					if Panel and not Panel.HiddenByToggled and (IsTabEnabled and not PanelTab:IsShown() or IsDPEnabled and not PanelDP:IsShown()) then
						KF:Create_CustomPanel(KF.db.Modules.ExpRepDisplay.EmbedPanel)
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
		if KF.db.Modules.ExpRepDisplay.EmbedPanel and KF.db.Modules.ExpRepDisplay.EmbedPanel == OldName then
			KF.db.Modules.ExpRepDisplay.EmbedPanel = NewName
		end
	end, 'ExpRepDisplay_ReplacePanelName')
	
	-- Update by panel's changing
	KF:RegisterCallback('CustomPanel_PanelSettingChanged', function(_, panelName)
		if KF.db.Modules.ExpRepDisplay.EmbedPanel and KF.db.Modules.ExpRepDisplay.EmbedPanel == panelName then
			KF.Modules.ExpRepDisplay()
		end
	end, 'ExpRepDisplay_UpdateSetting')
	
	-- Clear setting when embeded panel was deleted
	KF:RegisterCallback('CustomPanel_Delete', function(_, panelName)
		if KF.db.Modules.ExpRepDisplay.EmbedPanel == panelName then
			KF.db.Modules.ExpRepDisplay.EmbedPanel = nil
			KF.db.Modules.ExpRepDisplay.EmbedLocation = nil
			
			KF.Modules.ExpRepDisplay()
		end
	end, 'ExpRepDisplay_ClearEmbedSetting')
end