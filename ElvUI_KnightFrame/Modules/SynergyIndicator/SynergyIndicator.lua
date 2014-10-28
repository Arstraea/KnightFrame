local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))
local A = E:GetModule('Auras')
local M = E:GetModule('Minimap')

--------------------------------------------------------------------------------
--<< KnightFrame : Synergy Indicator										>>--
--------------------------------------------------------------------------------
local SI = _G['KF_SynergyIndicator'] or CreateFrame('Frame', 'KF_SynergyIndicator', KF.UIParent)
local x, y


SI.BorderColor = {
	Default = { 1, 0.86, 0.24 },
	HARMFUL = { 1, 0, 0 }
}


do --<< Button Script >>--
	function SI:UpdateDuration()
		self.Timer:SetValue(floor((self.Expiration - GetTime()) / self.Duration * 100))
	end
	
	
	function SI:Button_OnEnter()
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT', 20, -4)
		
		local Tracker = self:GetParent()
		local RemainTime, FormatID
		
		Tracker:SetScript('OnUpdate', function()
			GameTooltip:ClearLines()
			GameTooltip:AddLine(Tracker.Tag..' : |cffffdc3c'..self.Tag..'|r', 1, 1, 1)
			
			if self.SpellName then
				RemainTime = self.Expiration - GetTime()
				
				if RemainTime > 0 then
					RemainTime, formatID = E:GetTimeInfo(RemainTime, 4)
				end
				
				GameTooltip:AddLine(' ')
				GameTooltip:AddDoubleLine('|cff6dd66d'..L['Applied']..'|r : ', RemainTime > 0 and format(format('%s%s|r', E.TimeColors[formatID], E.TimeFormats[formatID][1]), RemainTime) or '', 1, 1, 1, 1, 1, 1)
				GameTooltip:AddDoubleLine(' '..self.SpellName, self.Caster or ' ', .44, .84, 1, 1, 1, 1)
			else
				GameTooltip:AddLine('|n'..'|cffb9062f'..L['Non-applied'], 1, 1, 1)
				
				RemainTime = nil
				
				for i = 1, #Info.SynergyIndicator_Filters[self.FilterName] do
					if type(Info.SynergyIndicator_Filters[self.FilterName][i]) == 'table' and Info.SynergyIndicator_Filters[self.FilterName][i][2] then
						if i == 1 then
							GameTooltip:AddLine(' ')
						end
						
						GameTooltip:AddDoubleLine(Info.SynergyIndicator_Filters[self.FilterName][i][1], Info.SynergyIndicator_Filters[self.FilterName][i][2], .44, .84, 1, 1, 1, 1)
					elseif Info.SynergyIndicator_Filters[self.FilterName][i] == true then
						GameTooltip:AddLine(' ')
					end
				end
			end
			
			GameTooltip:Show()
		end)
	end


	function SI:Button_OnLeave()
		self:GetParent():SetScript('OnUpdate', nil)
		GameTooltip:Hide()
	end


	function SI:Button_OnClick(Button)
		if self:GetParent() == KF_SynergyIndicator_Player then
			if not IsShiftKeyDown() and Button == 'RightButton' and self.SpellName then
				CancelUnitBuff('player', self.SpellName)
			end
		end
	end
	
	
	function SI:CreateButton(Button, IconWidth, IconHeight)
		Button.IconWidth = IconWidth
		Button.IconHeight = IconHeight or IconWidth
		Button:Size(Button.IconWidth, Button.IconHeight)
		Button:SetFrameLevel(10)
		Button:SetFrameStrata('HIGH')
		Button:RegisterForClicks('AnyUp')
		
		Button.Icon = Button.Icon or CreateFrame('Frame', nil, Button)
		Button.Icon:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Button.Icon:SetBackdropColor(0, 0, 0, 1)
		Button.Icon:Size(Button.IconWidth, Button.IconHeight)
		Button.Icon:SetFrameLevel(8)
		Button.Icon:Point('TOP', Button)
		
		Button.Texture = Button.Texture or Button.Icon:CreateTexture(nil, 'OVERLAY')
		Button.Texture:SetTexCoord(unpack(E.TexCoords))
		Button.Texture:SetInside()
		
		Button.TimerBG = Button.TimerBG or CreateFrame('Frame', nil, Button)
		Button.TimerBG:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Button.TimerBG:SetBackdropColor(0, 0, 0, 1)
		Button.TimerBG:Size(IconWidth, 5)
		Button.TimerBG:SetFrameLevel(8)
		Button.TimerBG:Point('TOP', Button.Icon, 'BOTTOM', 0, -1)
		
		Button.Timer = Button.Timer or CreateFrame('StatusBar', nil, Button.TimerBG)
		Button.Timer:SetMinMaxValues(0, 100)
		Button.Timer:SetStatusBarTexture(E.media.blankTex)
		Button.Timer:SetFrameLevel(9)
		Button.Timer:Point('TOPLEFT', 2, -2)
		Button.Timer:Point('BOTTOMRIGHT', -2, 2)
		Button.Timer:SetStatusBarColor(1, 1, 1, 1)
		
		Button.TimerBG:Hide()
		
		Button:SetScript('OnEnter', self.Button_OnEnter)
		Button:SetScript('OnLeave', self.Button_OnLeave)
		Button:SetScript('OnClick', self.Button_OnClick)
		
		return Button
	end
