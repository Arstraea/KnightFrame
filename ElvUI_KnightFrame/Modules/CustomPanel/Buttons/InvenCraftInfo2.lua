local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Panel - InvenCraftInfo2 Button							>>--
--------------------------------------------------------------------------------
local Check_ICI2 = IsAddOnLoaded('InvenCraftInfo2')
local _, _, _, _, _, IsMissing = GetAddOnInfo('InvenCraftInfo2')

KF.UIParent.Button.InvenCraftInfo2 = {
	Text = (Check_ICI2 and '' or '|cff828282')..'I',
	
	OnClick = function(Button, pressedButton)
		GameTooltip:Hide()
		
		if Check_ICI2 then
			ToggleFrame(TradeSkillFrame)
			
			if InvenCraftInfo2SideTab7 then	-- Default page is Enchanting
				InvenCraftInfo2SideTab7:Click()
			end
			
			Button.text:SetText(KF.UIParent.Button.InvenCraftInfo2.Text)
		elseif IsMissing ~= 'MISSING' then
			EnableAddOn('InvenCraftInfo2')
			
			if InCombatLockdown() then
				E:StaticPopup_Show('CONFIG_RL')
			else
				ReloadUI()
			end
		end
	end
}