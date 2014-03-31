local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 5
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Toolkit		 											>>--
--------------------------------------------------------------------------------
function KF:Color_Value(InputText)
	return E:RGBToHex(E.media.rgbvaluecolor[1], E.media.rgbvaluecolor[2], E.media.rgbvaluecolor[3])..(InputText and InputText..'|r' or '')
end	


function KF:Color_Class(Class, InputText)
	return (Class and '|c'..RAID_CLASS_COLORS[Class].colorStr or '')..(InputText and InputText..'|r' or '')
end


function KF:TextSetting(self, Text, Style, ...)
	if Style and Style.Tag then
		if not self[Style.Tag] then
			self[Style.Tag] = self:CreateFontString(nil, 'OVERLAY')
		end
		
		self = self[Style.Tag]
	else
		if not Style then
			Style = {}
		end
		
		if not self.text then
			self.text = self:CreateFontString(nil, 'OVERLAY')
		end
		
		self = self.text
	end
	
	self:FontTemplate(Style.Font and LibStub('LibSharedMedia-3.0'):Fetch('font', Style.Font), Style.FontSize, Style.FontOutline)
	self:SetJustifyH(Style.directionH or 'CENTER')
	self:SetJustifyV(Style.directionV or 'MIDDLE')
	self:SetText(Text)
	
	if ... then
		self:Point(...)
	else
		self:SetInside()
	end
end


function KF:CreateWidget_CheckButton(buttonName, buttonText, heightSize, fontInfo)
	if not _G[buttonName] then
		heightSize = heightSize or 24
		fontInfo = fontInfo or { ['FontStyle'] = 'OUTLINE', ['directionH'] = 'LEFT', }
		
		CreateFrame('Button', buttonName, KF.UIParent)
		_G[buttonName]:SetHeight(heightSize)
		_G[buttonName]:EnableMouse(true)

		_G[buttonName].CheckButtonBG = CreateFrame('Frame', nil, _G[buttonName])
		_G[buttonName].CheckButtonBG:SetTemplate('Default', true)
		_G[buttonName].CheckButtonBG:Size(heightSize - 8)
		_G[buttonName].CheckButtonBG:SetPoint('LEFT')

		_G[buttonName].CheckButton = _G[buttonName].CheckButtonBG:CreateTexture(nil, 'OVERLAY')
		_G[buttonName].CheckButton:Size(heightSize)
		_G[buttonName].CheckButton:Point('CENTER', _G[buttonName].CheckButtonBG)
		_G[buttonName].CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')

		KF:TextSetting(_G[buttonName], buttonText, fontInfo, 'LEFT', _G[buttonName].CheckButtonBG, 'RIGHT', 6, 0)
		
		_G[buttonName].hover = _G[buttonName]:CreateTexture(nil, 'HIGHLIGHT')
		_G[buttonName].hover:SetTexture('Interface\\Buttons\\UI-CheckBox-Highlight')
		_G[buttonName].hover:SetBlendMode('ADD')
		_G[buttonName].hover:SetAllPoints(_G[buttonName].CheckButtonBG)
		
		_G[buttonName]:SetHighlightTexture(_G[buttonName].hover)
		_G[buttonName]:SetWidth(_G[buttonName].text:GetWidth() + heightSize + 2)
		_G[buttonName]:SetScript('OnMouseDown', function(self) self.text:Point('LEFT', self.CheckButtonBG, 'RIGHT', 6, -2) end)
		_G[buttonName]:SetScript('OnMouseUp', function(self) self.text:Point('LEFT', self.CheckButtonBG, 'RIGHT', 6, 0) end)
		
		return _G[buttonName]
	end
end




if KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Callback		 											>>--
	--------------------------------------------------------------------------------
	KF.Callback = {}
	function KF:RegisterCallback(RegisterName, InputFunction, FunctionName)
		KF.Callback[RegisterName] = KF.Callback[RegisterName] or {}
		
		FunctionName = FunctionName or (#KF.Callback[RegisterName] + 1)
		KF.Callback[RegisterName][FunctionName] = InputFunction
	end
	
	
	function KF:UnregisterCallback(RegisterName, FunctionName)
		if not (KF.Callback[RegisterName] and KF.Callback[RegisterName][FunctionName]) then
			return
		else
			KF.Callback[RegisterName][FunctionName] = nil
			
			for _ in pairs(KF.Callback[RegisterName]) do
				return
			end
			
			KF.Callback[RegisterName] = nil
		end
	end
	
	
	function KF:CallbackFire(RegisterName, ...)
		if KF.Callback[RegisterName] then
			for _, RegisteredFunction in pairs(KF.Callback[RegisterName]) do
				RegisteredFunction(RegisterName, ...)
			end
		end
	end
	
	
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Events		 											>>--
	--------------------------------------------------------------------------------
	KF.Event = {}
	function KF:RegisterEventList(EventName, InputFunction, FunctionName)
		if not KF.Event[EventName] then
			KF.Event[EventName] = {}
			
			KF:RegisterEvent(EventName, function(...)
				for _, SavedFunction in pairs(KF.Event[EventName]) do
					SavedFunction(...)
				end
			end)
		end
		
		FunctionName = FunctionName or (#KF.Event[EventName] + 1)
		KF.Event[EventName][FunctionName] = InputFunction
	end


	function KF:UnregisterEventList(EventName, FunctionName)
		if not (KF.Event[EventName] and KF.Event[EventName][FunctionName]) then
			return
		else
			KF.Event[EventName][FunctionName] = nil
			
			for _ in pairs (KF.Event[EventName]) do
				return
			end
			
			-- If there is a remain regist event, this is not worked.
			KF:UnregisterEvent(EventName)
			KF.Event[EventName] = nil
		end
	end
	
	
	
	
	function KF:GetPanelData(key)
		local Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled
		
		if (key == 'LeftChatPanel' and (E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'LEFT') or key == 'RightChatPanel' and (E.db.chat.panelBackdrop == 'SHOWBOTH' or E.db.chat.panelBackdrop == 'RIGHT')) and _G[key] then
			Panel = _G[key]
			panelType = 'ElvUI'
			IsTabEnabled = E.db.chat.panelTabBackdrop
			
			if key == 'LeftChatPanel' then
				panelTab = LeftChatTab
				panelDP = LeftChatDataPanel
				IsDPEnabled = E.db.datatexts.leftChatPanel
			else
				panelTab = RightChatTab
				panelDP = RightChatDataPanel
				IsDPEnabled = E.db.datatexts.rightChatPanel
			end
		elseif KF.Frame[key] and KF.db.Modules.CustomPanel.Enable ~= false and KF.db.Modules.CustomPanel[key] and KF.db.Modules.CustomPanel[key].Enable == true then
			Panel = KF.Frame[key]
			panelType = 'KF'
			panelTab = KF.Frame[key].Tab
			IsTabEnabled = KF.db.Modules.CustomPanel[key].Tab.Enable
			panelDP = KF.Frame[key].DP
			IsDPEnabled = KF.db.Modules.CustomPanel[key].DP.Enable
		end
		
		return Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled
	end
end