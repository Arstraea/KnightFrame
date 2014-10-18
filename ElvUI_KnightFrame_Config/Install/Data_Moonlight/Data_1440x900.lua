﻿local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--------------------------------------------------------------------------------
--<< KnightFrame : 1440x900 Install Data - Moonlight						>>--
--------------------------------------------------------------------------------
KF_Config.Install_Layout_Data.Moonlight['1440x900'] = {
	TotemBarMover = 'BOTTOMElvUIParentBOTTOM0234',
	BNETMover = 'CENTERUIParentTOPRIGHT-240-260',
	VehicleSeatMover = 'CENTERUIParentBOTTOM464228',
	GMMover = 'TOPLEFTUIParentTOPLEFT504-36',
	BagsMover = 'TOPRIGHTUIParentTOPRIGHT-272-6',
	TempEnchantMover = 'TOPRIGHTElvUIParentTOPRIGHT-20-251',
	AltPowerBarMover = 'TOPElvUIParentTOP0-120',
	AlertFrameMover = 'TOPElvUIParentTOP0-170',
	MinimapMover = 'TOPRIGHTElvUIParentTOPRIGHT-13-35',
	BuffsMover = 'TOPRIGHTElvUIParentTOPRIGHT-179-37',
	DebuffsMover = 'TOPRIGHTElvUIParentTOPRIGHT-179-184',
	BossButton = 'BOTTOMElvUIParentBOTTOM0399',
	WatchFrameMover = 'TOPRIGHTElvUIParentTOPRIGHT-101-306',
	
	--UnitFrame
	ElvUF_PlayerMover = 'BOTTOMElvUIParentBOTTOM-262259',
	ElvUF_TargetMover = 'BOTTOMElvUIParentBOTTOM253259',
	ElvUF_TargetTargetMover = 'CENTERUIParentBOTTOM458311',
	ElvUF_FocusMover = 'BOTTOMElvUIParentBOTTOM-68337',
	ElvUF_FocusCastbarMover = 'TOPElvUIParentTOP0-200',
	ElvUF_FocusTargetMover = 'BOTTOMElvUIParentBOTTOM58337',
	ElvUF_PetMover = 'BOTTOMElvUIParentBOTTOM0274',
	ElvUF_AssistMover = 'LEFTUIParentLEFT1016',
	ElvUF_TankMover = 'LEFTUIParentLEFT1072',
	ArenaHeaderMover = 'BOTTOMRIGHTUIParentRIGHT-68-188',
	BossHeaderMover = 'BOTTOMRIGHTUIParentRIGHT-68-188',
	ElvUF_PartyMover = 'BOTTOMLEFTUIParentBOTTOMLEFT4198',
	ElvUF_RaidMover = 'BOTTOMLEFTUIParentBOTTOMLEFT4189',
	ElvUF_Raid40Mover = 'BOTTOMLEFTUIParentBOTTOMLEFT4189',
	
	--Actionbar
	ElvAB_1 = 'BOTTOMElvUIParentBOTTOM0164',
	ElvAB_2 = 'BOTTOMLEFTElvUIParentBOTTOMLEFT427164',
	ElvAB_3 = 'BOTTOMElvUIParentBOTTOM0164',
	ElvAB_4 = 'RIGHTUIParentRIGHT-40',
	ElvAB_5 = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-427164',
	ElvAB_6 = 'BOTTOMUIParentBOTTOM0600',
	ShiftAB = 'BOTTOMLEFTElvUIParentBOTTOMLEFT302159',
	PetAB = 'BOTTOMElvUIParentBOTTOM0234'
}




KF_Config.Install_Profile_Data.Moonlight['1440x900'] = function()
	SetCVar('alternateResourceText', 1)
	SetCVar('statusTextDisplay', 'BOTH')
	SetCVar('ShowClassColorInNameplate', 1)
	SetCVar('screenshotQuality', 10)
	SetCVar('chatMouseScroll', 1)
	SetCVar('chatStyle', 'classic')
	SetCVar('WholeChatWindowClickable', 0)
	SetCVar('ConversationMode', 'inline')
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
			Location = 'BOTTOMLEFTLeftChatPanelBOTTOMRIGHT50'
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
			Location = 'BOTTOMRIGHTRightChatPanelBOTTOMLEFT-50'
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
			Location = 'BOTTOMElvUIParentBOTTOM568'
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
			Location = 'BOTTOMElvUIParentBOTTOM1518'
		},
		KnightText2 = {
			Display = {
				Mode = 'Crit Chance',
				PvPMode = 'PvP Resilience'
			},
			Location = 'BOTTOMElvUIParentBOTTOM2518'
		},
		KnightText3 = {
			Display = {
				Mode = 'Mastery'
			},
			Location = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4168'
		}
	}
	E.db.KnightFrame.Modules.ExpRepDisplay = {
		EmbedPanel = L['MiddleChatPanel'],
		EmbedLocation = 'DP'
	}
	E.db.KnightFrame.Modules.Inspect = {
		Location = 'TOPLEFTElvUIParentTOPLEFT4-15'
	}
	E.db.KnightFrame.Modules.SmartTracker = {
		Appearance = {
			Area_Width = 394,
			Area_Height = 320,
			Area_Visible = false,
			
			RaidIcon_Direction = 4,
			
			Color_MainFrame = { 0.2627450980392157, 0.2627450980392157, 0.2627450980392157 }
		},
		Location = 'TOPLEFTElvUIParentTOPLEFT9-5'
	}
end