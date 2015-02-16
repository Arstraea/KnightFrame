local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Register Callbacks	 									>>--
--------------------------------------------------------------------------------
function KF:RegisterCallback(RegisterName, InputFunction, FunctionName)
	KF.Callbacks[RegisterName] = KF.Callbacks[RegisterName] or {}
	
	FunctionName = FunctionName or (#KF.Callbacks[RegisterName] + 1)
	KF.Callbacks[RegisterName][FunctionName] = InputFunction
end


function KF:UnregisterCallback(RegisterName, FunctionName)
	if not (KF.Callbacks[RegisterName] and KF.Callbacks[RegisterName][FunctionName]) then
		return
	else
		KF.Callbacks[RegisterName][FunctionName] = nil
		
		if not next(KF.Callbacks[RegisterName]) then
			KF.Callbacks[RegisterName] = nil
		end
	end
end


function KF:CallbackFire(RegisterName, ...)
	if KF.Callbacks[RegisterName] then
		for _, RegisteredFunction in pairs(KF.Callbacks[RegisterName]) do
			RegisteredFunction(RegisterName, ...)
		end
	end
end




--------------------------------------------------------------------------------
--<< KnightFrame : Register Events											>>--
--------------------------------------------------------------------------------
function KF:RegisterEventList(EventName, InputFunction, FunctionName)
	if not KF.Events[EventName] then
		KF.Events[EventName] = {}
		
		KF:RegisterEvent(EventName, function(...)
			for _, SavedFunction in pairs(KF.Events[EventName]) do
				SavedFunction(...)
			end
		end)
	end
	
	FunctionName = FunctionName or (#KF.Events[EventName] + 1)
	KF.Events[EventName][FunctionName] = InputFunction
end


function KF:UnregisterEventList(EventName, FunctionName)
	if not (KF.Events[EventName] and KF.Events[EventName][FunctionName]) then
		return
	else
		KF.Events[EventName][FunctionName] = nil
		
		if not next(KF.Events[EventName]) then
			KF:UnregisterEvent(EventName)
			KF.Events[EventName] = nil
		end
	end
end





--------------------------------------------------------------------------------
--<< KnightFrame : Register Timer											>>--
--------------------------------------------------------------------------------
function KF:RegisterTimer(TimerName, Type, Duration, Callback, Iteration, InitFunc)
	if not Timer[TimerName] or Timer[TimerName]._cancelled then
		if InitFunc then
			Callback()
		end
		Timer[TimerName] = C_Timer[Type](Duration, Callback, Iteration)
	end
end


function KF:CancelTimer(TimerName)
	if Timer[TimerName] and not Timer[TimerName]._cancelled then
		Timer[TimerName]:Cancel()
	end
end

--[[
KNIGHTFRAME_ADS_MESSAGE = '높망 영웅 [탱1][힐4][딜16] 손님4분 받습니다 1/1 3탐'
KF:RegisterTimer('광고', 'NewTicker', 30, function()
	SendChatMessage(KNIGHTFRAME_ADS_MESSAGE, 'CHANNEL', nil, GetChannelName('파티'))
end, nil, true)
]]
--/run ElvUI_KnightFrame[1]:CancelTimer('광고')


--------------------------------------------------------------------------------
--<< KnightFrame : Toggle KnightFrame During Pet Battle						>>--
--------------------------------------------------------------------------------
local function ToggleKnightFrameDuringWowkemon()
	if KF.UIParent then
		if C_PetBattles.IsInBattle() then
			KF.UIParent:Hide()
		else
			KF.UIParent:Show()
		end
	end
end
KF:RegisterEventList('PET_BATTLE_CLOSE', ToggleKnightFrameDuringWowkemon, 'ToggleKnightFrameDuringWowkemon')
KF:RegisterEventList('PET_BATTLE_OPENING_START', ToggleKnightFrameDuringWowkemon, 'ToggleKnightFrameDuringWowkemon')




--------------------------------------------------------------------------------
--<< KnightFrame : Check Player Role										>>--
--------------------------------------------------------------------------------
Info.Role = 'Melee' -- Default
Info.ClassRole = {
	WARRIOR = {
		[(L['Spec_Warrior_Arms'])] = { --무기
			Color = '|cff9a9a9a',
			Role = 'Melee'
		},
		[(L['Spec_Warrior_Fury'])] = { --분노
			Color = '|cffb50000',
			Role = 'Melee'
		},
		[(L['Spec_Warrior_Protection'])] = { --방어
			Color = '|cff088fdc',
			Role = 'Tank'
		}
	},
	HUNTER = {
		[(L['Spec_Hunter_Beast'])] = { --야수
			Color = '|cffffdb00',
			Role = 'Melee'
		},
		[(L['Spec_Hunter_Marksmanship'])] = { --사격
			Color = '|cffea5455',
			Role = 'Melee'
		},
		[(L['Spec_Hunter_Survival'])] = { --생존
			Color = '|cffbaf71d',
			Role = 'Melee'
		}
	},
	SHAMAN = {
		[(L['Spec_Shaman_Elemental'])] = { --정기
			Color = '|cff2be5fa',
			Role = 'Caster'
		},
		[(L['Spec_Shaman_Enhancement'])] = { --고양
			Color = '|cffe60000',
			Role = 'Melee'
		},
		[(L['Spec_Shaman_Restoration'])] = { --복원
			Color = '|cff00ff0c',
			Role = 'Healer'
		}
	},
	MONK = {
		[(L['Spec_Monk_Brewmaster'])] = { --양조
			Color = '|cffbcae6d',
			Role = 'Tank'
		},
		[(L['Spec_Monk_Mistweaver'])] = { --운무
			Color = '|cffb6f1b7',
			Role = 'Healer'
		},
		[(L['Spec_Monk_Windwalker'])] = { --풍운
			Color = '|cffb2c6de',
			Role = 'Melee'
		}
	},
	ROGUE = {
		[(L['Spec_Rogue_Assassination'])] = { --암살
			Color = '|cff129800',
			Role = 'Melee'
		},
		[(L['Spec_Rogue_Combat'])] = { --전투
			Color = '|cffbc0001',
			Role = 'Melee'
		},
		[(L['Spec_Rogue_Subtlety'])] = { --잠행
			Color = '|cfff48cba',
			Role = 'Melee'
		}
	},
	DEATHKNIGHT = {
		[(L['Spec_DeathKnight_Blood'])] = { --혈기
			Color = '|cffbc0001',
			Role = 'Tank'
		},
		[(L['Spec_DeathKnight_Frost'])] = { --냉기
			Color = '|cff1784d1',
			Role = 'Melee'
		},
		[(L['Spec_DeathKnight_Unholy'])] = { --부정
			Color = '|cff00ff10',
			Role = 'Melee'
		}
	},
	MAGE = {
		[(L['Spec_Mage_Arcane'])] = { --비전
			Color = '|cffdcb0fb',
			Role = 'Caster'
		},
		[(L['Spec_Mage_Fire'])] = { --화염
			Color = '|cffff3615',
			Role = 'Caster'
		},
		[(L['Spec_Mage_Frost'])] = { --냉기
			Color = '|cff1784d1',
			Role = 'Caster'
		}
	},
	DRUID = {
		[(L['Spec_Druid_Balance'])] = { --조화
			Color = '|cffff7d0a',
			Role = 'Caster'
		},
		[(L['Spec_Druid_Feral'])] = { --야성
			Color = '|cffffdb00',
			Role = 'Melee'
		},
		[(L['Spec_Druid_Guardian'])] = { --수호
			Color = '|cff088fdc',
			Role = 'Tank'
		},
		[(L['Spec_Druid_Restoration'])] = { --회복
			Color = '|cff64df62',
			Role = 'Healer'
		}
	},
	PALADIN = {
		[(L['Spec_Paladin_Holy'])] = { --신성
			Color = '|cfff48cba',
			Role = 'Healer'
		},		
		[(L['Spec_Paladin_Protection'])] = { --보호
			Color = '|cff84e1ff',
			Role = 'Tank'
		},
		[(L['Spec_Paladin_Retribution'])] = { --징벌
			Color = '|cffe60000',
			Role = 'Melee'
		}
	},
	PRIEST = {
		[(L['Spec_Priest_Discipline'])] = { --수양
			Color = '|cffffffff',
			Role = 'Healer'
		},
		[(L['Spec_Priest_Holy'])] = { --신성
			Color = '|cff6bdaff',
			Role = 'Healer'
		},
		[(L['Spec_Priest_Shadow'])] = { --암흑
			Color = '|cff7e52c1',
			Role = 'Caster'
		}
	},
	WARLOCK = {
		[(L['Spec_Warlock_Affliction'])] = { --고통
			Color = '|cff00ff10',
			Role = 'Caster'
		},
		[(L['Spec_Warlock_Demonology'])] = { --악마
			Color = '|cff9482c9',
			Role = 'Caster'
		},
		[(L['Spec_Warlock_Destruction'])] = { --파괴
			Color = '|cffba1706',
			Role = 'Caster'
		}
	}
}


local function CheckRole()
	if Info.Role and InCombatLockdown() then return end
	
	local Check = GetSpecialization()
	
	if Check then
		_, Check = GetSpecializationInfo(Check)
		
		if Check and Info.ClassRole[E.myclass] and Info.ClassRole[E.myclass][Check] then
			Check = Info.ClassRole[E.myclass][Check].Role
		else
			Check = nil
		end
	end
	
	if not Check then
		local _, playerint = UnitStat('player', 4)
		local base, posBuff, negBuff = UnitAttackPower('player')
		
		if (base + posBuff + negBuff > playerint) or (UnitStat('player', 2) > playerint) then
			Check = 'Melee'
		else
			Check = 'Caster'
		end
	end
	
	if Info.Role ~= Check then
		Info.Role = Check
		
		KF:CallbackFire('SpecChanged')
	end
	
	return Check
end
KF:RegisterEventList('PLAYER_ENTERING_WORLD', CheckRole, 'CheckRole')
KF:RegisterEventList('ACTIVE_TALENT_GROUP_CHANGED', CheckRole, 'CheckRole')
KF:RegisterEventList('PLAYER_TALENT_UPDATE', CheckRole, 'CheckRole')
KF:RegisterEventList('CHARACTER_POINTS_CHANGED', CheckRole, 'CheckRole')
KF:RegisterEventList('UNIT_INVENTORY_CHANGED', CheckRole, 'CheckRole')




--------------------------------------------------------------------------------
--<< KnightFrame : Check Current Group Type									>>--
--------------------------------------------------------------------------------
Info.CurrentGroupMode = 'NoGroup' -- Default
function KF:CheckGroupMode()
	local Check
	
	if not (IsInGroup() or IsInRaid()) or GetNumGroupMembers() <= 1 then
		Check = 'NoGroup'
	else
		if IsInRaid() then
			Check = 'raid'
		else
			Check = 'party'
		end
	end
	
	if Info.CurrentGroupMode ~= Check then
		Info.CurrentGroupMode = Check
		
		KF:CallbackFire('GroupChanged')
	end
	
	return Check
end
KF:RegisterEventList('GROUP_ROSTER_UPDATE', KF.CheckGroupMode, 'CheckGroupMode')
KF:RegisterEventList('PLAYER_ENTERING_WORLD', KF.CheckGroupMode, 'CheckGroupMode')




--------------------------------------------------------------------------------
--<< KnightFrame : Current Area												>>--
--------------------------------------------------------------------------------
Info.InstanceType = 'field' -- Default
local function CheckCurrentArea()
	local Check
	local _, instanceType, difficultyID = GetInstanceInfo()
	
	if difficultyID == 8 then
		Check = 'challenge'
	else
		Check = instanceType == 'none' and 'field' or instanceType
	end
	
	if Info.InstanceType ~= Check then
		Info.InstanceType = Check
		
		KF:CallbackFire('CurrentAreaChanged')
	end
	
	return Check
end
KF:RegisterEventList('PLAYER_ENTERING_WORLD', CheckCurrentArea, 'CheckCurrentArea')
KF:RegisterEventList('ZONE_CHANGED_NEW_AREA', CheckCurrentArea, 'CheckCurrentArea')




--------------------------------------------------------------------------------
--<< KnightFrame : Upgrade AnchorMode's Popup and Add KnightFrame Mode		>>--
--------------------------------------------------------------------------------
-- Original Code (Version)		: ElvUI(6.94)
-- Original Code Location		: ElvUI\Core\Config.lua
local selectedValue = 'ALL'

local function ConfigMode_OnClick(self)
	selectedValue = self.value
	E:ToggleConfigMode(false, self.value)
	UIDropDownMenu_SetSelectedValue(ElvUIMoverPopupWindowDropDown, self.value)
end

hooksecurefunc(E, 'CreateMoverPopup', function()
	UIDropDownMenu_Initialize(ElvUIMoverPopupWindowDropDown, function()
		local info = UIDropDownMenu_CreateInfo()
		info.func = ConfigMode_OnClick
		
		for _, configMode in ipairs(E.ConfigModeLayouts) do
			info.text = E.ConfigModeLocalizedStrings[configMode]
			info.value = configMode
			UIDropDownMenu_AddButton(info)
		end
		
		-- Blank
		info.text = ' '
		info.value = nil
		info.disabled = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info)
		
		-- Add KnightFrame Mode
		info.text = KF:Color_Value('       [Knight Frame]')
		info.disabled = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info)
		
		info.text = KF:Color_Value('1. ')..ALL
		info.value = 'KF'
		info.disabled = nil
		info.notCheckable = nil
		UIDropDownMenu_AddButton(info)
		
		local DropdownCount = 2
		for MoverType, Text in pairs(KF.UIParent.MoverType) do
			info.text = KF:Color_Value(DropdownCount..'. ')..Text
			info.value = MoverType
			UIDropDownMenu_AddButton(info)
			
			DropdownCount = DropdownCount + 1
		end
		
		UIDropDownMenu_SetSelectedValue(ElvUIMoverPopupWindowDropDown, selectedValue)
	end)
end)




