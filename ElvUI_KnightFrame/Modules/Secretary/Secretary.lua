﻿local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

local SC = KnightFrame_Secretary or CreateFrame('Frame', 'KnightFrame_Secretary', KF.UIParent)


--------------------------------------------------------------------------------
--<< KnightFrame : Secretary - Toggle ObjectiveFrame during boss battle					>>--
--------------------------------------------------------------------------------
Info.Secretary_ToggleObjectiveFrame_Toggled = false
Info.Secretary_ToggleObjectiveFrame_ExceptionList = {
	--['bossName'] = true <- when you write like this, this function will not active. use this list for kind of quest boss.
}


function SC:ToggleObjectiveFrame_BossBattleStart()
	if Info.InstanceType == 'challenge' or Info.InstanceType == 'scenario' then return end
	
	local bossName, bossLevel, playerLevel
	for i = 1, 4 do
		bossName = UnitName('boss'..i)
		if bossName then
			if Info.Secretary_ToggleObjectiveFrame_ExceptionList[bossName] then return end
			
			bossLevel = UnitLevel('boss'..i)
			playerLevel = UnitLevel('player')
			if not (bossLevel == -1 or UnitClassification('boss'..i) == 'worldboss') and (bossLevel > playerLevel + 6 or bossLevel < playerLevel - 6) then return end
		end
	end
	
	if ObjectiveTrackerFrame and not ObjectiveTrackerFrame.collapsed and Info.Secretary_ToggleObjectiveFrame_Toggled == false and not ObjectiveTrackerFrame.collapsed then
		Info.Secretary_ToggleObjectiveFrame_Toggled = true
		ObjectiveTracker_Collapse()
		print(L['KF']..' : '..L['Hide Objectiveframe because of entering boss battle.'])
	end
end


function SC:ToggleObjectiveFrame_BossBattleEnd()
	if ObjectiveTrackerFrame and ObjectiveTrackerFrame.collapsed and Info.Secretary_ToggleObjectiveFrame_Toggled == true then
		ObjectiveTracker_Expand()
		Info.Secretary_ToggleObjectiveFrame_Toggled = false
	end
end



--------------------------------------------------------------------------------
--<< KnightFrame : Secretary - Alarm																			>>--
--------------------------------------------------------------------------------
local Value = {}
local LFDRoleCheckPopupDescriptionDefaultPoint = { LFDRoleCheckPopupDescription:GetPoint() }
SC.Alarm_EventList = {
	LFG_PROPOSAL_SHOW = 'ReadyCheck',
	
	READY_CHECK = function(arg1)
		if arg1 ~= E.myname then
			return 'ReadyCheck'
		end
	end,
	
	LFG_PROPOSAL_SUCCEEDED = false,
	
	LFG_PROPOSAL_FAILED = false,
	
	READY_CHECK_FINISHED = false,
	
	READY_CHECK_CONFIRM = function(arg1)
		if arg1 == 'player' then
			return false
		end
	end,
	
	UPDATE_BATTLEFIELD_STATUS = function(...)
		local BattleField_Status = GetBattlefieldStatus(...)
		
		if BattleField_Status == 'confirm' and not Value.BattleField_Status then
			Value.BattleField_Status = BattleField_Status
			
			return 'PVPTHROUGHQUEUE'
		elseif BattleField_Status == 'none' or BattleField_Status == 'active' then
			Value.BattleField_Status = nil
			
			return false
		end
	end
}


function SC:Alarm_TurnOnAlarm(Sound)
	if Info.Secretary_Alarm_Activate then
		if KF.db.Modules.Secretary.Alarm.AlarmMethod.Blink then
			FlashClientIcon()
		end
		
		if KF.db.Modules.Secretary.Alarm.AlarmMethod.Sound and GetCVar('Sound_EnableAllSound') == '0' then
			KF.db.Modules.Secretary.Alarm.SoundOff = true
			
			SetCVar('Sound_EnableAllSound', '1')
			
			if Sound:find('\\') then
				PlaySoundFile(Sound)
			else
				PlaySound(Sound)
			end
		end
	end
end

function SC:Alarm_TurnOffAlarm()
	if KF.db.Modules.Secretary.Alarm.SoundOff then
		SetCVar('Sound_EnableAllSound', '0')
		KF.db.Modules.Secretary.Alarm.SoundOff = nil
	end
end
SC:Alarm_TurnOffAlarm()


SC.Alarm_ButtonSetting = function(Frame)
	if Info.Secretary_Alarm_Activate and GetCVar('Sound_EnableAllSound') == '0' and Frame and Frame:IsVisible() then
		KF_NoticeProposalButton_1:Show()
		KF_NoticeProposalButton_1:SetParent(Frame)
		KF_NoticeProposalButton_1:ClearAllPoints()
		
		if Frame:GetName() == 'HonorFrame' then
			KF_NoticeProposalButton_1:Point('BOTTOMLEFT', Frame, 'BOTTOMRIGHT', -216, -1)
		elseif Frame:GetName() == 'ConquestFrame' then
			KF_NoticeProposalButton_1:Point('BOTTOMLEFT', Frame, 'BOTTOMRIGHT', -105, 3)
		else
			KF_NoticeProposalButton_1:Point('BOTTOMLEFT', Frame, 'BOTTOMRIGHT', -95, 3)
		end
	else
		KF_NoticeProposalButton_1:Hide()
	end
end


