﻿--Cache global variables
--Lua functions
local _G = _G
local unpack, select, pairs, type = unpack, select, pairs, type

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

--WoW API / Variables
local CreateFrame = CreateFrame

--------------------------------------------------------------------------------
--<< KnightFrame : Create Floating Datatext									>>--
--------------------------------------------------------------------------------
local Activate = false
local DeletedDatatext = {}
local FloatingDatatextCount = 0
local PANEL_HEIGHT = 22

KF.UIParent.Datatext = {}
KF.UIParent.MoverType.KF_Datatext = L['Floating Datatext']

local function RefreshDatatext(DatatextName, DatatextInfo)
	local FD = KF.UIParent.Datatext[DatatextName]
	
	FD.Datatext:UnregisterAllEvents()
	FD.Datatext:SetScript('OnEvent', nil)
	FD.Datatext:SetScript('OnUpdate', nil)
	FD.Datatext:SetScript('OnEnter', nil)
	FD.Datatext:SetScript('OnLeave', nil)
	FD.Datatext:SetScript('OnClick', nil)
	FD.Datatext.text:SetText(nil)
	
	if DatatextInfo.Display.PvPMode ~= '' and DT.RegisteredDataTexts[(DatatextInfo.Display.PvPMode)] and (Info.InstanceType == 'arena' or Info.InstanceType =='pvp') then
		DT:AssignPanelToDataText(FD.Datatext, DT.RegisteredDataTexts[(DatatextInfo.Display.PvPMode)])
	elseif DatatextInfo.Display.Mode == '0' and DatatextInfo.Display[Info.Role] ~= '' and DT.RegisteredDataTexts[(DatatextInfo.Display[Info.Role])] then
		DT:AssignPanelToDataText(FD.Datatext, DT.RegisteredDataTexts[(DatatextInfo.Display[Info.Role])])
	elseif DatatextInfo.Display.Mode ~= '' and DT.RegisteredDataTexts[(DatatextInfo.Display.Mode)] then
		DT:AssignPanelToDataText(FD.Datatext, DT.RegisteredDataTexts[(DatatextInfo.Display.Mode)])
	end
end


