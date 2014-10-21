local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (KF and KF.Modules and KF.Modules.EmbedMeter and KF_Config) then return end
--------------------------------------------------------------------------------
--<< KnightFrame : Embed Meter												>>--
--------------------------------------------------------------------------------
local SkadaLoaded = IsAddOnLoaded('Skada') or IsAddOnLoaded('SkadaU')
local RecountLoaded = IsAddOnLoaded('Recount')
local OmenLoaded = IsAddOnLoaded('Omen')
local PanelNumber


local function NameColor(Color)
	return DB.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
end


local function GetPanelList(Key)
	local List = { [''] = (DB.Enable and '|cffceff00' or '')..L['Please Select'], }
	
	if PanelNumber.LeftChatPanel > 1 or (PanelNumber.LeftChatPanel == 1 and Key ~= 'LeftChatPanel') then
		List['LeftChatPanelLEFT'] = NameColor()..'Left|r : '..L['Left Chat']
		List['LeftChatPanelRIGHT'] = NameColor()..'Right|r : '..L['Left Chat']
	else
		List.LeftChatPanel = L['Left Chat']
	end
	
	if PanelNumber.RightChatPanel > 1 or (PanelNumber.RightChatPanel == 1 and Key ~= 'RightChatPanel') then
		List['RightChatPanelLEFT'] = NameColor()..'Left|r : '..L['Right Chat']
		List['RightChatPanelRIGHT'] = NameColor()..'Right|r : '..L['Right Chat']
	else
		List.RightChatPanel = L['Right Chat']
	end
	
	for panelName, IsPanelData in pairs(DB.Modules.CustomPanel) do
		if type(IsPanelData) == 'table' and IsPanelData.Enable ~= false then
			if PanelNumber[panelName] and (PanelNumber[panelName] > 1 or (PanelNumber[panelName] == 1 and Key ~= panelName)) then
				List[panelName..'LEFT'] = NameColor()..'Left|r : '..panelName
				List[panelName..'RIGHT'] = NameColor()..'Right|r : '..panelName
			else
				List[panelName] = panelName
			end
		end
	end
	
	return List
end


local function CheckDuplication(Key, Direction)
	local isDuplicated, anotherDB
	
	if SkadaLoaded then
		for k, win in ipairs(Skada:GetWindows()) do
			if win.db.KnightFrame_Embed and win.db.KnightFrame_Embed.Key == Key then
				if win.db.KnightFrame_Embed.Direction == Direction then
					isDuplicated = k
				else
					anotherDB = k
				end
			end
		end
	end
	
	if RecountLoaded and Recount.db.profile.KnightFrame_Embed and Recount.db.profile.KnightFrame_Embed.Key == Key then
		if Recount.db.profile.KnightFrame_Embed.Direction == Direction then
			isDuplicated = 'Recount'
		else
			anotherDB = 'Recount'
		end
	end
	
	if OmenLoaded and Omen.db.profile.KnightFrame_Embed and Omen.db.profile.KnightFrame_Embed.Key == Key then
		if Omen.db.profile.KnightFrame_Embed.Direction == Direction then
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
				get = function() return window.db.KnightFrame_Embed and window.db.KnightFrame_Embed.Key..(PanelNumber[window.db.KnightFrame_Embed.Key] > 1 and ''..window.db.KnightFrame_Embed.Direction or '') or '' end,
				set = function(_, value)
					window.db.KnightFrame_Embed = nil
					
					if value ~= '' then
						local Key, Direction = strsplit('', value)
						Direction = Direction or 'LEFT'
						
						local isDuplicated, anotherDB = CheckDuplication(Key, Direction)
						
						if isDuplicated then
							if anotherDB and anotherDB ~= i then
								if type(isDuplicated) == 'string' then
									_G[isDuplicated].db.profile.KnightFrame_Embed = nil
								else
									Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed = nil
								end
							else
								if type(isDuplicated) == 'string' then
									_G[isDuplicated].db.profile.KnightFrame_Embed.Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
								else
									Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed.Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
								end
							end
						end
						
						window.db.KnightFrame_Embed = {
							Key = Key,
							Direction = Direction,
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
				values = function() return GetPanelList(window.db.KnightFrame_Embed and window.db.KnightFrame_Embed.Key or nil) end,
				hidden = function() return DB.Modules.EmbedMeter.Enable == false or not Skada:GetWindows()[i] end,
				disabled = function() return DB.Enable == false end
			}
		end
	end
