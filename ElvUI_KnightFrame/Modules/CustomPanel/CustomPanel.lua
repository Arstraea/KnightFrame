local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))
local CH = E:GetModule('Chat')

local PANEL_HEIGHT = 22
local SIDE_BUTTON_WIDTH = 16
local SPACING = E.PixelMode and 3 or 5
local PanelTag = 'KF_CustomPanel'

--------------------------------------------------------------------------------
--<< KnightFrame : Create Panel, Button										>>--
--------------------------------------------------------------------------------
local FrameLinkByID = {}
local DeletedFrame = {}
local DeletedButton = {}
local FrameCount = 0

KF.UIParent.Panel = {}
KF.UIParent.Button = {}

function KF:CustomPanel_Create(PanelName, PanelInfo)
	PanelInfo = PanelInfo or DB.Modules.CustomPanel[PanelName] or {}
	
	if not (DB.Modules.CustomPanel.Enable and PanelInfo.Enable) then
		KF:CustomPanel_Delete(PanelName, true)
		return
	end
	
	local Panel = KF.UIParent.Panel[PanelName]
	
	-- Recycle Panel if there is a deleted Panel
	if not Panel then
		if #DeletedFrame > 0 then
			KF.UIParent.Panel[PanelName] = DeletedFrame[#DeletedFrame]
			
			Panel = KF.UIParent.Panel[PanelName]
			
			local moverData = Panel.MoverData
			E.CreatedMovers[Panel.mover.name] = moverData
			Panel.MoverData = nil
			E.CreatedMovers[Panel.mover.name].point = E:HasMoverBeenMoved(PanelName) and E.db.movers[PanelName] or PanelInfo.Location or 'CENTERElvUIParent'
			
			Panel.mover:ClearAllPoints()
			Panel.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Panel.mover.name].point)}))
			
			Panel:Show()
			
			DeletedFrame[#DeletedFrame] = nil
		else
			FrameCount = FrameCount + 1
			
			local f = CreateFrame('Frame', PanelTag..'_'..FrameCount, KF.UIParent)
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
			
			f.Count = FrameCount
			KF.UIParent.Panel[PanelName] = f
			
			Panel = KF.UIParent.Panel[PanelName]
		end
		
		FrameLinkByID[Panel.Count] = PanelName
	end
	
	
	-- Parent
	Panel:SetParent(PanelInfo.HideWhenPetBattle and KF.UIParent or E.UIParent)
	Panel:SetFrameStrata('BACKGROUND')
	Panel:SetFrameLevel(2)
	
	-- Size
	Panel:Size(PanelInfo.Width, PanelInfo.Height)
	
	-- Backdrop
	if PanelInfo.panelBackdrop then
		Panel.backdrop:Show()
	else
		Panel.backdrop:Hide()
	end
	
	
	-- Clear All Buttons before each panel's button setting
	KF:CustomPanel_Button_ClearAll(Panel)
	
	-- Tab panel and button setting
	if PanelInfo.Tab.Enable then
		Panel.Tab:Show()
		Panel.Tab:SetTemplate(PanelInfo.Tab.Transparency == true and 'Transparent' or 'Default', true)
		Panel.Tab:Point('TOPLEFT', Panel, SPACING + (#PanelInfo.Tab.ButtonLeft * SIDE_BUTTON_WIDTH), -SPACING)
		Panel.Tab:Point('BOTTOMRIGHT', Panel, 'TOPRIGHT', -(SPACING + (#PanelInfo.Tab.ButtonRight * SIDE_BUTTON_WIDTH)), -(SPACING + PANEL_HEIGHT))
		
		if #PanelInfo.Tab.ButtonLeft > 0 then
			for i = 1, #PanelInfo.Tab.ButtonLeft do
				Panel.Button.Tab_Left = Panel.Button.Tab_Left or {}
				Panel.Button.Tab_Left[i] = KF:CustomPanel_Button_Create(Panel.Button.Tab_Left[i], PanelInfo.Tab.ButtonLeft[i], PanelInfo.Tab.Transparency)
				Panel.Button.Tab_Left[i]:SetParent(Panel)
				Panel.Button.Tab_Left[i]:Point('TOPLEFT', Panel, SPACING + ((i - 1) * SIDE_BUTTON_WIDTH), -SPACING)
			end
		end
		
		if #PanelInfo.Tab.ButtonRight > 0 then
			for i = 1, #PanelInfo.Tab.ButtonRight do
				Panel.Button.Tab_Right = Panel.Button.Tab_Right or {}
				Panel.Button.Tab_Right[i] = KF:CustomPanel_Button_Create(Panel.Button.Tab_Right[i], PanelInfo.Tab.ButtonRight[i], PanelInfo.Tab.Transparency)
				Panel.Button.Tab_Right[i]:SetParent(Panel)
				Panel.Button.Tab_Right[i]:Point('TOPRIGHT', Panel, -(SPACING + ((i - 1) * SIDE_BUTTON_WIDTH)), -SPACING)
			end
		end
	else
		Panel.Tab:Hide()
	end
	
	-- Data Panel and button setting
	if PanelInfo.DP.Enable then
		Panel.DP:Show()
		Panel.DP:SetTemplate(PanelInfo.DP.Transparency == true and 'Transparent' or 'Default', true)
		Panel.DP:Point('TOPLEFT', Panel, 'BOTTOMLEFT', SPACING + (#PanelInfo.DP.ButtonLeft * SIDE_BUTTON_WIDTH), SPACING + PANEL_HEIGHT)
		Panel.DP:Point('BOTTOMRIGHT', Panel, -(SPACING + (#PanelInfo.DP.ButtonRight * SIDE_BUTTON_WIDTH)), SPACING)
		
		if #PanelInfo.DP.ButtonLeft > 0 then
			for i = 1, #PanelInfo.DP.ButtonLeft do
				Panel.Button.DP_Left = Panel.Button.DP_Left or {}
				Panel.Button.DP_Left[i] = KF:CustomPanel_Button_Create(Panel.Button.DP_Left[i], PanelInfo.DP.ButtonLeft[i], PanelInfo.DP.Transparency)
				Panel.Button.DP_Left[i]:SetParent(Panel)
				Panel.Button.DP_Left[i]:Point('BOTTOMLEFT', Panel, SPACING + ((i - 1) * SIDE_BUTTON_WIDTH), SPACING)
			end
		end
		
		if #PanelInfo.DP.ButtonRight > 0 then
			for i = 1, #PanelInfo.DP.ButtonRight do
				Panel.Button.DP_Right = Panel.Button.DP_Right or {}
				Panel.Button.DP_Right[i] = KF:CustomPanel_Button_Create(Panel.Button.DP_Right[i], PanelInfo.DP.ButtonRight[i], PanelInfo.DP.Transparency)
				Panel.Button.DP_Right[i]:SetParent(Panel)
				Panel.Button.DP_Right[i]:Point('BOTTOMRIGHT', Panel, -(SPACING + ((i - 1) * SIDE_BUTTON_WIDTH)), SPACING)
			end
		end
	else
		Panel.DP:Hide()
	end
	
	
	-- Texture
	if PanelInfo.Texture.Enable then
		Panel.Texture:Show()
		Panel.Texture:SetTexture(PanelInfo.Texture.Path)
		Panel.Texture:SetAlpha(PanelInfo.Texture.Alpha)
	else
		Panel.Texture:Hide()
	end
	
	
	-- Create Mover after Panel locating
	if not Panel.mover then
		if PanelInfo.Location then
			Panel:SetPoint(unpack({string.split('\031', PanelInfo.Location)}))
			--PanelInfo['Location'] = nil
		else
			Panel:Point('CENTER')
		end
		
		E:CreateMover(Panel, PanelTag..'_'..Panel.Count..'_Mover', nil, nil, nil, nil, 'ALL,KF')
		
		if E:HasMoverBeenMoved(PanelName) then
			Panel.mover:ClearAllPoints()
			Panel.mover:SetPoint(unpack({string.split('\031', E.db.movers[PanelName])}))
			E.CreatedMovers[PanelTag..'_'..Panel.Count..'_Mover'].point = E.db.movers[PanelName]
		end
	end
	-- Update Mover's Tag
	Panel.mover.text:SetText(L['PanelTag']..'|n'..(PanelInfo.Name or PanelName)..(DB.Modules.CustomPanel[PanelName] and '' or '|n|n|cffff5675'..L['CAUTION']..' : '..L['NOT SAVED!!']))
	
	
	if E.ConfigurationMode then
		Panel.mover:Show()
	end
end


function KF:CustomPanel_Delete(PanelName, SaveProfile)
	local Panel = KF.UIParent.Panel[PanelName]
	
	if Panel then
		Panel:SetAlpha(1)
		Panel:SetScript('OnUpdate', nil)
		Panel:Hide()
		Panel.mover:Hide()
		
		KF:CustomPanel_Button_ClearAll(Panel)
		
		local moverData = E.CreatedMovers[Panel.mover.name]
		Panel.MoverData = moverData
		E.CreatedMovers[Panel.mover.name] = nil
		
		if SaveProfile then
			E:SaveMoverPosition(Panel.mover.name)
			E.db.movers[PanelName] = E.db.movers[Panel.mover.name]
		else
			E.db.movers[PanelName] = nil
		end
		E.db.movers[Panel.mover.name] = nil
		
		DeletedFrame[#DeletedFrame + 1] = KF.UIParent.Panel[PanelName]
		KF.UIParent.Panel[PanelName] = nil
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


function KF:CustomPanel_Button_ClearAll(Panel)
	if Panel.Button then
		for buttonLocation in pairs(Panel.Button) do
			for _, b in pairs(Panel.Button[buttonLocation]) do
				b:ClearAllPoints()
				b:SetParent(nil)
				b:Hide()
				DeletedButton[#DeletedButton + 1] = b
			end
		end
	end
	
	Panel.Button = {}
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
			for PanelName, Panel in pairs(KF.UIParent.Panel) do
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
				for PanelName, Panel in pairs(KF.UIParent.Panel) do
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
	for panelName in pairs(KF.UIParent.Panel) do
		KF:CustomPanel_Delete(panelName, true)
	end
	
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.CustomPanel.Enable ~= false then
		Info.CustomPanel_Activate = true
		
		for panelName, IsPanelData in pairs(DB.Modules.CustomPanel) do
			if type(IsPanelData) == 'table' then
				KF:CustomPanel_Create(panelName)
				
				for i = 1, #IsPanelData.Chat do
					--KF:DockingChatFrameToCustomPanel(_G[format('ChatFrame%dTab', IsPanelData.Chat[i])], KF.UIParent.Panel[panelName])
				end
			end
		end
	else
		Info.CustomPanel_Activate = nil
	end
end