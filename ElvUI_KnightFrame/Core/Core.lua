local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 4. 13
-- Last Code Checking Version	: 3.0_02
-- Last Testing ElvUI Version	: 6.999

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Toggle KnightFrame During Pet Battle						>>--
	--------------------------------------------------------------------------------
	local function ToggleKnightFrameDuringWowkemon()
		if KnightFrameUIParent then
			if C_PetBattles.IsInBattle() then
				KnightFrameUIParent:Hide()
			else
				KnightFrameUIParent:Show()
			end
		end
	end
	KF:RegisterEventList('PET_BATTLE_CLOSE', ToggleKnightFrameDuringWowkemon, 'ToggleKnightFrameDuringWowkemon')
	KF:RegisterEventList('PET_BATTLE_OPENING_START', ToggleKnightFrameDuringWowkemon, 'ToggleKnightFrameDuringWowkemon')
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Check Player Role										>>--
	--------------------------------------------------------------------------------
	KF.Role = 'Melee' -- Default
	local function CheckRole()
		if KF.Role and InCombatLockdown() then return end
		
		local Check = GetSpecialization()
		
		if Check then
			_, Check = GetSpecializationInfo(Check)
			
			if Check and KF.Table.ClassRole[E.myclass] and KF.Table.ClassRole[E.myclass][Check] then
				Check = KF.Table.ClassRole[E.myclass][Check].Role
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
		
		if KF.Role ~= Check then
			KF.Role = Check
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
	KF.CurrentGroupMode = 'NoGroup' -- Default
	local function CheckGroupMode()
		local Check
		
		if not (IsInGroup() or IsInRaid()) or GetNumGroupMembers() == 1 then
			Check = 'NoGroup'
		else
			if IsInRaid() then
				Check = 'raid'
			else
				Check = 'party'
			end
		end
		
		if KF.CurrentGroupMode ~= Check then
			KF.CurrentGroupMode = Check
			
			KF:CallbackFire('GroupChanged')
		end
		
		return Check
	end
	KF:RegisterEventList('GROUP_ROSTER_UPDATE', CheckGroupMode, 'CheckGroupMode')
	KF:RegisterEventList('PLAYER_ENTERING_WORLD', CheckGroupMode, 'CheckGroupMode')
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Current Area												>>--
	--------------------------------------------------------------------------------
	KF.InstanceType = 'field' -- Default
	local function CheckCurrentArea()
		local Check
		local _, instanceType, difficultyID = GetInstanceInfo()
		
		if difficultyID == 8 then
			Check = 'challenge'
		else
			Check = instanceType == 'none' and 'field' or instanceType
		end
		
		if KF.InstanceType ~= Check then
			KF.InstanceType = Check
			
			KF:CallbackFire('CurrentAreaChanged')
		end
		
		return Check
	end
	KF:RegisterEventList('PLAYER_ENTERING_WORLD', CheckCurrentArea, 'CheckCurrentArea')
	KF:RegisterEventList('ZONE_CHANGED_NEW_AREA', CheckCurrentArea, 'CheckCurrentArea')
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Check BossBattle											>>--
	--------------------------------------------------------------------------------
	local NowInBossBattle, BossIsExists, IsEncounterInProgressOn, EndType
	local KilledBossList = {}
	
	local function ClearKilledBossList()
		KilledBossList = {}
	end
	KF:RegisterCallback('GroupChanged', ClearKilledBossList)
	KF:RegisterCallback('CurrentAreaChanged', ClearKilledBossList)
	
	KF.Table['BossBattle_Exception'] = {
		[EJ_GetEncounterInfo(742)] = 'friendly',	-- TSULONG
	}
	
	KF.BossBattleStart = function(StartingType)
		if NowInBossBattle ~= nil then return end
		
		if StartingType == 'pull' then
			NowInBossBattle = 'DBM'
			KF.Update.CheckCombatEnd = nil
		elseif StartingType == 'BigWigs_OnBossEngage' then
			NowInBossBattle = 'BigWigs'
			KF.Update.CheckCombatEnd = nil
		else
			NowInBossBattle = 'KF'
		end
		
		ClearKilledBossList()
		KF:CallbackFire('BossBattleStart')
	end
	
	KF.BossBattleEnd = function(EndingType)
		if EndingType == 'wipe' or EndingType == 'BigWigs_OnBossWipe' then
			ClearKilledBossList()
		end
		
		KF.Update.CheckCombatEnd = nil
		
		NowInBossBattle = nil
		BossIsExists = nil
		
		KF:CallbackFire('BossBattleEnd')
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
			
			if KF.CurrentGroupMode ~= 'NoGroup' then
				for i = 1, KF.CurrentGroupMode == 'party' and 4 or MAX_RAID_MEMBERS do
					if UnitExists(KF.CurrentGroupMode..i) then
						if UnitAffectingCombat(KF.CurrentGroupMode..i) then
							return false
						elseif not UnitIsDeadOrGhost(KF.CurrentGroupMode..i) then
							checkWiped = true -- true means not wipe, just group was out of combat.
						end
					end
				end
			end
			
			return checkWiped
		end
		
		return true
	end
	
	function KF:BossExists(Unit)
		local bossName = UnitName(Unit)
		
		if bossName and bossName ~= UNKNOWNOBJECT and bossName ~= COMBATLOG_UNKNOWN_UNIT and not UnitIsDead(Unit) and not (KF.Table.BossBattle_Exception[bossName] and (KF.Table.BossBattle_Exception[bossName] == 'friendly' and UnitIsFriend('player', Unit) or UnitIsEnemy('player', Unit))) then
			return bossName
		end
	end
	
	function KF:CheckBossCombat()
		if NowInBossBattle == nil then
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
				KF.Update.CheckCombatEnd = {
					['Condition'] = true,
					['Delay'] = 0,
					['Action'] = function()
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
					end,
				}
				
				KF:BossBattleStart()
				return
			end
		end
		KF.Update.CheckCombatEnd = nil
	end
	
	KF.Update.CheckCombatEnd = {
		['Condition'] = true,
		['Delay'] = 0,
		['Action'] = KF.CheckBossCombat,
	}
	KF:RegisterEventList('INSTANCE_ENCOUNTER_ENGAGE_UNIT', function()
		local bossName
		
		for i = 1, 5 do
			bossName = KF:BossExists('boss'..i)
			
			if bossName then
				if NowInBossBattle == nil and not KilledBossList[bossName] then
					KF.Update.CheckCombatEnd = {
						['Condition'] = true,
						['Delay'] = 0,
						['LastUpdate'] = KF.TimeNow,
						['Action'] = KF.CheckBossCombat,
					}
					KF:CheckBossCombat()
				end
				
				KilledBossList[bossName] = true
			end
		end
	end)
	
	
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Update													>>--
	--------------------------------------------------------------------------------
	function KF:UpdateAll(RemoveOrder)
		for i = 1, #KF.Modules do
			KF.Modules[(KF.Modules[i])](RemoveOrder)
		end
	end
	
	
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Update													>>--
	--------------------------------------------------------------------------------
	KF.Update.CheckArstraea = {
		['Condition'] = true,
		['Action'] = function()
			if KF.CurrentGroupMode == 'NoGroup' then
				KF.Update.CheckArstraea.Condition = false
				
				return
			end
			
			local userName, userRealm
			for i = 1, MAX_RAID_MEMBERS do
				userName, userRealm = UnitName(KF.CurrentGroupMode..i)
				
				if userName then
					userRealm = userRealm ~= '' and userRealm or E.myrealm
					
					if KF.Arstraea[userName..'-'..userRealm] then
						if not KF.ArstraeaFind then
							KF.ArstraeaFind = true
							SendAddonMessage('KnightFrame_CA', KF.AddOnName..'/'..KF.Version, userRealm == E.myrealm and 'WHISPER' or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or string.upper(KF.CurrentGroupMode), userName..'-'..userRealm)
							
							print(L['KF']..' : 본 애드온 제작자인 제가 |cff2eb7e4'..userName..'|r 아이디로 |cffceff00'..L[KF.CurrentGroupMode]..'|r 안에 있습니다! 귓속말로 '..L['KF']..' 에 대하여 의견을 이야기해주세요.')
						end
						
						KF.Update.CheckArstraea.Condition = false
						return
					end
				end
			end
			
			KF.ArstraeaFind = nil
		end,
	}
	KF:RegisterCallback('GroupChanged', function()
		if KF.Update.CheckArstraea then
			if KF.CurrentGroupMode == 'NoGroup' then
				KF.Update.CheckArstraea.Condition = false
				KF.ArstraeaFind = nil
			else
				KF.Update.CheckArstraea.Condition = true
			end
		else
			KF:UnregisterCallback('GroupChanged', 'CheckArstraea')
		end
	end, 'CheckArstraea')
end