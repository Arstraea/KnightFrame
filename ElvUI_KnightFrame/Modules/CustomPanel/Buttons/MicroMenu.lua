--Cache global variables
--Lua functions
local _G = _G
local unpack, select, gsub = unpack, select, gsub

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local ShowUIPanel = ShowUIPanel
local HideUIPanel = HideUIPanel

local CHARACTER_BUTTON = CHARACTER_BUTTON
local ToggleCharacter = ToggleCharacter
local SPELLBOOK_ABILITIES_BUTTON = SPELLBOOK_ABILITIES_BUTTON
local ToggleSpellBook = ToggleSpellBook
local TALENTS_BUTTON = TALENTS_BUTTON
local TalentMicroButton_OnClick = TalentMicroButton_OnClick
local QUESTLOG_BUTTON = QUESTLOG_BUTTON
local ToggleQuestLog = ToggleQuestLog
local COLLECTIONS = COLLECTIONS
local ToggleCollectionsJournal = ToggleCollectionsJournal
local ACHIEVEMENT_BUTTON = ACHIEVEMENT_BUTTON
local ToggleAchievementFrame = ToggleAchievementFrame
local SOCIAL_BUTTON = SOCIAL_BUTTON
local ToggleFriendsFrame = ToggleFriendsFrame
local ACHIEVEMENTS_GUILD_TAB = ACHIEVEMENTS_GUILD_TAB
local ToggleGuildFrame = ToggleGuildFrame
local SLASH_CALENDAR1 = SLASH_CALENDAR1
local LFG_TITLE = LFG_TITLE
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
local ENCOUNTER_JOURNAL = ENCOUNTER_JOURNAL
local ToggleEncounterJournal = ToggleEncounterJournal
local PLAYER_V_PLAYER = PLAYER_V_PLAYER
local TogglePVPUI = TogglePVPUI
local MAINMENU_BUTTON = MAINMENU_BUTTON
local BLIZZARD_STORE = BLIZZARD_STORE
local ToggleStoreUI = ToggleStoreUI

--------------------------------------------------------------------------------
--<< KnightFrame : Panel - MicroMenu Button									>>--
--------------------------------------------------------------------------------
local c1, c2, c3

local function MiniButton_OnShow(self)
	self:SetBackdropBorderColor(unpack(E.media.bordercolor))
end


local function MiniButton_OnEnter(self)
	KF_MicroMenuHolder.text:SetText(self.buttonText)
	c1, c2, c3 = unpack(E.media.rgbvaluecolor)
	self:SetBackdropColor(c1, c2, c3, 1)
	self:SetBackdropBorderColor(c1, c2, c3)
end


local function MiniButton_OnLeave(self)
	KF_MicroMenuHolder.text:SetText('')
	self:SetBackdropColor(.2, .2, .2, 1)
	self:SetBackdropBorderColor(unpack(E.media.bordercolor))
	self:SetPoint('CENTER', self.xOffset, self.yOffset)
end


local function MiniButton_OnMouseDown(self)
	self:SetPoint('CENTER', self.xOffset, self.yOffset - 2)
end


local function MiniButton_OnMouseUp(self)
	self:SetPoint('CENTER', self.xOffset, self.yOffset)
end