end


function SI:CheckAura(Unit, SpellName, SpellType)
	local Icon, Duration, Expiration, Caster
	
	SpellName, _, Icon, _, _, Duration, Expiration, Caster = UnitAura(Unit, SpellName, nil, SpellType)
	Caster = Caster and KF:Color_Class(select(2, UnitClass(Caster)), UnitName(Caster)) or nil
	
	return SpellName, Icon, Duration, Expiration, Caster
end


function SI:CheckFilters(FilterName, Unit)
	if not Info.SynergyIndicator_Filters[FilterName] then return end
	
	local Icon, Duration, Expiration, Caster
	
	for i = 1, #Info.SynergyIndicator_Filters[FilterName] do
		if type(Info.SynergyIndicator_Filters[FilterName][i]) == 'table' then
			_, Icon, Duration, Expiration, Caster = self:CheckAura(Unit, Info.SynergyIndicator_Filters[FilterName][i][1], Info.SynergyIndicator_Filters[FilterName].Type)
			
			if Icon then
				return Info.SynergyIndicator_Filters[FilterName][i][1], Icon, Duration, Expiration, Caster
			end
		end
	end 
end


function SI:UpdateIndicator()
	self.needUpdate = nil
	
	local SpellName, Icon, Duration, Expiration, Caster
	
	for IconName in pairs(self.FilterList) do
		if self[IconName].SpellName then
			SpellName, Icon, Duration, Expiration, Caster = SI:CheckAura(self.Unit, self[IconName].SpellName, Info.SynergyIndicator_Filters[self[IconName].FilterName].Type)
		else
			SpellName, Icon, Duration, Expiration, Caster = SI:CheckFilters(self[IconName].FilterName, self.Unit)
		end
		
		if not SpellName then
			if self[IconName].SpellName then
				self.needUpdate = true
			end
			
			if Info.SynergyIndicator_Filters[self[IconName].FilterName].ShownWhenHasAura then
				self[IconName]:Hide()
			end
			
			self[IconName].SpellName = nil
			self[IconName].Duration = nil
			self[IconName].Expiration = nil
			self[IconName].Caster = nil
			
			self[IconName]:SetScript('OnUpdate', nil)
			self[IconName].Texture:SetTexture(Info.SynergyIndicator_Filters[self[IconName].FilterName].MainIcon)
			self[IconName].Texture:SetAlpha(.4)
			self[IconName].Icon:SetBackdropBorderColor(unpack(E.media.bordercolor))
			self[IconName].TimerBG:Hide()
			
			self[IconName]:Size(self[IconName].IconWidth, self[IconName].IconHeight)
		elseif not self[IconName].SpellName or (self[IconName].Expiration and self[IconName].Expiration ~= Expiration) then
			self[IconName]:Show()
			
			self[IconName].SpellName = SpellName
			self[IconName].Duration = Duration
			self[IconName].Expiration = Expiration
			self[IconName].Caster = Caster
			
			self[IconName].Texture:SetTexture(Icon)
			self[IconName].Texture:SetAlpha(1)
			self[IconName].Icon:SetBackdropBorderColor(unpack(SI.BorderColor[Info.SynergyIndicator_Filters[self[IconName].FilterName].Type] or SI.BorderColor.Default))
			self[IconName].TimerBG:SetBackdropBorderColor(unpack(SI.BorderColor[Info.SynergyIndicator_Filters[self[IconName].FilterName].Type] or SI.BorderColor.Default))
			
			if Duration > 0 then
				self[IconName].TimerBG:Show()
				
				self[IconName]:SetScript('OnUpdate', SI.UpdateDuration)
				self[IconName]:Size(self[IconName].IconWidth, self[IconName].IconHeight + 6)
				SI.UpdateDuration(self[IconName])
			else
				self[IconName].TimerBG:Hide()
				
				self[IconName]:SetScript('OnUpdate', nil)
				self[IconName]:Size(self[IconName].IconWidth, self[IconName].IconHeight)
			end
		end
	end
	
	if self.needUpdate then
		self:SetScript('OnUpdate', function()
			self:SetScript('OnUpdate', nil)
			SI.UpdateIndicator(self)
		end)
	end
