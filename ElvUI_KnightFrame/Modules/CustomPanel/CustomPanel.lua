local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))
local CH = E:GetModule('Chat')

local PANEL_HEIGHT = 22
local SIDE_BUTTON_WIDTH = 16
local SPACING = E.PixelMode and 3 or 5
local frameTag = 'KF_CustomPanel'

--------------------------------------------------------------------------------
--<< KnightFrame : Create Panel, Button										>>--
--------------------------------------------------------------------------------
local FrameLinkByID = {}
local DeletedFrame = {}
local DeletedButton = {}
local frameCount = 0


function KF:CustomPanel_Create(PanelName, PanelInfo)
	PanelInfo = PanelInfo or DB.Modules.CustomPanel[PanelName] or {}
	
	if not (DB.Modules.CustomPanel.Enable and PanelInfo.Enable) then
		KF:CustomPanel_Delete(PanelName, true)
		return
	end
	
	local frame = KF.UIParent.Frame[PanelName]
	
	-- Recycle frame if there is a deleted frame
	if not frame then
		if #DeletedFrame > 0 then
			KF.UIParent.Frame[PanelName] = DeletedFrame[#DeletedFrame]
			
			frame = KF.UIParent.Frame[PanelName]
			
			local moverData = frame.MoverData
			E.CreatedMovers[frame.mover.name] = moverData
			frame.MoverData = nil
			E.CreatedMovers[frame.mover.name].point = E:HasMoverBeenMoved(PanelName) and E.db.movers[PanelName] or PanelInfo.Location or 'CENTERElvUIParent'
			
			frame.mover:ClearAllPoints()
			frame.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[frame.mover.name].point)}))
			
			frame:Show()
			
			DeletedFrame[#DeletedFrame] = nil
		else
			frameCount = frameCount + 1
			
			local f = CreateFrame('Frame', frameTag..'_'..frameCount, KF.UIParent)
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
			
			f.Count = frameCount
			KF.UIParent.Frame[PanelName] = f
			
			frame = KF.UIParent.Frame[PanelName]
		end
		
		FrameLinkByID[frame.Count] = PanelName
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
	KF:CustomPanel_Button_ClearAll(frame)
	
	-- Tab panel and button setting
	if PanelInfo.Tab.Enable then
		frame.Tab:Show()
		frame.Tab:SetTemplate(PanelInfo.Tab.Transparency == true and 'Transparent' or 'Default', true)
		frame.Tab:Point('TOPLEFT', frame, SPACING + (#PanelInfo.Tab.ButtonLeft * SIDE_BUTTON_WIDTH), -SPACING)
		frame.Tab:Point('BOTTOMRIGHT', frame, 'TOPRIGHT', -(SPACING + (#PanelInfo.Tab.ButtonRight * SIDE_BUTTON_WIDTH)), -(SPACING + PANEL_HEIGHT))
		
		if #PanelInfo.Tab.ButtonLeft > 0 then
			for i = 1, #PanelInfo.Tab.ButtonLeft do
				frame.Button.Tab_Left = frame.Button.Tab_Left or {}
				frame.Button.Tab_Left[i] = KF:CustomPanel_Button_Create(frame.Button.Tab_Left[i], PanelInfo.Tab.ButtonLeft[i], PanelInfo.Tab.Transparency)
				frame.Button.Tab_Left[i]:SetParent(frame)
				frame.Button.Tab_Left[i]:Point('TOPLEFT', frame, SPACING + ((i - 1) * SIDE_BUTTON_WIDTH), -SPACING)
			end
		end
		
		if #PanelInfo.Tab.ButtonRight > 0 then
			for i = 1, #PanelInfo.Tab.ButtonRight do
				frame.Button.Tab_Right = frame.Button.Tab_Right or {}
				frame.Button.Tab_Right[i] = KF:CustomPanel_Button_Create(frame.Button.Tab_Right[i], PanelInfo.Tab.ButtonRight[i], PanelInfo.Tab.Transparency)
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
				frame.Button.DP_Left[i] = KF:CustomPanel_Button_Create(frame.Button.DP_Left[i], PanelInfo.DP.ButtonLeft[i], PanelInfo.DP.Transparency)
				frame.Button.DP_Left[i]:SetParent(frame)
				frame.Button.DP_Left[i]:Point('BOTTOMLEFT', frame, SPACING + ((i - 1) * SIDE_BUTTON_WIDTH), SPACING)
			end
		end
		
		if #PanelInfo.DP.ButtonRight > 0 then
			for i = 1, #PanelInfo.DP.ButtonRight do
				frame.Button.DP_Right = frame.Button.DP_Right or {}
				frame.Button.DP_Right[i] = KF:CustomPanel_Button_Create(frame.Button.DP_Right[i], PanelInfo.DP.ButtonRight[i], PanelInfo.DP.Transparency)
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
		
		E:CreateMover(frame, frameTag..'_'..frame.Count..'_Mover', L['FrameTag']..(PanelInfo.Name or PanelName)..(DB.Modules.CustomPanel[PanelName] and '' or '|n|n|cffff5675'..L['CAUTION']..' : '..L['NOT SAVED!!']), nil, nil, nil, 'ALL,KF')
		
		if E:HasMoverBeenMoved(PanelName) then
			frame.mover:ClearAllPoints()
			frame.mover:SetPoint(unpack({string.split('\031', E.db.movers[PanelName])}))
			E.CreatedMovers[frameTag..'_'..frame.Count..'_Mover'].point = E.db.movers[PanelName]
		end
	else
		-- Update Mover's Tag
		frame.mover.text:SetText(L['FrameTag']..(PanelInfo.Name or PanelName)..(DB.Modules.CustomPanel[PanelName] and '' or '|n|n|cffff5675'..L['CAUTION']..' : '..L['NOT SAVED!!']))
	end
	
	
	if E.ConfigurationMode then
		frame.mover:Show()
	end
end


function KF:CustomPanel_Delete(PanelName, SaveProfile)
	local frame = KF.UIParent.Frame[PanelName]
	
	if frame then
		frame:Hide()
		frame.mover:Hide()
		
		KF:CustomPanel_Button_ClearAll(frame)
		
		local moverData = E.CreatedMovers[frame.mover.name]
		frame.MoverData = moverData
		E.CreatedMovers[frame.mover.name] = nil
		
		if SaveProfile then
			E:SaveMoverPosition(frame.mover.name)
			E.db.movers[PanelName] = E.db.movers[frame.mover.name]
		else
			E.db.movers[PanelName] = nil
		end
		E.db.movers[frame.mover.name] = nil
		
		DeletedFrame[#DeletedFrame + 1] = KF.UIParent.Frame[PanelName]
		KF.UIParent.Frame[PanelName] = nil
	end
end


do --<< Area To Hiding button's optionpanel >>--
	local function HideArea()
		if KF.UIParent.Button.AreaToHide.Function then
			KF.UIParent.Button.AreaToHide.Function()
		end
	end
	KF.UIParent.Button.AreaToHide = {}
	
	KF.UIParent.Button.AreaToHide.TOP = CreateFrame('Frame')
	KF.UIParent.Button.AreaToHide.TOP:SetFrameStrata('TOOLTIP')
	KF.UIParent.Button.AreaToHide.TOP:Point('TOPLEFT', KF.UIParent)
	KF.UIParent.Button.AreaToHide.TOP:Point('TOPRIGHT', KF.UIParent)
	KF.UIParent.Button.AreaToHide.TOP:SetScript('OnEnter', HideArea)
	
	KF.UIParent.Button.AreaToHide.BOTTOM = CreateFrame('Frame')
	KF.UIParent.Button.AreaToHide.BOTTOM:SetFrameStrata('TOOLTIP')
	KF.UIParent.Button.AreaToHide.BOTTOM:Point('BOTTOMLEFT', KF.UIParent)
	KF.UIParent.Button.AreaToHide.BOTTOM:Point('BOTTOMRIGHT', KF.UIParent)
	KF.UIParent.Button.AreaToHide.BOTTOM:SetScript('OnEnter', HideArea)
	
	KF.UIParent.Button.AreaToHide.LEFT = CreateFrame('Frame')
	KF.UIParent.Button.AreaToHide.LEFT:SetFrameStrata('TOOLTIP')
	KF.UIParent.Button.AreaToHide.LEFT:Point('TOP', KF.UIParent.Button.AreaToHide.TOP, 'BOTTOM')
	KF.UIParent.Button.AreaToHide.LEFT:Point('BOTTOM', KF.UIParent.Button.AreaToHide.BOTTOM, 'TOP')
	KF.UIParent.Button.AreaToHide.LEFT:Point('LEFT', KF.UIParent)
	KF.UIParent.Button.AreaToHide.LEFT:SetScript('OnEnter', HideArea)
	
	KF.UIParent.Button.AreaToHide.RIGHT = CreateFrame('Frame')
	KF.UIParent.Button.AreaToHide.RIGHT:SetFrameStrata('TOOLTIP')
	KF.UIParent.Button.AreaToHide.RIGHT:Point('TOP', KF.UIParent.Button.AreaToHide.TOP, 'BOTTOM')
	KF.UIParent.Button.AreaToHide.RIGHT:Point('BOTTOM', KF.UIParent.Button.AreaToHide.BOTTOM, 'TOP')
	KF.UIParent.Button.AreaToHide.RIGHT:Point('RIGHT', KF.UIParent)
	KF.UIParent.Button.AreaToHide.RIGHT:SetScript('OnEnter', HideArea)
end


function KF:CustomPanel_Button_Create(ButtonFrame, buttonType, buttonTransparency)
	if not buttonType then return end
	
	local button
	
	if not ButtonFrame then
		if #DeletedButton > 0 then
			button = DeletedButton[#DeletedButton]
			DeletedButton[#DeletedButton] = nil
		else
			button = CreateFrame('Button', nil, KF.UIParent)
			button:Size(SIDE_BUTTON_WIDTH, PANEL_HEIGHT)
			KF:TextSetting(button, nil, { Font = 'Meat Edition Font', FontOutline = 'OUTLINE' }, 'CENTER', 0, 0)
			button:RegisterForClicks('AnyUp')
		end
	else
		button = ButtonFrame
	end
	
	button:SetTemplate(buttonTransparency == true and 'Transparent' or 'Default', true)
	button:Show()
	
	local buttonText = KF.UIParent.Button[buttonType] and KF.UIParent.Button[buttonType].Text or (IsAddOnLoaded(buttonType) and '' or '|cff828282')..(strsub(buttonType, 1, 1))
	
	button.text:SetText(buttonText or '|cff828282..')
	
	button:SetScript('OnEnter', function(...)
		if not (KF.UIParent.Button[buttonType] and KF.UIParent.Button[buttonType].OnEnter) then
			GameTooltip:SetOwner(button, 'ANCHOR_TOP', 0, 2)
			GameTooltip:ClearLines()
			
			if not IsAddOnLoaded(buttonType) then
				if select(5, GetAddOnInfo(buttonType)) ~= 'MISSING' then
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
		else
			KF.UIParent.Button[buttonType].OnEnter(...)
		end
	end)
	
	button:SetScript('OnLeave', function(...)
		if not (KF.UIParent.Button[buttonType] and KF.UIParent.Button[buttonType].OnLeave) then
			GameTooltip:Hide()
			button.text:SetText(buttonText)
		else
			KF.UIParent.Button[buttonType].OnLeave(...)
		end
	end)
	
	button:SetScript('OnMouseDown', function(...)
		if not (KF.UIParent.Button[buttonType] and KF.UIParent.Button[buttonType].OnMouseDown) then
			button.text:SetPoint('CENTER', 0, -2)
		else
			KF.UIParent.Button[buttonType].OnMouseDown(...)
		end
	end)
	
	button:SetScript('OnMouseUp', function(...)
		if not (KF.UIParent.Button[buttonType] and KF.UIParent.Button[buttonType].OnMouseUp) then
			button.text:SetPoint('CENTER')
		else
			KF.UIParent.Button[buttonType].OnMouseUp(...)
		end
	end)
	
	button:SetScript('OnClick', function(...)
		if not IsAddOnLoaded(buttonType) and select(5, GetAddOnInfo(buttonType)) ~= 'MISSING' then
			EnableAddOn(buttonType)
			
			if InCombatLockdown() then
				E:StaticPopup_Show('CONFIG_RL')
			else
				ReloadUI()
			end
		elseif KF.UIParent.Button[buttonType] and KF.UIParent.Button[buttonType].OnClick then
			KF.UIParent.Button[buttonType].OnClick(...)
		end
	end)
	
	if KF.UIParent.Button[buttonType] and KF.UIParent.Button[buttonType].Func then
		KF.UIParent.Button[buttonType].Func()
	end
	
	return button
end


function KF:CustomPanel_Button_ClearAll(frame)
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
--<< KnightFrame : ChatFrame Docking										>>--
--------------------------------------------------------------------------------
local MouseOveredPanel, MouseOveredPanelName, DockingLocation, ChatID
--[[
hooksecurefunc('FCFTab_OnUpdate', function(self)
	if Info.CustomPanel_Activate and not self.ForbidDockingToCustomPanel then
		if MouseOveredPanel and not MouseOveredPanel:IsMouseOver() then
			MouseOveredPanel = nil
			DockingLocation = nil
		end
		
		if not MouseOveredPanel then
			for PanelName, Panel in pairs(KF.UIParent.Frame) do
				if Panel:IsMouseOver() then
					MouseOveredPanel = Panel
					MouseOveredPanelName = PanelName
					break
				end
			end
		end
		
		ChatID = self:GetID()
		
		if IsMouseButtonDown(self.dragButton) then
			if not MouseOveredPanel then
				for PanelName, Panel in pairs(KF.UIParent.Frame) do
					if Panel:IsMouseOver() then
						MouseOveredPanel = Panel
						MouseOveredPanelName = PanelName
						break
					end
				end
			elseif not MouseOveredPanel:IsMouseOver() then
				MouseOveredPanel = nil
			else
				--하이라이트 처리 넣고싶으면 여기에.... 
			end
		else
			if MouseOveredPanel then
				if DB.Modules.CustomPanel[MouseOveredPanelName] then
					for i = 1, #DB.Modules.CustomPanel[MouseOveredPanelName].Chat do
						if DB.Modules.CustomPanel[MouseOveredPanelName].Chat[i] == ChatID then
							tremove(DB.Modules.CustomPanel[MouseOveredPanelName].Chat, i)
						end
					end
					
					tinsert(DB.Modules.CustomPanel[MouseOveredPanelName].Chat, ChatID)
				end
				
				KF:DockingChatFrameToCustomPanel(self, MouseOveredPanel, true)
			else
				for panelName, IsPanelData in pairs(DB.Modules.CustomPanel) do
					if type(IsPanelData) == 'table' then
						for i = 1, #IsPanelData.Chat do
							if IsPanelData.Chat[i] == ChatID then
								tremove(IsPanelData.Chat, i)
							end
						end
					end
				end
				
				_G[format('ChatFrame%d', ChatID)]:SetParent(UIParent)
				self:SetParent(UIParent)
				
				CH:SetupChatTabs(self, true)
			end
			
			MouseOveredPanel = nil
		end
	end
end)


function KF:DockingChatFrameToCustomPanel(Tab, Panel, Menual)
	local ID = Tab:GetID()
	local Chat = _G[format('ChatFrame%d', ID)]
	local PanelName = FrameLinkByID[Panel.Count]
	
	CH:SetupChatTabs(Tab, false)
	
	Tab:SetParent(Panel)
	Chat:SetParent(Panel)
	--Chat:SetUserPlaced(false)
	Chat:SetSize(Panel:GetWidth() - SPACING * 2 - 4, Panel:GetHeight() - (PANEL_HEIGHT * 2 + SPACING * 4) - (ID == 2 and CombatLogQuickButtonFrame_Custom:GetHeight() or 0))
	
	Chat:ClearAllPoints()
	Chat:Point('BOTTOMLEFT', Panel, SPACING + 2, PANEL_HEIGHT + SPACING * 2)
	
end
]]




--------------------------------------------------------------------------------
--<< KnightFrame : Initialize Custom Panel									>>--
--------------------------------------------------------------------------------
KF.Modules[#KF.Modules + 1] = 'CustomPanel'
KF.Modules.CustomPanel = function(RemoveOrder)
	-- Get LDB data for creating button
	KF:CustomPanel_Button_RegisterLDB()
	
	-- Update Panel Setting
	for panelName in pairs(KF.UIParent.Frame) do
		KF:CustomPanel_Delete(panelName, true)
	end
	
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.CustomPanel.Enable ~= false then
		Info.CustomPanel_Activate = true
		
		for panelName, IsPanelData in pairs(DB.Modules.CustomPanel) do
			if type(IsPanelData) == 'table' then
				KF:CustomPanel_Create(panelName)
				
				for i = 1, #IsPanelData.Chat do
					--KF:DockingChatFrameToCustomPanel(_G[format('ChatFrame%dTab', IsPanelData.Chat[i])], KF.UIParent.Frame[panelName])
				end
			end
		end
	else
		Info.CustomPanel_Activate = nil
	end
end