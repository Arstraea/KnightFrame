local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Embed Meter												>>--
--------------------------------------------------------------------------------
local PANEL_HEIGHT = 22
local SPACING = E.PixelMode and 3 or 5

local SkadaLoaded = IsAddOnLoaded('Skada') or IsAddOnLoaded('SkadaU')
local RecoundLoaded = IsAddOnLoaded('Recount')
local OmenLoaded = IsAddOnLoaded('Omen')

local PanelLink = {}
local DeletedDivider = {}
local Omen_Embed


local function ClearDivider(key, deleteSplitRatio)
	if PanelLink[key].Divider then
		if deleteSplitRatio and DB.Modules.EmbedMeter.SplitRatio and DB.Modules.EmbedMeter.SplitRatio[key] then
			DB.Modules.EmbedMeter.SplitRatio[key] = nil
		end
		
		PanelLink[key].Divider:SetParent(nil)
		PanelLink[key].Divider:ClearAllPoints()
		PanelLink[key].Divider:Hide()
		
		DeletedDivider[#DeletedDivider + 1] = PanelLink[key].Divider
		PanelLink[key].Divider = nil
	end
end




if SkadaLoaded then
	local libwindow = LibStub('LibWindow-1.1')
	
	function KF:EmbedMeter_Skada_ChangedApplySettings(window)
		libwindow.SavePosition_ = libwindow.SavePosition
		libwindow.SavePosition = function() end
		window.display:ApplySettings(window)
		libwindow.SavePosition = libwindow.SavePosition_
		libwindow.SavePosition_ = nil
	end
	
	function KF:EmbedMeter_EmbedSetting_Skada(HoldEmbeding)
		if not Info.EmbedMeter_Activate then return end
		
		local needUpdate
		
		for i, window in ipairs(Skada:GetWindows()) do
			local embedData = window.db.KnightFrame_Embed
			
			if embedData then
				needUpdate = true
				
				if KF:GetPanelData(embedData.Key) then
					PanelLink[(embedData.Key)] = PanelLink[(embedData.Key)] or {}
					PanelLink[(embedData.Key)][(embedData.Direction or 'LEFT')] = { AddOn = 'Skada', Window = window, }
				else
					KF:EmbedMeter_ClearSetting_Skada(nil, i)
				end
			else
				KF:EmbedMeter_ClearSetting_Skada(nil, i)
			end
		end
		
		if needUpdate then
			if not HoldEmbeding then
				KF:EmbedMeter()
			else
				return true
			end
		end
	end
	
	local function ClearWindow(Window, PreserveSetting)
		if Window.bargroup:GetParent() ~= UIParent then
			Window.bargroup:SetParent(UIParent)
			LibStub('LibWindow-1.1').RestorePosition(Window.bargroup)
			
			if PreserveSetting ~= 'SwitchProfile' then
				Window.db.KnightFrame_Embed = nil
			end
		end
	end
	
	function KF:EmbedMeter_ClearSetting_Skada(PreserveSetting, WindowNumber)
		local windowTable = Skada:GetWindows()
		
		if WindowNumber then
			ClearWindow(windowTable[WindowNumber], PreserveSetting)
		else
			for i, window in ipairs(windowTable) do
				ClearWindow(window, PreserveSetting)
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
			
			Timer.EmbedMeter_CheckRecountMoving:Cancel()
			Timer.EmbedMeter_CheckRecountMoving = C_Timer.NewTicker(.1, function()
				local New_mouseX, New_mouseY = GetCursorPosition()
					
				if mouseX ~= New_mouseX or mouseY ~= New_mouseY then
					Timer.EmbedMeter_CheckRecountMoving:Cancel()
					Recount.db.profile.KnightFrame_Embed = nil
					
					if KF:EmbedMeter_CheckNeedEmbeding() then
						KF:EmbedMeter()
					end
				end
			end)
		end
	end)
	
	Recount_MainWindow:HookScript('OnMouseUp', function(self)
		Timer.EmbedMeter_CheckRecountMoving:Cancel()
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
			ClearDivider(Key, true)
			
			if EmbedAddOn == 'Skada' then
				local width, height
				
				if panelType == 'ElvUI' then
					width = E.db.chat.panelWidth - SPACING * 2 - 4
					height = E.db.chat.panelHeight - SPACING * 2 - (IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - (IsDPEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 4
				elseif panelType == 'KF' then
					width = DB.Modules.CustomPanel[Key].Width - SPACING * 2 - 4
					height = DB.Modules.CustomPanel[Key].Height - SPACING * 2 - (IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - (IsDPEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 4
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
						if window.bargroup:GetParent() ~= UIParent and window.db.KnightFrame_Embed then
							window.bargroup:SetParent(UIParent)
							window.db.KnightFrame_Embed = nil
							
							if KF:EmbedMeter_CheckNeedEmbeding() then
								KF:EmbedMeter()
							end
						end
						
						LibStub('LibWindow-1.1').SavePosition(group)
					end)
					window.bargroup.RegisterCallback(Skada.displays.bar, 'WindowResized', function(cbk, group)
						if window.bargroup:GetParent() ~= UIParent and window.db.KnightFrame_Embed then
							window.bargroup:SetParent(UIParent)
							window.db.KnightFrame_Embed = nil
							
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
			local divider = PanelLink[Key].Divider
			
			if not divider then
				if #DeletedDivider > 0 then
					PanelLink[Key].Divider = DeletedDivider[#DeletedDivider]
					divider = PanelLink[Key].Divider
					
					divider:Show()
					
					DeletedDivider[#DeletedDivider] = nil
				else
					local f = CreateFrame('Frame')
					f:SetMinResize(50, 100)
					
					f.Bar = CreateFrame('Frame', nil, f)
					f.Bar:SetTemplate('Default', true, true)
					f.Bar:SetWidth(1)
					f.Bar:Point('TOPRIGHT', f)
					f.Bar:Point('BOTTOMRIGHT', f)
					
					f.Sensor = CreateFrame('Button', nil, f)
					f.Sensor:SetWidth(1 + SPACING * 2)
					f.Sensor:Point('TOP', f.Bar, 0, SPACING)
					f.Sensor:Point('BOTTOM', f.Bar, 0, -SPACING)
					f.Sensor:SetScript('OnEnter', function() f.Bar:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
					f.Sensor:SetScript('OnLeave', function() f.Bar:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
					f.Sensor:SetScript('OnMouseUp', function(self)
						f:SetResizable(false)
						f:StopMovingOrSizing()
						f:SetScript('OnSizeChanged', nil)
					end)
					
					PanelLink[Key].Divider = f
					divider = PanelLink[Key].Divider
				end
			end
			
			divider:SetParent(Panel)
			divider:SetMaxResize(Panel:GetWidth() - SPACING * 2 - 50, 600)
			divider.Sensor:SetScript('OnMouseDown', function(self)
				divider:SetResizable(true)
				divider:StartSizing('RIGHT')
				divider:SetScript('OnSizeChanged', function(self, width)
					DB.Modules.EmbedMeter.SplitRatio = DB.Modules.EmbedMeter.SplitRatio or {}
					DB.Modules.EmbedMeter.SplitRatio[Key] = tonumber(format('%.3f', width / (self:GetParent():GetWidth() - SPACING * 2)))
					
					KF:EmbedMeter()
				end)
			end)
			
			if IsTabEnabled then
				divider:Point('TOP', panelTab, 'BOTTOM', 0, - SPACING * 2)
			else
				divider:Point('TOP', Panel, 0, - SPACING * 2)
			end
			
			if IsDPEnabled then
				divider:Point('BOTTOM', panelDP, 'TOP', 0, SPACING * 2)
			else
				divider:Point('BOTTOM', Panel, 0, SPACING * 2)
			end
			
			divider:Point('LEFT', Panel, SPACING, 0)
			
			if DB.Modules.EmbedMeter.SplitRatio and DB.Modules.EmbedMeter.SplitRatio[Key] then
				divider:Point('RIGHT', Panel, 'LEFT', SPACING + DB.Modules.EmbedMeter.SplitRatio[Key] * (Panel:GetWidth() - SPACING * 2), 0)
			else
				divider:Point('RIGHT', Panel, 'CENTER', 0, 0)
			end
			
			for _, Direction in pairs({ 'LEFT', 'RIGHT', }) do
				EmbedAddOn = type(Data[Direction]) == 'table' and Data[Direction].AddOn or Data[Direction]
				
				if EmbedAddOn == 'Skada' then
					local width, height
					
					width = Direction == 'LEFT' and divider:GetWidth() - SPACING - 5 or Panel:GetWidth() - divider:GetWidth() - SPACING * 3 - 4
					if panelType == 'ElvUI' then
						height = E.db.chat.panelHeight - SPACING * 2 - (IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - (IsDPEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 4
					elseif panelType == 'KF' then
						height = DB.Modules.CustomPanel[Key].Height - SPACING * 2 - (IsTabEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - (IsDPEnabled and PANEL_HEIGHT + SPACING - (E.PixelMode and 1 or 0) or 0) - 4
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
							if Info.EmbedMeter_Activate and window.bargroup:GetParent() ~= UIParent and window.db.KnightFrame_Embed then
								window.bargroup:SetParent(UIParent)
								window.db.KnightFrame_Embed = nil
								
								if KF:EmbedMeter_CheckNeedEmbeding() then
									KF:EmbedMeter()
								end
							end
							
							LibStub('LibWindow-1.1').SavePosition(group)
						end)
						window.bargroup.RegisterCallback(Skada.displays.bar, 'WindowResized', function(cbk, group)
							if Info.EmbedMeter_Activate and window.bargroup:GetParent() ~= UIParent and window.db.KnightFrame_Embed then
								window.bargroup:SetParent(UIParent)
								window.db.KnightFrame_Embed = nil
								
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
						Recount_MainWindow:SetPoint('RIGHT', divider, -SPACING - 1, 0)
					else
						Recount_MainWindow:SetPoint('LEFT', divider, 'RIGHT', SPACING, 0)
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
						OmenAnchor:SetPoint('RIGHT', divider, -SPACING - 1, 0)
					else
						OmenAnchor:SetPoint('LEFT', divider, 'RIGHT', SPACING, 0)
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
			ClearDivider(Key, true)
			
			PanelLink[Key] = nil
		end
	end
end


function KF:EmbedMeter_CheckNeedEmbeding()
	for Key, Data in pairs(PanelLink) do
		ClearDivider(Key)
	end
	PanelLink = {}
	
	local needEmbed
	
	if SkadaLoaded then
		needEmbed = KF:EmbedMeter_EmbedSetting_Skada(true)
	end
	
	if RecoundLoaded then
		needEmbed = KF:EmbedMeter_EmbedSetting_Recount(true) or needEmbed
	end
	
	if OmenLoaded then
		needEmbed = KF:EmbedMeter_EmbedSetting_Omen(true) or needEmbed
	end
	
	return Info.EmbedMeter_Activate and needEmbed
end


function KF:EmbedMeter_ClearSettingByPanel(panelName, PreserveSetting)
	for Key in pairs(PanelLink) do
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
	
	KF.Modules.EmbedMeter()
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
	
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.EmbedMeter.Enable ~= false then
		Info.EmbedMeter_Activate = true
		
		if KF:EmbedMeter_CheckNeedEmbeding() then
			KF:EmbedMeter()
		end
	end
end