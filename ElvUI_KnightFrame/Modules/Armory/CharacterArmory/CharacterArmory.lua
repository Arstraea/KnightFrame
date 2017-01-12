--Cache global variables
--Lua functions
local _G = _G
local unpack, select, type, pairs, find, tonumber, match, gsub, strupper = unpack, select, type, pairs, find, tonumber, match, gsub, strupper

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))
local ElvUI_BagModule = E:GetModule('Bags')
local Lib_Search = LibStub('LibItemSearch-1.2-ElvUI')

--WoW API / Variables
local CreateFrame = CreateFrame
local GetItemInfo = GetItemInfo
local CursorHasItem = CursorHasItem
local IsShiftKeyDown = IsShiftKeyDown
local SetItemRef = SetItemRef
local SocketInventoryItem = SocketInventoryItem
local HandleModifiedItemClick = HandleModifiedItemClick
local GetCursorInfo = GetCursorInfo
local AUCTION_CATEGORY_GEMS = AUCTION_CATEGORY_GEMS
local ClickSocketButton = ClickSocketButton
local hooksecurefunc = hooksecurefunc
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemLink = GetInventoryItemLink
local MAX_NUM_SOCKETS = MAX_NUM_SOCKETS
local GetInventoryItemGems = GetInventoryItemGems
local ITEM_MOD_AGILITY_SHORT = ITEM_MOD_AGILITY_SHORT
local AGI = AGI
local ITEM_MOD_SPIRIT_SHORT = ITEM_MOD_SPIRIT_SHORT
local SPI = SPI
local ITEM_MOD_STAMINA_SHORT = ITEM_MOD_STAMINA_SHORT
local STA = STA
local ITEM_MOD_STRENGTH_SHORT = ITEM_MOD_STRENGTH_SHORT
local STR = STR
local ITEM_MOD_INTELLECT_SHORT = ITEM_MOD_INTELLECT_SHORT
local INT = INT
local ITEM_MOD_CRIT_RATING_SHORT = ITEM_MOD_CRIT_RATING_SHORT
local CRIT_ABBR = CRIT_ABBR
local ITEM_SPELL_TRIGGER_ONUSE = ITEM_SPELL_TRIGGER_ONUSE
local ITEM_UPGRADE_TOOLTIP_FORMAT = ITEM_UPGRADE_TOOLTIP_FORMAT
local C_Transmog = C_Transmog
local C_TransmogCollection = C_TransmogCollection
local LE_TRANSMOG_TYPE_ILLUSION = LE_TRANSMOG_TYPE_ILLUSION
local LE_TRANSMOG_TYPE_APPEARANCE = LE_TRANSMOG_TYPE_APPEARANCE
local STAT_AVERAGE_ITEM_LEVEL = STAT_AVERAGE_ITEM_LEVEL
local AnimatedNumericFontStringMixin = AnimatedNumericFontStringMixin

--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade Character Frame's Item Info like Wow-Armory		>>--
--------------------------------------------------------------------------------
local CA = CharacterArmory or CreateFrame('Frame', 'CharacterArmory', PaperDollFrame)
local SlotIDList = {}
local DefaultPosition = {
	InsetDefaultPoint = { CharacterFrameInsetRight:GetPoint() },
	CharacterMainHandSlot = { CharacterMainHandSlot:GetPoint() }
}
local Legion_ArtifactData = {}
local COLORSTRING_ARTIFACT = E:RGBToHex(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].r, BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].g, BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].b)

local Default_Panel_Width = PANEL_DEFAULT_WIDTH
local Default_Panel_Width_Expand = CHARACTERFRAME_EXPANDED_WIDTH
local CharacterArmory_Panel_Width = 448
local CharacterArmory_Panel_Width_Expand = 650

--local ExpandButtonDefaultPoint = { CharacterFrameExpandButton:GetPoint() }

do --<< Button Script >>--
	function CA:OnEnter()
		if self.Link or self.Message then
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
			
			self:SetScript('OnUpdate', function()
				GameTooltip:ClearLines()
				
				if self.Link then
					GameTooltip:SetHyperlink(self.Link)
				end
				
				if self.Link and self.Message then GameTooltip:AddLine(' ') end -- Line space
				
				if self.Message then
					GameTooltip:AddLine(self.Message, 1, 1, 1)
				end
				
				GameTooltip:Show()
			end)
		end
	end
	
	
	function CA:OnLeave()
		self:SetScript('OnUpdate', nil)
		GameTooltip:Hide()
	end
	
	
	function CA:GemSocket_OnClick(Button)
		if CursorHasItem() then
			CA.GemSocket_OnRecieveDrag(self)
			return
		else
			self = self:GetParent()
		end
		
		if self.GemItemID then
			local ItemName, ItemLink = GetItemInfo(self.GemItemID)
			if self.Socket and self.Socket.Link then
				ItemLink = self.Socket.Link
			end
			
			if Button == 'LeftButton' and not IsShiftKeyDown() then
				SetItemRef(ItemLink, ItemLink, 'LeftButton')
			elseif IsShiftKeyDown() then
				if Button == 'RightButton' then
					ShowUIPanel(SocketInventoryItem(self.SlotID))
				elseif HandleModifiedItemClick(ItemLink) then
				elseif BrowseName and BrowseName:IsVisible() then
					AuctionFrameBrowse_Reset(BrowseResetButton)
					BrowseName:SetText(ItemName)
					BrowseName:SetFocus()
				end
			end
		end
	end
	
	
	local INVTYPE_ARTIFACT_RELIC = GetItemSubClassInfo(LE_ITEM_CLASS_GEM, 11)
	function CA:GemSocket_OnRecieveDrag()
		self = self:GetParent()
		
		if CursorHasItem() then
			local CursorType, _, ItemLink = GetCursorInfo()
			local _, _, _, _, _, ItemType, ItemSubType = GetItemInfo(ItemLink)
			
			if CursorType == 'item' and ItemType == AUCTION_CATEGORY_GEMS then
				ShowUIPanel(SocketInventoryItem(self.SlotID))
				
				if ItemSubType == INVTYPE_ARTIFACT_RELIC then
					ArtifactFrame.PerksTab.TitleContainer:OnRelicSlotClicked(ArtifactFrame.PerksTab.TitleContainer['RelicSlot'..self.SocketNumber])
				else
					ClickSocketButton(self.SocketNumber)
				end
			end
		end
	end
	
	
	function CA:Transmogrify_OnEnter()
		self.Texture:SetVertexColor(1, .8, 1)
		
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
		GameTooltip:SetHyperlink(self.Link)
		GameTooltip:Show()
	end
	
	
	function CA:Transmogrify_OnLeave()
		self.Texture:SetVertexColor(1, .5, 1)
		
		GameTooltip:Hide()
	end
	
	
	function CA:Transmogrify_OnClick(Button)
		local ItemName, ItemLink = GetItemInfo(self.Link)
		
		if not IsShiftKeyDown() then
			SetItemRef(ItemLink, ItemLink, 'LeftButton')
		else
			if HandleModifiedItemClick(ItemLink) then
			elseif BrowseName and BrowseName:IsVisible() then
				AuctionFrameBrowse_Reset(BrowseResetButton)
				BrowseName:SetText(ItemName)
				BrowseName:SetFocus()
			end
		end
	end
	
	
	function CA:Illusion_OnEnter()
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM')
		GameTooltip:AddLine(self.Link, 1, 1, 1)
		GameTooltip:Show()
	end
	
	
	function CA:Illusion_OnLeave()
		GameTooltip:Hide()
	end
	
	
	function CA:Illusion_OnClick(Button)
		if IsShiftKeyDown() then
			HandleModifiedItemClick(self.Link)
		end
	end
end


