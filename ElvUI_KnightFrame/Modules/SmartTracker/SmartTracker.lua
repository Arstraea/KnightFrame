local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

local WindowCount = 1
local WindowTag = 'KF_SmartTracker'

--------------------------------------------------------------------------------
--<< KnightFrame : Smart Tracker											>>--
--------------------------------------------------------------------------------
local ST = KF_SmartTracker or CreateFrame('Frame', 'KF_SmartTracker', KF.UIParent)
ST.DeletedWindow = {}
ST.DeletedBar = {}
ST.TrackingSpell = {}
ST.InspectCache = {}
ST.CooldownCache = {}
ST.TAB_HEIGHT = 22
ST.FADE_TIME = .4

KF.UIParent.Window = {}
KF.UIParent.MoverType.KF_SmartTracker = L['Smart Tracker']


do	--<< About Window's Layout and Appearance >>--
	function ST:OnSizeChanged()
		KF.db.Modules.SmartTracker.Window[self.Name].Area_Width = tonumber(E:Round(self:GetWidth()))
		KF.db.Modules.SmartTracker.Window[self.Name].Area_Height = tonumber(E:Round(self:GetHeight()))
		
		ST:Window_Size(self)
		
		--KF:RaidCooldown_RefreshCooldownBarData()
	end
	
	
	function ST:DisplayArea_OnMouseWheel(Spinning)
		--마우스 휠을 위로 굴리면 spining 에 1값 리턴, 아래로 굴리면 spining 에 -1값 리턴
		local Window = self:GetParent()
		
		if KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 'UP' then
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
			if KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 'UP' then
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
			if KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 'UP' then
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
			KF.db.Modules.SmartTracker.Window[Window.Name].DisplayArea = false
			print(L['KF']..' : '..L['Lock Display Area.'])
		else
			Window.DisplayArea:SetAlpha(1)
			KF.db.Modules.SmartTracker.Window[Window.Name].DisplayArea = true
			print(L['KF']..' : '..L['Unlock Display Area.'])
		end
	end


	function ST:Window_Create(WindowName)
		if not KF.db.Modules.SmartTracker.Enable or KF.db.Modules.SmartTracker.Window[WindowName].Enable == false then
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
				
				Window:Show()
				
				self.DeletedWindow[#self.DeletedWindow] = nil
			else
				WindowCount = WindowCount + 1
				
				Window = self:Window_Setup(CreateFrame('Frame', WindowTag..'_'..WindowCount, KF.UIParent), WindowCount)
				
				KF.UIParent.Window[WindowName] = Window
				
				E:CreateMover(Window, WindowTag..'_'..Window.Count..'_Mover', nil, nil, nil, nil, 'ALL,KF,KF_SmartTracker')
				Window:SetScript('OnSizeChanged', self.OnSizeChanged)
			end
			
			E.CreatedMovers[Window.mover.name].point = E:HasMoverBeenMoved(WindowName) and E.db.movers[WindowName] or KF.db.Modules.SmartTracker.Window[WindowName].Location or 'CENTERElvUIParent'
			Window.mover:ClearAllPoints()
			Window.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Window.mover.name].point)}))
			
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
		Window.Tab:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[WindowName].Color_WindowTab))
		
		
		--Window.Tab.text:SetText('|cff2eb7e4'..Default['MainFrame_Tab_AddOnName']) 탭에 표시할 제목
		
		
		if E.ConfigurationMode then
			Window.mover:Show()
		end
	end


	function ST:Window_Size(Window)
		local MinimumHeight = (KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Height - 1) * 5 + ST.TAB_HEIGHT
		
		if KF.db.Modules.SmartTracker.Window[Window.Name].Area_Height < MinimumHeight then
			KF.db.Modules.SmartTracker.Window[Window.Name].Area_Height = MinimumHeight
		end
		
		Window:SetMinResize(200, MinimumHeight)
		Window:SetMaxResize(floor(UIParent:GetWidth() / 2), floor(UIParent:GetHeight() * 2/3))
		Window:Size(KF.db.Modules.SmartTracker.Window[Window.Name].Area_Width, KF.db.Modules.SmartTracker.Window[Window.Name].Area_Height)
		Window.mover:Size(KF.db.Modules.SmartTracker.Window[Window.Name].Area_Width, KF.db.Modules.SmartTracker.Window[Window.Name].Area_Height)
		Window.DisplayArea.text:SetText(L['Enable to display']..' : |cff2eb7e4'..floor((KF.db.Modules.SmartTracker.Window[Window.Name].Area_Height - ST.TAB_HEIGHT) / (KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Height - 1)))
	end


	function ST:Window_ChangeBarGrowDirection(Window)
		Window.Tab:ClearAllPoints()
		Window.Tab:Point('LEFT', Window)
		Window.Tab:Point('RIGHT', Window)
		
		Window.ResizeGrip:ClearAllPoints()
		Window.DisplayArea.text:ClearAllPoints()
		if KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 'UP' then -- 1 : Up / 2 : Down
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
		
		if KF.db.Modules.SmartTracker.Window[1].Location then
			self:SetPoint(unpack({string.split('\031', KF.db.Modules.SmartTracker.Window[1].Location)}))
			--KF.db.Modules.SmartTracker.Window[1].Location = nil
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
				elseif not ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID].Fade or ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID].FadeFadeType == 'IN' then
					if ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID]['Chargy'] then
						ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID]['ActivateTime'] = 0
					else
						ST.CooldownCache[Table['Cooldown_BarList'][BarNumber].Data.GUID].List[Table['Cooldown_BarList'][BarNumber].Data.SpellID].Fade = { FadeType = TimeNow, .NoAnnounce = true, }
					end
				end
			end
		end)
		self:SetScript('OnLeave', function() self:SetScript('OnUpdate', nil) self:SetScript('OnClick', nil) GameTooltip:Hide() end)
	end)
	]]
	
	function ST:Bar_OnUpdate(elapsed)
		local UserGUID = self.Data.GUID
		local Window = self:GetParent()
		
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
			local RemainCooltime = ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime - TimeNow
			
			if not self.Data.SettingComplete then
				local SpellName, _, SpellIcon = GetSpellInfo(SpellID)
				self.SpellIcon:SetTexture(SpellIcon)
				self:SetBackdropBorderColor(unpack(E.media.bordercolor))
				self.SpellIconFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))
				
				if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Charge and ST.CooldownCache[UserGUID].List[SpellID][2] then
					if ST.CooldownCache[UserGUID].List[SpellID][2].ChargedColor then
						self.CooldownBar:SetStatusBarColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Color_Charged1))
						self:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Color_Charged2))
					else
						self.CooldownBar:SetStatusBarColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Color_Charged2))
						self:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Color_Charged1))
					end
					
					if not ST.CooldownCache[UserGUID].List[SpellID][3] then
						self:SetBackdropColor(Bar_Color.r, Bar_Color.g, Bar_Color.b)
					end
				else
					self:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Window[Window.Name].Color_BehindBar))
					self.CooldownBar:SetStatusBarColor(Bar_Color.r, Bar_Color.g, Bar_Color.b)
				end
				
				SpellName = SpellName..(#ST.CooldownCache[UserGUID].List[SpellID] > 1 and ' ('..#ST.CooldownCache[UserGUID].List[SpellID]..')' or '')
				
				if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Target then
					local Target, LastestTargetUserGUID
					local LastestTargetUserCount = 1
					local DisplayedTargetUser = 0
					
					for i = 1, #ST.CooldownCache[UserGUID].List[SpellID] do
						if LastestTargetUserGUID ~= ST.CooldownCache[UserGUID].List[SpellID][i].DestGUID then
							Target = (Target and '|r'..(LastestTargetUserCount > 1 and 'x '..ST.CooldownCache[UserGUID].List[SpellID][i]DestColor..LastestTargetUserCount or ', ') or '')..ST.CooldownCache[UserGUID].List[SpellID][i]DestColor..ST.CooldownCache[UserGUID].List[SpellID][i].DestName
							
							LastestTargetUserCount = 1
							DisplayedTargetUser = DisplayedTargetUser + 1
						else
							LastestTargetUserCount = LastestTargetUserCount + 1
						end
						
						if DisplayedTargetUser > KF.db.Modules.SmartTracker.Window[Window.Name].Appearance.Count_TargetUser then
							break
						end
						
						LastestTargetUserGUID = ST.CooldownCache[UserGUID].List[SpellID][i].DestGUID
					end
					
					SpellName = SpellName..' |cffceff00▶|r '..Target
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
						--KF.Update['RaidCooldown_RefreshCooldown']['Action']()
						return
					end
				end
			elseif self:GetAlpha() ~= 1 then
				self:SetAlpha(1)
			end
			
			if ST.CooldownCache[UserGUID].List[SpellID][1].NeedCalculating and ((ST.InspectCache[UserGUID] and ST.InspectCache[UserGUID].Spec) or ST.CooldownCache[UserGUID].Spec) then
				ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime, ST.CooldownCache[UserGUID].List[SpellID][1].NeedCalculating = ST:CalculateCooldown(ST.CooldownCache[UserGUID].List[SpellID][1].Event, UserGUID, ST.CooldownCache[UserGUID].Name, ST.CooldownCache[UserGUID].Class, SpellID, ST.CooldownCache[UserGUID].List[SpellID][1].DestName)
			end
			
			if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Charge and (TimeNow > ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime + ST.CooldownCache[UserGUID].List[SpellID].Cooltime - ST.FADE_TIME) and not self.Fade then
				self.Fade = { Type = TimeNow, }
			end
			
			self.CooldownBar:SetValue(100 - (TimeNow - ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime) / ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime * 100)
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
		
		KF:TextSetting(Bar.CooldownBar, nil, { Tag = 'Time', FontSize = KF.db.Modules.SmartTracker.Window[WindowName].Bar_Fontsize, FontOutline = 'OUTLINE', directionH = 'RIGHT', }, 'RIGHT', Bar.CooldownBar, -2, 0)
		Bar.Time = Bar.CooldownBar.Time
		
		KF:TextSetting(Bar.CooldownBar, nil, { FontSize = KF.db.Modules.SmartTracker.Window[WindowName].Bar_Fontsize, FontOutline = 'OUTLINE', directionH = 'LEFT', }, 'LEFT', Bar.CooldownBar, 5, 0)
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
			Bar:SetParent(Window)
			
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
			
			if KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Direction == 1 then
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
			Bar:SetHeight(KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Height)
			Bar.SpellIconFrame:Size(KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Height)
			Bar.Time:SetFont(Bar.Time:GetFont(), KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Fontsize, 'OUTLINE')
			Bar.Text:SetFont(Bar.Text:GetFont(), KF.db.Modules.SmartTracker.Window[Window.Name].Bar_Fontsize, 'OUTLINE')
			
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
						Cooldown = Cooldown + (Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Talent[(self.InspectCache[UserGUID].Glyph[i])] or 0)
					end
				end
				
				--Change Cooldown By Glyph
				if Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Glyph then
					for i = 1, NUM_GLYPH_SLOTS do
						Cooldown = Cooldown + (Info.SmartTracker_Data[ST.CooldownCache[UserGUID].Class][SpellID].Glyph[(self.InspectCache[UserGUID].Glyph[i])] or 0)
					end
				end
				
				return Cooldown, nil
			end
		end
		
		return Cooldown, true
	end
	
	
	local TempTable = {}
	function ST:BuildTrackingSpellList()
		wipe(TempTable)
		
		for WindowName in pairs(KF.db.Modules.SmartTracker.Window) do
			for ClassName in pairs(KF.db.Modules.SmartTracker.Window[WindowName].SpellList) do
				for SpellID, Enable in pairs(KF.db.Modules.SmartTracker.Window[WindowName].SpellList[ClassName]) do
					if Enable then
						TempTable[SpellID] = (TempTable[SpellID] or 0) + 1
					end
				end
			end
		end
		
		self.TrackingSpell = TempTable
	end
	
	
	function ST:RegisterCooldown(Event, UserGUID, UserClass, UserName, SpellID, DestGUID, DestColor, DestName)
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
			elseif SpellID == 108285 then --원소의 부름
				if ST.CooldownCache[UserGUID].List[8143] then ST.CooldownCache[UserGUID].List[8143].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[51485] then ST.CooldownCache[UserGUID].List[51485].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[108273] then ST.CooldownCache[UserGUID].List[108273].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[2484] then ST.CooldownCache[UserGUID].List[2484].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[108269] then ST.CooldownCache[UserGUID].List[108269].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[108279] then ST.CooldownCache[UserGUID].List[108279].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[8177] then ST.CooldownCache[UserGUID].List[8177].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
				if ST.CooldownCache[UserGUID].List[108270] then ST.CooldownCache[UserGUID].List[108270].Fade = { FadeType = TimeNow, NoAnnounce = true, } end
			end
		end
		]]
		
		
		--[[
		if Event == 'SPELL_RESURRECT' and NowBossBattle then
			Table['BattleResurrection_CastMember'][#Table['BattleResurrection_CastMember'] + 1] = { ['UserGUID'] = UserGUID, ['UserClass'] = UserClass, ['UserName'] = UserName, ['DestGUID'] = DestGUID, ['DestColor'] = DestColor, ['DestName'] = DestName, }
		end
		]]
		
		ST.CooldownCache[UserGUID] = ST.CooldownCache[UserGUID] or {
			Name = UserName,
			Class = UserClass,
			List = {}
		}
		
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
		--elseif ST.CooldownCache[UserGUID].List[SpellID].ActivateTime + 0.5 > TimeNow then -- because combat log check more than 1 time, so it needs to forbid just one.
		--	return
		--elseif ST.CooldownCache[UserGUID].List[SpellID].Fade then
		--	ST.CooldownCache[UserGUID].List[SpellID].Fade = { FadeType = 'IN' }
		end
		
		if Event ~= 'SPELL_INTERRUPT' then Event = nil end
		
		if ST.CooldownCache[UserGUID].List[SpellID][1] and Info.SmartTracker_Data[UserClass][SpellID].Charge and not (Info.SmartTracker_Data[UserClass][SpellID].NotToMe and UserName ~= E.myname) then
			local Data = {
				ActivateTime = ST.CooldownCache[UserGUID].List[SpellID][1],
				DestGUID = DestGUID,
				DestColor = DestColor,
				DestName = DestName,
				Event = Event
			}
			Data.Cooltime, Data.NeedCalculating = ST:CalculateCooldown(Event, UserGUID, UserName, UserClass, SpellID, DestName)
			Data.ChargedColor = not ST.CooldownCache[UserGUID].List[SpellID][#ST.CooldownCache[UserGUID].List[SpellID] - 1]
			
			tinsert(ST.CooldownCache[UserGUID].List[SpellID], Data)
		else
			ST.CooldownCache[UserGUID].List[SpellID][1] = ST.CooldownCache[UserGUID].List[SpellID][1] or {}
			ST.CooldownCache[UserGUID].List[SpellID][1].ActivateTime = TimeNow
			ST.CooldownCache[UserGUID].List[SpellID][1].DestGUID = DestGUID
			ST.CooldownCache[UserGUID].List[SpellID][1].DestColor = DestColor
			ST.CooldownCache[UserGUID].List[SpellID][1].DestName = DestName
			ST.CooldownCache[UserGUID].List[SpellID][1].Event = Event
			ST.CooldownCache[UserGUID].List[SpellID][1].Cooltime, ST.CooldownCache[UserGUID].List[SpellID][1].NeedCalculating = ST:CalculateCooldown(Event, UserGUID, UserName, UserClass, SpellID, DestName)
		end
		
		--Value['RefreshCooldown'] = true
		--KF:RaidCooldown_RefreshCooldownBarData()
	end
	
	
	do
		local UnitType, SpellID, UserName, UserGUID, UserClass
		KF:RegisterEventList('UNIT_SPELLCAST_SUCCEEDED', function(...)
			_, UnitType, _, _, _, SpellID = ...
			SpellID = Info.SmartTracker_ConvertSpell[SpellID] or SpellID
			
			if not (SpellID and ST.TrackingSpell[SpellID] and Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[SpellID]) then return end
			
			UserName = string.split('-', UnitName(UnitType))
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
			
			ST:RegisterCooldown(Event, UserGUID, UserClass, UserName, SpellID)
		end)
	end
	
	
	do
		local Event, UserGUID, UserName, UserFlag, DestGUID, DestName, DestFlag, SpellID, UserClass, DestColor
		KF:RegisterEventList('COMBAT_LOG_EVENT_UNFILTERED', function(...)
			_, _, Event, _, UserGUID, UserName, UserFlag, _, DestGUID, DestName, DestFlag, _, SpellID = ...
			SpellID = Info.SmartTracker_ConvertSpell[SpellID] or SpellID
			
			if not (SpellID and ST.TrackingSpell[SpellID]) or bit.band(UserFlag, (COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE)) == 0 or
				(Event ~= 'SPELL_RESURRECT' and Event ~= 'SPELL_AURA_APPLIED' and Event ~= 'SPELL_AURA_REFRESH' and Event ~= 'SPELL_CAST_SUCCESS' and Event ~= 'SPELL_INTERRUPT' and Event ~= 'SPELL_SUMMON') then return end
			
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
			
			UserName = string.split('-', UserName)
			
			if UserClass and Info.SmartTracker_Data[UserClass] and UserName and UserGUID then
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
				
				ST:RegisterCooldown(Event, UserGUID, UserClass, UserName, SpellID, DestGUID, DestColor, DestName)
			end
		end)
	end
	
	
	function ST:RefreshCooldownCache()
		--[[
		['Condition'] = function() return Value['RefreshCooldown'] end,
		['Delay'] = 0,
		['Action'] = function()
			local HasData, RemainCooltime, NeedRefreshCooldownBarData
			
			for userGUID in pairs(Table['Cooldown_Cache']) do
				HasData = nil
				
				for spellID in pairs(Table['Cooldown_Cache'][userGUID]['List']) do
					HasData = true
					
					RemainCooltime = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow
					
					if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Chargy'] and RemainCooltime <= 0 then
						if Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] ~= 0 then
							if KF.db.Modules.SmartTracker[Table['Cooldown_Cache'][userGUID]['Class'] ][spellID] == 3 then
								Func['Announcer'](userGUID, spellID)
							end
							
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime2'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime']
						else
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime2']
						end
						
						Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor2']
						Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName2']
						Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName2'] = nil
						Table['Cooldown_Cache'][userGUID]['List'][spellID]['Chargy'] = nil
						Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime2'] = nil
						
						RemainCooltime = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow
						
						NeedRefreshCooldownBarData = true
					end
					
					if RemainCooltime <= 0 then
						if KF.db.Modules.SmartTracker[Table['Cooldown_Cache'][userGUID]['Class'] ][spellID] == 3 and not (Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] and Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['NoAnnounce']) then
							Func['Announcer'](userGUID, spellID)
						end
						
						Table['Cooldown_Cache'][userGUID]['List'][spellID] = nil
						
						NeedRefreshCooldownBarData = true
					end
				end
				
				if not HasData then
					Table['Cooldown_Cache'][userGUID] = nil
				end
			end
			
			if NeedRefreshCooldownBarData then
				KF:RaidCooldown_RefreshCooldownBarData()
			elseif HasData == nil then
				Value['RefreshCooldown'] = nil
			end
		end,
		]]
	end
end

--[[
KF.Modules[#KF.Modules + 1] = 'SmartTracker'
KF.Modules.SmartTracker = function(RemoveOrder)
	for WindowName in pairs(KF.UIParent.Window) do
		ST:Window_Delete(WindowName, true)
	end
	
	if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable ~= false then
		Info.SmartTracker_Activate = true
		
		if ST.Setup_MainWindow then
			ST:Setup_MainWindow()
			ST:BuildTrackingSpellList()
		end
		
		for WindowName, IsWindowData in pairs(KF.db.Modules.SmartTracker.Window) do
			if type(IsWindowData) == 'table' then
				ST:Window_Create(WindowName)
			end
		end
	else
		Info.SmartTracker_Activate = nil
	end
end
]]