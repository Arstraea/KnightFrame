local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')
--[[
if not (KF and KF.Modules and KF.Modules.EmbedMeter and KF_Config) then return end
--------------------------------------------------------------------------------
--<< KnightFrame : Embed Meter												>>--
--------------------------------------------------------------------------------
local SkadaLoaded = IsAddOnLoaded('Skada') or IsAddOnLoaded('SkadaU')
local RecountLoaded = IsAddOnLoaded('Recount')
local OmenLoaded = IsAddOnLoaded('Omen')
local PanelNumber


local function NameColor(Color)
	return KF.db.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
end


local function GetPanelList(key)
	local List = { [''] = (KF.db.Enable and '|cffceff00' or '')..L['Please Select'], }
	
	if PanelNumber['LeftChatPanel'] > 1 or (PanelNumber['LeftChatPanel'] == 1 and key ~= 'LeftChatPanel') then
		List['LeftChatPanelLEFT'] = NameColor()..'Left|r : '..L['Left Chat']
		List['LeftChatPanelRIGHT'] = NameColor()..'Right|r : '..L['Left Chat']
	else
		List['LeftChatPanel'] = L['Left Chat']
	end
	
	if PanelNumber['RightChatPanel'] > 1 or (PanelNumber['RightChatPanel'] == 1 and key ~= 'RightChatPanel') then
		List['RightChatPanelLEFT'] = NameColor()..'Left|r : '..L['Right Chat']
		List['RightChatPanelRIGHT'] = NameColor()..'Right|r : '..L['Right Chat']
	else
		List['RightChatPanel'] = L['Right Chat']
	end
	
	for panelName, IsPanelData in pairs(KF.db.Modules.CustomPanel) do
		if type(IsPanelData) == 'table' and IsPanelData.Enable ~= false then
			if PanelNumber[panelName] and (PanelNumber[panelName] > 1 or (PanelNumber[panelName] == 1 and key ~= panelName)) then
				List[panelName..'LEFT'] = NameColor()..'Left|r : '..panelName
				List[panelName..'RIGHT'] = NameColor()..'Right|r : '..panelName
			else
				List[panelName] = panelName
			end
		end
	end
	
	return List
end


local function CheckDuplication(key, direction)
	local isDuplicated, anotherDB
	
	if SkadaLoaded then
		for k, win in ipairs(Skada:GetWindows()) do
			if win.db.KnightFrame_Embed and win.db.KnightFrame_Embed.key == key then
				if win.db.KnightFrame_Embed.direction == direction then
					isDuplicated = k
				else
					anotherDB = k
				end
			end
		end
	end
	
	if RecountLoaded and Recount.db.profile.KnightFrame_Embed and Recount.db.profile.KnightFrame_Embed.key == key then
		if Recount.db.profile.KnightFrame_Embed.direction == direction then
			isDuplicated = 'Recount'
		else
			anotherDB = 'Recount'
		end
	end
	
	if OmenLoaded and Omen.db.profile.KnightFrame_Embed and Omen.db.profile.KnightFrame_Embed.key == key then
		if Omen.db.profile.KnightFrame_Embed.direction == direction then
			isDuplicated = 'Omen'
		else
			anotherDB = 'Omen'
		end
	end
	
	return isDuplicated, anotherDB
end


local function SettingSkada()
	if SkadaLoaded then
		for i, window in ipairs(Skada:GetWindows()) do
			E.Options.args.KnightFrame.args.EmbedMeter.args[tostring(i)] = {
				type = 'select',
				name = function() return ' '..NameColor()..'Skada '..NameColor('ffffff')..': '..(Skada:GetWindows()[i] and Skada:GetWindows()[i].db.name or '') end,
				order = i + 3,
				desc = '',
				descStyle = 'inline',
				get = function() return window.db.KnightFrame_Embed and window.db.KnightFrame_Embed.key..(PanelNumber[window.db.KnightFrame_Embed.key] > 1 and ''..window.db.KnightFrame_Embed.direction or '') or '' end,
				set = function(_, value)
					window.db.KnightFrame_Embed = nil
					
					if value ~= '' then
						local key, direction = strsplit('', value)
						direction = direction or 'LEFT'
						
						local isDuplicated, anotherDB = CheckDuplication(key, direction)
						
						if isDuplicated then
							if anotherDB and anotherDB ~= i then
								if type(isDuplicated) == 'string' then
									_G[isDuplicated].db.profile.KnightFrame_Embed = nil
								else
									Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed = nil
								end
							else
								if type(isDuplicated) == 'string' then
									_G[isDuplicated].db.profile.KnightFrame_Embed.direction = direction == 'LEFT' and 'RIGHT' or 'LEFT'
								else
									Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed.direction = direction == 'LEFT' and 'RIGHT' or 'LEFT'
								end
							end
						end
						
						window.db.KnightFrame_Embed = {
							['key'] = key,
							['direction'] = direction,
						}
						
						if KF:EmbedMeter_CheckNeedEmbeding() then
							KF:EmbedMeter()
						end
					else
						KF:EmbedMeter_ClearSetting_Skada(nil, i)
						
						if KF:EmbedMeter_CheckNeedEmbeding() then
							KF:EmbedMeter()
						end
					end
				end,
				values = function() return GetPanelList(window.db.KnightFrame_Embed and window.db.KnightFrame_Embed.key or nil) end,
				hidden = function() return KF.db.Modules.EmbedMeter.Enable == false or not Skada:GetWindows()[i] end,
				disabled = function() return KF.db.Enable == false end,
			}
		end
	end
end


--<< Embed Meter >>--
KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.EmbedMeter = {
	type = 'group',
	order = 800,
	name = function()
		-- Count embeded panel
		PanelNumber = { ['LeftChatPanel'] = 0, ['RightChatPanel'] = 0, }
		
		if SkadaLoaded then
			for _, window in ipairs(Skada:GetWindows()) do
				if window.db.KnightFrame_Embed then
					PanelNumber[window.db.KnightFrame_Embed.key] = (PanelNumber[window.db.KnightFrame_Embed.key] or 0) + 1
				end
			end
		end
		
		if RecountLoaded and Recount.db.profile.KnightFrame_Embed then
			PanelNumber[Recount.db.profile.KnightFrame_Embed.key] = (PanelNumber[Recount.db.profile.KnightFrame_Embed.key] or 0) + 1
		end
		
		if OmenLoaded and Omen.db.profile.KnightFrame_Embed then
			PanelNumber[Omen.db.profile.KnightFrame_Embed.key] = (PanelNumber[Omen.db.profile.KnightFrame_Embed.key] or 0) + 1
		end
		
		-- Create Skada window config
		SettingSkada()
		
		return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Embed Meter'])
	end,
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Enable'] end,
			order = 1,
			desc = '',
			descStyle = 'inline',
			get = function() return KF.db.Modules.EmbedMeter.Enable end,
			set = function(_, value)
				KF.db.Modules.EmbedMeter.Enable = value
				
				KF.Modules.EmbedMeter()
			end,
			disabled = function() return KF.db.Enable == false end,
		},
		Description = {
			type = 'description',
			name = L["Embed MeterAddon to ElvUI's Chat Panel or KnightFrame's Custom Panel."],
			order = 2,
			width = 'double',
		},
		Space = {
			type = 'description',
			name = ' ',
			order = 3,
			hidden = function() return KF.db.Modules.EmbedMeter.Enable == false end,
		},
	},
}


