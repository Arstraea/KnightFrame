local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Secretary - Notice proposal								>>--
--------------------------------------------------------------------------------
local Value = {}
local LFDRoleCheckPopupDescriptionDefaultPoint = { LFDRoleCheckPopupDescription:GetPoint() }

local function NoticeProposal_TurnOnSound(Sound)
	if GetCVar('Sound_EnableAllSound') == '0' then
		KF.db.Modules.Secretary.SoundOff = true
		SetCVar('Sound_EnableAllSound', '1')
		
		if Sound:find('\\') then
			PlaySoundFile(Sound)
		else
			PlaySound(Sound)
		end
	end
end


local function NoticeProposal_TurnOffSound()
	if KF.db.Modules.Secretary.SoundOff then
		SetCVar('Sound_EnableAllSound', '0')
		KF.db.Modules.Secretary.SoundOff = nil
	end
end
NoticeProposal_TurnOffSound()


local function NoticeProposal(EventName, ...)
	if KF.db.Modules.Secretary.NoticeProposal then
		local arg1, arg2, arg3 = ...
		
		if EventName == 'LFG_PROPOSAL_SHOW'  or (EventName == 'READY_CHECK' and arg1 ~= E.myname) then
			NoticeProposal_TurnOnSound('ReadyCheck')
		elseif EventName == 'LFG_PROPOSAL_SUCCEEDED' or EventName == 'LFG_PROPOSAL_FAILED' or EventName == 'READY_CHECK_FINISHED' or (EventName == 'READY_CHECK_CONFIRM' and arg1 == 'player') then
			NoticeProposal_TurnOffSound()
		elseif EventName == 'UPDATE_BATTLEFIELD_STATUS' then
			local BattleField_Status = GetBattlefieldStatus(...)
			
			if BattleField_Status == 'confirm' and not Value.BattleField_Status then
				Value.BattleField_Stauts = BattleField_Status
				NoticeProposal_TurnOnSound('PVPTHROUGHQUEUE')
			elseif BattleField_Status == 'none' or BattleField_Status == 'active' then
				Value.BattleField_Status = nil
				NoticeProposal_TurnOffSound()
			end
		end			
	end
end
KF:RegisterEventList('LFG_PROPOSAL_SHOW', NoticeProposal, 'Secretary_NoticeProposal')
KF:RegisterEventList('LFG_PROPOSAL_SUCCEEDED', NoticeProposal, 'Secretary_NoticeProposal')
KF:RegisterEventList('LFG_PROPOSAL_FAILED', NoticeProposal, 'Secretary_NoticeProposal')
KF:RegisterEventList('UPDATE_BATTLEFIELD_STATUS', NoticeProposal, 'Secretary_NoticeProposal')
KF:RegisterEventList('READY_CHECK', NoticeProposal, 'Secretary_NoticeProposal')
KF:RegisterEventList('READY_CHECK_CONFIRM', NoticeProposal, 'Secretary_NoticeProposal')
KF:RegisterEventList('READY_CHECK_FINISHED', NoticeProposal, 'Secretary_NoticeProposal')


--<< Create Check Button >>--
for i = 1, 2 do
	KF:CreateWidget_CheckButton('KF_NoticeProposalButton_'..i, L['Notice'])
	if KF.db.Modules.Secretary.NoticeProposal == false then
		_G['KF_NoticeProposalButton_'..i].CheckButton:Hide()
	end
	
	_G['KF_NoticeProposalButton_'..i]:SetScript('OnClick', function(self)
		if KF.db.Modules.Secretary.NoticeProposal == true then
			KF.db.Modules.Secretary.NoticeProposal = false
			self.CheckButton:Hide()
		else
			KF.db.Modules.Secretary.NoticeProposal = true
			self.CheckButton:Show()
		end
	end)
	_G['KF_NoticeProposalButton_'..i]:SetScript('OnShow', function(self)
		if KF.db.Modules.Secretary.NoticeProposal == true then
			self.CheckButton:Show()
		else
			self.CheckButton:Hide()
		end
	end)
end
KF_NoticeProposalButton_2:SetParent(LFDRoleCheckPopup)	
KF_NoticeProposalButton_2:Point('CENTER', LFDRoleCheckPopup, 'BOTTOM', 0, 53)
--KF_NoticeProposalButton_2:SetScript('OnUpdate', function(self)

--end)


local function NoticeProposal_ButtonSetting(frame)
	if GetCVar('Sound_EnableAllSound') == '0' then
		KF_NoticeProposalButton_1:Show()
		KF_NoticeProposalButton_1:SetParent(frame)
		KF_NoticeProposalButton_1:ClearAllPoints()
		
		if frame:GetName() == 'HonorFrame' then
			KF_NoticeProposalButton_1:Point('BOTTOMLEFT', frame, 'BOTTOMRIGHT', -216, -1)
		elseif frame:GetName() == 'ConquestFrame' then
			KF_NoticeProposalButton_1:Point('BOTTOMLEFT', frame, 'BOTTOMRIGHT', -105, 3)
		else
			KF_NoticeProposalButton_1:Point('BOTTOMLEFT', frame, 'BOTTOMRIGHT', -95, 3)
		end
	else
		KF_NoticeProposalButton_1:Hide()
	end
end
LFDQueueFrame:HookScript('OnShow', NoticeProposal_ButtonSetting)
RaidFinderFrame:HookScript('OnShow', NoticeProposal_ButtonSetting)
ScenarioQueueFrame:HookScript('OnShow', NoticeProposal_ButtonSetting)


KF:RegisterEventList('ADDON_LOADED', function(_, AddOnName)
	if AddOnName == 'Blizzard_PVPUI' then
		HonorFrame:HookScript('OnShow', NoticeProposal_ButtonSetting)
		ConquestFrame:HookScript('OnShow', NoticeProposal_ButtonSetting)
		
		KF:UnregisterEventList('ADDON_LOADED', 'Secretary_NoticeProposal')
	end
end, 'Secretary_NoticeProposal')


KF:RegisterEventList('LFG_ROLE_CHECK_SHOW', function()
	if GetCVar('Sound_EnableAllSound') == '0' then
		KF_NoticeProposalButton_2:Show()
		
		LFDRoleCheckPopup:SetHeight(LFDRoleCheckPopup:GetHeight() + 20)
		
		local Arg1, Arg2, Arg3, Arg4, Arg5 = unpack(LFDRoleCheckPopupDescriptionDefaultPoint)
		LFDRoleCheckPopupDescription:Point(Arg1, Arg2, Arg3, Arg4, Arg5 + 20)
	else
		KF_NoticeProposalButton_2:Hide()
		
		LFDRoleCheckPopup:SetHeight(180)
		LFDRoleCheckPopupDescription:Point(unpack(LFDRoleCheckPopupDescriptionDefaultPoint))
	end
end, 'Secretary_NoticeProposal')