local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

local WindowCount = 0
local AnchorCount = 0

--------------------------------------------------------------------------------
--<< KnightFrame : Smart Tracker											>>--
--------------------------------------------------------------------------------
local ST = SmartTracker or CreateFrame('Frame', 'SmartTracker', KF.UIParent)
local ENI = _G['EnhancedNotifyInspect'] or { CancelInspect = function() end }

ST.DropDownInfo = {}

ST.DeletedWindow = {}
ST.DeletedBar = {}
ST.DeletedIcon = {}
ST.DeletedAnchor = {}

ST.TrackingSpell = {}
ST.WarriorRageTracker = {}

ST.InspectOrder = {}
ST.InspectCache = {}
ST.CooldownCache = {}

ST.DeadList = {}
ST.ResurrectionList = {}

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
				--print('아래로 굴림')
				Window.CurrentWheelLine = Window.CurrentWheelLine + 1
			elseif Spinning == 1 and Window.CurrentWheelLine > 0 then
				--print('위로 굴림')
				Window.CurrentWheelLine = Window.CurrentWheelLine - 1
				Window.Reverse = nil
			else
				--print('리턴됨')
				return
			end
		end
		
		ST:RedistributeCooldownData(Window)
	end
	
	
	function ST:Tab_OnEnter()
		local Window = self:GetParent()
		
		ST.ToggleDisplayButton:SetParent(Window)
		ST.ToggleDisplayButton:Point('RIGHT', self, -2, 0)
		ST.ToggleDisplayButton:SetAlpha(1)
		ST.ToggleDisplayButton:SetFrameLevel(4)
		ST.ToggleDisplayButton:SetFrameStrata('HIGH')
		ST.ToggleDisplayButton:Show()
		
		if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Show then
			ST.ToggleDisplayButton.Texture:SetTexCoord(.25, .5, 0, 1)
		else
			ST.ToggleDisplayButton.Texture:SetTexCoord(0, .25, 0, 1)
		end
		
		self:SetScript('OnUpdate', ST.Tab_OnUpdate)
	end
	
	
	function ST:Tab_OnUpdate()
		if not self:IsMouseOver() then
			ST.ToggleDisplayButton:SetParent(nil)
			ST.ToggleDisplayButton:ClearAllPoints()
			ST.ToggleDisplayButton:SetAlpha(0)
			ST.ToggleDisplayButton:Hide()
			
			self:SetScript('OnUpdate', nil)
		end
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
	
	
	function ST:ToggleDisplay_OnEnter()
		if not self then return end
		
		local Window = self:GetParent()
		if not (Window and KF.db.Modules.SmartTracker.Window[Window.Name]) then return end
		
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
		GameTooltip:ClearLines()
		GameTooltip:Point('LEFT', self, 'RIGHT')
		
		if KF.db.Modules.SmartTracker.Window[self:GetParent().Name].Appearance.Area_Show then
			GameTooltip:AddLine(L['Lock Display Area.'], 1, 1, 1)
		else
			GameTooltip:AddLine(L['Unlock Display Area.'], 1, 1, 1)
		end
		
		GameTooltip:Show()
	end
	
	
	function ST:ToggleDisplay_OnLeave()
		GameTooltip:Hide()
	end
	
	
	function ST:ToggleDisplay_OnClick()
		if not self then return end
		
		local Window = self:GetParent()
		
		if not (Window and KF.db.Modules.SmartTracker.Window[Window.Name]) then return end
		
		ST:ToggleDisplay(Window)
		ST.ToggleDisplay_OnEnter(self)
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
		Window:SetAlpha(0)
		Window:Hide()
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
		KF:TextSetting(Window.Tab, nil, { FontSize = 10, FontStyle = 'OUTLINE', directionH = 'LEFT' }, 'LEFT', 4, 0)
		Window.Tab:SetScript('OnEnter', self.Tab_OnEnter)
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
		if KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Show then
			KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Show = false
			self.ToggleDisplayButton.Texture:SetTexCoord(0, .25, 0, 1)
			
			print(L['KF']..' : '..L['Lock Display Area.'])
		else
			KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Show = true
			self.ToggleDisplayButton.Texture:SetTexCoord(.25, .5, 0, 1)
			
			print(L['KF']..' : '..L['Unlock Display Area.'])
		end
		
		self:SetWindowDisplayingStatus(Window)
	end
	
	
	function ST:SetWindowDisplayingStatus(Window)
		if KF.db.Modules.SmartTracker.Window[Window.Name].Enable and KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Area_Show then
			Window.DisplayArea:Show()
			Window.DisplayArea:SetAlpha(Window:GetAlpha())
		else
			Window.DisplayArea:SetAlpha(0)
			Window.DisplayArea:Hide()
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
				
				wipe(Window.ContainedBar)
				
				Window:Show()
				
				self.DeletedWindow[#self.DeletedWindow] = nil
			else
				WindowCount = WindowCount + 1
				
				Window = self:Window_Setup(CreateFrame('Frame', 'ST_Window_'..WindowCount, KF.UIParent), WindowCount)
				
				KF.UIParent.ST_Window[WindowName] = Window
				
				E:CreateMover(Window, 'ST_Window_'..Window.Count..'_Mover', nil, nil, nil, nil, 'ALL,KF,KF_SmartTracker')
				Window:SetScript('OnSizeChanged', self.OnSizeChanged)
			end
			E.CreatedMovers[Window.mover.name].point = E:HasMoverBeenMoved(WindowName) and E.db.movers[WindowName] or KF.db.Modules.SmartTracker.Window[WindowName].Appearance.Location or 'CENTERElvUIParent'
			Window.mover:ClearAllPoints()
			Window.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Window.mover.name].point)}))
			
			--초기화 여기서
			Window.Name = WindowName
			Window.CurrentWheelLine = 0
			
			self:SetDisplay('Window', 'ST_Window', WindowName, Window)
			self:BuildTrackingSpellList(WindowName)
			self:RedistributeCooldownData(Window)
			self:SetWindowDisplayingStatus(Window)
		end
		
		-- Setting
		self:Window_Size(Window)
		self:Window_ChangeBarGrowDirection(Window)
		
		-- Colorize
		Window.Tab:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[WindowName].Appearance.Color_WindowTab))
		
		Window.mover.text:SetText(L['SmartTracker_WindowTag']..WindowName)
		
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
			self:SetDisplay('Window', 'ST_Window', WindowName, Window)
			self:SetWindowDisplayingStatus(Window)
			
			local moverData = E.CreatedMovers[Window.mover.name]
			Window.MoverData = moverData
			E.CreatedMovers[Window.mover.name] = nil
			
			if SaveProfile then
				E:SaveMoverPosition(Window.mover.name)
				E.db.movers[WindowName] = E.db.movers[Window.mover.name]
			else
				E.db.movers[WindowName] = nil
			end
			
			if WindowName ~= L['SmartTracker_MainWindow'] then
				E.db.movers[Window.mover.name] = nil
			end
			
			self.DeletedWindow[#self.DeletedWindow + 1] = Window
			KF.UIParent.ST_Window[WindowName] = nil
			
			self:BuildTrackingSpellList()
		end
	end
	
	
	function ST:Setup_MainWindow()
		KF.UIParent.ST_Window[(L['SmartTracker_MainWindow'])] = self:Window_Setup(self, 1)
		
		if KF.db.Modules.SmartTracker.Window[(L['SmartTracker_MainWindow'])].Appearance.Location then
			self:SetPoint(unpack({string.split('\031', KF.db.Modules.SmartTracker.Window[(L['SmartTracker_MainWindow'])].Appearance.Location)}))
			--KF.db.Modules.SmartTracker.Window[1].Location = nil
		else
			self:Point('CENTER')
		end
		
		E:CreateMover(self, L['SmartTracker_MainWindow'], L['SmartTracker_WindowTag']..L['SmartTracker_MainWindow'], nil, nil, nil, 'ALL,KF,KF_SmartTracker')
		self:SetScript('OnSizeChanged', self.OnSizeChanged)
		
		self.Name = L['SmartTracker_MainWindow']
		self.CurrentWheelLine = 0
		self.ContainedBar = {}
		
		self:SetDisplay('Window', 'ST_Window', L['SmartTracker_MainWindow'], self)
		self:BuildTrackingSpellList(L['SmartTracker_MainWindow'])
		self:RedistributeCooldownData(self)
		self:SetWindowDisplayingStatus(self)
		
		self.ToggleDisplayButton = CreateFrame('Button')
		self.ToggleDisplayButton:Size(ST.TAB_HEIGHT - 8)
		self.ToggleDisplayButton.Texture = self.ToggleDisplayButton:CreateTexture(nil, 'OVERLAY')
		self.ToggleDisplayButton.Texture:SetInside()
		self.ToggleDisplayButton.Texture:SetTexture('Interface\\Glues\\CharacterSelect\\Glues-AddOn-Icons')
		self.ToggleDisplayButton:SetScript('OnEnter', ST.ToggleDisplay_OnEnter)
		self.ToggleDisplayButton:SetScript('OnLeave', ST.ToggleDisplay_OnLeave)
		self.ToggleDisplayButton:SetScript('OnClick', ST.ToggleDisplay_OnClick)
		
		self.BrezTracker = CreateFrame('Frame')
		self.BrezTracker:SetScript('OnUpdate', ST.ResurrectionTracking)
		
		self.Menu = CreateFrame('Frame', 'SmartTrackerDropDownMenu', E.UIParent, 'UIDropDownMenuTemplate')
		
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
			self.TooltipDisplayed = nil
			GameTooltip:Hide()
		end
	end
	
	
	function ST:BarIcon_OnClick(Button)
		local Bar = self:GetParent()
		
		if not (Button == 'RightButton' and Bar.Data and Bar.Data.FrameType ~= 'NamePlate') then
			return
		else
			if self.TooltipDisplayed then
				self.TooltipDisplayed = nil
				GameTooltip:Hide()
			end
			
			if IsShiftKeyDown() then
				local Window = Bar:GetParent()
				
				do	-- Modify TrackingSpell List
					ST.TrackingSpell[Bar.Data.SpellID][Window] = nil
					
					if not next(ST.TrackingSpell[Bar.Data.SpellID]) then
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
			
			if KF.db.Modules.SmartTracker.General.DetailSpellTooltip == true or IsShiftKeyDown() then
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
			
			--|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\arrow:10:10:-4:-1:64:64:0:64:0:64:206:255:0|t
			self.Text:SetText('|cffceff00'..(self.Data.ArrowUp and '▲|r ' or '▼|r ')..KF:Color_Class(ST.CooldownCache[UserGUID].Class, ST.CooldownCache[UserGUID].Name)..ST:GetUserRoleIcon(UserGUID))
		elseif self.Data.FrameType == 'CooldownBar' and ST.CooldownCache[UserGUID] and ST.CooldownCache[UserGUID].List[tonumber(self.Data.SpellID)] then
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
						self.CooldownBar:SetStatusBarColor(unpack(KF.db.Modules.SmartTracker.ClassColor[strupper(ST.CooldownCache[UserGUID].Class)][1]))
						self:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.ClassColor[strupper(ST.CooldownCache[UserGUID].Class)][2]))
					else
						self.CooldownBar:SetStatusBarColor(unpack(KF.db.Modules.SmartTracker.ClassColor[strupper(ST.CooldownCache[UserGUID].Class)][2]))
						self:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.ClassColor[strupper(ST.CooldownCache[UserGUID].Class)][1]))
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
		else
			ST:RedistributeCooldownData(Window)
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
		
		KF:TextSetting(Bar.CooldownBar, nil, { Tag = 'Time', FontSize = KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_FontSize, FontStyle = 'OUTLINE', directionH = 'RIGHT', }, 'RIGHT', Bar.CooldownBar, -2, 0)
		Bar.Time = Bar.CooldownBar.Time
		
		KF:TextSetting(Bar.CooldownBar, nil, { FontSize = KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Bar_FontSize, FontStyle = 'OUTLINE', directionH = 'LEFT', }, 'LEFT', Bar.CooldownBar, 5, 0)
		Bar.Text = Bar.CooldownBar.text
		Bar.Text:Point('RIGHT', Bar.Time, 'LEFT', -5, 0)
		
		Bar.Data = {}
		
		return Bar
	end
	
	
	function ST:Bar_Create(Window, BarNum)
		local Bar = Window.ContainedBar[BarNum]
		
		if not Bar then
			if #self.DeletedBar > 0 then
				Window.ContainedBar[BarNum] = self.DeletedBar[#self.DeletedBar]
				Window.ContainedBar[BarNum]:Show()
				wipe(Window.ContainedBar[BarNum].Data)
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
		end
	end
	
	
	function ST:Bar_Delete(Window, BarNum)
		local Bar = Window.ContainedBar[BarNum]
		
		if Bar then
			Bar:SetAlpha(1)
			Bar:SetScript('OnUpdate', nil)
			wipe(Bar.Data)
			Bar:Hide()
			
			self.DeletedBar[#self.DeletedBar + 1] = Window.ContainedBar[BarNum]
			Window.ContainedBar[BarNum] = nil
		end
	end
end


do	--<< About Icon >>--
	function ST:Icon_OnEnter()
		self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
		self.DisplayTooltip = true
	end
	
	
	function ST:Icon_OnLeave()
		self:SetBackdropBorderColor(unpack(E.media.bordercolor))
		
		if self.DisplayTooltip then
			self.DisplayTooltip = nil
			GameTooltip:Hide()
		end
	end
	
	
	function ST:Icon_OnClick(Button)
		if Button == 'RightButton' then
			CloseDropDownMenus()
			
			if SmartTrackerDropDownMenu.initialize ~= ST.IconDropdownMenu_Initialize then
				SmartTrackerDropDownMenu.initialize = ST.IconDropdownMenu_Initialize
			end
			
			SmartTrackerDropDownMenu.Icon = self
			SmartTrackerDropDownMenu.SpellName = self.SpellName
			SmartTrackerDropDownMenu.Anchor = self:GetParent()
			
			ToggleDropDownMenu(1, nil, SmartTrackerDropDownMenu, 'cursor', -10, 10, nil, nil, 1)
		end
	end
	
	
	function ST:Icon_OnUpdate()
		if self.DisplayTooltip then
			GameTooltip:ClearLines()
			
			if self.Link and (KF.db.Modules.SmartTracker.General.DetailSpellTooptip == true or IsShiftKeyDown()) then
				GameTooltip:SetHyperlink(self.Link)
				GameTooltip:AddLine('|n|cff2eb7e4▶|r '..L['Castable User'], 1, 1, 1)
			elseif self.SpellName then
				GameTooltip:AddLine(KF:Color_Value('>> ')..self.SpellName..KF:Color_Value(' <<'), 1, 1, 1)
			end
		end
		
		local UserName, TotalNow, TotalCount, MaxBrez, Time, ShortestTime, Disable, IsUnitDead
		local SpellNow, SpellCount = 0, 0
		local TimeNow = GetTime()
		
		TotalNow, MaxBrez, Time, ShortestTime = GetSpellCharges(20484)
		
		if self.SpellName == L['Battle Resurrection'] then
			if TotalNow then
				ShortestTime = ShortestTime - (GetTime() - Time)
			
				if self.DisplayTooltip then
					GameTooltip:AddDoubleLine('  |cff2eb7e4'..L['Brez Available']..'|r :', (TotalNow == 0 and '|cffff5252' or '')..TotalNow, 1, 1, 1, 1, 1, 1)
					GameTooltip:AddDoubleLine('  |cff2eb7e4'..L['Now Charging']..'|r :', ST:GetTimeFormat(ShortestTime), 1, 1, 1, 1, 1, 1)
				end
			end
			
			if self.DisplayTooltip then
				for i = 1, #ST.ResurrectionList do
					if i == 1 then
						GameTooltip:AddLine('|n|cff2eb7e4▶|r '..L['Resurrection Situation'], 1, 1, 1)
					end
					
					GameTooltip:AddDoubleLine(
						' '..i..'. '..ST:GetUserRoleIcon(ST.ResurrectionList[i].DestGUID)..' '..ST.ResurrectionList[i].DestColor..ST.ResurrectionList[i].DestName
						,
						'from '..KF:Color_Class(ST.ResurrectionList[i].UserClass, ST.ResurrectionList[i].UserName)..' '..ST:GetUserRoleIcon(ST.ResurrectionList[i].UserGUID)
					, 1, 1, 1, 1, 1, 1)
				end
			end
		end
		
		if not (self.SpellName == L['Battle Resurrection'] and TotalNow) then
			TotalNow, TotalCount, MaxBrez = 0, 0, nil
			
			for SpellID in pairs(self.Data) do
				ShortestTime = nil
				
				if self.DisplayTooltip and not (self.Link and (KF.db.Modules.SmartTracker.General.DetailSpellTooptip == true or IsShiftKeyDown())) then
					GameTooltip:AddLine(((self.SpellName or UserName) and '|n' or '')..'|cff2eb7e4▶|r '..GetSpellInfo(SpellID), 1, 1, 1)
				end
				
				for _, UserGUID in pairs(self.Data[SpellID]) do
					if ST.InspectCache[UserGUID] then
						UserName = ST.InspectCache[UserGUID].Name
						
						SpellCount = ST:CheckSpellChargeCondition(UserGUID, UserName, ST.InspectCache[UserGUID].Class, SpellID) or 1
						SpellNow = SpellCount
						
						if ST.CooldownCache[UserGUID] and ST.CooldownCache[UserGUID].List[SpellID] then
							Time = ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime - TimeNow
							SpellNow = SpellNow - #ST.CooldownCache[UserGUID].List[SpellID]
							
							if not ShortestTime or Time < ShortestTime then
								ShortestTime = Time
							end
						end
						
						TotalNow = TotalNow + SpellNow
						TotalCount = TotalCount + SpellCount
						IsUnitDead = UnitIsDeadOrGhost(UserName)
						
						if self.DisplayTooltip then
							GameTooltip:AddDoubleLine(
								'  '..ST:GetUserRoleIcon(UserGUID)..' '..(IsUnitDead and '|cff778899'..UserName..' ('..DEAD..')' or KF:Color_Class(ST.InspectCache[UserGUID].Class, UserName))
								,
								SpellNow > 0 and '|cff2eb7e4'..L['Enable To Cast']..(SpellCount > 1 and '|r ('..SpellNow..')' or '') or ST:GetTimeFormat(Time)
							, 1, 1, 1, 1, 1, 1)
						end
						
						if not Disable then
							Disable = IsUnitDead
						end
					end
				end
			end
		end
		
		if TotalCount == 0 then
			ST:DistributeIconData(self:GetParent())
		else
			self.SpellIcon:SetAlpha(TotalNow > 0 and 1 or .3)
			self.text:SetText(TotalNow == 0 and '|cffff5252'..ST:GetTimeFormat(ShortestTime) or TotalNow..(not MaxBrez and KF.db.Modules.SmartTracker.Icon[self:GetParent().Name].Appearance.DisplayMax ~= false and '/'..TotalCount or ''))
			self.SpellIcon:SetDesaturated(Disable)
			
			if self.SpellName then
				if TotalNow == 0 then
					self:SetBackdropColor(1, .1, .1)
				else
					self:SetBackdropColor(.8, .8, .8)
				end
			end
			
			if self.DisplayTooltip then
				GameTooltip:Show()
			end
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
		Icon:SetBackdropBorderColor(unpack(E.media.bordercolor))
		Icon:SetScript('OnEnter', ST.Icon_OnEnter)
		Icon:SetScript('OnLeave', ST.Icon_OnLeave)
		Icon:SetScript('OnClick', ST.Icon_OnClick)
		Icon:RegisterForClicks('RightButtonUp')
		
		Icon.SpellIconFrame = CreateFrame('Frame', nil, Icon)
		Icon.SpellIconFrame:SetBackdrop({
			bgFile = E.media.blankTex,
			edgeFile = E.media.blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		Icon.SpellIconFrame:SetFrameLevel(4)
		Icon.SpellIconFrame:SetBackdropColor(0, 0, 0)
		Icon.SpellIconFrame:EnableMouse(false)
		
		Icon.SpellIcon = Icon.SpellIconFrame:CreateTexture(nil, 'OVERLAY')
		Icon.SpellIcon:SetInside()
		
		Icon.Data = {}
		
		KF:TextSetting(Icon.SpellIconFrame, nil, { FontSize = KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.FontSize, FontStyle = 'OUTLINE', directionH = 'RIGHT' }, 'BOTTOMRIGHT', Icon, -1, 2)
		Icon.text = Icon.SpellIconFrame.text
		--Icon.text:Point('LEFT', Icon)
		
		return Icon
	end
	
	
	function ST:Icon_Create(Anchor, IconNum)
		local Icon = Anchor.ContainedIcon[IconNum]
		
		if not Icon then
			if #self.DeletedIcon > 0 then
				Anchor.ContainedIcon[IconNum] = self.DeletedIcon[#self.DeletedIcon]
				self.DeletedIcon[#self.DeletedIcon] = nil
				wipe(Anchor.ContainedIcon[IconNum].Data)
				Anchor.ContainedIcon[IconNum]:Show()
			else
				Anchor.ContainedIcon[IconNum] = self:Icon_Setup(CreateFrame('Button'), Anchor)
			end
			
			Icon = Anchor.ContainedIcon[IconNum]
			Icon:SetParent(Anchor)
			Icon:SetScript('OnUpdate', ST.Icon_OnUpdate)
			
			Icon.Num = IconNum
			ST:Icon_Size(Anchor, IconNum)
		end
		
		return Icon
	end
	
	
	function ST:Icon_Delete(Anchor, IconNum)
		local Icon = Anchor.ContainedIcon[IconNum]
		
		if Icon then
			Icon:SetScript('OnUpdate', nil)
			wipe(Icon.Data)
			Icon:Hide()
			
			self.DeletedIcon[#self.DeletedIcon + 1] = Anchor.ContainedIcon[IconNum]
			Anchor.ContainedIcon[IconNum] = nil
		end
	end
	
	
	function ST:Icon_Size(Anchor, StartNum)
		local Icon
		local TexCoord = { unpack(E.TexCoords) }
		
		if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width ~= KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height then
			local Diff
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width > KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height then
				Diff = (KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width - KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height) / KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width / 2
				TexCoord[3] = Diff
				TexCoord[4] = 1 - Diff
			else
				Diff = (KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height - KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width) / KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height / 2
				TexCoord[1] = Diff
				TexCoord[2] = 1 - Diff
			end
		end
		
		for IconNum = (StartNum or 1), StartNum or #Anchor.ContainedIcon do
			Icon = Anchor.ContainedIcon[IconNum]
			
			Icon:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height)
			Icon.SpellIcon:SetTexCoord(unpack(TexCoord))
		end
	end
	
	
	function ST:Icon_Rearrange(Anchor)
		local Icon
		local Point, SecondaryPoint, X, Y
		local Spacing = KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing
		
		if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Arrangement == 'Center' then
			local OddNumberMode = #Anchor.ContainedIcon % 2 > 0
			local LeftAnchor, CenterAnchor, RightAnchor
			
			if OddNumberMode then
				CenterAnchor = ceil(#Anchor.ContainedIcon / 2)
				
				Icon = Anchor.ContainedIcon[CenterAnchor]
				Icon:ClearAllPoints()
				Icon:Point('CENTER', Anchor)
			else
				LeftAnchor = #Anchor.ContainedIcon / 2
				RightAnchor = LeftAnchor + 1
				
				Icon = Anchor.ContainedIcon[LeftAnchor]
				Icon:ClearAllPoints()
				
				if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Orientation == 'Horizontal' then
					Icon:Point('RIGHT', Anchor, 'CENTER', -Spacing / 2, 0)
				else
					Icon:Point('BOTTOM', Anchor, 'CENTER', 0, Spacing / 2)
				end
				
				Icon = Anchor.ContainedIcon[RightAnchor]
				Icon:ClearAllPoints()
				
				if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Orientation == 'Horizontal' then
					Icon:Point('LEFT', Anchor, 'CENTER', Spacing / 2, 0)
				else
					Icon:Point('TOP', Anchor, 'CENTER', 0, -Spacing / 2)
				end
			end
			
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Orientation == 'Horizontal' then
				Point = 'RIGHT'
				SecondaryPoint = 'LEFT'
				X = -Spacing
				Y = 0
			else
				Point = 'BOTTOM'
				SecondaryPoint = 'TOP'
				X = 0
				Y = Spacing
			end
			
			for IconNum = (LeftAnchor or CenterAnchor) - 1, 1, -1 do
				Icon = Anchor.ContainedIcon[IconNum]
				Icon:ClearAllPoints()
				Icon:Point(Point, Anchor.ContainedIcon[IconNum + 1], SecondaryPoint, X, Y)
			end
			
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Orientation == 'Horizontal' then
				Point = 'LEFT'
				SecondaryPoint = 'RIGHT'
				X = Spacing
				Y = 0
			else
				Point = 'TOP'
				SecondaryPoint = 'BOTTOM'
				X = 0
				Y = -Spacing
			end
			
			for IconNum = (RightAnchor or CenterAnchor) + 1, #Anchor.ContainedIcon do
				Icon = Anchor.ContainedIcon[IconNum]
				Icon:ClearAllPoints()
				Icon:Point(Point, Anchor.ContainedIcon[IconNum - 1], SecondaryPoint, X, Y)
			end
		else
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Arrangement == 'Left to Right' then
				Point = 'LEFT'
				SecondaryPoint = 'RIGHT'
				X = Spacing
				Y = 0
			elseif KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Arrangement == 'Right to Left' then
				Point = 'RIGHT'
				SecondaryPoint = 'LEFT'
				X = -Spacing
				Y = 0
			elseif KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Arrangement == 'Top To Bottom' then
				Point = 'TOP'
				SecondaryPoint = 'BOTTOM'
				X = 0
				Y = -Spacing
			elseif KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Arrangement == 'Bottom To Top' then
				Point = 'BOTTOM'
				SecondaryPoint = 'TOP'
				X = 0
				Y = Spacing
			end
			
			for IconNum = 1, #Anchor.ContainedIcon do
				Icon = Anchor.ContainedIcon[IconNum]
				Icon:ClearAllPoints()
				
				if IconNum == 1 then
					Icon:Point(Point, Anchor)
				else
					Icon:Point(Point, Anchor.ContainedIcon[IconNum - 1], SecondaryPoint, X, Y)
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
			if #self.DeletedAnchor > 0 then
				KF.UIParent.ST_Icon[AnchorName] = self.DeletedAnchor[#self.DeletedAnchor]
				
				Anchor = KF.UIParent.ST_Icon[AnchorName]
				
				E.CreatedMovers[Anchor.mover.name] = Anchor.MoverData
				Anchor.MoverData = nil
				
				wipe(Anchor.ContainedIcon)
				wipe(Anchor.Group)
				
				Anchor:Show()
				
				self.DeletedAnchor[#self.DeletedAnchor] = nil
			else
				AnchorCount = AnchorCount + 1
				
				Anchor = CreateFrame('Frame', 'ST_IconAnchor_'..AnchorCount, KF.UIParent)
				Anchor:Point('CENTER')
				Anchor:SetAlpha(0)
				Anchor:Hide()
				Anchor.Count = AnchorCount
				Anchor.ContainedIcon = {}
				Anchor.Group = {}
				
				KF.UIParent.ST_Icon[AnchorName] = Anchor
				
				E:CreateMover(Anchor, 'ST_Icon_'..Anchor.Count..'_Mover', nil, nil, nil, nil, 'ALL,KF,KF_SmartTracker')
			end
			
			E.CreatedMovers[Anchor.mover.name].point = E:HasMoverBeenMoved(AnchorName) and E.db.movers[AnchorName] or KF.db.Modules.SmartTracker.Icon[AnchorName].Appearance.Location or 'CENTERElvUIParent'
			Anchor.mover:ClearAllPoints()
			Anchor.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Anchor.mover.name].point)}))
			
			--초기화 여기서
			Anchor.Name = AnchorName
			
			self:SetDisplay('Icon', 'ST_Icon', AnchorName, Anchor)
			self:BuildTrackingSpellList(AnchorName)
			self:DistributeIconData(Anchor)
		end
		
		-- Update AnchorSize
		self:IconAnchor_Size(Anchor)
		
		Anchor.mover.text:SetText(L['SmartTracker_IconTag']..AnchorName)
		
		if E.ConfigurationMode then
			Anchor.mover:Show()
		end
	end
	
	
	function ST:IconAnchor_Delete(AnchorName, SaveProfile)
		local Anchor = KF.UIParent.ST_Icon[AnchorName]
		
		if Anchor then
			self:SetDisplay('Icon', 'ST_Icon', AnchorName, Anchor)
			
			local moverData = E.CreatedMovers[Anchor.mover.name]
			Anchor.MoverData = moverData
			E.CreatedMovers[Anchor.mover.name] = nil
			
			if SaveProfile then
				E:SaveMoverPosition(Anchor.mover.name)
				E.db.movers[AnchorName] = E.db.movers[Anchor.mover.name]
			else
				E.db.movers[AnchorName] = nil
			end
			E.db.movers[Anchor.mover.name] = nil
			
			self.DeletedAnchor[#self.DeletedAnchor + 1] = Anchor
			KF.UIParent.ST_Icon[AnchorName] = nil
			
			self:BuildTrackingSpellList()
		end
	end
	
	
	function ST:IconAnchor_Size(Anchor)
		local Width, Height
		local SpellCount = #KF.db.Modules.SmartTracker.Icon[Anchor.Name].SpellList
		
		if SpellCount == 1 then
			Anchor:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height)
			Anchor.mover:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height)
		elseif SpellCount > 1 then
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Orientation == 'Horizontal' then
				Anchor:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width * SpellCount + KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing * (SpellCount - 1), KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height)
				Anchor.mover:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width * SpellCount + KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing * (SpellCount - 1), KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height)
			else
				Anchor:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height * SpellCount + KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing * (SpellCount - 1))
				Anchor.mover:Size(KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Width, KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Icon_Height * SpellCount + KF.db.Modules.SmartTracker.Icon[Anchor.Name].Appearance.Spacing * (SpellCount - 1))
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
				RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\healer:12:12:1:0|t'
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
		if Info.SmartTracker_Data[UserClass][SpellID].CooldownFunc then
			Cooldown, NeedUpdating = Info.SmartTracker_Data[UserClass][SpellID].CooldownFunc(Cooldown, self.CooldownCache[UserGUID], self.InspectCache[UserGUID], Event, UserGUID, UserName, UserClass, SpellID, DestName, ParamTable)
		end
		
		return Cooldown, NeedUpdating
	end
	
	
	function ST:BuildTrackingSpellList(TrackerName)
		if TrackerName then
			if KF.UIParent.ST_Window[TrackerName] then
				for ClassName in pairs(Info.SmartTracker_Data) do
					for SpellID in pairs(Info.SmartTracker_Data[ClassName]) do
						if KF.db.Modules.SmartTracker.Window[TrackerName].SpellList[ClassName][SpellID] and not (self.TrackingSpell[SpellID] and self.TrackingSpell[SpellID][(KF.UIParent.ST_Window[TrackerName])]) then
							self.TrackingSpell[SpellID] = self.TrackingSpell[SpellID] or {}
							self.TrackingSpell[SpellID][(KF.UIParent.ST_Window[TrackerName])] = 'Window'
						end
					end
				end
			elseif KF.UIParent.ST_Icon[TrackerName] then
				for _, Data in pairs(KF.db.Modules.SmartTracker.Icon[TrackerName].SpellList) do
					for SpellID in pairs(Data) do
						if not (self.TrackingSpell[SpellID] and self.TrackingSpell[SpellID][(KF.UIParent.ST_Icon[TrackerName])]) then
							self.TrackingSpell[SpellID] = self.TrackingSpell[SpellID] or {}
							self.TrackingSpell[SpellID][(KF.UIParent.ST_Icon[TrackerName])] = 'Icon'
						end
					end
				end
			end
		else
			wipe(self.TrackingSpell)
			
			for WindowName, Window in pairs(KF.UIParent.ST_Window) do
				for ClassName in pairs(Info.SmartTracker_Data) do
					for SpellID in pairs(Info.SmartTracker_Data[ClassName]) do
						if KF.db.Modules.SmartTracker.Window[WindowName].SpellList[ClassName][SpellID] and not (self.TrackingSpell[SpellID] and self.TrackingSpell[SpellID][Window]) then
							self.TrackingSpell[SpellID] = self.TrackingSpell[SpellID] or {}
							self.TrackingSpell[SpellID][Window] = 'Window'
						end
					end
				end
			end
			
			for AnchorName, Anchor in pairs(KF.UIParent.ST_Icon) do
				for _, Data in pairs(KF.db.Modules.SmartTracker.Icon[AnchorName].SpellList) do
					for SpellID in pairs(Data) do
						if not (self.TrackingSpell[SpellID] and self.TrackingSpell[SpellID][Anchor]) then
							self.TrackingSpell[SpellID] = self.TrackingSpell[SpellID] or {}
							self.TrackingSpell[SpellID][Anchor] = 'Icon'
						end
					end
				end
			end
		end
	end
	
	
	function ST:SetDisplay(TrackerType, TrackerTable, TrackerName, Tracker)
		if	KF.db.Modules.SmartTracker.Enable and KF.db.Modules.SmartTracker[TrackerType][TrackerName].Enable and
			
			(Info.CurrentGroupMode == 'NoGroup' and KF.db.Modules.SmartTracker[TrackerType][TrackerName].Display.Situation.Solo ~= false or
			Info.CurrentGroupMode ~= 'NoGroup' and KF.db.Modules.SmartTracker[TrackerType][TrackerName].Display.Situation.Group ~= false)
			
			and (Info.InstanceType == 'field' and KF.db.Modules.SmartTracker[TrackerType][TrackerName].Display.Location.Field ~= false or
			Info.InstanceType == 'raid' and KF.db.Modules.SmartTracker[TrackerType][TrackerName].Display.Situation.RaidDungeon ~= false or
			(Info.InstanceType == 'arena' or Info.InstanceType == 'pvp') and KF.db.Modules.SmartTracker[TrackerType][TrackerName].Display.Situation.PvPGround ~= false or
			(Info.InstanceType == 'scenario' or Info.InstanceType == 'party' or Info.InstanceType == 'challenge') and KF.db.Modules.SmartTracker[TrackerType][TrackerName].Display.Location.Instance ~= false)
			
			and (KF.db.Modules.SmartTracker[TrackerType][TrackerName].Display.AmICondition[Info.Role] ~= false or
			(UnitIsGroupLeader('player') or UnitIsRaidOfficer('player')) and KF.db.Modules.SmartTracker[TrackerType][TrackerName].Display.AmICondition.GroupLeader ~= false) then
			
			if not Tracker.NowDisplaying then
				Tracker.NowDisplaying = true
				Tracker:Show()
				E:UIFrameFadeIn(Tracker, 1)
				
				if TrackerType == 'Window' then
					self:RedistributeCooldownData(Tracker)
				else
					self:DistributeIconData(Tracker)
				end
			end
		else
			if Tracker.NowDisplaying then
				Tracker.NowDisplaying = nil
				E:UIFrameFadeOut(Tracker, 1)
				Tracker.fadeInfo.finishedFunc = function()
					if TrackerType == 'Window' then
						for BarNum = 1, #Tracker.ContainedBar do
							self:Bar_Delete(Tracker, BarNum)
						end
					elseif TrackerType == 'Icon' then
						for IconNum = 1, #Tracker.ContainedIcon do
							self:Icon_Delete(Tracker, IconNum)
						end
						Tracker.CurrentIconNum = nil
					end
					
					Tracker:Hide()
				end
			end
		end
	end
	
	function ST:UpdateAllTrackersDisplay()
		for TrackerType, TrackerTable in pairs({ Window = 'ST_Window', Icon = 'ST_Icon' }) do
			for TrackerName, Tracker in pairs(KF.UIParent[TrackerTable]) do
				ST:SetDisplay(TrackerType, TrackerTable, TrackerName, Tracker)
			end
		end
	end
	
	
	function ST:CheckSpellChargeCondition(UserGUID, UserName, UserClass, SpellID)
		if type(Info.SmartTracker_Data[UserClass][SpellID].Charge) == 'function' then
			return Info.SmartTracker_Data[UserClass][SpellID].Charge(UserGUID, UserName)
		else
			return Info.SmartTracker_Data[UserClass][SpellID].Charge
		end
	end
	
	
	function ST:RegisterCooldown(TimeStamp, Event, UserGUID, UserClass, UserName, SpellID, DestGUID, DestColor, DestName, ParamTable)
		local TimeNow = GetTime()
		
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
		
		if ST.TrackingSpell[SpellID] then
			for Tracker, TrackerType in pairs(ST.TrackingSpell[SpellID]) do
				if TrackerType == 'Window' then --and Tracker.NowDisplaying then
					ST:RedistributeCooldownData(Tracker)
				end
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
			
			if SpellID == 20608 then
				ST.DeadList[strsplit('-', UserName)] = nil
			end
			if ST.PrintEvent then
				print(Event, UserName, DestGUID, DestName, GetSpellLink(SpellID))
			end
			
	--		if (Event == 'SPELL_CAST_SUCCESS' or Event == 'SPELL_AURA_APPLIED') and UserName and UnitIsPlayer(UserName) and select(2, UnitClass(UserName)) == 'WARRIOR' and bit.band(UserFlag, (COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE)) ~= 0 then
	--			print(Event, UserName, GetSpellLink(SpellID), '분노 : ', UnitPower(UserName))
	--		end
			
			if not (SpellID and ST.TrackingSpell[SpellID] or SpellID and Info.SmartTracker_BattleResurrection[SpellID]) or Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[SpellID] or bit.band(UserFlag, (COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE)) == 0 then return end
			
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
			
			if Event == 'UNIT_DIED' and UnitIsPlayer(DestName) and UnitIsDeadOrGhost(DestName) then
				ST.DeadList[DestName] = true
			elseif Info.SmartTracker_BattleResurrection[SpellID] and (Event == 'SPELL_RESURRECT' or Event == 'SPELL_CAST_SUCCESS') then
				ST.DeadList[DestName] = { UserGUID = UserGUID, UserClass = UserClass, UserName = UserName, DestGUID = DestGUID, DestColor = DestColor, DestName = DestName }
				ST.BrezTracker:Show()
			end
			
			if UserClass and Info.SmartTracker_Data[UserClass] and Info.SmartTracker_Data[UserClass][SpellID] and UserName and UserGUID and not (Info.SmartTracker_Data[UserClass][SpellID].NotToMe and UserName == DestName) and
			   (Info.SmartTracker_Data[UserClass][SpellID].Event and Info.SmartTracker_Data[UserClass][SpellID].Event[Event] or not Info.SmartTracker_Data[UserClass][SpellID].Event and DefaultEventList[Event]) then
				
				ST:RegisterCooldown(TimeStamp, Event, UserGUID, UserClass, UserName, SpellID, DestGUID, DestColor, DestName, Info.SmartTracker_Data[UserClass][SpellID].NeedParameter and { select(15, ...) } or nil)
			end
		end
	end
	
	
	do	-- Resurrection Tracking
		local SoulStone = GetSpellInfo(20707)
		function ST:ResurrectionTracking()
			if next(ST.DeadList) then
				for DeadUser, Data in pairs(ST.DeadList) do
					if not UnitExists(DeadUser) then
						ST.DeadList[DeadUser] = nil
					elseif not UnitIsDeadOrGhost(DeadUser) and UnitIsConnected(DeadUser) and not UnitBuff(DeadUser, SoulStone) then	--and UnitAffectingCombat(DeadUser) then
						tinsert(ST.ResurrectionList, Data)
						ST.ResurrectionList[Data.UserGUID] = #ST.ResurrectionList
						
						ST.DeadList[DeadUser] = nil
					end
				end
			else
				self:Hide()
			end
		end
	end
	
	
	do	-- DropDownMenu
		function ST:IconDropDownMenu_Close()
			if UIDROPDOWNMENU_OPEN_MENU == SmartTrackerDropDownMenu then
				CloseDropDownMenus()
			end
		end
		
		
		function ST:IconDropDownMenu_Clear(Index)
			ST:IconDropDownMenu_Close()
			
			if self.Icon.GroupNum then
				local SpellID, UserGUID = strsplit('/', Index)
				SpellID = tonumber(SpellID)
				
				if UserGUID then
					self.Anchor.Group[self.Icon.GroupNum][SpellID][UserGUID] = nil
					
					if next(self.Anchor.Group[self.Icon.GroupNum][SpellID]) then
						return
					end
				end
				
				self.Anchor.Group[self.Icon.GroupNum][SpellID] = nil
				
				if self.Anchor.Group[self.Icon.GroupNum].Icon == SpellID then
					self.Anchor.Group[self.Icon.GroupNum].Icon = nil
				end
				
				local NextIndex = next(self.Anchor.Group[self.Icon.GroupNum])
				if NextIndex then
					if NextIndex ~= 'Icon' and not self.Anchor.Group[self.Icon.GroupNum].Icon then
						self.Anchor.Group[self.Icon.GroupNum].Icon = NextIndex
						self.Icon.SpellIcon:SetTexture(select(3, GetSpellInfo(NextIndex)))
					end
				else
					tremove(self.Anchor.Group, self.Icon.GroupNum)
				end
				
				ST:DistributeIconData(self.Anchor)
			elseif self.Icon.SpellListIndex then
				KF.db.Modules.SmartTracker.Icon[self.Anchor.Name].SpellList[self.Icon.SpellListIndex][Index] = nil
				
				if not next(KF.db.Modules.SmartTracker.Icon[self.Anchor.Name].SpellList[self.Icon.SpellListIndex]) then
					tremove(KF.db.Modules.SmartTracker.Icon[self.Anchor.Name].SpellList, self.Icon.SpellListIndex)
					
					ST:DistributeIconData(self.Anchor)
				end
			end
		end
		
		
		function ST:IconDropDownMenu_AssignGroup(GroupNum, SpellID, UserGUID)
			ST:IconDropDownMenu_Close()
			
			self.Anchor.Group[GroupNum] = self.Anchor.Group[GroupNum] or { Icon = SpellID }
			self.Anchor.Group[GroupNum][SpellID] = self.Anchor.Group[GroupNum][SpellID] or {}
			self.Anchor.Group[GroupNum][SpellID][UserGUID] = true
			
			ST:DistributeIconData(self.Anchor)
		end
		
		
		function ST:IconDropdownMenu_Initialize(Level)
			if self.SpellName == L['Battle Resurrection'] then return end
			
			local info = ST.DropDownInfo
			
			wipe(info)
			
			if Level == 1 then
				if self.SpellName then
					info.text = KF:Color_Value('>> ')..'|cffffffff'..self.SpellName..KF:Color_Value(' <<')
					info.disabled = 1
					info.notCheckable = 1
					UIDropDownMenu_AddButton(info, Level)
					wipe(info)
					
					info.text = ' '
					info.disabled = 1
					info.notCheckable = 1
					UIDropDownMenu_AddButton(info, Level)
					wipe(info)
				end
				
				local UserGUID
				for SpellID in pairs(self.Icon.Data) do
					info.text = KF:Color_Value('▶')..' |cff71d5ff['..GetSpellInfo(SpellID)..']'
					info.hasArrow = true
					info.value = SpellID
					info.notCheckable = 1
					UIDropDownMenu_AddButton(info, Level)
					wipe(info)
					
					for i = 1, #self.Icon.Data[SpellID] do
						UserGUID = self.Icon.Data[SpellID][i]
						
						info.text = '  '..ST:GetUserRoleIcon(UserGUID)..' '..KF:Color_Class(ST.InspectCache[UserGUID].Class, ST.InspectCache[UserGUID].Name)
						info.hasArrow = true
						info.value = SpellID..'/'..UserGUID
						info.notCheckable = 1
						UIDropDownMenu_AddButton(info, Level)
						wipe(info)
					end
					
					info.text = ' '
					info.disabled = 1
					info.notCheckable = 1
					UIDropDownMenu_AddButton(info, Level)
					wipe(info)
				end
				
				if self.SpellName then
					info.text = KF:Color_Value('▶')..' '..L['Disband this group.']
					info.notCheckable = 1
					info.func = function()
						ST:IconDropDownMenu_Close()
						tremove(self.Anchor.Group, self.Icon.GroupNum)
						
						ST:DistributeIconData(self.Anchor)
					end
					UIDropDownMenu_AddButton(info, Level)
					wipe(info)
					
					if #self.Anchor.Group > 1 then
						info.text = KF:Color_Value('▶')..' '..L['Disband all groups.']
						info.notCheckable = 1
						info.func = function()
							ST:IconDropDownMenu_Close()
							wipe(self.Anchor.Group)
							
							ST:DistributeIconData(self.Anchor)
						end
						UIDropDownMenu_AddButton(info, Level)
						wipe(info)
					end
				end
				
				info.text = KF:Color_Value('▶')..' '..CLOSE
				info.notCheckable = 1
				info.func = ST.IconDropDownMenu_Close
				UIDropDownMenu_AddButton(info, Level)
			elseif Level == 2 then
				if type(UIDROPDOWNMENU_MENU_VALUE) == 'number' then
					if self.SpellName and self.Anchor.Group[self.Icon.GroupNum].Icon ~= UIDROPDOWNMENU_MENU_VALUE then
						info.text = L["Show this spell's icon in frame."]
						info.notCheckable = 1
						info.func = function()
							self.Anchor.Group[self.Icon.GroupNum].Icon = UIDROPDOWNMENU_MENU_VALUE
							self.Icon.SpellIcon:SetTexture(select(3, GetSpellInfo(UIDROPDOWNMENU_MENU_VALUE)))
							
							ST:IconDropDownMenu_Close()
						end
						UIDropDownMenu_AddButton(info, Level)
						wipe(info)
						
						info.text = ' '
						info.disabled = 1
						info.notCheckable = 1
						UIDropDownMenu_AddButton(info, Level)
						wipe(info)
					end
					
					
					info.text = format(self.SpellName and L['Exclude all %s from this group.'] or '|cff808080'..L['Exclude %s from Icon tracking list.']..' (작업중)', '|cff71d5ff['..GetSpellInfo(UIDROPDOWNMENU_MENU_VALUE)..']|r')
					
					if not self.SpellName then
						info.disabled = 1
					end
					
					info.notCheckable = 1
					info.func = function() ST.IconDropDownMenu_Clear(self, UIDROPDOWNMENU_MENU_VALUE) end
					UIDropDownMenu_AddButton(info, Level)
				else
					local SpellID, UserGUID = strsplit('/', UIDROPDOWNMENU_MENU_VALUE)
					SpellID = tonumber(SpellID)
					
					for i = 1, #self.Anchor.Group do
						info.text = '|cffffffff'..format(L['Assign to %s.'], KF:Color_Value(format(L['IconGroup %d'], i))..'|cffffffff')
						info.checked = function() return self.Icon.GroupNum == i end
						info.func = function() if self.Icon.GroupNum ~= i then ST.IconDropDownMenu_AssignGroup(self, i, SpellID, UserGUID) end end
						UIDropDownMenu_AddButton(info, Level)
						
						if self.Icon.GroupNum == i then
							info.disabled = true
						end
						
						wipe(info)
					end
					
					if #self.Anchor.Group > 0 then
						info.text = ' '
						info.disabled = 1
						info.notCheckable = 1
						UIDropDownMenu_AddButton(info, Level)
						wipe(info)
					end
					
					if not self.SpellName then
						info.text = format(L['Make a new %s and assign to it.'], KF:Color_Value(format(L['IconGroup %d'], #self.Anchor.Group + 1)))
						info.notCheckable = 1
						info.func = function() ST.IconDropDownMenu_AssignGroup(self, #self.Anchor.Group + 1, SpellID, UserGUID) end
						UIDropDownMenu_AddButton(info, Level)
						wipe(info)
					else
						for Index, GUIDTable in pairs(self.Anchor.Group[self.Icon.GroupNum]) do
							if Index ~= 'Icon' and Index ~= SpellID then
								info.text = format(L['Make a new %s and assign to it.'], KF:Color_Value(format(L['IconGroup %d'], #self.Anchor.Group + 1)))
								info.notCheckable = 1
								info.func = function()
									ST.IconDropDownMenu_Clear(self, UIDROPDOWNMENU_MENU_VALUE)
									ST.IconDropDownMenu_AssignGroup(self, #self.Anchor.Group + 1, SpellID, UserGUID)
								end
								UIDropDownMenu_AddButton(info, Level)
								wipe(info)
								
								info.text = ' '
								info.disabled = 1
								info.notCheckable = 1
								UIDropDownMenu_AddButton(info, Level)
								wipe(info)
								
								break
							end
						end
						
						info.text = L['Exclude from this group and revert it.']
						info.notCheckable = 1
						info.func = function() ST.IconDropDownMenu_Clear(self, UIDROPDOWNMENU_MENU_VALUE) end
						UIDropDownMenu_AddButton(info, Level)
					end
				end
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
						
						if Info.SmartTracker_BattleResurrection[SpellID] and ST.ResurrectionList[UserGUID] then
							tremove(ST.ResurrectionList, ST.ResurrectionList[UserGUID])
							ST.ResurrectionList[UserGUID] = nil
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
			
			for SpellID in pairs(NeedRedistributing) do
				if ST.TrackingSpell[SpellID] then
					for Tracker, TrackerType in pairs(ST.TrackingSpell[SpellID]) do
						if TrackerType == 'Window' and Tracker.NowDisplaying then
							NeedUpdatingWindow[Tracker.Name] = Tracker
						end
					end
				end
			end
			
			for WindowName, Window in pairs(NeedUpdatingWindow) do
				ST:RedistributeCooldownData(Window)
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
					if KF.db.Modules.SmartTracker.Window[Window.Name].SpellList[ST.CooldownCache[UserGUID].Class][SpellID] and not ST.CooldownCache[UserGUID].List[SpellID][1].Hidden then
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
						wipe(Bar.Data)
						Bar.Data.FrameType = 'NamePlate'
						Bar.Data.GUID = UserGUID
						
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
							
							local NameBar = ST:Bar_Create(Window, CurrentLine)
							
							wipe(NameBar.Data)
							NameBar.Data.FrameType = 'NamePlate'
							NameBar.Data.GUID = UserGUID
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
						
						wipe(Bar.Data)
						Bar.Data.FrameType = 'CooldownBar'
						Bar.Data.GUID = UserGUID
						Bar.Data.SpellID = SpellID
						
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
	
	
	function ST:DistributeIconData(Anchor)
		local TimeNow = GetTime()
		local CurrentIconNum = 0
		
		local SpellID, Class
		local Icon
		
		local GroupedUser = {}
		if Info.SmartTracker_Activate and KF.db.Modules.SmartTracker.Icon[Anchor.Name] then
			if KF.db.Modules.SmartTracker.Icon[Anchor.Name].ShowBattleResurrectionIcon then
				for SpellID, Class in pairs(Info.SmartTracker_BattleResurrection) do
					for UserGUID, Data in pairs(ST.InspectCache) do
						if not (Data.Class ~= Class or SpellID == 126393 or
								(Info.SmartTracker_Data[Data.Class][SpellID].Level and Info.SmartTracker_Data[Data.Class][SpellID].Level > Data.Level) or
								(Info.SmartTracker_Data[Data.Class][SpellID].Spec and (type(Info.SmartTracker_Data[Data.Class][SpellID].Spec) == 'table' and not Info.SmartTracker_Data[Data.Class][SpellID].Spec[Data.Spec] or type(Info.SmartTracker_Data[Data.Class][SpellID].Spec) ~= 'table' and Info.SmartTracker_Data[Data.Class][SpellID].Spec ~= Data.Spec)) or
								(Info.SmartTracker_Data[Data.Class][SpellID].TalentID and not Data.Talent[Info.SmartTracker_Data[Data.Class][SpellID].TalentID]) or
								(Info.SmartTracker_Data[Data.Class][SpellID].GlyphID and not Data.Talent[Info.SmartTracker_Data[Data.Class][SpellID].GlyphID])) then
							
							if not Icon then
								CurrentIconNum = CurrentIconNum + 1
								
								Icon = ST:Icon_Create(Anchor, CurrentIconNum)
								Icon.SpellName = L['Battle Resurrection']
								Icon.SpellIcon:SetTexture(select(3, GetSpellInfo(83968)))
								Icon.Link = nil
								Icon.GroupNum = nil
								Icon.SpellListIndex = nil
								
								Icon.SpellIconFrame:Point('TOPLEFT', Icon, 3, -3)
								Icon.SpellIconFrame:Point('BOTTOMRIGHT', Icon, -3, 3)
								Icon.SpellIconFrame:SetBackdropColor(0, 0, 0, 1)
								Icon.SpellIconFrame:SetBackdropBorderColor(0, 0, 0, 1)
								
								wipe(Icon.Data)
							end
							
							Icon.Data[SpellID] = Icon.Data[SpellID] or {}
							tinsert(Icon.Data[SpellID], UserGUID)
						end
					end
				end
			end
			
			for i = 1, #Anchor.Group do
				Icon = nil
				
				for SpellID, GUIDTable in pairs(Anchor.Group[i]) do
					if type(SpellID) == 'number' and type(GUIDTable) == 'table' then
						for UserGUID in pairs(GUIDTable) do
							if ST.InspectCache[UserGUID] then
								if not ((Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].Level and Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].Level > ST.InspectCache[UserGUID].Level) or
										(Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].Spec and (type(Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].Spec) == 'table' and not Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].Spec[ST.InspectCache[UserGUID].Spec] or type(Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].Spec) ~= 'table' and Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].Spec ~= ST.InspectCache[UserGUID].Spec)) or
										(Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].TalentID and not ST.InspectCache[UserGUID].Talent[Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].TalentID]) or
										(Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].GlyphID and not ST.InspectCache[UserGUID].Talent[Info.SmartTracker_Data[ST.InspectCache[UserGUID].Class][SpellID].GlyphID])) then
									
									if not Icon then
										CurrentIconNum = CurrentIconNum + 1
										
										Icon = ST:Icon_Create(Anchor, CurrentIconNum)
										Icon.SpellName = format(L['IconGroup %d'], i)
										Icon.SpellIcon:SetTexture(select(3, GetSpellInfo(Anchor.Group[i].Icon)))
										Icon.Link = nil
										Icon.GroupNum = i
										Icon.SpellListIndex = nil
										
										Icon.SpellIconFrame:Point('TOPLEFT', Icon, 3, -3)
										Icon.SpellIconFrame:Point('BOTTOMRIGHT', Icon, -3, 3)
										Icon.SpellIconFrame:SetBackdropColor(0, 0, 0, 1)
										Icon.SpellIconFrame:SetBackdropBorderColor(0, 0, 0, 1)
										
										wipe(Icon.Data)
									end
									
									Icon.Data[SpellID] = Icon.Data[SpellID] or {}
									tinsert(Icon.Data[SpellID], UserGUID)
									
									GroupedUser[SpellID] = GroupedUser[SpellID] or {}
									GroupedUser[SpellID][UserGUID] = true
								end
							else
								Anchor.Group[i][SpellID][UserGUID] = nil
							end
						end
						
						if not next(Anchor.Group[i][SpellID]) then
							Anchor.Group[i][SpellID] = nil
							
							if Anchor.Group[i].Icon == SpellID then
								Anchor.Group[i].Icon = nil
							end
						end
					end
				end
				
				local NextIndex = next(Anchor.Group[i])
				if NextIndex then
					if NextIndex ~= 'Icon' and not Anchor.Group[i].Icon then
						Anchor.Group[i].Icon = NextIndex
						Icon.SpellIcon:SetTexture(select(3, NextIndex))
					end
				else
					tremove(Anchor.Group, i)
				end
			end
			
			for i = 1, #KF.db.Modules.SmartTracker.Icon[Anchor.Name].SpellList do
				Icon = nil
				
				for SpellID, Class in pairs(KF.db.Modules.SmartTracker.Icon[Anchor.Name].SpellList[i]) do
					for UserGUID, Data in pairs(ST.InspectCache) do
						if not ((Data.Class ~= Class) or
								(GroupedUser[SpellID] and GroupedUser[SpellID][UserGUID]) or
								(Info.SmartTracker_Data[Data.Class][SpellID].Level and Info.SmartTracker_Data[Data.Class][SpellID].Level > Data.Level) or
								(Info.SmartTracker_Data[Data.Class][SpellID].Spec and (type(Info.SmartTracker_Data[Data.Class][SpellID].Spec) == 'table' and not Info.SmartTracker_Data[Data.Class][SpellID].Spec[Data.Spec] or type(Info.SmartTracker_Data[Data.Class][SpellID].Spec) ~= 'table' and Info.SmartTracker_Data[Data.Class][SpellID].Spec ~= Data.Spec)) or
								(Info.SmartTracker_Data[Data.Class][SpellID].TalentID and not Data.Talent[Info.SmartTracker_Data[Data.Class][SpellID].TalentID]) or
								(Info.SmartTracker_Data[Data.Class][SpellID].GlyphID and not Data.Talent[Info.SmartTracker_Data[Data.Class][SpellID].GlyphID])) then
							
							if not Icon then
								CurrentIconNum = CurrentIconNum + 1
								
								Icon = ST:Icon_Create(Anchor, CurrentIconNum)
								Icon.SpellName = nil
								Icon.SpellIcon:SetTexture(select(3, GetSpellInfo(SpellID)))
								Icon.Link = GetSpellLink(SpellID)
								Icon.GroupNum = nil
								Icon.SpellListIndex = i
								
								Icon:SetBackdropColor(0, 0, 0)
								Icon.SpellIconFrame:Point('TOPLEFT', Icon)
								Icon.SpellIconFrame:Point('BOTTOMRIGHT', Icon)
								Icon.SpellIconFrame:SetBackdropColor(0, 0, 0, 0)
								Icon.SpellIconFrame:SetBackdropBorderColor(0, 0, 0, 0)
								
								wipe(Icon.Data)
							end
							
							Icon.Data[SpellID] = Icon.Data[SpellID] or {}
							tinsert(Icon.Data[SpellID], UserGUID)
						end
					end
				end
			end
		end
		
		for IconNum = CurrentIconNum + 1, #Anchor.ContainedIcon do
			ST:Icon_Delete(Anchor, IconNum)
		end
		
		if CurrentIconNum > 0 and Anchor.CurrentIconNum ~= CurrentIconNum then
			ST:Icon_Rearrange(Anchor)
		end
		Anchor.CurrentIconNum = CurrentIconNum
	end
	
	
	function ST:ResetSpellCooldown(InArena)
		local UserGUID
		
		for i = 1, #ST.CooldownCache do
			UserGUID = ST.CooldownCache[i]
			
			for SpellID in pairs(ST.CooldownCache[UserGUID].List) do
				if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Reset or InArena == true then
					for i = 1, #ST.CooldownCache[UserGUID].List[SpellID] do
						ST.CooldownCache[UserGUID].List[SpellID][i].EraseThisCooltimeCache = true
					end
				end
			end
		end
	end
	
	
	do	-- Boss Battle Parts
		local CurrentMapID
		function ST:BossBattleStart()
			_, _, _, _, _, _, _, CurrentMapID = GetInstanceInfo()
			
			if Info.SmartTracker_ResetCooldownMapID[CurrentMapID] then
				ST.NowBossBattle = CurrentMapID
				ST.GroupTypeWhenBossBattleStart = KF:CheckGroupMode()
			end
			
			if Info.InstanceType == 'raid' then
				wipe(ST.DeadList)
				wipe(ST.ResurrectionList)
				
				for i = 1, #ST.CooldownCache do
					UserGUID = ST.CooldownCache[i]
					
					for SpellID in pairs(ST.CooldownCache[UserGUID].List) do
						if Info.SmartTracker_BattleResurrection[SpellID] then
							for i = 1, #ST.CooldownCache[UserGUID].List[SpellID] do
								ST.CooldownCache[UserGUID].List[SpellID][i].EraseThisCooltimeCache = true
							end
						end
					end
				end
			end
		end
		
		
		function ST:BossBattleEnd()
			wipe(ST.DeadList)
			wipe(ST.ResurrectionList)
			
			if not (IsInInstance() and ST.NowBossBattle ~= select(8, GetInstanceInfo())) and ST.GroupTypeWhenBossBattleStart == KF:CheckGroupMode() then
				ST:ResetSpellCooldown()
				
				print(L['KF']..' : '..L['Reset major cooltime that had used in previous boss battle.'])
			end
		end
	end