function CA:Setup_CharacterArmory()
	local CharacterFrame_Level = CharacterModelFrame:GetFrameLevel()
	
	--<< Core >>--
	self:Point('TOPLEFT', CharacterFrameInset, 10, 20)
	self:Point('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', -10, 5)
	
	--<< Updater >>--
	local args
	self:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'SOCKET_INFO_SUCCESS' or Event == 'ITEM_UPGRADE_MASTER_UPDATE' or Event == 'TRANSMOGRIFY_SUCCESS' or Event == 'PLAYER_ENTERING_WORLD' then
			self.GearUpdated = nil
			self:SetScript('OnUpdate', self.ScanData)
		elseif Event == 'UNIT_INVENTORY_CHANGED' then
			args = ...
			
			if args == 'player' then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.ScanData)
			end
		elseif Event == 'PLAYER_EQUIPMENT_CHANGED' then
			args = ...
			args = SlotIDList[args]
			
			self.GearUpdated = type(self.GearUpdated) == 'table' and self.GearUpdated or {}
			table.insert(self.GearUpdated, args)
			
			self:SetScript('OnUpdate', self.ScanData)
		elseif Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			_, Event, _, _, _, _, _, _, args = ...
			
			if Event == 'ENCHANT_APPLIED' and args == E.myname then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.ScanData)
			end
		elseif Event == 'UPDATE_INVENTORY_DURABILITY' then
			self.DurabilityUpdated = nil
			self:SetScript('OnUpdate', self.ScanData)
		end
	end)
	self:SetScript('OnShow', self.ScanData)
	hooksecurefunc('ToggleCharacter', function(frameType)
		if frameType ~= 'PaperDollFrame' and frameType ~= 'PetPaperDollFrame' then
			CharacterFrame:SetWidth(Default_Panel_Width)
		elseif Info.CharacterArmory_Activate and frameType == 'PaperDollFrame' then
			CharacterFrameInsetRight:SetPoint('TOPLEFT', CharacterFrameInset, 'TOPRIGHT', 110, 0)
			--CharacterFrameExpandButton:SetPoint('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', 0, 1)
		else
			CharacterFrameInsetRight:SetPoint(unpack(DefaultPosition.InsetDefaultPoint))
			--CharacterFrameExpandButton:SetPoint(unpack(ExpandButtonDefaultPoint))
		end
	end)
	hooksecurefunc('PaperDollFrame_SetLevel', function()
		if Info.CharacterArmory_Activate then 
			CharacterLevelText:SetText('|c'..RAID_CLASS_COLORS[E.myclass].colorStr..CharacterLevelText:GetText())

			CharacterFrameTitleText:ClearAllPoints()
			CharacterFrameTitleText:Point('TOP', self, 0, 23)
			CharacterFrameTitleText:SetParent(self)
			CharacterLevelText:ClearAllPoints()
			CharacterLevelText:SetPoint('TOP', CharacterFrameTitleText, 'BOTTOM', 0, -13)
			CharacterLevelText:SetParent(self)
		end
	end)
	
	self.DisplayUpdater = CreateFrame('Frame', nil, PaperDollFrame)
	self.DisplayUpdater:SetScript('OnShow', function() if Info.CharacterArmory_Activate then self:Update_Display(true) end end)
	self.DisplayUpdater:SetScript('OnUpdate', function() if Info.CharacterArmory_Activate then self:Update_Display() end end)
	
	--<< Backdrop >>--
	self.BG = self:CreateTexture(nil, 'OVERLAY')
	self.BG:SetPoint('TOPLEFT', self, -7, -20)
	self.BG:SetPoint('BOTTOMRIGHT', self, 7, 2)
	self:Update_BG()
	
	--<< Change Model Frame's frameLevel >>--
	CharacterModelFrame:SetFrameLevel(self:GetFrameLevel() + 2)
	
	--<< Average Item Level >>--
	KF:TextSetting(self, nil, { Tag = 'AverageItemLevel', FontSize = 12 }, 'BOTTOM', CharacterModelFrame, 'TOP', 0, 14)
	local function ValueColorUpdate()
		self.AverageItemLevel:SetText(KF:Color_Value(STAT_AVERAGE_ITEM_LEVEL)..' : '..format('%.2f', select(2, GetAverageItemLevel())))
	end
	E.valueColorUpdateFuncs[ValueColorUpdate] = true
	
	-- Create each equipment slots gradation, text, gem socket icon.
	local Slot
	for i, SlotName in pairs(Info.Armory_Constants.GearList) do
		-- Equipment Tag
		Slot = CreateFrame('Frame', nil, self)
		Slot:Size(130, 41)
		Slot:SetFrameLevel(CharacterFrame_Level + 2)
		Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
		Slot.ID, Slot.EmptyTexture = GetInventorySlotInfo(SlotName)
		Slot:Point(Slot.Direction, _G['Character'..SlotName], Slot.Direction == 'LEFT' and -1 or 1, 0)
		
		-- Grow each equipment slot's frame level
		_G['Character'..SlotName]:SetFrameLevel(CharacterFrame_Level + 4)
		
		-- Gradation
		Slot.Gradation = Slot:CreateTexture(nil, 'OVERLAY')
		Slot.Gradation:SetInside()
		Slot.Gradation:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Modules\\Armory\\Media\\Graphics\\Gradation')
		if Slot.Direction == 'LEFT' then
			Slot.Gradation:SetTexCoord(0, 1, 0, 1)
		else
			Slot.Gradation:SetTexCoord(1, 0, 0, 1)
		end
		
		if not KF.db.Modules.Armory.Character.Gradation.Display then
			Slot.Gradation:Hide()
		end
		
		if SlotName ~= 'ShirtSlot' and SlotName ~= 'TabardSlot' then
			-- Item Level
			KF:TextSetting(Slot, nil, { Tag = 'ItemLevel',
				Font = KF.db.Modules.Armory.Character.Level.Font,
				FontSize = KF.db.Modules.Armory.Character.Level.FontSize,
				FontStyle = KF.db.Modules.Armory.Character.Level.FontStyle,
				directionH = Slot.Direction
			}, 'TOP'..Slot.Direction, _G['Character'..SlotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)
			
			if KF.db.Modules.Armory.Character.Level.Display == 'Hide' then
				Slot.ItemLevel:Hide()
			end
			
			-- Enchantment Name
			KF:TextSetting(Slot, nil, { Tag = 'ItemEnchant',
				Font = KF.db.Modules.Armory.Character.Enchant.Font,
				FontSize = KF.db.Modules.Armory.Character.Enchant.FontSize,
				FontStyle = KF.db.Modules.Armory.Character.Enchant.FontStyle,
				directionH = Slot.Direction
			}, Slot.Direction, _G['Character'..SlotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 1)
			
			if KF.db.Modules.Armory.Character.Enchant.Display == 'Hide' then
				Slot.ItemEnchant:Hide()
			end
			
			Slot.EnchantWarning = CreateFrame('Button', nil, Slot)
			Slot.EnchantWarning:Size(KF.db.Modules.Armory.Character.Enchant.WarningSize)
			Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
			Slot.EnchantWarning.Texture:SetInside()
			Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Modules\\Armory\\Media\\Graphics\\Warning-Small')
			Slot.EnchantWarning:Point(Slot.Direction, Slot.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
			Slot.EnchantWarning:SetScript('OnEnter', self.OnEnter)
			Slot.EnchantWarning:SetScript('OnLeave', self.OnLeave)
			
			-- Durability
			KF:TextSetting(Slot, nil, { Tag = 'Durability',
				Font = KF.db.Modules.Armory.Character.Durability.Font,
				FontSize = KF.db.Modules.Armory.Character.Durability.FontSize,
				FontStyle = KF.db.Modules.Armory.Character.Durability.FontStyle,
				directionH = Slot.Direction
			}, 'BOTTOM'..Slot.Direction, _G['Character'..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 3)
			
			-- Gem Socket
			for i = 1, MAX_NUM_SOCKETS do
				Slot['Socket'..i] = CreateFrame('Frame', nil, Slot)
				Slot['Socket'..i]:Size(KF.db.Modules.Armory.Character.Gem.SocketSize)
				Slot['Socket'..i]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot['Socket'..i]:SetBackdropColor(0, 0, 0, 1)
				Slot['Socket'..i]:SetBackdropBorderColor(0, 0, 0)
				Slot['Socket'..i]:SetFrameLevel(CharacterFrame_Level + 3)
				
				Slot['Socket'..i].SlotID = Slot.ID
				Slot['Socket'..i].SocketNumber = i
				
				Slot['Socket'..i].Socket = CreateFrame('Button', nil, Slot['Socket'..i])
				Slot['Socket'..i].Socket:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot['Socket'..i].Socket:SetInside()
				Slot['Socket'..i].Socket:SetFrameLevel(CharacterFrame_Level + 3)
				Slot['Socket'..i].Socket:RegisterForClicks('AnyUp', 'RightButtonDown')
				Slot['Socket'..i].Socket:SetScript('OnEnter', self.OnEnter)
				Slot['Socket'..i].Socket:SetScript('OnLeave', self.OnLeave)
				Slot['Socket'..i].Socket:SetScript('OnClick', self.GemSocket_OnClick)
				Slot['Socket'..i].Socket:SetScript('OnReceiveDrag', self.GemSocket_OnRecieveDrag)
				
				Slot['Socket'..i].Texture = Slot['Socket'..i].Socket:CreateTexture(nil, 'OVERLAY')
				Slot['Socket'..i].Texture:SetTexCoord(.1, .9, .1, .9)
				Slot['Socket'..i].Texture:SetInside()
			end
			Slot.Socket2:Point(Slot.Direction, Slot.Socket1, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
			Slot.Socket3:Point(Slot.Direction, Slot.Socket2, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 1 or -1, 0)
			
			Slot.SocketWarning = CreateFrame('Button', nil, Slot)
			Slot.SocketWarning:Size(KF.db.Modules.Armory.Character.Gem.WarningSize)
			Slot.SocketWarning:RegisterForClicks('AnyUp')
			Slot.SocketWarning.Texture = Slot.SocketWarning:CreateTexture(nil, 'OVERLAY')
			Slot.SocketWarning.Texture:SetInside()
			Slot.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Modules\\Armory\\Media\\Graphics\\Warning-Small')
			Slot.SocketWarning:SetScript('OnEnter', self.OnEnter)
			Slot.SocketWarning:SetScript('OnLeave', self.OnLeave)
			
			-- Transmogrify
			if Info.Armory_Constants.CanTransmogrifySlot[SlotName] then
				Slot.TransmogrifyAnchor = CreateFrame('Button', nil, Slot)
				Slot.TransmogrifyAnchor:Size(12)
				Slot.TransmogrifyAnchor:SetFrameLevel(CharacterFrame_Level + 3)
				Slot.TransmogrifyAnchor:Point('BOTTOM'..Slot.Direction, Slot, Slot.Direction == 'LEFT' and -2 or 2, -1)
				Slot.TransmogrifyAnchor:SetScript('OnEnter', self.Transmogrify_OnEnter)
				Slot.TransmogrifyAnchor:SetScript('OnLeave', self.Transmogrify_OnLeave)
				Slot.TransmogrifyAnchor:SetScript('OnClick', self.Transmogrify_OnClick)
				
				Slot.TransmogrifyAnchor.Texture = Slot.TransmogrifyAnchor:CreateTexture(nil, 'OVERLAY')
				Slot.TransmogrifyAnchor.Texture:SetInside()
				Slot.TransmogrifyAnchor.Texture:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Modules\\Armory\\Media\\Graphics\\Anchor')
				Slot.TransmogrifyAnchor.Texture:SetVertexColor(1, .5, 1)
				
				if Slot.Direction == 'LEFT' then
					Slot.TransmogrifyAnchor.Texture:SetTexCoord(0, 1, 0, 1)
				else
					Slot.TransmogrifyAnchor.Texture:SetTexCoord(1, 0, 0, 1)
				end
				
				Slot.TransmogrifyAnchor:Hide()
			end
			
			-- Illusion
			if Info.Armory_Constants.CanIllusionSlot[SlotName] then
				Slot.IllusionAnchor = CreateFrame('Button', nil, Slot)
				Slot.IllusionAnchor:Size(18)
				Slot.IllusionAnchor:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot.IllusionAnchor:SetFrameLevel(CharacterFrame_Level + 5)
				Slot.IllusionAnchor:Point('CENTER', _G['Character'..SlotName], 'BOTTOM', 0, -2)
				Slot.IllusionAnchor:SetScript('OnEnter', self.Illusion_OnEnter)
				Slot.IllusionAnchor:SetScript('OnLeave', self.Illusion_OnLeave)
				Slot.IllusionAnchor:SetScript('OnClick', self.Illusion_OnClick)
				hooksecurefunc(_G['Character'..SlotName].IconBorder, 'SetVertexColor', function(self, r, g, b)
					Slot.IllusionAnchor:SetBackdropBorderColor(r, g, b)
				end)
				
				Slot.IllusionAnchor.Texture = Slot.IllusionAnchor:CreateTexture(nil, 'OVERLAY')
				Slot.IllusionAnchor.Texture:SetInside()
				Slot.IllusionAnchor.Texture:SetTexCoord(.1, .9, .1, .9)
				Slot.IllusionAnchor:Hide()
			end
		end
		
		SlotIDList[Slot.ID] = SlotName
		self[SlotName] = Slot
	end
	
	-- GameTooltip for counting gem sockets and getting enchant effects
	self.ScanTT = CreateFrame('GameTooltip', 'Knight_CharacterArmory_ScanTT', nil, 'GameTooltipTemplate')
	self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
	
	do -- Legion : Artifact Weapon Monitor
		self.ArtifactMonitor = CreateFrame('Frame', nil, self)
		self.ArtifactMonitor:SetFrameLevel(CharacterFrame_Level + 2)
		self.ArtifactMonitor:Height(41)
		self.ArtifactMonitor:Point('RIGHT', CharacterTrinket1Slot)
		self.ArtifactMonitor:SetScript('OnShow', function() CA:LegionArtifactMonitor_SearchPowerItem() end)
		self.ArtifactMonitor:SetScript('OnUpdate', function(_, Elapsed)
			self.ArtifactMonitor.CurrentPower:UpdateAnimatedValue(Elapsed)
			
			if not self.ArtifactMonitor.UpdateData then
				CA:LegionArtifactMonitor_UpdateData()
			end
			
			if not self.ArtifactMonitor.SearchPowerItem then
				CA:LegionArtifactMonitor_SearchPowerItem()
			end
		end)
		self.ArtifactMonitor:SetScript('OnEvent', function(_, Event)
			if Event == 'ARTIFACT_UPDATE' or Event == 'ARTIFACT_XP_UPDATE' then
				self.ArtifactMonitor.UpdateData = nil
			elseif Event == 'BAG_UPDATE' or Event == 'PLAYER_ENTERING_WORLD' then
				self.ArtifactMonitor.SearchPowerItem = nil
			end
		end)
		
		-- Gradation
		self.ArtifactMonitor.Gradation = self.ArtifactMonitor:CreateTexture(nil, 'OVERLAY')
		self.ArtifactMonitor.Gradation:Width(130)
		self.ArtifactMonitor.Gradation:Point('TOPLEFT', E.Border, -E.Border)
		self.ArtifactMonitor.Gradation:Point('BOTTOMLEFT', E.Border, E.Border)
		self.ArtifactMonitor.Gradation:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Modules\\Armory\\Media\\Graphics\\Gradation')
		self.ArtifactMonitor.Gradation:SetTexCoord(0, 1, 0, 1)
		
		-- Power StatusBar
		self.ArtifactMonitor.BarBorder = CreateFrame('Frame', nil, self.ArtifactMonitor)
		self.ArtifactMonitor.BarBorder:Height(5)
		self.ArtifactMonitor.BarBorder:Point('BOTTOMLEFT', 40, 4 + E.Border)
		self.ArtifactMonitor.BarBorder:Point('RIGHT')
		self.ArtifactMonitor.BarBorder:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		self.ArtifactMonitor.BarBorder:SetBackdropColor(.25, .25, .25)
		self.ArtifactMonitor.BarBorder:SetBackdropBorderColor(0, 0, 0)
		
		self.ArtifactMonitor.Bar = CreateFrame('StatusBar', nil, self.ArtifactMonitor.BarBorder, 'AnimatedStatusBarTemplate')
		self.ArtifactMonitor.Bar:SetFrameLevel(CharacterFrame_Level + 4)
		self.ArtifactMonitor.Bar:SetStatusBarTexture(E.media.blankTex)
		self.ArtifactMonitor.Bar:SetStatusBarColor(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].r, BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].g, BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].b)
		self.ArtifactMonitor.Bar:SetInside()
		self.ArtifactMonitor.Bar:EnableMouse(false)
		self.ArtifactMonitor.Bar.SparkBurstMove:Height(3)
		self.ArtifactMonitor.BarExpected = CreateFrame('StatusBar', nil, self.ArtifactMonitor.BarBorder)
		self.ArtifactMonitor.BarExpected:SetFrameLevel(CharacterFrame_Level + 3)
		self.ArtifactMonitor.BarExpected:SetStatusBarTexture(E.media.blankTex)
		self.ArtifactMonitor.BarExpected:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
		self.ArtifactMonitor.BarExpected:SetInside()
		self.ArtifactMonitor.BarExpected:EnableMouse(false)
		E:Flash(self.ArtifactMonitor.BarExpected, 1, true)
		
		-- Gem Socket
		for i = 1, C_ArtifactUI.GetEquippedArtifactNumRelicSlots() or 3 do
			self.ArtifactMonitor['Socket'..i] = CreateFrame('Frame', nil, self.ArtifactMonitor)
			self.ArtifactMonitor['Socket'..i]:Size(KF.db.Modules.Armory.Character.Gem.SocketSize)
			self.ArtifactMonitor['Socket'..i]:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.ArtifactMonitor['Socket'..i]:SetBackdropColor(0, 0, 0, 1)
			self.ArtifactMonitor['Socket'..i]:SetBackdropBorderColor(0, 0, 0)
			self.ArtifactMonitor['Socket'..i]:SetFrameLevel(CharacterFrame_Level + 4)
			
			self.ArtifactMonitor['Socket'..i].SlotID = 16
			self.ArtifactMonitor['Socket'..i].SocketNumber = i
			
			self.ArtifactMonitor['Socket'..i].Socket = CreateFrame('Button', nil, self.ArtifactMonitor['Socket'..i])
			self.ArtifactMonitor['Socket'..i].Socket:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.ArtifactMonitor['Socket'..i].Socket:SetInside()
			self.ArtifactMonitor['Socket'..i].Socket:SetFrameLevel(CharacterFrame_Level + 4)
			self.ArtifactMonitor['Socket'..i].Socket:RegisterForClicks('AnyUp', 'RightButtonDown')
			self.ArtifactMonitor['Socket'..i].Socket:SetScript('OnEnter', self.OnEnter)
			self.ArtifactMonitor['Socket'..i].Socket:SetScript('OnLeave', self.OnLeave)
			self.ArtifactMonitor['Socket'..i].Socket:SetScript('OnClick', self.GemSocket_OnClick)
			self.ArtifactMonitor['Socket'..i].Socket:SetScript('OnReceiveDrag', self.GemSocket_OnRecieveDrag)
			
			self.ArtifactMonitor['Socket'..i].Texture = self.ArtifactMonitor['Socket'..i].Socket:CreateTexture(nil, 'OVERLAY')
			self.ArtifactMonitor['Socket'..i].Texture:SetTexCoord(.1, .9, .1, .9)
			self.ArtifactMonitor['Socket'..i].Texture:SetInside()
			
			self.ArtifactMonitor['Socket'..i]:Point('CENTER', self.MainHandSlot['Socket'..i])
		end
		self.ArtifactMonitor.SocketWarning = CreateFrame('Button', nil, self.ArtifactMonitor)
		self.ArtifactMonitor.SocketWarning:Size(KF.db.Modules.Armory.Character.Gem.WarningSize)
		self.ArtifactMonitor.SocketWarning:RegisterForClicks('AnyUp')
		self.ArtifactMonitor.SocketWarning.Texture = self.ArtifactMonitor.SocketWarning:CreateTexture(nil, 'OVERLAY')
		self.ArtifactMonitor.SocketWarning.Texture:SetInside()
		self.ArtifactMonitor.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Modules\\Armory\\Media\\Graphics\\Warning-Small')
		self.ArtifactMonitor.SocketWarning:SetScript('OnEnter', self.OnEnter)
		self.ArtifactMonitor.SocketWarning:SetScript('OnLeave', self.OnLeave)
		self.ArtifactMonitor.SocketWarning:Point('RIGHT', self.ArtifactMonitor.Socket3, 'LEFT', -3, 0)
		
		-- Current Artifact Power
		KF:TextSetting(self.ArtifactMonitor, ARTIFACT_POWER..' : ', { Tag = 'PowerTitle',
			Font = KF.db.Modules.Armory.Character.Enchant.Font,
			FontSize = 9,
			FontStyle = KF.db.Modules.Armory.Character.Enchant.FontStyle,
			directionH = 'LEFT'
		}, 'BOTTOMLEFT', self.ArtifactMonitor.BarBorder, 'TOPLEFT', 0, 4 + E.Border)
		
		KF:TextSetting(self.ArtifactMonitor, nil, { Tag = 'CurrentPower',
			Font = KF.db.Modules.Armory.Character.Enchant.Font,
			FontSize = 9,
			FontStyle = KF.db.Modules.Armory.Character.Enchant.FontStyle,
			directionH = 'LEFT'
		}, 'LEFT', self.ArtifactMonitor.PowerTitle, 'RIGHT', 0, 0)
		Mixin(self.ArtifactMonitor.CurrentPower, AnimatedNumericFontStringMixin)
		self.ArtifactMonitor.CurrentPower:SetTextColor(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].r, BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].g, BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT].b)
		
		-- Available Artifact Power
		KF:TextSetting(self.ArtifactMonitor.BarExpected, nil, { Tag = 'AvailablePower',
			Font = KF.db.Modules.Armory.Character.Enchant.Font,
			FontSize = 9,
			FontStyle = KF.db.Modules.Armory.Character.Enchant.FontStyle,
			directionH = 'LEFT'
		}, 'TOPRIGHT', self.ArtifactMonitor.BarBorder, 'BOTTOMRIGHT', 0, -1)
		
		-- Artifact Traits Rank
		KF:TextSetting(self.ArtifactMonitor, nil, { Tag = 'TraitRank',
			Font = KF.db.Modules.Armory.Character.Level.Font,
			FontSize = 9,
			FontStyle = KF.db.Modules.Armory.Character.Level.FontStyle,
			directionH = 'LEFT'
		}, 'BOTTOMLEFT', self.ArtifactMonitor.PowerTitle, 'TOPLEFT', 0, 3)
		
		-- Require Artifact Power
		KF:TextSetting(self.ArtifactMonitor, nil, { Tag = 'RequirePower',
			Font = KF.db.Modules.Armory.Character.Enchant.Font,
			FontSize = 9,
			FontStyle = KF.db.Modules.Armory.Character.Enchant.FontStyle,
			directionH = 'RIGHT'
		}, 'BOTTOM', self.ArtifactMonitor.BarBorder, 'TOP', 0, 4 + E.Border)
		self.ArtifactMonitor.RequirePower:Point('RIGHT', self.ArtifactMonitor)
		self.ArtifactMonitor.CurrentPower:Point('RIGHT', self.ArtifactMonitor.RequirePower, 'LEFT', -4, 0)
		
		-- Message
		KF:TextSetting(self.ArtifactMonitor.BarExpected, nil, { Tag = 'Message',
			Font = KF.db.Modules.Armory.Character.Level.Font,
			FontSize = 11,
			FontStyle = KF.db.Modules.Armory.Character.Level.FontStyle,
			directionH = 'RIGHT'
		}, 'BOTTOMRIGHT', self.ArtifactMonitor.RequirePower, 'TOPRIGHT', 0, 2)
		
		self.ArtifactMonitor.AddPower = CreateFrame('Frame', nil, self.ArtifactMonitor)
		self.ArtifactMonitor.AddPower:Point('BOTTOMLEFT', 39, 0)
		self.ArtifactMonitor.AddPower:Point('TOPRIGHT')
		
		self.ArtifactMonitor.AddPower.Texture = self.ArtifactMonitor.AddPower:CreateTexture(nil, 'OVERLAY')
		self.ArtifactMonitor.AddPower.Texture:Size(15)
		self.ArtifactMonitor.AddPower.Texture:SetTexture('Interface\\GLUES\\CharacterSelect\\Glue-Char-Up')
		self.ArtifactMonitor.AddPower.Texture:Point('LEFT', self.ArtifactMonitor.TraitRank, 'RIGHT', 1, 0)
		self.ArtifactMonitor.AddPower.Texture:Hide()
		
		self.ArtifactMonitor.AddPower.Button = CreateFrame('Button', nil, self.ArtifactMonitor.AddPower)
		self.ArtifactMonitor.AddPower.Button:SetInside()
		self.ArtifactMonitor.AddPower.Button:SetFrameLevel(CharacterFrame_Level + 6)
		self.ArtifactMonitor.AddPower.Button:SetScript('OnEnter', self.OnEnter)
		self.ArtifactMonitor.AddPower.Button:SetScript('OnLeave', self.OnLeave)
		self.ArtifactMonitor.AddPower.Button:SetScript('OnClick', function()
			if E.private.bags.enable then
				OpenAllBags()
				ElvUI_ContainerFrameEditBox:SetText('POWER')
				self.ArtifactMonitor.NowSearchingPowerItem = true
			end
		end)
		
		self.ArtifactMonitor.ScanTT = CreateFrame('GameTooltip', 'Knight_CharacterArmory_ArtifactScanTT', nil, 'GameTooltipTemplate')
		self.ArtifactMonitor.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
		
		self.ArtifactMonitor:Hide()
		
		if E.private.bags.enable then
			hooksecurefunc(ElvUI_BagModule, 'CloseBags', function() self:LegionArtifactMonitor_ClearPowerItemSearching() end)
			ElvUI_ContainerFrame:HookScript('OnHide', function() self:LegionArtifactMonitor_ClearPowerItemSearching() end)
		end
	end
	self.Setup_CharacterArmory = nil