function KF:FloatingDatatext_Create(DatatextName, DatatextInfo)
	DatatextInfo = DatatextInfo or KF.db.Modules.FloatingDatatext[DatatextName] or {}
	
	if not (KF.db.Modules.FloatingDatatext.Enable and DatatextInfo.Enable) then
		KF:FloatingDatatext_Delete(DatatextName, true)
		return
	end
	
	local FD = KF.UIParent.Datatext[DatatextName]
	
	if not FD then
		if #DeletedDatatext > 0 then
			KF.UIParent.Datatext[DatatextName] = DeletedDatatext[#DeletedDatatext]
			
			FD = KF.UIParent.Datatext[DatatextName]
			
			--local moverData = FD.MoverData
			E.CreatedMovers[FD.mover.name] = FD.MoverData --moverData
			FD.MoverData = nil
			
			FD:Show()
			
			DeletedDatatext[#DeletedDatatext] = nil
		else
			FloatingDatatextCount = FloatingDatatextCount + 1
			
			FD = CreateFrame('Frame', nil, KF.UIParent)
			FD.xOff = 0
			FD.yOff = 2
			FD.anchor = 'ANCHOR_TOP'
			FD.Count = FloatingDatatextCount
			FD:Point('CENTER')
			
			FD.BG = CreateFrame('Frame', nil, FD)
			FD.BG:SetInside()
			
			FD.Datatext = CreateFrame('Button', nil, FD)
			FD.Datatext:RegisterForClicks('AnyUp')
			FD.Datatext:SetInside()
			KF:TextSetting(FD.Datatext, nil, nil, 'CENTER', FD.Datatext)
			
			KF.UIParent.Datatext[DatatextName] = FD
			
			E:CreateMover(FD, 'KF_Datatext_'..FD.Count, DatatextInfo.Name or DatatextName, nil, nil, nil, 'ALL,KF,KF_Datatext')
		end
		
		E.CreatedMovers[FD.mover.name].point = E:HasMoverBeenMoved(DatatextName) and E.db.movers[DatatextName] or DatatextInfo.Location or 'CENTER'..Info.MoverDelimiter..'ElvUIParent'
		FD.mover:ClearAllPoints()
		FD.mover:SetPoint(unpack({string.split(Info.MoverDelimiter, E.CreatedMovers[FD.mover.name].point)}))
	end
	
	-- Parent
	FD:SetParent(DatatextInfo.HideWhenPetBattle and KF.UIParent or E.UIParent)
	FD:SetFrameStrata('LOW')
	FD:SetFrameLevel(11)
	
	-- Size
	FD:Size(DatatextInfo.Backdrop.Width, DatatextInfo.Backdrop.Height)
	FD.mover:Size(DatatextInfo.Backdrop.Width, DatatextInfo.Backdrop.Height)
	
	-- Backdrop
	if DatatextInfo.Backdrop.Enable then
		FD.BG:Show()
		FD.BG:SetTemplate(DatatextInfo.Backdrop.Transparency == true and 'Transparent' or 'Default', true)
		
		-- Texture
		if DatatextInfo.Backdrop.Texture ~= '' and FD.BG.backdropTexture then
			FD.BG.backdropTexture:SetTexture(LibStub('LibSharedMedia-3.0'):Fetch('statusbar', DatatextInfo.Backdrop.Texture))
		end
		
		if DatatextInfo.Backdrop.CustomColor then
			E.frames[FD.BG] = nil
			
			if DatatextInfo.Backdrop.Transparency then
				FD.BG:SetBackdropColor(DatatextInfo.Backdrop.CustomColor_Backdrop_Transparency.r, DatatextInfo.Backdrop.CustomColor_Backdrop_Transparency.g, DatatextInfo.Backdrop.CustomColor_Backdrop_Transparency.b, DatatextInfo.Backdrop.CustomColor_Backdrop_Transparency.a)
			elseif FD.BG.backdropTexture then
				FD.BG:SetBackdropColor(0, 0, 0, DatatextInfo.Backdrop.CustomColor_Backdrop.a)
				FD.BG.backdropTexture:SetVertexColor(DatatextInfo.Backdrop.CustomColor_Backdrop.r, DatatextInfo.Backdrop.CustomColor_Backdrop.g, DatatextInfo.Backdrop.CustomColor_Backdrop.b)
				FD.BG.backdropTexture:SetAlpha(DatatextInfo.Backdrop.CustomColor_Backdrop.a)
			end
			
			FD.BG:SetBackdropBorderColor(DatatextInfo.Backdrop.CustomColor_Border.r, DatatextInfo.Backdrop.CustomColor_Border.g, DatatextInfo.Backdrop.CustomColor_Border.b)
		end
	else
		FD.BG:Hide()
	end
	
	-- Font
	if DatatextInfo.Font.UseCustomFontStyle == false then
		FD.Datatext.text:FontTemplate(E.LSM:Fetch('font', DT.db.font), DT.db.fontSize, DT.db.FontStyle)
	else
		FD.Datatext.text:FontTemplate(E.LSM:Fetch('font', DatatextInfo.Font.Font), DatatextInfo.Font.FontSize, DatatextInfo.Font.FontStyle)
	end
	
	-- Display Mode
	KF:UnregisterCallback('SpecChanged', 'FloatingDatatext_'..FD.Count)
	KF:UnregisterCallback('CurrentAreaChanged', 'FloatingDatatext_'..FD.Count)
	
	
	local function RefreshDatatextByCallback()
		RefreshDatatext(DatatextName, DatatextInfo)
	end
	
	if DatatextInfo.Display.PvPMode ~= '' then
		KF:RegisterCallback('SpecChanged', RefreshDatatextByCallback, 'FloatingDatatext_'..FD.Count)
		KF:RegisterCallback('CurrentAreaChanged', RefreshDatatextByCallback, 'FloatingDatatext_'..FD.Count)
	elseif DatatextInfo.Display.Mode == '0' then
		KF:RegisterCallback('SpecChanged', RefreshDatatextByCallback, 'FloatingDatatext_'..FD.Count)
	end
	
	RefreshDatatext(DatatextName, DatatextInfo)
	
	
	-- Update Mover's Tag
	FD.mover.text:SetText(DatatextInfo.Name or DatatextName)
	
	
	-- Ignore Cursor
	FD.Datatext:EnableMouse(not DatatextInfo.IgnoreCursor)
	
	
	if E.ConfigurationMode then
		FD.mover:Show()
	end
end


function KF:FloatingDatatext_Delete(DatatextName, SaveProfile)
	local FD = KF.UIParent.Datatext[DatatextName]
	
	if FD then
		FD:SetAlpha(1)
		FD:SetScript('OnUpdate', nil)
		FD:Hide()
		
		FD.Datatext:UnregisterAllEvents()
		FD.Datatext:SetScript('OnEvent', nil)
		FD.Datatext:SetScript('OnUpdate', nil)
		FD.Datatext:SetScript('OnEnter', nil)
		FD.Datatext:SetScript('OnLeave', nil)
		FD.Datatext:SetScript('OnClick', nil)
		FD.Datatext.text:SetText(nil)
		
		FD.mover:Hide()
		
		local moverData = E.CreatedMovers[FD.mover.name]
		FD.MoverData = moverData
		E.CreatedMovers[FD.mover.name] = nil
		KF:UnregisterCallback('SpecChanged', 'FloatingDatatext_'..FD.Count)
		KF:UnregisterCallback('CurrentAreaChanged', 'FloatingDatatext_'..FD.Count)
		
		if SaveProfile then
			E:SaveMoverPosition(FD.mover.name)
			E.db.movers[DatatextName] = E.db.movers[FD.mover.name]
		else
			E.db.movers[DatatextName] = nil
		end
		E.db.movers[FD.mover.name] = nil
		
		DeletedDatatext[#DeletedDatatext + 1] = KF.UIParent.Datatext[DatatextName]
		KF.UIParent.Datatext[DatatextName] = nil
	end
end


hooksecurefunc(DT, 'LoadDataTexts', function()
	if FloatingDatatextCount == 0 then return end
	
	if Info.FloatingDatatext_Activate then
		local Data
		
		for DatatextName, IsDatatextData in pairs(KF.db.Modules.FloatingDatatext) do
			if type(IsDatatextData) == 'table' and KF.UIParent.Datatext[DatatextName] then
				Data = nil
				if IsDatatextData.Display.PvPMode ~= '' and DT.RegisteredDataTexts[(IsDatatextData.Display.PvPMode)] and (Info.InstanceType == 'arena' or Info.InstanceType =='pvp') then
					Data = 'PvPMode'
				elseif IsDatatextData.Display.Mode == '0' and IsDatatextData.Display[Info.Role] ~= '' and DT.RegisteredDataTexts[(IsDatatextData.Display[Info.Role])] then
					Data = Info.Role
				elseif IsDatatextData.Display.Mode ~= '' and DT.RegisteredDataTexts[(IsDatatextData.Display.Mode)] then
					Data = 'Mode'
				end
				
				if Data then
					Data = DT.RegisteredDataTexts[(IsDatatextData.Display[Data])]
					
					if Data.eventFunc then
						Data.eventFunc(KF.UIParent.Datatext[DatatextName].Datatext, 'ELVUI_FORCE_RUN')
					end
					
					if Data.onUpdate then
						Data.onUpdate(KF.UIParent.Datatext[DatatextName].Datatext, 20000)
					end
				end
				
				if IsDatatextData.Font.UseCustomFontStyle == false then
					KF.UIParent.Datatext[DatatextName].Datatext.text:FontTemplate(E.LSM:Fetch('font', DT.db.font), DT.db.fontSize, DT.db.FontStyle)
				end
			end
		end
	end
end)


if IsAddOnLoaded('ElvUI_Enhanced') then
	local EDT = E:GetModule('ExtraDataTexts')
	
	if EDT then
		local enhancedClickMenu
		
		EDT.ExtendClickFunction_ = EDT.ExtendClickFunction
		
		function EDT:ExtendClickFunction(data)
			if data.onClick and data.origOnClick and not enhancedClickMenu then
				enhancedClickMenu = data.onClick
			end
			
			if not data.onClick or enhancedClickMenu and data.onClick ~= enhancedClickMenu then
				EDT:ExtendClickFunction_(data)
			end
			
			if data.onClick and data.origOnClick and not enhancedClickMenu then
				enhancedClickMenu = data.onClick
			end
			
			if not data.enhancedOnClick then
				data.enhancedOnClick = data.onClick
				data.onClick = function(self, Button)
					if DT.RegisteredPanels[self:GetParent():GetName()] then
						data.enhancedOnClick(self, Button)
					elseif data.origOnClick then
						data.origOnClick(self, Button)
					end
				end
			end
		end
		
		for name in pairs(DT.RegisteredDataTexts) do
			EDT:ExtendClickFunction(DT.RegisteredDataTexts[name])
		end
	end
end




--------------------------------------------------------------------------------
--<< KnightFrame : Initialize Floating Datatext								>>--
--------------------------------------------------------------------------------
KF.Modules[#KF.Modules + 1] = 'FloatingDatatext'
KF.Modules.FloatingDatatext = function(RemoveOrder)
	-- Update Floating Datatext
	for DatatextName in pairs(KF.UIParent.Datatext) do
		KF:FloatingDatatext_Delete(DatatextName, true)
	end
	
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.FloatingDatatext.Enable ~= false then
		Info.FloatingDatatext_Activate = true
		
		for DatatextName, IsDatatextData in pairs(KF.db.Modules.FloatingDatatext) do
			if type(IsDatatextData) == 'table' then
				KF:FloatingDatatext_Create(DatatextName)
			end
		end
	else
		Info.FloatingDatatext_Activate = nil
	end
end