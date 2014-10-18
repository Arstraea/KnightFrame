local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade Character Frame's Item Info like Wow-Armory		>>--
--------------------------------------------------------------------------------
local CA = CreateFrame('Frame', 'CharacterArmory', PaperDollFrame)
local SlotIDList = {}

CA.elapsed = 0
CA.Delay_Updater = .5

do --<< Button Script >>--
	CA.OnEnter = function(self)
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
	
	CA.OnLeave = function(self)
		self:SetScript('OnUpdate', nil)
		GameTooltip:Hide()
	end
	
	CA.GemSocket_OnEnter = function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		
		local Parent = self:GetParent()
		
		if Parent.GemItemID then
			if type(Parent.GemItemID) == 'number' then
				if GetItemInfo(Parent.GemItemID) then
					GameTooltip:SetHyperlink(select(2, GetItemInfo(Parent.GemItemID)))
				else
					self:SetScript('OnUpdate', function()
						if GetItemInfo(Parent.GemItemID) then
							CA.GemSocket_OnEnter(self)
							self:SetScript('OnUpdate', nil)
						end
					end)
					return
				end
			else
				GameTooltip:ClearLines()
				GameTooltip:AddLine('|cffffffff'..Parent.GemItemID)
			end
		elseif Parent.GemType then
			GameTooltip:ClearLines()
			GameTooltip:AddLine('|cffffffff'.._G['EMPTY_SOCKET_'..Parent.GemType])
		end
		
		GameTooltip:Show()
	end
	
	CA.GemSocket_OnClick = function(self, button)
		self = self:GetParent()
		
		if CursorHasItem() then
			local CursorType, _, ItemLink = GetCursorInfo()
			
			-- Check cursor item is gem type
			if CursorType == 'item' and select(6, GetItemInfo(ItemLink)) == select(8, GetAuctionItemClasses()) then
				SocketInventoryItem(GetInventorySlotInfo(self.slotName))
				ClickSocketButton(self.socketNumber)
				
				return
			end
		end
		
		if self.GemItemID then
			local itemName, itemLink = GetItemInfo(self.GemItemID)
			
			if not IsShiftKeyDown() then
				SetItemRef(itemLink, itemLink, 'LeftButton')
			else
				if button == 'RightButton' then
					SocketInventoryItem(GetInventorySlotInfo(self.slotName))
				elseif HandleModifiedItemClick(itemLink) then
				elseif BrowseName and BrowseName:IsVisible() then
					AuctionFrameBrowse_Reset(BrowseResetButton)
					BrowseName:SetText(itemName)
					BrowseName:SetFocus()
				end
			end
		end
	end
	
	CA.GemSocket_OnRecieveDrag = function(self)
		self = self:GetParent()
		
		if CursorHasItem() then
			local CursorType, _, ItemLink = GetCursorInfo()
			
			if CursorType == 'item' and select(6, GetItemInfo(ItemLink)) == select(8, GetAuctionItemClasses()) then
				SocketInventoryItem(GetInventorySlotInfo(self.slotName))
				ClickSocketButton(self.socketNumber)
			end
		end
	end
end


