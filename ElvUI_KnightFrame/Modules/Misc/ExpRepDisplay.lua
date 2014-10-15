local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--[[
--------------------------------------------------------------------------------
--<< KnightFrame : Create Panel, Button										>>--
--------------------------------------------------------------------------------
local M = E:GetModule('Misc')
local PANEL_HEIGHT = 22

function KF:ExpRepDisplay_ToggleExpRepTooltip(ToggleType)
	local needUpdate
	
	if KF_RepTooltip then
		if ToggleType == 'HIDE' or (not ElvUI_ReputationBar:IsShown() and KF_RepTooltip:IsShown()) then
			KF_RepTooltip:Hide()
			
			needUpdate = true
		elseif ReputationBarMover and ElvUI_ReputationBar:IsShown() then
			KF_RepTooltip:Show()
			ElvUI_ReputationBar:ClearAllPoints()
			ElvUI_ReputationBar:Point('TOPLEFT', KF_RepTooltip, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
			ElvUI_ReputationBar:Point('BOTTOMRIGHT', KF_RepTooltip, -2, 2)
			ElvUI_ReputationBar:SetFrameStrata('HIGH')
			ElvUI_ReputationBar:SetFrameLevel(4)
		end
	end
	
	if KF_ExpTooltip then
		if ToggleType == 'HIDE' or (not ElvUI_ExperienceBar:IsShown() and KF_ExpTooltip:IsShown()) then
			KF_ExpTooltip:Hide()
			
			needUpdate = true
		elseif ExperienceBarMover and ElvUI_ExperienceBar:IsShown() then
			KF_ExpTooltip:Show()
			if ElvUI_ReputationBar:IsShown() then
				KF_ExpTooltip:Point('BOTTOM', KF_RepTooltip, 'TOP', 0, -1)
			else
				KF_ExpTooltip:Point('BOTTOM', KF_ExpRepSensor)
			end
			ElvUI_ExperienceBar:ClearAllPoints()
			ElvUI_ExperienceBar:Point('TOPLEFT', KF_ExpTooltip, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
			ElvUI_ExperienceBar:Point('BOTTOMRIGHT', KF_ExpTooltip, -2, 2)
			ElvUI_ExperienceBar:SetFrameStrata('HIGH')
			ElvUI_ExperienceBar:SetFrameLevel(4)
		end
	end
	
	if needUpdate then
		--M:UpdateExpRepAnchors()
	end
end


function KF:ExpRepDisplay_Lock(Button)
	if not Button or Button == 'RightButton' then
		if DB.Modules.ExpRepDisplay.Lock == true then
			if KF_ExpTooltip then
				KF_ExpTooltip.Title:SetText('< '..KF:Color_Value(COMBAT_XP_GAIN)..' >')
			end
			KF_RepTooltip.Title:SetText('< '..KF:Color_Value(REPUTATION)..' >')
			
			DB.Modules.ExpRepDisplay.Lock = false
			print(L['KF']..' : '..L['Unlock ExpRep Tooltip.'])
		else
			if KF_ExpTooltip then
				KF_ExpTooltip.Title:SetText('< '..KF:Color_Value(COMBAT_XP_GAIN)..' > |cffceff00LOCKED!!|r')
			end
			KF_RepTooltip.Title:SetText('< '..KF:Color_Value(REPUTATION)..' > |cffceff00LOCKED!!|r')
			
			DB.Modules.ExpRepDisplay.Lock = true
			print(L['KF']..' : '..L['Lock ExpRep Tooltip.'])
		end
	elseif Button then
		ToggleCharacter('ReputationFrame')
	end
end


function KF:ExpRepDisplay_EmbedToPanel()
	if Info.ExpRepDisplay_Activate and ReputationBarMover and ExperienceBarMover and KF_ExpRepSensor then
		if not ((KF_ExpTooltip and KF_ExpTooltip:IsShown()) or (KF_RepTooltip and KF_RepTooltip:IsShown())) then
			ElvUI_ExperienceBar:ClearAllPoints()
			ElvUI_ReputationBar:ClearAllPoints()
			
			if ElvUI_ExperienceBar:IsShown() and ElvUI_ReputationBar:IsShown() then
				ElvUI_ExperienceBar:Point('TOPLEFT', KF_ExpRepSensor, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
				ElvUI_ExperienceBar:Point('BOTTOMRIGHT', KF_ExpRepSensor, -2, PANEL_HEIGHT/2 + .5)
				ElvUI_ReputationBar:Point('TOPLEFT', KF_ExpRepSensor, 'BOTTOMLEFT', 2, PANEL_HEIGHT/2 - .5)
				ElvUI_ReputationBar:Point('BOTTOMRIGHT', KF_ExpRepSensor, -2, 2)
			elseif ElvUI_ExperienceBar:IsShown() then
				ElvUI_ExperienceBar:Point('TOPLEFT', KF_ExpRepSensor, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
				ElvUI_ExperienceBar:Point('BOTTOMRIGHT', KF_ExpRepSensor, -2, 2)
			elseif ElvUI_ReputationBar:IsShown() then
				ElvUI_ReputationBar:Point('TOPLEFT', KF_ExpRepSensor, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
				ElvUI_ReputationBar:Point('BOTTOMRIGHT', KF_ExpRepSensor, -2, 2)
			end
		else
			KF:ExpRepDisplay_ToggleExpRepTooltip('SHOW')
		end
	end
end
--hooksecurefunc(M, 'UpdateExpRepAnchors', KF.ExpRepDisplay_EmbedToPanel)


M.UpdateExpRepDimensions_ = M.UpdateExpRepDimensions
function M:UpdateExpRepDimensions()
	if not Info.ExpRepDisplay_Activate then
		M:UpdateExpRepDimensions_()
	end
end


M.UpdateExperience_ = M.UpdateExperience
function M:UpdateExperience(event)
	M.expBar.statusBar:SetValue(0)
	M.expBar.rested:SetValue(0)
	
	if Info.ExpRepDisplay_Activate and KF_ExpTooltip then
		M.expBar.text:SetText('')
		
		if UnitLevel('player') == MAX_PLAYER_LEVEL or IsXPUserDisabled() then
			M.expBar:Hide()
		else
			M.expBar:Show()
			
			local cur, max = M:GetXP('player')
			M.expBar.statusBar:SetMinMaxValues(0, max)
			M.expBar.statusBar:SetValue(cur - 1 >= 0 and cur - 1 or 0)
			M.expBar.statusBar:SetValue(cur)
			
			local rested = GetXPExhaustion()
			
			if rested and rested > 0 then
				M.expBar.rested:SetMinMaxValues(0, max)
				M.expBar.rested:SetValue(min(cur + rested, max))
			end
			
			KF_ExpTooltip.text:SetText(KF:Color_Value('-* ').. string.format('%d / %d '..KF:Color_Value()..'(%d%%)', cur, max, cur / max * 100))
			KF_ExpTooltip.text2:SetText(string.format(L['Rested:']..KF:Color_Value()..' %d%%', rested and rested / max * 100 or 0))
		end
	else
		M:UpdateExperience_(event)
	end
end


M.UpdateReputation_ = M.UpdateReputation
function M:UpdateReputation(event)
	M.repBar.statusBar:SetValue(0)
	
	if Info.ExpRepDisplay_Activate and KF_RepTooltip then
		M.repBar.text:SetText('')
		
		local name, reaction, min, max, value = GetWatchedFactionInfo()
		
		if not name then
			M.repBar:Hide()
			
			if DB.Modules.ExpRepDisplay.Lock and KF_RepTooltip:IsShown() then
				KF:ExpRepDisplay_ToggleExpRepTooltip('SHOW')
			end
		elseif name then
			M.repBar:Show()
			
			if DB.Modules.ExpRepDisplay.Lock and not KF_RepTooltip:IsShown() then
				KF:ExpRepDisplay_ToggleExpRepTooltip('SHOW')
			end
			
			M.repBar.statusBar:SetMinMaxValues(min, max)
			M.repBar.statusBar:SetValue(value)
			M.repBar.statusBar:SetStatusBarColor(FACTION_BAR_COLORS[reaction].r, FACTION_BAR_COLORS[reaction].g, FACTION_BAR_COLORS[reaction].b)
			
			KF_RepTooltip.text:SetText(KF:Color_Value('-* ')..string.format('%d / %d '..KF:Color_Value()..'(%d%%)', value - min, max - min, (value - min) / (max - min) * 100))
			KF_RepTooltip.text2:SetText(E:RGBToHex(FACTION_BAR_COLORS[reaction].r, FACTION_BAR_COLORS[reaction].g, FACTION_BAR_COLORS[reaction].b).._G['FACTION_STANDING_LABEL'..reaction])
			KF_RepTooltip.text3:SetText(name)
		end
	else
		M:UpdateReputation_(event)
	end
end


KF.Modules[#KF.Modules + 1] = 'ExpRepDisplay'
KF.Modules.ExpRepDisplay = function(RemoveOrder)
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.Enable ~= false and DB.Modules.ExpRepDisplay.Enable ~= false and DB.Modules.ExpRepDisplay.EmbedPanel then
		local Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled = KF:GetPanelData(DB.Modules.ExpRepDisplay.EmbedPanel)
		
		if Panel and DB.Modules.ExpRepDisplay.EmbedLocation and (DB.Modules.ExpRepDisplay.EmbedLocation == 'Tab' and IsTabEnabled or IsDPEnabled) then
			if not E.db.general.reputation.enable then
				E.db.general.reputation.enable = true
				M:EnableDisable_ReputationBar()
			end
			
			if not E.db.general.experience.enable then
				E.db.general.experience.enable = true
				M:EnableDisable_ExperienceBar()
			end
			
			Info.ExpRepDisplay_Activate = true
			
			if not KF_ExpRepSensor then
				CreateFrame('Button', 'KF_ExpRepSensor', KF.UIParent)
				KF_ExpRepSensor:RegisterForClicks('AnyUp')
				KF_ExpRepSensor:SetScript('OnEnter', KF.ExpRepDisplay_ToggleExpRepTooltip)
				KF_ExpRepSensor:SetScript('OnLeave', function()
					if DB.Modules.ExpRepDisplay.Lock == false then
						KF:ExpRepDisplay_ToggleExpRepTooltip('HIDE')
					end
				end)
				KF_ExpRepSensor:SetScript('OnClick', KF.ExpRepDisplay_Lock)
				
				
				CreateFrame('Frame', 'KF_RepTooltip', KF.UIParent)
				KF_RepTooltip:SetFrameStrata('HIGH')
				KF_RepTooltip:SetFrameLevel(2)
				KF_RepTooltip:Height(50)
				KF_RepTooltip:Point('LEFT', KF_ExpRepSensor)
				KF_RepTooltip:Point('RIGHT', KF_ExpRepSensor)
				KF_RepTooltip:Point('BOTTOM', KF_ExpRepSensor)
				
				KF_RepTooltip.background = CreateFrame('Frame', nil, KF_RepTooltip)
				KF_RepTooltip.background:CreateBackdrop('Transparent')
				KF_RepTooltip.background:SetInside()
				KF_RepTooltip.background:SetFrameLevel(1)
				
				KF:TextSetting(KF_RepTooltip, '< '..KF:Color_Value(REPUTATION)..' >', { Tag = 'Title', FontSize = 10, FontOutline = 'OUTLINE', directionH = 'LEFT' }, 'TOPLEFT', KF_RepTooltip, 6, -3)
				KF:TextSetting(KF_RepTooltip, '', { FontSize = 10, FontOutline = 'OUTLINE', directionH = 'LEFT' }, 'LEFT', KF_RepTooltip, 8, 4)
				KF:TextSetting(KF_RepTooltip, '', { Tag = 'text2', FontSize = 10, FontOutline = 'OUTLINE', directionH = 'RIGHT' }, 'RIGHT', KF_RepTooltip, -8, 4)
				KF:TextSetting(KF_RepTooltip, '', { Tag = 'text3', FontSize = 10, FontOutline = 'OUTLINE', directionH = 'RIGHT' }, 'TOPRIGHT', KF_RepTooltip, -8, -3)
				
				KF_RepTooltip:Hide()
				
				if not ((UnitLevel('player') == MAX_PLAYER_LEVEL) or IsXPUserDisabled()) then
					CreateFrame('Frame', 'KF_ExpTooltip', KF.UIParent)
					KF_ExpTooltip:SetFrameStrata('HIGH')
					KF_ExpTooltip:SetFrameLevel(2)
					KF_ExpTooltip:Height(50)
					KF_ExpTooltip:Point('LEFT', KF_ExpRepSensor)
					KF_ExpTooltip:Point('RIGHT', KF_ExpRepSensor)
					KF_ExpTooltip:Point('BOTTOM', KF_ExpRepSensor)
					
					KF_ExpTooltip.background = CreateFrame('Frame', nil, KF_ExpTooltip)
					KF_ExpTooltip.background:CreateBackdrop('Transparent')
					KF_ExpTooltip.background:SetInside()
					KF_ExpTooltip.background:SetFrameLevel(1)
					
					KF:TextSetting(KF_ExpTooltip, '< '..KF:Color_Value(COMBAT_XP_GAIN)..' >', { Tag = 'Title', FontSize = 10, FontOutline = 'OUTLINE', directionH = 'LEFT' }, 'TOPLEFT', KF_ExpTooltip, 6, -4)
					KF:TextSetting(KF_ExpTooltip, '', { FontSize = 10, FontOutline = 'OUTLINE', directionH = 'LEFT' }, 'LEFT', KF_ExpTooltip, 8, 3)
					KF:TextSetting(KF_ExpTooltip, '', { Tag = 'text2', FontSize = 10, FontOutline = 'OUTLINE', directionH = 'RIGHT' }, 'TOPRIGHT', KF_ExpTooltip, -8, -4)
					
					KF_ExpTooltip:Hide()
				end
			else
				KF_ExpRepSensor:Show()
			end
			
			KF_ExpRepSensor:SetParent(DB.Modules.ExpRepDisplay.EmbedLocation == 'Tab' and panelTab or panelDP)
			KF_ExpRepSensor:SetFrameStrata('TOOLTIP')
			KF_ExpRepSensor:SetFrameLevel(7)
			KF_ExpRepSensor:ClearAllPoints()
			KF_ExpRepSensor:SetAllPoints()
			
			
			-- Reputation
			ElvUI_ReputationBar:Disable()
			
			if E.CreatedMovers.ReputationBarMover then
				KF_RepTooltip.moverData = E.CreatedMovers.ReputationBarMover
				E.CreatedMovers.ReputationBarMover = nil
				
				KF_RepTooltip.moverPoint = ElvUI_ReputationBar:GetPoint()
				
				ReputationBarMover:Hide()
			end
			
			-- Experience
			if KF_ExpTooltip then
				ElvUI_ExperienceBar:Disable()
				
				if E.CreatedMovers.ExperienceBarMover then
					KF_ExpTooltip.moverData = E.CreatedMovers.ExperienceBarMover
					E.CreatedMovers.ExperienceBarMover = nil
					
					ExperienceBarMover:Hide()
					
					KF_ExpTooltip.moverPoint = ElvUI_ExperienceBar:GetPoint()
				end
			end
			
			
			if DB.Modules.ExpRepDisplay.Lock ~= false then
				if KF_ExpTooltip then
					KF_ExpTooltip.Title:SetText('< '..KF:Color_Value(COMBAT_XP_GAIN)..' > |cffceff00LOCKED!!|r')
				end
				KF_RepTooltip.Title:SetText('< '..KF:Color_Value(REPUTATION)..' > |cffceff00LOCKED!!|r')
				
				KF:ExpRepDisplay_ToggleExpRepTooltip()
			end
			
			KF:ExpRepDisplay_EmbedToPanel()
			M:UpdateExperience()
			M:UpdateReputation()
			
			return
		end
	end
	
	if Info.ExpRepDisplay_Activate then
		Info.ExpRepDisplay_Activate = nil
		
		ElvUI_ExperienceBar:Enable()
		ElvUI_ReputationBar:Enable()
		
		if KF_RepTooltip and KF_RepTooltip.moverData then
			local moverData = KF_RepTooltip.moverData
			E.CreatedMovers.ReputationBarMover = moverData
			KF_RepTooltip.moverData = nil
			
			ReputationBarMover:ClearAllPoints()
			if E:HasMoverBeenMoved('ReputationBarMover') then
				ReputationBarMover:SetPoint(unpack({string.split('\031', E.db.movers.ReputationBarMover)}))
			else
				ReputationBarMover:SetPoint(unpack({string.split('\031', moverData.point)}))
			end
			
			ElvUI_ReputationBar:ClearAllPoints()
			ElvUI_ReputationBar:Point(KF_RepTooltip.moverPoint, ReputationBarMover)
			KF_RepTooltip.moverPoint = nil
			
			if E.ConfigurationMode then
				ReputationBarMover:Show()
			end
		end
		
		if KF_ExpTooltip and KF_ExpTooltip.moverData then
			local moverData = KF_ExpTooltip.moverData
			E.CreatedMovers.ExperienceBarMover = moverData
			KF_ExpTooltip.moverData = nil
			
			ExperienceBarMover:ClearAllPoints()
			if E:HasMoverBeenMoved('ExperienceBarMover') then
				ExperienceBarMover:SetPoint(unpack({string.split('\031', E.db.movers.ExperienceBarMover)}))
			else
				ExperienceBarMover:SetPoint(unpack({string.split('\031', moverData.point)}))
			end
			
			ElvUI_ExperienceBar:ClearAllPoints()
			ElvUI_ExperienceBar:Point(KF_ExpTooltip.moverPoint, ExperienceBarMover)
			KF_ExpTooltip.moverPoint = nil
			
			if E.ConfigurationMode then
				ExperienceBarMover:Show()
			end
		end
		
		if KF_ExpRepSensor then KF_ExpRepSensor:Hide() end
		
		KF:ExpRepDisplay_ToggleExpRepTooltip('HIDE')
		
		if RemoveOrder ~= 'SwitchProfile' then
			M:UpdateExpRepDimensions()
			M:UpdateExperience()
			M:UpdateReputation()
		end
	end
end


local function Update_Color()
	if KF_ExpRepSensor then
		if DB.Modules.ExpRepDisplay.Lock ~= false then
			if KF_ExpTooltip then
				KF_ExpTooltip.Title:SetText('< '..KF:Color_Value(COMBAT_XP_GAIN)..' > |cffceff00LOCKED!!|r')
			end
			KF_RepTooltip.Title:SetText('< '..KF:Color_Value(REPUTATION)..' > |cffceff00LOCKED!!|r')
		else
			if KF_ExpTooltip then
				KF_ExpTooltip.Title:SetText('< '..KF:Color_Value(COMBAT_XP_GAIN)..' >')
			end
			KF_RepTooltip.Title:SetText('< '..KF:Color_Value(REPUTATION)..' >')
		end
		
		M:UpdateExperience()
		M:UpdateReputation()
	end
end
E.valueColorUpdateFuncs[Update_Color] = true
]]