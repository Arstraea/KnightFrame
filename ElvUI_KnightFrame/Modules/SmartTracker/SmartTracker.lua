local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

local WindowCount = 1
local IconCount = 1
local AnchorCount = 1

--------------------------------------------------------------------------------
--<< KnightFrame : Smart Tracker											>>--
--------------------------------------------------------------------------------
local ST = SmartTracker or CreateFrame('Frame', 'SmartTracker', KF.UIParent)

ST.DeletedWindow = {}
ST.DeletedBar = {}
ST.DeletedIcon = {}
ST.DeletedAnchor = {}

ST.TrackingSpell = {}
ST.WarriorRageTracker = {}

ST.InspectOrder = {}
ST.InspectCache = {}
ST.CooldownCache = {}

ST.TAB_HEIGHT = 22
ST.FADE_TIME = .4

KF.UIParent.ST_Window = {}
KF.UIParent.ST_Icon = {}
KF.UIParent.MoverType.KF_SmartTracker = L['Smart Tracker']


do	--<< About Window's Layout and Appearance >>--
	function ST:OnSizeChanged()
		KF.db.Modules.SmartTracker.Window[self.Name].Appearance.Area_Width = tonumber(E:Round(self:GetWidth()))
		KF.db.Modules.SmartTracker.Window[self.Name].Appearance.Area_Height = tonumber(E:Round(self:GetHeight()))
		
		ST:Window_Size(self)
	end
	
	
	function ST:DisplayArea_OnMouseWheel(Spinning)
		--마우스 휠을 위로 굴리면 Spinning 에 1값 리턴, 아래로 굴리면 Spinning 에 -1값 리턴
		local Window = self:GetParent()
		
		if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 'UP' then
			if Spinning == 1 and Window.BarRemains then
				Window.CurrentWheelLine = Window.CurrentWheelLine + 1
			elseif Spinning == -1 and Window.CurrentWheelLine > 0 then
				Window.CurrentWheelLine = Window.CurrentWheelLine - 1
			else
				return
			end
		else
			if Spinning == -1 and Window.BarRemains then
				print('아래로 굴림')
				Window.CurrentWheelLine = Window.CurrentWheelLine + 1
			elseif Spinning == 1 and Window.CurrentWheelLine > 0 then
				print('위로 굴림')
				Window.CurrentWheelLine = Window.CurrentWheelLine - 1
				Window.Reverse = nil
			else
				print('리턴됨')
				return
			end
		end
		
		ST:RedistributeCooldownData(Window)
	end
	
	
	function ST:Tab_OnMouseUp()
		local Window = self:GetParent()
		
		if Window.DisplayArea:GetAlpha() > 0 then
			Window:StopMovingOrSizing()
			local Point, _, SecondaryPoint, X, Y = Window:GetPoint()
			Window.mover:ClearAllPoints()
			Window.mover:Point(Point, E.UIParent, SecondaryPoint, X, Y)
			E:SaveMoverPosition(Window.mover.name)
			Window:ClearAllPoints()
			Window:SetPoint(Point, Window.mover, 0, 0)
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
			if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 'UP' then
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
			if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 'UP' then
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
		
		Window:Point('CENTER')
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
			KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Show = false
			print(L['KF']..' : '..L['Lock Display Area.'])
		else
			Window.DisplayArea:SetAlpha(1)
			KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Show = true
			print(L['KF']..' : '..L['Unlock Display Area.'])
		end
	end


	function ST:Window_Create(WindowName)
		if not KF.db.Modules.SmartTracker.Enable or KF.db.Modules.SmartTracker.Window[WindowName].Enable == false then
			self:Window_Delete(WindowName, true)
			return
		end
		
		local Window = KF.UIParent.ST_Window[WindowName]
		
		if not Window then
			if #self.DeletedWindow > 0 then
				KF.UIParent.ST_Window[WindowName] = self.DeletedWindow[#self.DeletedWindow]
				
				Window = KF.UIParent.ST_Window[WindowName]
				
				E.CreatedMovers[Window.mover.name] = Window.MoverData
				Window.MoverData = nil
				
				Window:Show()
				
				self.DeletedWindow[#self.DeletedWindow] = nil
			else
				WindowCount = WindowCount + 1
				
				Window = self:Window_Setup(CreateFrame('Frame', 'ST_Window_'..WindowCount, KF.UIParent), WindowCount)
				
				KF.UIParent.ST_Window[WindowName] = Window
				
				E:CreateMover(Window, 'ST_Window_'..Window.Count..'_Mover', nil, nil, nil, nil, 'ALL,KF,KF_SmartTracker')
				Window:SetScript('OnSizeChanged', self.OnSizeChanged)
			end
			
			E.CreatedMovers[Window.mover.name].point = E:HasMoverBeenMoved(WindowName) and E.db.movers[WindowName] or KF.db.Modules.SmartTracker.Window[WindowName].Location or 'CENTERElvUIParent'
			Window.mover:ClearAllPoints()
			Window.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Window.mover.name].point)}))
			
			--초기화 여기서
			Window.Name = WindowName
			Window.CurrentWheelLine = 0
			Window.ContainedBar = {}
			
			self:BuildTrackingSpellList(WindowName)
			self:RedistributeCooldownData(Window)
		end
		
		-- Setting
		self:Window_Size(Window)
		self:Window_ChangeBarGrowDirection(Window)
		
		-- Colorize
		Window.Tab:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[WindowName].Appearance.Color_WindowTab))
		
		Window.mover.text:SetText(L['WindowTag']..WindowName)
		
		--Window.Tab.text:SetText('|cff2eb7e4'..Default['MainFrame_Tab_AddOnName']) 탭에 표시할 제목
		
		
		if E.ConfigurationMode then
			Window.mover:Show()
		end
	end


	function ST:Window_Size(Window)
		local MinimumHeight = (KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Height - 1) * 5 + ST.TAB_HEIGHT
		
		if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Height < MinimumHeight then
			KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Height = MinimumHeight
		end
		
		Window:SetMinResize(200, MinimumHeight)
		Window:SetMaxResize(floor(UIParent:GetWidth() / 2), floor(UIParent:GetHeight() * 2/3))
		Window:Size(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Width, KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Height)
		Window.mover:Size(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Width, KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Height)
		
		local DisplayableBarNum = floor((KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Height - ST.TAB_HEIGHT) / (KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Height - 1))
		
		if Window.OldDisplayableBarNum ~= DisplayableBarNum then
			if Window.OldDisplayableBarNum then
				ST:RedistributeCooldownData(Window)
			end
			
			Window.OldDisplayableBarNum = DisplayableBarNum
			Window.DisplayArea.text:SetText(L['Enable to display']..' : |cff2eb7e4'..DisplayableBarNum)
		end
	end


	function ST:Window_ChangeBarGrowDirection(Window)
		Window.Tab:ClearAllPoints()
		Window.Tab:Point('LEFT', Window)
		Window.Tab:Point('RIGHT', Window)
		
		Window.ResizeGrip:ClearAllPoints()
		Window.DisplayArea.text:ClearAllPoints()
		if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 'UP' then -- 1 : Up / 2 : Down
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
		local Window = KF.UIParent.ST_Window[WindowName]
		
		if Window then
			
		end
	end


	function ST:Setup_MainWindow()
		KF.UIParent.ST_Window[1] = self:Window_Setup(self, 1)
		
		if KF.db.Modules.SmartTracker.Window[1].Location then
			self:SetPoint(unpack({string.split('\031', KF.db.Modules.SmartTracker.Window[1].Appearance.Location)}))
			--KF.db.Modules.SmartTracker.Window[1].Location = nil
		else
			self:Point('CENTER')
		end
		
		E:CreateMover(self, 'SmartTracker_MainWindow', L['WindowTag']..L['SmartTracker_MainWindow'], nil, nil, nil, 'ALL,KF,KF_SmartTracker')
		self:SetScript('OnSizeChanged', self.OnSizeChanged)
		
		if E:HasMoverBeenMoved('SmartTracker_MainWindow') then
			self.mover:ClearAllPoints()
			self.mover:SetPoint(unpack({string.split('\031', E.db.movers.SmartTracker_MainWindow)}))
			E.CreatedMovers.SmartTracker_MainWindow.point = E.db.movers.SmartTracker_MainWindow
		end
		
		self.Name = 1
		self.CurrentWheelLine = 0
		self.ContainedBar = {}
		
		self:BuildTrackingSpellList(1)
		self:RedistributeCooldownData(self)
		
		self.Setup_MainWindow = nil
	end
end


