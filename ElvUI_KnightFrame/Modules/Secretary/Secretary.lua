--Cache global variables
--Lua functions
local _G = _G
local unpack, select, find, pairs = unpack, select, find, pairs

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local CreateFrame = CreateFrame
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitClassification = UnitClassification
local ObjectiveTracker_Collapse = ObjectiveTracker_Collapse
local ObjectiveTracker_Expand = ObjectiveTracker_Expand
local GetBattlefieldStatus = GetBattlefieldStatus
local FlashClientIcon = FlashClientIcon
local GetCVar = GetCVar
local SetCVar = SetCVar
local PlaySoundFile = PlaySoundFile
local PlaySound = PlaySound

local SC = KnightFrame_Secretary or CreateFrame('Frame', 'KnightFrame_Secretary', KF.UIParent)


--------------------------------------------------------------------------------
--<< KnightFrame : Secretary - Toggle ObjectiveFrame during boss battle					>>--
--------------------------------------------------------------------------------
Info.Secretary_ToggleObjectiveFrame_Toggled = false
Info.Secretary_ToggleObjectiveFrame_ExceptionList = {
	--['BossName'] = true <- when you write like this, this function will not active. use this list for kind of quest boss.
}


local BossName, BossLevel, PlayerLevel
function SC:ToggleObjectiveFrame_BossBattleStart()
	if Info.InstanceType == 'challenge' or Info.InstanceType == 'scenario' then return end
	
	for i = 1, 4 do
		BossName = UnitName('boss'..i)
		if BossName then
			if Info.Secretary_ToggleObjectiveFrame_ExceptionList[BossName] then return end
			
			BossLevel = UnitLevel('boss'..i)
			PlayerLevel = UnitLevel('player')
			if not (BossLevel == -1 or UnitClassification('boss'..i) == 'worldboss') and (BossLevel > PlayerLevel + 6 or BossLevel < PlayerLevel - 6) then return end
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
	CONFIRM_SUMMON = 'Interface\\AddOns\\ElvUI\\media\\sounds\\whisper.ogg',
	CANCEL_SUMMON = false,
	
	LFG_PROPOSAL_SHOW = 'ReadyCheck',
	LFG_PROPOSAL_SUCCEEDED = false,
	LFG_PROPOSAL_FAILED = false,
	GROUP_JOINED = false,
	
	READY_CHECK = function(arg1)
		if arg1 ~= E.myname then
			return 'ReadyCheck'
		end
	end,
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
		KnightFrame_Secretary_AlarmButton1:Show()
		KnightFrame_Secretary_AlarmButton1:SetParent(Frame)
		KnightFrame_Secretary_AlarmButton1:ClearAllPoints()
		
		if Frame:GetName() == 'HonorFrame' then
			KnightFrame_Secretary_AlarmButton1:Point('BOTTOMLEFT', Frame, 'BOTTOMRIGHT', -216, -1)
		elseif Frame:GetName() == 'ConquestFrame' then
			KnightFrame_Secretary_AlarmButton1:Point('BOTTOMLEFT', Frame, 'BOTTOMRIGHT', -105, 3)
		else
			KnightFrame_Secretary_AlarmButton1:Point('BOTTOMLEFT', Frame, 'BOTTOMRIGHT', -95, 3)
		end
	else
		KnightFrame_Secretary_AlarmButton1:Hide()
	end
end


local Arg1, Arg2, Arg3, Arg4, Arg5
SC.Alarm_PopupSetting = function()
	if Info.Secretary_Alarm_Activate and GetCVar('Sound_EnableAllSound') == '0' then
		KnightFrame_Secretary_AlarmButton2:Show()
		
		LFDRoleCheckPopup:SetHeight(LFDRoleCheckPopup:GetHeight() + 20)
		
		Arg1, Arg2, Arg3, Arg4, Arg5 = unpack(LFDRoleCheckPopupDescriptionDefaultPoint)
		LFDRoleCheckPopupDescription:Point(Arg1, Arg2, Arg3, Arg4, Arg5 + 20)
	elseif KnightFrame_Secretary_AlarmButton2 then
		KnightFrame_Secretary_AlarmButton2:Hide()
		
		LFDRoleCheckPopup:SetHeight(180)
		LFDRoleCheckPopupDescription:Point(unpack(LFDRoleCheckPopupDescriptionDefaultPoint))
	end
end


function SC:Alarm_Initialize()
	--<< Create Check Button >>--
	for i = 1, 2 do
		KF:CreateWidget_CheckButton('KnightFrame_Secretary_AlarmButton'..i, L['Alarm'])
		
		_G['KnightFrame_Secretary_AlarmButton'..i]:SetScript('OnClick', function(self)
			if KF.db.Modules.Secretary.Alarm.Event.ContentsQueue == true then
				KF.db.Modules.Secretary.Alarm.Event.ContentsQueue = false
				self.CheckButton:Hide()
			else
				KF.db.Modules.Secretary.Alarm.Event.ContentsQueue = true
				self.CheckButton:Show()
			end
		end)
		_G['KnightFrame_Secretary_AlarmButton'..i]:SetScript('OnShow', function(self)
			if KF.db.Modules.Secretary.Alarm.Event.ContentsQueue == true then
				self.CheckButton:Show()
			else
				self.CheckButton:Hide()
			end
		end)
	end
	
	KnightFrame_Secretary_AlarmButton2:SetParent(LFDRoleCheckPopup)	
	KnightFrame_Secretary_AlarmButton2:Point('CENTER', LFDRoleCheckPopup, 'BOTTOM', 0, 53)
	
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
	
	hooksecurefunc('ConfirmSummon', SC.Alarm_TurnOffAlarm)
	hooksecurefunc('CancelSummon', SC.Alarm_TurnOffAlarm)
	
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
			SC:RegisterEvent('GROUP_JOINED')
			SC:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
			KF:RegisterEventList('LFG_ROLE_CHECK_SHOW', SC.Alarm_PopupSetting, 'Alarm_Initialize')
		end
		
		if KF.db.Modules.Secretary.Alarm.Event.ReadyCheck then
			SC:RegisterEvent('READY_CHECK')
			SC:RegisterEvent('READY_CHECK_CONFIRM')
			SC:RegisterEvent('READY_CHECK_FINISHED')
		end
		
		if KF.db.Modules.Secretary.Alarm.Event.Summon then
			SC:RegisterEvent('CONFIRM_SUMMON')
			SC:RegisterEvent('CANCEL_SUMMON')
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