end


function SI:TargetIndicatorSetting()
	SI.Target:UnregisterAllEvents()
	
	if not UnitExists('target') then
		SI.Target:Hide()
		SI:UpdateLocation()
		
		return false
	else
		SI.Target:Show()
		
		local unitColor, TargetType
		if UnitCanAttack('player', 'target') or UnitIsEnemy('player', 'target') then
			SI.Target:Hide()
			
			if UnitIsPlayer('target') then
				TargetType = 'Enemy'
				unitColor = KF:Color_Class(select(2, UnitClass('target')), nil)
			else
				TargetType = 'Monster'
				unitColor = '|cffcd4c37'
			end
		else
			if UnitIsPlayer('target') then
				SI.Target:Show()
				
				SI.Target.Slot10.Tag = L['Bloodlust Debuff']
				SI.Target.Slot10.FilterName = 'BloodLustDebuff'
				
				SI.Target.Slot1.Tag = RAID_BUFF_6
				SI.Target.Slot1.FilterName = 'Critical'
				SI.Target.Slot2.Tag = RAID_BUFF_4
				SI.Target.Slot2.FilterName = 'Haste'
				SI.Target.Slot3.Tag = RAID_BUFF_8
				SI.Target.Slot3.FilterName = 'MultiStrike'
				SI.Target.Slot4.Tag = RAID_BUFF_9
				SI.Target.Slot4.FilterName = 'Versatility'
				
				SI.Target.Slot5.Tag = RAID_BUFF_1
				SI.Target.Slot5.FilterName = 'AllStats'
				
				SI.Target.Slot6.Tag = RAID_BUFF_3
				SI.Target.Slot6.FilterName = 'AttackPower'
				SI.Target.Slot7.Tag = RAID_BUFF_5
				SI.Target.Slot7.FilterName = 'SpellPower'
				SI.Target.Slot8.Tag = RAID_BUFF_7
				SI.Target.Slot8.FilterName = 'Mastery'
				SI.Target.Slot9.Tag = RAID_BUFF_2
				SI.Target.Slot9.FilterName = 'Stamina'
				
				SI.Target.Slot11.Tag = L['Resurrection Debuff']
				SI.Target.Slot11.FilterName = 'ResurrectionDebuff'
				
				SI.UpdateIndicator(SI.Target)
				SI.Target:RegisterUnitEvent('UNIT_AURA', 'target')
				SI.Target:RegisterUnitEvent('UNIT_FACTION', 'target')
				
				TargetType = 'Ally'
				unitColor = KF:Color_Class(select(2, UnitClass('target')), nil)
			else
				SI.Target:Hide()
				
				TargetType = 'NPC'
				unitColor = '|cff20ff20'
			end
		end
		
		SI.LocationName.text:SetText(unitColor..UnitName('target'))
		
		local Classifi = UnitClassification('target')
		local CanAttack = UnitCanAttack('player', 'target')
		local unitLevel = UnitLevel('target')
		unitColor = GetQuestDifficultyColor(unitLevel)
		
		if Classifi == 'worldboss' then Classifi = 'WB'
		elseif Classifi == 'rareelite' then Classifi = 'RE'
		elseif Classifi == 'elite' then Classifi = 'E'
		elseif Classifi == 'rare' then Classifi = 'R'
		else Classifi = '' end
		
		SI.LocationX.text:SetText(format('|cff%02x%02x%02x%s%s|r',
			((CanAttack and (Classifi == 'WB' or unitLevel == -1)) and .6 or unitColor.r) * 255,
			((CanAttack and (Classifi == 'WB' or unitLevel == -1)) and 0 or unitColor.g) * 255,
			((CanAttack and (Classifi == 'WB' or unitLevel == -1)) and 0 or unitColor.b) * 255, unitLevel > 0 and unitLevel or '??', ' '..(Classifi == 'WB' and '|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:0|t' or Classifi)))
		SI.LocationY.text:SetText(nil)
		
		if SI.Target.TargetType ~= TargetType then
			SI.Target.TargetType = TargetType
			return true
		end
	end