do	--<< About Bar's Layout and Appearance >>--
	function ST:BarIcon_OnEnter()
		local Bar = self:GetParent()
		
		if not (Bar.Data and Bar.Data.FrameType ~= 'NamePlate') then return end
		
		self:SetScript('OnUpdate', ST.BarIcon_OnUpdate)
	end
	
	
	function ST:BarIcon_OnLeave()
		self:SetScript('OnUpdate', nil)
		
		if self.TooltipDisplayed then
			GameTooltip:Hide()
		end
		self.TooltipDisplayed = nil
	end
	
	
	function ST:BarIcon_OnClick(Button)
		local Bar = self:GetParent()
		
		if not (Button == 'RightButton' and Bar.Data and Bar.Data.FrameType ~= 'NamePlate') then
			return
		else
			if self.TooltipDisplayed then
				GameTooltip:Hide()
			end
			self.TooltipDisplayed = nil
			
			if IsShiftKeyDown() then
				local Window = Bar:GetParent()
				
				do	-- Modify TrackingSpell List
					local EraseTrackingSpell = true
					
					ST.TrackingSpell[Bar.Data.SpellID][Window] = nil
					
					for _ in pairs(ST.TrackingSpell[Bar.Data.SpellID]) do
						EraseTrackingSpell = nil
						break
					end
					
					if EraseTrackingSpell then
						ST.TrackingSpell[Bar.Data.SpellID] = nil
					end
				end
				
				for i = 1, #ST.CooldownCache do
					ST.CooldownCache[(ST.CooldownCache[i])].List[Bar.Data.SpellID] = nil
				end
				
				KF.db.Modules.SmartTracker.Window[Window.Name].SpellList[ST.CooldownCache[Bar.Data.GUID].Class][Bar.Data.SpellID] = false
				
				ST:RedistributeCooldownData(Window)
			elseif not ST.CooldownCache[Bar.Data.GUID].List[Bar.Data.SpellID].Fade or ST.CooldownCache[Bar.Data.GUID].List[Bar.Data.SpellID].Fade.Type == 'IN' then
				if #ST.CooldownCache[Bar.Data.GUID].List[Bar.Data.SpellID] > 1 then
					ST.CooldownCache[Bar.Data.GUID].List[Bar.Data.SpellID][1].EraseThisCooltimeCache = true
				else
					Bar.Fade = {}
					ST.CooldownCache[Bar.Data.GUID].List[Bar.Data.SpellID][1].NoAnnounce = true
				end
			end
		end
	end
	
	
	function ST:BarIcon_OnUpdate()
		local Bar = self:GetParent()
		local Window = Bar:GetParent()
		
		if Bar.Data and Bar.Data.FrameType ~= 'NamePlate' and Bar.Data.SpellID then
			self.TooltipDisplayed = true
			
			if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 1 then -- 1 : Up / 2 : Down
				GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
			else
				GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
			end
			
			GameTooltip:ClearLines()
			
			if KF.db.Modules.SmartTracker.General.DetailSpellTooptip == true or IsShiftKeyDown() then
				GameTooltip:SetHyperlink(GetSpellLink(Bar.Data.SpellID))
				GameTooltip:AddLine('|n')
			else
				GameTooltip:AddLine(GetSpellInfo(Bar.Data.SpellID))
			end
			
			GameTooltip:AddDoubleLine(' - |cff2eb7e4'..L['RightClick'], L['Remove this cooltime bar.'], 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine(' - Shift + |cff2eb7e4'..L['RightClick'], L['Clear this spell config to forbid displaying.'], 1, 1, 1, 1, 1, 1)
			GameTooltip:Show()
		else
			ST.BarIcon_OnLeave(self)
		end
	end
	
	
	function ST:Bar_OnUpdate(elapsed)
		local UserGUID = self.Data.GUID
		local Window = self:GetParent()
		
		if self.Data.FrameType == 'NamePlate' then
			if ST.InspectCache[UserGUID] and ST.CooldownCache[UserGUID].Spec ~= ST.InspectCache[UserGUID].Spec then
				ST.CooldownCache[UserGUID].Spec = ST.InspectCache[UserGUID].Spec
				
				self.Data.SettingComplete = nil
				self:SetScript('OnUpdate', nil)
			end
			
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
			
			--|TInterface\\AddOns\\ElvUI\\media\\textures\\arrow:10:10:-4:-1:64:64:0:64:0:64:206:255:0|t
			self.Text:SetText('|cffceff00'..(self.Data.ArrowUp and '▲|r ' or '▼|r ')..KF:Color_Class(ST.CooldownCache[UserGUID].Class, ST.CooldownCache[UserGUID].Name)..ST:GetUserRoleIcon(UserGUID))
		elseif self.Data.FrameType == 'CooldownBar' then
			local Bar_Color = RAID_CLASS_COLORS[ST.CooldownCache[UserGUID].Class]
			local SpellID = tonumber(self.Data.SpellID)
			local TimeNow = GetTime()
			local RemainCooltime = ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime - TimeNow
			
			if not self.Data.SettingComplete then
				local SpellName, _, SpellIcon = GetSpellInfo(SpellID)
				SpellName = ST.CooldownCache[UserGUID].List[SpellID][1].Text or SpellName
				
				self.SpellIcon:SetTexture(SpellIcon)
				self:SetBackdropBorderColor(unpack(E.media.bordercolor))
				self.SpellIconFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))
				
				if #ST.CooldownCache[UserGUID].List[SpellID] > 1 then
					if ST.CooldownCache[UserGUID].List[SpellID][2].ChargedColor then
						self.CooldownBar:SetStatusBarColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Color_Charged1))
						self:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Color_Charged2))
					else
						self.CooldownBar:SetStatusBarColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Color_Charged2))
						self:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Color_Charged1))
					end
					
					if not ST.CooldownCache[UserGUID].List[SpellID][3] then
						self:SetBackdropColor(Bar_Color.r, Bar_Color.g, Bar_Color.b)
					end
				else
					self:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Color_BehindBar))
					self.CooldownBar:SetStatusBarColor(Bar_Color.r, Bar_Color.g, Bar_Color.b)
				end
				
				SpellName = SpellName..(not ST.CooldownCache[UserGUID].List[SpellID][1].Text and #ST.CooldownCache[UserGUID].List[SpellID] > 1 and ' ('..#ST.CooldownCache[UserGUID].List[SpellID]..')' or '')
				
				if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Target then
					local Target, LastestTargetUserGUID, LastestTargetColor
					local LastestTargetUserCount = 1
					local DisplayedTargetUser = 0
					
					for i = 1, #ST.CooldownCache[UserGUID].List[SpellID] do
						if ST.CooldownCache[UserGUID].List[SpellID][i].DestName then
							if LastestTargetUserGUID ~= ST.CooldownCache[UserGUID].List[SpellID][i].DestGUID then
								Target = (Target and Target..'|r'..(LastestTargetUserCount > 1 and ' x '..LastestTargetColor..LastestTargetUserCount or ', ') or '')..ST.CooldownCache[UserGUID].List[SpellID][i].DestColor..ST.CooldownCache[UserGUID].List[SpellID][i].DestName
								
								LastestTargetUserCount = 1
								DisplayedTargetUser = DisplayedTargetUser + 1
							else
								LastestTargetUserCount = LastestTargetUserCount + 1
								LastestTargetColor = ST.CooldownCache[UserGUID].List[SpellID][i].DestColor
							end
							
							if DisplayedTargetUser > KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Count_TargetUser then
								break
							end
							
							LastestTargetUserGUID = ST.CooldownCache[UserGUID].List[SpellID][i].DestGUID
						end
					end
					
					SpellName = SpellName..(Target and ' |cffceff00▶|r '..Target..(LastestTargetUserCount > 1 and ' |rx '..LastestTargetColor..LastestTargetUserCount or '') or '')
				end
				self.Text:SetText(SpellName)
				
				self.Data.SettingComplete = true
			end
			
			if self.Fade then --ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.FADE_TIME > TimeNow then
				self.Fade.Timer = (self.Fade.Timer or 0) + elapsed
				
				if self.Fade.Timer < ST.FADE_TIME then
					if self.Fade.Type == 'IN' then
						self:SetAlpha(self.Fade.Timer / ST.FADE_TIME)
					else
						self:SetAlpha((ST.FADE_TIME - self.Fade.Timer) / ST.FADE_TIME)
					end
				else
					if self.Fade.Type == 'IN' then
						self:SetAlpha(1)
						self.Fade = nil
					else
						self:SetAlpha(0)
						ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime = 0
						
						ST:RefreshCooldownCache()
						return
					end
				end
			elseif self:GetAlpha() ~= 1 then
				self:SetAlpha(1)
			end
			
			if #ST.CooldownCache[UserGUID].List[SpellID] == 1 and (TimeNow > ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime - ST.FADE_TIME) and not self.Fade then
				self.Fade = {}--{ Type = TimeNow, }
			end
			
			self.CooldownBar:SetValue(100 - (TimeNow - ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime) / ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime * 100)
			self.Time:SetText(ST:GetTimeFormat(RemainCooltime))
		end
	end
	
	
	function ST:Bar_Setup(Bar, Window)
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
		Bar.SpellIconFrame:SetScript('OnEnter', ST.BarIcon_OnEnter)
		Bar.SpellIconFrame:SetScript('OnLeave', ST.BarIcon_OnLeave)
		Bar.SpellIconFrame:SetScript('OnClick', ST.BarIcon_OnClick)
		Bar.SpellIcon = Bar.SpellIconFrame:CreateTexture(nil, 'OVERLAY')
		Bar.SpellIcon:SetTexCoord(unpack(E.TexCoords))
		Bar.SpellIcon:SetInside()
		
		Bar.CooldownBar = CreateFrame('Statusbar', nil, Bar)
		Bar.CooldownBar:SetMinMaxValues(0,100)
		Bar.CooldownBar:SetStatusBarTexture(E.media.normTex)
		Bar.CooldownBar:SetFrameLevel(5)
		Bar.CooldownBar:Point('TOPLEFT', Bar.SpellIconFrame, 'TOPRIGHT', 0, -1)
		Bar.CooldownBar:Point('BOTTOMRIGHT', Bar, -1, 1)
		
		KF:TextSetting(Bar.CooldownBar, nil, { Tag = 'Time', FontSize = KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_FontSize, FontOutline = 'OUTLINE', directionH = 'RIGHT', }, 'RIGHT', Bar.CooldownBar, -2, 0)
		Bar.Time = Bar.CooldownBar.Time
		
		KF:TextSetting(Bar.CooldownBar, nil, { FontSize = KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_FontSize, FontOutline = 'OUTLINE', directionH = 'LEFT', }, 'LEFT', Bar.CooldownBar, 5, 0)
		Bar.Text = Bar.CooldownBar.text
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
				Window.ContainedBar[BarNum] = self:Bar_Setup(CreateFrame('Frame'), Window)
			end
			
			Bar = Window.ContainedBar[BarNum]
			Bar:SetParent(Window)
			
			--초기화 여기서
			Bar.Num = BarNum
		end
		
		Bar:SetScript('OnUpdate', ST.Bar_OnUpdate)
		
		-- Update Appearance
		ST:Bar_Rearrange(Window, BarNum)
		
		return Bar
	end
	
	
	function ST:Bar_Rearrange(Window, StartNum)
		local Bar
		
		for CurrentLine = (StartNum or 1), StartNum or #Window.ContainedBar do
			Bar = Window.ContainedBar[CurrentLine]
			
			Bar:ClearAllPoints()
			Bar:Point('LEFT', Window.DisplayArea)
			Bar:Point('RIGHT', Window.DisplayArea)
			
			if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 1 then
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
			Bar:SetHeight(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Height)
			Bar.SpellIconFrame:Size(KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Height)
			Bar.Time:SetFont(Bar.Time:GetFont(), KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_FontSize, 'OUTLINE')
			Bar.Text:SetFont(Bar.Text:GetFont(), KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_FontSize, 'OUTLINE')
			
			Bar:Show()
		end
	end
	
	
	function ST:Bar_Delete(Window, BarNum)
		local Bar = Window.ContainedBar[BarNum]
		
		if Bar then
			Bar:SetAlpha(1)
			Bar:SetScript('OnUpdate', nil)
			Bar.Data = nil
			Bar:Hide()
			
			self.DeletedBar[#self.DeletedBar + 1] = Window.ContainedBar[BarNum]
			Window.ContainedBar[BarNum] = nil
		end
	end
end


do	--<< About Icon >>--
	function ST:Icon_OnEnter()
		self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
		self.DisplayTooltip = true
		self:SetScript('OnUpdate', ST.Icon_OnUpdate)
	end
	
	
	function ST:Icon_OnLeave()
		self:SetBackdropBorderColor(unpack(E.media.bordercolor))
		
		self.DisplayTooltip = nil
		self:SetScript('OnUpdate', nil)
		GameTooltip:Hide()
	end
	
	
	function ST:Icon_OnUpdate()
		if not self.Data then
			return
		elseif self.DisplayTooltip then
			GameTooltip:ClearLines()
			
			if KF.db.Modules.SmartTracker.General.DetailSpellTooptip == true or IsShiftKeyDown() then
				self.Link = self.Link or GetSpellLink(self.SpellID)
				
				GameTooltip:SetHyperlink(self.Link)
				GameTooltip:AddLine('|n|cff1784d1>>|r '..L['Castable User']..' |cff1784d1<<', 1, 1, 1)
			else
				self.SpellName = self.SpellName or GetSpellInfo(self.SpellID)
				
				GameTooltip:AddLine('|cff1784d1>>|r '..self.SpellName..' |cff1784d1<<', 1, 1, 1)
			end
		end
		
		local UserName, Text
		local SpellNow, SpellCount, TotalNow, TotalCount = 0, 0, 0, 0
		local TimeNow = GetTime()
		
		for _, UserGUID in pairs(self.Data) do
			if ST.InspectCache[UserGUID] then
				UserName = ST.InspectCache[UserGUID].Name
				
				SpellCount = ST:CheckSpellChargeCondition(UserGUID, UserName, ST.InspectCache[UserGUID].Class, self.SpellID) or 1
				SpellNow = SpellCount
				
				if ST.CooldownCache[UserGUID] and ST.CooldownCache[UserGUID].List[SpellID] then
					SpellNow = SpellNow - #ST.CooldownCache[UserGUID].List[SpellID]
				end
				
				TotalNow = TotalNow + SpellNow
				TotalCount = TotalCount + SpellCount
				
				
				if self.DisplayTooltip then
					GameTooltip:AddDoubleLine(
						' '..ST:GetUserRoleIcon(UserGUID)' '..(UnitIsDeadOrGhost(UserName) and '|cff778899'..UserName..' ('..DEAD..')' or KF:Color_Class(ST.InspectCache[UserGUID].Class, UserName))
						,
						SpellNow > 0 and '|cff2eb7e4'..L['Enable To Cast']..(SpellCount > 1 and '|r ('..SpellNow..')' or '') or ST.CooldownCache[UserGUID].List[self.SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[self.SpellID][1].Cooltime - TimeNow
					)
				end
			end
		end
		
		self.SpellIcon:SetAlpha(TotalNow > 0 and 1 or .2)
		self.text:SetText((TotalNow == 0 and '|cffb90624' or '')..TotalNow..(KF.db.Modules.SmartTracker.Icon[self:GetParent().Name].Appearance.DisplayMax ~= false and '/'..TotalCount or ''))
		
		if self.DisplayTooltip then
			GameTooltip:Show()
		end
	end
	
	
	function ST:Icon_Setup(Icon, Anchor)
		Icon:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		Icon:SetFrameLevel(3)
		Icon:SetBackdropColor(0, 0, 0, .8)
		Icon:SetBackdropBorderColor(unpack(E.media.bordercolor))
		Icon:SetScript('OnEnter', ST.Icon_OnEnter)
		Icon:SetScript('OnLeave', ST.Icon_OnLeave)
		
		Icon.SpellIcon = Icon:CreateTexture(nil, 'OVERLAY')
		--Icon.SpellIcon:SetTexture(select(3, GetSpellInfo(spellID)))
		Icon.SpellIcon:SetInside()
		
		KF:TextSetting(Icon, nil, { FontSize = KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Fontsize, FontStyle = 'OUTLINE', directionH = 'RIGHT' }, 'BOTTOMRIGHT', -1, 4)
		
		return Icon
	end
	
	
	function ST:Icon_Create(Anchor, IconNum)
		local Icon = Anchor.ContainedIcon[IconNum]
		
		if not Icon then
			if #self.DeletedIcon > 0 then
				Anchor.ContainedIcon[IconNum] = self.DeletedIcon[#self.DeletedIcon]
				self.DeletedIcon[#self.DeletedIcon] = nil
			else
				Anchor.ContainedIcon[IconNum] = self:Icon_Setup(CreateFrame('Button'), Anchor)
			end
			
			Icon = Anchor.ContainedIcon[IconNum]
			Icon:SetParent(Anchor)
			
			Icon.Num = IconNum
		end
		
		ST:Icon_Size(Anchor, IconNum)
		
		return Icon
	end
	
	
	function ST:Icon_Delete(Anchor, IconNum)
		local Icon = Anchor.ContainedIcon[IconNum]
		
		if Icon then
			Icon:SetScript('OnUpdate', nil)
			Icon.Data = nil
			Icon.SpellName = nil
			Icon.Link = nil
			Icon:Hide()
			
			self.DeletedIcon[#self.DeletedIcon + 1] = Anchor.ContainedIcon[IconNum]
			Anchor.ContainedIcon[IconNum] = nil
		end
	end
	
	
	function ST:Icon_Size(Anchor, StartNum)
		local Icon
		local TexCoord = { unpack(E.TexCoords) }
		
		if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth ~= KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight then
			local Diff
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth > KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight then
				Diff = (KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth - KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight) / KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth / 2
				TexCoord[3] = Diff
				TexCoord[4] = 1 - Diff
			else
				Diff = (KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight - KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth) / KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight / 2
				TexCoord[1] = Diff
				TexCodrd[2] = 1 - Diff
			end
		end
		
		for IconNum = (StartNum or 1), StartNum or #Anchor.ContainedIcon do
			Icon = Anchor.ContainedIcon[IconNum]
			
			Icon:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight)
			Icon.SpellIcon:SetTexCoord(unpack(TexCoord))
		end
	end
	
	
	function ST:Icon_Rearrange(Anchor, StartNum)
		local Icon
		local Point, SecondaryPoint
		local Spacing = KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing
		
		if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Arrangement == 'CENTER' then
			local OddNumberMode = #Anchor.ContainedIcon % 2 > 0
			local LeftAnchor, CenterAnchor, RightAnchor
			
			if OddNumberMode then
				CenterAnchor = ceil(#Anchor.ContainedIcon / 2)
				
				if not (StartNum and StartNum ~= CenterAnchor) then
					Icon = Anchor.ContainedIcon[CenterAnchor]
					Icon:ClearAllPoints()
					Icon:Point('CENTER', Anchor)
				end
			else
				LeftAnchor = #Anchor.ContainedIcon / 2
				RightAnchor = LeftAnchor + 1
				
				if not (StartNum and StartNum ~= (LeftAnchor)) then
					Icon = Anchor.ContainedIcon[LeftAnchor]
					Icon:ClearAllPoints()
					Icon:Point('CENTER', Anchor, 'Right', -Spacing / 2, 0)
				end
				
				if not (StartNum and StartNum ~= RightAnchor) then
					Icon = Anchor.ContainedIcon[RightAnchor]
					Icon:ClearAllPoints()
					Icon:Point('CENTER', Anchor, 'LEFT', Spacing / 2, 0)
				end
			end
			
			if not (StartNum and StartNum >= (LeftAnchor or CenterAnchor)) then
				Point = 'RIGHT'
				SecondaryPoint = 'LEFT'
				
				for IconNum = (StartNum or LeftAnchor - 1), StartNum or 1, -1 do
					Icon = Anchor.ContainedIcon[IconNum]
					Icon:ClearAllPoints()
					Icon:Point(Point, Anchor.ContainedIcon[IconNum + 1], SecondaryPoint, Spacing, 0)
				end
			end
			
			if not (StartNum and StartNum <= (RightAnchor or CenterAnchor)) then
				Point = 'LEFT'
				SecondaryPoint = 'RIGHT'
				
				for IconNum = (StartNum or RightAnchor + 1), StartNum or #Anchor.ContainedIcon do
					Icon = Anchor.ContainedIcon[IconNum]
					Icon:ClearAllPoints()
					Icon:Point(Point, Anchor.ContainedIcon[IconNum - 1], SecondaryPoint, Spacing, 0)
				end
			end
		else
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Arrangement == 'Left to Right' then
				Point = 'LEFT'
				SecondaryPoint = 'RIGHT'
			else
				Point = 'RIGHT'
				SecondaryPoint = 'LEFT'
				Spacing = -Spacing
			end
			
			for IconNum = (StartNum or 1), StartNum or #Anchor.ContainedIcon do
				Icon = Anchor.ContainedIcon[IconNum]
				Icon:ClearAllPoints()
				
				if IconNum == 1 then
					Icon:Point(Point, Anchor)
				else
					Icon:Point(Point, Anchor.ContainedIcon[IconNum - 1], SecondaryPoint, Spacing, 0)
				end
			end
		end
	end
	
	
	function ST:IconAnchor_Create(AnchorName)
		if not KF.db.Modules.SmartTracker.Enable or KF.db.Modules.SmartTracker.Icon[AnchorName].Enable == false then
			self:IconAnchor_Delete(AnchorName, true)
			return
		end
		
		local Anchor = KF.UIParent.ST_Icon[AnchorName]
		
		if not Anchor then
			if #self.DeletedIcon > 0 then
				KF.UIParent.ST_Icon[AnchorName] = self.DeletedAnchor[#self.DeletedIcon]
				
				Anchor = KF.UIParent.ST_Icon[AnchorName]
				
				E.CreatedMovers[Anchor.mover.name] = Anchor.MoverData
				Anchor.MoverData = nil
				
				Anchor:Show()
				
				self.DeletedIcon[#self.DeletedIcon] = nil
			else
				AnchorCount = AnchorCount + 1
				
				Anchor = CreateFrame('Frame', 'ST_IconAnchor_'..AnchorCount, KF.UIParent)
				Anchor:Point('CENTER')
				Anchor.Count = AnchorCount
				
				KF.UIParent.ST_Window[AnchorName] = Anchor
				
				E:CreateMover(Anchor, 'ST_Icon_'..Anchor.Count..'_Mover', nil, nil, nil, nil, 'ALL,KF,KF_SmartTracker')
			end
			
			E.CreatedMovers[Anchor.mover.name].point = E:HasMoverBeenMoved(AnchorName) and E.db.movers[AnchorName] or KF.db.Modules.SmartTracker.Icon[AnchorName].Location or 'CENTERElvUIParent'
			Anchor.mover:ClearAllPoints()
			Anchor.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Anchor.mover.name].point)}))
			
			--초기화 여기서
			Anchor.Name = AnchorName
			Anchor.ContainedIcon = {}
			
			self:BuildTrackingSpellList(AnchorName)
			self:RedistributeIconData(Anchor)
		end
		
		-- Update AnchorSize
		self:IconAnchor_Size(Anchor)
		
		
		
		
		
		if E.ConfigurationMode then
			Anchor.mover:Show()
		end
	end
	
	
	function ST:IconAnchor_Delete(AnchorName, SaveProfile)
		
	end
	
	
	function ST:IconAnchor_Size(Anchor)
		local Width, Height
		local SpellCount = #KF.db.Modules.SmartTracker.Icon[Anchor.Name].SpellList
		
		if SpellCount == 1 then
			Anchor:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight)
			Anchor.mover:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight)
		elseif SpellCount > 1 then
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Orientation == 'Horizontal' then
				Anchor:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth * SpellCount + KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing * (SpellCount - 1), KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight)
				Anchor.mover:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth * SpellCount + KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing * (SpellCount - 1), KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight)
			else
				Anchor:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight * SpellCount + KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing * (SpellCount - 1))
				Anchor.mover:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconWidth, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.IconHeight * SpellCount + KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing * (SpellCount - 1))
			end
		elseif SpellCount == 0 then
			Anchor:Size(0)
			Anchor.mover:Size(0)
		end
	end
