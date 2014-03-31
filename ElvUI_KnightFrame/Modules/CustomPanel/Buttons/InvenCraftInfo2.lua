local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 5
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Panel - InvenCraftInfo2 Button							>>--
	--------------------------------------------------------------------------------
	local Check_ICI2 = IsAddOnLoaded('InvenCraftInfo2')
	local _, _, _, _, _, IsMissing = GetAddOnInfo('InvenCraftInfo2')
	
	KF.Button['InvenCraftInfo2'] = {
		['Text'] = (Check_ICI2 and '' or '|cff828282')..'I',
		
		['OnEnter'] = 'AddOn_Default',
		
		['OnLeave'] = 'AddOn_Default',
		
		['OnMouseDown'] = 'AddOn_Default',
		['OnMouseUp'] = 'AddOn_Default',
		
		['OnClick'] = function(Button, pressedButton)
			GameTooltip:Hide()
			
			if Check_ICI2 then
				ToggleFrame(TradeSkillFrame)
				
				if TradeSkillFrame:IsShown() then	-- Default page is Enchanting
					InvenCraftInfo2SideTab7:Click()
				end
				
				Button.text:SetText(KF.Button['InvenCraftInfo2']['Text'])
			elseif IsMissing ~= 'MISSING' then
				EnableAddOn('InvenCraftInfo2')
				
				if InCombatLockdown() then
					E:StaticPopup_Show('CONFIG_RL')
				else
					ReloadUI()
				end
			end
		end,
	}
end