function CA:Setup_CharacterArmory()
	--<< Core >>--
	self:Point('TOPLEFT', CharacterFrameInset, 10, 20)
	self:Point('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', -10, 5)
	
	--<< Updater >>--
	local args
	self:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'SOCKET_INFO_SUCCESS' or Event == 'ITEM_UPGRADE_MASTER_UPDATE' or Event == 'TRANSMOGRIFY_UPDATE' or Event == 'PLAYER_ENTERING_WORLD' then
			if Event == 'TRANSMOGRIFY_UPDATE' then
				--print(...)
			end
			self.GearUpdated = nil
			self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
		elseif Event == 'UNIT_INVENTORY_CHANGED' then
			args = ...
			
			if args == 'player' then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
			end
		elseif Event == 'PLAYER_EQUIPMENT_CHANGED' then
			args = ...
			
			self.GearUpdated = type(self.GearUpdated) == 'table' and self.GearUpdated or {}
			self.GearUpdated[#self.GearUpdated + 1] = SlotIDList[args]
			self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
		elseif Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			_, Event, _, _, _, _, _, _, args = ...
			
			if Event == 'ENCHANT_APPLIED' and args == E.myname then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
			end
		elseif Event == 'UPDATE_INVENTORY_DURABILITY' then
			self.DurabilityUpdated = nil
			self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
		end
	end)
	hooksecurefunc('CharacterFrame_Collapse', function() if Info.CharacterArmory_Activate then CharacterFrame:SetWidth(PaperDollFrame:IsShown() and 448 or PANEL_DEFAULT_WIDTH) end end)
	hooksecurefunc('CharacterFrame_Expand', function() if Info.CharacterArmory_Activate then CharacterFrame:SetWidth(650) end end)
	hooksecurefunc('ToggleCharacter', function(frameType) if frameType ~= 'PaperDollFrame' then CharacterFrame:SetWidth(PANEL_DEFAULT_WIDTH) end end)
	hooksecurefunc('PaperDollFrame_SetLevel', function()
		if Info.CharacterArmory_Activate then 
			CharacterLevelText:SetText('|c'..RAID_CLASS_COLORS[E.myclass].colorStr..CharacterLevelText:GetText())

			--Maybe Adjust Name, Level, Avg iLvL if bliz skinning is off?
			CharacterFrameTitleText:ClearAllPoints()
			CharacterFrameTitleText:Point('TOP', self, 0, 15)
			CharacterFrameTitleText:SetParent(self)
			CharacterLevelText:ClearAllPoints()
			CharacterLevelText:SetPoint('TOP', CharacterFrameTitleText, 'BOTTOM', 0, -4)
			CharacterLevelText:SetParent(self)
		end
	end)
	
	--<< Background >>--
	self.BG = self:CreateTexture(nil, 'OVERLAY')
	self.BG:SetInside()
	self.BG:SetTexture(DB.Modules.Armory.Character.BackgroundImage)
	
	--<< Change Model Frame's frameLevel >>--
	CharacterModelFrame:SetFrameLevel(self:GetFrameLevel() + 2)
	
	--<< Average Item Level >>--
	KF:TextSetting(self, nil, { Tag = 'AverageItemLevel', FontSize = 12 }, 'BOTTOM', CharacterModelFrame, 'TOP', 0, 14)
	local function ValueColorUpdate()
		self.AverageItemLevel:SetText(KF:Color_Value(L['Average'])..' : '..format('%.2f', select(2, GetAverageItemLevel())))
	end
	E.valueColorUpdateFuncs[ValueColorUpdate] = true
	
	-- Create each equipment slots gradation, text, gem socket icon.
	local Slot
	for i, slotName in pairs(Info.Armory_Constants.GearList) do
		-- Equipment Tag
		Slot = CreateFrame('Frame', nil, self)
		Slot:Size(130, 41)
		Slot:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 1)
		Slot.Direction = i%2 == 1 and 'LEFT' or 'RIGHT'
		Slot.ID, Slot.EmptyTexture = GetInventorySlotInfo(slotName)
		Slot:Point(Slot.Direction, _G['Character'..slotName], Slot.Direction == 'LEFT' and -1 or 1, 0)
		
		-- Grow each equipment slot's frame level
		_G['Character'..slotName]:SetFrameLevel(Slot:GetFrameLevel() + 1)
		
		-- Gradation
		Slot.Gradation = Slot:CreateTexture(nil, 'OVERLAY')
		Slot.Gradation:SetInside()
		Slot.Gradation:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Gradation')
		if Slot.Direction == 'LEFT' then
			Slot.Gradation:SetTexCoord(0, 1, 0, 1)
		else
			Slot.Gradation:SetTexCoord(1, 0, 0, 1)
		end
		
		if slotName ~= 'ShirtSlot' and slotName ~= 'TabardSlot' then
			-- Item Level
			KF:TextSetting(Slot, nil, { Tag = 'ItemLevel', FontSize = 10, directionH = Slot.Direction }, 'TOP'..Slot.Direction, _G['Character'..slotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)
			
			-- Enchantment Name
			KF:TextSetting(Slot, nil, { Tag = 'ItemEnchant', FontSize = 8, directionH = Slot.Direction }, Slot.Direction, _G['Character'..slotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 1)
			Slot.EnchantWarning = CreateFrame('Button', nil, Slot)
			Slot.EnchantWarning:Size(12)
			Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
			Slot.EnchantWarning.Texture:SetInside()
			Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Warning-Small')
			Slot.EnchantWarning:Point(Slot.Direction, Slot.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
			Slot.EnchantWarning:SetScript('OnEnter', self.OnEnter)
			Slot.EnchantWarning:SetScript('OnLeave', self.OnLeave)
			
			-- Durability
			KF:TextSetting(Slot, nil, { Tag = 'Durability', FontSize = 10, directionH = Slot.Direction }, 'BOTTOM'..Slot.Direction, _G['Character'..slotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 3)
			
			-- Gem Socket
			for i = 1, MAX_NUM_SOCKETS do
				Slot['Socket'..i] = CreateFrame('Frame', nil, Slot)
				Slot['Socket'..i]:Size(12)
				Slot['Socket'..i]:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot['Socket'..i]:SetBackdropColor(0, 0, 0, 1)
				Slot['Socket'..i]:SetBackdropBorderColor(0, 0, 0)
				Slot['Socket'..i]:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 1)
				
				Slot['Socket'..i].slotName = slotName
				Slot['Socket'..i].socketNumber = i
				
				Slot['Socket'..i].Socket = CreateFrame('Button', nil, Slot['Socket'..i])
				Slot['Socket'..i].Socket:SetBackdrop({
					bgFile = E.media.blankTex,
					edgeFile = E.media.blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				Slot['Socket'..i].Socket:SetInside()
				Slot['Socket'..i].Socket:SetFrameLevel(Slot['Socket'..i]:GetFrameLevel() + 1)
				Slot['Socket'..i].Socket:RegisterForClicks('AnyUp')
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
			Slot.SocketWarning:Size(12)
			Slot.SocketWarning:RegisterForClicks('AnyUp')
			Slot.SocketWarning.Texture = Slot.SocketWarning:CreateTexture(nil, 'OVERLAY')
			Slot.SocketWarning.Texture:SetInside()
			Slot.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Warning-Small')
			Slot.SocketWarning:SetScript('OnEnter', self.OnEnter)
			Slot.SocketWarning:SetScript('OnLeave', self.OnLeave)
		end
		
		SlotIDList[Slot.ID] = slotName
		self[slotName] = Slot
	end
	
	-- GameTooltip for counting gem sockets and getting enchant effects
	self.ScanTT = CreateFrame('GameTooltip', 'Knight_CharacterArmory_ScanTT', nil, 'GameTooltipTemplate')
	self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
	
	self.Setup_CharacterArmory = nil
end


function CA:CharacterArmory_DataSetting(elapsed)
	self.elapsed = self.elapsed + (elapsed or .1)
	
	if self.elapsed > 0 then
		self.elapsed = -self.Delay_Updater
		self.needUpdate = nil
		
		if not self.DurabilityUpdated then
			self.needUpdate = self:Update_Durability() or self.needUpdate
		end
		
		if self.GearUpdated ~= true then
			self.needUpdate = self:Update_Gear() or self.needUpdate
		end
		
		if not self.needUpdate and self:IsShown() then
			self.elapsed = 0
			self:SetScript('OnUpdate', nil)
		elseif self.needUpdate then
			self:SetScript('OnShow', function()
				self.elapsed = 0
				self:CharacterArmory_DataSetting()
				self:SetScript('OnShow', nil)
			end)
			self:SetScript('OnUpdate', self.CharacterArmory_DataSetting)
		end
	end
end


function CA:Update_Durability()
	local Slot, r, g, b, CurrentDurability, MaxDurability
	
	for _, slotName in pairs(Info.Armory_Constants.GearList) do
		Slot = self[slotName]
		CurrentDurability, MaxDurability = GetInventoryItemDurability(Slot.ID)
		
		if CurrentDurability and MaxDurability then
			r, g, b = E:ColorGradient((CurrentDurability / MaxDurability), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			Slot.Durability:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (CurrentDurability / MaxDurability) * 100)
			Slot.Socket1:Point('BOTTOM'..Slot.Direction, Slot.Durability, 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, -2)
		elseif Slot.Durability then
			Slot.Durability:SetText('')
			Slot.Socket1:Point('BOTTOM'..Slot.Direction, _G['Character'..slotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 3)
		end
	end
	
	self.DurabilityUpdated = true
end


function CA:ClearTooltip(tooltip)
	local tooltipName = tooltip:GetName()
	
	tooltip:ClearLines()
	for i = 1, 10 do
		_G[tooltipName..'Texture'..i]:SetTexture(nil)
		_G[tooltipName..'Texture'..i]:ClearAllPoints()
		_G[tooltipName..'Texture'..i]:Point('TOPLEFT', tooltip)
	end
end


function CA:Update_Gear()
	-- Get Player Profession
	local Prof1, Prof2 = GetProfessions()
	local Prof1_Level, Prof2_Level = 0, 0
	self.PlayerProfession = {}
	
	if Prof1 then Prof1, _, Prof1_Level = GetProfessionInfo(Prof1) end
	if Prof2 then Prof2, _, Prof2_Level = GetProfessionInfo(Prof2) end
	if Prof1 and Info.Armory_Constants.ProfessionList[Prof1] then self.PlayerProfession[(Info.Armory_Constants.ProfessionList[Prof1].Key)] = Prof1_Level end
	if Prof2 and Info.Armory_Constants.ProfessionList[Prof2] then self.PlayerProfession[(Info.Armory_Constants.ProfessionList[Prof2].Key)] = Prof2_Level end
	
	local ErrorDetected, needUpdate, needUpdateList
	local r, g, b
	local Slot, ItemLink, ItemData, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, ItemTexture, IsEnchanted, UsableEffect, CurrentLineText, GemID, GemCount_Default, GemCount_Enable, GemCount_Now, GemCount
	
	for _, slotName in pairs(self.GearUpdated or Info.Armory_Constants.GearList) do
		if not (slotName == 'ShirtSlot' or slotName == 'TabardSlot') then
			Slot = self[slotName]
			ItemLink = GetInventoryItemLink('player', Slot.ID)
			
			do --<< Clear Setting >>--
				needUpdate, ErrorDetected, TrueItemLevel, IsEnchanted, UsableEffect, ItemUpgradeID, ItemTexture = nil, nil, nil, nil, nil, nil, nil
				
				Slot.ItemLevel:SetText(nil)
				Slot.ItemEnchant:SetText(nil)
				for i = 1, MAX_NUM_SOCKETS do
					Slot['Socket'..i].Texture:SetTexture(nil)
					Slot['Socket'..i].Socket.Link = nil
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
			end
			
			if ItemLink then
				if not ItemLink:find('%[%]') then -- sometimes itemLink is malformed so we need to update when crashed
					do --<< Gem Parts >>--
						ItemData = { strsplit(':', ItemLink) }
						ItemData[4], ItemData[5], ItemData[6], ItemData[7] = 0, 0, 0, 0
						
						for i = 1, #ItemData do
							ItemData.FixedLink = (ItemData.FixedLink and ItemData.FixedLink..':' or '')..ItemData[i]
						end
						
						self:ClearTooltip(self.ScanTT)
						self.ScanTT:SetHyperlink(ItemData.FixedLink)
						
						GemCount_Default, GemCount_Now, GemCount = 0, 0, 0
						
						-- First, Counting default gem sockets
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['Knight_CharacterArmory_ScanTTTexture'..i]:GetTexture()
							
							if ItemTexture and ItemTexture:find('Interface\\ItemSocketingFrame\\') then
								GemCount_Default = GemCount_Default + 1
								Slot['Socket'..GemCount_Default].GemType = strupper(gsub(ItemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
							end
						end
						
						-- Second, Check if slot's item enable to adding a socket
						GemCount_Enable = GemCount_Default
						if (slotName == 'WaistSlot' and UnitLevel('player') >= 70) or -- buckle
							((slotName == 'WristSlot' or slotName == 'HandsSlot') and self.PlayerProfession.BlackSmithing and self.PlayerProfession.BlackSmithing >= 550) then -- BlackSmith
							
							GemCount_Enable = GemCount_Enable + 1
							Slot['Socket'..GemCount_Enable].GemType = 'PRISMATIC'
						end
						
						self:ClearTooltip(self.ScanTT)
						self.ScanTT:SetInventoryItem('player', Slot.ID)
						
						-- Apply current item's gem setting
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['Knight_CharacterArmory_ScanTTTexture'..i]:GetTexture()
							GemID = select(i, GetInventoryItemGems(Slot.ID))
							
							if Slot['Socket'..i].GemType and Info.Armory_Constants.GemColor[Slot['Socket'..i].GemType] then
								r, g, b = unpack(Info.Armory_Constants.GemColor[Slot['Socket'..i].GemType])
								Slot['Socket'..i].Socket:SetBackdropColor(r, g, b, .5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(r, g, b)
							else
								Slot['Socket'..i].Socket:SetBackdropColor(1, 1, 1, .5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(1, 1, 1)
							end
							
							if ItemTexture or GemID then
								Slot['Socket'..i]:Show()
								GemCount_Now = GemCount_Now + 1
								Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
								
								if GemID then
									GemCount = GemCount + 1
									Slot['Socket'..i].GemItemID = GemID
									
									_, Slot['Socket'..i].Socket.Link, _, _, _, _, _, _, _, ItemTexture = GetItemInfo(GemID)
									
									if ItemTexture then
										Slot['Socket'..i].Texture:SetTexture(ItemTexture)
									else
										needUpdate = true
									end
								end
							end
						end
						
						--print(slotName..' : ', GemCount_Default, GemCount_Enable, GemCount_Now, GemCount)
						if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
							needUpdate = true
						end
					end
					
					_, _, ItemRarity, BasicItemLevel, _, _, _, _, _, ItemTexture = GetItemInfo(ItemLink)
					r, g, b = GetItemQualityColor(ItemRarity)
					
					ItemUpgradeID = ItemLink:match(':(%d+)\124h%[')
					
					--<< Enchant Parts >>--
					for i = 1, self.ScanTT:NumLines() do
						CurrentLineText = _G['Knight_CharacterArmory_ScanTTTextLeft'..i]:GetText()
						
						if CurrentLineText:find(Info.Armory_Constants.ItemLevelKey_Alt) then
							TrueItemLevel = tonumber(CurrentLineText:match(Info.Armory_Constants.ItemLevelKey_Alt))
						elseif CurrentLineText:find(Info.Armory_Constants.ItemLevelKey) then
							TrueItemLevel = tonumber(CurrentLineText:match(Info.Armory_Constants.ItemLevelKey))
						elseif CurrentLineText:find(Info.Armory_Constants.EnchantKey) then
							CurrentLineText = CurrentLineText:match(Info.Armory_Constants.EnchantKey) -- Get enchant string
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_AGILITY_SHORT, AGI)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_SPIRIT_SHORT, SPI)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_STAMINA_SHORT, STA)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_STRENGTH_SHORT, STR)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_INTELLECT_SHORT, INT)
							CurrentLineText = gsub(CurrentLineText, ITEM_MOD_CRIT_RATING_SHORT, CRIT_ABBR) -- Critical is too long
							CurrentLineText = gsub(CurrentLineText, ' + ', '+') -- Remove space
							
							Slot.ItemEnchant:SetText('|cffceff00'..CurrentLineText)
							
							IsEnchanted = true
						elseif CurrentLineText:find(ITEM_SPELL_TRIGGER_ONUSE) then
							UsableEffect = true
						end
					end
					
					--<< ItemLevel Parts >>--
					if BasicItemLevel then
						if ItemUpgradeID then
							if ItemUpgradeID == '0' then
								ItemUpgradeID = nil
							else
								ItemUpgradeID = TrueItemLevel - BasicItemLevel
							end
						end
						
						Slot.ItemLevel:SetText((Slot.Direction == 'LEFT' and TrueItemLevel or '')..(ItemUpgradeID and (Slot.Direction == 'LEFT' and ' ' or '')..(Info.Armory_Constants.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r'..(Slot.Direction == 'RIGHT' and ' ' or '') or '')..(Slot.Direction == 'RIGHT' and TrueItemLevel or ''))
					end
					
					--[[ Check Error
					if DB.Modules.Armory.Character.NoticeMissing ~= false then
						if (not IsEnchanted and Info.Armory_Constants.EnchantableSlots[slotName]) or ((slotName == 'Finger0Slot' or slotName == 'Finger1Slot') and self.PlayerProfession.Enchanting and self.PlayerProfession.Enchanting >= 550 and not IsEnchanted) then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
						elseif self.PlayerProfession.Engineering and ((slotName == 'BackSlot' and self.PlayerProfession.Engineering >= 380) or (slotName == 'HandsSlot' and self.PlayerProfession.Engineering >= 400) or (slotName == 'WaistSlot' and self.PlayerProfession.Engineering >= 380)) and not UsableEffect then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110403)..'|r : '..L['Missing Tinkers']
						elseif slotName == 'ShoulderSlot' and self.PlayerProfession.Inscription and Info.Armory_EnchantList.Profession_Inscription and self.PlayerProfession.Inscription >= Info.Armory_EnchantList.Profession_Inscription and not KF.Table.ItemEnchant_Profession_Inscription[(ItemData[3])] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110400)..'|r : '..L['This is not profession only.']
						elseif slotName == 'WristSlot' and self.PlayerProfession.LeatherWorking and Info.Armory_EnchantList.Profession_LeatherWorking and self.PlayerProfession.LeatherWorking >= Info.Armory_EnchantList.Profession_LeatherWorking and not KF.Table.ItemEnchant_Profession_LeatherWorking[(ItemData[3])] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110423)..'|r : '..L['This is not profession only.']
						elseif slotName == 'BackSlot' and self.PlayerProfession.Tailoring and Info.Armory_EnchantList.Profession_Tailoring then
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
								if slotName == 'WaistSlot' then
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
								elseif slotName == 'HandsSlot' then
									Slot.SocketWarning.Link = GetSpellLink(114112)
									Slot.SocketWarning.Message = '|cff71d5ff'..GetSpellInfo(110396)..'|r : '..L['Missing Socket']
								elseif slotName == 'WristSlot' then
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
					needUpdate = true
				end
			end
			
			-- Change Gradation
			if ErrorDetected and DB.Modules.Armory.Character.NoticeMissing ~= false then
				Slot.Gradation:SetVertexColor(1, 0, 0)
			else
				Slot.Gradation:SetVertexColor(unpack(DB.Modules.Armory.Character.GradationColor))
			end
			
			if needUpdate then
				needUpdateList = needUpdateList or {}
				needUpdateList[#needUpdateList + 1] = slotName
			end
		end
	end
	
	self.AverageItemLevel:SetText(KF:Color_Value(STAT_AVERAGE_ITEM_LEVEL)..' : '..format('%.2f', select(2, GetAverageItemLevel())))
	
	if needUpdateList then
		self.GearUpdated = needUpdateList
		return true
	end
	
	self.GearUpdated = true
end


KF.Modules[#KF.Modules + 1] = 'CharacterArmory'
KF.Modules.CharacterArmory = function(RemoveOrder)
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.Armory and DB.Modules.Armory.Character and DB.Modules.Armory.Character.Enable ~= false then
		Info.CharacterArmory_Activate = true
		
		-- Setting frame
		CharacterFrame:SetHeight(444)
		CharacterFrameInsetRight:SetPoint('TOPLEFT', CharacterFrameInset, 'TOPRIGHT', 110, 0)
		CharacterFrameExpandButton:SetPoint('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', 0, 1)
		
		-- Move right equipment slots
		CharacterHandsSlot:SetPoint('TOPRIGHT', CharacterFrameInsetRight, 'TOPLEFT', -4, -2)
		
		-- Move bottom equipment slots
		CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 185, 14)
		
		-- Model Frame
		CharacterModelFrame:Size(341, 302)
		CharacterModelFrame:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 52, -90)
		CharacterModelFrame.BackgroundTopLeft:Hide()
		CharacterModelFrame.BackgroundTopRight:Hide()
		CharacterModelFrame.BackgroundBotLeft:Hide()
		CharacterModelFrame.BackgroundBotRight:Hide()
		
		if CA.Setup_CharacterArmory then
			CA:Setup_CharacterArmory()
		else
			CA:Show()
		end
		CA:CharacterArmory_DataSetting()
		
		-- Run KnightArmory
		CA:RegisterEvent('SOCKET_INFO_SUCCESS')
		CA:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
		CA:RegisterEvent('UNIT_INVENTORY_CHANGED')
		CA:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
		CA:RegisterEvent('TRANSMOGRIFY_UPDATE')
		CA:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		CA:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
		CA:RegisterEvent('PLAYER_ENTERING_WORLD')
		
		--[[
		KF_KnightArmory.CheckButton:Show()
		KF_KnightArmory_NoticeMissing:EnableMouse(true)
		KF_KnightArmory_NoticeMissing.text:SetTextColor(1, 1, 1)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')
		]]
	elseif Info.CharacterArmory_Activate then
		Info.CharacterArmory_Activate = nil
		
		-- Setting frame to default
		CharacterFrame:SetHeight(424)
		CharacterFrameInsetRight:SetPoint('TOPLEFT', CharacterFrameInset, 'TOPRIGHt', 1, 0)
		CharacterFrameExpandButton:SetPoint('BOTTOMRIGHT', CharacterFrameInset, 'BOTTOMRIGHT', -2, -1)
		
		-- Move rightside equipment slots to default position
		CharacterHandsSlot:SetPoint('TOPRIGHT', CharacterFrameInset, 'TOPRIGHT', -4, -2)
		
		-- Move bottom equipment slots to default position
		CharacterMainHandSlot:SetPoint('BOTTOMLEFT', PaperDollItemsFrame, 'BOTTOMLEFT', 130, 16)
		
		-- Model Frame
		CharacterModelFrame:Size(231, 320)
		CharacterModelFrame:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 52, -66)
		CharacterModelFrame.BackgroundTopLeft:Show()
		CharacterModelFrame.BackgroundTopRight:Show()
		CharacterModelFrame.BackgroundBotLeft:Show()
		CharacterModelFrame.BackgroundBotRight:Show()
		
		-- Turn off ArmoryFrame
		CA:Hide()
		CA:UnregisterAllEvents()
		
		--[[
		KF_KnightArmory.CheckButton:Hide()
		KF_KnightArmory_NoticeMissing:EnableMouse(false)
		KF_KnightArmory_NoticeMissing.text:SetTextColor(0.31, 0.31, 0.31)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
		]]
	end
end