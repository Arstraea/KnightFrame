local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 24
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return
elseif KF.UIParent then
--------------------------------------------------------------------------------
--<< KnightFrame : Hide WatchFrame when player in boss battle				>>--
--------------------------------------------------------------------------------
	local Toggled = false
	local Exception_Boss = {
		--['bossName'] = true <- when you write like this, this function will not active. use this list for kind of quest boss.
	}
	
	KF.Modules[#KF.Modules + 1] = 'ToggleWatchFrame'
	KF.Modules['ToggleWatchFrame'] = function(RemoveOrder)
		if not RemoveAll and KF.db.Modules.ToggleWatchFrame ~= false then
			KF:RegisterCallback('BossBattleStart', function()
				if KF.InstanceType == 'challenge' then return end
				
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
				
				if WatchFrameLines:IsVisible() and WatchFrameCollapseExpandButton:IsShown() and Toggled == false then
					Toggled = true
					WatchFrameCollapseExpandButton:Click()
					print(L['KF']..' : '..L['Hide Watchframe because of entering boss battle.'])
				end
			end, 'ToggleWatchFrame')
			
			KF:RegisterCallback('BossBattleEnd', function()
				if not WatchFrameLines:IsVisible() and WatchFrameCollapseExpandButton:IsShown() and Toggled == true then
					WatchFrameCollapseExpandButton:Click()
					Toggled = false
				end
			end, 'ToggleWatchFrame')
		else
			KF:UnregisterCallback('BossBattleStart', 'ToggleWatchFrame')
			KF:UnregisterCallback('BossBattleEnd', 'ToggleWatchFrame')
		end
	end
end