--------------------------------------------------------------------------------
--<< KnightFrame : Check BossBattle											>>--
--------------------------------------------------------------------------------
local BossIsExists, IsEncounterInProgressOn, EndType

Info.CheckedBossList = {}
Info.BossBattle_Exception = {
	[EJ_GetEncounterInfo(742)] = 'friendly',	-- TSULONG
}

local function ClearCheckedBossList(Force)
	KF:CancelTimer('ClearCheckedBossList')
	
	if not IsEncounterInProgress() or Force == true then
		wipe(Info.CheckedBossList)
		
		if not Force then
			KF:RegisterEventList('ENCOUNTER_START', KF.CheckBossCombat, 'CheckBossCombat')
			KF:RegisterEventList('PLAYER_REGEN_DISABLED', KF.CheckBossCombat, 'CheckBossCombat')
		end
	else
		KF:RegisterTimer('ClearCheckedBossList', 'NewTimer', 2, ClearCheckedBossList)
	end
end
KF:RegisterCallback('GroupChanged', ClearCheckedBossList)
KF:RegisterCallback('CurrentAreaChanged', ClearCheckedBossList)


KF.BossBattleStart = function(StartingType)
	if Info.NowInBossBattle ~= nil or next(Info.CheckedBossList) then return end
	
	if StartingType == 'pull' then
		Info.NowInBossBattle = 'DBM'
		KF:CancelTimer('CheckCombatEnd')
	elseif StartingType == 'BigWigs_OnBossEngage' then
		Info.NowInBossBattle = 'BigWigs'
		KF:CancelTimer('CheckCombatEnd')
	else
		Info.NowInBossBattle = 'KF'
	end
	
	ClearCheckedBossList(true)
	KF:UnregisterEventList('ENCOUNTER_START', 'CheckBossCombat')
	KF:UnregisterEventList('PLAYER_REGEN_DISABLED', 'CheckBossCombat')
	
	local BossName
	for i = 1, 5 do
		BossName = KF:BossExists('boss'..i)
		
		if BossName and not Info.CheckedBossList[BossName] then
			Info.CheckedBossList[BossName] = true
		end
	end
	
	KF:CallbackFire('BossBattleStart')