end


function CA:ScanData()
	self.NeedUpdate = nil
	
	if not self.DurabilityUpdated then
		self.NeedUpdate = self:Update_Durability() or self.NeedUpdate
	end
	
	if self.GearUpdated ~= true then
		self.NeedUpdate = self:Update_Gear() or self.NeedUpdate
	end
	
	if not self.NeedUpdate and self:IsShown() then
		self:SetScript('OnUpdate', nil)
		self:Update_Display(true)
	elseif self.NeedUpdate then
		self:SetScript('OnUpdate', self.ScanData)
	end
end


function CA:Update_Durability()
	local Slot, R, G, B, CurrentDurability, MaxDurability
	
	for _, SlotName in pairs(Info.Armory_Constants.GearList) do
		Slot = self[SlotName]
		CurrentDurability, MaxDurability = GetInventoryItemDurability(Slot.ID)
		
		if CurrentDurability and MaxDurability and not (KF.db.Modules.Armory.Character.Durability.Display == 'DamagedOnly' and CurrentDurability == MaxDurability) then
			R, G, B = E:ColorGradient((CurrentDurability / MaxDurability), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			Slot.Durability:SetFormattedText("%s%.0f%%|r", E:RGBToHex(R, G, B), (CurrentDurability / MaxDurability) * 100)
			
			if (KF.db.Modules.Armory.Character.Durability.Display == 'MouseoverOnly' and not Slot:IsMouseOver()) or KF.db.Modules.Armory.Character.Durability.Display == 'Hide' then
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 2)
			else
				Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot.Durability, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Durability:GetText() and (Slot.Direction == 'LEFT' and 3 or -1) or 0, Slot.Durability:GetText() and -1 or 0)
			end
		elseif Slot.Durability then
			Slot.Durability:SetText()
			Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 2)
		end
	end
	
	self.DurabilityUpdated = true