if RecountLoaded then
	KF_Config.Options.args.EmbedMeter.args.Recount = {
		type = 'select',
		name = function() return ' '..NameColor()..'Recount' end,
		order = -1,
		desc = '',
		descStyle = 'inline',
		get = function() return Recount.db.profile.KnightFrame_Embed and Recount.db.profile.KnightFrame_Embed.key..(PanelNumber[Recount.db.profile.KnightFrame_Embed.key] > 1 and ''..Recount.db.profile.KnightFrame_Embed.direction or '') or '' end,
		set = function(_, value)
			Recount.db.profile.KnightFrame_Embed = nil
			
			if value ~= '' then
				local key, direction = strsplit('', value)
				direction = direction or 'LEFT'
				
				local isDuplicated, anotherDB = CheckDuplication(key, direction)
				
				if isDuplicated then
					if anotherDB and anotherDB ~= 'Recount' then
						if type(isDuplicated) == 'string' then
							_G[isDuplicated].db.profile.KnightFrame_Embed = nil
						else
							Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed = nil
						end
					else
						if type(isDuplicated) == 'string' then
							_G[isDuplicated].db.profile.KnightFrame_Embed.direction = direction == 'LEFT' and 'RIGHT' or 'LEFT'
						else
							Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed.direction = direction == 'LEFT' and 'RIGHT' or 'LEFT'
						end
					end
				end
				
				Recount.db.profile.KnightFrame_Embed = {
					['key'] = key,
					['direction'] = direction,
				}
			else
				KF:EmbedMeter_ClearSetting_Recount()
			end
			
			if KF:EmbedMeter_CheckNeedEmbeding() then
				KF:EmbedMeter()
			end
		end,
		values = function() return GetPanelList(Recount.db.profile.KnightFrame_Embed and Recount.db.profile.KnightFrame_Embed.key or nil) end,
		hidden = function() return KF.db.Modules.EmbedMeter.Enable == false end,
		disabled = function() return KF.db.Enable == false end,
	}