end


KF.BossBattleEnd = function(EndingType)
	if Info.NowInBossBattle then
		--print('보스전 끝 : ', EndingType)
		--if EndingType == 'wipe' or EndingType == 'BigWigs_OnBossWipe' then
			KF:CancelTimer('ClearCheckedBossList')
			KF:RegisterTimer('ClearCheckedBossList', 'NewTimer', 4, ClearCheckedBossList)
		--end
		
		KF:CancelTimer('CheckCombatEnd')
		
		Info.NowInBossBattle = nil
		BossIsExists = nil
		
		KF:CallbackFire('BossBattleEnd')
	end
end


if (IsAddOnLoaded('DBM-Core') or DBM) and DBM.RegisterCallback then
	DBM:RegisterCallback('pull', KF.BossBattleStart)
	DBM:RegisterCallback('kill', KF.BossBattleEnd)
	DBM:RegisterCallback('wipe', KF.BossBattleEnd)
end
if BigWigsLoader and BigWigsLoader.RegisterMessage then
	BigWigsLoader.RegisterMessage(KF, 'BigWigs_OnBossEngage', KF.BossBattleStart)
	BigWigsLoader.RegisterMessage(KF, 'BigWigs_OnBossWin', KF.BossBattleEnd)
	BigWigsLoader.RegisterMessage(KF, 'BigWigs_OnBossWipe', KF.BossBattleEnd)