end


function CA:ClearTooltip(Tooltip)
	local TooltipName = Tooltip:GetName()
	
	Tooltip:ClearLines()
	for i = 1, 10 do
		_G[TooltipName..'Texture'..i]:SetTexture(nil)
		_G[TooltipName..'Texture'..i]:ClearAllPoints()
		_G[TooltipName..'Texture'..i]:Point('TOPLEFT', Tooltip)
	end
end


local Artifact_ItemID, Artifact_Power, Artifact_Rank, LockedReason
function CA:Update_Gear()
	--[[ Get Player Profession
	
	local Prof1, Prof2 = GetProfessions()
	local Prof1_Level, Prof2_Level = 0, 0
	self.PlayerProfession = {}
	
	if Prof1 then Prof1, _, Prof1_Level = GetProfessionInfo(Prof1) end
	if Prof2 then Prof2, _, Prof2_Level = GetProfessionInfo(Prof2) end
	if Prof1 and Info.Armory_Constants.ProfessionList[Prof1] then self.PlayerProfession[(Info.Armory_Constants.ProfessionList[Prof1].Key)] = Prof1_Level end
	if Prof2 and Info.Armory_Constants.ProfessionList[Prof2] then self.PlayerProfession[(Info.Armory_Constants.ProfessionList[Prof2].Key)] = Prof2_Level end
	]]
	
	local ErrorDetected, NeedUpdate, NeedUpdateList, R, G, B, ArtifactMonitor_RequireUpdate
	local Slot, ItemLink, ItemData, BasicItemLevel, TrueItemLevel, ItemUpgradeID, CurrentUpgrade, MaxUpgrade, ItemType, UsableEffect, CurrentLineText, GemID, GemLink, GemTexture, GemCount_Default, GemCount_Now, GemCount, IsTransmogrified
	
	Artifact_ItemID, _, _, _, Artifact_Power, Artifact_Rank = C_ArtifactUI.GetEquippedArtifactInfo()
	
	for _, SlotName in pairs(type(self.GearUpdated) == 'table' and self.GearUpdated or Info.Armory_Constants.GearList) do
		Slot = self[SlotName]
		ItemLink = GetInventoryItemLink('player', Slot.ID)
		ErrorDetected = nil
		
		if not (SlotName == 'ShirtSlot' or SlotName == 'TabardSlot') then
			do --<< Clear Setting >>--
				NeedUpdate, TrueItemLevel, UsableEffect, ItemUpgradeID, CurrentUpgrade, MaxUpgrade, ItemType, ItemTexture, IsTransmogrified = nil, nil, nil, nil, nil, nil, nil, nil, nil
				
				Slot.ItemRarity = nil
				Slot.ItemLevel:SetText(nil)
				Slot.IsEnchanted = nil
				Slot.ItemEnchant:SetText(nil)
				Slot.ItemEnchant.Message = nil
				Slot.GemCount_Enable = nil
				for i = 1, MAX_NUM_SOCKETS do
					Slot['Socket'..i].Texture:SetTexture(nil)
					Slot['Socket'..i].Socket.Link = nil
					Slot['Socket'..i].Socket.Message = nil
					Slot['Socket'..i].GemItemID = nil
					Slot['Socket'..i].GemType = nil
					Slot['Socket'..i]:Hide()
				end
				Slot.EnchantWarning:Hide()
				Slot.EnchantWarning.Message = nil
				Slot.SocketWarning:Point(Slot.Direction, Slot.Socket1)
				Slot.SocketWarning:Hide()
				Slot.SocketWarning.Link = nil
				Slot.SocketWarning.Message = nil
				
				if Slot.TransmogrifyAnchor then
					Slot.TransmogrifyAnchor.SourceID = nil
					Slot.TransmogrifyAnchor.Link = nil
					Slot.TransmogrifyAnchor:Hide()
				end
				
				if Slot.IllusionAnchor then
					Slot.IllusionAnchor.Link = nil
					Slot.IllusionAnchor:Hide()
				end
			end
			
			if ItemLink then
				if not ItemLink:find('%[%]') then -- sometimes itemLink is malformed so we need to update when crashed
					--<< Prepare Setting >>
					ItemData = { strsplit(':', ItemLink) }
					for i = 1, #ItemData do
						if tonumber(ItemData[i]) then
							ItemData[i] = tonumber(ItemData[i])
						end
					end
					Slot.ItemName, _, Slot.ItemRarity, BasicItemLevel, _, _, _, _, ItemType = GetItemInfo(ItemLink)
					R, G, B = GetItemQualityColor(Slot.ItemRarity)
					
					--<< Legion - Artifact Weapon Detection >>--
					if (SlotName == 'MainHandSlot' or SlotName == 'SecondaryHandSlot') then
						if Artifact_ItemID and Artifact_ItemID == ItemData[2] then
							Legion_ArtifactData.MajorSlot = SlotName
							Legion_ArtifactData.ItemID = Artifact_ItemID
							Legion_ArtifactData.Power = Artifact_Power
							Legion_ArtifactData.Rank = Artifact_Rank
						elseif not Artifact_ItemID then
							wipe(Legion_ArtifactData)
						end
						
						ArtifactMonitor_RequireUpdate = true
					end
					
					do --<< Gem Parts >>--
						GemCount_Default, GemCount_Now, GemCount = 0, 0, 0
						
						-- First, Counting default gem sockets
						if Legion_ArtifactData.ItemID and Legion_ArtifactData.MajorSlot == SlotName then
							Slot.GemCount_Enable = C_ArtifactUI.GetEquippedArtifactNumRelicSlots()
							
							self:ClearTooltip(self.ScanTT)
							self.ScanTT:SetInventoryItem('player', Slot.ID)
							
							for i = 1, Slot.GemCount_Enable do
								LockedReason, _, GemTexture, GemLink = C_ArtifactUI.GetEquippedArtifactRelicInfo(i)
								GemID = Info.Armory_Constants.ArtifactType[Legion_ArtifactData.ItemID][i]
								R, G, B = unpack(Info.Armory_Constants.GemColor[GemID])
								
								if not LockedReason then
									GemCount_Now = GemCount_Now + 1
									
									self.ArtifactMonitor['Socket'..i].Texture:SetTexture(GemTexture)
									self.ArtifactMonitor['Socket'..i].Socket.Link = GemLink
									self.ArtifactMonitor['Socket'..i].Socket.Message = nil
									self.ArtifactMonitor['Socket'..i].GemItemID = ItemData[i + 3] ~= '' and ItemData[i + 3] or 0
									self.ArtifactMonitor['Socket'..i].Socket:SetBackdropColor(R, G, B, .5)
									
									Slot['Socket'..i].Texture:SetTexture(GemTexture)
									Slot['Socket'..i].Socket.Link = GemLink
									Slot['Socket'..i].Socket.Message = nil
									Slot['Socket'..i].GemItemID = ItemData[i + 3] ~= '' and ItemData[i + 3] or 0
									Slot['Socket'..i].Socket:SetBackdropColor(R, G, B, .5)
									
									if GemTexture then
										GemCount = GemCount + 1
									else
										self.ArtifactMonitor['Socket'..i].Socket.Message = format(RELIC_TOOLTIP_TYPE, E:RGBToHex(R, G, B).._G['RELIC_SLOT_TYPE_'..GemID])
										Slot['Socket'..i].Socket.Message = format(RELIC_TOOLTIP_TYPE, E:RGBToHex(R, G, B).._G['RELIC_SLOT_TYPE_'..GemID])
									end
								else
									Slot.GemCount_Enable = Slot.GemCount_Enable - 1
									self.ArtifactMonitor['Socket'..i].Socket.Message = format(LOCKED_RELIC_TOOLTIP_TITLE, E:RGBToHex(R, G, B).._G['RELIC_SLOT_TYPE_'..GemID])..'|r|n'..LockedReason
									self.ArtifactMonitor['Socket'..i].Socket:SetBackdropColor(0, 0, 0, .5)
									
									Slot['Socket'..i].Socket.Message = format(LOCKED_RELIC_TOOLTIP_TITLE, E:RGBToHex(R, G, B).._G['RELIC_SLOT_TYPE_'..GemID])..'|r|n'..LockedReason
									Slot['Socket'..i].Socket:SetBackdropColor(0, 0, 0, .5)
								end
								
								self.ArtifactMonitor['Socket'..i].Socket:SetBackdropBorderColor(R, G, B)
								self.ArtifactMonitor['Socket'..i].GemType = GemID
								
								Slot['Socket'..i].Socket:SetBackdropBorderColor(R, G, B)
								Slot['Socket'..i].GemType = GemID
								if KF.db.Modules.Armory.Character.Gem.Display == 'Always' or KF.db.Modules.Armory.Character.Gem.Display == 'MouseoverOnly' and Slot.Mouseovered or KF.db.Modules.Armory.Character.Gem.Display == 'MissingOnly' then
									Slot['Socket'..i]:Show()
									Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
								end
								
								--<< Notice Missing >>--
								if KF.db.Modules.Armory.Character.NoticeMissing ~= false and Slot.GemCount_Enable > GemCount_Now or Slot.GemCount_Enable > GemCount or GemCount_Now > GemCount then
									self.ArtifactMonitor.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L['Empty Socket']
									self.ArtifactMonitor.SocketWarning:Show()
								else
									self.ArtifactMonitor.SocketWarning.Message = nil
									self.ArtifactMonitor.SocketWarning:Hide()
								end
							end
						else
							ItemData.FixedLink = ItemData[1]
							
							for i = 2, #ItemData do
								if i == 4 or i == 5 or i == 6 or i == 7 then
									ItemData.FixedLink = ItemData.FixedLink..':'
								else
									ItemData.FixedLink = ItemData.FixedLink..':'..ItemData[i]
								end
							end
							
							self:ClearTooltip(self.ScanTT)
							self.ScanTT:SetHyperlink(ItemData.FixedLink)
							
							for i = 1, MAX_NUM_SOCKETS do
								GemTexture = _G['Knight_CharacterArmory_ScanTTTexture'..i]:GetTexture()
								
								if GemTexture and GemTexture:find('Interface\\ItemSocketingFrame\\') then
									GemCount_Default = GemCount_Default + 1
									Slot['Socket'..GemCount_Default].GemType = strupper(gsub(GemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
								end
							end
							
							-- Second, Check if slot's item enable to adding a socket
							Slot.GemCount_Enable = GemCount_Default
							--[[
							if (SlotName == 'WaistSlot' and UnitLevel('player') >= 70) or -- buckle
								((SlotName == 'WristSlot' or SlotName == 'HandsSlot') and self.PlayerProfession.BlackSmithing and self.PlayerProfession.BlackSmithing >= 550) then -- BlackSmith
								
								GemCount_Enable = GemCount_Enable + 1
								Slot['Socket'..GemCount_Enable].GemType = 'PRISMATIC'
							end
							]]
							
							self:ClearTooltip(self.ScanTT)
							self.ScanTT:SetInventoryItem('player', Slot.ID)
							
							-- Apply current item's gem setting
							for i = 1, MAX_NUM_SOCKETS do
								GemTexture = _G['Knight_CharacterArmory_ScanTTTexture'..i]:GetTexture()
								GemID = ItemData[i + 3] ~= '' and ItemData[i + 3] or 0
								_, GemLink = GetItemGem(ItemLink, i)
								
								if Slot['Socket'..i].GemType and Info.Armory_Constants.GemColor[Slot['Socket'..i].GemType] then
									R, G, B = unpack(Info.Armory_Constants.GemColor[Slot['Socket'..i].GemType])
									Slot['Socket'..i].Socket:SetBackdropColor(R, G, B, .5)
									Slot['Socket'..i].Socket:SetBackdropBorderColor(R, G, B)
								else
									Slot['Socket'..i].Socket:SetBackdropColor(1, 1, 1, .5)
									Slot['Socket'..i].Socket:SetBackdropBorderColor(1, 1, 1)
								end
								
								if GemTexture or GemLink then
									if KF.db.Modules.Armory.Character.Gem.Display == 'Always' or KF.db.Modules.Armory.Character.Gem.Display == 'MouseoverOnly' and Slot.Mouseovered or KF.db.Modules.Armory.Character.Gem.Display == 'MissingOnly' then
										Slot['Socket'..i]:Show()
										Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
									end
									
									GemCount_Now = GemCount_Now + 1
									
									if GemID ~= 0 then
										GemCount = GemCount + 1
										Slot['Socket'..i].GemItemID = GemID
										Slot['Socket'..i].Socket.Link = GemLink
										
										GemTexture = select(10, GetItemInfo(GemID))
										
										if GemTexture then
											Slot['Socket'..i].Texture:SetTexture(GemTexture)
										else
											NeedUpdate = true
										end
									else
										Slot['Socket'..i].Socket.Message = '|cffffffff'.._G['EMPTY_SOCKET_'..Slot['Socket'..i].GemType]
									end
								end
							end
							
							if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
								NeedUpdate = true
							end
						end
					end
					
					--<< Enchant Parts >>--
					for i = 1, self.ScanTT:NumLines() do
						CurrentLineText = _G['Knight_CharacterArmory_ScanTTTextLeft'..i]:GetText()
						
						if CurrentLineText:find(Info.Armory_Constants.ItemLevelKey_Alt) then
							TrueItemLevel = tonumber(CurrentLineText:match(Info.Armory_Constants.ItemLevelKey_Alt))
						elseif CurrentLineText:find(Info.Armory_Constants.ItemLevelKey) then
							TrueItemLevel = tonumber(CurrentLineText:match(Info.Armory_Constants.ItemLevelKey))
						elseif CurrentLineText:find(Info.Armory_Constants.EnchantKey) then
							if KF.db.Modules.Armory.Character.Enchant.Display ~= 'Hide' then
								CurrentLineText = CurrentLineText:match(Info.Armory_Constants.EnchantKey) -- Get enchant string
								CurrentLineText = gsub(CurrentLineText, ITEM_MOD_AGILITY_SHORT, AGI)
								CurrentLineText = gsub(CurrentLineText, ITEM_MOD_SPIRIT_SHORT, SPI)
								CurrentLineText = gsub(CurrentLineText, ITEM_MOD_STAMINA_SHORT, STA)
								CurrentLineText = gsub(CurrentLineText, ITEM_MOD_STRENGTH_SHORT, STR)
								CurrentLineText = gsub(CurrentLineText, ITEM_MOD_INTELLECT_SHORT, INT)
								CurrentLineText = gsub(CurrentLineText, ITEM_MOD_CRIT_RATING_SHORT, CRIT_ABBR) -- Critical is too long
								CurrentLineText = gsub(CurrentLineText, ' + ', '+') -- Remove space
								
								if L.Armory_ReplaceEnchantString and type(L.Armory_ReplaceEnchantString) == 'table' then
									for Old, New in pairs(L.Armory_ReplaceEnchantString) do
										CurrentLineText = gsub(CurrentLineText, Old, New)
									end
								end
								
								for Old, New in pairs(KnightFrameDB.ArmoryDB.EnchantString) do
									CurrentLineText = gsub(CurrentLineText, Old, New)
								end
								
								Slot.ItemEnchant:SetText('|cffceff00'..CurrentLineText)
							end
							
							Slot.IsEnchanted = true
						elseif CurrentLineText:find(ITEM_SPELL_TRIGGER_ONUSE) then
							UsableEffect = true
						elseif CurrentLineText:find(ITEM_UPGRADE_TOOLTIP_FORMAT) then
							CurrentUpgrade, MaxUpgrade = CurrentLineText:match(Info.Armory_Constants.ItemUpgradeKey)
						end
					end
					
					--<< ItemLevel Parts >>--
					ItemUpgradeID = ItemData[12]
					
					if BasicItemLevel then
						if ItemUpgradeID then
							if ItemUpgradeID == '' or not KF.db.Modules.Armory.Character.Level.ShowUpgradeLevel and Slot.ItemRarity == 7 then -- Rarity 7 : Heirloom
								ItemUpgradeID = nil
							elseif CurrentUpgrade or MaxUpgrade then
								ItemUpgradeID = TrueItemLevel - BasicItemLevel
							else
								ItemUpgradeID = nil
							end
						end
						
						Slot.ItemLevel:SetText(
							(not TrueItemLevel or BasicItemLevel == TrueItemLevel) and BasicItemLevel
							or
							KF.db.Modules.Armory.Character.Level.ShowUpgradeLevel and (Slot.Direction == 'LEFT' and TrueItemLevel..' ' or '')..(ItemUpgradeID and (Info.Armory_Constants.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r' or '')..(Slot.Direction == 'RIGHT' and ' '..TrueItemLevel or '')
							or
							TrueItemLevel
						)
					end
					
					--<< Notice Missing >>--
					if KF.db.Modules.Armory.Character.NoticeMissing ~= false then
						if not Slot.IsEnchanted and
						   (Info.Armory_Constants.EnchantableSlots[SlotName] or (E.myclass == 'DEATHKNIGHT' and (SlotName == 'MainHandSlot' or SlotName == 'SecondaryHandSlot'))) and
						   not (SlotName == 'SecondaryHandSlot' and ItemType ~= 'INVTYPE_WEAPON' and ItemType ~= 'INVTYPE_WEAPONOFFHAND' and ItemType ~= 'INVTYPE_RANGEDRIGHT') then
							
							ErrorDetected = true
							Slot.IsEnchanted = false
							Slot.EnchantWarning:Show()
							
							if KF.db.Modules.Armory.Character.Enchant.WarningIconOnly then
								Slot.EnchantWarning.Message = '|cffff0000'..L['Not Enchanted']
							else
								Slot.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
							end
						end
						
						if Slot.GemCount_Enable > GemCount_Now or Slot.GemCount_Enable > GemCount or GemCount_Now > GemCount then
							ErrorDetected = true
							
							Slot.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L['Empty Socket']
							Slot.SocketWarning:Show()
						end
					end
					
					--<< Transmogrify Parts >>--
					if Slot.TransmogrifyAnchor and C_Transmog.GetSlotInfo(Slot.ID, LE_TRANSMOG_TYPE_APPEARANCE) then
						_, _, Slot.TransmogrifyAnchor.SourceID = C_Transmog.GetSlotVisualInfo(Slot.ID, LE_TRANSMOG_TYPE_APPEARANCE)
						_, _, _, _, _, Slot.TransmogrifyAnchor.Link = C_TransmogCollection.GetAppearanceSourceInfo(Slot.TransmogrifyAnchor.SourceID)
						
						Slot.TransmogrifyAnchor:Show()
					end
					
					--<< Illusion Parts >>--
					if Slot.IllusionAnchor then
						IsTransmogrified, _, _, _, _, _, _, ItemTexture = C_Transmog.GetSlotInfo(Slot.ID, LE_TRANSMOG_TYPE_ILLUSION)
						
						if IsTransmogrified then
							Slot.IllusionAnchor.Texture:SetTexture(ItemTexture)
							_, _, Slot.IllusionAnchor.Link = C_TransmogCollection.GetIllusionSourceInfo(select(3, C_Transmog.GetSlotVisualInfo(Slot.ID, LE_TRANSMOG_TYPE_ILLUSION)))
							
							Slot.IllusionAnchor:Show()
						end
					end
					
					--[[ Check Error
					if KF.db.Modules.Armory.Character.NoticeMissing ~= false then
						if (not Slot.IsEnchanted and Info.Armory_Constants.EnchantableSlots[SlotName]) or ((SlotName == 'Finger0Slot' or SlotName == 'Finger1Slot') and self.PlayerProfession.Enchanting and self.PlayerProfession.Enchanting >= 550 and not Slot.IsEnchanted) then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
						elseif self.PlayerProfession.Engineering and ((SlotName == 'BackSlot' and self.PlayerProfession.Engineering >= 380) or (SlotName == 'HandsSlot' and self.PlayerProfession.Engineering >= 400) or (SlotName == 'WaistSlot' and self.PlayerProfession.Engineering >= 380)) and not UsableEffect then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110403)..'|r : '..L['Missing Tinkers']
						elseif SlotName == 'ShoulderSlot' and self.PlayerProfession.Inscription and Info.Armory_EnchantList.Profession_Inscription and self.PlayerProfession.Inscription >= Info.Armory_EnchantList.Profession_Inscription and not KF.Table.ItemEnchant_Profession_Inscription[(ItemData[3])] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110400)..'|r : '..L['This is not profession only.']
						elseif SlotName == 'WristSlot' and self.PlayerProfession.LeatherWorking and Info.Armory_EnchantList.Profession_LeatherWorking and self.PlayerProfession.LeatherWorking >= Info.Armory_EnchantList.Profession_LeatherWorking and not KF.Table.ItemEnchant_Profession_LeatherWorking[(ItemData[3])] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110423)..'|r : '..L['This is not profession only.']
						elseif SlotName == 'BackSlot' and self.PlayerProfession.Tailoring and Info.Armory_EnchantList.Profession_Tailoring then
							for EnchantID, NeedLevel in pairs(Info.Armory_EnchantList.Profession_Tailoring) do
								if self.PlayerProfession.Tailoring >= NeedLevel then
									if EnchantID == ItemTable[3] then
										ErrorDetected = nil
										break
									else
										ErrorDetected = true
									end
								end
							end
							
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110426)..'|r : '..L['This is not profession only.']
						end
						
						if GemCount_Enable > GemCount_Now or GemCount_Enable > GemCount or GemCount_Now > GemCount then
							ErrorDetected = true
							
							Slot.SocketWarning:Show()
							
							if GemCount_Enable > GemCount_Now then
								if SlotName == 'WaistSlot' then
									if TrueItemLevel < 300 then
										_, Slot.SocketWarning.Link = GetItemInfo(41611)	
									elseif TrueItemLevel < 417 then
										_, Slot.SocketWarning.Link = GetItemInfo(55054)
									else
										_, Slot.SocketWarning.Link = GetItemInfo(90046)
									end
									
									Slot.SocketWarning.Message = L['Missing Buckle']
									
									Slot.SocketWarning:SetScript('OnClick', function(self, button)
										local itemName, itemLink
										
										if TrueItemLevel < 300 then
											itemName, itemLink = GetItemInfo(41611)
										elseif TrueItemLevel < 417 then
											itemName, itemLink = GetItemInfo(55054)
										else
											itemName, itemLink = GetItemInfo(90046)
										end
										
										if HandleModifiedItemClick(itemLink) then
										elseif IsShiftKeyDown() then
											if button == 'RightButton' then
												SocketInventoryItem(Slot.ID)
											elseif BrowseName and BrowseName:IsVisible() then
												AuctionFrameBrowse_Reset(BrowseResetButton)
												BrowseName:SetText(itemName)
												BrowseName:SetFocus()
											end
										end
									end)
								elseif SlotName == 'HandsSlot' then
									Slot.SocketWarning.Link = GetSpellLink(114112)
									Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
								elseif SlotName == 'WristSlot' then
									Slot.SocketWarning.Link = GetSpellLink(113263)
									Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
								end
							else
								Slot.SocketWarning.Message = '|cffff5678'..(GemCount_Now - GemCount)..'|r '..L['Empty Socket']
							end
						end
					end
					]]
				else
					NeedUpdate = true
				end
			end
			
			if NeedUpdate then
				NeedUpdateList = NeedUpdateList or {}
				table.insert(NeedUpdateList, SlotName)
			end
		end
		
		-- Change Gradation
		if ItemLink and KF.db.Modules.Armory.Character.Gradation.Display then
			Slot.Gradation:Show()
		else
			Slot.Gradation:Hide()
		end
		if ErrorDetected and KF.db.Modules.Armory.Character.NoticeMissing then
			Slot.Gradation:SetVertexColor(1, 0, 0)
			Slot.Gradation:Show()
		else
			Slot.Gradation:SetVertexColor(unpack(KF.db.Modules.Armory.Character.Gradation.Color))
		end
	end
	
	self.AverageItemLevel:SetText(KF:Color_Value(STAT_AVERAGE_ITEM_LEVEL)..' : '..format('%.2f', select(2, GetAverageItemLevel())))
	
	if NeedUpdateList then
		self.GearUpdated = NeedUpdateList
		return true
	end
	
	self.GearUpdated = true
	
	if ArtifactMonitor_RequireUpdate then
		CA:LegionArtifactMonitor_UpdateLayout()
	end
