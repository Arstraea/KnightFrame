local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--------------------------------------------------------------------------------
--<< KnightFrame : 1440x900 Install Data - Moonlight						>>--
--------------------------------------------------------------------------------
KF_Config.Install_Layout_Data.Moonlight['1440x900'] = {
	TotemBarMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'234',
	BNETMover = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-240'..Info.MoverDelimiter..'-260',
	VehicleSeatMover = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'464'..Info.MoverDelimiter..'228',
	GMMover = 'TOPLEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'TOPLEFT'..Info.MoverDelimiter..'504'..Info.MoverDelimiter..'-36',
	BagsMover = 'TOPRIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-272'..Info.MoverDelimiter..'-6',
	TempEnchantMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-20'..Info.MoverDelimiter..'-251',
	AltPowerBarMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-120',
	AlertFrameMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-170',
	MinimapMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-13'..Info.MoverDelimiter..'-35',
	BuffsMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-179'..Info.MoverDelimiter..'-37',
	DebuffsMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-179'..Info.MoverDelimiter..'-184',
	BossButton = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'399',
	WatchFrameMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-101'..Info.MoverDelimiter..'-306',
	
	--UnitFrame
	ElvUF_PlayerMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-262'..Info.MoverDelimiter..'259',
	ElvUF_TargetMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'253'..Info.MoverDelimiter..'259',
	ElvUF_TargetTargetMover = 'CENTER'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'458'..Info.MoverDelimiter..'311',
	ElvUF_FocusMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-68'..Info.MoverDelimiter..'337',
	ElvUF_FocusCastbarMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-200',
	ElvUF_FocusTargetMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'58'..Info.MoverDelimiter..'337',
	ElvUF_PetMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'274',
	ElvUF_AssistMover = 'LEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'LEFT'..Info.MoverDelimiter..'10'..Info.MoverDelimiter..'16',
	ElvUF_TankMover = 'LEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'LEFT'..Info.MoverDelimiter..'10'..Info.MoverDelimiter..'72',
	ArenaHeaderMover = 'BOTTOMRIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'RIGHT'..Info.MoverDelimiter..'-68'..Info.MoverDelimiter..'-188',
	BossHeaderMover = 'BOTTOMRIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'RIGHT'..Info.MoverDelimiter..'-68'..Info.MoverDelimiter..'-188',
	ElvUF_PartyMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'198',
	ElvUF_RaidMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'189',
	ElvUF_Raid40Mover = 'BOTTOMLEFT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'189',
	
	--Actionbar
	ElvAB_1 = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'164',
	ElvAB_2 = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'427'..Info.MoverDelimiter..'164',
	ElvAB_3 = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'164',
	ElvAB_4 = 'RIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'RIGHT'..Info.MoverDelimiter..'-4'..Info.MoverDelimiter..'0',
	ElvAB_5 = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-427'..Info.MoverDelimiter..'164',
	ElvAB_6 = 'BOTTOM'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'600',
	ShiftAB = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'302'..Info.MoverDelimiter..'159',
	PetAB = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'234'
}




KF_Config.Install_Profile_Data.Moonlight['1440x900'] = function()
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
	
	E.db.chat.panelWidth = 380
	E.db.chat.panelHeight = nil
	
	E.db.datatexts.panels = nil
	
	E.db.unitframe = {
		units = {
			focus = {
				width = 120
			},
			
			focustarget = {
				width = 120
			},
			
			party = {
				width = 200
			}
		},
	}
	
	E.db.actionbar = {
		stanceBar = {
			backdrop = true,
			buttonsize = 17,
			point = 'BOTTOMRIGHT'
		}
	}
	
	E.global.general.autoScale = false
	
	E.db.KnightFrame.Modules = E.db.KnightFrame.Modules or {}
	E.db.KnightFrame.Modules.CustomPanel = {
		[(L['MiddleChatPanel'])] = {
			Width = 427,
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
			Width = 427,
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
			Location = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'56'..Info.MoverDelimiter..'8'
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
			Location = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'151'..Info.MoverDelimiter..'8'
		},
		KnightText2 = {
			Display = {
				Mode = 'Crit Chance',
				PvPMode = 'PvP Resilience'
			},
			Location = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'251'..Info.MoverDelimiter..'8'
		},
		KnightText3 = {
			Display = {
				Mode = 'Mastery'
			},
			Location = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-416'..Info.MoverDelimiter..'8'
		}
	}
	E.db.KnightFrame.Modules.ExpRepDisplay = {
		EmbedPanel = L['MiddleChatPanel'],
		EmbedLocation = 'DP'
	}
	E.db.KnightFrame.Modules.Inspect = {
		Location = 'TOPLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'-15'
	}
	E.db.KnightFrame.Modules.SmartTracker = {
		Appearance = {
			Area_Width = 394,
			Area_Height = 320,
			Area_Visible = false,
			
			RaidIcon_Direction = 4,
			
			Color_MainFrame = { 0.2627450980392157, 0.2627450980392157, 0.2627450980392157 }
		},
		Location = 'TOPLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPLEFT'..Info.MoverDelimiter..'9'..Info.MoverDelimiter..'-5'
	}
end