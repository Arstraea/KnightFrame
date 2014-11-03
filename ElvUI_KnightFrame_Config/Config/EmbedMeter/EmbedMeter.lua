local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
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
	return KF.db.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
end


local function GetPanelList(Key)
	local List = { [''] = (KF.db.Enable and '|cffceff00' or '')..L['Please Select'], }
	
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
	
	for panelName, IsPanelData in pairs(KF.db.Modules.CustomPanel) do
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
		for WindowNumber = 1, #Skada:GetWindows() do
			if KF.db.Modules.EmbedMeter.Skada and KF.db.Modules.EmbedMeter.Skada[WindowNumber] and KF.db.Modules.EmbedMeter.Skada[WindowNumber].Key == Key then
				if KF.db.Modules.EmbedMeter.Skada[WindowNumber].Direction == Direction then
					isDuplicated = WindowNumber
				else
					anotherDB = WindowNumber
				end
			end
		end
	end
	
	if RecountLoaded and KF.db.Modules.EmbedMeter.Recount and KF.db.Modules.EmbedMeter.Recount.Key == Key then
		if KF.db.Modules.EmbedMeter.Recount.Direction == Direction then
			isDuplicated = 'Recount'
		else
			anotherDB = 'Recount'
		end
	end
	
	if OmenLoaded and KF.db.Modules.EmbedMeter.Omen and KF.db.Modules.EmbedMeter.Omen.Key == Key then
		if KF.db.Modules.EmbedMeter.Omen.Direction == Direction then
			isDuplicated = 'Omen'
		else
			anotherDB = 'Omen'
		end
	end
	
	return isDuplicated, anotherDB
end


