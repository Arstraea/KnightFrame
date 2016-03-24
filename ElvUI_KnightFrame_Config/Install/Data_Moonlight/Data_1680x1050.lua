local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--------------------------------------------------------------------------------
--<< KnightFrame : 1680x1050 Install Data - Moonlight						>>--
--------------------------------------------------------------------------------
KF_Config.Install_Layout_Data.Moonlight['1680x1050'] = {
	TotemBarMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'256',
	BNETMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-224'..Info.MoverDelimiter..'-238',
	VehicleSeatMover = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'464'..Info.MoverDelimiter..'228',
	GMMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-14'..Info.MoverDelimiter..'-238',
	BagsMover = 'TOPRIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-272'..Info.MoverDelimiter..'-6',
	TempEnchantMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-20'..Info.MoverDelimiter..'-251',
	AltPowerBarMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-120',
	AlertFrameMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-170',
	MinimapMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-1'..Info.MoverDelimiter..'4',
	BuffsMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-14'..Info.MoverDelimiter..'-42',
	DebuffsMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-14'..Info.MoverDelimiter..'-188',
	BossButton = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'400',
	
	--UnitFrame
	ElvUF_PlayerMover = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-232'..Info.MoverDelimiter..'276',
	ElvUF_TargetMover = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'232'..Info.MoverDelimiter..'276',
	ElvUF_TargetTargetMover = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'412'..Info.MoverDelimiter..'305',
	ElvUF_FocusMover = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-412'..Info.MoverDelimiter..'305',
	ElvUF_FocusCastbarMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-200',
	ElvUF_FocusTargetMover = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-412'..Info.MoverDelimiter..'267',
	ElvUF_PetMover = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'313',
	ElvUF_AssistMover = 'LEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'LEFT'..Info.MoverDelimiter..'10'..Info.MoverDelimiter..'16',
	ElvUF_TankMover = 'LEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'LEFT'..Info.MoverDelimiter..'10'..Info.MoverDelimiter..'72',
	ArenaHeaderMover = 'BOTTOMRIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'RIGHT'..Info.MoverDelimiter..'-68'..Info.MoverDelimiter..'-188',
	BossHeaderMover = 'BOTTOMRIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'RIGHT'..Info.MoverDelimiter..'-68'..Info.MoverDelimiter..'-188',
	ElvUF_PartyMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'198',
	ElvUF_RaidMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'189',
	ElvUF_Raid40Mover = 'BOTTOMLEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'189',
	
	--Actionbar
	ElvAB_1 = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'188',
	ElvAB_2 = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-261'..Info.MoverDelimiter..'188',
	ElvAB_3 = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'188',
	ElvAB_4 = 'RIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'RIGHT'..Info.MoverDelimiter..'-4'..Info.MoverDelimiter..'0',
	ElvAB_5 = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'261'..Info.MoverDelimiter..'188',
	ElvAB_6 = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'600',
	ShiftAB = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-310'..Info.MoverDelimiter..'251',
	PetAB = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'251',
}




KF_Config.Install_Profile_Data.Moonlight['1680x1050'] = function()
	SetCVar('alternateResourceText', 1)
	SetCVar('statusTextDisplay', 'BOTH')
	SetCVar('ShowClassColorInNameplate', 1)
	SetCVar('screenshotQuality', 10)
	SetCVar('chatMouseScroll', 1)
	SetCVar('chatStyle', 'classic')
	SetCVar('WholeChatWindowClickable', 0)
	SetCVar('showTutorials', 0)
	SetCVar('UberTooltips', 1)
	SetCVar('threatWarning', 3)
	SetCVar('alwaysShowActionBars', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('SpamFilter', 0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()
	
	E.db.general.minimap.size = nil
	
	E.db.chat.panelWidth = 363
	E.db.chat.panelHeight = nil
	
	E.db.datatexts.panels = nil
	
	E.db.unitframe = {
		units = {
			player = {
				width = 230,
				
				castbar = {
					width = 230
				}
			},
			
			target = {
				width = 230,
				
				castbar = {
					width = 230
				}
			},
			
			targettarget = {
				width = 120
			},
			
			focus = {
				width = 120
			},
			
			focustarget = {
				width = 120
			},
			
			party = {
				width = 200,
				height = 45,
				debuffs = {
					perrow = 6
				}
			},
			
			raid10 = {
				width = 67,
				height = 56
			},
			
			raid25 = {
				width = 67,
				height = 56
			},
			
			raid40 = {
				width = 67,
				height = 34
			}
		}
	}
	
	E.db.actionbar = {
		bar1 = {
			buttonsize = 24
		},
		
		bar2 = {
			buttonsize = 24
		},
		
		bar3 = {
			buttonsize = 24
		},
		
		bar4 = {
			buttonsize = 24
		},
		
		bar5 = {
			buttonsize = 24
		}
	}
	
	E.global.general.autoScale = true
	
	E.db.KnightFrame.Modules = E.db.KnightFrame.Modules or {}
	E.db.KnightFrame.Modules.CustomPanel = {
		[(L['MiddleChatPanel'])] = {
			Width = 383,
			Height = 180,
			DP = {
				ButtonLeft = {
					[1] = 'Config'
				},
				ButtonRight = {
					[1] = 'BlueItemInfo3'
				}
			},
			Location = 'BOTTOMLEFT'..Info.MoverDelimiter..'LeftChatPanel'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'5'..Info.MoverDelimiter..'0'
		},
		[(L['MeterAddonPanel'])] = {
			Width = 384,
			Height = 180,
			Tab = {
				ButtonRight = {
					[1] = 'InvenCraftInfo2'
				}
			},
			DP = {
				ButtonLeft = {
					[1] = 'Findparty'
				},
				ButtonRight = {
					[1] = 'MicroMenu'
				}
			},
			Location = 'BOTTOMRIGHT'..Info.MoverDelimiter..'RightChatPanel'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'-5'..Info.MoverDelimiter..'0'
		},
	}
	E.db.KnightFrame.Modules.FloatingDatatext = {
		SpecText = {
			Display = {
				Mode = 'SpecSwitch |cff2eb7e4(KF)'
			},
			Backdrop = {
				Enable = true,
				CustomColor = true,
				Width = 70,
				CustomColor_Backdrop = { r = 1, g = 1, b = 1, a = 1 }
			},
			Font = {
				UseCustomFontStyle = true,
				FontSize = 12
			},
			Location = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'136'..Info.MoverDelimiter..'7'
		},
		KnightText1 = {
			Display = {
				Mode = '0',
				PvPMode = 'PvP Power',
				Tank = 'Avoidance',
				Melee = 'Attack Power',
				Caster = 'Spell/Heal Power',
				Healer = 'Spell/Heal Power'
			},
			Location = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'220'..Info.MoverDelimiter..'8'
		},
		KnightText2 = {
			Display = {
				Mode = 'Crit Chance',
				PvPMode = 'PvP Resilience'
			},
			Location = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-478'..Info.MoverDelimiter..'8'
		},
		KnightText3 = {
			Display = {
				Mode = 'Mastery'
			},
			Location = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-386'..Info.MoverDelimiter..'8'
		}
	}
	E.db.KnightFrame.Modules.ExpRepDisplay = {
		EmbedPanel = L['MiddleChatPanel'],
		EmbedLocation = 'DP'
	}
	E.db.KnightFrame.Modules.SmartTracker = {
		Location = 'TOPLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPLEFT'..Info.MoverDelimiter..'11'..Info.MoverDelimiter..'-258'
	}
end