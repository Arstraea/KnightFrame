--Cache global variables
--Lua functions
local _G = _G
local unpack, select = unpack, select

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local CreateFrame = CreateFrame

--------------------------------------------------------------------------------
--<< KnightFrame : Widget		 											>>--
--------------------------------------------------------------------------------
local function Widget_CheckButton_OnMouseDown(self)
	self.text:Point('LEFT', self.CheckButtonBG, 'RIGHT', 6, -2)
end

local function Widget_CheckButton_OnMouseUp(self)
	self.text:Point('LEFT', self.CheckButtonBG, 'RIGHT', 6, 0)
end

function KF:CreateWidget_CheckButton(buttonName, buttonText, heightSize, fontInfo)
	if not _G[buttonName] then
		heightSize = heightSize or 24
		fontInfo = fontInfo or { FontStyle = 'OUTLINE', directionH = 'LEFT' }
		
		CreateFrame('Button', buttonName, KF.UIParent)
		_G[buttonName]:SetHeight(heightSize)
		_G[buttonName]:EnableMouse(true)

		_G[buttonName].CheckButtonBG = CreateFrame('Frame', nil, _G[buttonName])
		_G[buttonName].CheckButtonBG:SetTemplate('Default', true)
		_G[buttonName].CheckButtonBG:Size(heightSize - 8)
		_G[buttonName].CheckButtonBG:SetPoint('LEFT')

		_G[buttonName].CheckButton = _G[buttonName].CheckButtonBG:CreateTexture(nil, 'OVERLAY')
		_G[buttonName].CheckButton:Size(heightSize)
		_G[buttonName].CheckButton:Point('CENTER', _G[buttonName].CheckButtonBG)
		_G[buttonName].CheckButton:SetTexture('Interface\\Buttons\\UI-CheckBox-Check')

		KF:TextSetting(_G[buttonName], buttonText, fontInfo, 'LEFT', _G[buttonName].CheckButtonBG, 'RIGHT', 6, 0)
		
		_G[buttonName].hover = _G[buttonName]:CreateTexture(nil, 'HIGHLIGHT')
		_G[buttonName].hover:SetTexture('Interface\\Buttons\\UI-CheckBox-Highlight')
		_G[buttonName].hover:SetBlendMode('ADD')
		_G[buttonName].hover:SetAllPoints(_G[buttonName].CheckButtonBG)
		
		_G[buttonName]:SetHighlightTexture(_G[buttonName].hover)
		_G[buttonName]:SetWidth(_G[buttonName].text:GetWidth() + heightSize + 2)
		_G[buttonName]:SetScript('OnMouseDown', Widget_CheckButton_OnMouseDown)
		_G[buttonName]:SetScript('OnMouseUp', Widget_CheckButton_OnMouseUp)
		
		return _G[buttonName]
	end
end