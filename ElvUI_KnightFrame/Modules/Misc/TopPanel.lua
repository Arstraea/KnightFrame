local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))
local M = E:GetModule('Minimap')

--------------------------------------------------------------------------------
--<< KnightFrame : Initialize KnightFrame TopPanel							>>--
--------------------------------------------------------------------------------
local x, y
local function UpdateLocation()
	--if not (DB.Modules.TargetAuraTracker ~= false and UnitExists('target'))then
		x, y = GetPlayerMapPosition('player')
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		KF_InfoDisplay.LocationName.text:SetText(strsub(GetMinimapZoneText(), 1))
		KF_InfoDisplay.LocationName.text:SetTextColor(M:GetLocTextColor())
		
		KF_InfoDisplay.LocationX.text:SetText(x == 0 and '...' or KF:Color_Value(x))
		KF_InfoDisplay.LocationY.text:SetText(y == 0 and '...' or KF:Color_Value(y))
	--end
end

KF.Modules[#KF.Modules + 1] = 'TopPanel'
KF.Modules.TopPanel = function(RemoveOrder)
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.TopPanel.Enable ~= false then
		if not KF_InfoDisplay then
			CreateFrame('Frame', 'KF_InfoDisplay', ElvUI_TopPanel)
			KF_InfoDisplay:CreateBackdrop('Transparent')
			KF_InfoDisplay:Size(304, 16)
			KF_InfoDisplay:Point('BOTTOM', ElvUI_TopPanel, 0, -8)
			KF_InfoDisplay:SetFrameLevel(10)
			
			KF_InfoDisplay.LocationName = CreateFrame('Frame', nil, KF_InfoDisplay)
			KF_InfoDisplay.LocationName:SetTemplate('Default', true)
			KF_InfoDisplay.LocationName.backdropTexture:SetVertexColor(.1, .1, .1)
			KF_InfoDisplay.LocationName:Size(200, 20)
			KF_InfoDisplay.LocationName:Point('BOTTOM', KF_InfoDisplay, 0, -6)
			KF_InfoDisplay.LocationName:SetFrameLevel(11)
			KF:TextSetting(KF_InfoDisplay.LocationName, nil, { FontSize = 12, FontOutline = 'NONE' })
			
			KF_InfoDisplay.LocationX = CreateFrame('Frame', nil, KF_InfoDisplay)
			KF_InfoDisplay.LocationX:SetTemplate('Default', true)
			KF_InfoDisplay.LocationX.backdropTexture:SetVertexColor(.1, .1, .1)
			KF_InfoDisplay.LocationX:Size(46, 20)
			KF_InfoDisplay.LocationX:Point('RIGHT', KF_InfoDisplay.LocationName, 'LEFT', -4, 0)
			KF_InfoDisplay.LocationX:SetFrameLevel(11)
			KF:TextSetting(KF_InfoDisplay.LocationX, nil, { FontSize = 12, FontOutline = 'NONE' })
			
			KF_InfoDisplay.LocationY = CreateFrame('Frame', nil, KF_InfoDisplay)
			KF_InfoDisplay.LocationY:SetTemplate('Default', true)
			KF_InfoDisplay.LocationY.backdropTexture:SetVertexColor(.1, .1, .1)
			KF_InfoDisplay.LocationY:Size(46, 20)
			KF_InfoDisplay.LocationY:Point('LEFT', KF_InfoDisplay.LocationName, 'RIGHT', 4, 0)
			KF_InfoDisplay.LocationY:SetFrameLevel(11)
			KF:TextSetting(KF_InfoDisplay.LocationY, nil, { FontSize = 12, FontOutline = 'NONE' })
		else
			KF_InfoDisplay:Show()
		end
		
		E.db.general.topPanel = true
		E.Layout:TopPanelVisibility()
		ElvUI_TopPanel:Height(DB.Modules.TopPanel.Height)
		
		KF:RegisterEventList('PLAYER_STARTED_MOVING', function()
			Timer.TopPanel_UpdateLocation = C_Timer.NewTicker(.25, UpdateLocation)
		end, 'TopPanel_UpdateLocation')
		
		KF:RegisterEventList('PLAYER_STOPPED_MOVING', function() Timer.TopPanel_UpdateLocation:Cancel() end, 'TopPanel_UpdateLocation')
		KF:RegisterEventList('PLAYER_ENTERING_WORLD', UpdateLocation, 'TopPanel_UpdateLocation')
		KF:RegisterEventList('WORLD_MAP_UPDATE', UpdateLocation, 'TopPanel_UpdateLocation')
		
		
		--[[
		UD.TopPanel_UpdateLocation = {
			Condition = function() return not (DB.Modules.SynergyTracker ~= false and UnitExists('target')) and (KF_InfoDisplay.LocationName.text:GetText() == nil or GetUnitSpeed('player') > 0) and true or false end,
			Delay = 0.25,
			Action = function()
				
			end
		}
		
		if (KF_SynergyTracker_Player or KF_SynergyTracker_Target) and not (DB.Modules.SynergyTracker ~= false and UnitExists('target')) then
			KF_SynergyTracker_Player:Point('TOPRIGHT', ElvUI_TopPanel, 'BOTTOMRIGHT', -8, 10)
			KF_SynergyTracker_Target:Point('CENTER', KF_InfoDisplay.LocationName)
			UD.TopPanel_UpdateLocation.Action()
		end
		]]
	elseif KF_InfoDisplay then
		KF:UnregisterEventList('PLAYER_ENTERING_WORLD', 'TopPanel_UpdateLocation')
		KF:UnregisterEventList('WORLD_MAP_UPDATE', 'TopPanel_UpdateLocation')
		
		KF_InfoDisplay:Hide()
	end
end