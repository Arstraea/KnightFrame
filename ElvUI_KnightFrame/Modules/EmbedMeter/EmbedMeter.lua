local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Embed Meter												>>--
--------------------------------------------------------------------------------
local PANEL_HEIGHT = 22
local SPACING = E.PixelMode and 3 or 5

local SkadaLoaded = IsAddOnLoaded('Skada') or IsAddOnLoaded('SkadaU')
local RecoundLoaded = IsAddOnLoaded('Recount')
local OmenLoaded = IsAddOnLoaded('Omen')

local PanelLink = {}
local DeletedSlider = {}
local Omen_Embed


local function ClearSlider(key, deleteSplitRatio)
	if PanelLink[key].Slider then
		if deleteSplitRatio and KF.db.Modules.EmbedMeter.SplitRatio and KF.db.Modules.EmbedMeter.SplitRatio[key] then
			KF.db.Modules.EmbedMeter.SplitRatio[key] = nil
		end
		
		PanelLink[key].Slider:SetParent(nil)
		PanelLink[key].Slider:ClearAllPoints()
		PanelLink[key].Slider:Hide()
		
		DeletedSlider[#DeletedSlider + 1] = PanelLink[key].Slider
		PanelLink[key].Slider = nil
	end
end


if SkadaLoaded then
	local libwindow = LibStub('LibWindow-1.1')
	
	function KF:EmbedMeter_Skada_ChangedApplySettings(Window)
		libwindow.SavePosition_ = libwindow.SavePosition
		libwindow.SavePosition = function() end
		Window.display:ApplySettings(Window)
		libwindow.SavePosition = libwindow.SavePosition_
		libwindow.SavePosition_ = nil
	end
	
	function KF:EmbedMeter_EmbedSetting_Skada(HoldEmbeding)
		if not Info.EmbedMeter_Activate then return end
		
		local NeedUpdate
		
		for WindowNumber, Window in ipairs(Skada:GetWindows()) do
			local EmbedData = KF.db.Modules.EmbedMeter.Skada[WindowNumber]
			
			if EmbedData then
				NeedUpdate = true
				
				if KF:GetPanelData(EmbedData.Key) then
					PanelLink[EmbedData.Key] = PanelLink[EmbedData.Key] or {}
					PanelLink[EmbedData.Key][EmbedData.Direction or 'LEFT'] = { AddOn = 'Skada', Window = Window, WindowNumber = WindowNumber }
				else
					KF:EmbedMeter_ClearSetting_Skada(nil, WindowNumber)
				end
			else
				KF:EmbedMeter_ClearSetting_Skada(nil, WindowNumber)
			end
		end
		
		if NeedUpdate then
			if not HoldEmbeding then
				KF:EmbedMeter()
			else
				return true
			end
		end
	end
	
	local function ClearWindow(Window, WindowNumber, PreserveSetting)
		if Window.bargroup:GetParent() ~= UIParent then
			Window.bargroup:SetParent(UIParent)
			LibStub('LibWindow-1.1').RestorePosition(Window.bargroup)
			
			if PreserveSetting ~= 'SwitchProfile' then
				KF.db.Modules.EmbedMeter.Skada[WindowNumber] = nil
			end
		end
	end
	
	function KF:EmbedMeter_ClearSetting_Skada(PreserveSetting, WindowNumber)
		local windowTable = Skada:GetWindows()
		
		if WindowNumber then
			ClearWindow(windowTable[WindowNumber], WindowNumber, PreserveSetting)
		else
			for i, window in ipairs(windowTable) do
				ClearWindow(window, i, PreserveSetting)
			end
		end
	end
	
	hooksecurefunc(Skada, 'ApplySettings', function() if Info.EmbedMeter_Activate then KF:EmbedMeter_EmbedSetting_Skada() end end)
	hooksecurefunc(Skada, 'DeleteWindow', function() if Info.EmbedMeter_Activate then KF.Modules.EmbedMeter() end end)
end


if RecoundLoaded then
	function KF:EmbedMeter_EmbedSetting_Recount(HoldEmbeding)
		if not Info.EmbedMeter_Activate then return end
		
		if Recount.db.profile.KnightFrame_Embed then
			if KF:GetPanelData(Recount.db.profile.KnightFrame_Embed.Key) then
				PanelLink[Recount.db.profile.KnightFrame_Embed.Key] = PanelLink[Recount.db.profile.KnightFrame_Embed.Key] or {}
				PanelLink[Recount.db.profile.KnightFrame_Embed.Key][(Recount.db.profile.KnightFrame_Embed.Direction or 'LEFT')] = 'Recount'
				
				if not HoldEmbeding then
					KF:EmbedMeter()
				else
					return true
				end
			else
				KF:EmbedMeter_ClearSetting_Recount()
			end
		else
			KF:EmbedMeter_ClearSetting_Recount()
		end
	end
	
	function KF:EmbedMeter_ClearSetting_Recount(PreserveSetting)
		if Recount_MainWindow:GetParent() ~= UIParent and not Recount_MainWindow.isMoving then
			Recount_MainWindow:SetParent(UIParent)
			Recount_MainWindow:ClearAllPoints()
			Recount:RestoreMainWindowPosition(Recount.db.profile.MainWindow.Position.x, Recount.db.profile.MainWindow.Position.y, Recount.db.profile.MainWindow.Position.w, Recount.db.profile.MainWindow.Position.h)
			
			if PreserveSetting ~= 'SwitchProfile' then
				Recount.db.profile.KnightFrame_Embed = nil
			end
		end
	end
	
	Recount_MainWindow:HookScript('OnMouseDown', function(self)
		-- If user move recount then delete config
		if Info.EmbedMeter_Activate and Recount_MainWindow:GetParent() ~= UIParent and Recount.db.profile.KnightFrame_Embed then
			local mouseX, mouseY = GetCursorPosition()
			
			KF:RegisterTimer('EmbedMeter_CheckRecountMoving',  'NewTicker', .1, function()
				local New_mouseX, New_mouseY = GetCursorPosition()
					
				if mouseX ~= New_mouseX or mouseY ~= New_mouseY then
					KF:CancelTimer('EmbedMeter_CheckRecountMoving')
					Recount.db.profile.KnightFrame_Embed = nil
					
					if KF:EmbedMeter_CheckNeedEmbeding() then
						KF:EmbedMeter()
					end
				end
			end)
		end
	end)
	
	Recount_MainWindow:HookScript('OnMouseUp', function(self)
		KF:CancelTimer('EmbedMeter_CheckRecountMoving')
	end)
	
	hooksecurefunc(Recount_MainWindow, 'SaveMainWindowPosition', function(self)
		if Info.EmbedMeter_Activate and Recount_MainWindow:GetParent() ~= UIParent and Recount.db.profile.KnightFrame_Embed then
			self:SetParent(UIParent)
			Recount.db.profile.KnightFrame_Embed = nil
			
			if KF:EmbedMeter_CheckNeedEmbeding() then
				KF:EmbedMeter()
			end
		end
	end)
end


if OmenLoaded then
	function KF:EmbedMeter_EmbedSetting_Omen(HoldEmbeding)
		if not Info.EmbedMeter_Activate then return end
		
		if Omen.db.profile.KnightFrame_Embed then
			if KF:GetPanelData(Omen.db.profile.KnightFrame_Embed.Key) then
				PanelLink[(Omen.db.profile.KnightFrame_Embed.Key)] = PanelLink[(Omen.db.profile.KnightFrame_Embed.Key)] or {}
				PanelLink[(Omen.db.profile.KnightFrame_Embed.Key)][(Omen.db.profile.KnightFrame_Embed.Direction or 'LEFT')] = 'Omen'
			
				if not HoldEmbeding then
					KF:EmbedMeter()
				else
					return true
				end
			else
				KF:EmbedMeter_ClearSetting_Omen()
			end
		else
			KF:EmbedMeter_ClearSetting_Omen()
		end
	end
	
	function KF:EmbedMeter_ClearSetting_Omen(PreserveSetting)
		if Omen_Embed then
			KnightFrame_OmenEmbed:SetParent(nil)
			Omen_Embed = nil
			Omen:SetAnchors(true)
			
			if PreserveSetting ~= 'SwitchProfile' then
				Omen.db.profile.KnightFrame_Embed = nil
			end
		end
	end
	
	CreateFrame('Frame', 'KnightFrame_OmenEmbed')
	KnightFrame_OmenEmbed:SetScript('OnShow', function() if Omen_Embed then OmenAnchor:Show() end end)
	KnightFrame_OmenEmbed:SetScript('OnHide', function() if Omen_Embed then OmenAnchor:Hide() end end)
	
	hooksecurefunc(Omen, 'SetAnchors', function()
		if Omen_Embed and Omen.db.profile.KnightFrame_Embed then
			KnightFrame_OmenEmbed:SetParent(nil)
			Omen_Embed = nil
			Omen.db.profile.KnightFrame_Embed = nil
			
			if KF:EmbedMeter_CheckNeedEmbeding() then
				KF:EmbedMeter()
			end
		end
	end)
end


function KF:EmbedMeter()
	if not Info.EmbedMeter_Activate then return end
	
	for Key, Data in pairs(PanelLink) do
		local Direction
		local directionCount = 0
		
		if Data.LEFT then
			Direction = 'LEFT'
			directionCount = directionCount + 1
		end
		
		if Data.RIGHT then
			Direction = 'RIGHT'
			directionCount = directionCount + 1
		end
		
		local EmbedAddOn = Data[Direction].AddOn or Data[Direction]
		local Panel, panelType, panelTab, IsTabEnabled, panelDP, IsDPEnabled = KF:GetPanelData(Key)
		IsTabEnabled = panelTab:IsShown()
		IsDPEnabled = panelDP:IsShown()
		
		if directionCount == 1 and Panel then
			ClearSlider(Key, true)
			
			if EmbedAddOn == 'Skada' then
				local width, height
				
				if panelType == 'ElvUI' then
					width = E.db.chat.panelWidth - SPACING * 2 - 4
					height = E.db.chat.panelHeight - SPACING * 2 - (IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - (IsDPEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 4
				elseif panelType == 'KF' then
					width = KF.db.Modules.CustomPanel[Key].Width - SPACING * 2 - 4
					height = KF.db.Modules.CustomPanel[Key].Height - SPACING * 2 - (IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - (IsDPEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 4
				end
				
				if width and height then
					local window = Data[Direction].Window
					window.db.barwidth = width
					window.db.background.height = height - (window.db.enabletitle and window.db.title.height or 0)
					
					window:Show()
					
					window.db.barslocked = true -- Lock window
					
					window.bargroup:SetParent(Panel)
					window.bargroup:ClearAllPoints()
					window.bargroup:Point('TOPLEFT', Panel, SPACING + 2, -SPACING - 2 -(window.db.enabletitle and window.db.title.height or 0) -(IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0))
					KF:EmbedMeter_Skada_ChangedApplySettings(window)
					window:UpdateDisplay()
					
					window.bargroup.RegisterCallback(Skada.displays.bar, 'AnchorMoved', function(cbk, group, x, y)
						if Info.EmbedMeter_Activate and window.bargroup:GetParent() ~= UIParent and KF.db.Modules.EmbedMeter.Skada[Data[Direction].WindowNumber] then
							window.bargroup:SetParent(UIParent)
							KF.db.Modules.EmbedMeter.Skada[Data[Direction].WindowNumber] = nil
							
							if KF:EmbedMeter_CheckNeedEmbeding() then
								KF:EmbedMeter()
							end
						end
						
						LibStub('LibWindow-1.1').SavePosition(group)
					end)
					window.bargroup.RegisterCallback(Skada.displays.bar, 'WindowResized', function(cbk, group)
						if Info.EmbedMeter_Activate and window.bargroup:GetParent() ~= UIParent and KF.db.Modules.EmbedMeter.Skada[Data[Direction].WindowNumber] then
							window.bargroup:SetParent(UIParent)
							KF.db.Modules.EmbedMeter.Skada[Data[Direction].WindowNumber] = nil
							
							if KF:EmbedMeter_CheckNeedEmbeding() then
								KF:EmbedMeter()
							end
						end
						
						group.win.db.background.height = group:GetHeight()
						group.win.db.barwidth = group:GetWidth()
					end)
				end
			elseif EmbedAddOn == 'Recount' then
				Recount_MainWindow:Show()
				
				Recount.db.profile.Locked = true -- Lock window
				Recount:LockWindows(true)
				
				Recount_MainWindow:ClearAllPoints()
				Recount_MainWindow:SetParent(Panel)
				Recount.db.profile.Scaling = 1
				
				Recount_MainWindow:SetPoint('LEFT', Panel, SPACING, 0)
				Recount_MainWindow:SetPoint('RIGHT', Panel, -SPACING - 1, 0)
				if IsTabEnabled then
					Recount_MainWindow:SetPoint('TOP', panelTab, 'BOTTOM', 0, -SPACING + 10)
				else
					Recount_MainWindow:SetPoint('TOP', Panel, 0, -SPACING + 9)
				end
				
				if IsDPEnabled then
					Recount_MainWindow:SetPoint('BOTTOM', panelDP, 'TOP', 0, SPACING - 1)
				else
					Recount_MainWindow:SetPoint('BOTTOM', Panel, 0, SPACING)
				end
				
				Recount:ResizeMainWindow()
			elseif EmbedAddOn == 'Omen' then
				OmenAnchor:Show()
				
				Omen.db.profile.ShowWith.UseShowWith = false -- always show (Use Auto Show/Hide Config)
				Omen.db.profile.Locked = true -- Lock window
				Omen:UpdateGrips() -- Lock window
				
				OmenAnchor:ClearAllPoints()
				KnightFrame_OmenEmbed:SetParent(Panel)
				Omen_Embed = true
				
				OmenAnchor:SetPoint('LEFT', Panel, SPACING, 0)
				OmenAnchor:SetPoint('RIGHT', Panel, -SPACING, 0)
				if IsTabEnabled then
					OmenAnchor:SetPoint('TOP', panelTab, 'BOTTOM', 0, -SPACING + 1)
				else
					OmenAnchor:SetPoint('TOP', Panel, 0, -SPACING + 1)
				end
				
				if IsDPEnabled then
					OmenAnchor:SetPoint('BOTTOM', panelDP, 'TOP', 0, SPACING)
				else
					OmenAnchor:SetPoint('BOTTOM', Panel, 0, SPACING)
				end
			end
		elseif directionCount == 2 and Panel then
			local Slider = PanelLink[Key].Slider
			
			if not Slider then
				if #DeletedSlider > 0 then
					PanelLink[Key].Slider = DeletedSlider[#DeletedSlider]
					Slider = PanelLink[Key].Slider
					
					Slider:Show()
					
					DeletedSlider[#DeletedSlider] = nil
				else
					Slider = CreateFrame('Frame')
					Slider:SetMinResize(50, 100)
					
					Slider.Bar = CreateFrame('Frame', nil, Slider)
					Slider.Bar:SetTemplate('Default', true, true)
					Slider.Bar:SetWidth(1)
					Slider.Bar:Point('TOPRIGHT', Slider)
					Slider.Bar:Point('BOTTOMRIGHT', Slider)
					
					Slider.Sensor = CreateFrame('Button', nil, Slider)
					Slider.Sensor:SetWidth(1 + SPACING * 2)
					Slider.Sensor:Point('TOP', Slider.Bar, 0, SPACING)
					Slider.Sensor:Point('BOTTOM', Slider.Bar, 0, -SPACING)
					Slider.Sensor:SetScript('OnEnter', function() Slider.Bar:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
					Slider.Sensor:SetScript('OnLeave', function() Slider.Bar:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
					Slider.Sensor:SetScript('OnMouseUp', function(self)
						Slider:SetResizable(false)
						Slider:StopMovingOrSizing()
						Slider:SetScript('OnSizeChanged', nil)
					end)
					
					PanelLink[Key].Slider = Slider
				end
			end
			
			Slider:SetParent(Panel)
			Slider:SetMaxResize(Panel:GetWidth() - SPACING * 2 - 50, 600)
			Slider.Sensor:SetScript('OnMouseDown', function(self)
				Slider:SetResizable(true)
				Slider:StartSizing('RIGHT')
				Slider:SetScript('OnSizeChanged', function(self, width)
					KF.db.Modules.EmbedMeter.SplitRatio = KF.db.Modules.EmbedMeter.SplitRatio or {}
					KF.db.Modules.EmbedMeter.SplitRatio[Key] = tonumber(format('%.3f', width / (self:GetParent():GetWidth() - SPACING * 2)))
					
					KF:EmbedMeter()
				end)
			end)
			
			if IsTabEnabled then
				Slider:Point('TOP', panelTab, 'BOTTOM', 0, - SPACING * 2)
			else
				Slider:Point('TOP', Panel, 0, - SPACING * 2)
			end
			
			if IsDPEnabled then
				Slider:Point('BOTTOM', panelDP, 'TOP', 0, SPACING * 2)
			else
				Slider:Point('BOTTOM', Panel, 0, SPACING * 2)
			end
			
			Slider:Point('LEFT', Panel, SPACING, 0)
			
			if KF.db.Modules.EmbedMeter.SplitRatio and KF.db.Modules.EmbedMeter.SplitRatio[Key] then
				Slider:Point('RIGHT', Panel, 'LEFT', SPACING + KF.db.Modules.EmbedMeter.SplitRatio[Key] * (Panel:GetWidth() - SPACING * 2), 0)
			else
				Slider:Point('RIGHT', Panel, 'CENTER', 0, 0)
			end
			
			for _, Direction in pairs({ 'LEFT', 'RIGHT', }) do
				EmbedAddOn = type(Data[Direction]) == 'table' and Data[Direction].AddOn or Data[Direction]
				
				if EmbedAddOn == 'Skada' then
					local width, height
					
					width = Direction == 'LEFT' and Slider:GetWidth() - SPACING - 5 or Panel:GetWidth() - Slider:GetWidth() - SPACING * 3 - 4
					if panelType == 'ElvUI' then
						height = E.db.chat.panelHeight - SPACING * 2 - (IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - (IsDPEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 4
					elseif panelType == 'KF' then
						height = KF.db.Modules.CustomPanel[Key].Height - SPACING * 2 - (IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - (IsDPEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 4
					end
					
					if width and height then
						local window = Data[Direction].Window
						window.db.barwidth = width
						window.db.background.height = height - (window.db.enabletitle and window.db.title.height or 0)
						
						window:Show()
						
						window.db.barslocked = true -- Lock window
						
						window.bargroup:SetParent(Panel)
						window.bargroup:ClearAllPoints()
						window.bargroup:Point('TOP'..Direction, Panel, (Direction == 'LEFT' and 1 or -1) * (SPACING + 2), -SPACING -(window.db.enabletitle and window.db.title.height or 0) -(IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 2)
						KF:EmbedMeter_Skada_ChangedApplySettings(window)
						window:UpdateDisplay()
						
						window.bargroup.RegisterCallback(Skada.displays.bar, 'AnchorMoved', function(cbk, group, x, y)
							if Info.EmbedMeter_Activate and window.bargroup:GetParent() ~= UIParent and KF.db.Modules.EmbedMeter.Skada[Data[Direction].WindowNumber] then
								window.bargroup:SetParent(UIParent)
								KF.db.Modules.EmbedMeter.Skada[Data[Direction].WindowNumber] = nil
								
								if KF:EmbedMeter_CheckNeedEmbeding() then
									KF:EmbedMeter()
								end
							end
							
							LibStub('LibWindow-1.1').SavePosition(group)
						end)
						window.bargroup.RegisterCallback(Skada.displays.bar, 'WindowResized', function(cbk, group)
							if Info.EmbedMeter_Activate and window.bargroup:GetParent() ~= UIParent and KF.db.Modules.EmbedMeter.Skada[Data[Direction].WindowNumber] then
								window.bargroup:SetParent(UIParent)
								KF.db.Modules.EmbedMeter.Skada[Data[Direction].WindowNumber] = nil
								
								if KF:EmbedMeter_CheckNeedEmbeding() then
									KF:EmbedMeter()
								end
							end
							
							group.win.db.background.height = group:GetHeight()
							group.win.db.barwidth = group:GetWidth()
						end)
					end
				elseif EmbedAddOn == 'Recount' then
					Recount_MainWindow:Show()
				
					Recount.db.profile.Locked = true -- Lock window
					Recount:LockWindows(true)
					
					Recount_MainWindow:ClearAllPoints()
					Recount_MainWindow:SetParent(Panel)
					Recount.db.profile.Scaling = 1
					
					if Direction == 'LEFT' then
						Recount_MainWindow:SetPoint('LEFT', Panel, SPACING, 0)
						Recount_MainWindow:SetPoint('RIGHT', Slider, -SPACING - 1, 0)
					else
						Recount_MainWindow:SetPoint('LEFT', Slider, 'RIGHT', SPACING, 0)
						Recount_MainWindow:SetPoint('RIGHT', Panel, -SPACING, 0)
					end
					
					if IsTabEnabled then
						Recount_MainWindow:SetPoint('TOP', panelTab, 'BOTTOM', 0, -SPACING + 10)
					else
						Recount_MainWindow:SetPoint('TOP', Panel, 0, -SPACING + 9)
					end
					
					if IsDPEnabled then
						Recount_MainWindow:SetPoint('BOTTOM', panelDP, 'TOP', 0, SPACING - 1)
					else
						Recount_MainWindow:SetPoint('BOTTOM', Panel, 0, SPACING)
					end
					
					Recount:ResizeMainWindow()
				elseif EmbedAddOn == 'Omen' then
					OmenAnchor:Show()
					
					Omen.db.profile.ShowWith.UseShowWith = false -- always show (Use Auto Show/Hide Config)
					Omen.db.profile.Locked = true -- Lock window
					Omen:UpdateGrips() -- Lock window
					
					OmenAnchor:ClearAllPoints()
					KnightFrame_OmenEmbed:SetParent(Panel)
					Omen_Embed = true
					
					if Direction == 'LEFT' then
						OmenAnchor:SetPoint('LEFT', Panel, SPACING, 0)
						OmenAnchor:SetPoint('RIGHT', Slider, -SPACING - 1, 0)
					else
						OmenAnchor:SetPoint('LEFT', Slider, 'RIGHT', SPACING, 0)
						OmenAnchor:SetPoint('RIGHT', Panel, -SPACING, 0)
					end
					
					if IsTabEnabled then
						OmenAnchor:SetPoint('TOP', panelTab, 'BOTTOM', 0, -SPACING + 1)
					else
						OmenAnchor:SetPoint('TOP', Panel, 0, -SPACING + 1)
					end
					
					if IsDPEnabled then
						OmenAnchor:SetPoint('BOTTOM', panelDP, 'TOP', 0, SPACING - 1)
					else
						OmenAnchor:SetPoint('BOTTOM', Panel, 0, SPACING)
					end
				end
			end
		else
			ClearSlider(Key, true)
			
			PanelLink[Key] = nil
		end
	end
end


function KF:EmbedMeter_CheckNeedEmbeding()
	for Key, Data in pairs(PanelLink) do
		ClearSlider(Key)
	end
	PanelLink = {}
	
	if not Info.EmbedMeter_Activate then return end
	
	local NeedEmbeding
	
	if SkadaLoaded and KF:EmbedMeter_EmbedSetting_Skada(true) then
		Info.EmbedMeter_Activate.Skada = true
		NeedEmbeding = true
	end
	
	if RecoundLoaded and KF:EmbedMeter_EmbedSetting_Recount(true) then
		Info.EmbedMeter_Activate.Recount = true
		NeedEmbeding = true
	end
	
	if OmenLoaded and KF:EmbedMeter_EmbedSetting_Omen(true) then
		Info.EmbedMeter_Activate.Omen = true
		NeedEmbeding = true
	end
	
	return NeedEmbeding
end


function KF:EmbedMeter_ClearSettingByPanel(panelName, PreserveSetting)
	print(panelName, PreserveSetting)
	for Key in pairs(PanelLink) do
		print(Key, Key == panelName)
		if Key == panelName then
			for Direction in pairs(PanelLink[Key]) do
				if type(PanelLink[Key][Direction]) == 'table' and PanelLink[Key][Direction].AddOn == 'Skada' then
					KF:EmbedMeter_ClearSetting_Skada(PreserveSetting)
				elseif PanelLink[Key][Direction] == 'Recount' then
					KF:EmbedMeter_ClearSetting_Recount(PreserveSetting)
				elseif PanelLink[Key][Direction] == 'Omen' then
					KF:EmbedMeter_ClearSetting_Omen(PreserveSetting)
				end
			end
		end
	end
	
	if KF:EmbedMeter_CheckNeedEmbeding() then
		KF:EmbedMeter()
	end
end


KF.Modules[#KF.Modules + 1] = 'EmbedMeter'
KF.Modules.EmbedMeter = function(RemoveOrder)
	Info.EmbedMeter_Activate = nil
	
	if SkadaLoaded then
		KF:EmbedMeter_ClearSetting_Skada(RemoveOrder)
	end
	
	if RecoundLoaded then
		KF:EmbedMeter_ClearSetting_Recount(RemoveOrder)
	end
	
	if OmenLoaded then
		KF:EmbedMeter_ClearSetting_Omen(RemoveOrder)
	end
	
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.EmbedMeter.Enable ~= false then
		Info.EmbedMeter_Activate = {}
		
		if KF:EmbedMeter_CheckNeedEmbeding() then
			KF:EmbedMeter()
		end
	end
end