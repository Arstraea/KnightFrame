local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 25
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

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
			
			if KF.Update.CheckArstraea then
				KF.Update.CheckArstraea.Condition = false
				KF.ArstraeaFind = nil
			end
		else
			if IsInRaid() then
				Check = 'raid'
			else
				Check = 'party'
			end
			
			if KF.Update.CheckArstraea then
				KF.Update.CheckArstraea.Condition = true
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
	KF.NowInBossBattle = nil
	KF.Table['BossBattle_Exception'] = {
		[EJ_GetEncounterInfo(742)] = 'friendly',	-- TSULONG
	}
	
	KF.BossBattleStart = function(StartingType)
		if KF.NowInBossBattle ~= nil then return end
		
		if StartingType == 'pull' then
			KF.NowInBossBattle = 'DBM'
			KF.Update.CheckCombatEnd = nil
		elseif StartingType == 'BigWigs_OnBossEngage' then
			KF.NowInBossBattle = 'BigWigs'
			KF.Update.CheckCombatEnd = nil
		else
			KF.NowInBossBattle = 'KF'
		end
		
		KF:CallbackFire('BossBattleStart')
	end
	
	function KF:BossBattleEnd()
		KF.Update.CheckCombatEnd = nil
		
		KF.NowInBossBattle = nil
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
		elseif UnitIsDeadOrGhost('player') and KF.CurrentGroupMode ~= 'NoGroup' and KF.BossBattleStart == true then
			for i = 1, KF.CurrentGroupMode == 'party' and 4 or MAX_RAID_MEMBERS do
				if UnitExists(KF.CurrentGroupMode..i) and UnitAffectingCombat(KF.CurrentGroupMode..i) then return false end
			end
		end
		
		return true
	end
	
	local BossIsExists, IsEncounterInProgressOn = false, nil
	function KF:CheckBossCombat()
		if KF.NowInBossBattle == nil then
			local bossName
			
			for i = 1, 4 do
				if UnitExists('boss'..i) then
					bossName = UnitName('boss'..i)
					
					if not (KF.Table.BossBattle_Exception[bossName] and (KF.Table.BossBattle_Exception[bossName] == 'friendly' and UnitIsFriend('player', 'boss'..i) or UnitIsEnemy('player', 'boss'..i))) then
						if IsEncounterInProgress() then
							IsEncounterInProgressOn = true
						end
						
						BossIsExists = true
						
						KF.Update.CheckCombatEnd = {
							['Condition'] = true,
							['Delay'] = 0.5,
							['Action'] = function()
								if BossIsExists == true and not (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
									BossIsExists = false
								elseif BossIsExists == false and (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
									BossIsExists = true
								end
								
								if (IsEncounterInProgressOn and not IsEncounterInProgress() or not IsEncounterInProgressOn and KF:CheckCombatEnd() == true) and BossIsExists == false then
									IsEncounterInProgressOn = nil
									KF:BossBattleEnd()
								end
							end,
						}
						
						KF:BossBattleStart()
						return
					end
				end
			end
		end
		KF.Update.CheckCombatEnd = nil
	end
	
	KF.Update.CheckCombatEnd = {
		['Condition'] = true,
		['Delay'] = 0.5,
		['Action'] = KF.CheckBossCombat,
	}
	KF:RegisterEventList('INSTANCE_ENCOUNTER_ENGAGE_UNIT', function()
		if KF.NowInBossBattle ~= nil then return end
		
		KF.Update.CheckCombatEnd = {
			['Condition'] = true,
			['Delay'] = 0.5,
			['LastUpdate'] = KF.TimeNow,
			['Action'] = KF.CheckBossCombat,
		}
		KF:CheckBossCombat()
	end)
	
	
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Update													>>--
	--------------------------------------------------------------------------------
	function KF:UpdateAll(RemoveOrder)
		for i = 1, #KF.Modules do
			KF.Modules[(KF.Modules[i])](RemoveOrder)
		end
	end
end