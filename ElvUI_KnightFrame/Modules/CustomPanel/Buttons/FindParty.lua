local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Panel - FindParty Button									>>--
--------------------------------------------------------------------------------
local Check_FindParty = IsAddOnLoaded('Findparty')
local _, _, _, _, _, IsMissing = GetAddOnInfo('Findparty')

KF.UIParent.Button.Findparty = {
	Text = (Check_FindParty and '' or '|cff828282')..'P',
	
	OnClick = function(Button, pressedButton)
		GameTooltip:Hide()
		
		if Check_FindParty then
			ToggleFrame(FP_Frame)
			
			Button.text:SetText(KF.UIParent.Button.Findparty.Text)
		elseif IsMissing ~= 'MISSING' then
			EnableAddOn('Findparty')
			
			if InCombatLockdown() then
				E:StaticPopup_Show('CONFIG_RL')
			else
				ReloadUI()
			end
		end
	end
}