local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 5
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Panel - FindParty Button									>>--
	--------------------------------------------------------------------------------
	local Check_FindParty = IsAddOnLoaded('Findparty')
	local _, _, _, _, _, IsMissing = GetAddOnInfo('Findparty')
	
	KF.Button['Findparty'] = {
		['Text'] = (Check_FindParty and '' or '|cff828282')..'P',
		
		['OnEnter'] = 'AddOn_Default',
		
		['OnLeave'] = 'AddOn_Default',
		
		['OnMouseDown'] = 'AddOn_Default',
		['OnMouseUp'] = 'AddOn_Default',
		
		['OnClick'] = function(Button, pressedButton)
			GameTooltip:Hide()
			
			if Check_FindParty then
				ToggleFrame(FP_Frame)
				
				Button.text:SetText(KF.Button['Findparty']['Text'])
			elseif IsMissing ~= 'MISSING' then
				EnableAddOn('Findparty')
				
				if InCombatLockdown() then
					E:StaticPopup_Show('CONFIG_RL')
				else
					ReloadUI()
				end
			end
		end,
	}
end