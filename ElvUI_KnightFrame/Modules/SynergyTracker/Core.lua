local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 7
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent then
--------------------------------------------------------------------------------
--<< KnightFrame : Synergy Tracker											>>--
--------------------------------------------------------------------------------
	local M = E:GetModule('Minimap')
	local Activate = false
	
	local BorderColor = {
		['Default'] = { 1, 0.86, 0.24 },
		['HARMFUL'] = { 1, 0, 0, },
	}
	local needUpdate
	
	
	local function CheckSynergy(Unit, spellName, spellType)
		local spellName, _, Icon, _, _, Duration, expirationTime, Caster = UnitAura(Unit, spellName, nil, spellType)
		Caster = Caster and KF:Color_Class(select(2, UnitClass(Caster)), UnitName(Caster)) or nil
		
		return spellName, Icon, Duration, expirationTime, Caster
	end
	
	
	local function CheckFilters(FilterName, Unit)
		if not KF.Table.SynergyTracker_Filters[FilterName] then return end
		
		local spellName, Icon, Duration, expirationTime, Caster
		
		for spellName in pairs(KF.Table.SynergyTracker_Filters[FilterName]) do
			_, Icon, Duration, expirationTime, Caster = CheckSynergy(Unit, spellName, KF.Table.SynergyTracker_Filters[FilterName].Type)
			
			if not (spellName == 'MainIcon' or spellName == 'Type' or spellName == 'ForbidTooltip') and Icon then
				return spellName, Icon, Duration, expirationTime, Caster
			end
		end 
	end
	
	
	local function UpdateDuration(self, elapsed)
		self.Timer:SetValue(floor((self.expirationTime - (KF.TimeNow or GetTime())) / self.AuraDuration * 100))
	end
	
	
	local function SynergyTracker_Player_Update(self)
		needUpdate = nil
		
		local spellName, Icon, Duration, expirationTime, Caster
		
		for IconName in pairs(self.FilterList) do
			if self[IconName].spellName then
				spellName, Icon, Duration, expirationTime, Caster = CheckSynergy(self.Unit, self[IconName].spellName, KF.Table.SynergyTracker_Filters[self[IconName].FilterName].Type)
			else
				spellName, Icon, Duration, expirationTime, Caster = CheckFilters(self[IconName].FilterName, self.Unit)
			end
			
			if not spellName then
				if self[IconName].spellName then
					needUpdate = true
				end
				self[IconName].spellName = nil
				self[IconName].AuraDuration = nil
				self[IconName].expirationTime = nil
				self[IconName].Caster = nil
				
				self[IconName]:SetScript('OnUpdate', nil)
				self[IconName].Texture:SetTexture(KF.Table.SynergyTracker_Filters[self[IconName].FilterName].MainIcon)
				self[IconName].Texture:SetAlpha(0.3)
				self[IconName].Icon:SetBackdropBorderColor(unpack(E.media.bordercolor))
				self[IconName].Duration:Hide()
				
				self[IconName]:Size(self[IconName].IconWidth, self[IconName].IconHeight)
			elseif not self[IconName].spellName or (self[IconName].expirationTime and self[IconName].expirationTime ~= expirationTime) then
				self[IconName].spellName = spellName
				self[IconName].AuraDuration = Duration
				self[IconName].expirationTime = expirationTime
				self[IconName].Caster = Caster
				
				self[IconName].Texture:SetTexture(Icon)
				self[IconName].Texture:SetAlpha(1)
				self[IconName].Icon:SetBackdropBorderColor(unpack(BorderColor[KF.Table.SynergyTracker_Filters[self[IconName].FilterName].Type] or BorderColor.Default))
				self[IconName].Duration:SetBackdropBorderColor(unpack(BorderColor[KF.Table.SynergyTracker_Filters[self[IconName].FilterName].Type] or BorderColor.Default))
				
				if Duration > 0 then
					self[IconName].Duration:Show()
					
					self[IconName]:SetScript('OnUpdate', UpdateDuration)
					
					self[IconName]:Size(self[IconName].IconWidth, self[IconName].IconHeight + 6)
				else
					self[IconName].Duration:Hide()
					
					self[IconName]:SetScript('OnUpdate', nil)
					
					self[IconName]:Size(self[IconName].IconWidth, self[IconName].IconHeight)
				end
				
				UpdateDuration(self[IconName])
			end
		end
		
		if needUpdate then
			SynergyTracker_Player_Update(self)
		end
	end
	
	
	hooksecurefunc(M, 'UpdateSettings', function()
		if Activate then
			if MMHolder then
				MMHolder:Width(Minimap:GetWidth() + (E.PixelMode and 3 or 4))
			end
			
			if ElvConfigToggle then
				ElvConfigToggle:Hide()
			end
			
			local A = E:GetModule('Auras')
			
			if A.DisableCB then
				A:DisableCB()
			end
		end
	end)
	
	
	local function Button_OnEnter(self)
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT', 20, -4)
		
		local Tracker = self:GetParent()
		local timeLeft, remainTime, formatID
		
		Tracker:SetScript('OnUpdate', function()
			GameTooltip:ClearLines()
			GameTooltip:AddLine(Tracker.Tag..' : |cffffdc3c'..self.Tag..'|r', 1, 1, 1)
			
			if self['spellName'] then
				timeLeft = self.expirationTime - KF.TimeNow
				
				if timeLeft > 0 then
					remainTime, formatID = E:GetTimeInfo(timeLeft, 4)
				end
				
				GameTooltip:AddLine(' ')
				GameTooltip:AddDoubleLine('|cff6dd66d'..L['Applied']..'|r : ', timeLeft > 0 and format(format('%s%s|r', E.TimeColors[formatID], E.TimeFormats[formatID][1]), remainTime) or '', 1, 1, 1, 1, 1, 1)
				GameTooltip:AddDoubleLine(' '..self.spellName, self.Caster or ' ', 1, 1, 1, 1, 1, 1)
			else
				GameTooltip:AddLine('|n'..'|cffb9062f'..L['Non-applied'], 1, 1, 1)
				
				timeLeft = nil
				
				for spellName, CastableClass in pairs(KF.Table.SynergyTracker_Filters[self.FilterName]) do
					if spellName ~= 'MainIcon' and spellName ~= 'Type' and CastableClass ~= false then
						if not timeLeft then
							timeLeft = true
							GameTooltip:AddLine(' ')
						end
						
						GameTooltip:AddDoubleLine(spellName, CastableClass, 1, 1, 1, 1, 1, 1)
					end
				end
			end
			GameTooltip:Show()
		end)
	end
	
	
	local function Button_OnLeave(self)
		local Tracker = self:GetParent()
		
		Tracker:SetScript('OnUpdate', nil)
		GameTooltip:Hide()
	end
	
	
	local function Button_OnClick(self, Button)
		local Tracker = self:GetParent()
		
		if Tracker == KF_SynergyTracker_Player then
			if not IsShiftKeyDown() and Button == 'RightButton' and self.spellName then
				CancelUnitBuff('player', self.spellName)
			end
		end
	end
	
	
	local function CreateButton(IconWidth, IconHeight)
		local button = CreateFrame('Button')
		button:Size(IconWidth, (IconHeight or IconWidth))
		button:SetFrameLevel(10)
		button:SetFrameStrata('HIGH')
		button:RegisterForClicks('AnyUp')
		
		button.Icon = CreateFrame('Frame', nil, button)
		button.Icon:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		button.Icon:SetBackdropColor(0, 0, 0, 1)
		button.Icon:Size(IconWidth, IconHeight)
		button.Icon:SetFrameLevel(8)
		button.Icon:Point('TOP', button)
		
		button.Texture = button.Icon:CreateTexture(nil, 'OVERLAY')
		button.Texture:SetTexCoord(unpack(E.TexCoords))
		button.Texture:SetInside()
		
		button.Duration = CreateFrame('Frame', nil, button)
		button.Duration:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		button.Duration:SetBackdropColor(0, 0, 0, 1)
		button.Duration:Size(IconWidth, 5)
		button.Duration:SetFrameLevel(8)
		button.Duration:Point('TOP', button.Icon, 'BOTTOM', 0, -1)
		
		button.Timer = CreateFrame('StatusBar', nil, button.Duration)
		button.Timer:SetMinMaxValues(0, 100)
		button.Timer:SetStatusBarTexture(E['media'].blankTex)
		button.Timer:SetFrameLevel(9)
		button.Timer:Point('TOPLEFT', 2, -2)
		button.Timer:Point('BOTTOMRIGHT', -2, 2)
		button.Timer:SetStatusBarColor(1, 1, 1, 1)
		
		button.Duration:Hide()
		
		button:SetScript('OnEnter', Button_OnEnter)
		button:SetScript('OnLeave', Button_OnLeave)
		button:SetScript('OnClick', Button_OnClick)
		
		button.IconWidth = IconWidth
		button.IconHeight = IconHeight or IconWidth
		
		return button
	end
	
	
	local function SynergyTracker_Target_Setting()
		if not UnitExists('target') then
			KF_SynergyTracker_Target.CurrentTarget = 'NONE'
			KF_SynergyTracker_Target:Hide()
			
			if KF.Update.TopPanel_UpdateLocation then
				KF.Update.TopPanel_UpdateLocation.Action()
			end
			
			return
		else
			KF_SynergyTracker_Target:Show()
			
			local unitColor
			
			if UnitCanAttack('player', 'target') then
				KF_SynergyTracker_Target.Spell5:Show()
				KF_SynergyTracker_Target.Spell5.FilterName = 'IncreaseMagicDamageTaken'
				KF_SynergyTracker_Target.Spell5.Tag = L['Increase Magic Damage Taken']
				
				KF_SynergyTracker_Target.Spell1.FilterName = 'WeakenedArmor'
				KF_SynergyTracker_Target.Spell1.Tag = L['Weakened Armor']
				
				KF_SynergyTracker_Target.Spell2.FilterName = 'PhysicalVulnerability'
				KF_SynergyTracker_Target.Spell2.Tag = L['Physical Vulnerability']
				
				KF_SynergyTracker_Target.Spell3.FilterName = 'WeakenedBlows'
				KF_SynergyTracker_Target.Spell3.Tag = L['Weakened Blows']
				
				KF_SynergyTracker_Target.Spell4.FilterName = 'SlowSpellCasting'
				KF_SynergyTracker_Target.Spell4.Tag = L['Slow Spell Casting']
				
				KF_SynergyTracker_Target.Spell6:Show()
				KF_SynergyTracker_Target.Spell6.FilterName = 'MortalWounds'
				KF_SynergyTracker_Target.Spell6.Tag = L['Mortal Wonds']
				
				KF_SynergyTracker_Target.Spell7:Hide()
				KF_SynergyTracker_Target.Spell8:Hide()
				KF_SynergyTracker_Target.Group1:Point('TOPLEFT', KF_SynergyTracker_Target.Spell5.Icon, -4, 4)
				KF_SynergyTracker_Target.Group1:Point('BOTTOMRIGHT', KF_SynergyTracker_Target.Spell6.Icon, 4, 4)
				
				if UnitIsPlayer('target') then
					KF_SynergyTracker_Target.CurrentTarget = 'Enemy'
					unitColor = KF:Color_Class(select(2, UnitClass('target')), nil)
				else
					KF_SynergyTracker_Target.CurrentTarget = 'Monster'
					unitColor = '|cffcd4c37'
				end
			else
				if UnitIsPlayer('target') then
					KF_SynergyTracker_Target.Spell5:Show()
					KF_SynergyTracker_Target.Spell5.FilterName = 'Critical'
					KF_SynergyTracker_Target.Spell5.Tag = RAID_BUFF_7
					
					KF_SynergyTracker_Target.Spell1.FilterName = 'AllStats'
					KF_SynergyTracker_Target.Spell1.Tag = RAID_BUFF_1
					
					KF_SynergyTracker_Target.Spell2.FilterName = 'Mastery'
					KF_SynergyTracker_Target.Spell2.Tag = RAID_BUFF_8
					
					KF_SynergyTracker_Target.Spell3.FilterName = 'Stamina'
					KF_SynergyTracker_Target.Spell3.Tag = RAID_BUFF_2
					
					KF_SynergyTracker_Target.Spell4.FilterName = 'Elixirs'
					KF_SynergyTracker_Target.Spell4.Tag = L['Elixirs']
					
					KF_SynergyTracker_Target.Spell6:Show()
					KF_SynergyTracker_Target.Spell6.FilterName = 'Foods'
					KF_SynergyTracker_Target.Spell6.Tag = L['Foods']
					
					KF_SynergyTracker_Target.Spell7:Show()
					KF_SynergyTracker_Target.Spell8:Show()
					KF_SynergyTracker_Target.Group1:Point('TOPLEFT', KF_SynergyTracker_Target.Spell5.Icon, -4, 4)
					KF_SynergyTracker_Target.Group1:Point('BOTTOMRIGHT', KF_SynergyTracker_Target.Spell6.Icon, 4, 4)
					
					KF_SynergyTracker_Target.CurrentTarget = 'Ally'
					unitColor = KF:Color_Class(select(2, UnitClass('target')), nil)
				else
					KF_SynergyTracker_Target.Spell1.FilterName = 'Critical'
					KF_SynergyTracker_Target.Spell1.Tag = RAID_BUFF_7
					
					KF_SynergyTracker_Target.Spell2.FilterName = 'AllStats'
					KF_SynergyTracker_Target.Spell2.Tag = RAID_BUFF_1
					
					KF_SynergyTracker_Target.Spell3.FilterName = 'Mastery'
					KF_SynergyTracker_Target.Spell3.Tag = RAID_BUFF_8
					
					KF_SynergyTracker_Target.Spell4.FilterName = 'Stamina'
					KF_SynergyTracker_Target.Spell4.Tag = RAID_BUFF_2
					
					KF_SynergyTracker_Target.Spell5:Hide()
					KF_SynergyTracker_Target.Spell5.FilterName = 'Critical'
					KF_SynergyTracker_Target.Spell5.Tag = RAID_BUFF_7
					
					KF_SynergyTracker_Target.Spell6:Hide()
					KF_SynergyTracker_Target.Spell6.FilterName = 'Foods'
					KF_SynergyTracker_Target.Spell6.Tag = L['Foods']
					
					KF_SynergyTracker_Target.Spell7:Hide()
					KF_SynergyTracker_Target.Spell8:Hide()
					KF_SynergyTracker_Target.Group1:Point('TOPLEFT', KF_SynergyTracker_Target.Spell1.Icon, -4, 4)
					KF_SynergyTracker_Target.Group1:Point('BOTTOMRIGHT', KF_SynergyTracker_Target.Spell4.Icon, 4, 4)
					
					KF_SynergyTracker_Target.CurrentTarget = 'NPC'
					unitColor = '|cff20ff20'
				end
			end
			
			if KF.db.Modules.TopPanel.Enable ~= false and KF_TopPanel and KF_TopPanel:IsShown() then
				KF_TopPanel.LocationName.text:SetText(unitColor..UnitName('target'))
				
				local Classifi = UnitClassification('target')
				local CanAttack = UnitCanAttack('player', 'target')
				local unitLevel = UnitLevel('target')
				unitColor = GetQuestDifficultyColor(unitLevel)
				
				if Classifi == 'worldboss' then Classifi = 'WB'
				elseif Classifi == 'rareelite' then Classifi = 'RE'
				elseif Classifi == 'elite' then Classifi = 'E'
				elseif Classifi == 'rare' then Classifi = 'R'
				else Classifi = '' end
				
				KF_TopPanel.LocationX.text:SetText(format('|cff%02x%02x%02x%s%s|r',
					((CanAttack and (Classifi == 'WB' or unitLevel == -1)) and 0.6 or unitColor.r) * 255,
					((CanAttack and (Classifi == 'WB' or unitLevel == -1)) and 0 or unitColor.g) * 255,
					((CanAttack and (Classifi == 'WB' or unitLevel == -1)) and 0 or unitColor.b) * 255, unitLevel > 0 and unitLevel or '??', ' '..(Classifi == 'WB' and '|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:0|t' or Classifi)))
				KF_TopPanel.LocationY.text:SetText(nil)
			end
			
			SynergyTracker_Player_Update(KF_SynergyTracker_Target)
		end
	end
	
	
	KF.Modules[#KF.Modules + 1] = 'SynergyTracker'
	KF.Modules['SynergyTracker'] = function(RemoveOrder)
		if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.TopPanel.Enable ~= false and KF.db.Modules.SynergyTracker ~= false then
			Activate = true
			
			E.db.auras.consolidatedBuffs.enable = true
			
			if not KF_SynergyTracker_Player and not KF_SynergyTracker_Target then
				--<< Synergy Tracker (Player) >>--
				local f = CreateFrame('Frame', 'KF_SynergyTracker_Player', KF.UIParent)
				f:Size(250, 20)
				f:SetScript('OnEvent', SynergyTracker_Player_Update)
				f.Unit = 'player'
				f.Tag = KF:Color_Value('Synergy')
				f.FilterList = {
					['AttackPower'] = true,
					['AttackSpeed'] = true,
					['SpellPower'] = true,
					['SpellHaste'] = true,
					['PrivateBuff'] = true,
					['Critical'] = true,
					['AllStats'] = true,
					['Mastery'] = true,
					['Stamina'] = true,
				}
				
				for frameName in pairs(f.FilterList) do
					f[frameName] = CreateButton(20)
					f[frameName]:SetParent(f)
					f[frameName].FilterName = frameName
				end

				f.AttackPower:Point('TOPRIGHT', f.AttackSpeed, 'TOPLEFT', -4, 0)
				f.AttackPower.Tag = RAID_BUFF_3
				f.AttackSpeed:Point('TOPRIGHT', f.SpellPower, 'TOPLEFT', -4, 0)
				f.AttackSpeed.Tag = RAID_BUFF_4
				f.SpellPower:Point('TOPRIGHT', f.SpellHaste, 'TOPLEFT', -4, 0)
				f.SpellPower.Tag = RAID_BUFF_5
				f.SpellHaste:Point('TOPRIGHT', f.PrivateBuff, 'TOPLEFT', -19, 0)
				f.SpellHaste.Tag = RAID_BUFF_6

				f.PrivateBuff:Point('TOP', f, 'BOTTOM', 0, 16)
				f.PrivateBuff.Tag = GetSpellInfo(53563)

				f.Critical:Point('TOPLEFT', f.PrivateBuff, 'TOPRIGHT', 19, 0)
				f.Critical.Tag = RAID_BUFF_7
				f.AllStats:Point('TOPLEFT', f.Critical, 'TOPRIGHT', 4, 0)
				f.AllStats.Tag = RAID_BUFF_1
				f.Mastery:Point('TOPLEFT', f.AllStats, 'TOPRIGHT', 4, 0)
				f.Mastery.Tag = RAID_BUFF_8
				f.Stamina:Point('TOPLEFT', f.Mastery, 'TOPRIGHT', 4, 0)
				f.Stamina.Tag = RAID_BUFF_2
				
				f.Group1 = CreateFrame('Frame', nil, f)
				f.Group1:Point('TOPLEFT', f.AttackPower.Icon, 'TOPLEFT', -4, 4)
				f.Group1:Point('BOTTOMRIGHT', f.SpellHaste.Icon, 'BOTTOMRIGHT', 4, 4)
				f.Group1:SetFrameLevel(7)
				f.Group1:SetFrameStrata('BACKGROUND')
				f.Group1:SetTemplate('Default', true)

				f.Group2 = CreateFrame('Frame', nil, f)
				f.Group2:Point('TOPLEFT', f.PrivateBuff.Icon, 'TOPLEFT', -4, 4)
				f.Group2:Point('BOTTOMRIGHT', f.PrivateBuff.Icon, 'BOTTOMRIGHT', 4, 4)
				f.Group2:SetFrameLevel(7)
				f.Group2:SetFrameStrata('BACKGROUND')
				f.Group2:SetTemplate('Default', true)

				f.Group3 = CreateFrame('Frame', nil, f)
				f.Group3:Point('TOPLEFT', f.Critical.Icon, 'TOPLEFT', -4, 4)
				f.Group3:Point('BOTTOMRIGHT', f.Stamina.Icon, 'BOTTOMRIGHT', 4, 4)
				f.Group3:SetFrameLevel(7)
				f.Group3:SetFrameStrata('BACKGROUND')
				f.Group3:SetTemplate('Default', true)
				
				
				--<< Synergy Tracker (Target) >>--
				f = CreateFrame('Frame', 'KF_SynergyTracker_Target', KF.UIParent)
				f:Size(300, 20)
				f:SetScript('OnEvent', SynergyTracker_Player_Update)
				f.Unit = 'target'
				f.Tag = KF:Color_Value('Aura')
				f.FilterList = {}
				
				for i = 1, 8  do
					f.FilterList['Spell'..i] = true
					f['Spell'..i] = CreateButton(20)
					f['Spell'..i]:SetParent(f)
				end

				f.Spell7:Point('TOPRIGHT', f.Spell5, 'TOPLEFT', -47, 0)
				f.Spell7.FilterName = 'BloodLustDebuff'
				f.Spell7.Tag = L['Bloodlust Debuff']
				
				f.Spell5:Point('TOPRIGHT', f.Spell1, 'TOPLEFT', -4, 0)
				f.Spell1:Point('TOPRIGHT', f.Spell2, 'TOPLEFT', -4, 0)
				f.Spell2:Point('TOPRIGHT', KF_SynergyTracker_Target, 'BOTTOM', -2, -2)
				f.Spell3:Point('TOPLEFT', KF_SynergyTracker_Target, 'BOTTOM', 2, -2)
				f.Spell4:Point('TOPLEFT', f.Spell3, 'TOPRIGHT', 4, 0)
				f.Spell6:Point('TOPLEFT', f.Spell4, 'TOPRIGHT', 4, 0)
				
				f.Spell8:Point('TOPLEFT', f.Spell6, 'TOPRIGHT', 47, 0)
				f.Spell8.FilterName = 'ResurrectionDebuff'
				f.Spell8.Tag = L['Resurrection Debuff']
				
				f.Group1 = CreateFrame('Frame', nil, f)
				f.Group1:SetFrameLevel(7)
				f.Group1:SetFrameStrata('BACKGROUND')
				f.Group1:SetTemplate('Default', true)

				f.Group2 = CreateFrame('Frame', nil, f.Spell7)
				f.Group2:Point('TOPLEFT', f.Spell7.Icon, 'TOPLEFT', -4, 4)
				f.Group2:Point('BOTTOMRIGHT', f.Spell7.Icon, 'BOTTOMRIGHT', 4, 4)
				f.Group2:SetFrameLevel(7)
				f.Group2:SetFrameStrata('BACKGROUND')
				f.Group2:SetTemplate('Default', true)

				f.Group3 = CreateFrame('Frame', nil, f.Spell8)
				f.Group3:Point('TOPLEFT', f.Spell8.Icon, 'TOPLEFT', -4, 4)
				f.Group3:Point('BOTTOMRIGHT', f.Spell8.Icon, 'BOTTOMRIGHT', 4, 4)
				f.Group3:SetFrameLevel(7)
				f.Group3:SetFrameStrata('BACKGROUND')
				f.Group3:SetTemplate('Default', true)
				
				KF_SynergyTracker_Target:Hide()
			else
				KF_SynergyTracker_Player:Show()
			end
			
			if KF_TopPanel then
				KF_SynergyTracker_Player:Point('TOPRIGHT', KF_TopPanel, 'BOTTOMRIGHT', -8, 10)
				KF_SynergyTracker_Target:Point('CENTER', KF_TopPanel.LocationName)
			end
			
			KF_SynergyTracker_Player:RegisterUnitEvent('UNIT_AURA', 'player')
			KF_SynergyTracker_Player:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
			KF_SynergyTracker_Player:RegisterEvent('CHARACTER_POINTS_CHANGED')
			KF_SynergyTracker_Player:RegisterEvent('PLAYER_ENTERING_WORLD')
			KF:RegisterEventList('PLAYER_TARGET_CHANGED', SynergyTracker_Target_Setting, 'SynergyTracker_Target_Setting')
			KF_SynergyTracker_Target:RegisterUnitEvent('UNIT_AURA', 'target')
			
			M:UpdateSettings()
			SynergyTracker_Player_Update(KF_SynergyTracker_Player)
		elseif KF_SynergyTracker_Player or KF_SynergyTracker_Target then
			Activate = false
			
			KF_SynergyTracker_Player:Hide()
			KF_SynergyTracker_Player:UnregisterAllEvents()
			KF:UnregisterEventList('PLAYER_TARGET_CHANGED', 'SynergyTracker_Target_Setting')
			KF_SynergyTracker_Target:UnregisterAllEvents()
			KF_SynergyTracker_Target:Hide()
			
			if RemoveOrder ~= 'SwitchProfile' then
				M:UpdateSettings()
			end
		end
	end
	
	
	KF:RegisterCallback('TopPanel_Delete', function()
		KF.db.Modules.SynergyTracker = false
		KF.Modules.SynergyTracker(true)
	end, 'TurnOffAuraTrackerByTopPanel')
	
	--[[
	--<< Redifine TopPanel Location Update Condition >>--
	KF.UpdateList['TopPanelItemLevel'] = {
		['Condition'] = function() return CurrentTarget == 'Ally' and KF_TopPanel.LocationY.text:GetText() == nil and true or false end,
		['Delay'] = 1,
		['Action'] = function()
			Check = 0
			
			if UnitIsUnit('target', 'player') then
				Check = E:GetModule('Tooltip'):GetItemLvL('player') or 0
			else
				for _, Cache in pairs(E:GetModule('Tooltip').InspectCache) do
					if Cache.GUID == UnitGUID('target') then
						Check = Cache.ItemLevel or 0
						break
					end
				end
			end
			
			if Check > 0 then
				KF_TopPanel.LocationY.text:SetText(Check)
				return
			elseif CanInspect('target') and not E:GetModule('Tooltip'):IsInspectFrameOpen() and not (KF.UpdateList['NotifyInspect'] and KF.UpdateList['NotifyInspect']['Condition'] == true) and not (KF.UpdateList['RaidCooldownInspect'] and KF.UpdateList['RaidCooldownInspect']['Condition']() == true) then
				if not KF.Memory['Event']['INSPECT_READY'] or not KF.Memory['Event']['INSPECT_READY']['TargetAuraTracker_ItemLevel'] then
					KF:RegisterEventList('INSPECT_READY', function(self, GUID)
						self = E:GetModule('Tooltip')
						
						Check = nil
						for _, inspectCache in ipairs(self.InspectCache) do
							if inspectCache.GUID == GUID then
								inspectCache.ItemLevel = self:GetItemLvL('target')
								inspectCache.TalentSpec = self:GetTalentSpec('target')
								inspectCache.LastUpdate = floor(GetTime())
								Check = true
								break
							end
						end

						if not Check then
							self.InspectCache[#self.InspectCache + 1] = {
								['GUID'] = GUID,
								['ItemLevel'] = self:GetItemLvL('target'),
								['TalentSpec'] = self:GetTalentSpec('target'),
								['LastUpdate'] = floor(GetTime()),
							}
						end
						
						ClearInspectPlayer()
						KF.Memory['Event']['INSPECT_READY']['TargetAuraTracker_ItemLevel'] = nil
					end, 'TargetAuraTracker_ItemLevel')
				end
				NotifyInspect('target')
			end
		end,
	}
	]]
end