local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Update = unpack(ElvUI_KnightFrame)

--[[
if not KF then return
elseif KF.UIParent then
	local Value = {}
	--------------------------------------------------------------------------------
	--<< KnightFrame : Secretary - Notice proposal								>>--
	--------------------------------------------------------------------------------
	local SoundOff
	local function NoticeProposal_TurnOnSound(Sound)
		if GetCVar('Sound_EnableAllSound') == '0' then
			SoundOff = true
			SetCVar('Sound_EnableAllSound', '1')
			
			if Sound:find('\\') then
				PlaySoundFile(Sound)
			else
				PlaySound(Sound)
			end
		end
	end
	
	
	local function NoticeProposal_TurnOffSound()
		if SoundOff then
			SetCVar('Sound_EnableAllSound', '0')
			SoundOff = nil
		end
	end
	
	
	local function NoticeProposal(EventName, ...)
		if KF.db.Extra_Functions.Secretary.NoticeProposal then
			if EventName == 'LFG_PROPOSAL_SHOW' then
				NoticeProposal_TurnOnSound('ReadyCheck')
			elseif EventName == 'LFG_PROPOSAL_SUCCEEDED' or EventName == 'LFG_PROPOSAL_FAILED' then
				NoticeProposal_TurnOffSound()
			elseif EventName == 'UPDATE_BATTLEFIELD_STATUS' then
				local BattleField_Status = GetBattlefieldStatus(...)
				
				if BattleField_Status == 'confirm' and not Value['BattleField_Status'] then
					Value['BattleField_Stauts'] = BattleField_Status
					NoticeProposal_TurnOnSound('PVPTHROUGHQUEUE')	
				elseif BattleField_Status == 'none' or BattleField_Status == 'active' then
					Value['BattleField_Status'] = nil
					NoticeProposal_TurnOffSound()
				end
			end			
		end
	end
	KF:RegisterEventList('LFG_PROPOSAL_SHOW', NoticeProposal, 'Secretary_NoticeProposal')
	KF:RegisterEventList('LFG_PROPOSAL_SUCCEEDED', NoticeProposal, 'Secretary_NoticeProposal')
	KF:RegisterEventList('LFG_PROPOSAL_FAILED', NoticeProposal, 'Secretary_NoticeProposal')
	KF:RegisterEventList('UPDATE_BATTLEFIELD_STATUS', NoticeProposal, 'Secretary_NoticeProposal')
	
	
	--<< Create Check Button >>--
	for i = 1, 2 do
		KF:CreateWidget_CheckButton('KF_NoticeProposalButton_'..i, L['Notice'])
		if KF.db.Extra_Functions.Secretary.NoticeProposal == false then
			_G['KF_NoticeProposalButton_'..i].CheckButton:Hide()
		end
		
		_G['KF_NoticeProposalButton_'..i]:SetScript('OnClick', function(self)
			if KF.db.Extra_Functions.Secretary.NoticeProposal == true then
				KF.db.Extra_Functions.Secretary.NoticeProposal = false
				self.CheckButton:Hide()
			else
				KF.db.Extra_Functions.Secretary.NoticeProposal = true
				self.CheckButton:Show()
			end
		end)
		_G['KF_NoticeProposalButton_'..i]:SetScript('OnShow', function(self)
			if KF.db.Extra_Functions.Secretary.NoticeProposal == true then
				self.CheckButton:Show()
			else
				self.CheckButton:Hide()
			end
		end)
	end
	KF_NoticeProposalButton_2:SetParent(LFDRoleCheckPopup)	
	KF_NoticeProposalButton_2:Point('CENTER', LFDRoleCheckPopup, 'BOTTOM', 0, 53)
	
	
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
	
	
	LFDRoleCheckPopup:HookScript('OnShow', function()
		if GetCVar('Sound_EnableAllSound') == '0' then
			KF_NoticeProposalButton_2:Show()
			
			LFDRoleCheckPopup:SetHeight(200)
			LFDRoleCheckPopupDescription:Point('CENTER', LFDRoleCheckPopup, 'BOTTOM', 0, 77)
		else
			KF_NoticeProposalButton_2:Hide()
			
			LFDRoleCheckPopup:SetHeight(180)
			LFDRoleCheckPopupDescription:Point('CENTER', LFDRoleCheckPopup, 'BOTTOM', 0, 57)
		end
	end)
end
]]