SC.Alarm_PopupSetting = function()
	if Info.Secretary_Alarm_Activate and GetCVar('Sound_EnableAllSound') == '0' then
		KF_NoticeProposalButton_2:Show()
		
		LFDRoleCheckPopup:SetHeight(LFDRoleCheckPopup:GetHeight() + 20)
		
		local Arg1, Arg2, Arg3, Arg4, Arg5 = unpack(LFDRoleCheckPopupDescriptionDefaultPoint)
		LFDRoleCheckPopupDescription:Point(Arg1, Arg2, Arg3, Arg4, Arg5 + 20)
	elseif KF_NoticeProposalButton_2 then
		KF_NoticeProposalButton_2:Hide()
		
		LFDRoleCheckPopup:SetHeight(180)
		LFDRoleCheckPopupDescription:Point(unpack(LFDRoleCheckPopupDescriptionDefaultPoint))
	end
end


function SC:Alarm_Initialize()
	--<< Create Check Button >>--
	for i = 1, 2 do
		KF:CreateWidget_CheckButton('KF_NoticeProposalButton_'..i, L['Alarm'])
		
		_G['KF_NoticeProposalButton_'..i]:SetScript('OnClick', function(self)
			if KF.db.Modules.Secretary.Alarm.Event.ContentsQueue == true then
				KF.db.Modules.Secretary.Alarm.Event.ContentsQueue = false
				self.CheckButton:Hide()
			else
				KF.db.Modules.Secretary.Alarm.Event.ContentsQueue = true
				self.CheckButton:Show()
			end
		end)
		_G['KF_NoticeProposalButton_'..i]:SetScript('OnShow', function(self)
			if KF.db.Modules.Secretary.Alarm.Event.ContentsQueue == true then
				self.CheckButton:Show()
			else
				self.CheckButton:Hide()
			end
		end)
	end
	
	KF_NoticeProposalButton_2:SetParent(LFDRoleCheckPopup)	
	KF_NoticeProposalButton_2:Point('CENTER', LFDRoleCheckPopup, 'BOTTOM', 0, 53)
	
	SC:SetScript('OnEvent', function(self, EventName, ...)
		local GetEvent = SC.Alarm_EventList[EventName]
		
		if GetEvent ~= nil then
			local Judgement = type(GetEvent)
			
			if Judgement == 'function' then
				Judgement = GetEvent(...)
			else
				Judgement = GetEvent
			end
			
			if Judgement then
				self:Alarm_TurnOnAlarm(Judgement)
			elseif Judgement == false then
				self:Alarm_TurnOffAlarm()
			end
		end
	end)
	
	LFDQueueFrame:HookScript('OnShow', SC.Alarm_ButtonSetting)
	RaidFinderFrame:HookScript('OnShow', SC.Alarm_ButtonSetting)
	ScenarioQueueFrame:HookScript('OnShow', SC.Alarm_ButtonSetting)
	
	SC.Alarm_Initialize = nil
end


KF:RegisterEventList('ADDON_LOADED', function(_, AddOnName)
	if AddOnName == 'Blizzard_PVPUI' then
		HonorFrame:HookScript('OnShow', SC.Alarm_ButtonSetting)
		ConquestFrame:HookScript('OnShow', SC.Alarm_ButtonSetting)
		
		KF:UnregisterEventList('ADDON_LOADED', 'Alarm_Initialize')
	end
end, 'Alarm_Initialize')


KF.Modules[#KF.Modules + 1] = 'Secretary'
KF.Modules.Secretary = function(RemoveOrder)
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.Secretary.Enable ~= false and KF.db.Modules.Secretary.Alarm.Enable then
		Info.Secretary_Alarm_Activate = true
		
		if SC.Alarm_Initialize then
			SC:Alarm_Initialize()
		end
		
		if KF.db.Modules.Secretary.Alarm.Event.ContentsQueue then
			SC:RegisterEvent('LFG_PROPOSAL_SHOW')
			SC:RegisterEvent('LFG_PROPOSAL_SUCCEEDED')
			SC:RegisterEvent('LFG_PROPOSAL_FAILED')
			SC:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
			KF:RegisterEventList('LFG_ROLE_CHECK_SHOW', SC.Alarm_PopupSetting, 'Alarm_Initialize')
		end
		
		if KF.db.Modules.Secretary.Alarm.Event.ReadyCheck then
			SC:RegisterEvent('READY_CHECK')
			SC:RegisterEvent('READY_CHECK_CONFIRM')
			SC:RegisterEvent('READY_CHECK_FINISHED')
		end
	else
		Info.Secretary_Alarm_Activate = nil
		
		SC:UnregisterAllEvents()
		KF:UnregisterEventList('LFG_ROLE_CHECK_SHOW', 'Alarm_Initialize')
	end
	
	for _, FrameName in pairs({ 'LFDQueueFrame', 'RaidFinderFrame', 'ScenarioQueueFrame', 'HonorFrame', 'ConquestFrame' }) do
		SC.Alarm_ButtonSetting(_G[FrameName])
	end
	
	
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.Secretary.Enable ~= false and KF.db.Modules.Secretary.ToggleObjectiveFrame.Enable then
		KF:RegisterCallback('BossBattleStart', SC.ToggleObjectiveFrame_BossBattleStart, 'ToggleObjectiveFrame')
		KF:RegisterCallback('BossBattleEnd', SC.ToggleObjectiveFrame_BossBattleEnd, 'ToggleObjectiveFrame')
	else
		KF:UnregisterCallback('BossBattleStart', 'ToggleObjectiveFrame')
		KF:UnregisterCallback('BossBattleEnd', 'ToggleObjectiveFrame')
	end
end