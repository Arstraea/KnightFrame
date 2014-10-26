local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

local TAB_HEIGHT = 22
local WindowCount = 1
local WindowTag = 'KF_SmartTracker'

--------------------------------------------------------------------------------
--<< KnightFrame : Smart Tracker											>>--
--------------------------------------------------------------------------------
local ST = _G['KF_SmartTracker'] or CreateFrame('Frame', 'KF_SmartTracker', KF.UIParent)
local DeletedWindow = {}

KF.UIParent.Window = {}
KF.UIParent.MoverType.KF_SmartTracker = L['Smart Tracker']

function ST:DisplayableBarNumber(Window)
	return floor((DB.Modules.SmartTracker.Window[Window.Name].Height - TAB_HEIGHT) / (DB.Modules.SmartTracker.Window[Window.Name].Height - 1))
end



do --<< Script >>--
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
		Window:SetMovable(true)
		Window:SetClampedToScreen(true)
		Window.Count = Count
		
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
		Window.Tab:Height(TAB_HEIGHT - 2)
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
		if #DeletedWindow > 0 then
			KF.UIParent.Window[WindowName] = DeletedWindow[#DeletedWindow]
			
			Window = KF.UIParent.Window[WindowName]
			
			E.CreatedMovers[Window.mover.name] = Window.MoverData
			Window.MoverData = nil
			E.CreatedMovers[Window.mover.name].point = E:HasMoverBeenMoved(WindowName) and E.db.movers[WindowName] or DB.Modules.SmartTracker.Window[WindowName].Location or 'CENTERElvUIParent'
			
			Window.mover:ClearAllPoints()
			Window.mover:SetPoint(unpack({string.split('\031', E.CreatedMovers[Window.mover.name].point)}))
			
			Window:Show()
			
			DeletedWindow[#DeletedWindow] = nil
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
	local MinimumHeight = (DB.Modules.SmartTracker.Window[Window.Name].Bar_Height - 1) * 5 + TAB_HEIGHT
	
	if DB.Modules.SmartTracker.Window[Window.Name].Area_Height < MinimumHeight then
		DB.Modules.SmartTracker.Window[Window.Name].Area_Height = MinimumHeight
	end
	
	Window:SetMinResize(200, MinimumHeight)
	Window:SetMaxResize(floor(UIParent:GetWidth() / 2), floor(UIParent:GetHeight() * 2/3))
	Window:Size(DB.Modules.SmartTracker.Window[Window.Name].Area_Width, DB.Modules.SmartTracker.Window[Window.Name].Area_Height)
	Window.mover:Size(DB.Modules.SmartTracker.Window[Window.Name].Area_Width, DB.Modules.SmartTracker.Window[Window.Name].Area_Height)
	Window.DisplayArea.text:SetText(L['Enable to display']..' : |cff2eb7e4'..floor((DB.Modules.SmartTracker.Window[Window.Name].Area_Height - TAB_HEIGHT) / (DB.Modules.SmartTracker.Window[Window.Name].Bar_Height - 1)))
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