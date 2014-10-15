local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--------------------------------------------------------------------------------
--<< KnightFrame : Default Install Data	- Kimsungjae						>>--
--------------------------------------------------------------------------------
KF_Config.Install_Layout_Data.Kimsungjae.Default = {
	TotemBarMover = 'BOTTOMElvUIParentBOTTOM0188',
	BNETMover = 'TOPRIGHTElvUIParentTOPRIGHT-120-234',
	VehicleSeatMover = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-300188',
	GMMover = 'TOPRIGHTElvUIParentTOPRIGHT-120-234',
	BagsMover = 'TOPRIGHTUIParentTOPRIGHT-272-6',
	TempEnchantMover = 'TOPRIGHTElvUIParentTOPRIGHT-4-250',
	AltPowerBarMover = 'TOPElvUIParentTOP0-75',
	AlertFrameMover = 'TOPElvUIParentTOP0-150',
	MinimapMover = 'TOPLEFTElvUIParentTOPLEFT4-38',
	BuffsMover = 'TOPRIGHTElvUIParentTOPRIGHT-21-37',
	DebuffsMover = 'TOPRIGHTElvUIParentTOPRIGHT-21-184',
	BossButton = 'BOTTOMElvUIParentBOTTOM0340',
	
	WatchFrameMover = 'TOPRIGHTElvUIParentTOPRIGHT-120-308',
	MicrobarMover = 'TOPRIGHTElvUIParentTOPRIGHT-408-4',
	LootFrameMover = 'TOPLEFTElvUIParentTOPLEFT4-224',
	
	--UnitFrame
	ElvUF_PlayerMover = 'BOTTOMElvUIParentBOTTOM-266244',
	ElvUF_TargetMover = 'BOTTOMElvUIParentBOTTOM266244',
	ElvUF_TargetTargetMover = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-431268',
	ElvUF_FocusMover = 'BOTTOMElvUIParentBOTTOM-66268',
	ElvUF_FocusCastbarMover = 'TOPElvUIParentTOP0-200',
	ElvUF_FocusTargetMover = 'BOTTOMElvUIParentBOTTOM66268',
	ElvUF_PetMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT430268',
	ElvUF_AssistMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT4426',
	ElvUF_TankMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT4484',
	ArenaHeaderMover = 'TOPRIGHTElvUIParentTOPRIGHT-40-340',
	BossHeaderMover = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-40355',
	ElvUF_PartyMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT4188',
	ElvUF_Raid10Mover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT4188',
	ElvUF_Raid25Mover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT4188',
	ElvUF_Raid40Mover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT4188',
	
	ElvUF_PlayerCastbarMover = 'BOTTOMElvUIParentBOTTOM-266218',
	ElvUF_TargetCastbarMover = 'BOTTOMElvUIParentBOTTOM266218',
	ElvUF_PetTargetMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT430218',
	
	--Actionbar
	ElvAB_1 = 'BOTTOMElvUIParentBOTTOM061',
	ElvAB_2 = 'BOTTOMElvUIParentBOTTOM030',
	ElvAB_3 = 'BOTTOMElvUIParentBOTTOM092',
	ElvAB_4 = 'BOTTOMElvUIParentBOTTOM-23730',
	ElvAB_5 = 'BOTTOMElvUIParentBOTTOM23730',
	ShiftAB = 'BOTTOMElvUIParentBOTTOM-216188',
	PetAB = 'BOTTOMElvUIParentBOTTOM168188'
}




KF_Config.Install_Profile_Data.Kimsungjae.Default = function()
	SetCVar("alternateResourceText", 1)
	SetCVar("statusTextDisplay", "BOTH")
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("showTutorials", 0)
	SetCVar("UberTooltips", 1)
	SetCVar("threatWarning", 3)
	SetCVar('alwaysShowActionBars', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('SpamFilter', 0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()
	
	E.db.general.minimap.size = nil
	
	E.db.chat.panelWidth = nil
	E.db.chat.panelHeight = nil
	
	E.db.datatexts.panels = nil
	
	E.db.unitframe = {
		units = {
			targettarget = {
				width = 130
			},
			
			focus = {
				width = 130
			},
			
			focustarget = {
				width = 130
			}
		}
	}
	
	E.db.actionbar = {
		bar1 = {
			backdrop = false,
			heightMult = 1
		},
		
		bar2 = {
			buttonsPerRow = 12
		},
		
		bar4 = {
			buttonsPerRow = 3
		},
		
		bar5 = {
			buttonsPerRow = 3
		},
		
		barPet = {
			buttonsize = 21,
			buttonspacing = 3
		},

		stanceBar = {
			buttonsize = 21,
			buttonspacing = 3
		},
	}
	
	E.db.KnightFrame.Modules = E.db.KnightFrame.Modules or {}
	E.db.KnightFrame.Modules.CustomPanel = {
		[(L['MiddleChatPanel'])] = {
			Width = 234,
			Height = 180,
			Tab = {
				Enable = false
			},
			Location = 'BOTTOMLEFTLeftChatPanelBOTTOMRIGHT50'
		},
		[(L['MeterAddonPanel'])] = {
			Width = 234,
			Height = 180,
			Tab = {
				Enable = false
			},
			Location = 'BOTTOMRIGHTRightChatPanelBOTTOMLEFT-50'
		},			
		[(L['ActionBarPanel'])] = {
			Width = 576,
			Height = 180,
			DP = {
				ButtonLeft = {
					[1] = 'Config',
					[2] = 'BlueItemInfo3'
				},
				ButtonRight = {
					[1] = 'MicroMenu',
					[2] = 'Findparty'
				}
			},
			Location = 'BOTTOMElvUIParentBOTTOM04'
		},
	}
	E.db.KnightFrame.Modules.FloatingDatatext = {
		SpecText = {
			Display = {
				Mode = 'SpecSwitch |cff2eb7e4(KF)'
			},
			Font = {
				UseCustomFontStyle = true,
				FontSize = 12
			},
			Location = 'BOTTOMLEFTElvUIParentBOTTOMLEFT4578'
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
			Location = 'BOTTOMLEFTElvUIParentBOTTOMLEFT5548'
		},
		KnightText2 = {
			Display = {
				Mode = '0',
				PvPMode = 'PvP Resilience',
				Tank = 'Expertise',
				Melee = 'Crit Chance',
				Caster = 'Crit Chance',
				Healer = 'Mastery'
			},
			Location = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-5548'
		},
		KnightText3 = {
			Display = {
				Mode = '0',
				PvPMode = '',
				Tank = 'Hit Rating',
				Melee = 'Hit Rating',
				Caster = 'Hit Rating',
				Healer = 'Mana Regen'
			},
			Location = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4468'
		},
		['Banner & Stormlash'] = {
			Display = {
				Mode = 'DPS Utility |cff2eb7e4(KF)'
			},
			Location = 'BOTTOMElvUIParentBOTTOM0435'
		}
	}
	E.db.KnightFrame.Modules.ExpRepDisplay = {
		EmbedPanel = L['ActionBarPanel'],
		EmbedLocation = 'DP'
	}
	E.db.KnightFrame.Modules.MinimapBackgroundWhenFarmMode = false
	E.db.KnightFrame.Modules.SmartTracker = {
		Location = 'TOPLEFTElvUIParentTOPLEFT4-262'
	}
end