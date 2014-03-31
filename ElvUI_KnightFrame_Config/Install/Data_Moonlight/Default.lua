﻿local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2014. 2. 5
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF or not KF_Config then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Default Install Data	- Moonlight							>>--
--------------------------------------------------------------------------------
KF_Config.Install_Layout_Data['Moonlight']['Default'] = {
	['TotemBarMover'] = 'BOTTOMElvUIParentBOTTOM0256',
	['BNETMover'] = 'TOPRIGHTElvUIParentTOPRIGHT-224-238',
	['VehicleSeatMover'] = 'CENTERUIParentBOTTOM464228',
	['GMMover'] = 'TOPRIGHTElvUIParentTOPRIGHT-14-238',
	['BagsMover'] = 'TOPRIGHTUIParentTOPRIGHT-272-6',
	['TempEnchantMover'] = 'TOPRIGHTElvUIParentTOPRIGHT-20-251',
	['AltPowerBarMover'] = 'TOPElvUIParentTOP0-120',
	['AlertFrameMover'] = 'TOPElvUIParentTOP0-170',
	['MinimapMover'] = 'BOTTOMElvUIParentBOTTOM-14',
	['BuffsMover'] = 'TOPRIGHTElvUIParentTOPRIGHT-14-42',
	['DebuffsMover'] = 'TOPRIGHTElvUIParentTOPRIGHT-14-188',
	['BossButton'] = 'CENTERUIParentBOTTOM0400',
	
	--UnitFrame
	['ElvUF_PlayerMover'] = 'BOTTOMUIParentBOTTOM-253282',
	['ElvUF_TargetMover'] = 'BOTTOMUIParentBOTTOM253282',
	['ElvUF_TargetTargetMover'] = 'CENTERUIParentBOTTOM458311',
	['ElvUF_FocusMover'] = 'CENTERUIParentBOTTOM-458311',
	['ElvUF_FocusCastbarMover'] = 'TOPElvUIParentTOP0-200',
	['ElvUF_FocusTargetMover'] = 'CENTERUIParentBOTTOM-458273',
	['ElvUF_PetMover'] = 'CENTERUIParentBOTTOM0319',
	['ElvUF_AssistMover'] = 'LEFTUIParentLEFT1016',
	['ElvUF_TankMover'] = 'LEFTUIParentLEFT1072',
	['ArenaHeaderMover'] = 'BOTTOMRIGHTUIParentRIGHT-68-188',
	['BossHeaderMover'] = 'BOTTOMRIGHTUIParentRIGHT-68-188',
	['ElvUF_PartyMover'] = 'BOTTOMLEFTUIParentBOTTOMLEFT4198',
	['ElvUF_Raid10Mover'] = 'BOTTOMLEFTUIParentBOTTOMLEFT4189',
	['ElvUF_Raid25Mover'] = 'BOTTOMLEFTUIParentBOTTOMLEFT4189',
	['ElvUF_Raid40Mover'] = 'BOTTOMLEFTUIParentBOTTOMLEFT4189',
	
	--Actionbar
	['ElvAB_1'] = 'BOTTOMUIParentBOTTOM0188',
	['ElvAB_2'] = 'BOTTOMUIParentBOTTOM-288188',
	['ElvAB_3'] = 'BOTTOMUIParentBOTTOM0188',
	['ElvAB_4'] = 'RIGHTUIParentRIGHT-40',
	['ElvAB_5'] = 'BOTTOMUIParentBOTTOM288188',
	['ElvAB_6'] = 'BOTTOMUIParentBOTTOM0600',
	['ShiftAB'] = 'BOTTOMLEFTUIParentBOTTOM-383257',
	['PetAB'] = 'BOTTOMElvUIParentBOTTOM0256',
}

