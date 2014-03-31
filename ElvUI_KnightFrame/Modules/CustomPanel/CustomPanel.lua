local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 20
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.99

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Create Panel, Button										>>--
	--------------------------------------------------------------------------------
	KF.Frame = {}
	KF.Button = { ['AreaToHide'] = {}, }
	
	local PANEL_HEIGHT = 22
	local SIDE_BUTTON_WIDTH = 16
	local SPACING = E.PixelMode and 3 or 5
	
	local DeletedFrame = {}
	local DeletedButton = {}
	local frameCount = 0
	
	
	function KF:Create_CustomPanel(panelName, PanelInfo)
		if panelName and not PanelInfo then
			PanelInfo = KF.db.Modules.CustomPanel[panelName]
		end
		
		if KF.db.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false then
			KF:Delete_CustomPanel(panelName, true)
			return
		end
		
		local frame = KF.Frame[panelName]
		
		-- Recycle frame if there is a deleted frame
		if not frame then
			if #DeletedFrame > 0 then
				KF.Frame[panelName] = DeletedFrame[#DeletedFrame]
				
				frame = KF.Frame[panelName]
				
				local moverData = frame.MoverData
				E.CreatedMovers[frame.mover.name] = moverData
				frame.MoverData = nil
				E.CreatedMovers[frame.mover.name].point = E:HasMoverBeenMoved(panelName) and E.db.movers[panelName] or PanelInfo.Location or 'CENTERElvUIParent'
				
				frame.mover:ClearAllPoints()
				frame.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[frame.mover.name].point)}))
				
				frame:Show()
				
				DeletedFrame[#DeletedFrame] = nil
			else
				local f = CreateFrame('Frame', nil, KF.UIParent)
				f:CreateBackdrop('Transparent')
				f.backdrop:SetAllPoints()
				
				f.Texture = f:CreateTexture(nil, 'OVERLAY')
				f.Texture:SetInside()
				
				f.Tab = CreateFrame('Frame', nil, f)
				f.Tab:Point('TOPLEFT', f, SPACING, -SPACING)
				f.Tab:Point('BOTTOMRIGHT', f, 'TOPRIGHT', -SPACING, -(SPACING + PANEL_HEIGHT))
				
				f.DP = CreateFrame('Frame', nil, f)
				f.DP:Point('TOPLEFT', f, 'BOTTOMLEFT', SPACING, SPACING + PANEL_HEIGHT)
				f.DP:Point('BOTTOMRIGHT', f, -SPACING, SPACING)
				
				frameCount = frameCount + 1
				
				f.Count = frameCount
				KF.Frame[panelName] = f
				
				frame = KF.Frame[panelName]
			end
		end
		
		
		-- Parent
		frame:SetParent(PanelInfo.HideWhenPetBattle and KF.UIParent or E.UIParent)
		frame:SetFrameStrata('BACKGROUND')
		frame:SetFrameLevel(2)
		
		-- Size
		frame:Size(PanelInfo.Width, PanelInfo.Height)
		
		-- Backdrop
		if PanelInfo.panelBackdrop then
			frame.backdrop:Show()
		else
			frame.backdrop:Hide()
		end
		
		
		-- Clear All Buttons before each panel's button setting
		KF:ClearAllCustomPanelButtons(frame)
		
		-- Tab panel and button setting
		if PanelInfo.Tab.Enable then
			frame.Tab:Show()
			frame.Tab:SetTemplate(PanelInfo.Tab.Transparency == true and 'Transparent' or 'Default', true)
			frame.Tab:Point('TOPLEFT', frame, SPACING + (#PanelInfo.Tab.ButtonLeft * SIDE_BUTTON_WIDTH), -SPACING)
			frame.Tab:Point('BOTTOMRIGHT', frame, 'TOPRIGHT', -(SPACING + (#PanelInfo.Tab.ButtonRight * SIDE_BUTTON_WIDTH)), -(SPACING + PANEL_HEIGHT))
			
			if #PanelInfo.Tab.ButtonLeft > 0 then
				for i = 1, #PanelInfo.Tab.ButtonLeft do
					frame.Button.Tab_Left = frame.Button.Tab_Left or {}
					frame.Button.Tab_Left[i] = KF:Create_CustomPanelButton(frame.Button.Tab_Left[i], PanelInfo.Tab.ButtonLeft[i], PanelInfo.Tab.Transparency)
					frame.Button.Tab_Left[i]:SetParent(frame)
					frame.Button.Tab_Left[i]:Point('TOPLEFT', frame, SPACING + ((i - 1) * SIDE_BUTTON_WIDTH), -SPACING)
				end
			end
			
			if #PanelInfo.Tab.ButtonRight > 0 then
				for i = 1, #PanelInfo.Tab.ButtonRight do
					frame.Button.Tab_Right = frame.Button.Tab_Right or {}
					frame.Button.Tab_Right[i] = KF:Create_CustomPanelButton(frame.Button.Tab_Right[i], PanelInfo.Tab.ButtonRight[i], PanelInfo.Tab.Transparency)
					frame.Button.Tab_Right[i]:SetParent(frame)
					frame.Button.Tab_Right[i]:Point('TOPRIGHT', frame, -(SPACING + ((i - 1) * SIDE_BUTTON_WIDTH)), -SPACING)
				end
			end
		else
			frame.Tab:Hide()
		end
		
		-- Data Panel and button setting
		if PanelInfo.DP.Enable then
			frame.DP:Show()
			frame.DP:SetTemplate(PanelInfo.DP.Transparency == true and 'Transparent' or 'Default', true)
			frame.DP:Point('TOPLEFT', frame, 'BOTTOMLEFT', SPACING + (#PanelInfo.DP.ButtonLeft * SIDE_BUTTON_WIDTH), SPACING + PANEL_HEIGHT)
			frame.DP:Point('BOTTOMRIGHT', frame, -(SPACING + (#PanelInfo.DP.ButtonRight * SIDE_BUTTON_WIDTH)), SPACING)
			
			if #PanelInfo.DP.ButtonLeft > 0 then
				for i = 1, #PanelInfo.DP.ButtonLeft do
					frame.Button.DP_Left = frame.Button.DP_Left or {}
					frame.Button.DP_Left[i] = KF:Create_CustomPanelButton(frame.Button.DP_Left[i], PanelInfo.DP.ButtonLeft[i], PanelInfo.DP.Transparency)
					frame.Button.DP_Left[i]:SetParent(frame)
					frame.Button.DP_Left[i]:Point('BOTTOMLEFT', frame, SPACING + ((i - 1) * SIDE_BUTTON_WIDTH), SPACING)
				end
			end
			
			if #PanelInfo.DP.ButtonRight > 0 then
				for i = 1, #PanelInfo.DP.ButtonRight do
					frame.Button.DP_Right = frame.Button.DP_Right or {}
					frame.Button.DP_Right[i] = KF:Create_CustomPanelButton(frame.Button.DP_Right[i], PanelInfo.DP.ButtonRight[i], PanelInfo.DP.Transparency)
					frame.Button.DP_Right[i]:SetParent(frame)
					frame.Button.DP_Right[i]:Point('BOTTOMRIGHT', frame, -(SPACING + ((i - 1) * SIDE_BUTTON_WIDTH)), SPACING)
				end
			end
		else
			frame.DP:Hide()
		end
		
		
		-- Texture
		if PanelInfo.Texture.Enable then
			frame.Texture:Show()
			frame.Texture:SetTexture(PanelInfo.Texture.Path)
			frame.Texture:SetAlpha(PanelInfo.Texture.Alpha)
		else
			frame.Texture:Hide()
		end
		
		
		-- Create Mover after frame locating
		if not frame.mover then
			if PanelInfo.Location then
				frame:SetPoint(unpack({string.split('\031', PanelInfo.Location)}))
				--PanelInfo['Location'] = nil
			else
				frame:Point('CENTER')
			end
			
			E:CreateMover(frame, 'KF_Panel_'..frame.Count, L['FrameTag']..(PanelInfo.Name or panelName)..(KF.db.Modules.CustomPanel[panelName] and '' or '|n|n|cffff5675'..L['CAUTION']..' : '..L['NOT SAVED!!']), nil, nil, nil, 'ALL,KF')
			
			if E:HasMoverBeenMoved(panelName) then
				frame.mover:ClearAllPoints()
				frame.mover:SetPoint(unpack({string.split('\031', E.db.movers[panelName])}))
				E.CreatedMovers['KF_Panel_'..frame.Count].point = E.db.movers[panelName]
			end
		else
			-- Update Mover's Tag
			frame.mover.text:SetText(L['FrameTag']..(PanelInfo.Name or panelName)..(KF.db.Modules.CustomPanel[panelName] and '' or '|n|n|cffff5675'..L['CAUTION']..' : '..L['NOT SAVED!!']))
		end
		
		
		if E.ConfigurationMode then
			frame.mover:Show()
		end
	end
	
	
	function KF:Delete_CustomPanel(panelName, SaveProfile)
		local frame = KF.Frame[panelName]
		
		if frame then
			frame:Hide()
			frame.mover:Hide()
			
			KF:ClearAllCustomPanelButtons(frame)
			
			local moverData = E.CreatedMovers[frame.mover.name]
			frame.MoverData = moverData
			E.CreatedMovers[frame.mover.name] = nil
			
			if SaveProfile then
				E:SaveMoverPosition(frame.mover.name)
				E.db.movers[panelName] = E.db.movers[frame.mover.name]
			else
				E.db.movers[panelName] = nil
			end
			E.db.movers[frame.mover.name] = nil
			
			DeletedFrame[#DeletedFrame + 1] = KF.Frame[panelName]
			KF.Frame[panelName] = nil
		end
	end
	
	
	do --<< Area To Hiding button's optionpanel >>--
		local function HideArea()
			if KF.Button.AreaToHide.Function then
				KF.Button.AreaToHide.Function()
			end
		end
		
		KF.Button.AreaToHide.TOP = CreateFrame('Frame')
		KF.Button.AreaToHide.TOP:SetFrameStrata('TOOLTIP')
		KF.Button.AreaToHide.TOP:Point('TOPLEFT', KF.UIParent)
		KF.Button.AreaToHide.TOP:Point('TOPRIGHT', KF.UIParent)
		KF.Button.AreaToHide.TOP:SetScript('OnEnter', HideArea)
		
		KF.Button.AreaToHide.BOTTOM = CreateFrame('Frame')
		KF.Button.AreaToHide.BOTTOM:SetFrameStrata('TOOLTIP')
		KF.Button.AreaToHide.BOTTOM:Point('BOTTOMLEFT', KF.UIParent)
		KF.Button.AreaToHide.BOTTOM:Point('BOTTOMRIGHT', KF.UIParent)
		KF.Button.AreaToHide.BOTTOM:SetScript('OnEnter', HideArea)
		
		KF.Button.AreaToHide.LEFT = CreateFrame('Frame')
		KF.Button.AreaToHide.LEFT:SetFrameStrata('TOOLTIP')
		KF.Button.AreaToHide.LEFT:Point('TOP', KF.Button.AreaToHide.TOP, 'BOTTOM')
		KF.Button.AreaToHide.LEFT:Point('BOTTOM', KF.Button.AreaToHide.BOTTOM, 'TOP')
		KF.Button.AreaToHide.LEFT:Point('LEFT', KF.UIParent)
		KF.Button.AreaToHide.LEFT:SetScript('OnEnter', HideArea)
		
		KF.Button.AreaToHide.RIGHT = CreateFrame('Frame')
		KF.Button.AreaToHide.RIGHT:SetFrameStrata('TOOLTIP')
		KF.Button.AreaToHide.RIGHT:Point('TOP', KF.Button.AreaToHide.TOP, 'BOTTOM')
		KF.Button.AreaToHide.RIGHT:Point('BOTTOM', KF.Button.AreaToHide.BOTTOM, 'TOP')
		KF.Button.AreaToHide.RIGHT:Point('RIGHT', KF.UIParent)
		KF.Button.AreaToHide.RIGHT:SetScript('OnEnter', HideArea)
	end
	
	
	function KF:Create_CustomPanelButton(ButtonFrame, buttonType, buttonTransparency)
		if not buttonType then return end
		
		local button
		
		if not ButtonFrame then
			if #DeletedButton > 0 then
				button = DeletedButton[#DeletedButton]
				DeletedButton[#DeletedButton] = nil
			else
				button = CreateFrame('Button', nil, KF.UIParent)
				button:Size(SIDE_BUTTON_WIDTH, PANEL_HEIGHT)
				KF:TextSetting(button, nil, { ['Font'] = 'Meat Edition Font', ['FontOutline'] = 'OUTLINE', }, 'CENTER', 0, 0)
				button:RegisterForClicks('AnyUp')
			end
		else
			button = ButtonFrame
		end
		
		button:SetTemplate(buttonTransparency == true and 'Transparent' or 'Default', true)
		button:Show()
		
		local buttonText = KF.Button[buttonType] and KF.Button[buttonType].Text or (IsAddOnLoaded(buttonType) and '' or '|cff828282')..(strsub(buttonType, 1, 1))
		
		button.text:SetText(buttonText or '|cff828282..')
		
		button:SetScript('OnEnter', function(...)
			if not KF.Button[buttonType] or KF.Button[buttonType].OnEnter == 'AddOn_Default' then
				GameTooltip:SetOwner(button, 'ANCHOR_TOP', 0, 2)
				GameTooltip:ClearLines()
				
				if not IsAddOnLoaded(buttonType) then
					if select(6, GetAddOnInfo(buttonType)) ~= 'MISSING' then
						GameTooltip:AddLine(KF:Color_Value(buttonType)..' is |cffb9062fnot loaded|r.|n|n', 1, 1, 1)
						GameTooltip:AddDoubleLine(KF:Color_Value('-')..' |cff6dd66dCLICK|r', 'Load AddOn.', 1, 1, 1, 1, 1, 1)
					else
						GameTooltip:AddLine(KF:Color_Value(buttonType)..' is |cffb9062fnot installed!!!|r :(', 1, 1, 1)
					end
				else
					button.text:SetText(KF:Color_Value(buttonText))
					GameTooltip:AddLine('Open '..KF:Color_Value(buttonType)..' addon.', 1, 1, 1)
				end
				
				GameTooltip:Show()
			elseif KF.Button[buttonType].OnEnter then
				KF.Button[buttonType].OnEnter(...)
			end
		end)
		
		button:SetScript('OnLeave', function(...)
			if not KF.Button[buttonType] or KF.Button[buttonType].OnLeave == 'AddOn_Default' then
				GameTooltip:Hide()
				button.text:SetText(buttonText)
			elseif KF.Button[buttonType].OnLeave then
				KF.Button[buttonType].OnLeave(...)
			end
		end)
		
		button:SetScript('OnMouseDown', function(...)
			if not KF.Button[buttonType] or KF.Button[buttonType].OnMouseDown == 'AddOn_Default' then
				button.text:SetPoint('CENTER', 0, -2)
			elseif KF.Button[buttonType].OnMouseDown then
				KF.Button[buttonType].OnMouseDown(...)
			end
		end)
		
		button:SetScript('OnMouseUp', function(...)
			if not KF.Button[buttonType] or KF.Button[buttonType].OnMouseUp == 'AddOn_Default' then
				button.text:SetPoint('CENTER')
			elseif KF.Button[buttonType].OnMouseUp then
				KF.Button[buttonType].OnMouseUp(...)
			end
		end)
		
		button:SetScript('OnClick', function(...)
			if not IsAddOnLoaded(buttonType) and select(6, GetAddOnInfo(buttonType)) ~= 'MISSING' then
				EnableAddOn(buttonType)
				
				if InCombatLockdown() then
					E:StaticPopup_Show('CONFIG_RL')
				else
					ReloadUI()
				end
			elseif KF.Button[buttonType].OnClick then
				KF.Button[buttonType].OnClick(...)
			end
		end)
		
		if KF.Button[buttonType] and KF.Button[buttonType].Func then
			KF.Button[buttonType].Func()
		end
		
		return button
	end
	
	
	function KF:ClearAllCustomPanelButtons(frame)
		if frame.Button then
			for buttonLocation in pairs(frame.Button) do
				for _, b in pairs(frame.Button[buttonLocation]) do
					b:ClearAllPoints()
					b:SetParent(nil)
					b:Hide()
					DeletedButton[#DeletedButton + 1] = b
				end
			end
		end
		
		frame.Button = {}
	end
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Initialize Custom Panel									>>--
	--------------------------------------------------------------------------------
	KF.Modules[#KF.Modules + 1] = 'CustomPanel'
	KF.Modules['CustomPanel'] = function(RemoveOrder)
		-- Get LDB data for creating button
		KF:CustomPanelButton_RegisterLDB()
		
		-- Update Panel Setting
		for panelName in pairs(KF.Frame) do
			KF:Delete_CustomPanel(panelName, true)
		end
		
		if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.CustomPanel.Enable ~= false then
			for panelName, IsPanelData in pairs(KF.db.Modules.CustomPanel) do
				if type(IsPanelData) == 'table' then
					KF:Create_CustomPanel(panelName)
				end
			end
		end
	end
end