end


do	--<< System >>--
	function ST:GetTimeFormat(InputTime)
		if InputTime > 60 then
			return string.format('%d:%.2d', InputTime / 60, InputTime % 60)
		elseif InputTime <= 9.9 then
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
				RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\tank:12:12:1:-1|t'
			elseif Spec == 'Healer' then
				RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\healer:12:12:1:-1|t'
			else
				RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\dps:12:12:1:-1|t'
			end
		end
		
		return RoleIcon
	end
	
	
	function ST:CalculateCooldown(Event, UserGUID, UserName, UserClass, SpellID, DestName, ParamTable)
		local Cooldown = Info.SmartTracker_Data[UserClass][SpellID].Time
		local NeedUpdating
		
		self.CooldownCache[UserGUID].Spec = self.InspectCache[UserGUID] and self.InspectCache[UserGUID].Spec or self.CooldownCache[UserGUID].Spec
		
		if self.InspectCache[UserGUID] and self.InspectCache[UserGUID].Spec then
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
			
			-- Change Cooldown By Talent
			if Info.SmartTracker_Data[UserClass][SpellID].Talent then
				for SelectedTalent, ChangingTime in pairs(Info.SmartTracker_Data[UserClass][SpellID].Talent) do
					if self.InspectCache[UserGUID].Talent[SelectedTalent] then
						Cooldown = Cooldown + ChangingTime
					end
				end
			end
			
			-- Change Cooldown By Glyph
			if Info.SmartTracker_Data[UserClass][SpellID].Glyph then
				for GlyphID, ChangingTime in pairs(Info.SmartTracker_Data[UserClass][SpellID].Glyph) do
					if self.InspectCache[UserGUID].Glyph[GlyphID] then
						Cooldown = Cooldown + ChangingTime
					end
				end
			end
		else
			NeedUpdating = true
		end
		
		-- If spell need more specific calcurating then run contained function.
		if Info.SmartTracker_Data[UserClass][SpellID].Func then
			Cooldown, NeedUpdating = Info.SmartTracker_Data[UserClass][SpellID].Func(Cooldown, self.CooldownCache[UserGUID], self.InspectCache[UserGUID], Event, UserGUID, UserName, UserClass, SpellID, DestName, ParamTable)
		end
		
		return Cooldown, NeedUpdating
	end
	
	
	function ST:BuildTrackingSpellList(TrackerName)
		if TrackerName then
			local Tracker, TrackerType
			
			if KF.UIParent.ST_Window[TrackerName] then
				Tracker = KF.UIParent.ST_Window[TrackerName]
				TrackerType = 'Window'
			elseif KF.UIParent.ST_Icon[TrackerName] then
				Tracker = KF.UIParent.ST_Icon[TrackerName]
				TrackerType = 'Icon'
			end
			
			if Tracker and TrackerType then
				for ClassName in pairs(Info.SmartTracker_Data) do
					for SpellID in pairs(Info.SmartTracker_Data[ClassName]) do
						if KF.db.Modules.SmartTracker[TrackerType][TrackerName].SpellList[ClassName][SpellID] ~= false and not (self.TrackingSpell[SpellID] and self.TrackingSpell[SpellID][Tracker]) then
							self.TrackingSpell[SpellID] = self.TrackingSpell[SpellID] or {}
							self.TrackingSpell[SpellID][Tracker] = TrackerType
						end
					end
				end
			end
		else
			wipe(self.TrackingSpell)
			
			for WindowName, Window in pairs(KF.UIParent.ST_Window) do
				for ClassName in pairs(Info.SmartTracker_Data) do
					for SpellID in pairs(Info.SmartTracker_Data[ClassName]) do
						if KF.db.Modules.SmartTracker.Window[WindowName].SpellList[ClassName][SpellID] ~= false and not (self.TrackingSpell[SpellID] and self.TrackingSpell[SpellID][Window]) then
							self.TrackingSpell[SpellID] = self.TrackingSpell[SpellID] or {}
							self.TrackingSpell[SpellID][Window] = 'Window'
						end
					end
				end
			end
			
			for AnchorName, Anchor in pairs(KF.UIParent.ST_Icon) do
				for ClassName in pairs(Info.SmartTracker_Data) do
					for SpellID in pairs(Info.SmartTracker_Data[ClassName]) do
						if KF.db.Modules.SmartTracker.Icon[AnchorName].SpellList[SpellID] ~= false and not (self.TrackingSpell[SpellID] and self.TrackingSpell[SpellID][Anchor]) then
							self.TrackingSpell[SpellID] = self.TrackingSpell[SpellID] or {}
							self.TrackingSpell[SpellID][Anchor] = 'Icon'
						end
					end
				end
			end
		end
	end
	
	--[[
	function ST:SetWindowDisplay(Window)
		Window = Window or self
		
		if
			Info.InstanceType == 'field' and (Info.CurrentGroupMode == 'NoGroup' and KF.db.Modules.SmartTracker.Window[Window.Name].Display.Situation.Solo == false or
			(Info.CurrentGroupMode == 'raid' or Info.CurrentGroupMode == 'party') and KF.db.Modules.SmartTracker.Window[Window.Name].Display.Situation.Group == false) or
			Info.InstanceType == 'raid' and KF.db.Modules.SmartTracker.Window[Window.Name].Display.Situation.RaidDungeon == false or
			(Info.InstanceType == 'arena' or Info.InstanceType == 'pvp') and KF.db.Modules.SmartTracker.Window[Window.Name].Display.Situation.PvPGround == false or
			KF.db.Modules.SmartTracker.Window[Window.Name].Display.Situation.Instance == false then
			
			
		else
			
		end
	end
	]]
	
	function ST:CheckSpellChargeCondition(UserGUID, UserName, UserClass, SpellID)
		if type(Info.SmartTracker_Data[UserClass][SpellID].Charge) == 'function' then
			return Info.SmartTracker_Data[UserClass][SpellID].Charge(UserGUID, UserName)
		else
			return Info.SmartTracker_Data[UserClass][SpellID].Charge
		end
	end
	
	
	function ST:RegisterCooldown(TimeStamp, Event, UserGUID, UserClass, UserName, SpellID, DestGUID, DestColor, DestName, ParamTable)
		local TimeNow = GetTime()
		
		--[[
		if ST.CooldownCache[UserGUID] then
			if SpellID == 11958 then --매서운 한파
				if ST.CooldownCache[UserGUID].List[45438] then ST.CooldownCache[UserGUID].List[45438].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[122] then ST.CooldownCache[UserGUID].List[122].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[120] then ST.CooldownCache[UserGUID].List[120].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
			elseif SpellID == 23989 then --만반의 준비
				for spell in pairs(ST.CooldownCache[UserGUID]['List']) do
					if KF.Table['RaidCooldownSpell'][UserClass][spell][1] < 300 then ST.CooldownCache[UserGUID].List[spell].Fade = { FadeType = TimeNow, .NoAnnounce = true, } end
				end
			elseif SpellID == 14185 then --마음가짐
				if ST.CooldownCache[UserGUID].List[2983] then ST.CooldownCache[UserGUID].List[2983].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[1856] then ST.CooldownCache[UserGUID].List[1856].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[180] then ST.CooldownCache[UserGUID].List[180].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[51722] then ST.CooldownCache[UserGUID].List[51722].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
			end
		end
		]]
		
		
		--[[
		if Event == 'SPELL_RESURRECT' and NowBossBattle then
			Table['BattleResurrection_CastMember'][#Table['BattleResurrection_CastMember'] + 1] = { ['UserGUID'] = UserGUID, ['UserClass'] = UserClass, ['UserName'] = UserName, ['DestGUID'] = DestGUID, ['DestColor'] = DestColor, ['DestName'] = DestName, }
		end
		]]
		
		if not ST.CooldownCache[UserGUID] then
			ST.CooldownCache[UserGUID] = {
				Name = UserName,
				Class = UserClass,
				List = {}
			}
			ST.CooldownCache[UserGUID].Spec = ST.InspectCache[UserGUID] and ST.InspectCache[UserGUID].Spec or nil
			tinsert(ST.CooldownCache, UserGUID)
			
			sort(ST.CooldownCache, function(UserGUID_A, UserGUID_B) return ST:SortData(UserGUID_A, UserGUID_B) end)
		end
		
		if not ST.CooldownCache[UserGUID].List[SpellID] then
			ST.CooldownCache[UserGUID].List[SpellID] = {
				--[[
				['Display'] = function()
					if KF.db.Modules.SmartTracker[UserClass] and KF.db.Modules.SmartTracker[UserClass][SpellID] == 1 then
						return NowBossBattle and 'InCombat' or true
					elseif KF.db.Modules.SmartTracker[UserClass] and KF.db.Modules.SmartTracker[UserClass][SpellID] and KF.db.Modules.SmartTracker[UserClass][SpellID] ~= 0 then
						return true
					elseif KF.db.Modules.SmartTracker.RaidIcon[SpellID] then
						return 'RaidIcon'
					end
				end,
				]]
				--Fade = { FadeType = 'IN' }
			}
		elseif TimeStamp and ST.CooldownCache[UserGUID].List[SpellID][(#ST.CooldownCache[UserGUID].List[SpellID])].TimeStamp == TimeStamp then -- because combat log check more than 1 time, so it needs to forbid just one.
			ST.CooldownCache[UserGUID].List[SpellID][(#ST.CooldownCache[UserGUID].List[SpellID])].Count = (ST.CooldownCache[UserGUID].List[SpellID][(#ST.CooldownCache[UserGUID].List[SpellID])].Count or 0) + 1
			return
		--elseif ST.CooldownCache[UserGUID].List[SpellID].Fade then
		--	ST.CooldownCache[UserGUID].List[SpellID].Fade = { FadeType = 'IN' }
		end
		
		local Chargable = ST:CheckSpellChargeCondition(UserGUID, UserName, UserClass, SpellID)
		
		if ST.CooldownCache[UserGUID].List[SpellID][1] and Chargable and not (type(Chargable) == 'number' and #ST.CooldownCache[UserGUID].List[SpellID] >= Chargable) then
			local Data = {
				ForbidFadeIn = true,
				TimeStamp = TimeStamp,
				DestGUID = DestGUID,
				DestColor = DestColor,
				DestName = DestName,
				Event = Event,
				ParamTable = ParamTable,
				Text = Info.SmartTracker_Data[UserClass][SpellID].Text,
				Hidden = Info.SmartTracker_Data[UserClass][SpellID].Hidden
			}
			Data.Cooltime, Data.NeedCalculating = ST:CalculateCooldown(Event, UserGUID, UserName, UserClass, SpellID, DestName, ParamTable)
			Data.ChargedColor = not ST.CooldownCache[UserGUID].List[SpellID][#ST.CooldownCache[UserGUID].List[SpellID] - 1]
			
			tinsert(ST.CooldownCache[UserGUID].List[SpellID], Data)
		else
			if not ST.CooldownCache[UserGUID].List[SpellID][1] then
				ST.CooldownCache[UserGUID].List[SpellID][1] = {}
			else
				ST.CooldownCache[UserGUID].List[SpellID][1].ForbidFadeIn = true
			end
			ST.CooldownCache[UserGUID].List[SpellID][1].TimeStamp = TimeStamp
			ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime = TimeNow
			ST.CooldownCache[UserGUID].List[SpellID][1].DestGUID = DestGUID
			ST.CooldownCache[UserGUID].List[SpellID][1].DestColor = DestColor
			ST.CooldownCache[UserGUID].List[SpellID][1].DestName = DestName
			ST.CooldownCache[UserGUID].List[SpellID][1].Event = Event
			ST.CooldownCache[UserGUID].List[SpellID][1].ParamTable = ParamTable
			ST.CooldownCache[UserGUID].List[SpellID][1].Text = Info.SmartTracker_Data[UserClass][SpellID].Text
			ST.CooldownCache[UserGUID].List[SpellID][1].Hidden = Info.SmartTracker_Data[UserClass][SpellID].Hidden
			ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime, ST.CooldownCache[UserGUID].List[SpellID][1].NeedCalculating = ST:CalculateCooldown(Event, UserGUID, UserName, UserClass, SpellID, DestName, ParamTable)
			ST.CooldownCache[UserGUID].List[SpellID][1].Count = nil
		end
		
		KF:RegisterTimer('RefreshCooldownCache', 'NewTicker', .1, ST.RefreshCooldownCache, nil, true)
		
		for Tracker, TrackerType in pairs(ST.TrackingSpell[SpellID]) do
			if TrackerType == 'Window' then --and Tracker.NowDisplaying then
				ST:RedistributeCooldownData(Tracker)
			else
				ST:RedistributeIconData(Tracker)
			end
		end
	end
	
	
	do	-- Event : UNIT_SPELLCAST_SUCCEEDED
		local UnitType, SpellID, UserName, UserGUID, UserClass
		function ST:UNIT_SPELLCAST_SUCCEEDED(...)
			UnitType, _, _, _, SpellID = ...
			SpellID = Info.SmartTracker_ConvertSpell[SpellID] or SpellID
			
			if not (SpellID and ST.TrackingSpell[SpellID] and Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[SpellID]) then return end
			
			UserName = UnitName(UnitType)
			UserGUID = UnitGUID(UnitType)
			
			if not UnitIsPlayer(UnitType) then -- find pet master
				if UnitName('pet') == UserName then
					UserName = E.myname
					UserGUID = E.myguid or UnitGUID('player')
				elseif Info.CurrentGroupMode ~= 'NoGroup' then
					if IsInRaid() and not UnitPlayerOrPetInRaid(UserName) then return
					elseif IsInGroup() and not UnitPlayerOrPetInParty(UserName) then return	end
					for i = 1, MAX_RAID_MEMBERS do
						if UnitExists(Info.CurrentGroupMode..i..'pet') and UnitIsUnit(UserName, Info.CurrentGroupMode..i..'pet') then
							UserName = UnitName(Info.CurrentGroupMode..i)
							UserGUID = UnitGUID(Info.CurrentGroupMode..i)
							break
						end
					end
				end
				
				if not UnitIsPlayer(UserName) then return end
			end
			_, UserClass = UnitClass(UserName)
			
			--[[
			elseif KF.db.Modules.SmartTracker.Scan.CheckChanging == true and (SpellID == 63644 or SpellID == 63645 or SpellID == 113873 or SpellID == 111621) then
				--Change Specialization or talent or glyph
				Table['Inspect_InspectOrder'][UserName] = nil
				Table['Inspect_InspectDelayed'][UserName] = nil
				
				if not KF.Update['RaidCooldownInspect']['Condition']() then
					Value['Inspect_ScanByChanging'] = true
					KF.Update['CheckGroupMembersNumber']['Condition'] = true
				end
			end
			]]
			
			if UserClass and Info.SmartTracker_Data[UserClass] and Info.SmartTracker_Data[UserClass][SpellID] and not (Info.SmartTracker_Data[UserClass][SpellID].NotToMe and UserName ~= E.myname) then
				ST:RegisterCooldown(nil, Event, UserGUID, UserClass, UserName, SpellID)
			end
		end
	end
	
	
	do	-- Event : COMBAT_LOG_EVENT_UNFILTERED
		local DefaultEventList = {
			SPELL_RESURRECT = true,
			SPELL_AURA_APPLIED = true,
			SPELL_AURA_REFRESH = true,
			SPELL_CAST_SUCCESS = true,
			SPELL_INTERRUPT	= true,
			SPELL_SUMMON = true
		}
		local TimeStamp, Event, UserGUID, UserName, UserFlag, DestGUID, DestName, DestFlag, SpellID, UserClass, DestColor
		function ST:COMBAT_LOG_EVENT_UNFILTERED(...)
			TimeStamp, Event, _, UserGUID, UserName, UserFlag, _, DestGUID, DestName, DestFlag, _, SpellID = ...
			SpellID = Info.SmartTracker_ConvertSpell[SpellID] or SpellID
			
			if ST.PrintEvent then
				print(Event, UserName, DestGUID, DestName, GetSpellLink(SpellID))
			end
			
	--		if (Event == 'SPELL_CAST_SUCCESS' or Event == 'SPELL_AURA_APPLIED') and UserName and UnitIsPlayer(UserName) and select(2, UnitClass(UserName)) == 'WARRIOR' and bit.band(UserFlag, (COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE)) ~= 0 then
	--			print(Event, UserName, GetSpellLink(SpellID), '분노 : ', UnitPower(UserName))
	--		end
			
			if not (SpellID and ST.TrackingSpell[SpellID]) or Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[SpellID] or bit.band(UserFlag, (COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE)) == 0 then return end
			
			UserName = string.split('-', UserName)
			
			if UserName then
				if not UnitIsPlayer(UserName) then -- find pet master
					if UnitName('pet') == UserName then
						UserName = E.myname
						UserGUID = E.myguid or UnitGUID('player')
					elseif Info.CurrentGroupMode ~= 'NoGroup' then
						if IsInRaid() and not UnitPlayerOrPetInRaid(UserName) then return
						elseif IsInGroup() and not UnitPlayerOrPetInParty(UserName) then return	end
						for i = 1, MAX_RAID_MEMBERS do
							if UnitExists(Info.CurrentGroupMode..i..'pet') and UnitIsUnit(UserName, Info.CurrentGroupMode..i..'pet') then
								UserName = UnitName(Info.CurrentGroupMode..i)
								UserGUID = UnitGUID(Info.CurrentGroupMode..i)
								break
							end
						end
					end
					
					if not UnitIsPlayer(UserName) then return end
				end
				
				_, UserClass = UnitClass(UserName)
			end
			
			if UserClass and Info.SmartTracker_Data[UserClass] and Info.SmartTracker_Data[UserClass][SpellID] and UserName and UserGUID and not (Info.SmartTracker_Data[UserClass][SpellID].NotToMe and UserName ~= E.myname) and
			   (Info.SmartTracker_Data[UserClass][SpellID].Event and Info.SmartTracker_Data[UserClass][SpellID].Event[Event] or not Info.SmartTracker_Data[UserClass][SpellID].Event and DefaultEventList[Event]) then
				if DestName then
					if GetPlayerInfoByGUID(DestGUID) then
						DestName = strsplit('-', DestName)
						DestColor = KF:Color_Class(select(2, GetPlayerInfoByGUID(DestGUID)), nil)
					else
						DestFlag = bit.band(DestFlag, COMBATLOG_OBJECT_REACTION_MASK)
						
						if DestFlag == 16 then
							DestColor = '|cff20ff20' --friendly
						else
							DestColor = '|cffcd4c37' --hostile
						end
					end
				end
				
				ST:RegisterCooldown(TimeStamp, Event, UserGUID, UserClass, UserName, SpellID, DestGUID, DestColor, DestName, Info.SmartTracker_Data[UserClass][SpellID].NeedParameter and { select(15, ...) } or nil)
			end
		end
	end
	
	
	function ST:SortData(UserGUID_A, UserGUID_B)
		local OrderTable = {}
		for i, Role in ipairs(KF.db.Modules.SmartTracker.SortOrder.Role) do
			OrderTable[Role] = i
		end
		for i, Class in ipairs(KF.db.Modules.SmartTracker.SortOrder.Class) do
			OrderTable[Class] = i
		end
		
		local Result
		local A = ST.CooldownCache[UserGUID_A]
		local B = ST.CooldownCache[UserGUID_B]
		
		if A.Spec and B.Spec then
			if Info.ClassRole[A.Class][A.Spec].Role == Info.ClassRole[B.Class][B.Spec].Role then
				Result = OrderTable[A.Class] < OrderTable[B.Class]
			else
				Result = OrderTable[Info.ClassRole[A.Class][A.Spec].Role] < OrderTable[Info.ClassRole[B.Class][B.Spec].Role]
			end
		elseif A.Spec then
			Result = true
		elseif B.Spec then
			Result = false
		else
			Result = OrderTable[A.Class] < OrderTable[B.Class]
		end
		
		return Result
	end
	
	
	function ST:RefreshCooldownCache()
		local HasData, NeedUpdateByCooldownCalcurating, NeedRedistributing
		local TimeNow = GetTime()
		
		for UserGUID, IsCooldownData in pairs(ST.CooldownCache) do
			if type(IsCooldownData) == 'table' then
				HasData = false
				
				for SpellID in pairs(ST.CooldownCache[UserGUID].List) do
					HasData = HasData or SpellID
					
					if ST.CooldownCache[UserGUID].List[SpellID][1].NeedCalculating then
						ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime, NeedUpdateByCooldownCalcurating = ST:CalculateCooldown(ST.CooldownCache[UserGUID].List[SpellID][1].Event, UserGUID, ST.CooldownCache[UserGUID].Name, ST.CooldownCache[UserGUID].Class, SpellID, ST.CooldownCache[UserGUID].List[SpellID][1].DestName, ST.CooldownCache[UserGUID].List[SpellID][1].ParamTable)
						
						if not NeedUpdateByCooldownCalcurating then
							ST.CooldownCache[UserGUID].List[SpellID][1].NeedCalculating = nil
							
							NeedRedistributing = NeedRedistributing or {}
							NeedRedistributing[SpellID] = true
						end
					end
					
					while ST.CooldownCache[UserGUID].List[SpellID][1] and (ST.CooldownCache[UserGUID].List[SpellID][1].EraseThisCooltimeCache or ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime - TimeNow <= 0) do
						if #ST.CooldownCache[UserGUID].List[SpellID] > 1 then
							ST.CooldownCache[UserGUID].List[SpellID][2].ActivateTime = ST.CooldownCache[UserGUID].List[SpellID][1].EraseThisCooltimeCache and TimeNow or ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime
						end
						
						--if KF.db.Modules.SmartTracker[Table['Cooldown_Cache'][UserGUID]['Class'] ][SpellID] == 3 and not ST.CooldownCache[UserGUID].List[SpellID][1].NoAnnounce then
						--	Func['Announcer'](UserGUID, SpellID)
						--end
						
						tremove(ST.CooldownCache[UserGUID].List[SpellID], 1)
						NeedRedistributing = NeedRedistributing or {}
						NeedRedistributing[SpellID] = true
					end
					
					if #ST.CooldownCache[UserGUID].List[SpellID] == 0 then
						ST.CooldownCache[UserGUID].List[SpellID] = nil
						
						if HasData == SpellID then
							HasData = false
						end
					end
				end
				
				if not HasData then
					ST.CooldownCache[UserGUID] = nil
					
					for i = 1, #ST.CooldownCache do
						if ST.CooldownCache[i] == UserGUID then
							tremove(ST.CooldownCache, i)
							break
						end
					end
				end
			end
		end
		
		if NeedRedistributing then
			local NeedUpdatingWindow = {}
			local NeedUpdatingIcon = {}
			
			for SpellID in pairs(NeedRedistributing) do
				for Tracker, TrackerType in pairs(ST.TrackingSpell[SpellID]) do
					if TrackerType == 'Window' then --and Tracker.NowDisplaying then
						NeedUpdatingWindow[Tracker.Name] = Tracker
					elseif TrackerType == 'Icon' then --and Tracker.NowDisplaying then
						NeedUpdatingIcon[Tracker.Name] = Tracker
					end
				end
			end
			
			for WindowName, Window in pairs(NeedUpdatingWindow) do
				ST:RedistributeCooldownData(Window)
			end
			
			for AnchorName, Anchor in pairs(NeedUpdatingIcon) do
				ST:RedistributeIconData(Anchor)
			end
		elseif HasData == nil then
			KF:CancelTimer('RefreshCooldownCache')
		end
	end
	
	
	function ST:RedistributeCooldownData(Window)
		local CurrentWheelLine = Window.CurrentWheelLine
		local DisplayableBarNum = floor((KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Height - ST.TAB_HEIGHT) / (KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Height - 1))
		local CurrentLine = Window.Reverse and DisplayableBarNum or 1
		local TimeNow = GetTime()
		
		local SpellID, UserGUID
		local Bar, NamePlateSet, BarExists
		local TotalSkipped = 0
		
		local List = {}
		for i = 1, #ST.CooldownCache do
			UserGUID = ST.CooldownCache[i]
			
			if not ST.CooldownCache[UserGUID].Spec or KF.db.Modules.SmartTracker.Window[Window.Name].Display.Filter[Info.ClassRole[ST.CooldownCache[UserGUID].Class][ST.CooldownCache[UserGUID].Spec].Role] then
				tinsert(List, { UserGUID = UserGUID, Name = ST.CooldownCache[UserGUID].Name })
				
				for SpellID in pairs(ST.CooldownCache[UserGUID].List) do
					if KF.db.Modules.SmartTracker.Window[Window.Name].SpellList[ST.CooldownCache[UserGUID].Class][SpellID] ~= false and not ST.CooldownCache[UserGUID].List[SpellID][1].Hidden then
						tinsert(List[#List], SpellID)
					end
				end
			end
		end
		
		Window.BarRemains = nil
		
		for i = Window.Reverse and #List or 1, Window.Reverse and 1 or #List, Window.Reverse and -1 or 1 do
			UserGUID = List[i].UserGUID
			BarExists = nil
			NamePlateSet = nil
			
			for k = Window.Reverse and #List[i] or 1, Window.Reverse and 1 or #List[i], Window.Reverse and -1 or 1 do
				SpellID = List[i][k]
				
				if BarExists == nil then BarExists = false end
				
				if not Window.Reverse and CurrentWheelLine > 0 then
					CurrentWheelLine = CurrentWheelLine - 1
					
					if CurrentLine + #List[i] < DisplayableBarNum then
						break
					end
				elseif CurrentLine > 0 and CurrentLine <= DisplayableBarNum then
					Bar = ST:Bar_Create(Window, CurrentLine)
					
					if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 'DOWN' and not NamePlateSet then
						Bar.Data = {
							FrameType = 'NamePlate',
							GUID = UserGUID,
						}
						
						if not Window.Reverse then
							NamePlateSet = true
							CurrentLine = CurrentLine + 1
						
							if CurrentLine <= DisplayableBarNum then
								--print('이름세팅 1번', List[i].Name)
								Bar = ST:Bar_Create(Window, CurrentLine)
							else
								--print('이름세팅 2번', List[i].Name)
								Window.BarRemains = true
								break
							end
						elseif not Window.ContainedBar[CurrentLine - 1] then
							--print('이름세팅 3번', List[i].Name)
							NamePlateSet = true
							
							if k == #List[i] then
								Bar.Data.ArrowUp = true
							end
						elseif k == 1 then
							--print('이름세팅 4번', List[i].Name)
							CurrentLine = CurrentLine - 1
							
							ST:Bar_Create(Window, CurrentLine).Data = {
								FrameType = 'NamePlate',
								GUID = UserGUID,
							}
						end
					--[[
					elseif KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 'UP' then
						if CurrentLine + 1 <= DisplayableBarNum then
							BarExists = true
							NamePlateSet = true
							
							ST:Bar_Create(Window, CurrentLine + 1).Data = {
								FrameType = 'NamePlate',
								GUID = UserGUID,
							}
						else
							NamePlateSet = nil
							
							Bar.Data = {
								FrameType = 'NamePlate',
								GUID = UserGUID,
							}
							
							if BarExists == false then
								Bar.Data.ArrowUp = true
							else
								Window.BarRemains = true
							end
						end
					]]
					end
					
					Bar.Fade = nil
					
					if not Window.Reverse and NamePlateSet or Window.Reverse and not NamePlateSet then
						BarExists = true
						
						Bar.Data = {
							FrameType = 'CooldownBar',
							GUID = UserGUID,
							SpellID = SpellID,
						}
						
						CurrentLine = CurrentLine + (Window.Reverse and -1 or 1)
						
						if not ST.CooldownCache[UserGUID].List[SpellID][1].ForbidFadeIn and ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.FADE_TIME > TimeNow then
							Bar.Fade = { Type = 'IN', Timer = TimeNow - ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime }
						elseif #ST.CooldownCache[UserGUID].List[SpellID] == 1 and (TimeNow > ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime - ST.FADE_TIME) then
							Bar.Fade = { Timer = TimeNow - ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime }
						end
					else
						CurrentLine = CurrentLine - 1
						Window.BarRemains = true
						
						if #List[i] < DisplayableBarNum then	-- 유저 통으로 스킵이 가능하면 CurrentWheelLine 을 1만 줄여야 되니까
							TotalSkipped = TotalSkipped + 1
						else
							TotalSkipped = TotalSkipped + k
						end
						break
					end
				else
					TotalSkipped = TotalSkipped + 1
					Window.BarRemains = true
					
					if not NamePlateSet then
						break
					end
				end
			end
			
			--if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_Direction == 'UP' and NamePlateSet then
			--	CurrentLine = CurrentLine + 1
			--end
			
			--if BarExists == false and CurrentLine == 1 then
			--	PrevUserExists = true
			--end
		end
		
		--print('RV= ', Window.Reverse and 'T' or 'F', ' / CL= ', CurrentLine, ' / WL= ', Window.CurrentWheelLine, ' / SK= ', TotalSkipped)
		if Window.Reverse then
			if CurrentLine > 0 then
				--print('종료 1번')
				Window.CurrentWheelLine = 0
				Window.Reverse = nil
				ST:RedistributeCooldownData(Window)
			else
				--print('종료 2번')
				Window.CurrentWheelLine = TotalSkipped
			end
		elseif Window.CurrentWheelLine > 0 and CurrentLine - 1--[[ + (PrevUserExists and 1 or 0)]] < DisplayableBarNum then
			--print('종료 3번')
			Window.Reverse = true
			ST:RedistributeCooldownData(Window)
		else
			--print('종료 4번')
			for BarNum = CurrentLine, #Window.ContainedBar do
				ST:Bar_Delete(Window, BarNum)
			end
		end
		
		for BarNum = DisplayableBarNum + 1, #Window.ContainedBar do
			ST:Bar_Delete(Window, BarNum)
		end
	end
	
	
	function ST:RedistributeIconData(Anchor)
	
	end
end


do	--<< Inspect System >>--
	ST.CheckPlayer = CreateFrame('Frame')
	ST.CheckPlayer:Hide()
	ST.CheckPlayer:SetScript('OnEvent', function(self, Event, ...)
		if Event == 'ACTIVE_TALENT_GROUP_CHANGED' or Event == 'PLAYER_SPECIALIZATION_CHANGED' then
			self.NeedCheckingSpec = true
			self.NeedCheckingGlyph = true
		elseif Event == 'GLYPH_ADDED' or Event == 'GLYPH_REMOVED' or Event == 'GLYPH_UPDATED' then
			self.NeedCheckingGlyph = true
		elseif Event == 'PLAYER_TALENT_UPDATE' then
			self.NeedCheckingSpec = true
		elseif Event == 'PLAYER_LEVEL_UP' then
			self.NeedCheckingLevel = true
		end
		
		self:Show()
	end)
	ST.CheckPlayer:SetScript('OnUpdate', function(self, elapsed)
		self.Elapsed = (self.Elapsed or 0) + elapsed
		
		if self.Elapsed > 0 then
			self.Elapsed = -.1
			self.NeedUpdate = nil
			
			if self.NeedCheckingSpec then
				self.NeedUpdate = ST:CheckPlayerSpec()
			end
			
			if self.NeedCheckingGlyph then
				self.NeedUpdate = ST:CheckPlayerGlyph() or self.NeedUpdate
			end
			
			if self.NeedCheckingLevel then
				self.NeedUpdate = ST:CheckPlayerLevel() or self.NeedUpdate
			end
			
			if not self.NeedUpdate then
				self.Elapsed = 0
				self:Hide()
			end
		end
	end)
	
	
	function ST:CheckPlayerSpec()
		wipe(ST.InspectCache[E.myguid].Talent)
		
		local Spec = GetSpecialization()
		local ActiveSpec = GetActiveSpecGroup()
		
		ST.InspectCache[E.myguid].Spec = Spec and Spec > 0 and select(2, GetSpecializationInfo(Spec)) or nil
		
		local Talent, IsSelected
		for i = 1, MAX_TALENT_TIERS do
			for k = 1, NUM_TALENT_COLUMNS do
				Talent, _, _, IsSelected = GetTalentInfo(i, k, ActiveSpec)
				
				if IsSelected then
					ST.InspectCache[E.myguid].Talent[Talent] = true
				end
			end
		end
		
		ST.CheckPlayer.NeedCheckingSpec = nil
	end
	
	
	function ST:CheckPlayerGlyph()
		wipe(ST.InspectCache[E.myguid].Glyph)
		
		local GlyphID
		local ActiveSpec = GetActiveSpecGroup()
		
		for SlotNum = 1, NUM_GLYPH_SLOTS do
			_, _, _, _, _, GlyphID = GetGlyphSocketInfo(SlotNum, ActiveSpec)
			
			if GlyphID then
				ST.InspectCache[E.myguid].Glyph[GlyphID] = true
			end
		end
		
		ST.CheckPlayer.NeedCheckingGlyph = nil
	end
	
	
	function ST:CheckPlayerLevel()
		ST.InspectCache[E.myguid].Level = UnitLevel('player')
		
		ST.CheckPlayer.NeedCheckingLevel = nil
	end
	
	
	do
		local UnitID, UserClass, UserName, Spec, Talent, IsSelected, GlyphID
		function ST:INSPECT_READY(UserGUID)
			if Info.CurrentGroupMode == 'NoGroup' then
				KF:UnregisterEventList('INSPECT_READY', 'SmartTracker')
				return
			end
			
			_, UserClass, _, _, _, UserName = GetPlayerInfoByGUID(UserGUID)
			
			if UserName == E.myname or not UnitExists(UserName) then return end
			print('INSPECT_READY', UserName)
			for i = 1, MAX_RAID_MEMBERS do
				if UnitName(Info.CurrentGroupMode..i) == UserName then
					UnitID = Info.CurrentGroupMode..i
					break
				end
			end
			
			if not ST.InspectCache[UserGUID] then
				ST.InspectCache[UserGUID] = {
					Name = UserName,
					Class = UserClass,
					Talent = {},
					Glyph = {}
				}
			else
				wipe(ST.InspectCache[UserGUID].Talent)
				wipe(ST.InspectCache[UserGUID].Glyph)
			end
			
			Spec = GetInspectSpecialization(UserName)
			ST.InspectCache[UserGUID].Spec = Spec and Spec > 0 and select(2, GetSpecializationInfoByID(Spec)) or nil
			
			for i = 1, MAX_TALENT_TIERS do
				for k = 1, NUM_TALENT_COLUMNS do
					Talent, _, _, IsSelected = GetTalentInfo(i, k, 1, true, UnitID)
					
					if IsSelected then
						ST.InspectCache[UserGUID].Talent[Talent] = true
					end
				end
			end
			
			for i = 1, NUM_GLYPH_SLOTS do
				_, _, _, _, _, GlyphID = GetGlyphSocketInfo(i, nil, true, UnitID)
				
				if GlyphID then
					ST.InspectCache[UserGUID].Glyph[GlyphID] = true
				end
			end
			
			ST.InspectCache[UserGUID].Level = UnitLevel(UserName)
			
			print('|cff2eb7e4INSPECT_READY|r : ', UserName, '설정검사 끝')
			ST.InspectOrder[UserName] = true
		end
	end
	
	
	do
		local InspectType, InspectTarget, DelayedMemberExists
		function ST:InspectGroup()
			ST.NowInspecting = true
			
			DelayedMemberExists = nil
			
			if KF.db.Modules.SmartTracker.Scan.UpdateInspectCache ~= false then
				InspectType = 'Updating'
				
				for MemberName in pairs(ST.InspectOrder) do
					if type(ST.InspectOrder[MemberName]) == 'number' or ST.InspectOrder[MemberName] == 'Delayed' then
						InspectType = 'Inspecting'
						break
					end
				end
			else
				InspectType = 'Inspecting'
			end
			
			if ST.CurrentInspectMemberUnitName then
				if not UnitExists(ST.CurrentInspectMemberUnitName) or not UnitIsConnected(ST.CurrentInspectMemberUnitName) or not (ST.InspectOrder[ST.CurrentInspectMemberUnitName] and ST.InspectOrder[ST.CurrentInspectMemberUnitName] ~= true) then
					ST.CurrentInspectMemberUnitName = nil
				else
					InspectTarget = InspectType == 'Updating' and tonumber(ST.InspectOrder[ST.CurrentInspectMemberUnitName]) or ST.InspectOrder[ST.CurrentInspectMemberUnitName]
					
					if type(InspectTarget) == 'number' then
						if InspectTarget >= 3 then
							ST.InspectOrder[ST.CurrentInspectMemberUnitName] = InspectType == 'Updating' and 'UpdateDelayed' or 'Delayed'
							ST.CurrentInspectMemberUnitName = nil
						elseif InspectType == 'Updating' then
							ST.InspectOrder[ST.CurrentInspectMemberUnitName] = tostring(InspectTarget + 1)
						else
							ST.InspectOrder[ST.CurrentInspectMemberUnitName] = InspectTarget + 1
						end
					else
						ST.CurrentInspectMemberUnitName = nil
					end
				end
			end
			
			if not ST.CurrentInspectMemberUnitName then
				ST.CurrentInspectMemberUnitName = nil
				
				for MemberName in pairs(ST.InspectOrder) do
					if not UnitExists(MemberName) then
						ST.InspectOrder[MemberName] = nil
					elseif ST.InspectOrder[MemberName] ~= true then
						InspectTarget = InspectType == 'Updating' and tonumber(ST.InspectOrder[MemberName]) or ST.InspectOrder[MemberName]
						
						if type(InspectTarget) == 'number' then
							if ST.CurrentInspectMemberUnitName == nil then
								ST.CurrentInspectMemberUnitName = false
							end
							
							if not (UnitIsConnected(MemberName) and InspectTarget < 3) then
								ST.InspectOrder[MemberName] = InspectType == 'Updating' and 'UpdateDelayed' or 'Delayed'
								DelayedMemberExists = true
							else
								if InspectType == 'Updating' then
									ST.InspectOrder[MemberName] = tostring(InspectTarget + 1)
								else
									ST.InspectOrder[MemberName] = InspectTarget + 1
								end
								
								ST.CurrentInspectMemberUnitName = MemberName
								break
							end
						elseif InspectType == 'Updating' and ST.InspectOrder[MemberName] == 'UpdateDelayed' or ST.InspectOrder[MemberName] == 'Delayed' then
							DelayedMemberExists = true
						end
					end
				end
			end
			
			if not ST.CurrentInspectMemberUnitName then
				if DelayedMemberExists and InspectType == 'Inspecting' then
					if ST.CurrentInspectMemberUnitName == nil then
						for MemberName in pairs(ST.InspectOrder) do
							if ST.InspectOrder[MemberName] == 'Delayed' then
								ST.InspectOrder[MemberName] = 0
							end
						end
					end
					
					return
				elseif KF.db.Modules.SmartTracker.Scan.UpdateInspectCache ~= false and InspectType == 'Updating' then
					local Check -- if false then just stop this function and if true then notice message.
					
					for MemberName in pairs(ST.InspectOrder) do
						if ST.InspectOrder[MemberName] == 'Update' then
							if not Check then
								Check = ST.CurrentInspectMemberUnitName == nil
							end
							
							ST.InspectOrder[MemberName] = '0'
						elseif ST.InspectOrder[MemberName] == 'UpdateDelayed' then
							if Check == nil then
								Check = false
							end
							
							if ST.CurrentInspectMemberUnitName == nil then
								ST.InspectOrder[MemberName] = '0'
							end
						end
					end
					
					if Check ~= nil or DelayedMemberExists then
						if Check == true then
							print(L['KF']..' : '..L["Now updating old member's setting."])
						end
						
						return
					end
				end
				
				--KnightRaidCooldown.InspectMembers.Number:SetText(nil)
				
				--if Value['Inspect_ScanByChanging'] == true then
				--	Value['Inspect_ScanByChanging'] = nil
				--else
					print(L['KF']..' : |cff2eb7e4'..L['Inspect Complete']..'|r. '..L["All members specialization, talent setting, glyph setting is saved. RaidCooldown will calcurating each spell's cooltime by this data.|r"])
				--end
				
				ST.NowInspecting = nil
				KF:UnregisterEventList('INSPECT_READY', 'SmartTracker')
				KF:CancelTimer('SmartTracker_InspectGroup')
			else
				--KnightRaidCooldown.InspectMembers.Number:SetText((InspectType == 'Updating' and '|cffceff00' or '|cff2eb7e4')..NeedUpdating)
				KF:RegisterEventList('INSPECT_READY', ST.INSPECT_READY, 'SmartTracker')
				NotifyInspect(ST.CurrentInspectMemberUnitName, nil, 3)
			end
		end
	end
	
	
	do
		local NeedInspecting, Old_NeedInspecting, AlreadyChecked = 0, 0, 0
		local Check, MemberName
		function ST:CheckGroupMember()
			--[[
			for MemberName in pairs(ST.InspectOrder) do
				if not UnitExists(MemberName) then
					ST.InspectOrder[MemberName] = nil
				end
			end
			]]
			Old_NeedInspecting = NeedInspecting
			NeedInspecting = 0
			AlreadyChecked = 0
			Check = nil
			
			for i = 1, MAX_RAID_MEMBERS do
				if UnitExists(Info.CurrentGroupMode..i) and not UnitIsUnit(Info.CurrentGroupMode..i, 'player') then
					MemberName = UnitName(Info.CurrentGroupMode..i)
					
					if MemberName then
						if MemberName == UNKNOWNOBJECT then
							return
						elseif ST.InspectOrder[MemberName] == true then
							AlreadyChecked = AlreadyChecked + 1
						else
							NeedInspecting = NeedInspecting + 1
							
							if not ST.InspectOrder[MemberName] then
								print('신입, 검사 필요 : ', MemberName)
								ST.InspectOrder[MemberName] = 0
								Check = true
							end
						end
					end
				end
			end
			
			if Check and (KF.db.Modules.SmartTracker.Scan.AutoScanning ~= false or ST.ForceUpdateAll) then
				if not ST.NowInspecting or ST.ForceUpdateAll then
					for MemberName in pairs(ST.InspectOrder) do
						if KF.db.Modules.SmartTracker.Scan.UpdateInspectCache ~= false and ST.InspectOrder[MemberName] == true and ST.InspectCache[UnitGUID(MemberName)] then
							print('업데이트 시작 : ', MemberName)
							ST.InspectOrder[MemberName] = 'Update'
						end
					end
					
					print(L['KF']..' : '..format(L["%s member's setting check start."], '|cffceff00'..NeedInspecting..'|r'))
				end
				
				ST.ForceUpdateAll = nil
				
				KF:RegisterTimer('SmartTracker_InspectGroup', 'NewTicker', 1, ST.InspectGroup, nil, true)
			end
			
			KF:CancelTimer('SmartTracker_CheckGroupMember')
		end
	end
	
	
	function ST:PrepareGroupInspect(ForceUpdateAll)
		if Info.CurrentGroupMode == 'NoGroup' then
			KF:UnregisterEventList('INSPECT_READY', 'SmartTracker')
			KF:CancelTimer('SmartTracker_CheckGroupMember')
			KF:CancelTimer('SmartTracker_InspectGroup')
			
			wipe(self.InspectOrder)
			self.NowInspectingMember = nil
			
			wipe(self.InspectCache)
			self.InspectCache[E.myguid] = {
				Name = E.myname,
				Class = E.myclass,
				Talent = {},
				Glyph = {}
			}
			self.CheckPlayer.NeedCheckingSpec = true
			self.CheckPlayer.NeedCheckingGlyph = true
			self.CheckPlayer.NeedCheckingLevel = true
			self.CheckPlayer:Show()
			
			self.GroupMemberCount = 0
			
			if KF.db.Modules.SmartTracker.General.EraseWhenUserLeftGroup ~= false then
				for UserGUID in pairs(self.CooldownCache) do
					if UserGUID ~= E.myguid and self.CooldownCache[UserGUID].List then
						for SpellID in pairs(self.CooldownCache[UserGUID].List) do
							for i = 1, #self.CooldownCache[UserGUID].List[SpellID] do
								self.CooldownCache[UserGUID].List[SpellID][i].EraseThisCooltimeCache = true
							end
						end
					end
				end
				
				self:RefreshCooldownCache()
			end
			return
		elseif ForceUpdateAll then
			wipe(self.InspectOrder)
			self.ForceUpdateAll = true
		end
		
		local MemberName, NeedRefresh
		for SavedGUID in pairs(self.InspectCache) do	-- Clear user that leaved party
			if SavedGUID ~= E.myguid then
				MemberName = self.InspectCache[SavedGUID].Name
				
				if not (UnitExists(MemberName) and UnitIsConnected(MemberName))then
					self.InspectCache[SavedGUID] = nil
					self.InspectOrder[MemberName] = nil
					
					if KF.db.Modules.SmartTracker.General.EraseWhenUserLeftGroup ~= false and self.CooldownCache[SavedGUID] then
						for SpellID in pairs(self.CooldownCache[SavedGUID].List) do
							for i = 1, #self.CooldownCache[SavedGUID].List[SpellID] do
								self.CooldownCache[SavedGUID].List[SpellID][i].EraseThisCooltimeCache = true
							end
						end
					end
					
					NeedRefresh = true
				end
			end
		end
		
		if NeedRefresh then
			self:RefreshCooldownCache()
		end
		
		self.GroupMemberCount = GetNumGroupMembers()
		KF:RegisterTimer('SmartTracker_CheckGroupMember', 'NewTicker', .5, ST.CheckGroupMember, nil, true)
	end
end


KF.Modules[#KF.Modules + 1] = 'SmartTracker'
KF.Modules.SmartTracker = function(RemoveOrder)
	for WindowName in pairs(KF.UIParent.ST_Window) do
		ST:Window_Delete(WindowName, true)
	end
	
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable ~= false then
		Info.SmartTracker_Activate = true
		
		if ST.Setup_MainWindow then
			ST:Setup_MainWindow()
		end
		
		for WindowName, IsWindowData in pairs(KF.db.Modules.SmartTracker.Window) do
			if type(IsWindowData) == 'table' then
				ST:Window_Create(WindowName)
			end
		end
		
		for AnchorName, IsAnchorData in pairs(KF.db.Modules.SmartTracker.Icon) do
			if type(IsAnchorData) == 'table' then
				ST:IconAnchor_Create(AnchorName)
			end
		end
		
		E.myguid = E.myguid or UnitGUID('player')
		ST.InspectCache[E.myguid] = ST.InspectCache[E.myguid] or {
			Name = E.myname,
			Class = E.myclass,
			Talent = {},
			Glyph = {}
		}
		ST.CheckPlayer.NeedCheckingSpec = true
		ST.CheckPlayer.NeedCheckingGlyph = true
		ST.CheckPlayer.NeedCheckingLevel = true
		ST.CheckPlayer:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		ST.CheckPlayer:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
		ST.CheckPlayer:RegisterEvent('GLYPH_ADDED')
		ST.CheckPlayer:RegisterEvent('GLYPH_REMOVED')
		ST.CheckPlayer:RegisterEvent('GLYPH_UPDATED')
		ST.CheckPlayer:RegisterEvent('PLAYER_TALENT_UPDATE')
		ST.CheckPlayer:RegisterEvent('PLAYER_LEVEL_UP')
		ST.CheckPlayer:Show()
		
		ST:PrepareGroupInspect(true)
		
		KF:RegisterEventList('UNIT_SPELLCAST_SUCCEEDED', ST.UNIT_SPELLCAST_SUCCEEDED, 'SmartTracker')
		KF:RegisterEventList('COMBAT_LOG_EVENT_UNFILTERED', ST.COMBAT_LOG_EVENT_UNFILTERED, 'SmartTracker')
		KF:RegisterCallback('GroupChanged', function() ST:PrepareGroupInspect() end, 'SmartTracker_PrepareGroupInspect')
		KF:RegisterEventList('GROUP_ROSTER_UPDATE', function() ST:PrepareGroupInspect() end, 'SmartTracker_PrepareGroupInspect')
		KF:RegisterEventList('READY_CHECK', function() ST:PrepareGroupInspect(true) end, 'SmartTracker_PrepareGroupInspect')
	else
		Info.SmartTracker_Activate = nil
		
		wipe(ST.InspectOrder)
		wipe(ST.InspectCache)
		wipe(ST.CooldownCache)
		
		ST.CheckPlayer:UnregisterAllEvents()
		ST.CheckPlayer:Hide()
		
		KF:UnregisterEventList('UNIT_SPELLCAST_SUCCEEDED', 'SmartTracker')
		KF:UnregisterEventList('COMBAT_LOG_EVENT_UNFILTERED', 'SmartTracker')
		KF:UnregisterEventList('UNIT_SPELLCAST_SUCCEEDED', 'SmartTracker_PrepareGroupInspect')
		KF:UnregisterEventList('COMBAT_LOG_EVENT_UNFILTERED', 'SmartTracker_PrepareGroupInspect')
	end
end


function KF:Test()
	ST.PrintEvent = not ST.PrintEvent
end