end


--<< Embed Meter >>--
KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.EmbedMeter = {
	type = 'group',
	order = 100 + OptionIndex,
	name = function()
		-- Count embeded panel
		PanelNumber = { LeftChatPanel = 0, RightChatPanel = 0, }
		
		if SkadaLoaded then
			for _, window in ipairs(Skada:GetWindows()) do
				if window.db.KnightFrame_Embed then
					PanelNumber[window.db.KnightFrame_Embed.Key] = (PanelNumber[window.db.KnightFrame_Embed.Key] or 0) + 1
				end
			end
		end
		
		if RecountLoaded and Recount.db.profile.KnightFrame_Embed then
			PanelNumber[Recount.db.profile.KnightFrame_Embed.Key] = (PanelNumber[Recount.db.profile.KnightFrame_Embed.Key] or 0) + 1
		end
		
		if OmenLoaded and Omen.db.profile.KnightFrame_Embed then
			PanelNumber[Omen.db.profile.KnightFrame_Embed.Key] = (PanelNumber[Omen.db.profile.KnightFrame_Embed.Key] or 0) + 1
		end
		
		-- Create Skada window config
		SettingSkada()
		
		return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Embed Meter'])
	end,
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(DB.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Embed Meter'] end,
			order = 1,
			desc = L["Embed MeterAddon to ElvUI's Chat Panel or KnightFrame's Custom Panel."],
			descStyle = 'inline',
			get = function() return DB.Modules.EmbedMeter.Enable end,
			set = function(_, value)
				DB.Modules.EmbedMeter.Enable = value
				
				KF.Modules.EmbedMeter()
			end,
			disabled = function() return DB.Enable == false end,
			width = 'full'
		},
		Space = {
			type = 'description',
			name = ' ',
			order = 2,
			hidden = function() return DB.Modules.EmbedMeter.Enable == false end
		}
	}
}


if RecountLoaded then
	KF_Config.Options.args.EmbedMeter.args.Recount = {
		type = 'select',
		name = function() return ' '..NameColor()..'Recount' end,
		order = -1,
		desc = '',
		descStyle = 'inline',
		get = function() return Recount.db.profile.KnightFrame_Embed and Recount.db.profile.KnightFrame_Embed.Key..(PanelNumber[Recount.db.profile.KnightFrame_Embed.Key] > 1 and ''..Recount.db.profile.KnightFrame_Embed.Direction or '') or '' end,
		set = function(_, value)
			Recount.db.profile.KnightFrame_Embed = nil
			
			if value ~= '' then
				local Key, Direction = strsplit('', value)
				Direction = Direction or 'LEFT'
				
				local isDuplicated, anotherDB = CheckDuplication(Key, Direction)
				
				if isDuplicated then
					if anotherDB and anotherDB ~= 'Recount' then
						if type(isDuplicated) == 'string' then
							_G[isDuplicated].db.profile.KnightFrame_Embed = nil
						else
							Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed = nil
						end
					else
						if type(isDuplicated) == 'string' then
							_G[isDuplicated].db.profile.KnightFrame_Embed.Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
						else
							Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed.Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
						end
					end
				end
				
				Recount.db.profile.KnightFrame_Embed = {
					Key = Key,
					Direction = Direction,
				}
			else
				KF:EmbedMeter_ClearSetting_Recount()
			end
			
			if KF:EmbedMeter_CheckNeedEmbeding() then
				KF:EmbedMeter()
			end
		end,
		values = function() return GetPanelList(Recount.db.profile.KnightFrame_Embed and Recount.db.profile.KnightFrame_Embed.Key or nil) end,
		hidden = function() return DB.Modules.EmbedMeter.Enable == false end,
		disabled = function() return DB.Enable == false end
	}
