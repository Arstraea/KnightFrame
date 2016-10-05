--Cache global variables
--Lua functions
local _G = _G
local unpack, select, print, format = unpack, select, print, format

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

--WoW API / Variables
local CreateFrame = CreateFrame
local GetNumEquipmentSets = GetNumEquipmentSets
local GetEquipmentSetInfo = GetEquipmentSetInfo
local GetNumSpecGroups = GetNumSpecGroups
local GetSpecialization = GetSpecialization
local UnitLevel = UnitLevel
local SHOW_SPEC_LEVEL = SHOW_SPEC_LEVEL
local GetLootSpecialization = GetLootSpecialization
local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT
local GetSpecialization = GetSpecialization
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpecializationInfo = GetSpecializationInfo
local TalentMicroButton_OnClick = TalentMicroButton_OnClick
local EasyMenu = EasyMenu

--------------------------------------------------------------------------------
--<< KnightFrame : Custom DataText - SpecSwitch								>>--
--------------------------------------------------------------------------------
local ActiveSpec, IsTooltipShow
local displayString = ''
local activeString = '|cff84e1ff['..ACTIVE_PETS..']|r'
local numSpecGroup


local EquipmentSetName, IsEquipped
local function GetCurrentEquipmentSet()
	for i = 1, GetNumEquipmentSets() do
		EquipmentSetName, _, _, IsEquipped = GetEquipmentSetInfo(i)
		
		if IsEquipped then
			return EquipmentSetName
		end
	end
end


local function tooltipSetting(self)
	DropDownList1:Hide()
	DT:SetupTooltip(self)
	
	-- Specialization
	DT.tooltip:AddLine(KF:Color_Value('>> ')..L['Current Spec']..' : '..self.text:GetText()..KF:Color_Value(' <<'), 1, 1, 1)
	DT.tooltip:AddLine(' ') -- space
	
	-- Current EquipmentSet
	if GetCurrentEquipmentSet() then
		DT.tooltip:AddLine(KF:Color_Value('>> ')..L['Equipped Set']..' : |cff84e1ff'..GetCurrentEquipmentSet()..KF:Color_Value(' <<'), 1, 1, 1)
		DT.tooltip:AddLine(' ') -- space
	end
	
	-- Loot Specialization
	if UnitLevel('player') >= SHOW_SPEC_LEVEL then
		local lootSpec = GetLootSpecialization()
		
		if lootSpec == 0 then
			DT.tooltip:AddLine(KF:Color_Value('>> ')..SELECT_LOOT_SPECIALIZATION..' : '..format(LOOT_SPECIALIZATION_DEFAULT, self.text:GetText())..KF:Color_Value(' <<'), 1, 1, 1)
		else
			local _, Spec, _, _, _, specRole = GetSpecializationInfoByID(lootSpec)
			DT.tooltip:AddLine(KF:Color_Value('>> ')..SELECT_LOOT_SPECIALIZATION..' : '..(specRole == 'TANK' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank:14:14:2:1|t ' or specRole == 'HEALER' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer:14:14:2:0|t ' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps:14:14:2:-1|t ')..(Info.ClassRole[E.myclass][Spec] and Info.ClassRole[E.myclass][Spec].Color or '')..Spec..KF:Color_Value(' <<'), 1, 1, 1)
		end
		DT.tooltip:AddLine(' ') -- space
	end
	
	DT.tooltip:AddDoubleLine('- |cff84e1ff'..L['LeftClick'], L['Toggle Talent frame.'], 1, 1, 1, 1, 1, 1)
	
	if UnitLevel('player') >= SHOW_SPEC_LEVEL then
		DT.tooltip:AddDoubleLine('- |cff84e1ff'..L['RightClick'], L['Change Loot Specialization.'], 1, 1, 1, 1, 1, 1)
	end
	
	DT.tooltip:Show()
end


local function OnEvent(self, event)
	ActiveSpec = GetSpecialization()
	
	if ActiveSpec then
		_, ActiveSpec = GetSpecializationInfo(ActiveSpec)
	end
	
	self.text:SetText(ActiveSpec and (Info.ClassRole[E.myclass][ActiveSpec] and (Info.Role == 'Tank' and '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\tank:13:13:1:0|t ' or Info.Role == 'Healer' and '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\healer:13:13:1:0|t ' or '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\dps:13:13:1:0|t ')..Info.ClassRole[E.myclass][ActiveSpec].Color or '')..ActiveSpec..'|r' or L['No Spec'])
	
	if IsTooltipShow and not DropDownList1:IsShown() then
		tooltipSetting(self)
	end
	
	if event == 'PLAYER_LOOT_SPEC_UPDATED' and GetLootSpecialization() == 0 and ActiveSpec then
		print(format('|cff%02x%02x%02x', ChatTypeInfo.SYSTEM.r * 255, ChatTypeInfo.SYSTEM.g * 255, ChatTypeInfo.SYSTEM.b * 255)..format(ERR_LOOT_SPEC_CHANGED_S, strsub(LOOT_SPECIALIZATION_DEFAULT, 1, -7)))
	end
end


local function OnEnter(self)
	IsTooltipShow = true
	
	tooltipSetting(self)
end


local function OnLeave(self)
	IsTooltipShow = nil
	
	DT.tooltip:Hide()
end


--local menuFrame = CreateFrame("Frame", "LootSpecializationDatatextClickMenu", E.UIParent, "UIDropDownMenuTemplate")
local menuList = {
	[1] = { text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
	[2] = { notCheckable = true, func = function() SetLootSpecialization(0) end }
}
local function OnClick(self, button)
	if button == 'LeftButton' then
		TalentMicroButton_OnClick(TalentMicroButton)
	elseif button == 'RightButton' and UnitLevel('player') >= SHOW_SPEC_LEVEL then
		if DropDownList1:IsShown() then
			tooltipSetting(self)
		else
			DT.tooltip:Hide()
			
			menuList[2].text = ' 0. '..format(LOOT_SPECIALIZATION_DEFAULT, self.text:GetText())
			
			if #menuList == 2 then
				for i = 1, GetNumSpecializations() do
					local SpecID, Spec, _, _, _, SpecRole = GetSpecializationInfo(i)
					
					if SpecID then
						menuList[i + 2] = {
							notCheckable = true,
							text = ' '..i..'. '..(SpecRole == 'TANK' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank:14:14:2:1|t ' or SpecRole == 'HEALER' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer:14:14:2:0|t ' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps:14:14:2:-1|t ')..(Info.ClassRole[E.myclass][Spec] and Info.ClassRole[E.myclass][Spec].Color or '')..Spec,
							func = function() SetLootSpecialization(SpecID) end
						}
					end
				end
			end

			EasyMenu(menuList, LootSpecializationDatatextClickMenu, 'cursor', -45, 20, 'MENU', 5)
		end
	end
end


DT:RegisterDatatext('SpecSwitch |cff2eb7e4(KF)', {'PLAYER_ENTERING_WORLD', 'CHARACTER_POINTS_CHANGED', 'PLAYER_TALENT_UPDATE', 'ACTIVE_TALENT_GROUP_CHANGED', 'PLAYER_LOOT_SPEC_UPDATED'}, OnEvent, nil, OnClick, OnEnter, OnLeave)