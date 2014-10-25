local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Hide WatchFrame when player in boss battle				>>--
--------------------------------------------------------------------------------
local Toggled = false
local Exception_Boss = {
	--['bossName'] = true <- when you write like this, this function will not active. use this list for kind of quest boss.
}

KF.Modules[#KF.Modules + 1] = 'ToggleWatchFrame'
KF.Modules['ToggleWatchFrame'] = function(RemoveOrder)
	if not RemoveAll and DB.Modules.ToggleWatchFrame ~= false then
		KF:RegisterCallback('BossBattleStart', function()
			if Info.InstanceType == 'challenge' or Info.InstanceType == 'scenario' then return end
			
			local bossName, bossLevel, playerLevel
			for i = 1, 4 do
				bossName = UnitName('boss'..i)
				if bossName then
					if Exception_Boss[bossName] then return end
					
					bossLevel = UnitLevel('boss'..i)
					playerLevel = UnitLevel('player')
					if not (bossLevel == -1 or UnitClassification('boss'..i) == 'worldboss') and (bossLevel > playerLevel + 6 or bossLevel < playerLevel - 6) then return end
				end
			end
			
			if ObjectiveTrackerFrame and not ObjectiveTrackerFrame.collapsed and Toggled == false and not ObjectiveTrackerFrame.collapsed then
				Toggled = true
				ObjectiveTracker_Collapse()
				print(L['KF']..' : '..L['Hide Objectiveframe because of entering boss battle.'])
			end
		end, 'ToggleWatchFrame')
		
		KF:RegisterCallback('BossBattleEnd', function()
			if ObjectiveTrackerFrame and ObjectiveTrackerFrame.collapsed and Toggled == true then
				ObjectiveTracker_Expand()
				Toggled = false
			end
		end, 'ToggleWatchFrame')
	else
		KF:UnregisterCallback('BossBattleStart', 'ToggleWatchFrame')
		KF:UnregisterCallback('BossBattleEnd', 'ToggleWatchFrame')
	end
end