end


do --<< Artifact Monitor >>
	local EnchantError, EnchantError_MainHand, EnchantError_SecondaryHand
	function CA:LegionArtifactMonitor_UpdateLayout()
		if Legion_ArtifactData.ItemID then
			self.SecondaryHandSlot.Gradation:SetAlpha(0)
			self.SecondaryHandSlot.ItemLevel:SetAlpha(0)
			self.SecondaryHandSlot.EnchantWarning:SetAlpha(0)
			self.SecondaryHandSlot.EnchantWarning:Disable()
			self.SecondaryHandSlot.SocketWarning:SetAlpha(0)
			self.SecondaryHandSlot.SocketWarning:Disable()
			for i = 1, MAX_NUM_SOCKETS do
				self.MainHandSlot['Socket'..i]:SetAlpha(0)
				self.MainHandSlot['Socket'..i].Socket:Disable()
				self.SecondaryHandSlot['Socket'..i]:SetAlpha(0)
				self.SecondaryHandSlot['Socket'..i].Socket:Disable()
			end
			
			self.ArtifactMonitor:Show()
			CA:LegionArtifactMonitor_UpdateData()
			
			if KF.db.Modules.Armory.Character.Gradation.Display then
				self.ArtifactMonitor.Gradation:SetVertexColor(unpack(KF.db.Modules.Armory.Character.Gradation.Color))
				self.ArtifactMonitor.Gradation:Show()
			else
				self.ArtifactMonitor.Gradation:Hide()
			end
			
			if Legion_ArtifactData.MajorSlot == 'SecondaryHandSlot' or self.SecondaryHandSlot.ItemRarity == 6 then
				-- << Case : Artifact's core in SecondaryHandSlot (ex: Protection Paladin's Artifact) >>
				-- << Case : Artifacts that using both of Hand slot >>
				
				do	-- Notice Missing
					EnchantError = nil
					EnchantError_MainHand = self.MainHandSlot.ItemEnchant:GetText()
					EnchantError_SecondaryHand = self.SecondaryHandSlot.ItemEnchant:GetText()
					
					if self.MainHandSlot.IsEnchanted == false and EnchantError_MainHand ~= nil then
						EnchantError = EnchantError_MainHand..'|r ('..INVTYPE_WEAPONMAINHAND..')'
					elseif self.SecondaryHandSlot.IsEnchanted == false and EnchantError_SecondaryHand ~= nil then
						EnchantError = EnchantError_SecondaryHand..'|r ('..INVTYPE_WEAPONOFFHAND..')'
					end
					
					self.MainHandSlot.ItemEnchant:SetText(EnchantError)
					
					if KF.db.Modules.Armory.Character.NoticeMissing then
						if EnchantError then
							self.MainHandSlot.EnchantWarning:Show()
						end
						if self.ArtifactMonitor.SocketWarning:IsShown() then
							EnchantError= true
						end
						
						if EnchantError then
							self.MainHandSlot.Gradation:SetVertexColor(1, 0, 0)
						end
					end
				end
				
				self.ArtifactMonitor:Point('LEFT', CharacterSecondaryHandSlot, 1, 0)
				--self.ArtifactMonitor:Width(210)
			else
				-- << Case : Mainhand only artifact >>
				-- Hide SecondaryHandSlot and move MainHandSlot to center.
				
				CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 205, 14)
				CharacterSecondaryHandSlot:Hide()
				
				self.ArtifactMonitor:Point('LEFT', CharacterMainHandSlot, 1, 0)
				--self.ArtifactMonitor:Width(232)
				return
			end
		else
			self.SecondaryHandSlot.Gradation:SetAlpha(1)
			self.SecondaryHandSlot.ItemLevel:SetAlpha(1)
			self.SecondaryHandSlot.EnchantWarning:SetAlpha(1)
			self.SecondaryHandSlot.EnchantWarning:Enable()
			self.SecondaryHandSlot.SocketWarning:SetAlpha(1)
			self.SecondaryHandSlot.SocketWarning:Enable()
			for i = 1, MAX_NUM_SOCKETS do
				self.MainHandSlot['Socket'..i]:SetAlpha(1)
				self.MainHandSlot['Socket'..i].Socket:Enable()
				self.SecondaryHandSlot['Socket'..i]:SetAlpha(1)
				self.SecondaryHandSlot['Socket'..i].Socket:Enable()
			end
			
			self.ArtifactMonitor:Hide()
		end
		
		-- Restore Original Layout
		CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 185, 14)
		
		CharacterSecondaryHandSlot:Show()
	end
	
	
	function CA:LegionArtifactMonitor_UpdateData()
		Artifact_ItemID, _, _, _, Artifact_Power, Artifact_Rank = C_ArtifactUI.GetEquippedArtifactInfo()
		
		if Artifact_ItemID then
			Legion_ArtifactData.ItemID = Artifact_ItemID
			Legion_ArtifactData.Rank = Artifact_Rank
			Legion_ArtifactData.Power = Artifact_Power
			Legion_ArtifactData.AvailablePoint, Legion_ArtifactData.XP, Legion_ArtifactData.XPForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(Artifact_Rank, Artifact_Power)
			Legion_ArtifactData.RemainXP = Legion_ArtifactData.XPForNextPoint - Legion_ArtifactData.XP
			
			self.ArtifactMonitor.TraitRank:SetText(RANK..' : '..COLORSTRING_ARTIFACT..Artifact_Rank)
			self.ArtifactMonitor.CurrentPower:SetAnimatedValue(Legion_ArtifactData.Power)
			self.ArtifactMonitor.RequirePower:SetText(BreakUpLargeNumbers(Legion_ArtifactData.XPForNextPoint))
			
			if Legion_ArtifactData.AvailablePoint > 0 then
				self.ArtifactMonitor.BarExpected.Message:SetText(format(L['%s Points Available!!'], KF:Color_Value(Legion_ArtifactData.AvailablePoint)))
			else
				self.ArtifactMonitor.BarExpected.Message:SetText()
			end
			
			self.ArtifactMonitor.Bar:SetAnimatedValues(Legion_ArtifactData.XP, 0, Legion_ArtifactData.XPForNextPoint, Legion_ArtifactData.Rank + Legion_ArtifactData.AvailablePoint)
			self.ArtifactMonitor.BarExpected:SetMinMaxValues(0, Legion_ArtifactData.XPForNextPoint)
		end
		
		self.ArtifactMonitor.UpdateData = true
	end
	
	
	local escapes = {
		['|c%x%x%x%x%x%x%x%x'] = '', -- color start
		['|r'] = '', -- color end
	}
	local function CleanString(str)
		for k, v in pairs(escapes) do
			str = str:gsub(k, v)
		end
		return str
	end

	local PowerItemLink, SearchingText, SearchingPhase, CurrentItemPower, TotalPower, LowestPower, LowestPower_BagID, LowestPower_SlotID, LowestPower_Link
	function CA:LegionArtifactMonitor_SearchPowerItem()
		if not self.ArtifactMonitor.UpdateData then
			CA:LegionArtifactMonitor_UpdateData()
		end
		
		LowestPower = nil
		TotalPower = 0
		
		if Legion_ArtifactData.ItemID then
			for BagID = 0, NUM_BAG_SLOTS do
				for SlotID = 1, GetContainerNumSlots(BagID) do
					_, _, _, _, _, _, PowerItemLink = GetContainerItemInfo(BagID, SlotID)
					
					if PowerItemLink then
						self:ClearTooltip(self.ArtifactMonitor.ScanTT)
						self.ArtifactMonitor.ScanTT:SetHyperlink(PowerItemLink)
						SearchingPhase = 1
						CurrentItemPower = 0
						
						for i = 1, self.ArtifactMonitor.ScanTT:NumLines() do
							SearchingText = CleanString(_G['Knight_CharacterArmory_ArtifactScanTTTextLeft' .. i]:GetText())
							
							if SearchingPhase == 1 and SearchingText == ARTIFACT_POWER then
								SearchingPhase = 2
							elseif SearchingPhase == 2 and SearchingText:find(ITEM_SPELL_TRIGGER_ONUSE) then
								CurrentItemPower = tonumber(SearchingText:gsub(',', ''):match('%d+'))
								TotalPower = TotalPower + CurrentItemPower
								
								if not LowestPower or LowestPower > CurrentItemPower then
									LowestPower = CurrentItemPower
									LowestPower_BagID = BagID
									LowestPower_SlotID = SlotID
									LowestPower_Link = PowerItemLink
								end
								
								break
							end
						end
						
						if SearchingPhase == 2 and not (LowestPower and LowestPower > 0) then
							LowestPower = CurrentItemPower
							LowestPower_BagID = BagID
							LowestPower_SlotID = SlotID
							LowestPower_Link = PowerItemLink
						end
					end
				end
			end
			
			if LowestPower then
				self.ArtifactMonitor.AddPower.Texture:Show()
				self.ArtifactMonitor.AddPower.Button:Show()
				self.ArtifactMonitor.AddPower.Button.Link = LowestPower_Link
				
				if LowestPower > 0 then
					self.ArtifactMonitor.BarExpected.AvailablePower:SetText(KF:Color_Value('+'..BreakUpLargeNumbers(TotalPower)))
				else
					self.ArtifactMonitor.BarExpected.AvailablePower:SetText()
				end
				
				if TotalPower + Legion_ArtifactData.XP > Legion_ArtifactData.XPForNextPoint then
					TotalPower = Legion_ArtifactData.XPForNextPoint
				else
					TotalPower = TotalPower + Legion_ArtifactData.XP
				end
			else
				self.ArtifactMonitor.AddPower.Texture:Hide()
				self.ArtifactMonitor.AddPower.Button:Hide()
				self.ArtifactMonitor.AddPower.Button.Link = nil
				
				self.ArtifactMonitor.BarExpected.AvailablePower:SetText()
				self:LegionArtifactMonitor_ClearPowerItemSearching()
			end
			
			self.ArtifactMonitor.BarExpected:SetValue(TotalPower)
		end
		
		self.ArtifactMonitor.SearchPowerItem = true
	end
	
	
	function CA:LegionArtifactMonitor_ClearPowerItemSearching()
		if self.ArtifactMonitor.NowSearchingPowerItem and E.private.bags.enable and ElvUI_ContainerFrameEditBox and ElvUI_ContainerFrameEditBox:GetText() == 'POWER' then
			ElvUI_BagModule.ResetAndClear(ElvUI_ContainerFrameEditBox)
			self.ArtifactMonitor.NowSearchingPowerItem = nil
		end
	end