KF_Config.Install_Profile_Data['Moonlight']['Default'] = function()
	SetCVar('mapQuestDifficulty', 1)
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
	SetCVar('Sound_EnableSoundWhenGameIsInBG', 1)
	SetCVar('cameraSmoothTrackingStyle', 0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()
	
	E.db['general']['minimap']['size'] = nil
	
	E.db['chat']['panelWidth'] = nil
	E.db['chat']['panelHeight'] = nil
	
	E.db['datatexts']['panels'] = nil
	
	E.db['unitframe'] = nil
	
	E.db['actionbar'] = nil
	
	E.global.general.autoScale = true
	
	E.db.KnightFrame.Modules = E.db.KnightFrame.Modules or {}
	E.db.KnightFrame.Modules.CustomPanel = {
		[(L['MiddleChatPanel'])] = {
			['Width'] = 442,
			['Height'] = 180,
			['DP'] = {
				['ButtonLeft'] = {
					[1] = 'Config',
				},
				['ButtonRight'] = {
					[1] = 'BlueItemInfo3',
				},
			},
			['Location'] = 'BOTTOMLEFTLeftChatPanelBOTTOMRIGHT50',
		},
		[(L['MeterAddonPanel'])] = {
			['Width'] = 443,
			['Height'] = 180,
			['Tab'] = {
				['ButtonRight'] = {
					[1] = 'InvenCraftInfo2',
				},
			},
			['DP'] = {
				['ButtonLeft'] = {
					[1] = 'Findparty',
				},
				['ButtonRight'] = {
					[1] = 'MicroMenu',
				},
			},
			['Location'] = 'BOTTOMRIGHTRightChatPanelBOTTOMLEFT-50',
		},
	}
	E.db.KnightFrame.Modules.FloatingDatatext = {
		['SpecText'] = {
			['Display'] = {
				['Mode'] = 'SpecSwitch |cff2eb7e4(KF)',
			},
			['Backdrop'] = {
				['Enable'] = true,
				['CustomColor'] = true,
				['Width'] = 70,
				['CustomColor_Backdrop'] = { r = 1, g = 1, b = 1, a = 1, },
			},
			['Font'] = {
				['UseCustomFontStyle'] = true,
				['FontSize'] = 12,
			},
			['Location'] = 'BOTTOMElvUIParentBOTTOM1367',
		},
		['KnightText1'] = {
			['Display'] = {
				['Mode'] = '0',
				['PvPMode'] = 'PvP Power',
				['Tank'] = 'Avoidance',
				['Melee'] = 'Attack Power',
				['Caster'] = 'Spell/Heal Power',
				['Healer'] = 'Spell/Heal Power',
			},
			['Location'] = 'BOTTOMElvUIParentBOTTOM2348',
		},
		['KnightText2'] = {
			['Display'] = {
				['Mode'] = '0',
				['PvPMode'] = 'PvP Resilience',
				['Tank'] = 'Expertise',
				['Melee'] = 'Crit Chance',
				['Caster'] = 'Crit Chance',
				['Healer'] = 'Mastery',
			},
			['Location'] = 'BOTTOMElvUIParentBOTTOM3408',
		},
		['KnightText3'] = {
			['Display'] = {
				['Mode'] = '0',
				['Tank'] = 'Hit Rating',
				['Melee'] = 'Hit Rating',
				['Caster'] = 'Hit Rating',
				['Healer'] = 'Mana Regen',
			},
			['Location'] = 'BOTTOMElvUIParentBOTTOM4468',
		},
		['Banner & Stormlash'] = {
			['Display'] = {
				['Mode'] = 'DPS Utility |cff2eb7e4(KF)',
			},
			['Location'] = 'BOTTOMElvUIParentBOTTOM0435',
		},
	}
	E.db.KnightFrame.Modules.ExpRepDisplay = {
		['EmbedPanel'] = L['MiddleChatPanel'],
		['EmbedLocation'] = 'DP',
	}
	E.db.KnightFrame.Modules.RaidCooldown = {
		['Location'] = 'TOPLEFTElvUIParentTOPLEFT11-258',
	}
end