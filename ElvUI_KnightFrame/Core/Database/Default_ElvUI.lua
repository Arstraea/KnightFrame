local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

P.hideTutorial = 1
if E.db.KnightFrame and E.db.KnightFrame.UseProfile == true then
	-- Private
	V.general.chatBubbles = 'disabled'
	V.bags.enable = false
	V.bags.bagBar = true
	
	-- Core
	P.general.loginmessage = false
	P.general.autoRepair = "GUILD"
	P.general.vendorGrays = true
	P.general.valuecolor = { r = 46/255, g = 183/255, b = 227/255 }
	P.general.minimap.size = 157
	P.general.minimap.locationText = 'SHOW'
	P.general.experience.orientation = 'HORIZONTAL'
	P.general.reputation.orientation = 'HORIZONTAL'
	P.general.threat.enable = false
	P.general.totems.growthDirection = 'HORIZONTAL'

	-- Bags
	P.bags.bagBar.growthDirection = 'HORIZONTAL'
	P.bags.bagBar.size = 24
	P.bags.bagBar.spacing = 1
	P.bags.bagBar.mouseover = true
	
	-- NamePlate
	P.nameplate.fontOutline = 'OUTLINE'
	P.nameplate.nonTargetAlpha = 0.35
	P.nameplate.healthBar.width = 120
	P.nameplate.healthBar.height = 4
	P.nameplate.healthBar.text.enable = true
	P.nameplate.healthBar.text.format = 'PERCENT'
	P.nameplate.castBar.height = 7
	P.nameplate.castBar.color = { r = 1, g = 1, b = 1 }
	P.nameplate.raidHealIcon.xOffset = 0
	P.nameplate.raidHealIcon.yOffset = 12
	P.nameplate.raidHealIcon.attachTo = 'TOP'
	P.nameplate.buffs.fontSize = 8
	P.nameplate.buffs.fontOutline = 'OUTLINE'
	P.nameplate.buffs.numAuras = 5
	P.nameplate.debuffs.fontSize = 8
	P.nameplate.debuffs.fontOutline = 'OUTLINE'
	P.nameplate.debuffs.numAuras = 5

	-- Auras
	P.auras.fontSize = 12
	P.auras.fontOutline = 'OUTLINE'
	P.auras.countYOffset = 17
	P.auras.timeYOffset = 6
	
	-- Chat
	P.chat.scrollDownInterval = 0
	P.chat.emotionIcons = false
	P.chat.chatHistory = false
	P.chat.keywords = '%MYNAME%, ElvUI, KnightFrame, KF'
	P.chat.panelWidth = 424
	P.chat.panelTabBackdrop = true
	P.chat.panelTabTransparency = true
	
	-- Datatexts
	P.datatexts.fontOutline = 'OUTLINE'
	P.datatexts.panels.LeftChatDataPanel.left = 'Call to Arms'
	P.datatexts.panels.LeftChatDataPanel.middle = 'Time'
	P.datatexts.panels.LeftChatDataPanel.right = 'System'
	P.datatexts.panels.RightChatDataPanel.left = 'Bags'
	P.datatexts.panels.RightChatDataPanel.middle = 'Durability'
	P.datatexts.panels.RightChatDataPanel.right = 'Gold'

	-- Tooltip
	P.tooltip.cursorAnchor = true
	P.tooltip.inspectInfo = false
	P.tooltip.visibility.unitFrames = 'SHIFT'
	
	-- UnitFrame
	P.unitframe.smoothbars = true
	P.unitframe.fontOutline = 'OUTLINE'
	P.unitframe.OORAlpha = 0.4
	P.unitframe.smartRaidFilter = false
	
	-- UnitFrame : Colors
	P.unitframe.colors.colorhealthbyvalue = false
	P.unitframe.colors.customhealthbackdrop = true
	P.unitframe.colors.auraBarByType = false
	P.unitframe.colors.transparentHealth = true
	P.unitframe.colors.transparentPower = true
	P.unitframe.colors.castColor = { r = 1, g = 1, b = 1 }
	P.unitframe.colors.health = { r = 1, g = 1, b = 1 }
	P.unitframe.colors.health_backdrop = { r = 0.07, g = 0.07, b = 0.07 }
	P.unitframe.colors.tapped = { r = 0, g = 0, b = 0 }
	P.unitframe.colors.disconnected = { r = 0.49, g = 0.51, b = 0.07 }
	P.unitframe.colors.auraBarBuff = { r = 1, g = 1, b = 1 }
	
	-- UnitFrame : Player
	P.unitframe.units.player.width = 260
	P.unitframe.units.player.height = 45
	P.unitframe.units.player.lowmana = 0
	P.unitframe.units.player.health.text_format = '[healthcolor][health:current-percent]'
	--P.unitframe.units.player.health.text_format = '[healthcolor][health:KF-current-percent]'
	P.unitframe.units.player.health.position = 'BOTTOMRIGHT'
	P.unitframe.units.player.health.yOffset = -6
	P.unitframe.units.player.power.height = 8
	P.unitframe.units.player.power.position = 'BOTTOMLEFT'
	P.unitframe.units.player.power.xOffset = 2
	P.unitframe.units.player.power.yOffset = -6
	P.unitframe.units.player.name.text_format = '[difficultycolor][level] [namecolor][name]'
	P.unitframe.units.player.portrait.enable = true
	P.unitframe.units.player.portrait.overlay = true
	P.unitframe.units.player.debuffs.perrow = 14
	P.unitframe.units.player.castbar.width = 260
	P.unitframe.units.player.castbar.height = 20
	P.unitframe.units.player.castbar.format = 'CURRENTMAX'
	
	-- UnitFrame : Target
	P.unitframe.units.target.width = 260
	P.unitframe.units.target.height = 45
	P.unitframe.units.target.health.text_format = '[healthcolor][health:current-percent]'
	--P.unitframe.units.target.health.text_format = '[healthcolor][health:KF-current-percent]'
	P.unitframe.units.target.health.position = 'BOTTOMRIGHT'
	P.unitframe.units.target.health.yOffset = -6
	P.unitframe.units.target.power.height = 8
	P.unitframe.units.target.power.position = 'BOTTOMLEFT'
	P.unitframe.units.target.power.hideonnpc = false
	P.unitframe.units.target.power.xOffset = 2
	P.unitframe.units.target.power.yOffset = -6
	P.unitframe.units.target.name.text_format = '[namecolor][name:medium] [difficultycolor][level] [shortclassification]'
	P.unitframe.units.target.portrait.enable = true
	P.unitframe.units.target.portrait.overlay = true
	P.unitframe.units.target.buffs.perrow = 14
	P.unitframe.units.target.debuffs.perrow = 14
	P.unitframe.units.target.debuffs.playerOnly.enemy = false
	P.unitframe.units.target.castbar.width = 260
	P.unitframe.units.target.castbar.height = 20
	P.unitframe.units.target.castbar.format = 'CURRENTMAX'
	
	-- UnitFrame : TargetTarget
	P.unitframe.units.targettarget.width = 140
	P.unitframe.units.targettarget.height = 31
	P.unitframe.units.targettarget.health.text_format = '[healthcolor][health:percent]'
	P.unitframe.units.targettarget.health.xOffset = 1
	P.unitframe.units.targettarget.power.height = 5
	P.unitframe.units.targettarget.name.position = 'LEFT'
	P.unitframe.units.targettarget.name.xOffset = 5
	P.unitframe.units.targettarget.debuffs.anchorPoint = 'TOPLEFT'
	P.unitframe.units.targettarget.debuffs.yOffset = 2
	
	-- UnitFrame : Focus
	P.unitframe.units.focus.width = 140
	P.unitframe.units.focus.height = 31
	P.unitframe.units.focus.health.text_format = '[healthcolor][health:percent]'
	P.unitframe.units.focus.health.xOffset = 1
	P.unitframe.units.focus.power.height = 5
	P.unitframe.units.focus.name.position = 'LEFT'
	P.unitframe.units.focus.name.xOffset = 5
	P.unitframe.units.focus.debuffs.yOffset = 2
	P.unitframe.units.focus.castbar.width = 400
	P.unitframe.units.focus.castbar.height = 24
	P.unitframe.units.focus.castbar.format = 'CURRENTMAX'
	
	-- UnitFrame : FocusTarget
	P.unitframe.units.focustarget.enable = true
	P.unitframe.units.focustarget.width = 140
	P.unitframe.units.focustarget.height = 31
	P.unitframe.units.focustarget.health.text_format = '[healthcolor][health:percent]'
	P.unitframe.units.focustarget.health.xOffset = 1
	P.unitframe.units.focustarget.power.enable = true
	P.unitframe.units.focustarget.power.height = 5
	P.unitframe.units.focustarget.name.position = 'LEFT'
	P.unitframe.units.focustarget.name.xOffset = 5
	
	-- UnitFrame : Pet
	P.unitframe.units.pet.height = 31
	P.unitframe.units.pet.power.height = 4
	P.unitframe.units.pet.buffs.enable = true
	P.unitframe.units.pet.buffs.sizeOverride = 0
	P.unitframe.units.pet.debuffs.enable = true
	P.unitframe.units.pet.debuffs.yOffset = 1
	P.unitframe.units.pet.debuffs.anchorPoint = 'TOPLEFT'
	
	-- UnitFrame : Boss
	P.unitframe.units.boss.width = 260
	P.unitframe.units.boss.height = 45
	P.unitframe.units.boss.health.text_format = '[healthcolor][health:current-percent]'
	--P.unitframe.units.boss.health.text_format = '[healthcolor][health:KF-current-percent]'
	P.unitframe.units.boss.health.position = 'BOTTOMRIGHT'
	P.unitframe.units.boss.health.yOffset = -6
	P.unitframe.units.boss.power.height = 8
	P.unitframe.units.boss.power.text_format = '[powercolor][power:percent]'
	P.unitframe.units.boss.power.position = 'BOTTOMLEFT'
	P.unitframe.units.boss.power.xOffset = 2
	P.unitframe.units.boss.power.yOffset = -6
	P.unitframe.units.boss.portrait.enable = true
	P.unitframe.units.boss.portrait.overlay = true
	P.unitframe.units.boss.name.position = 'CENTER'
	P.unitframe.units.boss.buffs.fontSize = 16
	P.unitframe.units.boss.buffs.sizeOverride = 30
	P.unitframe.units.boss.buffs.xOffset = -4
	P.unitframe.units.boss.buffs.yOffset = 1
	P.unitframe.units.boss.debuffs.numrows = 1
	P.unitframe.units.boss.debuffs.perrow = 14
	P.unitframe.units.boss.debuffs.anchorPoint = 'TOPRIGHT'
	P.unitframe.units.boss.debuffs.playerOnly = false
	P.unitframe.units.boss.debuffs.yOffset = -12
	P.unitframe.units.boss.debuffs.sizeOverride = 0
	P.unitframe.units.boss.castbar.width = 260
	P.unitframe.units.boss.castbar.format = 'CURRENTMAX'
	
	-- UnitFrame : Arena
	P.unitframe.units.arena.width = 260
	P.unitframe.units.arena.height = 45
	P.unitframe.units.arena.health.text_format = '[healthcolor][health:current-percent]'
	--P.unitframe.units.arena.health.text_format = '[healthcolor][health:KF-current-percent]'
	P.unitframe.units.arena.health.position = 'BOTTOMRIGHT'
	P.unitframe.units.arena.health.yOffset = -6
	P.unitframe.units.arena.power.height = 8
	P.unitframe.units.arena.power.position = 'BOTTOMLEFT'
	P.unitframe.units.arena.power.xOffset = 2
	P.unitframe.units.arena.power.yOffset = -6
	P.unitframe.units.arena.name.position = 'CENTER'
	P.unitframe.units.arena.buffs.fontSize = 16
	P.unitframe.units.arena.buffs.sizeOverride = 30
	P.unitframe.units.arena.buffs.yOffset = 0
	P.unitframe.units.arena.debuffs.perrow = 11
	P.unitframe.units.arena.debuffs.anchorPoint = 'TOPLEFT'
	P.unitframe.units.arena.debuffs.xOffset = 8
	P.unitframe.units.arena.debuffs.sizeOverride = 0
	P.unitframe.units.arena.castbar.width = 260
	P.unitframe.units.arena.castbar.format = 'CURRENTMAX'
	P.unitframe.units.arena.pvpTrinket.size = 38
	P.unitframe.units.arena.pvpTrinket.xOffset = -42
	
	-- UnitFrame : Party
	P.unitframe.units.party.verticalSpacing = 15
	P.unitframe.units.party.healPrediction = true
	P.unitframe.units.party.width = 230
	P.unitframe.units.party.height = 45
	P.unitframe.units.party.health.text_format = '[healthcolor][health:current-percent]'
	--P.unitframe.units.party.health.text_format = '[healthcolor][health:KF-current-percent]'
	P.unitframe.units.party.health.position = 'BOTTOMRIGHT'
	P.unitframe.units.party.health.yOffset = -6
	P.unitframe.units.party.power.height = 8
	P.unitframe.units.party.power.position = 'BOTTOMLEFT'
	P.unitframe.units.party.power.xOffset = 2
	P.unitframe.units.party.power.yOffset = -6
	P.unitframe.units.party.name.position = 'CENTER'
	P.unitframe.units.party.buffs.anchorPoint = 'RIGHT'
	P.unitframe.units.party.buffs.yOffset = -15
	P.unitframe.units.party.buffs.sizeOverride = 23
	P.unitframe.units.party.debuffs.perrow = 8
	P.unitframe.units.party.debuffs.attachTo = 'BUFFS'
	P.unitframe.units.party.debuffs.anchorPoint = 'BOTTOMLEFT'
	P.unitframe.units.party.debuffs.xOffset = 3
	P.unitframe.units.party.debuffs.yOffset = 20
	P.unitframe.units.party.debuffs.sizeOverride = 18
	P.unitframe.units.party.roleIcon.position = 'TOPRIGHT'
	P.unitframe.units.party.targetsGroup.enable = true
	P.unitframe.units.party.targetsGroup.height = 26
	P.unitframe.units.party.targetsGroup.anchorPoint = 'TOPRIGHT'
	P.unitframe.units.party.targetsGroup.xOffset = 103
	P.unitframe.units.party.targetsGroup.yOffset = -26
	
	-- UnitFrame : Raid10
	P.unitframe.units.raid.growthDirection = 'RIGHT_UP'
	P.unitframe.units.raid.horizontalSpacing = 5
	P.unitframe.units.raid.verticalSpacing = 5
	P.unitframe.units.raid.numGroups = 5
	P.unitframe.units.raid.healPrediction = true
	P.unitframe.units.raid.height = 56
	P.unitframe.units.raid.health.text_format = '[healthcolor][health:current]'
	--P.unitframe.units.raid10.health.text_format = '[healthcolor][health:KF-current]'
	P.unitframe.units.raid.health.yOffset = 3
	P.unitframe.units.raid.power.height = 6
	P.unitframe.units.raid.buffIndicator.size = 10
	P.unitframe.units.raid.buffIndicator.fontSize = 15
	P.unitframe.units.raid.rdebuffs.fontSize = 12
	P.unitframe.units.raid.rdebuffs.size = 35
	P.unitframe.units.raid.roleIcon.position = 'CENTER'
	
	-- UnitFrame : Raid40
	P.unitframe.units.raid40.growthDirection = 'RIGHT_UP'
	P.unitframe.units.raid40.horizontalSpacing = 5
	P.unitframe.units.raid40.verticalSpacing = 5
	P.unitframe.units.raid40.healPrediction = true
	P.unitframe.units.raid40.height = 34
	P.unitframe.units.raid40.health.text_format = '[healthcolor][health:percent]'
	--P.unitframe.units.raid40.health.text_format = '[healthcolor][health:KF-percent]'
	P.unitframe.units.raid40.health.yOffset = 2
	P.unitframe.units.raid40.power.enable = true
	P.unitframe.units.raid40.power.height = 5
	P.unitframe.units.raid40.name.position = 'TOP'
	P.unitframe.units.raid40.name.yOffset = 1
	P.unitframe.units.raid40.rdebuffs.enable = true
	P.unitframe.units.raid40.rdebuffs.size = 24
	P.unitframe.units.raid40.roleIcon.enable = true
	P.unitframe.units.raid40.roleIcon.position = 'TOPRIGHT'
	P.unitframe.units.raid40.buffIndicator.size = 10
	P.unitframe.units.raid40.buffIndicator.fontSize = 15
	
	-- UnitFrame : Tank
	P.unitframe.units.tank.enable = false
	P.unitframe.units.tank.targetsGroup.enable = false
	
	-- UnitFrame : Assist
	P.unitframe.units.assist.enable = false
	P.unitframe.units.assist.targetsGroup.enable = false
	
	-- UnitFrame : Filter
	G.unitframe.AuraBarColors[GetSpellInfo(2825)] = { r = 0.09, g = 0.51, b = 0.82 }
	G.unitframe.AuraBarColors[GetSpellInfo(32182)] = { r = 0.09, g = 0.51, b = 0.82 }
	G.unitframe.AuraBarColors[GetSpellInfo(80353)] = { r = 0.09, g = 0.51, b = 0.82 }
	G.unitframe.AuraBarColors[GetSpellInfo(90355)] = { r = 0.09, g = 0.51, b = 0.82 }
	G.unitframe.AuraBarColors[GetSpellInfo(146555)] = { r = 0.09, g = 0.51, b = 0.82 }
	G.unitframe.aurafilters.Whitelist.spells[GetSpellInfo(146555)] = { enable = true, priority = 0 }
	
	-- ActionBar
	P.actionbar.fontOutline = 'OUTLINE'
	P.actionbar.macrotext = true
	P.actionbar.bar1.point = 'TOPLEFT'
	P.actionbar.bar1.backdrop = true
	P.actionbar.bar1.heightMult = 2
	P.actionbar.bar1.buttonsize = 27
	P.actionbar.bar1.buttonspacing = 4
	P.actionbar.bar2.enabled = true
	P.actionbar.bar2.buttonsPerRow = 6
	P.actionbar.bar2.point = 'TOPLEFT'
	P.actionbar.bar2.backdrop = true
	P.actionbar.bar2.buttonsize = 27
	P.actionbar.bar2.buttonspacing = 4
	P.actionbar.bar3.buttons = 12
	P.actionbar.bar3.buttonsPerRow = 12
	P.actionbar.bar3.buttonsize = 27
	P.actionbar.bar3.buttonspacing = 4
	P.actionbar.bar4.point = 'TOPLEFT'
	P.actionbar.bar4.buttonsize = 27
	P.actionbar.bar4.buttonspacing = 4
	P.actionbar.bar5.point = 'TOPLEFT'
	P.actionbar.bar5.backdrop = true
	P.actionbar.bar5.buttons = 12
	P.actionbar.bar5.buttonsize = 27
	P.actionbar.bar5.buttonspacing = 4
	P.actionbar.barPet.buttonsPerRow = 10
	P.actionbar.barPet.point = 'TOPLEFT'
	P.actionbar.barPet.buttonsize = 16
	P.actionbar.barPet.buttonspacing = 2
	P.actionbar.stanceBar.backdrop = true
	P.actionbar.stanceBar.buttonsize = 16
	P.actionbar.stanceBar.buttonspacing = 2
end