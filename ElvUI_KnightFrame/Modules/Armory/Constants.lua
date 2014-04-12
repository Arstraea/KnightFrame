local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 18
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.994

if not KF then return
elseif KF.UIParent then
	KnightFrame_Armory_Constants = {
		['ItemLevelKey'] = ITEM_LEVEL:gsub('%%d', '(.+)'),
		['ItemLevelKey_Alt'] = ITEM_LEVEL_ALT:gsub('%%d', '.+'):gsub('%(.+%)', '%%((.+)%%)'),
		['EnchantKey'] = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)'),
		['ItemSetBonusKey'] = ITEM_SET_BONUS:gsub('%%s', '(.+)'),
		['TransmogrifiedKey'] = TRANSMOGRIFIED:gsub('%%s', '(.+)'),
		
		['GearList'] = {
			'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
			'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
		},
		
		['EnchantableSlots'] = {
			['ShoulderSlot'] = true, ['BackSlot'] = true, ['ChestSlot'] = true, ['WristSlot'] = true, ['HandsSlot'] = true,
			['LegsSlot'] = true, ['FeetSlot'] = true, ['MainHandSlot'] = true, ['SecondaryHandSlot'] = true
		},
		
		['UpgradeColor'] = {
			[16] = '|cffff9614',
			[12] = '|cfff88ef4',
			[8] = '|cff2eb7e4',
			[4] = '|cffceff00'
		},
		
		['GemColor'] = {
			['RED'] = { 1, .2, .2, },
			['YELLOW'] = { .97, .82, .29, },
			['BLUE'] = { .47, .67, 1, }
		},
		
		['EmptySocketString'] = {
			[EMPTY_SOCKET_BLUE] = true,
			[EMPTY_SOCKET_COGWHEEL] = true,
			[EMPTY_SOCKET_HYDRAULIC] = true,
			[EMPTY_SOCKET_META] = true,
			[EMPTY_SOCKET_NO_COLOR] = true,
			[EMPTY_SOCKET_PRISMATIC] = true,
			[EMPTY_SOCKET_RED] = true,
			[EMPTY_SOCKET_YELLOW] = true
		},
		
		['ItemBindString'] = { -- Usually transmogrify string is located upper than bind string so we need to check this string for adding a transmogrify string in tooltip.
			[ITEM_BIND_ON_EQUIP] = true,
			[ITEM_BIND_ON_PICKUP] = true,
			[ITEM_BIND_TO_ACCOUNT] = true,
			[ITEM_BIND_TO_BNETACCOUNT] = true
		},
		
		['CanTransmogrifySlot'] = {
			['HeadSlot'] = true,
			['ShoulderSlot'] = true,
			['BackSlot'] = true,
			['ChestSlot'] = true,
			['WristSlot'] = true,
			['HandsSlot'] = true,
			['WaistSlot'] = true,
			['LegsSlot'] = true,
			['FeetSlot'] = true,
			['MainHandSlot'] = true,
			['SecondaryHandSlot'] = true
		},
		
		['ProfessionList'] = {},
		
		['CommonScript'] = {
			['OnEnter'] = function(self)
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
			end,
			['OnLeave'] = function(self)
				self:SetScript('OnUpdate', nil)
				GameTooltip:Hide()
			end,
			['GemSocket_OnEnter'] = function(self)
				GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
				
				local Parent = self:GetParent()
				
				if Parent.GemItemID then
					if type(Parent.GemItemID) == 'number' then
						if GetItemInfo(Parent.GemItemID) then
							GameTooltip:SetHyperlink(select(2, GetItemInfo(Parent.GemItemID)))
						else
							self:SetScript('OnUpdate', function()
								if GetItemInfo(Parent.GemItemID) then
									KnightFrame_Armory_Constants.CommonScript.GemSocket_OnEnter(self)
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
			end,
			['Transmogrify_OnEnter'] = function(self)
				self.Texture:SetVertexColor(1, .8, 1)
				
				if self.Link then
					if GetItemInfo(self.Link) then
						GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
						GameTooltip:SetHyperlink(select(2, GetItemInfo(self.Link)))
						GameTooltip:Show()
					else
						self:SetScript('OnUpdate', function()
							if GetItemInfo(self.Link) then
								KnightFrame_Armory_Constants.CommonScript.Transmogrify_OnEnter(self)
								self:SetScript('OnUpdate', nil)
							end
						end)
					end
				end
			end,
			['Transmogrify_OnLeave'] = function(self)
				self:SetScript('OnUpdate', nil)
				self.Texture:SetVertexColor(1, .5, 1)
				
				GameTooltip:Hide()
			end,
			['ClearTooltip'] = function(tooltip)
				local tooltipName = tooltip:GetName()
				
				tooltip:ClearLines()
				for i = 1, 10 do
					_G[tooltipName..'Texture'..i]:SetTexture(nil)
					_G[tooltipName..'Texture'..i]:ClearAllPoints()
					_G[tooltipName..'Texture'..i]:Point('TOPLEFT', tooltip)
				end
			end,
		},
	}
	
	local ProfessionName, ProfessionTexture
	for ProfessionSkillID, Key in pairs({
		[105206] = 'Alchemy',
		[110396] = 'BlackSmithing',
		[110400] = 'Enchanting',
		[110403] = 'Engineering',
		[110417] = 'Inscription',
		[110420] = 'JewelCrafting',
		[110423] = 'LeatherWorking',
		[110426] = 'Tailoring',
		
		[110413] = 'Herbalism',
		[102161] = 'Mining',
		[102216] = 'Skinning'
	}) do
		ProfessionName, _, ProfessionTexture = GetSpellInfo(ProfessionSkillID)
		
		KnightFrame_Armory_Constants.ProfessionList[ProfessionName] = {
			['Key'] = Key,
			['Texture'] = ProfessionTexture
		}
	end
end