end


if OmenLoaded then
	KF_Config.Options.args.EmbedMeter.args.Omen = {
		type = 'select',
		name = function() return ' '..NameColor()..'Omen3' end,
		order = -2,
		desc = '',
		descStyle = 'inline',
		get = function() return Omen.db.profile.KnightFrame_Embed and Omen.db.profile.KnightFrame_Embed.key..(PanelNumber[Omen.db.profile.KnightFrame_Embed.key] > 1 and ''..Omen.db.profile.KnightFrame_Embed.direction or '') or '' end,
		set = function(_, value)
			Omen.db.profile.KnightFrame_Embed = nil
			
			if value ~= '' then
				local key, direction = strsplit('', value)
				direction = direction or 'LEFT'
				
				local isDuplicated, anotherDB = CheckDuplication(key, direction)
				
				if isDuplicated then
					if anotherDB and anotherDB ~= 'Omen' then
						if type(isDuplicated) == 'string' then
							_G[isDuplicated].db.profile.KnightFrame_Embed = nil
						else
							Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed = nil
						end
					else
						if type(isDuplicated) == 'string' then
							_G[isDuplicated].db.profile.KnightFrame_Embed.direction = direction == 'LEFT' and 'RIGHT' or 'LEFT'
						else
							Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed.direction = direction == 'LEFT' and 'RIGHT' or 'LEFT'
						end
					end
				end
				
				Omen.db.profile.KnightFrame_Embed = {
					['key'] = key,
					['direction'] = direction,
				}
			else
				KF:EmbedMeter_ClearSetting_Omen()
			end
			
			if KF:EmbedMeter_CheckNeedEmbeding() then
				KF:EmbedMeter()
			end
		end,
		values = function() return GetPanelList(Omen.db.profile.KnightFrame_Embed and Omen.db.profile.KnightFrame_Embed.key or nil) end,
		hidden = function() return KF.db.Modules.EmbedMeter.Enable == false end,
		disabled = function() return KF.db.Enable == false end,
	}
end




-- Callbacks
if KF.UIParent then
	local function UpdateEmbedMeter()
		if KF:EmbedMeter_CheckNeedEmbeding() then
			KF:EmbedMeter()
		end
	end
	
	-- Toggle by custom panel's enable
	KF:RegisterCallback('CustomPanel_Toggle', UpdateEmbedMeter, 'EmbedMeter_DisabledCustomPanel')
	
	-- Replace embeded panel key
	KF:RegisterCallback('CustomPanel_RewritePanelName', function(_, OldName, NewName)
		if SkadaLoaded then
			for _, window in ipairs(Skada:GetWindows()) do
				if window.db.KnightFrame_Embed and window.db.KnightFrame_Embed.key == OldName then
					window.db.KnightFrame_Embed.key = NewName
				end
			end
		end
		
		if RecountLoaded and Recount.db.profile.KnightFrame_Embed and Recount.db.profile.KnightFrame_Embed.key == OldName then
			Recount.db.profile.KnightFrame_Embed.key = NewName
		end
		
		if OmenLoaded and Omen.db.profile.KnightFrame_Embed and Omen.db.profile.KnightFrame_Embed.key == OldName then
			Omen.db.profile.KnightFrame_Embed.key = NewName
		end
		
		if KF.db.Modules.EmbedMeter.SplitRatio and KF.db.Modules.EmbedMeter.SplitRatio[OldName] then
			KF.db.Modules.EmbedMeter.SplitRatio[NewName] = KF.db.Modules.EmbedMeter.SplitRatio[OldName]
			KF.db.Modules.EmbedMeter.SplitRatio[OldName] = nil
		end
	end, 'EmbedMeter_ReplacePanelName')
	
	-- Update by custom panel's changing
	KF:RegisterCallback('CustomPanel_PanelSettingChanged', UpdateEmbedMeter, 'EmbedMeter_RunEmbedingByCustomPanelCreating')
	
	-- Update by chat panel's changing
	hooksecurefunc(E.Layout, 'ToggleChatPanels', UpdateEmbedMeter)
	hooksecurefunc(E:GetModule('Chat'), 'PositionChat', UpdateEmbedMeter)
	
	-- Clear setting when embeded panel was deleted
	KF:RegisterCallback('CustomPanel_Delete', KF.EmbedMeter_ClearSettingByPanel, 'EmbedMeter_ClearEmbedSetting')
end
]]