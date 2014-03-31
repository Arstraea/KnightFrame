local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 5
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Panel - Config Button									>>--
	--------------------------------------------------------------------------------
	local function OnEnter(self)
		self:SetBackdropBorderColor(unpack(E['media'].rgbvaluecolor))
		self.text:SetText('|cffceff00'..self.ButtonTag)
	end
	
	
	local function OnLeave(self)
		self:SetBackdropBorderColor(unpack(E['media'].bordercolor))
		self.text:SetText(self.ButtonTag)
		self.text:SetPoint('CENTER')
	end
	
	
	local function OnMouseDown(self)
		self.text:SetPoint('CENTER', 0, -2)
	end
	
	
	local function OnMouseUp(self)
		self.text:SetPoint('CENTER')
	end
	
	
	
	KF.Button['Config'] = {
		['Text'] = 'C',
		
		['OnEnter'] = function(Button)
			if not KF_OptionPanelHolder then
				CreateFrame('Frame', 'KF_OptionPanelHolder', KF.UIParent):SetFrameStrata('TOOLTIP')
				KF_OptionPanelHolder:SetFrameLevel(7)
				KF_OptionPanelHolder:Size(116, 85)
				KF_OptionPanelHolder:SetTemplate('Default', true)
				KF:TextSetting(KF_OptionPanelHolder, '', { ['FontSize'] = 12, ['FontOutline'] = 'NONE', }, 'TOP', 0, -5)
				
				
				--<< Buttons : Toggle Anchor Mode, Toggle ElvUI Config, Toggle Addon Control Panel >>--
				KF_OptionPanelHolder.Button1 = CreateFrame('Button', nil, KF_OptionPanelHolder)
				KF_OptionPanelHolder.Button1:Size(108, 18)
				KF_OptionPanelHolder.Button1:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KF_OptionPanelHolder.Button1:SetBackdropColor(0.2, 0.2, 0.2, 1)
				KF_OptionPanelHolder.Button1:Point('BOTTOM', KF_OptionPanelHolder, 0, 4)
				KF:TextSetting(KF_OptionPanelHolder.Button1, 'Anchor Toggle', { ['FontSize'] = 12, ['FontOutline'] = 'NONE', })
				
				KF_OptionPanelHolder.Button1.ButtonTag = 'Anchor Toggle'
				KF_OptionPanelHolder.Button1:SetScript('OnEnter', OnEnter)
				KF_OptionPanelHolder.Button1:SetScript('OnLeave', OnLeave)
				KF_OptionPanelHolder.Button1:SetScript('OnMouseDown', OnMouseDown)
				KF_OptionPanelHolder.Button1:SetScript('OnMouseUp', OnMouseUp)
				KF_OptionPanelHolder.Button1:SetScript('OnClick', function() KF_OptionPanelHolder:Hide() E:ToggleConfigMode() Button.text:SetText(KF.Button['Config']['Text']) end)
				
				
				KF_OptionPanelHolder.Button2 = CreateFrame('Button', nil, KF_OptionPanelHolder)
				KF_OptionPanelHolder.Button2:Size(108, 18)
				KF_OptionPanelHolder.Button2:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KF_OptionPanelHolder.Button2:SetBackdropColor(0.2, 0.2, 0.2, 1)
				KF_OptionPanelHolder.Button2:Point('BOTTOM', KF_OptionPanelHolder, 0, 25)
				KF:TextSetting(KF_OptionPanelHolder.Button2, 'Elv UI Config', { ['FontSize'] = 12, ['FontOutline'] = 'NONE', })
				KF_OptionPanelHolder.Button2.ButtonTag = 'Elv UI Config'
				KF_OptionPanelHolder.Button2:SetScript('OnEnter', OnEnter)
				KF_OptionPanelHolder.Button2:SetScript('OnLeave', OnLeave)
				KF_OptionPanelHolder.Button2:SetScript('OnMouseDown', OnMouseDown)
				KF_OptionPanelHolder.Button2:SetScript('OnMouseUp', OnMouseUp)
				KF_OptionPanelHolder.Button2:SetScript('OnClick', function() KF_OptionPanelHolder:Hide() E:ToggleConfig() Button.text:SetText(KF.Button['Config']['Text']) end)
				
				
				KF_OptionPanelHolder.Button3 = CreateFrame('Button', nil, KF_OptionPanelHolder)
				KF_OptionPanelHolder.Button3:Size(108, 18)
				KF_OptionPanelHolder.Button3:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KF_OptionPanelHolder.Button3:SetBackdropColor(0.2, 0.2, 0.2, 1)
				KF_OptionPanelHolder.Button3:Point('BOTTOM', KF_OptionPanelHolder, 0, 46)
				KF:TextSetting(KF_OptionPanelHolder.Button3, 'ACP', { ['FontSize'] = 12, ['FontOutline'] = 'NONE', })
				KF_OptionPanelHolder.Button3.ButtonTag = 'ACP'
				
				if not IsAddOnLoaded('ACP') then
					KF_OptionPanelHolder.Button3.text:SetText('|cff828282ACP')
					KF_OptionPanelHolder.Button3:SetScript('OnLeave', function(self) self:SetBackdropBorderColor(unpack(E['media'].bordercolor)) GameTooltip:Hide() self.text:SetPoint('CENTER') end)
					KF_OptionPanelHolder.Button3:SetScript('OnEnter', function(self)
						self:SetBackdropBorderColor(unpack(E['media'].rgbvaluecolor))
						GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
						GameTooltip:SetFrameLevel(8)
						GameTooltip:ClearLines()
						
						if select(6, GetAddOnInfo('ACP')) ~= 'MISSING' then
							GameTooltip:AddLine(KF:Color_Value('ACP')..' is |cffb9062fnot loaded|r.|n'..KF:Color_Value('->')..' |cff6dd66dCLICK|r : Load AddOn.', 1, 1, 1)
							KF_OptionPanelHolder.Button3:SetScript('OnClick', function() GameTooltip:Hide() EnableAddOn('ACP') if InCombatLockdown() then E:StaticPopup_Show('CONFIG_RL') else ReloadUI() end end)
						else
							GameTooltip:AddLine(KF:Color_Value('ACP')..' is |cffb9062fnot installed!!!|r :(', 1, 1, 1)
						end
						
						GameTooltip:Show()
					end)
				else
					KF_OptionPanelHolder.Button3:SetScript('OnEnter', OnEnter)
					KF_OptionPanelHolder.Button3:SetScript('OnLeave', OnLeave)
					KF_OptionPanelHolder.Button3:SetScript('OnMouseDown', OnMouseDown)
					KF_OptionPanelHolder.Button3:SetScript('OnMouseUp', OnMouseUp)
					KF_OptionPanelHolder.Button3:SetScript('OnClick', function() KF_OptionPanelHolder:Hide() ToggleFrame(ACP_AddonList) Button.text:SetText(KF.Button['Config']['Text']) end)
				end
			else
				KF_OptionPanelHolder:Show()
			end
			
			KF_OptionPanelHolder:Point('BOTTOMRIGHT', Button, 'TOPRIGHT', 0, 2)
			KF_OptionPanelHolder.text:SetText('< '..KF:Color_Value('Elv Options')..' >')
			KF_OptionPanelHolder.Button1:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			KF_OptionPanelHolder.Button2:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			KF_OptionPanelHolder.Button3:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			Button.text:SetText(KF:Color_Value(KF.Button['Config']['Text']))
			
			KF.Button['AreaToHide']['TOP']:Point('BOTTOM', KF_OptionPanelHolder, 'TOP', 0, 2)
			KF.Button['AreaToHide']['TOP']:SetParent(KF_OptionPanelHolder)
			KF.Button['AreaToHide']['BOTTOM']:Point('TOP', Button, 'BOTTOM', 0, -2)
			KF.Button['AreaToHide']['BOTTOM']:SetParent(KF_OptionPanelHolder)
			KF.Button['AreaToHide']['LEFT']:Point('RIGHT', KF_OptionPanelHolder, 'LEFT', -2, 0)
			KF.Button['AreaToHide']['LEFT']:SetParent(KF_OptionPanelHolder)
			KF.Button['AreaToHide']['RIGHT']:Point('LEFT', KF_OptionPanelHolder, 'RIGHT', 2, 0)
			KF.Button['AreaToHide']['RIGHT']:SetParent(KF_OptionPanelHolder)
			KF.Button['AreaToHide']['Function'] = function()
				KF_OptionPanelHolder:Hide()
				Button.text:SetText(KF.Button['Config']['Text'])
			end
		end,
		
		['OnClick'] = function(Button, pressedButton)
			KF_OptionPanelHolder:Hide()
			E:ToggleConfigMode()
			Button.text:SetText(KF.Button['Config']['Text'])
		end,
	}
end