end


do	--<< Inspect System >>--
	ST.CheckPlayer = CreateFrame('Frame')
	ST.CheckPlayer:Hide()
	ST.CheckPlayer:SetScript('OnEvent', function(self, Event, arg1, ...)
		if Event == 'ACTIVE_TALENT_GROUP_CHANGED' then
			self.NeedCheckingSpec = true
			self.NeedCheckingGlyph = true
		elseif Event == 'PLAYER_SPECIALIZATION_CHANGED' then
			if arg1 == 'player' then
				self.NeedCheckingSpec = true
				self.NeedCheckingGlyph = true
			elseif arg1 then
				arg1 = UnitName(arg1)
				
				if Info.CurrentGroupMode ~= 'NoGroup' and arg1 then
					ST.InspectOrder[arg1] = 'Delayed'
					
					if not ST.NowInspecting then
						ST.UpdateDataByChanging = true
					end
					self.GroupMemberCount = GetNumGroupMembers()
					KF:RegisterTimer('SmartTracker_InspectGroup', 'NewTicker', 1, ST.InspectGroup, nil, true)
				end
			end
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
				
				for AnchorName, Anchor in pairs(KF.UIParent.ST_Icon) do
					ST:DistributeIconData(Anchor)
				end
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
	
	
	do	-- Event : INSPECT_READY
		local UnitID, UserClass, UserName, UserRealm, Spec, Talent, IsSelected, GlyphID
		function ST:INSPECT_READY(UserGUID)
			if Info.CurrentGroupMode == 'NoGroup' then
				KF:UnregisterEventList('INSPECT_READY', 'SmartTracker')
				return
			end
			
			_, UserClass, _, _, _, UserName, UserRealm = GetPlayerInfoByGUID(UserGUID)
			
			if UserName == E.myname or not UnitExists(UserName) then return end
			
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
			
			ST.InspectOrder[UserName] = true
			ENI.CancelInspect(UserName..(UserRealm and UserRealm ~= '' and UserRealm ~= Info.MyRealm and '-'..UserRealm or ''), 'SmartTracker')
			
			for AnchorName, Anchor in pairs(KF.UIParent.ST_Icon) do
				ST:DistributeIconData(Anchor)
			end
		end
	end
	
	
	do	-- InspectGroup
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
				
				if ST.UpdateDataByChanging then
					ST.UpdateDataByChanging = nil
				else
					print(L['KF']..' : |cff2eb7e4'..L['Inspect Complete']..'|r. '..L["All members specialization, talent, glyph setting is saved. SmartTracker will calcurating each spell's cooltime by this data.|r"])
				end
				
				ST.NowInspecting = nil
				KF:UnregisterEventList('INSPECT_READY', 'SmartTracker')
				KF:CancelTimer('SmartTracker_InspectGroup')
			else
				--KnightRaidCooldown.InspectMembers.Number:SetText((InspectType == 'Updating' and '|cffceff00' or '|cff2eb7e4')..NeedUpdating)
				KF:RegisterEventList('INSPECT_READY', ST.INSPECT_READY, 'SmartTracker')
				NotifyInspect(ST.CurrentInspectMemberUnitName, { Reservation = true, InspectTryCount = 3, CancelInspectByManual = 'SmartTracker' })
			end
		end
	end
	
	
	do	-- CheckGroupMember
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
			self.CurrentInspectMemberUnitName = nil
			
			wipe(self.InspectCache)
			E.myguid = E.myguid or UnitGUID('player')
			self.InspectCache[E.myguid] = {
				Name = E.myname,
				Class = E.myclass,
				Talent = {},
				Glyph = {}
			}
			self:CheckPlayerSpec()
			self:CheckPlayerGlyph()
			self:CheckPlayerLevel()
			
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
			
			for AnchorName, Anchor in pairs(KF.UIParent.ST_Icon) do
				wipe(Anchor.Group)
				self:DistributeIconData(Anchor)
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
			
			for AnchorName, Anchor in pairs(KF.UIParent.ST_Icon) do
				self:DistributeIconData(Anchor)
			end
		end
		
		self.GroupMemberCount = GetNumGroupMembers()
		KF:RegisterTimer('SmartTracker_CheckGroupMember', 'NewTicker', .5, self.CheckGroupMember, nil, true)
	end
end


KF.Modules[#KF.Modules + 1] = 'SmartTracker'
KF.Modules.SmartTracker = function(RemoveOrder)
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable ~= false then
		Info.SmartTracker_Activate = true
		
		ST:PrepareGroupInspect(true)
		
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
		
		ST.CheckPlayer:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		ST.CheckPlayer:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
		ST.CheckPlayer:RegisterEvent('GLYPH_ADDED')
		ST.CheckPlayer:RegisterEvent('GLYPH_REMOVED')
		ST.CheckPlayer:RegisterEvent('GLYPH_UPDATED')
		ST.CheckPlayer:RegisterEvent('PLAYER_TALENT_UPDATE')
		ST.CheckPlayer:RegisterEvent('PLAYER_LEVEL_UP')
		
		KF:RegisterCallback('SpecChanged', ST.UpdateAllTrackersDisplay, 'SmartTracker')
		KF:RegisterCallback('CurrentAreaChanged', function()
			if Info.InstanceType == 'arena' then
				ST:ResetSpellCooldown(true)
			end
			
			ST:UpdateAllTrackersDisplay()
		end, 'SmartTracker')
		KF:RegisterCallback('GroupChanged', function() ST:PrepareGroupInspect() ST:UpdateAllTrackersDisplay() end, 'SmartTracker')
		
		KF:RegisterCallback('BossBattleStart', ST.BossBattleStart, 'SmartTracker')
		KF:RegisterCallback('BossBattleEnd', ST.BossBattleEnd, 'SmartTracker')
		if Info.NowInBossBattle then
			ST:BossBattleStart()
		end
		
		KF:RegisterEventList('UNIT_SPELLCAST_SUCCEEDED', ST.UNIT_SPELLCAST_SUCCEEDED, 'SmartTracker')
		KF:RegisterEventList('COMBAT_LOG_EVENT_UNFILTERED', ST.COMBAT_LOG_EVENT_UNFILTERED, 'SmartTracker')
		KF:RegisterEventList('GROUP_ROSTER_UPDATE', function() ST:PrepareGroupInspect() end, 'SmartTracker_PrepareGroupInspect')
		KF:RegisterEventList('READY_CHECK', function() if KF.db.Modules.SmartTracker.ScanWhenReadyCheck then ST:PrepareGroupInspect(true) end end, 'SmartTracker_PrepareGroupInspect')
		KF:RegisterEventList('CHALLENGE_MODE_RESET', ST.ResetSpellCooldown, 'SmartTracker')
	elseif Info.SmartTracker_Activate then
		Info.SmartTracker_Activate = nil
		
		for WindowName in pairs(KF.UIParent.ST_Window) do
			ST:Window_Delete(WindowName, true)
		end
		
		for AnchorName in pairs(KF.UIParent.ST_Icon) do
			ST:IconAnchor_Delete(AnchorName, true)
		end
		
		wipe(ST.InspectOrder)
		wipe(ST.InspectCache)
		wipe(ST.CooldownCache)
		wipe(ST.DeadList)
		wipe(ST.ResurrectionList)
		
		ST.CheckPlayer:UnregisterAllEvents()
		ST.CheckPlayer:Hide()
		
		KF:UnregisterCallback('SpecChanged', 'SmartTracker')
		KF:UnregisterCallback('GroupChanged', 'SmartTracker')
		KF:UnregisterCallback('CurrentAreaChanged', 'SmartTracker')
		
		KF:UnregisterCallback('BossBattleStart', 'SmartTracker')
		KF:UnregisterCallback('BossBattleEnd', 'SmartTracker')
		
		KF:UnregisterEventList('UNIT_SPELLCAST_SUCCEEDED', 'SmartTracker')
		KF:UnregisterEventList('COMBAT_LOG_EVENT_UNFILTERED', 'SmartTracker')
		KF:UnregisterEventList('GROUP_ROSTER_UPDATE', 'SmartTracker_PrepareGroupInspect')
		KF:UnregisterEventList('READY_CHECK', 'SmartTracker_PrepareGroupInspect')
		KF:UnregisterEventList('CHALLENGE_MODE_RESET', 'SmartTracker')
	end
end