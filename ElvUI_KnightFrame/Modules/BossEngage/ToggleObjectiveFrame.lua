local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Hide WatchFrame when player in boss battle				>>--
--------------------------------------------------------------------------------
Info.BossEngage_ToggleObjectiveFrame_Toggled = false
Info.BossEngage_ToggleObjectiveFrame_ExceptionList = {
	--['bossName'] = true <- when you write like this, this function will not active. use this list for kind of quest boss.
}


function KF:BossEngage_ToggleObjectiveFrame_BossBattleStart()
	if Info.InstanceType == 'challenge' or Info.InstanceType == 'scenario' then return end
	
	local bossName, bossLevel, playerLevel
	for i = 1, 4 do
		bossName = UnitName('boss'..i)
		if bossName then
			if Info.BossEngage_ToggleObjectiveFrame_ExceptionList[bossName] then return end
			
			bossLevel = UnitLevel('boss'..i)
			playerLevel = UnitLevel('player')
			if not (bossLevel == -1 or UnitClassification('boss'..i) == 'worldboss') and (bossLevel > playerLevel + 6 or bossLevel < playerLevel - 6) then return end
		end
	end
	
	if ObjectiveTrackerFrame and not ObjectiveTrackerFrame.collapsed and Info.BossEngage_ToggleObjectiveFrame_Toggled == false and not ObjectiveTrackerFrame.collapsed then
		Info.BossEngage_ToggleObjectiveFrame_Toggled = true
		ObjectiveTracker_Collapse()
		print(L['KF']..' : '..L['Hide Objectiveframe because of entering boss battle.'])
	end
end


function KF:BossEngage_ToggleObjectiveFrame_BossBattleEnd()
	if ObjectiveTrackerFrame and ObjectiveTrackerFrame.collapsed and Info.BossEngage_ToggleObjectiveFrame_Toggled == true then
		ObjectiveTracker_Expand()
		Info.BossEngage_ToggleObjectiveFrame_Toggled = false
	end
end


KF.Modules[#KF.Modules + 1] = 'ToggleObjectiveFrame'
KF.Modules.ToggleObjectiveFrame = function(RemoveOrder)
	if not RemoveAll and KF.db.Modules.ToggleObjectiveFrame ~= false then
		KF:RegisterCallback('BossBattleStart', KF.BossEngage_ToggleObjectiveFrame_BossBattleStart, 'ToggleObjectiveFrame')
		KF:RegisterCallback('BossBattleEnd', KF.BossEngage_ToggleObjectiveFrame_BossBattleEnd, 'ToggleObjectiveFrame')
	else
		KF:UnregisterCallback('BossBattleStart', 'ToggleObjectiveFrame')
		KF:UnregisterCallback('BossBattleEnd', 'ToggleObjectiveFrame')
	end
end