end


if OmenLoaded then
	KF_Config.Options.args.EmbedMeter.args.Omen = {
		type = 'select',
		name = function() return ' '..NameColor()..'Omen3' end,
		order = -2,
		desc = '',
		descStyle = 'inline',
		get = function() return Omen.db.profile.KnightFrame_Embed and Omen.db.profile.KnightFrame_Embed.Key..(PanelNumber[Omen.db.profile.KnightFrame_Embed.Key] > 1 and ''..Omen.db.profile.KnightFrame_Embed.Direction or '') or '' end,
		set = function(_, value)
			Omen.db.profile.KnightFrame_Embed = nil
			
			if value ~= '' then
				local Key, Direction = strsplit('', value)
				Direction = Direction or 'LEFT'
				
				local isDuplicated, anotherDB = CheckDuplication(Key, Direction)
				
				if isDuplicated then
					if anotherDB and anotherDB ~= 'Omen' then
						if type(isDuplicated) == 'string' then
							_G[isDuplicated].db.profile.KnightFrame_Embed = nil
						else
							Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed = nil
						end
					else
						if type(isDuplicated) == 'string' then
							_G[isDuplicated].db.profile.KnightFrame_Embed.Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
						else
							Skada:GetWindows()[isDuplicated].db.KnightFrame_Embed.Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
						end
					end
				end
				
				Omen.db.profile.KnightFrame_Embed = {
					Key = Key,
					Direction = Direction,
				}
			else
				KF:EmbedMeter_ClearSetting_Omen()
			end
			
			if KF:EmbedMeter_CheckNeedEmbeding() then
				KF:EmbedMeter()
			end
		end,
		values = function() return GetPanelList(Omen.db.profile.KnightFrame_Embed and Omen.db.profile.KnightFrame_Embed.Key or nil) end,
		hidden = function() return DB.Modules.EmbedMeter.Enable == false end,
		disabled = function() return DB.Enable == false end
	}
end


do	-- Callbacks
	local function UpdateEmbedMeter(...)
		if KF:EmbedMeter_CheckNeedEmbeding() then
			KF:EmbedMeter()
		end
	end
	
	-- Toggle by custom panel's enable
	KF:RegisterCallback('CustomPanel_Toggle', UpdateEmbedMeter, 'EmbedMeter_DisabledCustomPanel')
	
	-- Replace embeded panel Key
	KF:RegisterCallback('CustomPanel_RewritePanelName', function(_, OldName, NewName)
		if SkadaLoaded then
			for _, window in ipairs(Skada:GetWindows()) do
				if window.db.KnightFrame_Embed and window.db.KnightFrame_Embed.Key == OldName then
					window.db.KnightFrame_Embed.Key = NewName
				end
			end
		end
		
		if RecountLoaded and Recount.db.profile.KnightFrame_Embed and Recount.db.profile.KnightFrame_Embed.Key == OldName then
			Recount.db.profile.KnightFrame_Embed.Key = NewName
		end
		
		if OmenLoaded and Omen.db.profile.KnightFrame_Embed and Omen.db.profile.KnightFrame_Embed.Key == OldName then
			Omen.db.profile.KnightFrame_Embed.Key = NewName
		end
		
		if DB.Modules.EmbedMeter.SplitRatio and DB.Modules.EmbedMeter.SplitRatio[OldName] then
			DB.Modules.EmbedMeter.SplitRatio[NewName] = DB.Modules.EmbedMeter.SplitRatio[OldName]
			DB.Modules.EmbedMeter.SplitRatio[OldName] = nil
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