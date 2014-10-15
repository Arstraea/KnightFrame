local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

if E.private.general.minimap.enable ~= false then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Minimap Panel											>>--
	--------------------------------------------------------------------------------
	local PANEL_HEIGHT = 22
	local SPACING = E.PixelMode and 3 or 5
	
	KF.InitializeFunction.Minimap_FarmModeButton = function()
		-- Create Farm-Mode Icon to minimap
		LeftMiniPanel:Point('BOTTOMRIGHT', Minimap, 'BOTTOM', -E.Spacing * 2 - 10, -((E.PixelMode and 0 or 3) + PANEL_HEIGHT))
		RightMiniPanel:Point('BOTTOMLEFT', Minimap, 'BOTTOM', E.Spacing * 2 + 10, -((E.PixelMode and 0 or 3) + PANEL_HEIGHT))
		
		CreateFrame('Frame', 'MiddleMiniPanel', Minimap)
		MiddleMiniPanel:Point('TOPLEFT', LeftMiniPanel, 'TOPRIGHT', E.Spacing, 0)
		MiddleMiniPanel:Point('BOTTOMRIGHT', RightMiniPanel, 'BOTTOMLEFT', -E.Spacing, 0)
		MiddleMiniPanel:SetTemplate('Default', true)
		MiddleMiniPanel.tex = MiddleMiniPanel:CreateTexture(nil, 'OVERLAY')
		MiddleMiniPanel.tex:SetTexture('INTERFACE\\ICONS\\inv_misc_shovel_01')
		MiddleMiniPanel.tex:SetInside()
		MiddleMiniPanel.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		MiddleMiniPanel:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
			GameTooltip:ClearLines()
			GameTooltip:AddLine('Run ElvUI '..KF:Color_Value('Farm Mode')..'.', 1, 1, 1)
			GameTooltip:Show()
		end)
		MiddleMiniPanel:SetScript('OnLeave', function() GameTooltip:Hide() end)
		MiddleMiniPanel:SetScript('OnMouseDown', E.FarmMode)
	end
	
	
	KF.Modules[#KF.Modules + 1] = 'MinimapBackdropWhenFarmMode'
	KF.Modules.MinimapBackdropWhenFarmMode = function(RemoveOrder)
		if not RemoveOrder and DB.Enable ~= false and DB.Modules.MinimapBackdropWhenFarmMode ~= false then
			if not MinimapBG then
				CreateFrame('Button', 'MinimapBG', KF.UIParent)
				MinimapBG:CreateBackdrop('Transparent')
				MinimapBG:Point('TOPLEFT', Minimap)
				MinimapBG:Point('BOTTOMRIGHT', Minimap)
				MinimapBG:SetFrameStrata('BACKGROUND')
				MinimapBG:SetScript('OnClick', E.FarmMode)
				
				KF:TextSetting(MinimapBG, KF:Color_Value('Farm Mode'), { Tag = 'Line1', FontSize = 20 }, 'CENTER', 0, 10)
				KF:TextSetting(MinimapBG, 'Activated', { Tag = 'Line2', FontSize = 20 }, 'CENTER', 0, -10)
				
				local function ValueColorUpdate()
					MinimapBG.Line1:SetText(KF:Color_Value('Farm Mode'))
				end
				E.valueColorUpdateFuncs[ValueColorUpdate] = true
			else
				MinimapBG:Show()
			end
			
			LeftMiniPanel:SetParent(MinimapBG)
			RightMiniPanel:SetParent(MinimapBG)
			MiddleMiniPanel:SetParent(MinimapBG)
		elseif MinimapBG then
			MinimapBG:Hide()
			
			LeftMiniPanel:SetParent(Minimap)
			RightMiniPanel:SetParent(Minimap)
			MiddleMiniPanel:SetParent(Minimap)
		end
	end
end