end


function SI:UpdateLocation()
	if not UnitExists('target') and SI:IsShown() then
		x, y = GetPlayerMapPosition('player')
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		SI.LocationName.text:SetText(strsub(GetMinimapZoneText(), 1))
		SI.LocationName.text:SetTextColor(M:GetLocTextColor())
		
		SI.LocationX.text:SetText(x == 0 and '...' or KF:Color_Value(x))
		SI.LocationY.text:SetText(y == 0 and '...' or KF:Color_Value(y))
	end
end


function SI:Setup_SynergyIndicator()
	self:SetFrameStrata('BACKGROUND')
	self:CreateBackdrop('Transparent')
	self:Point('TOPLEFT', KF.UIParent, 6, 2)
	
	do -- Location Display
		self.LocationHolder = CreateFrame('Frame', nil, self)
		self.LocationHolder:CreateBackdrop('Transparent')
		self.LocationHolder:Size(354, 16)
		self.LocationHolder:Point('BOTTOM', self, 0, -8)
		self.LocationHolder:SetFrameLevel(10)
		
		self.LocationName = CreateFrame('Frame', nil, self.LocationHolder)
		self.LocationName:SetTemplate('Default', true)
		self.LocationName.backdropTexture:SetVertexColor(.1, .1, .1)
		self.LocationName:Size(250, 20)
		self.LocationName:Point('BOTTOM', self.LocationHolder, 0, -6)
		self.LocationName:SetFrameLevel(11)
		KF:TextSetting(self.LocationName, nil, { Fontsize = 12, FontOutline = 'NONE' })
		
		self.LocationX = CreateFrame('Frame', nil, self.LocationName)
		self.LocationX:SetTemplate('Default', true)
		self.LocationX.backdropTexture:SetVertexColor(.1, .1, .1)
		self.LocationX:Size(46, 20)
		self.LocationX:Point('RIGHT', self.LocationName, 'LEFT', -4, 0)
		self.LocationX:SetFrameLevel(11)
		KF:TextSetting(self.LocationX, nil, { FontSize = 12, FontOutline = 'NONE' })
		
		self.LocationY = CreateFrame('Frame', nil, self.LocationName)
		self.LocationY:SetTemplate('Default', true)
		self.LocationY.backdropTexture:SetVertexColor(.1, .1, .1)
		self.LocationY:Size(46, 20)
		self.LocationY:Point('LEFT', self.LocationName, 'RIGHT', 4, 0)
		self.LocationY:SetFrameLevel(11)
		KF:TextSetting(self.LocationY, nil, { FontSize = 12, FontOutline = 'NONE' })
	end
	
	do -- Indicator(Player) --
		self.Player = CreateFrame('Frame', 'KF_SynergyIndicator_Player', KF.UIParent)
		self.Player:Size(250, 20)
		self.Player:Point('TOPRIGHT', self, 'BOTTOMRIGHT', -8, 10)
		self.Player:SetScript('OnEvent', self.UpdateIndicator)
		self.Player.Unit = 'player'
		self.Player.Tag = KF:Color_Value('Synergy')
		self.Player.FilterList = {
			Critical = true,
			Haste = true,
			MultiStrike = true,
			Versatility = true,
			AllStats = true,
			AttackPower = true,
			SpellPower = true,
			Mastery = true,
			Stamina = true
		}
		
		for frameName in pairs(self.Player.FilterList) do
			self.Player[frameName] = self:CreateButton(CreateFrame('Button', nil, self.Player), 20)
			self.Player[frameName].FilterName = frameName
		end

		self.Player.Critical:Point('TOPRIGHT', self.Player.Haste, 'TOPLEFT', -4, 0)
		self.Player.Critical.Tag = RAID_BUFF_6
		self.Player.Haste:Point('TOPRIGHT', self.Player.MultiStrike, 'TOPLEFT', -4, 0)
		self.Player.Haste.Tag = RAID_BUFF_4
		self.Player.MultiStrike:Point('TOPRIGHT', self.Player.Versatility, 'TOPLEFT', -4, 0)
		self.Player.MultiStrike.Tag = RAID_BUFF_8
		self.Player.Versatility:Point('TOPRIGHT', self.Player.AllStats, 'TOPLEFT', -19, 0)
		self.Player.Versatility.Tag = RAID_BUFF_9

		self.Player.AllStats:Point('TOP', self.Player, 'BOTTOM', 0, 16)
		self.Player.AllStats.Tag = RAID_BUFF_1

		self.Player.AttackPower:Point('TOPLEFT', self.Player.AllStats, 'TOPRIGHT', 19, 0)
		self.Player.AttackPower.Tag = RAID_BUFF_3
		self.Player.SpellPower:Point('TOPLEFT', self.Player.AttackPower, 'TOPRIGHT', 4, 0)
		self.Player.SpellPower.Tag = RAID_BUFF_5
		self.Player.Mastery:Point('TOPLEFT', self.Player.SpellPower, 'TOPRIGHT', 4, 0)
		self.Player.Mastery.Tag = RAID_BUFF_7
		self.Player.Stamina:Point('TOPLEFT', self.Player.Mastery, 'TOPRIGHT', 4, 0)
		self.Player.Stamina.Tag = RAID_BUFF_2
		
		self.Player.Group1 = CreateFrame('Frame', nil, self.Player)
		self.Player.Group1:Point('TOPLEFT', self.Player.Critical.Icon, -4, 4)
		self.Player.Group1:Point('BOTTOMRIGHT', self.Player.Versatility.Icon, 4, 4)
		self.Player.Group1:SetFrameLevel(7)
		self.Player.Group1:SetFrameStrata('BACKGROUND')
		self.Player.Group1:SetTemplate('Default', true)

		self.Player.Group2 = CreateFrame('Frame', nil, self.Player)
		self.Player.Group2:Point('TOPLEFT', self.Player.AllStats.Icon, -4, 4)
		self.Player.Group2:Point('BOTTOMRIGHT', self.Player.AllStats.Icon, 4, 4)
		self.Player.Group2:SetFrameLevel(7)
		self.Player.Group2:SetFrameStrata('BACKGROUND')
		self.Player.Group2:SetTemplate('Default', true)

		self.Player.Group3 = CreateFrame('Frame', nil, self.Player)
		self.Player.Group3:Point('TOPLEFT', self.Player.AttackPower.Icon, -4, 4)
		self.Player.Group3:Point('BOTTOMRIGHT', self.Player.Stamina.Icon, 4, 4)
		self.Player.Group3:SetFrameLevel(7)
		self.Player.Group3:SetFrameStrata('BACKGROUND')
		self.Player.Group3:SetTemplate('Default', true)
	end
	
	do -- Indicator(Target) --
		self.Target = CreateFrame('Frame', 'KF_SynergyIndicator_Target', KF.UIParent)
		self.Target:SetScript('OnEvent', function(_, Event)
			if Event == 'UNIT_FACTION' and SI:TargetIndicatorSetting() or Event == 'UNIT_AURA' then
				self.UpdateIndicator(self.Target)
			end
		end)
		self.Target.Unit = 'target'
		self.Target.Tag = KF:Color_Value('Aura')
		self.Target.FilterList = {}
		
		for i = 1, 11 do
			self.Target.FilterList['Slot'..i] = true
			self.Target['Slot'..i] = self:CreateButton(CreateFrame('Button', nil, self.Target), 20)
		end
		
		self.Target.Slot10:Point('TOP', self.LocationX, 'BOTTOM', 0, -2)
		
		self.Target.Slot1:Point('TOPRIGHT', self.Target.Slot2, 'TOPLEFT', -3, 0)
		self.Target.Slot2:Point('TOPRIGHT', self.Target.Slot3, 'TOPLEFT', -3, 0)
		self.Target.Slot3:Point('TOPRIGHT', self.Target.Slot4, 'TOPLEFT', -3, 0)
		self.Target.Slot4:Point('TOPRIGHT', self.Target.Slot5, 'TOPLEFT', -13, 0)

		self.Target.Slot5:Point('TOP', self.LocationName, 'BOTTOM', 0, -2)

		self.Target.Slot6:Point('TOPLEFT', self.Target.Slot5, 'TOPRIGHT', 13, 0)
		self.Target.Slot7:Point('TOPLEFT', self.Target.Slot6, 'TOPRIGHT', 3, 0)
		self.Target.Slot8:Point('TOPLEFT', self.Target.Slot7, 'TOPRIGHT', 3, 0)
		self.Target.Slot9:Point('TOPLEFT', self.Target.Slot8, 'TOPRIGHT', 3, 0)
		
		self.Target.Slot11:Point('TOP', self.LocationY, 'BOTTOM', 0, -2)
		
		self.Target.Group1 = CreateFrame('Frame', nil, self.Target)
		self.Target.Group1:Point('TOPLEFT', self.Target.Slot1.Icon, -3, 4)
		self.Target.Group1:Point('BOTTOMRIGHT', self.Target.Slot4.Icon, 'RIGHT', 3, 0)
		self.Target.Group1:SetFrameLevel(7)
		self.Target.Group1:SetFrameStrata('BACKGROUND')
		self.Target.Group1:SetTemplate('Default', true)

		self.Target.Group2 = CreateFrame('Frame', nil, self.Target)
		self.Target.Group2:Point('TOPLEFT', self.Target.Slot5.Icon, -3, 4)
		self.Target.Group2:Point('BOTTOMRIGHT', self.Target.Slot5.Icon, 'RIGHT', 3, 0)
		self.Target.Group2:SetFrameLevel(7)
		self.Target.Group2:SetFrameStrata('BACKGROUND')
		self.Target.Group2:SetTemplate('Default', true)

		self.Target.Group3 = CreateFrame('Frame', nil, self.Target)
		self.Target.Group3:Point('TOPLEFT', self.Target.Slot6.Icon, -3, 4)
		self.Target.Group3:Point('BOTTOMRIGHT', self.Target.Slot9.Icon, 'RIGHT', 3, 0)
		self.Target.Group3:SetFrameLevel(7)
		self.Target.Group3:SetFrameStrata('BACKGROUND')
		self.Target.Group3:SetTemplate('Default', true)
		
		self.Target.Group4 = CreateFrame('Frame', nil, self.Target.Slot10)
		self.Target.Group4:Point('TOPLEFT', self.Target.Slot10.Icon, -3, 4)
		self.Target.Group4:Point('BOTTOMRIGHT', self.Target.Slot10.Icon, 'RIGHT', 3, 0)
		self.Target.Group4:SetFrameLevel(7)
		self.Target.Group4:SetFrameStrata('BACKGROUND')
		self.Target.Group4:SetTemplate('Default', true)
		
		self.Target.Group5 = CreateFrame('Frame', nil, self.Target.Slot11)
		self.Target.Group5:Point('TOPLEFT', self.Target.Slot11.Icon, -3, 4)
		self.Target.Group5:Point('BOTTOMRIGHT', self.Target.Slot11.Icon, 'RIGHT', 3, 0)
		self.Target.Group5:SetFrameLevel(7)
		self.Target.Group5:SetFrameStrata('BACKGROUND')
		self.Target.Group5:SetTemplate('Default', true)
	end
	
	self.Setup_SynergyIndicator = nil
