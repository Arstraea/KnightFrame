local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 9
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.991

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Upgrade Character Frame's Item Info like Wow-Armory		>>--
	--------------------------------------------------------------------------------
	local KA = CreateFrame('Frame', 'KnightArmory', PaperDollFrame)
	local C = KnightFrame_Armory_Constants
	
	--<< Key Table >>--
	KA.SlotID = {}
	
	KA.GemSocket_OnClick = function(self, button)
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
	KA.GemSocket_OnRecieveDrag = function(self)
		self = self:GetParent()
		
		if CursorHasItem() then
			local CursorType, _, ItemLink = GetCursorInfo()
			
			if CursorType == 'item' and select(6, GetItemInfo(ItemLink)) == select(8, GetAuctionItemClasses()) then
				SocketInventoryItem(GetInventorySlotInfo(self.slotName))
				ClickSocketButton(self.socketNumber)
			end
		end
	end
	
	
	function KA:CreateArmoryFrame()
		--<< Core >>--
		self:Point('TOPLEFT', CharacterFrameInset, 10, 20)
		self:Point('BOTTOMRIGHT', CharacterFrameInsetRight, 'BOTTOMLEFT', -10, 5)
		
		--<< Updater >>--
		local args
		self:SetScript('OnEvent', function(self, Event, ...)
			if Event == 'SOCKET_INFO_SUCCESS' or Event == 'ITEM_UPGRADE_MASTER_UPDATE' or Event == 'UNIT_INVENTORY_CHANGED' or Event == 'PLAYER_ENTERING_WORLD' then
				self.GearUpdated = nil
				self:SetScript('OnUpdate', KA.ArmoryFrame_DataSetting)
			elseif Event == 'PLAYER_EQUIPMENT_CHANGED' then
				args = ...
				self.GearUpdated = type(self.GearUpdated) == 'table' and self.GearUpdated or {}
				self.GearUpdated[#self.GearUpdated + 1] = self.SlotID[args]
				self:SetScript('OnUpdate', KA.ArmoryFrame_DataSetting)
			elseif Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
				_, Event, _, _, _, _, _, _, args = ...
				
				if Event == 'ENCHANT_APPLIED' and args == E.myname then
					self.GearUpdated = nil
					self:SetScript('OnUpdate', KA.ArmoryFrame_DataSetting)
				end
			elseif Event == 'UPDATE_INVENTORY_DURABILITY' then
				self.DurabilityUpdated = nil
				self:SetScript('OnUpdate', KA.ArmoryFrame_DataSetting)
			end
		end)
		
		--<< Background >>--
		self.BG = self:CreateTexture(nil, 'OVERLAY')
		self.BG:SetInside()
		self.BG:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Space.tga')
		
		--<< Change Model Frame's frameLevel >>--
		CharacterModelFrame:SetFrameLevel(self:GetFrameLevel() + 2)
		
		--<< Average Item Level >>--
		KF:TextSetting(self, nil, { ['Tag'] = 'AverageItemLevel', ['FontSize'] = 12, }, 'BOTTOM', CharacterModelFrame, 'TOP', 0, 14)
		local function ValueColorUpdate()
			self.AverageItemLevel:SetText(KF:Color_Value(L['Average'])..' : '..format('%.2f', select(2, GetAverageItemLevel())))
		end
		E.valueColorUpdateFuncs[ValueColorUpdate] = true
		
		-- Create each equipment slots gradation, text, gem socket icon.
		local Slot
		for i, slotName in pairs(C.GearList) do
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
			Slot.Gradation:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Gradation.tga')
			if Slot.Direction == 'LEFT' then
				Slot.Gradation:SetTexCoord(0, .5, 0, .5)
			else
				Slot.Gradation:SetTexCoord(.5, 1, 0, .5)
			end
			
			if slotName ~= 'ShirtSlot' and slotName ~= 'TabardSlot' then
				-- Item Level
				KF:TextSetting(Slot, nil, { ['Tag'] = 'ItemLevel', ['FontSize'] = 10, ['directionH'] = Slot.Direction, }, 'TOP'..Slot.Direction, _G['Character'..slotName], 'TOP'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, -1)
				
				-- Enchantment Name
				KF:TextSetting(Slot, nil, { ['Tag'] = 'ItemEnchant', ['FontSize'] = 8, ['directionH'] = Slot.Direction, }, Slot.Direction, _G['Character'..slotName], Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 2 or -2, 1)
				Slot.EnchantWarning = CreateFrame('Button', nil, Slot)
				Slot.EnchantWarning:Size(12)
				Slot.EnchantWarning.Texture = Slot.EnchantWarning:CreateTexture(nil, 'OVERLAY')
				Slot.EnchantWarning.Texture:SetInside()
				Slot.EnchantWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Warning-Small.tga')
				Slot.EnchantWarning:Point(Slot.Direction, Slot.ItemEnchant, Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT', Slot.Direction == 'LEFT' and 3 or -3, 0)
				Slot.EnchantWarning:SetScript('OnEnter', C.CommonScript.OnEnter)
				Slot.EnchantWarning:SetScript('OnLeave', C.CommonScript.OnLeave)
				
				-- Durability
				KF:TextSetting(Slot, nil, { ['Tag'] = 'Durability', ['FontSize'] = 10, ['directionH'] = Slot.Direction, }, 'BOTTOM'..Slot.Direction, _G['Character'..slotName], 'BOTTOM'..(Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 2 or -2, 3)
				
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
					Slot['Socket'..i].Socket:SetScript('OnEnter', C.CommonScript.OnEnter)
					Slot['Socket'..i].Socket:SetScript('OnLeave', C.CommonScript.OnLeave)
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
				Slot.SocketWarning.Texture:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Warning-Small.tga')
				Slot.SocketWarning:SetScript('OnEnter', C.CommonScript.OnEnter)
				Slot.SocketWarning:SetScript('OnLeave', C.CommonScript.OnLeave)
			end
			
			self.SlotID[Slot.ID] = slotName
			self[slotName] = Slot
		end
		
		-- GameTooltip for counting gem sockets and getting enchant effects
		self.ScanTT = CreateFrame('GameTooltip', 'KnightArmoryScanTT', nil, 'GameTooltipTemplate')
		self.ScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
		
		-- For resizing paper doll frame when it toggled.
		self.ChangeCharacterFrameWidth = CreateFrame('Frame')
		self.ChangeCharacterFrameWidth:SetScript('OnShow', function() if PaperDollFrame:IsVisible() then PANEL_DEFAULT_WIDTH = 448 self:ArmoryFrame_DataSetting() end end)
		self.ChangeCharacterFrameWidth:SetScript('OnHide', function() PANEL_DEFAULT_WIDTH = 338 end)
		
		self.CreateArmoryFrame = nil
	end
	
	
	function KA:Update_Durability()
		local Slot, r, g, b, CurrentDurability, MaxDurability
		
		for _, slotName in pairs(C.GearList) do
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
	
	
	function KA:Update_Gear()
		-- Get Player Profession
		local Prof1, Prof2 = GetProfessions()
		local Prof1_Level, Prof2_Level = 0, 0
		KA.PlayerProfession = {}
		
		if Prof1 then Prof1, _, Prof1_Level = GetProfessionInfo(Prof1) end
		if Prof2 then Prof2, _, Prof2_Level = GetProfessionInfo(Prof2) end
		if Prof1 and C.ProfessionList[Prof1] then KA.PlayerProfession[(C.ProfessionList[Prof1].Key)] = Prof1_Level end
		if Prof2 and C.ProfessionList[Prof2] then KA.PlayerProfession[(C.ProfessionList[Prof2].Key)] = Prof2_Level end
		
		local ErrorDetected, needUpdate
		local r, g, b
		local Slot, ItemLink, ItemRarity, BasicItemLevel, TrueItemLevel, ItemUpgradeID, ItemTexture, IsEnchanted, UsableEffect, CurrentLineText, GemID, GemCount_Default, GemCount_Enable, GemCount_Now, GemCount
		local arg1, itemID, enchantID, _, _, _, _, arg2, arg3, arg4, arg5, arg6
		
		for _, slotName in pairs(self.GearUpdated or C.GearList) do
			if not (slotName == 'ShirtSlot' or slotName == 'TabardSlot') then
				Slot = KA[slotName]
				ItemLink = GetInventoryItemLink('player', Slot.ID)
				
				do --<< Clear Setting >>--
					ErrorDetected, TrueItemLevel, IsEnchanted, UsableEffect, ItemUpgradeID, ItemTexture = nil, nil, nil, nil, nil, nil
					
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
					do --<< Gem Parts >>--
						arg1, itemID, enchantID, _, _, _, _, arg2, arg3, arg4, arg5, arg6 = strsplit(':', ItemLink)
						
						KA.ScanTT:ClearLines()
						for i = 1, 10 do
							_G['KnightArmoryScanTTTexture'..i]:SetTexture(nil)
						end
						KA.ScanTT:SetHyperlink(format('%s:%s:%d:0:0:0:0:%s:%s:%s:%s:%s', arg1, itemID, enchantID, arg2, arg3, arg4, arg5, arg6))
						
						GemCount_Default, GemCount_Now, GemCount = 0, 0, 0
						
						-- First, Counting default gem sockets
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['KnightArmoryScanTTTexture'..i]:GetTexture()
							
							if ItemTexture and ItemTexture:find('Interface\\ItemSocketingFrame\\') then
								GemCount_Default = GemCount_Default + 1
								Slot['Socket'..GemCount_Default].GemType = strupper(gsub(ItemTexture, 'Interface\\ItemSocketingFrame\\UI--EmptySocket--', ''))
							end
						end
						
						-- Second, Check if slot's item enable to adding a socket
						GemCount_Enable = GemCount_Default
						if (slotName == 'WaistSlot' and UnitLevel('player') >= 70) or -- buckle
							((slotName == 'WristSlot' or slotName == 'HandsSlot') and KA.PlayerProfession.BlackSmithing and KA.PlayerProfession.BlackSmithing >= 550) then -- BlackSmith
							
							GemCount_Enable = GemCount_Enable + 1
							Slot['Socket'..GemCount_Enable].GemType = 'PRISMATIC'
						end
						
						KA.ScanTT:ClearLines()
						for i = 1, 10 do
							_G['KnightArmoryScanTTTexture'..i]:SetTexture(nil)
						end
						KA.ScanTT:SetHyperlink(ItemLink)
						
						-- Apply current item's gem setting
						for i = 1, MAX_NUM_SOCKETS do
							ItemTexture = _G['KnightArmoryScanTTTexture'..i]:GetTexture()
							GemID = select(i, GetInventoryItemGems(Slot.ID))
							
							if Slot['Socket'..i].GemType and C.GemColor[Slot['Socket'..i].GemType] then
								r, g, b = unpack(C.GemColor[Slot['Socket'..i].GemType])
								Slot['Socket'..i].Socket:SetBackdropColor(r, g, b, .5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(r, g, b)
							else
								Slot['Socket'..i].Socket:SetBackdropColor(1, 1, 1, .5)
								Slot['Socket'..i].Socket:SetBackdropBorderColor(1, 1, 1)
							end
							
							if ItemTexture then
								Slot['Socket'..i]:Show()
								GemCount_Now = GemCount_Now + 1
								Slot.SocketWarning:Point(Slot.Direction, Slot['Socket'..i], (Slot.Direction == 'LEFT' and 'RIGHT' or 'LEFT'), Slot.Direction == 'LEFT' and 3 or -3, 0)
								
								if GemID then
									GemCount = GemCount + 1
									Slot['Socket'..i].Texture:SetTexture(ItemTexture)
									Slot['Socket'..i].GemItemID = GemID
									Slot['Socket'..i].Socket.Link = select(2, GetItemInfo(GemID))
								end
							end
						end
						
						if GemCount_Now < GemCount_Default then -- ItemInfo not loaded
							needUpdate = needUpdate or {}
							needUpdate[#needUpdate + 1] = slotName
						end
					end
					
					_, _, ItemRarity, BasicItemLevel, _, _, _, _, _, ItemTexture = GetItemInfo(ItemLink)
					r, g, b = GetItemQualityColor(ItemRarity)
					
					ItemUpgradeID = ItemLink:match(':(%d+)\124h%[')
					
					KA.ScanTT:ClearLines()
					for i = 1, 10 do
						_G['KnightArmoryScanTTTexture'..i]:SetTexture(nil)
					end
					KA.ScanTT:SetInventoryItem('player', Slot.ID)
					
					--<< Enchant Parts >>--
					for i = 1, KA.ScanTT:NumLines() do
						CurrentLineText = _G['KnightArmoryScanTTTextLeft'..i]:GetText()
						
						if CurrentLineText:find(C.ItemLevelKey_Alt) then
							TrueItemLevel = tonumber(CurrentLineText:match(C.ItemLevelKey_Alt))
						elseif CurrentLineText:find(C.ItemLevelKey) then
							TrueItemLevel = tonumber(CurrentLineText:match(C.ItemLevelKey))
						elseif CurrentLineText:find(C.EnchantKey) then
							CurrentLineText = CurrentLineText:match(C.EnchantKey) -- Get enchant string
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
						
						Slot.ItemLevel:SetText((Slot.Direction == 'LEFT' and TrueItemLevel or '')..(ItemUpgradeID and (Slot.Direction == 'LEFT' and ' ' or '')..(C.UpgradeColor[ItemUpgradeID] or '|cffaaaaaa')..'(+'..ItemUpgradeID..')|r'..(Slot.Direction == 'RIGHT' and ' ' or '') or '')..(Slot.Direction == 'RIGHT' and TrueItemLevel or ''))
					end
					
					-- Check Error
					if KF.db.Modules.KnightArmory.NoticeMissing ~= false then
						if (not IsEnchanted and C.EnchantableSlots[slotName]) or ((slotName == 'Finger0Slot' or slotName == 'Finger1Slot') and KA.PlayerProfession.Enchanting and KA.PlayerProfession.Enchanting >= 550 and not IsEnchanted) then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.ItemEnchant:SetText('|cffff0000'..L['Not Enchanted'])
						elseif KA.PlayerProfession.Engineering and ((slotName == 'BackSlot' and KA.PlayerProfession.Engineering >= 380) or (slotName == 'HandsSlot' and KA.PlayerProfession.Engineering >= 400) or (slotName == 'WaistSlot' and KA.PlayerProfession.Engineering >= 380)) and not UsableEffect then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110403)..'|r : '..L['Missing Tinkers']
						elseif slotName == 'ShoulderSlot' and KA.PlayerProfession.Inscription and KF.Table.ItemEnchant_Profession_Inscription and KA.PlayerProfession.Inscription >= KF.Table.ItemEnchant_Profession_Inscription.NeedLevel and not KF.Table.ItemEnchant_Profession_Inscription[enchantID] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110400)..'|r : '..L['This is not profession only.']
						elseif slotName == 'WristSlot' and KA.PlayerProfession.LeatherWorking and KF.Table.ItemEnchant_Profession_LeatherWorking and KA.PlayerProfession.LeatherWorking >= KF.Table.ItemEnchant_Profession_LeatherWorking.NeedLevel and not KF.Table.ItemEnchant_Profession_LeatherWorking[enchantID] then
							ErrorDetected = true
							Slot.EnchantWarning:Show()
							Slot.EnchantWarning.Message = '|cff71d5ff'..GetSpellInfo(110423)..'|r : '..L['This is not profession only.']
						elseif slotName == 'BackSlot' and KA.PlayerProfession.Tailoring and KF.Table.ItemEnchant_Profession_Tailoring and KA.PlayerProfession.Tailoring >= KF.Table.ItemEnchant_Profession_Tailoring.NeedLevel and not KF.Table.ItemEnchant_Profession_Tailoring[enchantID] then
							ErrorDetected = true
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
				end
				
				-- Change Gradation
				if ErrorDetected and KF.db.Modules.KnightArmory.NoticeMissing ~= false then
					if Slot.Direction == 'LEFT' then
						Slot.Gradation:SetTexCoord(0, .5, .5, 1)
					else
						Slot.Gradation:SetTexCoord(.5, 1, .5, 1)
					end
				else
					if Slot.Direction == 'LEFT' then
						Slot.Gradation:SetTexCoord(0, .5, 0, .5)
					else
						Slot.Gradation:SetTexCoord(.5, 1, 0, .5)
					end
				end
			end
		end
		
		KA.AverageItemLevel:SetText(KF:Color_Value(STAT_AVERAGE_ITEM_LEVEL)..' : '..format('%.2f', select(2, GetAverageItemLevel())))
		
		if needUpdate then
			self.GearUpdated = needUpdate
			return true
		end
		
		self.GearUpdated = true
	end
	
	
	local needUpdate
	function KA:ArmoryFrame_DataSetting()
		if not KA:IsVisible() then return end
		
		needUpdate = nil
		
		if not self.DurabilityUpdated then
			needUpdate = self:Update_Durability() or needUpdate
		end
		
		if self.GearUpdated ~= true then
			needUpdate = self:Update_Gear() or needUpdate
		end
		
		if not needUpdate then
			self:SetScript('OnUpdate', nil)
		end
	end
	
	
	
	
	-- Create Config button in Character Frame : Enable
	KF:CreateWidget_CheckButton('KF_KnightArmory', L['Armory Mode'], 20, { ['FontSize'] = 10, ['directionH'] = 'LEFT', })
	KF_KnightArmory:SetParent(PaperDollFrame)
	KF_KnightArmory:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 1)
	KF_KnightArmory:SetFrameStrata(PaperDollFrame:GetFrameStrata())
	KF_KnightArmory:Point('TOPLEFT', PaperDollFrame, 15, -20)
	KF_KnightArmory:SetScript('OnClick', function(self)
		KF.db.Modules.KnightArmory.Enable = not KF.db.Modules.KnightArmory.Enable
		
		KF.Modules.KnightArmory()
	end)
	
	
	-- Create Config button in Character Frame : NoticeMissing
	KF:CreateWidget_CheckButton('KF_KnightArmory_NoticeMissing', L['Notice Missing'], 20, { ['FontSize'] = 10, ['directionH'] = 'LEFT', })
	
	if KF.db.Modules.KnightArmory.NoticeMissing == false then
		KF_KnightArmory_NoticeMissing.CheckButton:Hide()
	end
	
	KF_KnightArmory_NoticeMissing:SetParent(PaperDollFrame)
	KF_KnightArmory_NoticeMissing:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 1)
	KF_KnightArmory_NoticeMissing:SetFrameStrata(PaperDollFrame:GetFrameStrata())
	KF_KnightArmory_NoticeMissing:Point('TOPLEFT', KF_KnightArmory, 'BOTTOMLEFT', 0, 4)
	KF_KnightArmory_NoticeMissing:SetScript('OnClick', function(self)
		if KF.db.Modules.KnightArmory.NoticeMissing == true then
			KF.db.Modules.KnightArmory.NoticeMissing = false
			KF_KnightArmory_NoticeMissing.CheckButton:Hide()
		else
			KF.db.Modules.KnightArmory.NoticeMissing = true
			KF_KnightArmory_NoticeMissing.CheckButton:Show()
		end
		
		KA:ArmoryFrame_DataSetting()
	end)
	
	
	if KF.db.Modules.KnightArmory.Enable == false then
		KF_KnightArmory.CheckButton:Hide()
		KF_KnightArmory_NoticeMissing.text:SetTextColor(0.31, 0.31, 0.31)
		KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
	end
	KF_KnightArmory_NoticeMissing:EnableMouse(KF.db.Modules.KnightArmory.Enable)
	
	local function ValueColorUpdate()
		KF_KnightArmory.text:SetTextColor(unpack(E.media.rgbvaluecolor))
	end
	E['valueColorUpdateFuncs'][ValueColorUpdate] = true
	
	
	
	
	KF.Modules[#KF.Modules + 1] = 'KnightArmory'
	KF.Modules['KnightArmory'] = function(RemoveOrder)
		if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.KnightArmory.Enable ~= false then
			-- Setting frame
			CHARACTERFRAME_EXPANDED_WIDTH = 650
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
			
			if KA.CreateArmoryFrame then
				KA:CreateArmoryFrame()
			else
				KA:Show()
			end
			KA:ArmoryFrame_DataSetting()
			
			-- Run KnightArmory
			KA:RegisterEvent('SOCKET_INFO_SUCCESS')
			KA:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
			KA:RegisterEvent('PLAYER_ENTERING_WORLD')
			KA:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
			KA:RegisterEvent('UNIT_INVENTORY_CHANGED')
			--KA:RegisterEvent('EQUIPMENT_SWAP_FINISHED')
			KA:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
			KA:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
			
			-- For frame resizing
			KA.ChangeCharacterFrameWidth:SetParent(PaperDollFrame)
			if PaperDollFrame:IsVisible() then
				KA.ChangeCharacterFrameWidth:Show()
				CharacterFrame:SetWidth(CharacterFrameInsetRight:IsShown() and 650 or 448)
			end
			
			KF_KnightArmory.CheckButton:Show()
			KF_KnightArmory_NoticeMissing:EnableMouse(true)
			KF_KnightArmory_NoticeMissing.text:SetTextColor(1, 1, 1)
			KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')
		elseif not KA.CreateArmoryFrame then
			-- Setting frame to default
			PANEL_DEFAULT_WIDTH = 338
			CHARACTERFRAME_EXPANDED_WIDTH = 540
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
			KA:Hide()
			KA:UnregisterAllEvents()
			
			-- Return to default size when PaperDollFrame is open
			KA.ChangeCharacterFrameWidth:SetParent(nil)
			KA.ChangeCharacterFrameWidth:Hide()
			if PaperDollFrame:IsVisible() then
				CharacterFrame:SetWidth(CharacterFrameInsetRight:IsShown() and 540 or 338)
			end
			
			KF_KnightArmory.CheckButton:Hide()
			KF_KnightArmory_NoticeMissing:EnableMouse(false)
			KF_KnightArmory_NoticeMissing.text:SetTextColor(0.31, 0.31, 0.31)
			KF_KnightArmory_NoticeMissing.CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
		end
	end
end