end


function KF:CheckCombatEnd()
	if UnitAffectingCombat('player') then
		return false
	elseif UnitIsDeadOrGhost('player') then
		local checkWiped = 'wipe'
		
		if Info.CurrentGroupMode ~= 'NoGroup' then
			for i = 1, Info.CurrentGroupMode == 'party' and 4 or MAX_RAID_MEMBERS do
				if UnitExists(Info.CurrentGroupMode..i) then
					if UnitAffectingCombat(Info.CurrentGroupMode..i) then
						return false
					elseif not UnitIsDeadOrGhost(Info.CurrentGroupMode..i) then
						checkWiped = true -- true means not wipe, just group was out of combat.
					end
				end
			end
		end
		
		return checkWiped
	end
	
	return true
end


function KF:CheckBossCombatEnd()
	if BossIsExists == true and not (KF:BossExists('boss1') or KF:BossExists('boss2') or KF:BossExists('boss3') or KF:BossExists('boss4') or KF:BossExists('boss5')) then
		BossIsExists = false
	elseif BossIsExists == false and (KF:BossExists('boss1') or KF:BossExists('boss2') or KF:BossExists('boss3') or KF:BossExists('boss4') or KF:BossExists('boss5')) then
		BossIsExists = true
	end
	
	EndType = KF:CheckCombatEnd()
	if (IsEncounterInProgressOn and not IsEncounterInProgress() or not IsEncounterInProgressOn and EndType) and (BossIsExists == false or EndType == 'wipe') then
		IsEncounterInProgressOn = nil
		KF.BossBattleEnd(EndType)
	end