local function SettingSkada()
	if SkadaLoaded then
		local WindowTable = Skada:GetWindows()
		
		for WindowNumber = 1, #WindowTable do
			E.Options.args.KnightFrame.args.EmbedMeter.args[tostring(WindowNumber)] = {
				type = 'select',
				name = function() return ' '..NameColor()..'Skada '..NameColor('ffffff')..': '..(WindowTable[WindowNumber].db.name or '') end,
				order = WindowNumber + 3,
				desc = '',
				descStyle = 'inline',
				get = function() return KF.db.Modules.EmbedMeter.Skada[WindowNumber] and KF.db.Modules.EmbedMeter.Skada[WindowNumber].Key..(PanelNumber[KF.db.Modules.EmbedMeter.Skada[WindowNumber].Key] > 1 and ''..KF.db.Modules.EmbedMeter.Skada[WindowNumber].Direction or '') or '' end,
				set = function(_, value)
					KF.db.Modules.EmbedMeter.Skada[WindowNumber] = nil
					
					if value ~= '' then
						local Key, Direction = strsplit('', value)
						Direction = Direction or 'LEFT'
						
						local IsDuplicated, AnotherDB = CheckDuplication(Key, Direction)
						
						if IsDuplicated then
							if AnotherDB and AnotherDB ~= WindowNumber then
								if type(IsDuplicated) == 'string' then
									KF.db.Modules.EmbedMeter[IsDuplicated] = nil
								else
									KF.db.Modules.EmbedMeter.Skada[IsDuplicated] = nil
								end
							else
								if type(IsDuplicated) == 'string' then
									KF.db.Modules.EmbedMeter[IsDuplicated].Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
								else
									KF.db.Modules.EmbedMeter.Skada[IsDuplicated].Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
								end
							end
						end
						
						KF.db.Modules.EmbedMeter.Skada[WindowNumber] = {
							Key = Key,
							Direction = Direction,
						}
						
						if KF:EmbedMeter_CheckNeedEmbeding() then
							KF:EmbedMeter()
						end
					else
						KF:EmbedMeter_ClearSetting_Skada(nil, WindowNumber)
						
						if KF:EmbedMeter_CheckNeedEmbeding() then
							KF:EmbedMeter()
						end
					end
				end,
				values = function() return GetPanelList(KF.db.Modules.EmbedMeter.Skada[WindowNumber] and KF.db.Modules.EmbedMeter.Skada[WindowNumber].Key or nil) end,
				hidden = function() return KF.db.Modules.EmbedMeter.Enable == false or not WindowTable[WindowNumber] end,
				disabled = function() return KF.db.Enable == false end
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
			for WindowNumber = 1, #Skada:GetWindows() do
				if KF.db.Modules.EmbedMeter.Skada[WindowNumber] then
					PanelNumber[KF.db.Modules.EmbedMeter.Skada[WindowNumber].Key] = (PanelNumber[KF.db.Modules.EmbedMeter.Skada[WindowNumber].Key] or 0) + 1
				end
			end
		end
		
		if RecountLoaded and KF.db.Modules.EmbedMeter.Recount then
			PanelNumber[KF.db.Modules.EmbedMeter.Recount.Key] = (PanelNumber[KF.db.Modules.EmbedMeter.Recount.Key] or 0) + 1
		end
		
		if OmenLoaded and KF.db.Modules.EmbedMeter.Omen then
			PanelNumber[KF.db.Modules.EmbedMeter.Omen.Key] = (PanelNumber[KF.db.Modules.EmbedMeter.Omen.Key] or 0) + 1
		end
		
		-- Create Skada window config
		SettingSkada()
		
		return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Embed Meter'])
	end,
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(KF.db.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Embed Meter'] end,
			order = 1,
			desc = L["Embed MeterAddon to ElvUI's Chat Panel or KnightFrame's Custom Panel."],
			descStyle = 'inline',
			get = function() return KF.db.Modules.EmbedMeter.Enable end,
			set = function(_, value)
				KF.db.Modules.EmbedMeter.Enable = value
				
				KF.Modules.EmbedMeter()
			end,
			disabled = function() return KF.db.Enable == false end,
			width = 'full'
		},
		Space = {
			type = 'description',
			name = ' ',
			order = 2,
			hidden = function() return KF.db.Modules.EmbedMeter.Enable == false end
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
		get = function() return KF.db.Modules.EmbedMeter.Recount and KF.db.Modules.EmbedMeter.Recount.Key..(PanelNumber[KF.db.Modules.EmbedMeter.Recount.Key] > 1 and ''..KF.db.Modules.EmbedMeter.Recount.Direction or '') or '' end,
		set = function(_, value)
			KF.db.Modules.EmbedMeter.Recount = nil
			
			if value ~= '' then
				local Key, Direction = strsplit('', value)
				Direction = Direction or 'LEFT'
				
				local IsDuplicated, AnotherDB = CheckDuplication(Key, Direction)
				
				if IsDuplicated then
					if AnotherDB and AnotherDB ~= 'Recount' then
						if type(IsDuplicated) == 'string' then
							KF.db.Modules.EmbedMeter[IsDuplicated] = nil
						else
							KF.db.Modules.EmbedMeter.Skada[IsDuplicated] = nil
						end
					else
						if type(IsDuplicated) == 'string' then
							KF.db.Modules.EmbedMeter[IsDuplicated].Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
						else
							KF.db.Modules.EmbedMeter.Skada[IsDuplicated].Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
						end
					end
				end
				
				KF.db.Modules.EmbedMeter.Recount = {
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
		values = function() return GetPanelList(KF.db.Modules.EmbedMeter.Recount and KF.db.Modules.EmbedMeter.Recount.Key or nil) end,
		hidden = function() return KF.db.Modules.EmbedMeter.Enable == false end,
		disabled = function() return KF.db.Enable == false end
	}
end


if OmenLoaded then
	KF_Config.Options.args.EmbedMeter.args.Omen = {
		type = 'select',
		name = function() return ' '..NameColor()..'Omen3' end,
		order = -2,
		desc = '',
		descStyle = 'inline',
		get = function() return KF.db.Modules.EmbedMeter.Omen and KF.db.Modules.EmbedMeter.Omen.Key..(PanelNumber[KF.db.Modules.EmbedMeter.Omen.Key] > 1 and ''..KF.db.Modules.EmbedMeter.Omen.Direction or '') or '' end,
		set = function(_, value)
			KF.db.Modules.EmbedMeter.Omen = nil
			
			if value ~= '' then
				local Key, Direction = strsplit('', value)
				Direction = Direction or 'LEFT'
				
				local IsDuplicated, AnotherDB = CheckDuplication(Key, Direction)
				
				if IsDuplicated then
					if AnotherDB and AnotherDB ~= 'Omen' then
						if type(IsDuplicated) == 'string' then
							KF.db.Modules.EmbedMeter[IsDuplicated] = nil
						else
							KF.db.Modules.EmbedMeter.Skada[IsDuplicated] = nil
						end
					else
						if type(IsDuplicated) == 'string' then
							KF.db.Modules.EmbedMeter[IsDuplicated].Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
						else
							KF.db.Modules.EmbedMeter.Skada[IsDuplicated].Direction = Direction == 'LEFT' and 'RIGHT' or 'LEFT'
						end
					end
				end
				
				KF.db.Modules.EmbedMeter.Omen = {
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
		values = function() return GetPanelList(KF.db.Modules.EmbedMeter.Omen and KF.db.Modules.EmbedMeter.Omen.Key or nil) end,
		hidden = function() return KF.db.Modules.EmbedMeter.Enable == false end,
		disabled = function() return KF.db.Enable == false end
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
			for WindowNumber = 1, #Skada:GetWindows() do
				if KF.db.Modules.EmbedMeter.Skada and KF.db.Modules.EmbedMeter.Skada[WindowNumber] and KF.db.Modules.EmbedMeter.Skada[WindowNumber].Key == OldName then
					KF.db.Modules.EmbedMeter.Skada[WindowNumber].Key = NewName
				end
			end
		end
		
		if RecountLoaded and KF.db.Modules.EmbedMeter.Recount and KF.db.Modules.EmbedMeter.Recount.Key == OldName then
			KF.db.Modules.EmbedMeter.Recount.Key = NewName
		end
		
		if OmenLoaded and KF.db.Modules.EmbedMeter.Omen and KF.db.Modules.EmbedMeter.Omen.Key == OldName then
			KF.db.Modules.EmbedMeter.Omen.Key = NewName
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