end


function CA:Update_BG()
	if KF.db.Modules.Armory.Character.Backdrop.SelectedBG == 'HIDE' then
		self.BG:SetTexture(nil)
	elseif KF.db.Modules.Armory.Character.Backdrop.SelectedBG == 'CUSTOM' then
		self.BG:SetTexture(KF.db.Modules.Armory.Character.Backdrop.CustomAddress)
	else
		self.BG:SetTexture(Info.Armory_Constants.BlizzardBackdropList[KF.db.Modules.Armory.Character.Backdrop.SelectedBG] or 'Interface\\AddOns\\ElvUI_KnightFrame\\Modules\\Armory\\Media\\Graphics\\'..KF.db.Modules.Armory.Character.Backdrop.SelectedBG)
	end
end


function CA:Update_Display(Force)
	local Slot, Mouseover, SocketVisible
	
	if (PaperDollFrame:IsMouseOver() and (KF.db.Modules.Armory.Character.Level.Display == 'MouseoverOnly' or KF.db.Modules.Armory.Character.Enchant.Display == 'MouseoverOnly' or KF.db.Modules.Armory.Character.Durability.Display == 'MouseoverOnly' or KF.db.Modules.Armory.Character.Gem.Display == 'MouseoverOnly')) or Force then
		for _, SlotName in pairs(Info.Armory_Constants.GearList) do
			Slot = self[SlotName]
			Mouseover = Slot:IsMouseOver()
			
			if Slot.ItemLevel then
				if KF.db.Modules.Armory.Character.Level.Display == 'Always' or Mouseover and KF.db.Modules.Armory.Character.Level.Display == 'MouseoverOnly' then
					Slot.ItemLevel:Show()
				else
					Slot.ItemLevel:Hide()
				end
			end
			
			if Slot.ItemEnchant then
				if KF.db.Modules.Armory.Character.Enchant.Display == 'Always' or Mouseover and KF.db.Modules.Armory.Character.Enchant.Display == 'MouseoverOnly' then
					Slot.ItemEnchant:Show()
				elseif KF.db.Modules.Armory.Character.Enchant.Display ~= 'Always' and not (KF.db.Modules.Armory.Character.NoticeMissing and not Slot.IsEnchanted) then
					Slot.ItemEnchant:Hide()
				end
			end
			
			if Slot.Durability then
				if KF.db.Modules.Armory.Character.Durability.Display == 'Always' or Mouseover and KF.db.Modules.Armory.Character.Durability.Display == 'MouseoverOnly' or KF.db.Modules.Armory.Character.Durability.Display == 'DamagedOnly' then
					Slot.Durability:Show()
					
					if Slot.Socket1 then
						if Slot.Durability:GetText() == '' or KF.db.Modules.Armory.Character.Durability.Display == 'MouseoverOnly' and not Mouseover then
							Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 2)
						else
							Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot.Durability, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Durability:GetText() and (Slot.Direction == 'LEFT' and 3 or -1) or 0, Slot.Durability:GetText() and -1 or 0)
						end
					end
				else
					Slot.Durability:Hide()
					
					Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..SlotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 2)
				end
			end
			
			
			SocketVisible = nil
			
			if Slot.Socket1 then
				for i = 1, MAX_NUM_SOCKETS do
					if KF.db.Modules.Armory.Character.Gem.Display == 'Always' or Mouseover and KF.db.Modules.Armory.Character.Gem.Display == 'MouseoverOnly' then
						if Slot['Socket'..i].GemType then
							Slot['Socket'..i]:Show()
							Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
						end
					else
						if SocketVisible == nil then
							SocketVisible = false
						end
						
						if Slot['Socket'..i].GemType and KF.db.Modules.Armory.Character.NoticeMissing and not Slot['Socket'..i].GemItemID then
							SocketVisible = true
						end
					end
				end
				
				if SocketVisible then
					for i = 1, MAX_NUM_SOCKETS do
						if Slot['Socket'..i].GemType then
							Slot['Socket'..i]:Show()
							Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
						end
					end
				elseif SocketVisible == false then
					for i = 1, MAX_NUM_SOCKETS do
						Slot['Socket'..i]:Hide()
					end
					
					Slot.SocketWarning:Point(Slot.Direction, Slot.Socket1)
				end
			end
			
			if Force == SlotName then
				break
			end
		end
		
		
	end