end


KF.Modules[#KF.Modules + 1] = 'SynergyIndicator'
KF.Modules.SynergyIndicator = function(RemoveOrder)
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.SynergyIndicator.Enable ~= false then
		Info.SynergyIndicator_Activate = true
		
		DB.Modules.SynergyIndicator.BackUp.Use_ConsolidatedBuffs = E.db.auras.consolidatedBuffs.enable
		E.db.auras.consolidatedBuffs.enable = true
		M:UpdateSettings()
		
		DB.Modules.SynergyIndicator.BackUp.Use_TopPanel = E.db.general.topPanel
		E.db.general.topPanel = false
		E.Layout:TopPanelVisibility()
		
		if SI.Setup_SynergyIndicator then
			SI:Setup_SynergyIndicator()
			
			hooksecurefunc(M, 'UpdateSettings', function()
				if Info.SynergyIndicator_Activate then
					if MMHolder then
						MMHolder:Width(Minimap:GetWidth() + (E.PixelMode and 3 or 4))
					end
					
					if ElvConfigToggle then
						ElvConfigToggle:Hide()
					end
					
					if A.DisableCB then
						A:DisableCB()
					end
				end
			end)
		else
			SI:Show()
			SI.Player:Show()
		end
		
		SI:Point('BOTTOMRIGHT', KF.UIParent, 'TOPRIGHT', -6, -(2 + DB.Modules.SynergyIndicator.TopPanel_Height))
		
		KF:RegisterEventList('PLAYER_STARTED_MOVING', function() Timer.SI_UpdateLocation = C_Timer.NewTicker(.25, SI.UpdateLocation) end, 'SI_UpdateLocation')
		KF:RegisterEventList('PLAYER_STOPPED_MOVING', Timer.SI_UpdateLocation.Cancel, 'SI_UpdateLocation')
		KF:RegisterEventList('PLAYER_ENTERING_WORLD', SI.UpdateLocation, 'SI_UpdateLocation')
		KF:RegisterEventList('WORLD_MAP_UPDATE', SI.UpdateLocation, 'SI_UpdateLocation')
		SI:UpdateLocation()
		
		SI.Player:RegisterUnitEvent('UNIT_AURA', 'player')
		SI.Player:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		SI.Player:RegisterEvent('CHARACTER_POINTS_CHANGED')
		SI.Player:RegisterEvent('PLAYER_ENTERING_WORLD')
		SI.UpdateIndicator(SI.Player)
		
		KF:RegisterEventList('PLAYER_TARGET_CHANGED', SI.TargetIndicatorSetting, 'SI_TargetSetting')
		
		if UnitExists('target') then
			SI.Target:Show()
			SI.UpdateIndicator(SI.Target)
		else
			SI.Target:Hide()
		end
	elseif not SI.Setup_SynergyIndicator then
		Info.SynergyIndicator_Activate = nil
		
		SI:Hide()
		
		KF:UnregisterEventList('PLAYER_STARTED_MOVING', 'SI_UpdateLocation')
		KF:UnregisterEventList('PLAYER_STOPPED_MOVING', 'SI_UpdateLocation')
		KF:UnregisterEventList('PLAYER_ENTERING_WORLD', 'SI_UpdateLocation')
		KF:UnregisterEventList('WORLD_MAP_UPDATE', 'SI_UpdateLocation')
		
		SI.Player:UnregisterAllEvents()
		SI.Player:Hide()
		
		KF:UnregisterEventList('PLAYER_TARGET_CHANGED', 'SI_TargetSetting')
		SI.Target:UnregisterAllEvents()
		SI.Target:Hide()
		
		if RemoveOrder ~= 'SwitchProfile' then
			E.db.auras.consolidatedBuffs.enable = DB.Modules.SynergyIndicator.BackUp.Use_ConsolidatedBuffs
			DB.Modules.SynergyIndicator.BackUp.Use_ConsolidatedBuffs = true
			M:UpdateSettings()
			
			E.db.general.topPanel = DB.Modules.SynergyIndicator.BackUp.Use_TopPanel
			DB.Modules.SynergyIndicator.BackUp.Use_TopPanel = false
			E.Layout:TopPanelVisibility()
		end
	end
end






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