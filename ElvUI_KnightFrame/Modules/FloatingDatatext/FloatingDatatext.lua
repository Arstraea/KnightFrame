local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 5
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Create Floating Datatext									>>--
	--------------------------------------------------------------------------------
	KF.Datatext = {}
	
	local DT = E:GetModule('DataTexts')
	local LSM = LibStub('LibSharedMedia-3.0')
	local Activate = false
	
	local PANEL_HEIGHT = 22
	
	local DeletedDatatext = {}
	local frameCount = 0
	
	
	local function RefreshDatatext(datatextName, DatatextInfo)
		local frame = KF.Datatext[datatextName]
		
		frame.Datatext:UnregisterAllEvents()
		frame.Datatext:SetScript('OnEvent', nil)
		frame.Datatext:SetScript('OnUpdate', nil)
		frame.Datatext:SetScript('OnEnter', nil)
		frame.Datatext:SetScript('OnLeave', nil)
		frame.Datatext:SetScript('OnClick', nil)
		frame.Datatext.text:SetText(nil)
		
		if DatatextInfo['Display']['PvPMode'] ~= '' and DT.RegisteredDataTexts[(DatatextInfo['Display']['PvPMode'])] and (KF.InstanceType == 'arena' or KF.InstanceType =='pvp') then
			DT:AssignPanelToDataText(frame.Datatext, DT.RegisteredDataTexts[(DatatextInfo['Display']['PvPMode'])])
		elseif DatatextInfo['Display']['Mode'] == '0' and DatatextInfo['Display'][KF.Role] ~= '' and DT.RegisteredDataTexts[(DatatextInfo['Display'][KF.Role])] then
			DT:AssignPanelToDataText(frame.Datatext, DT.RegisteredDataTexts[(DatatextInfo['Display'][KF.Role])])
		elseif DatatextInfo['Display']['Mode'] ~= '' and DT.RegisteredDataTexts[(DatatextInfo['Display']['Mode'])] then
			DT:AssignPanelToDataText(frame.Datatext, DT.RegisteredDataTexts[(DatatextInfo['Display']['Mode'])])
		end
	end
	
	
	function KF:Create_FloatingDatatext(datatextName, DatatextInfo)
		if datatextName and not DatatextInfo then
			DatatextInfo = KF.db.Modules.FloatingDatatext[datatextName]
		end
		
		if KF.db.Modules.FloatingDatatext.Enable == false or DatatextInfo['Enable'] == false then
			KF:Delete_FloatingDatatext(datatextName, true)
			return
		end
		
		local frame = KF.Datatext[datatextName]
		
		if not frame then
			if #DeletedDatatext > 0 then
				KF.Datatext[datatextName] = DeletedDatatext[#DeletedDatatext]
				
				frame = KF.Datatext[datatextName]
				
				local moverData = frame.MoverData
				E.CreatedMovers[frame.mover.name] = moverData
				frame.MoverData = nil
				E.CreatedMovers[frame.mover.name]['point'] = E:HasMoverBeenMoved(datatextName) and E.db['movers'][datatextName] or DatatextInfo['Location'] or 'CENTERElvUIParent'
				
				frame.mover:ClearAllPoints()
				frame.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[frame.mover.name]['point'])}))
				
				frame:Show()
				
				DeletedDatatext[#DeletedDatatext] = nil
			else
				local f = CreateFrame('Frame', nil, KF.UIParent)
				f.xOff = 0
				f.yOff = 2
				f.anchor = 'ANCHOR_TOP'
				f:Size(100, PANEL_HEIGHT)
				
				f.BG = CreateFrame('Frame', nil, f)
				f.BG:SetInside()
				
				f.Datatext = CreateFrame('Button', nil, f)
				f.Datatext:RegisterForClicks('AnyUp')
				f.Datatext:SetInside()
				KF:TextSetting(f.Datatext, nil, nil, 'CENTER', f.Datatext)
				
				frameCount = frameCount + 1
				
				f.Count = frameCount
				KF.Datatext[datatextName] = f
				
				frame = KF.Datatext[datatextName]
			end
		end
		
		
		-- Parent
		frame:SetParent(DatatextInfo['HideWhenPetBattle'] and KF.UIParent or E.UIParent)
		frame:SetFrameStrata('BACKGROUND')
		frame:SetFrameLevel(11)
		
		-- Size
		frame:Size(DatatextInfo['Backdrop']['Width'], DatatextInfo['Backdrop']['Height'])
		
		-- Backdrop
		if DatatextInfo['Backdrop']['Enable'] then
			frame.BG:Show()
			frame.BG:SetTemplate(DatatextInfo['Backdrop']['Transparency'] == true and 'Transparent' or 'Default', true)
			
			-- Texture
			if DatatextInfo['Backdrop']['Texture'] ~= '' and frame.BG.backdropTexture then
				frame.BG.backdropTexture:SetTexture(LibStub('LibSharedMedia-3.0'):Fetch('statusbar', DatatextInfo['Backdrop']['Texture']))
			end
			
			if DatatextInfo['Backdrop']['CustomColor'] then
				E['frames'][frame.BG] = nil
				
				if DatatextInfo['Backdrop']['Transparency'] then
					frame.BG:SetBackdropColor(DatatextInfo['Backdrop']['CustomColor_Backdrop_Transparency']['r'], DatatextInfo['Backdrop']['CustomColor_Backdrop_Transparency']['g'], DatatextInfo['Backdrop']['CustomColor_Backdrop_Transparency']['b'], DatatextInfo['Backdrop']['CustomColor_Backdrop_Transparency']['a'])
				elseif frame.BG.backdropTexture then
					frame.BG:SetBackdropColor(0, 0, 0, DatatextInfo['Backdrop']['CustomColor_Backdrop']['a'])
					frame.BG.backdropTexture:SetVertexColor(DatatextInfo['Backdrop']['CustomColor_Backdrop']['r'], DatatextInfo['Backdrop']['CustomColor_Backdrop']['g'], DatatextInfo['Backdrop']['CustomColor_Backdrop']['b'])
					frame.BG.backdropTexture:SetAlpha(DatatextInfo['Backdrop']['CustomColor_Backdrop']['a'])
				end
				
				frame.BG:SetBackdropBorderColor(DatatextInfo['Backdrop']['CustomColor_Border']['r'], DatatextInfo['Backdrop']['CustomColor_Border']['g'], DatatextInfo['Backdrop']['CustomColor_Border']['b'])
			end
		else
			frame.BG:Hide()
		end
		
		-- Font
		if DatatextInfo['Font']['UseCustomFontStyle'] == false then
			frame.Datatext.text:FontTemplate(LSM:Fetch('font', DT.db.font), DT.db.fontSize, DT.db.fontOutline)
		else
			frame.Datatext.text:FontTemplate(LSM:Fetch('font', DatatextInfo['Font']['Font']), DatatextInfo['Font']['FontSize'], DatatextInfo['Font']['FontOutline'])
		end
		
		-- Display Mode
		KF:UnregisterCallback('SpecChanged', 'FloatingDatatext_'..frame.Count)
		KF:UnregisterCallback('CurrentAreaChanged', 'FloatingDatatext_'..frame.Count)
		
		
		local function RefreshDatatextByCallback()
			RefreshDatatext(datatextName, DatatextInfo)
		end
		
		if DatatextInfo['Display']['PvPMode'] ~= '' then
			KF:RegisterCallback('SpecChanged', RefreshDatatextByCallback, 'FloatingDatatext_'..frame.Count)
			KF:RegisterCallback('CurrentAreaChanged', RefreshDatatextByCallback, 'FloatingDatatext_'..frame.Count)
		elseif DatatextInfo['Display']['Mode'] == '0' then
			KF:RegisterCallback('SpecChanged', RefreshDatatextByCallback, 'FloatingDatatext_'..frame.Count)
		end
		
		RefreshDatatext(datatextName, DatatextInfo)
		
		
		-- Create Mover after frame locating
		if not frame.mover then
			if DatatextInfo['Location'] then
				frame:SetPoint(unpack({string.split('\031', DatatextInfo['Location'])}))
				--DatatextInfo['Location'] = nil
			else
				frame:Point('CENTER')
			end
			
			E:CreateMover(frame, 'KF_Datatext_'..frame.Count, DatatextInfo['Name'] or datatextName, nil, nil, nil, 'ALL,KF,KF_Datatext')
			
			if E:HasMoverBeenMoved(datatextName) then
				frame.mover:ClearAllPoints()
				frame.mover:SetPoint(unpack({string.split('\031', E.db['movers'][datatextName])}))
				E.CreatedMovers['KF_Datatext_'..frame.Count]['point'] = E.db['movers'][datatextName]
			end
		else
			-- Update Mover's Tag
			frame.mover.text:SetText(DatatextInfo['Name'] or datatextName)
		end
		
		
		-- Ignore Cursor
		if DatatextInfo['IgnoreCursor'] then
			frame.Datatext:EnableMouse(false)
		else
			frame.Datatext:EnableMouse(true)
		end
		
		
		if E.ConfigurationMode then
			frame.mover:Show()
		end
	end
	
	
	function KF:Delete_FloatingDatatext(datatextName, SaveProfile)
		local frame = KF.Datatext[datatextName]
		
		if frame then
			frame:Hide()
			
			frame.Datatext:UnregisterAllEvents()
			frame.Datatext:SetScript('OnEvent', nil)
			frame.Datatext:SetScript('OnUpdate', nil)
			frame.Datatext:SetScript('OnEnter', nil)
			frame.Datatext:SetScript('OnLeave', nil)
			frame.Datatext:SetScript('OnClick', nil)
			frame.Datatext.text:SetText(nil)
			
			frame.mover:Hide()
			
			local moverData = E.CreatedMovers[frame.mover.name]
			frame.MoverData = moverData
			E.CreatedMovers[frame.mover.name] = nil
			KF:UnregisterCallback('SpecChanged', 'FloatingDatatext_'..frame.Count)
			KF:UnregisterCallback('CurrentAreaChanged', 'FloatingDatatext_'..frame.Count)
			
			if SaveProfile then
				E:SaveMoverPosition(frame.mover.name)
				E.db['movers'][datatextName] = E.db['movers'][frame.mover.name]
			else
				E.db['movers'][datatextName] = nil
			end
			E.db['movers'][frame.mover.name] = nil
			
			DeletedDatatext[#DeletedDatatext + 1] = KF.Datatext[datatextName]
			KF.Datatext[datatextName] = nil
		end
	end
	
	
	KF:RegisterEventList('ADDON_LOADED', function(_, AddOnName)
		if AddOnName == 'ElvUI_Config' then
			hooksecurefunc(DT, 'LoadDataTexts', function()
				if frameCount == 0 then return end
				
				if Activate then
					for datatextName, IsDatatextData in pairs(KF.db.Modules.FloatingDatatext) do
						if type(IsDatatextData) == 'table' and KF.Datatext[datatextName] and IsDatatextData['Font']['UseCustomFontStyle'] == false then
							KF.Datatext[datatextName]['Datatext']['text']:FontTemplate(LSM:Fetch('font', DT.db.font), DT.db.fontSize, DT.db.fontOutline)
						end
					end
				end
			end)
			
			KF:UnregisterEventList('ADDON_LOADED', 'FloatingDatatext')
		end
	end, 'FloatingDatatext')
	
	
	--------------------------------------------------------------------------------
	--<< KnightFrame : Initialize Floating Datatext								>>--
	--------------------------------------------------------------------------------
	KF.Modules[#KF.Modules + 1] = 'FloatingDatatext'
	KF.Modules['FloatingDatatext'] = function(RemoveOrder)
		Activate = false
		
		-- Update Floating Datatext
		for datatextName in pairs(KF.Datatext) do
			KF:Delete_FloatingDatatext(datatextName, true)
		end
		
		if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.FloatingDatatext.Enable ~= false then
			Activate = true
			
			for datatextName, IsDatatextData in pairs(KF.db.Modules.FloatingDatatext) do
				if type(IsDatatextData) == 'table' then
					KF:Create_FloatingDatatext(datatextName)
				end
			end
		end
	end
end