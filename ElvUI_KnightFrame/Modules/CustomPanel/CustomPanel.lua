local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))
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
local PanelCount = 0

KF.UIParent.Panel = {}
KF.UIParent.Button = {}

function KF:CustomPanel_Create(PanelName, PanelInfo)
	PanelInfo = PanelInfo or KF.db.Modules.CustomPanel[PanelName] or {}
	
	if not (KF.db.Modules.CustomPanel.Enable and PanelInfo.Enable) then
		KF:CustomPanel_Delete(PanelName, true)
		return
	end
	
	local Panel = KF.UIParent.Panel[PanelName]
	
	-- Recycle Panel if there is a deleted Panel
	if not Panel then
		if #DeletedFrame > 0 then
			KF.UIParent.Panel[PanelName] = DeletedFrame[#DeletedFrame]
			
			Panel = KF.UIParent.Panel[PanelName]
			
			--local moverData = Panel.MoverData
			E.CreatedMovers[Panel.mover.name] = Panel.MoverData --moverData
			Panel.MoverData = nil
			
			Panel:Show()
			
			DeletedFrame[#DeletedFrame] = nil
		else
			PanelCount = PanelCount + 1
			
			Panel = CreateFrame('Frame', PanelTag..'_'..PanelCount, KF.UIParent)
			Panel:CreateBackdrop('Transparent')
			Panel:Point('CENTER')
			Panel.backdrop:SetAllPoints()
			
			Panel.Texture = Panel:CreateTexture(nil, 'OVERLAY')
			Panel.Texture:SetInside()
			
			Panel.Tab = CreateFrame('Frame', nil, Panel)
			Panel.Tab:Point('TOPLEFT', Panel, SPACING, -SPACING)
			Panel.Tab:Point('BOTTOMRIGHT', Panel, 'TOPRIGHT', -SPACING, -(SPACING + PANEL_HEIGHT))
			
			Panel.DP = CreateFrame('Frame', nil, Panel)
			Panel.DP:Point('TOPLEFT', Panel, 'BOTTOMLEFT', SPACING, SPACING + PANEL_HEIGHT)
			Panel.DP:Point('BOTTOMRIGHT', Panel, -SPACING, SPACING)
			
			Panel.Count = PanelCount
			KF.UIParent.Panel[PanelName] = Panel
			
			E:CreateMover(Panel, PanelTag..'_'..Panel.Count..'_Mover', nil, nil, nil, nil, 'ALL,KF')
		end
		
		E.CreatedMovers[Panel.mover.name].point = E:HasMoverBeenMoved(PanelName) and E.db.movers[PanelName] or PanelInfo.Location or 'CENTERElvUIParent'
		Panel.mover:ClearAllPoints()
		Panel.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Panel.mover.name].point)}))
		
		FrameLinkByID[Panel.Count] = PanelName
	end
	
	
	-- Parent
	Panel:SetParent(PanelInfo.HideWhenPetBattle and KF.UIParent or E.UIParent)
	Panel:SetFrameStrata('BACKGROUND')
	Panel:SetFrameLevel(2)
	
	-- Size
	Panel:Size(PanelInfo.Width, PanelInfo.Height)
	Panel.mover:Size(PanelInfo.Width, PanelInfo.Height)
	
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
	
	
	-- Update Mover's Tag
	Panel.mover.text:SetText(L['PanelTag']..'|n'..(PanelInfo.Name or PanelName)..(KF.db.Modules.CustomPanel[PanelName] and '' or '|n|n|cffff5675'..L['CAUTION']..' : '..L['NOT SAVED!!']))
	
	
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


