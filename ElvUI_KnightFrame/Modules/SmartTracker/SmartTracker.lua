local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

local WindowCount = 1
local WindowTag = 'KF_SmartTracker'

--------------------------------------------------------------------------------
--<< KnightFrame : Smart Tracker											>>--
--------------------------------------------------------------------------------
local ST = _G['KF_SmartTracker'] or CreateFrame('Frame', 'KF_SmartTracker', KF.UIParent)
ST.DeletedWindow = {}
ST.DeletedBar = {}
ST.InspectCache = {}
ST.CooldownCache = {}
ST.TAB_HEIGHT = 22
ST.FADE_TIME = .4

KF.UIParent.Window = {}
KF.UIParent.MoverType.KF_SmartTracker = L['Smart Tracker']


do	--<< About Window's Layout and Appearance >>--
	function ST:OnSizeChanged()
		DB.Modules.SmartTracker.Window[self.Name].Area_Width = tonumber(E:Round(self:GetWidth()))
		DB.Modules.SmartTracker.Window[self.Name].Area_Height = tonumber(E:Round(self:GetHeight()))
		
		ST:Window_Size(self)
		
		--KF:RaidCooldown_RefreshCooldownBarData()
	end
	
	
	function ST:DisplayArea_OnMouseWheel(Spinning)
		--마우스 휠을 위로 굴리면 spining 에 1값 리턴, 아래로 굴리면 spining 에 -1값 리턴
		local Window = self:GetParent()
		
		if DB.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 'UP' then
			if spining == 1 and Window.BarRemains then
				Window.CurrentWheelLine = Window.CurrentWheelLine + 1
			elseif spining == -1 and Window.CurrentWheelLine > 0 then
				Window.CurrentWheelLine = Window.CurrentWheelLine - 1
			end
		else
			if spining == -1 and Window.BarRemains then
				Window.CurrentWheelLine = Window.CurrentWheelLine + 1
			elseif spining == 1 and Window.CurrentWheelLine > 0 then
				Window.CurrentWheelLine = Window.CurrentWheelLine - 1
			end
		end
		--KF:RaidCooldown_RefreshCooldownBarData()
	end
	
	
	function ST:Tab_OnMouseUp()
		local Window = self:GetParent()
		
		if Window.DisplayArea:GetAlpha() > 0 then
			Window:StopMovingOrSizing()
			local point, _, secondaryPoint, x, y = Window:GetPoint()
			Window.mover:ClearAllPoints()
			Window.mover:Point(point, E.UIParent, secondaryPoint, x, y)
			E:SaveMoverPosition(Window.mover.name)
			Window:ClearAllPoints()
			Window:SetPoint(point, Window.mover, 0, 0)
		end
	end
	
	
	function ST:Tab_OnMouseDown()
		local Window = self:GetParent()
		
		if Window.DisplayArea:GetAlpha() > 0 then
			Window:StartMoving()
		end
	end
	
	
	function ST:ResizeGrip_OnEnter()
		self.texture:SetTexture('Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Highlight')
	end
	
	
	function ST:ResizeGrip_OnLeave()
		self.texture:SetTexture('Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Up')
	end
	
	
	function ST:ResizeGrip_OnMouseUp()
		local Window = self:GetParent():GetParent()
		
		if Window.DisplayArea:GetAlpha() > 0 then
			Window:StopMovingOrSizing()
			Window:SetResizable(false)
			
			Window:ClearAllPoints()
			if DB.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 'UP' then
				Window:Point('BOTTOMLEFT', Window.mover)
			else
				Window:Point('TOPLEFT', Window.mover)
			end
			
			E:SaveMoverPosition(Window.mover.name)
		end

	end
	
	
	function ST:ResizeGrip_OnMouseDown()
		local Window = self:GetParent():GetParent()
		
		if Window.DisplayArea:GetAlpha() > 0 then
			Window:SetResizable(true)
			local x, y = Window.mover:GetLeft(), Window.mover:GetBottom()
			
			Window.mover:ClearAllPoints()
			if DB.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 'UP' then
				Window.mover:Point('BOTTOMLEFT', E.UIParent, x, y)
				Window:StartSizing('TOPRIGHT')
			else
				y = -(E.UIParent:GetTop() - Window.mover:GetTop())
				Window.mover:Point('TOPLEFT', E.UIParent, x, y)
				Window:StartSizing('BOTTOMRIGHT')
			end
		end
	end
	
	
	function ST:Window_Setup(Window, Count)
		Window.Count = Count
		
		Window:SetMovable(true)
		Window:SetClampedToScreen(true)
		
		Window.DisplayArea = CreateFrame('Frame', nil, Window)
		Window.DisplayArea:SetFrameLevel(2)
		Window.DisplayArea:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Window.DisplayArea:SetBackdropColor(1, 1, 1, .1)
		Window.DisplayArea:SetBackdropBorderColor(unpack(E.media.bordercolor))
		Window.DisplayArea:EnableMouseWheel()
		Window.DisplayArea:SetScript('OnMouseWheel', self.DisplayArea_OnMouseWheel)
		KF:TextSetting(Window.DisplayArea, nil, { FontSize = 11, directionH = 'RIGHT' })
		
		Window.Tab = CreateFrame('Frame', nil, Window)
		Window.Tab:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Window.Tab:SetBackdropBorderColor(unpack(E.media.bordercolor))
		Window.Tab:SetFrameLevel(3)
		Window.Tab:Height(ST.TAB_HEIGHT - 2)
		KF:TextSetting(Window.Tab, nil, { FontSize = 10, FontOutline = 'OUTLINE', directionH = 'LEFT' }, 'LEFT', 4, 0)
		Window.Tab:SetScript('OnMouseUp', self.Tab_OnMouseUp)
		Window.Tab:SetScript('OnMouseDown', self.Tab_OnMouseDown)
		
		Window.ResizeGrip = CreateFrame('Frame', nil, Window.DisplayArea)
		Window.ResizeGrip:Size(16)
		Window.ResizeGrip:SetFrameStrata('HIGH')
		Window.ResizeGrip.texture = Window.ResizeGrip:CreateTexture(nil, 'OVERLAY')
		Window.ResizeGrip.texture:SetInside()
		Window.ResizeGrip.texture:SetTexture('Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Up')
		Window.ResizeGrip:SetScript('OnEnter', self.ResizeGrip_OnEnter)
		Window.ResizeGrip:SetScript('OnLeave', self.ResizeGrip_OnLeave)
		Window.ResizeGrip:SetScript('OnMouseUp', self.ResizeGrip_OnMouseUp)
		Window.ResizeGrip:SetScript('OnMouseDown', self.ResizeGrip_OnMouseDown)
		
		return Window
	end


	function ST:ToggleDisplay(Window)
		if Window.DisplayArea:GetAlpha() > 0 then
			Window.DisplayArea:SetAlpha(0)
			DB.Modules.SmartTracker.Window[Window.Name].DisplayArea = false
			print(L['KF']..' : '..L['Lock Display Area.'])
		else
			Window.DisplayArea:SetAlpha(1)
			DB.Modules.SmartTracker.Window[Window.Name].DisplayArea = true
			print(L['KF']..' : '..L['Unlock Display Area.'])
		end
	end


	function ST:Window_Create(WindowName)
		if not DB.Modules.SmartTracker.Enable or DB.Modules.SmartTracker.Window[WindowName].Enable == false then
			self:Window_Delete(WindowName, true)
			return
		end
		
		local Window = KF.UIParent.Window[WindowName]
		
		if not Window then
			if #self.DeletedWindow > 0 then
				KF.UIParent.Window[WindowName] = self.DeletedWindow[#self.DeletedWindow]
				
				Window = KF.UIParent.Window[WindowName]
				
				E.CreatedMovers[Window.mover.name] = Window.MoverData
				Window.MoverData = nil
				E.CreatedMovers[Window.mover.name].point = E:HasMoverBeenMoved(WindowName) and E.db.movers[WindowName] or DB.Modules.SmartTracker.Window[WindowName].Location or 'CENTERElvUIParent'
				
				Window.mover:ClearAllPoints()
				Window.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Window.mover.name].point)}))
				
				Window:Show()
				
				self.DeletedWindow[#self.DeletedWindow] = nil
			else
				WindowCount = WindowCount + 1
				
				KF.UIParent.Window[WindowName] = self:Window_Setup(CreateFrame('Frame', WindowTag..'_'..WindowCount, KF.UIParent), WindowCount)
				
				Window = KF.UIParent.Window[WindowName]
				
				if DB.Modules.SmartTracker.Window[WindowName].Location then
					Window:SetPoint(unpack({string.split('\031', DB.Modules.SmartTracker.Window[WindowName].Location)}))
					--DB.Modules.SmartTracker.Window[WindowName].Location = nil
				else
					Window:Point('CENTER')
				end
				
				E:CreateMover(Window, WindowTag..'_'..Window.Count..'_Mover', nil, nil, nil, nil, 'ALL,KF,KF_SmartTracker')
				Window:SetScript('OnSizeChanged', self.OnSizeChanged)
				
				if E:HasMoverBeenMoved(WindowName) then
					Window.mover:ClearAllPoints()
					Window.mover:SetPoint(unpack({string.split('\031', E.db.movers[WindowName])}))
					E.CreatedMovers[WindowTag..'_'..Window.Count..'_Mover'].point = E.db.movers[WindowName]
				end
			end
			
			--초기화 여기서
			Window.Name = WindowName
			Window.CurrentWheelLine = 0
			Window.ContainedBar = {}
			Window.mover.text:SetText(L['WindowTag']..'|n'..WindowName)
		end
		
		-- Setting
		self:Window_Size(Window)
		self:Window_ChangeBarGrowDirection(Window)
		
		-- Colorize
		Window.Tab:SetBackdropColor(unpack(DB.Modules.SmartTracker.Window[WindowName].Color_WindowTab))
		
		
		--Window.Tab.text:SetText('|cff2eb7e4'..Default['MainFrame_Tab_AddOnName']) 탭에 표시할 제목
		
		
		if E.ConfigurationMode then
			Window.mover:Show()
		end
	end


	function ST:Window_Size(Window)
		local MinimumHeight = (DB.Modules.SmartTracker.Window[Window.Name].Bar_Height - 1) * 5 + ST.TAB_HEIGHT
		
		if DB.Modules.SmartTracker.Window[Window.Name].Area_Height < MinimumHeight then
			DB.Modules.SmartTracker.Window[Window.Name].Area_Height = MinimumHeight
		end
		
		Window:SetMinResize(200, MinimumHeight)
		Window:SetMaxResize(floor(UIParent:GetWidth() / 2), floor(UIParent:GetHeight() * 2/3))
		Window:Size(DB.Modules.SmartTracker.Window[Window.Name].Area_Width, DB.Modules.SmartTracker.Window[Window.Name].Area_Height)
		Window.mover:Size(DB.Modules.SmartTracker.Window[Window.Name].Area_Width, DB.Modules.SmartTracker.Window[Window.Name].Area_Height)
		Window.DisplayArea.text:SetText(L['Enable to display']..' : |cff2eb7e4'..floor((DB.Modules.SmartTracker.Window[Window.Name].Area_Height - ST.TAB_HEIGHT) / (DB.Modules.SmartTracker.Window[Window.Name].Bar_Height - 1)))
	end


	function ST:Window_ChangeBarGrowDirection(Window)
		Window.Tab:ClearAllPoints()
		Window.Tab:Point('LEFT', Window)
		Window.Tab:Point('RIGHT', Window)
		
		Window.ResizeGrip:ClearAllPoints()
		Window.DisplayArea.text:ClearAllPoints()
		if DB.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 'UP' then -- 1 : Up / 2 : Down
			Window.Tab:Point('BOTTOM', Window)
			Window.DisplayArea:Point('TOPLEFT', Window)
			Window.DisplayArea:Point('BOTTOMRIGHT', Window.Tab, 'TOPRIGHT', 0, -1)
			Window.DisplayArea.text:Point('TOPRIGHT', Window.ResizeGrip, 'TOPLEFT', -2, -4)
			Window.ResizeGrip:Point('TOPRIGHT', Window.DisplayArea)
			Window.ResizeGrip.texture:SetTexCoord(0, .95, .9, 0)
		else
			Window.Tab:Point('TOP', Window)
			Window.DisplayArea:Point('TOPLEFT', Window.Tab, 'BOTTOMLEFT', 0, 1)
			Window.DisplayArea:Point('BOTTOMRIGHT', Window)
			Window.DisplayArea.text:Point('BOTTOMRIGHT', Window.ResizeGrip, 'BOTTOMLEFT', -2, 4)
			Window.ResizeGrip:Point('BOTTOMRIGHT', Window.DisplayArea)
			Window.ResizeGrip.texture:SetTexCoord(0, .95, 0, .9)
		end
	end


	function ST:Window_Delete(WindowName, SaveProfile)
		local Window = KF.UIParent.Window[WindowName]
		
		if Window then
			
		end
	end


	function ST:Setup_MainWindow()
		KF.UIParent.Window[1] = self:Window_Setup(self, 1)
		
		if DB.Modules.SmartTracker.Window[1].Location then
			self:SetPoint(unpack({string.split('\031', DB.Modules.SmartTracker.Window[1].Location)}))
			--DB.Modules.SmartTracker.Window[1].Location = nil
		else
			self:Point('CENTER')
		end
		
		E:CreateMover(self, 'SmartTracker_MainWindow', L['WindowTag']..'|n'..L['SmartTracker_MainWindow'], nil, nil, nil, 'ALL,KF,KF_SmartTracker')
		self:SetScript('OnSizeChanged', self.OnSizeChanged)
		
		if E:HasMoverBeenMoved('SmartTracker_MainWindow') then
			self.mover:ClearAllPoints()
			self.mover:SetPoint(unpack({string.split('\031', E.db.movers.SmartTracker_MainWindow)}))
			E.CreatedMovers.SmartTracker_MainWindow.point = E.db.movers.SmartTracker_MainWindow
		end
		
		self.Name = 1
		self.CurrentWheelLine = 0
		
		self.Setup_MainWindow = nil
	end
end


do	--<< About Bar's Layout and Appearance >>--
	--[[
	Bar.SpellIconFrame:SetScript('OnEnter', function(self)
		if Table['Cooldown_BarList'][BarNumber]['Data']['FrameType'] == 'NamePlate' or not Table['Cooldown_BarList'][BarNumber]['Data'] then return end
		
		self:SetScript('OnUpdate', function()
			if Table['Cooldown_BarList'][BarNumber]['Data']['FrameType'] ~= 'NamePlate' and Table['Cooldown_BarList'][BarNumber].Data.SpellID then
				if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then -- 1 : Up / 2 : Down
					GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
				else
					GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
				end
				GameTooltip:ClearLines()
				
				if KF.db.Modules.SmartTracker.General.ShowDetailTooltip == true or IsShiftKeyDown() then
					GameTooltip:SetHyperlink(GetSpellLink(Table['Cooldown_BarList'][BarNumber].Data.SpellID))
					GameTooltip:AddLine('|n')
				else
					GameTooltip:AddLine(GetSpellInfo(Table['Cooldown_BarList'][BarNumber].Data.SpellID))
				end
				GameTooltip:AddDoubleLine(' - |cff2eb7e4'..L['RightClick'], L['Remove this cooltime bar.'], 1, 1, 1, 1, 1, 1)
				GameTooltip:AddDoubleLine(' - Shift + |cff2eb7e4'..L['RightClick'], L['Clear this spell config to forbid displaying.'], 1, 1, 1, 1, 1, 1)
				GameTooltip:Show()
			end
		end)
		self:SetScript('OnClick', function(_, button)
			if button ~= 'RightButton' or Table['Cooldown_BarList'][BarNumber]['Data']['FrameType'] == 'NamePlate' then
				return
			else
				GameTooltip:Hide()
				if IsShiftKeyDown() then
					KF.db.Modules.SmartTracker[ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID.Class][Table['Cooldown_BarList'][BarNumber].Data.SpellID] = 0
					KF:RaidCooldown_RefreshCooldownBarData()
				elseif not ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID].Fade or ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID].Fade['FadeType'] == 'IN' then
					if ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID]['Chargy'] then
						ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID]['ActivateTime'] = 0
					else
						ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID].Fade = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, }
					end
				end
			end
		end)
		self:SetScript('OnLeave', function() self:SetScript('OnUpdate', nil) self:SetScript('OnClick', nil) GameTooltip:Hide() end)
	end)
	]]
	
	function ST:Bar_OnUpdate(elapsed)
		local UserGUID = self.Data.GUID
		
		if self.Data.FrameType == 'NamePlate' then
			if not self.Data.SettingComplete then
				self:SetAlpha(1)
				self:SetBackdropColor(0, 0, 0, 0)
				self:SetBackdropBorderColor(0, 0, 0, 0)
				self.SpellIconFrame:SetBackdropBorderColor(0, 0, 0, 0)
				self.CooldownBar:SetStatusBarColor(0, 0, 0, 0)
				self.SpellIcon:SetTexture(nil)
				self.Time:SetText(nil)
				
				self.Data.SettingComplete = true
			end
			
			if ST.InspectCache[UserGUID] then
				ST.CooldownCache[UserGUID].Spec = ST.InspectCache[UserGUID].Spec
				
				self:SetScript('OnUpdate', nil)
			end
			
			self.Text:SetText('|TInterface\\AddOns\\ElvUI\\media\\textures\\arrow:10:10:-4:-1:64:64:0:64:0:64:206:255:0|t'..KF:Color_Class(ST.CooldownCache[UserGUID].Class, ST.CooldownCache[UserGUID].Name)..ST:GetUserRoleIcon(UserGUID))
		elseif self.Data.FrameType == 'CooldownBar' then
			local Bar_Color = RAID_CLASS_COLORS[ST.CooldownCache[UserGUID].Class]
			local SpellID = tonumber(self.Data.SpellID)
			local TimeNow = GetTime()
			local RemainCooltime = ST.CooldownCache[UserGUID].List[SpellID].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID].Cooltime - TimeNow
			
			if not self.Data.SettingComplete then
				local SpellName, _, SpellIcon = GetSpellInfo(SpellID)
				self.SpellIcon:SetTexture(SpellIcon)
				self:SetBackdropBorderColor(unpack(E.media.bordercolor))
				self.SpellIconFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))
				
				if ST.CooldownCache[UserGUID].List[SpellID].Charge then
					self:SetBackdropColor(Bar_Color.r, Bar_Color.g, Bar_Color.b)
					self.CooldownBar:SetStatusBarColor(unpack(DB.Modules.SmartTracker.Window[WindowName].Color_Charged))
					
					if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Target then
						self.Text:SetText(SpellName..' (2) |cffceff00▶|r '..ST.CooldownCache[UserGUID].List[SpellID].DestColor..ST.CooldownCache[UserGUID].List[SpellID].DestName..(ST.CooldownCache[UserGUID].List[SpellID].DestName == ST.CooldownCache[UserGUID].List[SpellID].DestName2 and '|r x '..ST.CooldownCache[UserGUID].List[SpellID].DestColor..'2|r' or '|r, '..ST.CooldownCache[UserGUID].List[SpellID].DestColor2..ST.CooldownCache[UserGUID].List[SpellID].DestName2))
					else
						self.Text:SetText(SpellName..' (2)')
					end
				else
					self:SetBackdropColor(unpack(DB.Modules.SmartTracker.Window[WindowName].Color_BehindBar))
					self.CooldownBar:SetStatusBarColor(Bar_Color.r, Bar_Color.g, Bar_Color.b)
					
					if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Target then
						self.Text:SetText(spellName..' |cffceff00▶|r '..ST.CooldownCache[UserGUID].List[SpellID].DestColor..ST.CooldownCache[UserGUID].List[SpellID].DestName..'|r')
					else
						self.Text:SetText(spellName)
					end
				end
				
				self.Data.SettingComplete = true
			end
			
			if ST.CooldownCache[UserGUID].List[SpellID].Fade then
				ST.CooldownCache[UserGUID].List[SpellID].Fade.FadeTimer = (ST.CooldownCache[UserGUID].List[SpellID].Fade.FadeTimer or 0) + elapsed
				
				if ST.CooldownCache[UserGUID].List[SpellID].Fade.FadeTimer < ST.FADE_TIME then
					if ST.CooldownCache[UserGUID].List[SpellID].Fade.FadeType == 'IN' then
						self:SetAlpha(ST.CooldownCache[UserGUID].List[SpellID].Fade.FadeTimer / ST.FADE_TIME)
					else
						self:SetAlpha((ST.FADE_TIME - ST.CooldownCache[UserGUID].List[SpellID].Fade.FadeTimer) / ST.FADE_TIME)
					end
				else
					if ST.CooldownCache[UserGUID].List[SpellID].Fade.FadeType == 'IN' then
						self:SetAlpha(1)
						ST.CooldownCache[UserGUID].List[SpellID].Fade = nil
					else
						self:SetAlpha(0)
						ST.CooldownCache[UserGUID].List[SpellID].ActivateTime = 0
						--KF.Update['RaidCooldown_RefreshCooldown']['Action']()
						return
					end
				end
			elseif self:GetAlpha() ~= 1 then
				self:SetAlpha(1)
			end
			
			if ST.CooldownCache[UserGUID].List[SpellID].NeedCalculating and ((ST.InspectCache[UserGUID] and ST.InspectCache[UserGUID].Spec) or ST.CooldownCache[UserGUID].Spec) then
				ST.CooldownCache[UserGUID].List[SpellID].Cooltime, ST.CooldownCache[UserGUID].List[SpellID].NeedCalculating = ST:CalculateCooldown(ST.CooldownCache[UserGUID].List[SpellID].Event, UserGUID, ST.CooldownCache[UserGUID].Name, ST.CooldownCache[UserGUID].Class, SpellID, ST.CooldownCache[UserGUID].List[SpellID].DestName)
			end
			
			if not ST.CooldownCache[UserGUID].List[SpellID].Chargy and (TimeNow > ST.CooldownCache[UserGUID].List[SpellID].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID].Cooltime - ST.FADE_TIME) and not ST.CooldownCache[UserGUID].List[SpellID].Fade then
				ST.CooldownCache[UserGUID].List[SpellID].Fade = { FadeType = TimeNow, }
			end
			
			self.CooldownBar:SetValue(100 - (TimeNow - ST.CooldownCache[UserGUID].List[SpellID].ActivateTime) / ST.CooldownCache[UserGUID].List[SpellID].Cooltime * 100)
			self.Time:SetText(ST:GetTimeFormat(RemainCooltime))
		end
	end
	
	
	function ST:Bar_Setup(Bar)
		--Bar:SetAlpha(0)
		Bar:SetBackdrop({
			bgFile = E.media.normTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Bar:SetFrameLevel(3)
		
		Bar.SpellIconFrame = CreateFrame('Button', nil, Bar)
		Bar.SpellIconFrame:SetBackdrop({
			bgFile = false,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Bar.SpellIconFrame:Point('LEFT', Bar)
		Bar.SpellIconFrame:RegisterForClicks('AnyUp')
		Bar.SpellIcon = Bar.SpellIconFrame:CreateTexture(nil, 'OVERLAY')
		Bar.SpellIcon:SetTexCoord(unpack(E.TexCoords))
		Bar.SpellIcon:SetInside()
		
		Bar.CooldownBar = CreateFrame('Statusbar', nil, Bar)
		Bar.CooldownBar:SetMinMaxValues(0,100)
		Bar.CooldownBar:SetStatusBarTexture(E.media.normTex)
		Bar.CooldownBar:SetFrameLevel(5)
		Bar.CooldownBar:Point('TOPLEFT', Bar.SpellIconFrame, 'TOPRIGHT', 0, -1)
		Bar.CooldownBar:Point('BOTTOMRIGHT', Bar, -1, 1)
		
		KF:TextSetting(Bar.CooldownBar, nil, { Tag = 'Time', FontSize = DB.Modules.SmartTracker.Window[WindowName].Bar_Fontsize, FontOutline = 'OUTLINE', directionH = 'RIGHT', }, 'RIGHT', Bar.CooldownBar, -2, 0)
		Bar.Time = Bar.CooldownBar.Time
		
		KF:TextSetting(Bar.CooldownBar, nil, { FontSize = DB.Modules.SmartTracker.Window[WindowName].Bar_Fontsize, FontOutline = 'OUTLINE', directionH = 'LEFT', }, 'LEFT', Bar.CooldownBar, 5, 0)
		Bar.Text = Bar.Text
		Bar.Text:Point('RIGHT', Bar.Time, 'LEFT', -5, 0)
		
		return Bar
	end
	
	
	function ST:Bar_Create(Window, BarNum)
		local Bar = Window.ContainedBar[BarNum]
		
		if not Bar then
			if #self.DeletedBar > 0 then
				Window.ContainedBar[BarNum] = self.DeletedBar[#self.DeletedBar]
				self.DeletedBar[#self.DeletedBar] = nil
			else
				Window.ContainedBar[BarNum] = self:Bar_Setup(CreateFrame('Frame'))
			end
			
			Bar = Window.ContainedBar[BarNum]
			
			--초기화 여기서
			Bar.Num = BarNum
		end
		
		-- Update Appearance
		ST:Bar_Rearrange(Window, BarNum)
	end
	
	
	function ST:Bar_Rearrange(Window, StartNum)
		local Bar
		
		for CurrentLine = (StartNum or 1), StartNum or #Window.ContainedBar do
			Bar = Window.ContainedBar[CurrentLine]
			
			Bar:ClearAllPoints()
			Bar:Point('LEFT', Window.DisplayArea)
			Bar:Point('RIGHT', Window.DisplayArea)
			
			if DB.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 1 then
				if CurrentLine == 1 then
					Bar:Point('BOTTOM', Window.DisplayArea, 0, 2)
				else
					Bar:Point('BOTTOM', Window.ContainedBar[CurrentLine - 1], 'TOP', 0, -1)
				end
			else
				if CurrentLine == 1 then
					Bar:Point('TOP', Window.DisplayArea, 0, -2)
				else
					Bar:Point('TOP', Window.ContainedBar[CurrentLine - 1], 'BOTTOM', 0, 1)
				end
			end
			Bar:SetHeight(DB.Modules.SmartTracker.Window[Window.Name].Bar_Height)
			Bar.SpellIconFrame:Size(DB.Modules.SmartTracker.Window[Window.Name].Bar_Height)
			Bar.Time:SetFont(Bar.Time:GetFont(), DB.Modules.SmartTracker.Window[Window.Name].Bar_Fontsize, 'OUTLINE')
			Bar.Text:SetFont(Bar.Text:GetFont(), DB.Modules.SmartTracker.Window[Window.Name].Bar_Fontsize, 'OUTLINE')
			
			Bar:Show()
		end
	end
end


do	--<< System >>--
	function ST:GetTimeFormat(InputTime)
		if InputTime > 60 then
			return string.format('%d:%.2d', InputTime / 60, InputTime % 60)
		elseif InputTime < 10 then
			return string.format('|cffb90624%.1f|r', InputTime)
		else
			return string.format('%d', InputTime)
		end
	end
	
	
	function ST:GetUserRoleIcon(UserGUID)
		local RoleIcon = ''
		local Spec, Class
		
		if self.InspectCache[UserGUID] and self.InspectCache[UserGUID].Spec then
			Spec = self.InspectCache[UserGUID].Spec
			Class = self.InspectCache[UserGUID].Class
		end
		
		if not Spec and not Class and self.CooldownCache[UserGUID] and self.CooldownCache[UserGUID].Spec then
			Spec = self.CooldownCache[UserGUID].Spec
			Class = self.CooldownCache[UserGUID].Class
		end
		
		if Spec and Class then
			Spec = Info.ClassRole[Class][Spec].Role
			
			if Spec == 'Tank' then
				RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\tank:12:12:0:|t'
			elseif Spec == 'Healer' then
				RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\healer:12:12:0:0|t'
			else
				RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\dps:12:12:0:0|t'
			end
		end
		
		return RoleIcon
	end
	
	
	function ST:CalculateCooldown(Event, UserGUID, UserName, UserClass, SpellID, DestName)
		local Cooldown = Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Time
		
		if self.InspectCache[UserGUID] then
			local UserSpec = self.InspectCache[UserGUID].Spec or self.CooldownCache[UserGUID].Spec
			
			if UserSpec then
				if DestName and DestName:find('|cff') then DestName = strsub(DestName, 11, -3) end
				
				--Change Cooldown By Specialization
				--[[
				if UserClass == 'WARRIOR' and UserSpec == L['Spec_Warrior_Protection'] and SpellID == 871 then
					Cooldown = Cooldown - 60
				elseif UserClass == 'HUNTER' and UserSpec == L['Spec_Hunter_Survival'] and (SpellID == 1499 or SpellID == 13809 or SpellID == 34600) then
					Cooldown = Cooldown - 6
				elseif UserClass == 'DRUID' and UserSpec == L['Spec_Druid_Restoration'] and SpellID == 740 and UnitLevel(UserName) >= 82 then
					Cooldown = Cooldown - 300
				elseif UserClass == 'ROGUE' and Event == 'SPELL_INTERRUPT' and SpellID == 1766 and (self.InspectCache[UserGUID]['Glyph'][2] == 56805 or self.InspectCache[UserGUID]['Glyph'][4] == 56805 or self.InspectCache[UserGUID]['Glyph'][6] == 56805) then
					Cooldown = Cooldown - 6
				elseif UserClass == 'PALADIN' and UserSpec == L['Spec_Paladin_Retribution'] and SpellID == 31884 then
					Cooldown = Cooldown - 60
				elseif UserClass == 'PRIEST' and UserSpec == L['Spec_Priest_Shadow'] and SpellID == 108968 then
					Cooldown = Cooldown + 300
				end
				
				if UserClass == 'HUNTER' and DestName and SpellID == 131894 then
					local CheckID = UnitName(UserName..'-target')
					UnitHealth(DestName)/UnitHealthMax(DestName) <= 0.2 then
					
					local asdfasdf = UnitName(UserName..'-target')
					print(asdfasdf)
					print(asdfasdf ~= nil and UnitHealth(UserName..'-target') or 'nil')
					
					Cooldown = Cooldown - 60 --저승까마귀 생명력 20% 이하 대상에게 사용 시 60초감소
				end
				]]
				
				--Change Cooldown By Talent
				if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Talent then
					for i = 1, MAX_TALENT_TIERS * NUM_TALENT_COLUMNS do
						Cooldown = Cooldown + (Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Talent[(self.InspectCache[UserGUID].Glyph[i])] + 0)
					end
				end
				
				--Change Cooldown By Glyph
				if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Glyph then
					for i = 1, NUM_GLYPH_SLOTS do
						Cooldown = Cooldown + (Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Glyph[(self.InspectCache[UserGUID].Glyph[i])] + 0)
					end
				end
				
				return Cooldown, nil
			end
		end
		
		return Cooldown, true
	end
end

--[[
KF.Modules[#KF.Modules + 1] = 'SmartTracker'
KF.Modules.SmartTracker = function(RemoveOrder)
	for WindowName in pairs(KF.UIParent.Window) do
		ST:Window_Delete(WindowName, true)
	end
	
	if not RemoveOrder and DB.Enable ~= false and DB.Modules.SmartTracker.Enable ~= false then
		Info.SmartTracker_Activate = true
		
		if ST.Setup_MainWindow then
			ST:Setup_MainWindow()
		end
		
		for WindowName, IsWindowData in pairs(DB.Modules.SmartTracker.Window) do
			if type(IsWindowData) == 'table' then
				ST:Window_Create(WindowName)
			end
		end
	else
		Info.SmartTracker_Activate = nil
	end
end]]