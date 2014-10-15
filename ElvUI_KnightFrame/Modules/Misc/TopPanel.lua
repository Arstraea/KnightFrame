local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Initialize KnightFrame TopPanel							>>--
--------------------------------------------------------------------------------
--[[
local function UpdateLocation()
	if not (DB.Modules.TargetAuraTracker ~= false and UnitExists('target'))then
		UD.TopPanel_UpdateLocation.Action()
	end
end


KF.Modules[#KF.Modules + 1] = 'TopPanel'
KF.Modules.TopPanel = function(RemoveOrder)
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.TopPanel.Enable ~= false then
		if not KF_TopPanel then
			CreateFrame('Frame', 'KF_TopPanel', KF.UIParent)
			KF_TopPanel:Point('TOPLEFT', KF.UIParent, 6, 2)
			KF_TopPanel:SetFrameStrata('BACKGROUND')
			KF_TopPanel:CreateBackdrop('Transparent')
			
			KF_TopPanel.CenterHolder = CreateFrame('Frame', nil, KF_TopPanel)
			KF_TopPanel.CenterHolder:CreateBackdrop('Transparent')
			KF_TopPanel.CenterHolder:Size(304, 16)
			KF_TopPanel.CenterHolder:Point('BOTTOM', KF_TopPanel, 0, -8)
			
			KF_TopPanel.LocationName = CreateFrame('Frame', nil, KF_TopPanel.CenterHolder)
			KF_TopPanel.LocationName:SetTemplate('Default', true)
			KF_TopPanel.LocationName.backdropTexture:SetVertexColor(0.1, 0.1, 0.1)
			KF_TopPanel.LocationName:Size(200, 20)
			KF_TopPanel.LocationName:Point('BOTTOM', KF_TopPanel.CenterHolder, 0, -6)
			KF_TopPanel.LocationName:SetFrameLevel(9)
			KF:TextSetting(KF_TopPanel.LocationName, nil, { FontSize = 12, FontOutline = 'NONE' })
			
			KF_TopPanel.LocationX = CreateFrame('Frame', nil, KF_TopPanel.CenterHolder)
			KF_TopPanel.LocationX:SetTemplate('Default', true)
			KF_TopPanel.LocationX.backdropTexture:SetVertexColor(0.1, 0.1, 0.1)
			KF_TopPanel.LocationX:Size(46, 20)
			KF_TopPanel.LocationX:Point('RIGHT', KF_TopPanel.LocationName, 'LEFT', -4, 0)
			KF_TopPanel.LocationX:SetFrameLevel(9)
			KF:TextSetting(KF_TopPanel.LocationX, nil, { FontSize = 12, FontOutline = 'NONE' })
			
			KF_TopPanel.LocationY = CreateFrame('Frame', nil, KF_TopPanel.CenterHolder)
			KF_TopPanel.LocationY:SetTemplate('Default', true)
			KF_TopPanel.LocationY.backdropTexture:SetVertexColor(0.1, 0.1, 0.1)
			KF_TopPanel.LocationY:Size(46, 20)
			KF_TopPanel.LocationY:Point('LEFT', KF_TopPanel.LocationName, 'RIGHT', 4, 0)
			KF_TopPanel.LocationY:SetFrameLevel(9)
			KF:TextSetting(KF_TopPanel.LocationY, nil, { FontSize = 12, FontOutline = 'NONE' })
		else
			KF_TopPanel:Show()
		end
		
		KF_TopPanel:Point('BOTTOMRIGHT', KF.UIParent, 'TOPRIGHT', -6, -(2 + DB.Modules.TopPanel.Height))
		
		local x, y
		UD.TopPanel_UpdateLocation = {
			Condition = function() return not (DB.Modules.SynergyTracker ~= false and UnitExists('target')) and (KF_TopPanel.LocationName.text:GetText() == nil or GetUnitSpeed('player') > 0) and true or false end,
			Delay = 0.25,
			Action = function()
				x, y = GetPlayerMapPosition('player')
				x = math.floor(100 * x)
				y = math.floor(100 * y)
				KF_TopPanel.LocationName.text:SetText(strsub(GetMinimapZoneText(), 1))
				KF_TopPanel.LocationName.text:SetTextColor(E:GetModule('Minimap'):GetLocTextColor())
				
				KF_TopPanel.LocationX.text:SetText(x == 0 and '...' or KF:Color_Value(x))
				KF_TopPanel.LocationY.text:SetText(y == 0 and '...' or KF:Color_Value(y))
			end
		}
		
		KF:RegisterEventList('PLAYER_ENTERING_WORLD', UpdateLocation, 'TopPanel_UpdateLocation')
		KF:RegisterEventList('WORLD_MAP_UPDATE', UpdateLocation, 'TopPanel_UpdateLocation')
		
		if (KF_SynergyTracker_Player or KF_SynergyTracker_Target) and not (DB.Modules.SynergyTracker ~= false and UnitExists('target')) then
			KF_SynergyTracker_Player:Point('TOPRIGHT', KF_TopPanel, 'BOTTOMRIGHT', -8, 10)
			KF_SynergyTracker_Target:Point('CENTER', KF_TopPanel.LocationName)
			UD.TopPanel_UpdateLocation.Action()
		end
	elseif KF_TopPanel then
		UD.TopPanel_UpdateLocation = nil
		KF:UnregisterEventList('PLAYER_ENTERING_WORLD', 'TopPanel_UpdateLocation')
		KF:UnregisterEventList('WORLD_MAP_UPDATE', 'TopPanel_UpdateLocation')
		
		KF_TopPanel:Hide()
	end
end]]