local function CreateMiniButton(self, xOffset, yOffset, Text, Script)
	self = CreateFrame('Button', nil, KF_MicroMenuHolder)
	self:Size(28,14)
	self:SetBackdrop({
		bgFile = E.media.blankTex,
		edgeFile = E.media.blankTex,
		tile = false, tileSize = 0, edgeSize = E.mult,
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	self:SetBackdropColor(.2, .2, .2, 1)
	self:SetBackdropBorderColor(unpack(E.media.bordercolor))
	self:Point('CENTER', KF_MicroMenuHolder, xOffset, yOffset)
	self.buttonText = Text
	self.xOffset = xOffset
	self.yOffset = yOffset
	
	self:SetScript('OnShow', MiniButton_OnShow)
	self:SetScript('OnEnter', MiniButton_OnEnter)
	self:SetScript('OnLeave', MiniButton_OnLeave)
	self:SetScript('OnMouseDown', MiniButton_OnMouseDown)
	self:SetScript('OnMouseUp', MiniButton_OnMouseUp)
	self:SetScript('OnClick', Script)
end


KF.UIParent.Button.MicroMenu = {
	Text = 'M',
	
	OnEnter = function(Button)
		Button.text:SetText(KF:Color_Value(KF.UIParent.Button.MicroMenu.Text))
		
		GameTooltip:SetOwner(Button, 'ANCHOR_TOP', 0, 2)
		GameTooltip:ClearLines()
		GameTooltip:AddLine('Open '..KF:Color_Value('Micro Menu'), 1, 1, 1)
		GameTooltip:Show()
	end,
	
	OnLeave = function(Button)
		GameTooltip:Hide()
		
		if not (KF_MicroMenuHolder and KF_MicroMenuHolder:IsShown()) then
			Button.text:SetText(KF.UIParent.Button.MicroMenu.Text)
		end
	end,
	
	OnClick = function(Button, pressedButton)
		GameTooltip:Hide()
		
		if not KF_MicroMenuHolder then
			CreateFrame('Frame', 'KF_MicroMenuHolder', KF.UIParent):SetFrameStrata('TOOLTIP')
			KF_MicroMenuHolder:SetFrameLevel(7)
			KF_MicroMenuHolder:Size(224, 72)
			KF_MicroMenuHolder:SetTemplate('Default', true)
			KF:TextSetting(KF_MicroMenuHolder, '', { Tag = 'tag', FontSize = 12 }, 'TOP', 0, -3)
			KF:TextSetting(KF_MicroMenuHolder, '', { FontSize = 12 }, 'CENTER', 0, 11)
			
			CreateMiniButton(Button1,	-93, -6,	'|cff1784d1'..CHARACTER_BUTTON,						function() ToggleFrame(KF_MicroMenuHolder) ToggleCharacter('PaperDollFrame') Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button2,	-62, -6,	'|cff228b22'..SPELLBOOK_ABILITIES_BUTTON,	function() ToggleFrame(KF_MicroMenuHolder) ToggleSpellBook(BOOKTYPE_SPELL) Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button3,	-31, -6,	'|cff1784d1'..TALENTS_BUTTON,							function() ToggleFrame(KF_MicroMenuHolder) TalentMicroButton_OnClick(TalentMicroButton) Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button4,	0, -6,		'|cff228b22'..QUESTLOG_BUTTON,						function() ToggleFrame(KF_MicroMenuHolder) ToggleQuestLog() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button5,	31, -6,		'|cff1784d1'..COLLECTIONS,									function() ToggleFrame(KF_MicroMenuHolder) ToggleCollectionsJournal() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button6,	62, -6,		'|cff228b22'..ACHIEVEMENT_BUTTON,					function() ToggleFrame(KF_MicroMenuHolder) ToggleAchievementFrame() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button7,	93, -6,		'|cff1784d1'..SOCIAL_BUTTON,							function() ToggleFrame(KF_MicroMenuHolder) ToggleFriendsFrame(1) Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button8,	-93, -24,	'|cff228b22'..ACHIEVEMENTS_GUILD_TAB,			function() ToggleFrame(KF_MicroMenuHolder) ToggleGuildFrame() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button9,	-62, -24,	'|cff1784d1'..gsub(gsub(SLASH_CALENDAR1, '/', ''), '^%l', string.upper), function() ToggleFrame(KF_MicroMenuHolder) GameTimeFrame:Click() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button10,	-31, -24,	'|cff228b22'..LFG_TITLE,										function() ToggleFrame(KF_MicroMenuHolder) PVEFrame_ToggleFrame() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button11,	0, -24,		'|cff1784d1'..ENCOUNTER_JOURNAL,					function() ToggleFrame(KF_MicroMenuHolder) ToggleEncounterJournal() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button12,	31, -24,	'|cff228b22'..PLAYER_V_PLAYER,							function() ToggleFrame(KF_MicroMenuHolder) TogglePVPUI() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button13,	62, -24,	'|cff1784d1'..MAINMENU_BUTTON,						function() ToggleFrame(KF_MicroMenuHolder) ToggleFrame(GameMenuFrame) Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
			CreateMiniButton(Button14,	93, -24,	'|cff228b22'..BLIZZARD_STORE,							function() ToggleFrame(KF_MicroMenuHolder) ToggleStoreUI() Button.text:SetText(KF.UIParent.Button.MicroMenu.Text) end)
		else
			ToggleFrame(KF_MicroMenuHolder)
		end
		
		if KF_MicroMenuHolder:IsShown() then
			Button.text:SetText(KF:Color_Value(KF.UIParent.Button.MicroMenu.Text))
			KF_MicroMenuHolder:Point('BOTTOM', Button, 'TOP', 0, 2)
			KF_MicroMenuHolder.text:SetText('v |cff6dd66dSelect Menu|r v')
			KF_MicroMenuHolder.tag:SetText('< '..KF:Color_Value('Micro Menu')..' >')
			
			KF.UIParent.Button.AreaToHide.TOP:Point('BOTTOM', KF_MicroMenuHolder, 'TOP', 0, 100)
			KF.UIParent.Button.AreaToHide.TOP:SetParent(KF_MicroMenuHolder)
			KF.UIParent.Button.AreaToHide.BOTTOM:Point('TOP', Button, 'BOTTOM', 0, -6)
			KF.UIParent.Button.AreaToHide.BOTTOM:SetParent(KF_MicroMenuHolder)
			KF.UIParent.Button.AreaToHide.LEFT:Point('RIGHT', KF_MicroMenuHolder, 'LEFT', -100, 0)
			KF.UIParent.Button.AreaToHide.LEFT:SetParent(KF_MicroMenuHolder)
			KF.UIParent.Button.AreaToHide.RIGHT:Point('LEFT', KF_MicroMenuHolder, 'RIGHT', 100, 0)
			KF.UIParent.Button.AreaToHide.RIGHT:SetParent(KF_MicroMenuHolder)
			KF.UIParent.Button.AreaToHide.Function = function()
				KF_MicroMenuHolder:Hide()
				Button.text:SetText(KF.UIParent.Button.MicroMenu.Text)
			end
		else
			Button.text:SetText(KF.UIParent.Button.MicroMenu.Text)
			Button.text:SetPoint('CENTER')
		end
	end
}