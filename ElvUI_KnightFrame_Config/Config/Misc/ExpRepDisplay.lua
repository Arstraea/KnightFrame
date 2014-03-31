local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2013. 10. 12
-- Last Code Checking Version	: 2.2_05
-- Last Testing ElvUI Version	: 6.59

if not KF or not KF_Config then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Exp Rep Display OptionTable								>>--
--------------------------------------------------------------------------------
local Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled


local function NameColor(Color)
	return KF.db.Enable ~= false and KF.db.Layout.Enable ~= false and KF.db.Layout.ExpRepDisplay.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
end


KF_Config.Options.args.Layout.args.ExpRepDisplay = {
	type = 'group',
	name = function() return '|cffffffff 4. '..KF:Color_Value(L['ExpRep Display']) end,
	order = 400,
	disabled = function() return KF.db.Enable == false or KF.db.Layout.Enable == false or KF.db.Layout.ExpRepDisplay.Enable == false end,
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(KF.db.Enable ~= false and KF.db.Layout.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF.db.Layout.Enable ~= false and KF:Color_Value() or '')..L['ExpRep Display'] end,
			order = 1,
			desc = '',
			descStyle = 'inline',
			get = function() return KF.db.Layout.ExpRepDisplay.Enable end,
			set = function(_, value)
				KF.db.Layout.ExpRepDisplay.Enable = value
				
				KF.InitializeFunction['Layout']['ExpRepDisplay'](not value)
			end,
			width = 'full',
			disabled = function() return KF.db.Enable == false or KF.db.Layout.Enable == false end,
		},
		Space = {
			type = 'description',
			name = ' ',
			order = 2,
		},
		EmbedPanel = {
			type = 'select',
			name = function() return ' '..NameColor()..L['Frame To Embed'] end,
			order = 3,
			desc = '',
			descStyle = 'inline',
			get = function() return KF.db.Layout.ExpRepDisplay.EmbedPanel end,
			set = function(_, value)
				if value == '' then
					KF.db.Layout.ExpRepDisplay.EmbedPanel = nil
				else
					KF.db.Layout.ExpRepDisplay.EmbedPanel = value
				end
				
				KF.InitializeFunction['Layout']['ExpRepDisplay']()
				
				if not SelectedLocation then
				
				end
			end,
			values = function()
				local List = { [''] = NameColor('ceff00')..L['Please Select'], }
				
				for panelName, IsPanelData in pairs(KF.db.Layout.CustomPanel) do
					if type(IsPanelData) == 'table' and IsPanelData['Enable'] ~= false and (IsPanelData['Tab']['Enable'] or IsPanelData['DP']['Enable']) then
						List[panelName] = panelName
					end
				end
				
				return List
			end,
		},
		EmbedLocation = {
			type = 'select',
			name = function()
				Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled = KF:GetPanelData(KF.db.Layout.ExpRepDisplay.EmbedPanel)
				
				return ' '..((IsTabEnabled or IsDPEnabled) and NameColor() or '')..L['Embed Location']
			end,
			order = 4,
			desc = '',
			descStyle = 'inline',
			get = function()
				if IsTabEnabled or IsDPEnabled then
					return KF.db.Layout.ExpRepDisplay.EmbedLocation == 'Tab' and '1' or KF.db.Layout.ExpRepDisplay.EmbedLocation == 'DP' and '2' or KF.db.Layout.ExpRepDisplay.EmbedLocation
				else
					KF.db.Layout.ExpRepDisplay.EmbedLocation = nil
					return ''
				end
			end,
			set = function(_, value)
				if value == '' then
					KF.db.Layout.ExpRepDisplay.EmbedLocation = nil
				else
					value = value == '1' and 'Tab' or 'DP'
					
					KF.db.Layout.ExpRepDisplay.EmbedLocation = value
				end
				
				if Panel and not Panel.HiddenByToggled and (IsTabEnabled and not panelTab:IsShown() or IsDPEnabled and not panelDP:IsShown()) then
					KF:Create_CustomPanel(KF.db.Layout.ExpRepDisplay.EmbedPanel)
				end
				
				KF.InitializeFunction['Layout']['ExpRepDisplay']()
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




-- Callbacks
if KF.UIParent then
	-- Toggle by custom panel's enable
	KF:RegisterCallback('CustomPanel_Toggle', function(_, value)
		KF.InitializeFunction['Layout']['ExpRepDisplay'](value)
	end, 'ExpRepDisplay_DisabledCustomPanel')
	
	-- Replace embeded panel key
	KF:RegisterCallback('CustomPanel_RewritePanelName', function(_, OldName, NewName)
		if KF.db.Layout.ExpRepDisplay.EmbedPanel and KF.db.Layout.ExpRepDisplay.EmbedPanel == OldName then
			KF.db.Layout.ExpRepDisplay.EmbedPanel = NewName
		end
	end, 'ExpRepDisplay_ReplacePanelName')
	
	-- Update by panel's changing
	KF:RegisterCallback('CustomPanel_PanelSettingChanged', function(_, panelName)
		if KF.db.Layout.ExpRepDisplay.EmbedPanel and KF.db.Layout.ExpRepDisplay.EmbedPanel == panelName then
			KF.InitializeFunction['Layout']['ExpRepDisplay']()
		end
	end, 'ExpRepDisplay_UpdateSetting')
	
	-- Clear setting when embeded panel was deleted
	KF:RegisterCallback('CustomPanel_Delete', function(_, panelName)
		if KF.db.Layout.ExpRepDisplay.EmbedPanel == panelName then
			KF.db.Layout.ExpRepDisplay.EmbedPanel = nil
			KF.db.Layout.ExpRepDisplay.EmbedLocation = nil
			
			KF.InitializeFunction['Layout']['ExpRepDisplay']()
		end
	end, 'ExpRepDisplay_ClearEmbedSetting')
end