function KF:CustomPanel_Button_Create(ButtonFrame, ButtonType, ButtonTransparency)
	if not ButtonType then return end
	
	local Button
	
	if not ButtonFrame then
		if #DeletedButton > 0 then
			Button = DeletedButton[#DeletedButton]
			DeletedButton[#DeletedButton] = nil
		else
			Button = CreateFrame('Button', nil, KF.UIParent)
			Button:Size(SIDE_BUTTON_WIDTH, PANEL_HEIGHT)
			KF:TextSetting(Button, nil, { Font = 'Meat Edition Font', FontOutline = 'OUTLINE' }, 'CENTER', 0, 0)
			Button:RegisterForClicks('AnyUp')
		end
	else
		Button = ButtonFrame
	end
	
	Button:SetTemplate(ButtonTransparency == true and 'Transparent' or 'Default', true)
	Button:Show()
	
	local buttonText = KF.UIParent.Button[ButtonType] and KF.UIParent.Button[ButtonType].Text or (IsAddOnLoaded(ButtonType) and '' or '|cff828282')..(strsub(ButtonType, 1, 1))
	
	Button.text:SetText(buttonText or '|cff828282..')
	
	Button:SetScript('OnEnter', function(...)
		if not (KF.UIParent.Button[ButtonType] and KF.UIParent.Button[ButtonType].OnEnter) then
			GameTooltip:SetOwner(Button, 'ANCHOR_TOP', 0, 2)
			GameTooltip:ClearLines()
			
			if not IsAddOnLoaded(ButtonType) then
				if select(5, GetAddOnInfo(ButtonType)) ~= 'MISSING' then
					GameTooltip:AddLine(KF:Color_Value(ButtonType)..' is |cffb9062fnot loaded|r.|n|n', 1, 1, 1)
					GameTooltip:AddDoubleLine(KF:Color_Value('-')..' |cff6dd66dCLICK|r', 'Load AddOn.', 1, 1, 1, 1, 1, 1)
				else
					GameTooltip:AddLine(KF:Color_Value(ButtonType)..' is |cffb9062fnot installed!!!|r :(', 1, 1, 1)
				end
			else
				Button.text:SetText(KF:Color_Value(buttonText))
				GameTooltip:AddLine('Open '..KF:Color_Value(ButtonType)..' addon.', 1, 1, 1)
			end
			
			GameTooltip:Show()
		else
			KF.UIParent.Button[ButtonType].OnEnter(...)
		end
	end)
	
	Button:SetScript('OnLeave', function(...)
		if not (KF.UIParent.Button[ButtonType] and KF.UIParent.Button[ButtonType].OnLeave) then
			GameTooltip:Hide()
			Button.text:SetText(buttonText)
		else
			KF.UIParent.Button[ButtonType].OnLeave(...)
		end
	end)
	
	Button:SetScript('OnMouseDown', function(...)
		if not (KF.UIParent.Button[ButtonType] and KF.UIParent.Button[ButtonType].OnMouseDown) then
			Button.text:SetPoint('CENTER', 0, -2)
		else
			KF.UIParent.Button[ButtonType].OnMouseDown(...)
		end
	end)
	
	Button:SetScript('OnMouseUp', function(...)
		if not (KF.UIParent.Button[ButtonType] and KF.UIParent.Button[ButtonType].OnMouseUp) then
			Button.text:SetPoint('CENTER')
		else
			KF.UIParent.Button[ButtonType].OnMouseUp(...)
		end
	end)
	
	Button:SetScript('OnClick', function(...)
		if not IsAddOnLoaded(ButtonType) and select(5, GetAddOnInfo(ButtonType)) ~= 'MISSING' then
			EnableAddOn(ButtonType)
			
			if InCombatLockdown() then
				E:StaticPopup_Show('CONFIG_RL')
			else
				ReloadUI()
			end
		elseif KF.UIParent.Button[ButtonType] and KF.UIParent.Button[ButtonType].OnClick then
			KF.UIParent.Button[ButtonType].OnClick(...)
		end
	end)
	
	if KF.UIParent.Button[ButtonType] and KF.UIParent.Button[ButtonType].Func then
		KF.UIParent.Button[ButtonType].Func()
	end
	
	return Button
end


function KF:CustomPanel_Button_ClearAll(Panel)
	if Panel.Button then
		for Location in pairs(Panel.Button) do
			for _, Button in pairs(Panel.Button[Location]) do
				Button:ClearAllPoints()
				Button:SetParent(nil)
				Button:Hide()
				DeletedButton[#DeletedButton + 1] = Button
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
				if KF.db.Modules.CustomPanel[MouseOveredPanelName] then
					for i = 1, #KF.db.Modules.CustomPanel[MouseOveredPanelName].Chat do
						if KF.db.Modules.CustomPanel[MouseOveredPanelName].Chat[i] == ChatID then
							tremove(KF.db.Modules.CustomPanel[MouseOveredPanelName].Chat, i)
						end
					end
					
					tinsert(KF.db.Modules.CustomPanel[MouseOveredPanelName].Chat, ChatID)
				end
				
				KF:DockingChatFrameToCustomPanel(self, MouseOveredPanel, true)
			else
				for panelName, IsPanelData in pairs(KF.db.Modules.CustomPanel) do
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
	
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.CustomPanel.Enable ~= false then
		Info.CustomPanel_Activate = true
		
		for panelName, IsPanelData in pairs(KF.db.Modules.CustomPanel) do
			if type(IsPanelData) == 'table' then
				KF:CustomPanel_Create(panelName)
				
				--for i = 1, #IsPanelData.Chat do
					--KF:DockingChatFrameToCustomPanel(_G[format('ChatFrame%dTab', IsPanelData.Chat[i])], KF.UIParent.Panel[panelName])
				--end
			end
		end
	else
		Info.CustomPanel_Activate = nil
	end
end