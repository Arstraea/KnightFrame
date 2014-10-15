-- Last Code Checking Date		: 2014. 6. 16
-- Last Code Checking Version	: 3.0_02
-- Last Testing ElvUI Version	: 6.9997

local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Panel - Config Button									>>--
--------------------------------------------------------------------------------
local function OnEnter(self)
	self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	self.text:SetText('|cffceff00'..self.ButtonTag)
end


local function OnLeave(self)
	self:SetBackdropBorderColor(unpack(E.media.bordercolor))
	self.text:SetText(self.ButtonTag)
end


local function OnMouseDown(self)
	self.text:SetPoint('CENTER', 0, -2)
end


local function OnMouseUp(self)
	self.text:SetPoint('CENTER')
end


KF.UIParent.Button.Config = {
	Text = 'C',
	
	OnEnter = function(Button)
		if not KF_OptionPanelHolder then
			CreateFrame('Frame', 'KF_OptionPanelHolder', KF.UIParent):SetFrameStrata('TOOLTIP')
			KF_OptionPanelHolder:SetFrameLevel(7)
			KF_OptionPanelHolder:Size(116, 85)
			KF_OptionPanelHolder:SetTemplate('Default', true)
			KF:TextSetting(KF_OptionPanelHolder, '', { FontSize = 12, FontOutline = 'NONE' }, 'TOP', 0, -5)
			
			
			--<< Buttons : Toggle Anchor Mode, Toggle ElvUI Config, Toggle Addon Control Panel >>--
			KF_OptionPanelHolder.Button1 = CreateFrame('Button', nil, KF_OptionPanelHolder)
			KF_OptionPanelHolder.Button1:Size(108, 18)
			KF_OptionPanelHolder.Button1:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KF_OptionPanelHolder.Button1:SetBackdropColor(0.2, 0.2, 0.2, 1)
			KF_OptionPanelHolder.Button1:Point('BOTTOM', KF_OptionPanelHolder, 0, 4)
			KF:TextSetting(KF_OptionPanelHolder.Button1, 'Anchor Toggle', { FontSize = 12, FontOutline = 'NONE' })
			
			KF_OptionPanelHolder.Button1.ButtonTag = 'Anchor Toggle'
			KF_OptionPanelHolder.Button1:SetScript('OnEnter', OnEnter)
			KF_OptionPanelHolder.Button1:SetScript('OnLeave', OnLeave)
			KF_OptionPanelHolder.Button1:SetScript('OnMouseDown', OnMouseDown)
			KF_OptionPanelHolder.Button1:SetScript('OnMouseUp', OnMouseUp)
			KF_OptionPanelHolder.Button1:SetScript('OnClick', function() KF_OptionPanelHolder:Hide() E:ToggleConfigMode() Button.text:SetText(KF.UIParent.Button.Config.Text) end)
			
			
			KF_OptionPanelHolder.Button2 = CreateFrame('Button', nil, KF_OptionPanelHolder)
			KF_OptionPanelHolder.Button2:Size(108, 18)
			KF_OptionPanelHolder.Button2:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KF_OptionPanelHolder.Button2:SetBackdropColor(0.2, 0.2, 0.2, 1)
			KF_OptionPanelHolder.Button2:Point('BOTTOM', KF_OptionPanelHolder, 0, 25)
			KF:TextSetting(KF_OptionPanelHolder.Button2, 'Elv UI Config', { FontSize = 12, FontOutline = 'NONE' })
			KF_OptionPanelHolder.Button2.ButtonTag = 'Elv UI Config'
			KF_OptionPanelHolder.Button2:SetScript('OnEnter', OnEnter)
			KF_OptionPanelHolder.Button2:SetScript('OnLeave', OnLeave)
			KF_OptionPanelHolder.Button2:SetScript('OnMouseDown', OnMouseDown)
			KF_OptionPanelHolder.Button2:SetScript('OnMouseUp', OnMouseUp)
			KF_OptionPanelHolder.Button2:SetScript('OnClick', function() KF_OptionPanelHolder:Hide() E:ToggleConfig() Button.text:SetText(KF.UIParent.Button.Config.Text) end)
			
			
			KF_OptionPanelHolder.Button3 = CreateFrame('Button', nil, KF_OptionPanelHolder)
			KF_OptionPanelHolder.Button3:Size(108, 18)
			KF_OptionPanelHolder.Button3:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KF_OptionPanelHolder.Button3:SetBackdropColor(0.2, 0.2, 0.2, 1)
			KF_OptionPanelHolder.Button3:Point('BOTTOM', KF_OptionPanelHolder, 0, 46)
			KF:TextSetting(KF_OptionPanelHolder.Button3, ADDONS, { FontSize = 12, FontOutline = 'NONE' })
			KF_OptionPanelHolder.Button3.ButtonTag = ADDONS
			KF_OptionPanelHolder.Button3:SetScript('OnEnter', OnEnter)
			KF_OptionPanelHolder.Button3:SetScript('OnLeave', OnLeave)
			KF_OptionPanelHolder.Button3:SetScript('OnMouseDown', OnMouseDown)
			KF_OptionPanelHolder.Button3:SetScript('OnMouseUp', OnMouseUp)
			KF_OptionPanelHolder.Button3:SetScript('OnClick', function()
				KF_OptionPanelHolder:Hide()
				
				if AddonList:IsShown() then
					AddonList_Hide()
				else
					AddonList_Show()
				end
				
				Button.text:SetText(KF.UIParent.Button.Config.Text)
			end)
		else
			KF_OptionPanelHolder:Show()
		end
		
		KF_OptionPanelHolder:Point('BOTTOMRIGHT', Button, 'TOPRIGHT', 0, 2)
		KF_OptionPanelHolder.text:SetText('< '..KF:Color_Value('Elv Options')..' >')
		KF_OptionPanelHolder.Button1:SetBackdropBorderColor(unpack(E.media.bordercolor))
		KF_OptionPanelHolder.Button2:SetBackdropBorderColor(unpack(E.media.bordercolor))
		KF_OptionPanelHolder.Button3:SetBackdropBorderColor(unpack(E.media.bordercolor))
		Button.text:SetText(KF:Color_Value(KF.UIParent.Button.Config.Text))
		
		KF.UIParent.Button.AreaToHide.TOP:Point('BOTTOM', KF_OptionPanelHolder, 'TOP', 0, 2)
		KF.UIParent.Button.AreaToHide.TOP:SetParent(KF_OptionPanelHolder)
		KF.UIParent.Button.AreaToHide.BOTTOM:Point('TOP', Button, 'BOTTOM', 0, -2)
		KF.UIParent.Button.AreaToHide.BOTTOM:SetParent(KF_OptionPanelHolder)
		KF.UIParent.Button.AreaToHide.LEFT:Point('RIGHT', KF_OptionPanelHolder, 'LEFT', -2, 0)
		KF.UIParent.Button.AreaToHide.LEFT:SetParent(KF_OptionPanelHolder)
		KF.UIParent.Button.AreaToHide.RIGHT:Point('LEFT', KF_OptionPanelHolder, 'RIGHT', 2, 0)
		KF.UIParent.Button.AreaToHide.RIGHT:SetParent(KF_OptionPanelHolder)
		KF.UIParent.Button.AreaToHide.Function = function()
			KF_OptionPanelHolder:Hide()
			Button.text:SetText(KF.UIParent.Button.Config.Text)
		end
	end,
	
	OnClick = function(Button, pressedButton)
		KF_OptionPanelHolder:Hide()
		E:ToggleConfigMode()
		Button.text:SetText(KF.UIParent.Button.Config.Text)
	end
}