end


KF.Modules[#KF.Modules + 1] = 'CharacterArmory'
KF.Modules.CharacterArmory = function(RemoveOrder)
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.Armory and KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable ~= false then
		Info.CharacterArmory_Activate = true
		
		-- Setting frame
		PANEL_DEFAULT_WIDTH = CharacterArmory_Panel_Width
		CHARACTERFRAME_EXPANDED_WIDTH = CharacterArmory_Panel_Width_Expand
		CharacterFrame:SetHeight(444)
		
		-- Move right equipment slots
		CharacterHandsSlot:SetPoint('TOPRIGHT', CharacterFrameInsetRight, 'TOPLEFT', -4, -2)
		
		-- Move bottom equipment slots
		CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 185, 14)
		
		if CA.Setup_CharacterArmory then
			CA:Setup_CharacterArmory()
		else
			CA:Show()
		end
		CA:ScanData()
		CA:Update_BG()
		
		-- Model Frame
		CharacterModelFrame:ClearAllPoints()
		CharacterModelFrame:SetPoint('TOPLEFT', CharacterHeadSlot)
		CharacterModelFrame:SetPoint('RIGHT', CharacterHandsSlot)
		CharacterModelFrame:SetPoint('BOTTOM', CharacterMainHandSlot)
		CharacterModelFrameBackgroundOverlay:Hide()
		CharacterModelFrame.BackgroundTopLeft:Hide()
		CharacterModelFrame.BackgroundTopRight:Hide()
		CharacterModelFrame.BackgroundBotLeft:Hide()
		CharacterModelFrame.BackgroundBotRight:Hide()
		
		if PaperDollFrame:IsShown() then
			CharacterFrame:SetWidth(CharacterFrame.Expanded and CharacterArmory_Panel_Width_Expand or CharacterArmory_Panel_Width)
			CharacterFrameInsetRight:SetPoint('TOPLEFT', CharacterFrameInset, 'TOPRIGHT', 110, 0)
			--CharacterFrameExpandButton:SetPoint('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', -3, 7)
		end
		
		-- Run KnightArmory
		CA:RegisterEvent('SOCKET_INFO_SUCCESS')
		CA:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
		CA:RegisterEvent('UNIT_INVENTORY_CHANGED')
		CA:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
		CA:RegisterEvent('TRANSMOGRIFY_SUCCESS')
		CA:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		CA:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
		CA:RegisterEvent('PLAYER_ENTERING_WORLD')
		CA.ArtifactMonitor:RegisterEvent('ARTIFACT_UPDATE')
		CA.ArtifactMonitor:RegisterEvent('ARTIFACT_XP_UPDATE')
		CA.ArtifactMonitor:RegisterEvent('BAG_UPDATE')
		CA.ArtifactMonitor:RegisterEvent('PLAYER_ENTERING_WORLD')
		
		--[[
		KF_KnightArmory.CheckButton:Show()
		KF_KnightArmory_NoticeMissing:EnableMouse(true)
		KF_KnightArmory_NoticeMissing.text:SetTextColor(1, 1, 1)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')
		]]
	elseif Info.CharacterArmory_Activate then
		Info.CharacterArmory_Activate = nil
		
		-- Setting frame to default
		PANEL_DEFAULT_WIDTH = Default_Panel_Width
		CHARACTERFRAME_EXPANDED_WIDTH = Default_Panel_Width_Expand
		CharacterFrame:SetHeight(424)
		CharacterFrame:SetWidth(PaperDollFrame:IsShown() and CharacterFrame.Expanded and CHARACTERFRAME_EXPANDED_WIDTH or PANEL_DEFAULT_WIDTH)
		CharacterFrameInsetRight:SetPoint(unpack(DefaultPosition.InsetDefaultPoint))
		--CharacterFrameExpandButton:SetPoint(unpack(ExpandButtonDefaultPoint))
		
		-- Move rightside equipment slots to default position
		CharacterHandsSlot:SetPoint('TOPRIGHT', CharacterFrameInset, 'TOPRIGHT', -4, -2)
		
		-- Move bottom equipment slots to default position
		CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 130, 16)
		
		-- Model Frame
		CharacterModelFrame:ClearAllPoints()
		CharacterModelFrame:Size(231, 320)
		CharacterModelFrame:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 52, -66)
		CharacterModelFrame.BackgroundTopLeft:Show()
		CharacterModelFrame.BackgroundTopRight:Show()
		CharacterModelFrame.BackgroundBotLeft:Show()
		CharacterModelFrame.BackgroundBotRight:Show()
		
		-- Turn off ArmoryFrame
		CA:Hide()
		CA:UnregisterAllEvents()
		CA.ArtifactMonitor:UnregisterAllEvents()
		
		--[[
		KF_KnightArmory.CheckButton:Hide()
		KF_KnightArmory_NoticeMissing:EnableMouse(false)
		KF_KnightArmory_NoticeMissing.text:SetTextColor(0.31, 0.31, 0.31)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
		]]
	end
end