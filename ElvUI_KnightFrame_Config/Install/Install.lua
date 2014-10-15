local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

local PANEL_HEIGHT = 22
local SPACING = 3

local CURRENT_PAGE = 1
local MAX_PAGE = 6


local function InstallWindow_Close()
	CURRENT_PAGE = 1
	KF_Config.SelectLayout = nil
	KF_Config.ArrangeMover = nil
	KF_Config.InstallProfile = nil
	KF_Config.InstallOption1 = nil
	KF_Config.InstallOption2 = nil
	
	print(L['KF']..' : '..L['You canceled KnightFrame install. If you wants to run KnightFrame install process again, please type /kf_install command.'])
	
	if E.db.KnightFrame and E.db.KnightFrame.Install_Complete and E.db.KnightFrame.Install_Complete ~= Info.Version then
		E.db.KnightFrame.Install_Complete = 'NotUpdated'
	end
	
	if not E.private.install_complete and E.Install_ then
		E.Install = E.Install_
		E.Install_ = nil
		E:Install()
	end
	
	KnightFrame_InstallWindow:Hide()
end


function KF_Config:InstallWindow_Initialize()
	-----------------------------------------------------------
	-- [ Knight : Install Window							]--
	-----------------------------------------------------------
	if not KnightFrame_InstallWindow then
		CreateFrame('Frame', 'KnightFrame_InstallWindow', E.UIParent)
		KnightFrame_InstallWindow:CreateBackdrop('Transparent')
		KnightFrame_InstallWindow:SetFrameStrata('DIALOG')
		KnightFrame_InstallWindow:SetFrameLevel(20)
		KnightFrame_InstallWindow:SetMovable(true)
		KnightFrame_InstallWindow:SetClampedToScreen(true)
		
		KnightFrame_InstallWindow.KnightFrameImage = KnightFrame_InstallWindow:CreateTexture(nil, 'OVERLAY')
		KnightFrame_InstallWindow.KnightFrameImage:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame_Config\\Media\\Graphics\\KnightFrame.tga')
		KnightFrame_InstallWindow.KnightFrameImage:Size(512,256)
		KnightFrame_InstallWindow.KnightFrameImage:Point('CENTER', 0, -50)
		
		KF:TextSetting(KnightFrame_InstallWindow, '', { Tag = 'SubTitle', FontSize = 15, FontOutline = 'OUTLINE' }, 'TOP', 0, -64)
		KnightFrame_InstallWindow.SubTitle:SetWidth(480)
		
		KF:TextSetting(KnightFrame_InstallWindow, '', { Tag = 'State', FontOutline = 'OUTLINE' }, 'TOP', 0, -170)
		KnightFrame_InstallWindow.State:SetWidth(480)
		
		KF:TextSetting(KnightFrame_InstallWindow, '', { FontOutline = 'OUTLINE' }, 'TOP', 0, -100)
		KnightFrame_InstallWindow.text:SetWidth(480)
		
		do -- Window : Tab
			KnightFrame_InstallWindow.Tab = CreateFrame('Frame', nil, KnightFrame_InstallWindow)
			KnightFrame_InstallWindow.Tab:Point('TOPLEFT', KnightFrame_InstallWindow, SPACING, -SPACING)
			KnightFrame_InstallWindow.Tab:Point('BOTTOMRIGHT', KnightFrame_InstallWindow, 'TOPRIGHT', -SPACING, -(SPACING + PANEL_HEIGHT))
			KnightFrame_InstallWindow.Tab:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.Tab:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(KnightFrame_InstallWindow.Tab, 'ElvUI - |cff1784d1Knight Frame', { FontSize = 12, FontOutline = 'OUTLINE' }, 'CENTER', 0, 1)
			
			KnightFrame_InstallWindow.Tab.Close = CreateFrame('Button', nil, KnightFrame_InstallWindow.Tab)
			KnightFrame_InstallWindow.Tab.Close:Size(PANEL_HEIGHT - 8)
			KnightFrame_InstallWindow.Tab.Close:SetTemplate()
			KnightFrame_InstallWindow.Tab.Close.backdropTexture:SetVertexColor(.1, .1, .1)
			KnightFrame_InstallWindow.Tab.Close:Point('RIGHT', -4, 0)
			KF:TextSetting(KnightFrame_InstallWindow.Tab.Close, 'X', { FontSize = 13 }, 'CENTER', 1, 0)
			KnightFrame_InstallWindow.Tab.Close:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
			KnightFrame_InstallWindow.Tab.Close:SetScript('OnLeave', function(self) self:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
			KnightFrame_InstallWindow.Tab.Close:SetScript('OnClick', function() InstallWindow_Close() end)
		end
		
		do -- Window : Bottom Panel
			KnightFrame_InstallWindow.BP = CreateFrame('Frame', nil, KnightFrame_InstallWindow)
			KnightFrame_InstallWindow.BP:Point('TOPLEFT', KnightFrame_InstallWindow, 'BOTTOMLEFT', SPACING, SPACING + PANEL_HEIGHT)
			KnightFrame_InstallWindow.BP:Point('BOTTOMRIGHT', KnightFrame_InstallWindow, -SPACING, SPACING)
			KnightFrame_InstallWindow.BP:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.BP:SetBackdropColor(.09, .3, .45)
			KnightFrame_InstallWindow.BP:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		
		do -- Window : Prev Button (Bottom Panel)
			KnightFrame_InstallWindow.PrevButton = CreateFrame('Button', nil, KnightFrame_InstallWindow.BP)
			KnightFrame_InstallWindow.PrevButton:Size(110,25)
			KnightFrame_InstallWindow.PrevButton:Point('BOTTOMLEFT', KnightFrame_InstallWindow.BP, 4, 4)
			KnightFrame_InstallWindow.PrevButton:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.PrevButton:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(KnightFrame_InstallWindow.PrevButton, PREV, { FontOutline = 'OUTLINE' })
			KnightFrame_InstallWindow.PrevButton:SetScript('OnClick', function(self)
				if CURRENT_PAGE ~= 1 then
					CURRENT_PAGE = CURRENT_PAGE - 1
					KF_Config:InstallWindow_SetPage(CURRENT_PAGE)
					PlaySoundFile('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\SoundEffects\\button')
				end
			end)
			KnightFrame_InstallWindow.PrevButton:SetScript('OnEnter', function(self) self.text:SetTextColor(unpack(E.media.rgbvaluecolor)) end)
			KnightFrame_InstallWindow.PrevButton:SetScript('OnLeave', function(self) self.text:SetTextColor(1, 1, 1) self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.PrevButton:SetScript('OnMouseDown', function(self) self.text:Point('CENTER', 0, -2) end)
			KnightFrame_InstallWindow.PrevButton:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
		end
		
		do -- Window : Next Button (Bottom Panel)
			KnightFrame_InstallWindow.NextButton = CreateFrame('Button', nil, KnightFrame_InstallWindow.BP)
			KnightFrame_InstallWindow.NextButton:Size(110,25)
			KnightFrame_InstallWindow.NextButton:Point('BOTTOMRIGHT', KnightFrame_InstallWindow.BP, -4, 4)
			KnightFrame_InstallWindow.NextButton:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.NextButton:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(KnightFrame_InstallWindow.NextButton, NEXT, { FontOutline = 'OUTLINE' })
			KnightFrame_InstallWindow.NextButton:SetScript('OnClick', function(self)
				if CURRENT_PAGE ~= MAX_PAGE then
					CURRENT_PAGE = CURRENT_PAGE + 1
					KF_Config:InstallWindow_SetPage(CURRENT_PAGE)
					PlaySoundFile('Interface\\AddOns\\ElvUI_KnightFrame\\Media\\SoundEffects\\button')
				end
			end)
			KnightFrame_InstallWindow.NextButton:SetScript('OnEnter', function(self) self.text:SetTextColor(unpack(E.media.rgbvaluecolor)) end)
			KnightFrame_InstallWindow.NextButton:SetScript('OnLeave', function(self) self.text:SetTextColor(1, 1, 1) self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.NextButton:SetScript('OnMouseDown', function(self) self.text:Point('CENTER', 0, -2) end)
			KnightFrame_InstallWindow.NextButton:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
		end
		
		do -- Window : Status Bar (Bottom Panel)
			KnightFrame_InstallWindow.StatusBarFrame = CreateFrame('Frame', nil, KnightFrame_InstallWindow.BP)
			KnightFrame_InstallWindow.StatusBarFrame:Point('TOPLEFT', KnightFrame_InstallWindow.PrevButton, 'TOPRIGHT', 3, 0)
			KnightFrame_InstallWindow.StatusBarFrame:Point('BOTTOMRIGHT', KnightFrame_InstallWindow.NextButton, 'BOTTOMLEFT', -3, 0)
			KnightFrame_InstallWindow.StatusBarFrame:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.StatusBarFrame:SetBackdropColor(.2, .2, .2)
			KnightFrame_InstallWindow.StatusBarFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KnightFrame_InstallWindow.StatusBar = CreateFrame('StatusBar', nil, KnightFrame_InstallWindow.StatusBarFrame)
			KnightFrame_InstallWindow.StatusBar:SetInside()
			KnightFrame_InstallWindow.StatusBar:SetMinMaxValues(0, 6)
			KnightFrame_InstallWindow.StatusBar:SetStatusBarTexture(E.media.normTex)
			KnightFrame_InstallWindow.StatusBar:SetStatusBarColor(.57, .8, 1)--(0.67, 0.85, 1)--(0.13, 0.43, 0.64)
			KF:TextSetting(KnightFrame_InstallWindow.StatusBar, CURRENT_PAGE..' / '..MAX_PAGE, { FontOutline = 'OUTLINE' })
			KnightFrame_InstallWindow.StatusBar:SetScript('OnValueChanged', function(self) self.text:SetText(CURRENT_PAGE..' / '..MAX_PAGE) end)
		end
		
		do -- Window : Main Button
			KnightFrame_InstallWindow.MainButton = CreateFrame('Button', nil, KnightFrame_InstallWindow)
			KnightFrame_InstallWindow.MainButton:Size(160,30)
			KnightFrame_InstallWindow.MainButton:Point('BOTTOM', KnightFrame_InstallWindow.BP, 0, 45)
			KnightFrame_InstallWindow.MainButton:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.MainButton:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(KnightFrame_InstallWindow.MainButton, '', { FontOutline = 'OUTLINE' })
			KnightFrame_InstallWindow.MainButton:SetScript('OnEnter', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.hr, self.textcolor.hg, self.textcolor.hb) else self.text:SetTextColor(unpack(E.media.rgbvaluecolor)) end end)
			KnightFrame_InstallWindow.MainButton:SetScript('OnLeave', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.r, self.textcolor.g, self.textcolor.b) else self.text:SetTextColor(1, 1, 1) end self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.MainButton:SetScript('OnMouseDown', function(self) self.text:Point('CENTER', 0, -2) end)
			KnightFrame_InstallWindow.MainButton:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
		end
		
		do -- Window : Option Panel 1
			KnightFrame_InstallWindow.OptionPanel1BG = CreateFrame('Frame', nil, KnightFrame_InstallWindow)
			KnightFrame_InstallWindow.OptionPanel1BG:Size(460,66)
			KnightFrame_InstallWindow.OptionPanel1BG:Point('BOTTOM', 0, 112)
			KnightFrame_InstallWindow.OptionPanel1BG:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.OptionPanel1BG:SetBackdropColor(.09, .3, .45)
			KnightFrame_InstallWindow.OptionPanel1BG:SetBackdropBorderColor(unpack(E.media.bordercolor))
			
			KnightFrame_InstallWindow.OptionPanel1 = CreateFrame('Frame', nil, KnightFrame_InstallWindow.OptionPanel1BG)
			KnightFrame_InstallWindow.OptionPanel1:Size(452,58)
			KnightFrame_InstallWindow.OptionPanel1:SetPoint('CENTER')
			KnightFrame_InstallWindow.OptionPanel1:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.OptionPanel1:SetBackdropColor(.1, .1, .1)
			KnightFrame_InstallWindow.OptionPanel1:SetBackdropBorderColor(unpack(E.media.bordercolor))
			
			KF:TextSetting(KnightFrame_InstallWindow.OptionPanel1, '', { Tag = 'Tag' }, 'TOP', 0, -5)
			KF:TextSetting(KnightFrame_InstallWindow.OptionPanel1, '', { directionH = 'LEFT' }, 'BOTTOMLEFT', 6, 6)
			
			KnightFrame_InstallWindow.OptionButton1 = CreateFrame('Button', nil, KnightFrame_InstallWindow.OptionPanel1)
			KnightFrame_InstallWindow.OptionButton1:Size(98,30)
			KnightFrame_InstallWindow.OptionButton1:Point('BOTTOMRIGHT', KnightFrame_InstallWindow.OptionPanel1, -4, 4)
			KnightFrame_InstallWindow.OptionButton1:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.OptionButton1:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(KnightFrame_InstallWindow.OptionButton1, L['Install'], { FontOutline = 'OUTLINE' })
			KnightFrame_InstallWindow.OptionButton1:SetScript('OnEnter', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.hr, self.textcolor.hg, self.textcolor.hb) else self.text:SetTextColor(unpack(E.media.rgbvaluecolor)) end end)
			KnightFrame_InstallWindow.OptionButton1:SetScript('OnLeave', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.r, self.textcolor.g, self.textcolor.b) else self.text:SetTextColor(1, 1, 1) end self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.OptionButton1:SetScript('OnMouseDown', function(self) self.text:Point('CENTER', 0, -2) end)
			KnightFrame_InstallWindow.OptionButton1:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.OptionButton1:SetScript('OnClick', function() if not KF_Config.InstallOption1 then KF_Config.InstallOption1 = true else KF_Config.InstallOption1 = nil end PlaySoundFile('Sound\\Interface\\LevelUp.wav') KF_Config:InstallWindow_SetPage(5) end)
			KnightFrame_InstallWindow.OptionPanel1.text:Point('TOPRIGHT', KnightFrame_InstallWindow.OptionButton1, 'TOPLEFT', -4, 2)
		end
		
		do -- Window : Option Panel 2
			KnightFrame_InstallWindow.OptionPanel2BG = CreateFrame('Frame', nil, KnightFrame_InstallWindow)
			KnightFrame_InstallWindow.OptionPanel2BG:Size(460,66)
			KnightFrame_InstallWindow.OptionPanel2BG:Point('BOTTOM', 0, 42)
			KnightFrame_InstallWindow.OptionPanel2BG:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.OptionPanel2BG:SetBackdropColor(.09, .3, .45)
			KnightFrame_InstallWindow.OptionPanel2BG:SetBackdropBorderColor(unpack(E.media.bordercolor))
			
			KnightFrame_InstallWindow.OptionPanel2 = CreateFrame('Frame', nil, KnightFrame_InstallWindow.OptionPanel2BG)
			KnightFrame_InstallWindow.OptionPanel2:Size(452,58)
			KnightFrame_InstallWindow.OptionPanel2:SetPoint('CENTER')
			KnightFrame_InstallWindow.OptionPanel2:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.OptionPanel2:SetBackdropColor(.1, .1, .1)
			KnightFrame_InstallWindow.OptionPanel2:SetBackdropBorderColor(unpack(E.media.bordercolor))
			
			KF:TextSetting(KnightFrame_InstallWindow.OptionPanel2, '', { Tag = 'Tag' }, 'TOP', 0, -5)
			KF:TextSetting(KnightFrame_InstallWindow.OptionPanel2, '', { directionH = 'LEFT' }, 'LEFT', 10, -10)
			
			KnightFrame_InstallWindow.OptionButton2 = CreateFrame('Button', nil, KnightFrame_InstallWindow.OptionPanel2)
			KnightFrame_InstallWindow.OptionButton2:Size(98,30)
			KnightFrame_InstallWindow.OptionButton2:Point('BOTTOMRIGHT', KnightFrame_InstallWindow.OptionPanel2, -4, 4)
			KnightFrame_InstallWindow.OptionButton2:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.OptionButton2:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(KnightFrame_InstallWindow.OptionButton2, L['Install'], { FontOutline = 'OUTLINE' })
			KnightFrame_InstallWindow.OptionButton2:SetScript('OnEnter', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.hr, self.textcolor.hg, self.textcolor.hb) else self.text:SetTextColor(unpack(E.media.rgbvaluecolor)) end end)
			KnightFrame_InstallWindow.OptionButton2:SetScript('OnLeave', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.r, self.textcolor.g, self.textcolor.b) else self.text:SetTextColor(1, 1, 1) end self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.OptionButton2:SetScript('OnMouseDown', function(self) self.text:Point('CENTER', 0, -2) end)
			KnightFrame_InstallWindow.OptionButton2:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.OptionButton2:SetScript('OnClick', function() if not KF_Config.InstallOption2 then KF_Config.InstallOption2 = true else KF_Config.InstallOption2 = nil end PlaySoundFile('Sound\\Interface\\LevelUp.wav') KF_Config:InstallWindow_SetPage(5) end)
		end
		
		do -- Window : Layout Panel - Moonlight
			KnightFrame_InstallWindow.LayoutPanel1 = CreateFrame('Frame', nil, KnightFrame_InstallWindow)
			KnightFrame_InstallWindow.LayoutPanel1:Size(264,136)
			KnightFrame_InstallWindow.LayoutPanel1:Point('BOTTOM', -136, 42)
			KnightFrame_InstallWindow.LayoutPanel1:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.LayoutPanel1:SetBackdropColor(.09, .3, .45)
			KnightFrame_InstallWindow.LayoutPanel1:SetBackdropBorderColor(unpack(E.media.bordercolor))
			
			KnightFrame_InstallWindow.LayoutImage1 = KnightFrame_InstallWindow.LayoutPanel1:CreateTexture(nil, 'OVERLAY')
			KnightFrame_InstallWindow.LayoutImage1:Size(256,128)
			KnightFrame_InstallWindow.LayoutImage1:Point('TOP', 0, -4)
			KnightFrame_InstallWindow.LayoutImage1:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame_Config\\Media\\Graphics\\moonlight.tga')
			
			KnightFrame_InstallWindow.LayoutButton1 = CreateFrame('Button', nil, KnightFrame_InstallWindow.LayoutPanel1)
			KnightFrame_InstallWindow.LayoutButton1:Size(98,30)
			KnightFrame_InstallWindow.LayoutButton1:Point('BOTTOM', KnightFrame_InstallWindow.LayoutPanel1, 0, -4)
			KnightFrame_InstallWindow.LayoutButton1:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.LayoutButton1:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(KnightFrame_InstallWindow.LayoutButton1, 'Moonlight', { FontOutline = 'OUTLINE' })
			KnightFrame_InstallWindow.LayoutButton1:SetScript('OnEnter', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.hr, self.textcolor.hg, self.textcolor.hb) else self.text:SetTextColor(unpack(E.media.rgbvaluecolor)) end end)
			KnightFrame_InstallWindow.LayoutButton1:SetScript('OnLeave', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.r, self.textcolor.g, self.textcolor.b) else self.text:SetTextColor(1, 1, 1) end self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.LayoutButton1:SetScript('OnMouseDown', function(self) self.text:Point('CENTER', 0, -2) end)
			KnightFrame_InstallWindow.LayoutButton1:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.LayoutButton1:SetScript('OnClick', function()
				KF_Config.SelectLayout = 'Moonlight'
				PlaySoundFile('Sound\\Interface\\LevelUp.wav')
				KF_Config:InstallWindow_SetPage(2)
			end)
		end
		
		do -- Window : Layout Panel - Kimsungjae
			KnightFrame_InstallWindow.LayoutPanel2 = CreateFrame('Frame', nil, KnightFrame_InstallWindow)
			KnightFrame_InstallWindow.LayoutPanel2:Size(264,136)
			KnightFrame_InstallWindow.LayoutPanel2:Point('BOTTOM', 136, 42)
			KnightFrame_InstallWindow.LayoutPanel2:SetBackdrop({
				bgFile = E.media.blankTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.LayoutPanel2:SetBackdropColor(.09, .3, .45)
			KnightFrame_InstallWindow.LayoutPanel2:SetBackdropBorderColor(unpack(E.media.bordercolor))
			
			KnightFrame_InstallWindow.LayoutImage2 = KnightFrame_InstallWindow.LayoutPanel2:CreateTexture(nil, 'OVERLAY')
			KnightFrame_InstallWindow.LayoutImage2:Size(256,128)
			KnightFrame_InstallWindow.LayoutImage2:Point('TOP', 0, -4)
			KnightFrame_InstallWindow.LayoutImage2:SetTexture('Interface\\AddOns\\ElvUI_KnightFrame_Config\\Media\\Graphics\\kimsungjae.tga')
			
			KnightFrame_InstallWindow.LayoutButton2 = CreateFrame('Button', nil, KnightFrame_InstallWindow.LayoutPanel2)
			KnightFrame_InstallWindow.LayoutButton2:Size(98,30)
			KnightFrame_InstallWindow.LayoutButton2:Point('BOTTOM', KnightFrame_InstallWindow.LayoutPanel2, 0, -4)
			KnightFrame_InstallWindow.LayoutButton2:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightFrame_InstallWindow.LayoutButton2:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(KnightFrame_InstallWindow.LayoutButton2, 'Kimsungjae', { FontOutline = 'OUTLINE' })
			KnightFrame_InstallWindow.LayoutButton2:SetScript('OnEnter', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.hr, self.textcolor.hg, self.textcolor.hb) else self.text:SetTextColor(unpack(E.media.rgbvaluecolor)) end end)
			KnightFrame_InstallWindow.LayoutButton2:SetScript('OnLeave', function(self) if self.textcolor then self.text:SetTextColor(self.textcolor.r, self.textcolor.g, self.textcolor.b) else self.text:SetTextColor(1, 1, 1) end self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.LayoutButton2:SetScript('OnMouseDown', function(self) self.text:Point('CENTER', 0, -2) end)
			KnightFrame_InstallWindow.LayoutButton2:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
			KnightFrame_InstallWindow.LayoutButton2:SetScript('OnClick', function()
				KF_Config.SelectLayout = 'Kimsungjae'
				PlaySoundFile('Sound\\Interface\\LevelUp.wav')
				KF_Config:InstallWindow_SetPage(2)
			end)
		end
	else
		KnightFrame_InstallWindow:Show()
	end
end


local function InstallWindow_Clear()
	KnightFrame_InstallWindow.KnightFrameImage:Hide()
	
	KnightFrame_InstallWindow.MainButton:SetBackdropColor(1, 1, 1)
	KnightFrame_InstallWindow.MainButton.textcolor = nil
	KnightFrame_InstallWindow.MainButton.text:SetTextColor(1, 1, 1)
	KnightFrame_InstallWindow.MainButton:Hide()
	
	KnightFrame_InstallWindow.OptionPanel1BG:Hide()
	KnightFrame_InstallWindow.OptionButton1.textcolor = nil
	KnightFrame_InstallWindow.OptionButton1.text:SetTextColor(1, 1, 1)
	KnightFrame_InstallWindow.OptionPanel2BG:Hide()
	KnightFrame_InstallWindow.OptionButton2.textcolor = nil
	KnightFrame_InstallWindow.OptionButton2.text:SetTextColor(1, 1, 1)
	KnightFrame_InstallWindow.LayoutPanel1:Hide()
	KnightFrame_InstallWindow.LayoutPanel2:Hide()
	
	KnightFrame_InstallWindow:Size(550, 400)
	KnightFrame_InstallWindow:Point('CENTER', E.UIParent, 0, 40)
end


local function ToggleButtonEnable(Button, ToggleType)
	if ToggleType == 'Enable' then
		Button:Enable()
		Button:SetBackdropColor(1, 1, 1)
		Button.text:SetTextColor(1, 1, 1)
	elseif ToggleType == 'Disable' then
		Button:Disable()
		Button:SetBackdropColor(.3, .3, .3)
		Button.text:SetTextColor(.5, .5, .5)
	end
end


function KF_Config:InstallWindow_SetPage(Page)
	InstallWindow_Clear()
	KnightFrame_InstallWindow.StatusBar:SetValue(Page)
	
	if Page == 1 then
		ToggleButtonEnable(KnightFrame_InstallWindow.PrevButton, 'Disable')
		ToggleButtonEnable(KnightFrame_InstallWindow.NextButton, 'Enable')
	elseif Page == MAX_PAGE or (Page == 2 and not KF_Config.SelectLayout) then
		ToggleButtonEnable(KnightFrame_InstallWindow.PrevButton, 'Enable')
		ToggleButtonEnable(KnightFrame_InstallWindow.NextButton, 'Disable')
	else
		ToggleButtonEnable(KnightFrame_InstallWindow.PrevButton, 'Enable')
		ToggleButtonEnable(KnightFrame_InstallWindow.NextButton, 'Enable')
	end
	
	if Page == 1 then
		KnightFrame_InstallWindow.SubTitle:SetText('Welcome to ElvUI - |cff1784d1Knight Frame|r |cffffdc3cv'..IN.Version)
		KnightFrame_InstallWindow.text:SetText('|n'..L['KnightFrame is an external addon of ElvUI|nto change layout setting and add some of extra functions.'])
		KnightFrame_InstallWindow.State:SetText(L['This page will be closed by clicking [Skip Process] button or closs button and you can see again by typing /kf_install command or clicking Install button in ElvUI Config - KnightFrame menu.']..'|n|n|n|n'..L['Please press the next button to go onto the next step.'])
		
		KnightFrame_InstallWindow.MainButton.text:SetText(L['Skip Process'])
		KnightFrame_InstallWindow.MainButton:SetBackdropColor(.3, .3, .3)
		KnightFrame_InstallWindow.MainButton.text:SetTextColor(.72, 0, 0)
		KnightFrame_InstallWindow.MainButton.textcolor = { hr = 1, hg = .34, hb = .46, r = .72, g = 0, b = 0 }
		KnightFrame_InstallWindow.MainButton:SetScript('OnClick', function() InstallWindow_Close() end)
		KnightFrame_InstallWindow.MainButton:Show()
	elseif Page == 2 then
		KnightFrame_InstallWindow.SubTitle:SetText('|cffffdc3c'..L['UI Layout Theme'])
		KnightFrame_InstallWindow.text:SetText(L['KnightFrame provides 2 layout theme.|nYou can preview those layout setting by clicking each preview button.|nPlease select one, then you can go onto the next step.'])
		
		KnightFrame_InstallWindow.LayoutImage1:SetDesaturated(false)
		KnightFrame_InstallWindow.LayoutButton1.text:SetTextColor(1, 1, 1)
		KnightFrame_InstallWindow.LayoutButton1.textcolor = nil
		
		KnightFrame_InstallWindow.LayoutImage2:SetDesaturated(false)
		KnightFrame_InstallWindow.LayoutButton2.text:SetTextColor(1, 1, 1)
		KnightFrame_InstallWindow.LayoutButton2.textcolor = nil
		
		KnightFrame_InstallWindow.State:SetText('|cff1784d1>> |cff93daff'..L['Layout to Install']..' |cff1784d1<<|r|n|n'..L['Did not selected yet.'])
		if KF_Config.SelectLayout == 'Moonlight' then
			KnightFrame_InstallWindow.LayoutButton1.text:SetTextColor(.18, .72, .89)
			KnightFrame_InstallWindow.LayoutButton1.textcolor = { hr = .58, hg = .85, hb = 1, r = .18, g = .72, b = .89 }
			KnightFrame_InstallWindow.LayoutImage2:SetDesaturated(true)
			KnightFrame_InstallWindow.State:SetText('|cff1784d1>> |cff93daff'..L['Layout to Install']..' |cff1784d1<<|n|n|cff2eb7e4Moonlight|r '..L['Layout'])
		elseif KF_Config.SelectLayout == 'Kimsungjae' then
			KnightFrame_InstallWindow.LayoutButton2.text:SetTextColor(.42, .77, .26)
			KnightFrame_InstallWindow.LayoutButton2.textcolor = { hr = .66, hg = 1, hb = .52, r = .42, g = .77, b = .26 }
			KnightFrame_InstallWindow.LayoutImage1:SetDesaturated(true)
			KnightFrame_InstallWindow.State:SetText('|cff1784d1>> |cff93daff'..L['Layout to Install']..' |cff1784d1<<|n|n|cff6ac443Kimsungjae|r '..L['Layout'])
		end
		
		KnightFrame_InstallWindow.LayoutPanel1:Show()
		KnightFrame_InstallWindow.LayoutPanel2:Show()
	elseif Page == 3 then
		KnightFrame_InstallWindow.SubTitle:SetText('|cffffdc3c'..L['Mover Arrangement'])
		KnightFrame_InstallWindow.text:SetText(format(L['You selected %s layout theme,|nand we needs to arrange movers position.']..'|n|n|n|cffff0000!! '..L['Warning']..' !!|r|n'..L['If you click the button below and when process is over,|n|cffff0000YOUR PRESENT MOVER SETTING WILL BE OVERWRITED!!|r|n|nIf you wants to preserve your custom mover profile, do not click the button and just go onto the next step.'], KF_Config.SelectLayout == 'Moonlight' and '|cff2eb7e4Moonlight|r' or '|cff6ac443Kimsungjae|r'))
		KnightFrame_InstallWindow.State:SetText('|n|n|n|n|n|n|n|n|cff1784d1>> |cff93daff'..L['Install Mover setting?']..' |cff1784d1<<|n|n|cffff0000'..NO)
		
		KnightFrame_InstallWindow.MainButton.text:SetText(L['Arrange Movers'])
		if KF_Config.ArrangeMover then
			KnightFrame_InstallWindow.MainButton.text:SetTextColor(.72, 0, 0)
			KnightFrame_InstallWindow.MainButton.textcolor = { hr = 1, hg = .34, hb = .46, r = .72, g = 0, b = 0 }
			KnightFrame_InstallWindow.MainButton.text:SetText(L['Do not arrange'])
			KnightFrame_InstallWindow.State:SetText('|n|n|n|n|n|n|n|n|cff1784d1>> |cff93daff'..L['Install Mover setting?']..' |cff1784d1<<|n|n|cffceff00'..YES)
		end
		
		KnightFrame_InstallWindow.MainButton:SetScript('OnClick', function() if not KF_Config.ArrangeMover then KF_Config.ArrangeMover = true else KF_Config.ArrangeMover = nil end PlaySoundFile('Sound\\Interface\\LevelUp.wav') KF_Config:InstallWindow_SetPage(3) end)
		KnightFrame_InstallWindow.MainButton:Show()
	elseif Page == 4 then
		KnightFrame_InstallWindow.SubTitle:SetText('|cffffdc3c'..L['Profile Install'])
		KnightFrame_InstallWindow.text:SetText(format(L['We also needs to install profile setting for becoming %s layout theme.']..'|n|n|n|cffff0000!! '..L['Warning']..' !!|r|n'..L['If you click the button below and when process is over,|n|cffff0000YOUR UNITFRAME AND ACTIONBAR SETTING WILL BE REMOVED!!|r|n|nIf you wants to preserve your custom option setting or just use extra functions, do not click the button and just go onto the next step.'], KF_Config.SelectLayout == 'Moonlight' and '|cff2eb7e4Moonlight|r' or '|cff6ac443Kimsungjae|r'))
		KnightFrame_InstallWindow.State:SetText('|n|n|n|n|n|n|n|n|cff1784d1>> |cff93daff'..L['Install Profile?']..' |cff1784d1<<|n|n|cffff0000'..NO)
		
		KnightFrame_InstallWindow.MainButton.text:SetText(L['Install Profile'])
		if KF_Config.InstallProfile then
			KnightFrame_InstallWindow.MainButton.text:SetTextColor(.72, 0, 0)
			KnightFrame_InstallWindow.MainButton.textcolor = { hr = 1, hg = .34, hb = .46, r = .72, g = 0, b = 0 }
			KnightFrame_InstallWindow.MainButton.text:SetText(L['Do not install'])
			KnightFrame_InstallWindow.State:SetText('|n|n|n|n|n|n|n|n|cff1784d1>> |cff93daff'..L['Install Profile?']..' |cff1784d1<<|n|n|cffceff00'..YES)
		end
		
		KnightFrame_InstallWindow.MainButton:SetScript('OnClick', function() if not KF_Config.InstallProfile then KF_Config.InstallProfile = true else KF_Config.InstallProfile = nil end PlaySoundFile('Sound\\Interface\\LevelUp.wav') KF_Config:InstallWindow_SetPage(4) end)
		KnightFrame_InstallWindow.MainButton:Show()
	elseif Page == 5 then
		KnightFrame_InstallWindow.SubTitle:SetText('|cffffdc3c'..L['Sub Install'])
		KnightFrame_InstallWindow.text:SetText(L['KnightFrame provides sub-install. Check explanation of sub-install and this is completely optional, so If you want not, just go onto the next step.'])
		KnightFrame_InstallWindow.State:SetText('|cff1784d1>> |cff93daff'..L['Current Order']..' |cff1784d1<<|r|n|n'..L['Do not install any sub-install.'])
		
		KnightFrame_InstallWindow.OptionPanel1.Tag:SetText('- |cff2eb7e4'..L['Add Important Raid Debuff']..'|r -')
		KnightFrame_InstallWindow.OptionPanel1.text:SetText(L['Add some of missing important raid debuff to unitframe filter.'])
		
		if KF_Config.InstallOption1 then
			KnightFrame_InstallWindow.OptionButton1.text:SetTextColor(.18, .72, .89)
			KnightFrame_InstallWindow.OptionButton1.textcolor = { hr = .58, hg = .85, hb = 1, r = .18, g = .72, b = .89 }
			KnightFrame_InstallWindow.State:SetText('|cff1784d1>> |cff93daff'..L['Current Order']..' |cff1784d1<<|r|n|n|cffceff00'..L['Add Important Raid Debuff'])
		end
		
		KnightFrame_InstallWindow.OptionPanel1BG:Show()
	elseif Page == 6 then
		KnightFrame_InstallWindow.SubTitle:SetText('|cffffdc3c'..L['Installation Complete'])
		KnightFrame_InstallWindow.text:SetText(L['Now installation precess is end. If you click the button below then KnightFrame will overwrite your current config profile for constructing UI layout theme and then reload.']..'|n|n|n|n'..L['If you have any suggestion, please send an email to me: qjr2513@naver.com'])
		KnightFrame_InstallWindow.State:SetText(nil)
		
		KnightFrame_InstallWindow.KnightFrameImage:Show()
		KnightFrame_InstallWindow:Size(550, 500)
		KnightFrame_InstallWindow:Point('CENTER', 0, 60)
		
		KnightFrame_InstallWindow.MainButton.text:SetText(L['Installation Complete'])
		KnightFrame_InstallWindow.MainButton:SetScript('OnClick', function() KF_Config:Install_KnightFrame() end)
		KnightFrame_InstallWindow.MainButton:Show()
	end
end

function KF_Config:Install_KnightFrame()
	KF:UnregisterEventList('PLAYER_LOGOUT', 'KnightFrame_SaveDB')
	
	E.db.KnightFrame = {
		Enable = true,
		Installed_UI_Layout = KF_Config.SelectLayout,
		Install_Complete = Info.Version,
	}
	
	local CurrentResolution = GetCVar('gxResolution')
	
	if KF_Config.ArrangeMover then
		if KF_Config.Install_Layout_Data[KF_Config.SelectLayout][CurrentResolution] then
			E.db.movers = KF_Config.Install_Layout_Data[KF_Config.SelectLayout][CurrentResolution]
		elseif KF_Config.Install_Layout_Data[KF_Config.SelectLayout].Default then
			E.db.movers = KF_Config.Install_Layout_Data[KF_Config.SelectLayout].Default
		end
	end
	
	if KF_Config.InstallProfile then
		if KF_Config.Install_Profile_Data[KF_Config.SelectLayout][CurrentResolution] then
			KF_Config.Install_Profile_Data[KF_Config.SelectLayout][CurrentResolution]()
			E.db.KnightFrame.UseProfile = true
		elseif KF_Config.Install_Profile_Data[KF_Config.SelectLayout].Default then
			KF_Config.Install_Profile_Data[KF_Config.SelectLayout].Default()
			E.db.KnightFrame.UseProfile = true
		end
	end
	
	if KF_Config.InstallOption1 then
		if KF_Config.Install_SubPackData_RaidDebuffs then
			KF_Config:Install_SubPackData_RaidDebuffs()
		end
	end
	
	ReloadUI()
end