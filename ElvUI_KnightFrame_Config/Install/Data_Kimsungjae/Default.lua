--Cache global variables
--Lua functions
local unpack = unpack

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--WoW API / Variables
local SetCVar = SetCVar

--------------------------------------------------------------------------------
--<< KnightFrame : Default Install Data	- Kimsungjae						>>--
--------------------------------------------------------------------------------
KF_Config.Install_Layout_Data.Kimsungjae.Default = {
	TotemBarMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'188',
	BNETMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-120'..Info.MoverDelimiter..'-234',
	VehicleSeatMover = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-300'..Info.MoverDelimiter..'188',
	GMMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-120'..Info.MoverDelimiter..'-234',
	BagsMover = 'TOPRIGHT'..Info.MoverDelimiter..'UIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-272'..Info.MoverDelimiter..'-6',
	TempEnchantMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-4'..Info.MoverDelimiter..'-250',
	AltPowerBarMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-75',
	AlertFrameMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-150',
	MinimapMover = 'TOPLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'-38',
	BuffsMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-21'..Info.MoverDelimiter..'-37',
	DebuffsMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-21'..Info.MoverDelimiter..'-184',
	BossButton = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'340',
	ElvUF_RaidpetMover = 'TOPLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'736',
	TalkingHeadFrameMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'340',
	
	WatchFrameMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-120'..Info.MoverDelimiter..'-308',
	MicrobarMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-408'..Info.MoverDelimiter..'-4',
	LootFrameMover = 'TOPLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'-224',
	
	--UnitFrame
	ElvUF_PlayerMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-266'..Info.MoverDelimiter..'244',
	ElvUF_TargetMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'266'..Info.MoverDelimiter..'244',
	ElvUF_TargetTargetMover = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-431'..Info.MoverDelimiter..'268',
	ElvUF_FocusMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-66'..Info.MoverDelimiter..'268',
	ElvUF_FocusCastbarMover = 'TOP'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOP'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'-200',
	ElvUF_FocusTargetMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'66'..Info.MoverDelimiter..'268',
	ElvUF_PetMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'430'..Info.MoverDelimiter..'268',
	ElvUF_AssistMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'426',
	ElvUF_TankMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'484',
	ArenaHeaderMover = 'TOPRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPRIGHT'..Info.MoverDelimiter..'-40'..Info.MoverDelimiter..'-340',
	BossHeaderMover = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-40'..Info.MoverDelimiter..'355',
	ElvUF_PartyMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'188',
	ElvUF_RaidMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'188',
	ElvUF_Raid40Mover = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'188',
	
	ElvUF_PlayerCastbarMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-266'..Info.MoverDelimiter..'218',
	ElvUF_TargetCastbarMover = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'266'..Info.MoverDelimiter..'218',
	ElvUF_PetTargetMover = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'430'..Info.MoverDelimiter..'218',
	
	--Actionbar
	ElvAB_1 = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'61',
	ElvAB_2 = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'30',
	ElvAB_3 = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'92',
	ElvAB_4 = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-237'..Info.MoverDelimiter..'30',
	ElvAB_5 = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'237'..Info.MoverDelimiter..'30',
	ShiftAB = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'-216'..Info.MoverDelimiter..'188',
	PetAB = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'168'..Info.MoverDelimiter..'188'
}




KF_Config.Install_Profile_Data.Kimsungjae.Default = function()
	SetCVar("statusTextDisplay", "BOTH")
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("showTutorials", 0)
	SetCVar("UberTooltips", 1)
	SetCVar("threatWarning", 3)
	SetCVar('alwaysShowActionBars', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('SpamFilter', 0)
	SetCVar("nameplateShowSelf", 0)
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
			Location = 'BOTTOMLEFT'..Info.MoverDelimiter..'LeftChatPanel'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'5'..Info.MoverDelimiter..'0'
		},
		[(L['MeterAddonPanel'])] = {
			Width = 234,
			Height = 180,
			Tab = {
				Enable = false
			},
			Location = 'BOTTOMRIGHT'..Info.MoverDelimiter..'RightChatPanel'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'-5'..Info.MoverDelimiter..'0'
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
			Location = 'BOTTOM'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOM'..Info.MoverDelimiter..'0'..Info.MoverDelimiter..'4'
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
			Location = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'457'..Info.MoverDelimiter..'8'
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
			Location = 'BOTTOMLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMLEFT'..Info.MoverDelimiter..'554'..Info.MoverDelimiter..'8'
		},
		KnightText2 = {
			Display = {
				Mode = 'Crit Chance',
				PvPMode = 'PvP Resilience'
			},
			Location = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-554'..Info.MoverDelimiter..'8'
		},
		KnightText3 = {
			Display = {
				Mode = 'Mastery'
			},
			Location = 'BOTTOMRIGHT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'BOTTOMRIGHT'..Info.MoverDelimiter..'-446'..Info.MoverDelimiter..'8'
		}
	}
	E.db.KnightFrame.Modules.ExpRepDisplay = {
		EmbedPanel = L['ActionBarPanel'],
		EmbedLocation = 'DP'
	}
	E.db.KnightFrame.Modules.MinimapBackgroundWhenFarmMode = false
	E.db.KnightFrame.Modules.SmartTracker = {
		Location = 'TOPLEFT'..Info.MoverDelimiter..'ElvUIParent'..Info.MoverDelimiter..'TOPLEFT'..Info.MoverDelimiter..'4'..Info.MoverDelimiter..'-262'
	}
end