end


function KF:BossExists(Unit)
	local BossName = UnitName(Unit)
	
	if BossName and BossName ~= UNKNOWNOBJECT and BossName ~= COMBATLOG_UNKNOWN_UNIT and not UnitIsDead(Unit) and not (Info.BossBattle_Exception[BossName] and (Info.BossBattle_Exception[BossName] == 'friendly' and UnitIsFriend('player', Unit) or UnitIsEnemy('player', Unit))) then
		return BossName
	end
end


function KF:CheckBossCombat()
	if Info.NowInBossBattle == nil then
		if IsEncounterInProgress() then
			IsEncounterInProgressOn = true
		end
		
		for i = 1, 5 do
			if KF:BossExists('boss'..i) then
				BossIsExists = true
				break
			end
		end
		
		if BossIsExists or IsEncounterInProgressOn then
			KF:CancelTimer('CheckCombatEnd')
			KF:RegisterTimer('CheckCombatEnd', 'NewTicker', .1, KF.CheckBossCombatEnd)
			
			KF.BossBattleStart()
			return
		end
	end
	
	KF:CancelTimer('CheckCombatEnd')
end
KF:RegisterTimer('CheckCombatEnd', 'NewTicker', .1, KF.CheckBossCombat)


KF:RegisterEventList('INSTANCE_ENCOUNTER_ENGAGE_UNIT', function()
	local BossName
	
	for i = 1, 5 do
		BossName = KF:BossExists('boss'..i)
		
		if BossName and Info.NowInBossBattle == nil and not Info.CheckedBossList[BossName] then
			Info.CheckedBossList[BossName] = true
			
			KF:RegisterTimer('CheckCombatEnd', 'NewTicker', .1, KF.CheckBossCombat, nil, true)
		end
	end
end)
KF:RegisterCallback('CurrentAreaChanged', function()
	if Info.InstanceType ~= 'field' then
		KF:RegisterEventList('ENCOUNTER_START', KF.CheckBossCombat, 'CheckBossCombat')
		KF:RegisterEventList('PLAYER_REGEN_DISABLED', KF.CheckBossCombat, 'CheckBossCombat')
	end
end)




--------------------------------------------------------------------------------
--<< KnightFrame : Updater													>>--
--------------------------------------------------------------------------------
function KF:UpdateAll(RemoveOrder)
	for i = 1, #KF.Modules do
		KF.Modules[(KF.Modules[i])](RemoveOrder)
	end
end




--------------------------------------------------------------------------------
--<< KnightFrame : Check Developer											>>--
--------------------------------------------------------------------------------
function KF:CheckDeveloper()
	if Info.CurrentGroupMode == 'NoGroup' then
		KF:CancelTimer('CheckDeveloper')
		
		return
	end
	
	local UserName, UserRealm
	
	for i = 1, MAX_RAID_MEMBERS do
		UserName, UserRealm = UnitName(Info.CurrentGroupMode..i)
		
		if UserName then
			UserRealm = UserRealm ~= '' and UserRealm or Info.MyRealm
			
			if Info.Developer[UserName..'-'..UserRealm] then
				if not Info.DeveloperFind then
					Info.DeveloperFind = true
					
					SendAddonMessage('KnightFrame_CA', Info.Name..'/'..Info.Version, UserRealm == Info.MyRealm and 'WHISPER' or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(Info.CurrentGroupMode), UserName..'-'..UserRealm)
					print(L['KF']..' : '..format(L['Creater of this addon, %s is in %s group. Please whisper me about opinion of %s addon.'], '|cff2eb7e4'..UserName..'|r', '|cffceff00'..L[Info.CurrentGroupMode]..'|r', KF:Color_Value(Info.Name)))
				end
				
				KF:CancelTimer('CheckDeveloper')
				return
			end
		end
	end
	
	Info.DeveloperFind = nil
end


KF:RegisterCallback('GroupChanged', function()
	KF:CancelTimer('CheckDeveloper')
	
	if Info.CurrentGroupMode == 'NoGroup' then
		Info.DeveloperFind = nil
	else
		KF:CheckDeveloper()
		KF:RegisterTimer('CheckDeveloper', 'NewTicker', 1, KF.CheckDeveloper)
	end
end, 'CheckDeveloper')