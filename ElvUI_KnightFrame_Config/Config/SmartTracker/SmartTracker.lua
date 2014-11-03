local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--[[
if KF then
	local red, green, blue, alpha
	local ChannelList, ChannelNumber, ChannelName, SelectRaidIcon, IsModified, RaidIconMessage
	local IconInfo = {}

	local function NameColor(Color)
		return KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable ~= false and '|cff'..Color or ''
	end

	CreateFrame('GameTooltip', 'KnightRaidCooldownTooltip', nil, 'GameTooltipTemplate')
	KnightRaidCooldownTooltip:SetOwner(UIParent, 'ANCHOR_NONE')


	KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
	local OptionIndex = KF_Config.OptionsCategoryCount
	KF_Config.Options.args.RaidCooldown = {
		type = 'group',
		name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['RaidCooldown']) end,
		order = 400,
		childGroups = 'tree',
		hidden = function() return KF_Config.ReadyToRunKF == false end,
		args = {
			Enable = {
				type = 'toggle',
				name = ' |cff2eb7e4RaidCooldown |cffffffff'..L['Enable'],
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function()
					return KF.db.Modules.SmartTracker.Enable
				end,
				set = function(_, value)
					KF.db.Modules.SmartTracker.Enable = value
				end,
				disabled = function() return KF.db.Enable == false end,
			},
			Space = {
				type = 'description',
				name = ' ',
				order = 3,
			},
			General = {
				type = 'group',
				name = '|cff1784d1>>|r |cffffffff'..L['General']..' |cff1784d1<<',
				order = 4,
				guiInline = true,
				disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
				args = {
					HideWhenSolo = {
						type = 'toggle',
						name = function() return ' '..NameColor('2eb7e4')..L['Hide When Solo'] end,
						order = 1,
						desc = L["Hides RaidCooldown's window when not in a party or raid."],
						get = function()
							return KF.db.Modules.SmartTracker.General.HideWhenSolo
						end,
						set = function(_, value)
							KF.db.Modules.SmartTracker.General.HideWhenSolo = value
							if value == false then
								if KnightRaidCooldown:GetAlpha() ~= 1 or not KnightRaidCooldown:IsShown() then
									KnightRaidCooldown:Show()
									E:UIFrameFadeIn(KnightRaidCooldown, 1)
								end
							else
								if KF.CurrentGroupMode == 'NoGroup' and (KnightRaidCooldown:GetAlpha() == 1 or KnightRaidCooldown:IsShown()) then
									E:UIFrameFadeOut(KnightRaidCooldown, 1)
									KnightRaidCooldown.fadeInfo.finishedFunc = function() KnightRaidCooldown:Hide() end
								end
							end
						end,
					},
					EraseWhenUserLeftGroup = {
						type = 'toggle',
						name = function() return ' '..NameColor('2eb7e4')..L['Erase Bar'] end,
						order = 2,
						desc = L["Erase specific user's all cooltime bar who left group."],
						get = function()
							return KF.db.Modules.SmartTracker.General.EraseWhenUserLeftGroup
						end,
						set = function(_, value)
							KF.db.Modules.SmartTracker.General.EraseWhenUserLeftGroup = value
						end,
					},
					ShowDetailTooltip = {
						type = 'toggle',
						name = function() return ' '..NameColor('2eb7e4')..L['Detail Tooltip'] end,
						order = 3,
						desc = '',
						descStyle = 'inline',
						get = function()
							return KF.db.Modules.SmartTracker.General.ShowDetailTooltip
						end,
						set = function(_, value)
							KF.db.Modules.SmartTracker.General.ShowDetailTooltip = value
						end,
					},
					Space = {
						type = 'description',
						name = ' ',
						order = 4,
					},
					CooldownEndAnnounceChannel = {
						type = 'select',
						name = function() return ' '..NameColor('2eb7e4')..L['Cooldown End Announce'] end,
						order = 7,
						desc = L["Announce will send this option's selected channel."],
						get = function()
							local value = KF.db.Modules.SmartTracker.General.CooldownEndAnnounce
							if KF.db.Modules.SmartTracker.General.PrivateChannelName then
								local SavedChannel = GetChannelName(KF.db.Modules.SmartTracker.General.PrivateChannelName)
								if SavedChannel == 0 then
									print(L['KF']..' : '..L['Could not find the private channel been stored for the announcement. Channel setting will be chaged to the default.'])
									value = 1
									KF.db.Modules.SmartTracker.General.CooldownEndAnnounce = 1
									KF.db.Modules.SmartTracker.General.PrivateChannelName = nil
								else
									local ChannelList = { GetChannelList() }
									local PrivateChannelNumber = 0
									for i = 1, #ChannelList/2 do
										local _, Check = GetChannelName(ChannelList[i*2-1])
										if not Check:find(' ') then
											PrivateChannelNumber = PrivateChannelNumber + 1
											if ChannelList[i*2] == KF.db.Modules.SmartTracker.General.PrivateChannelName then return 5 + PrivateChannelNumber end
										end
									end
								end
							end
							return value
						end,
						set = function(_, value)
							if value > 5 then
								ChannelNumber, ChannelName = string.split('|cff', ChannelList[value], 2)
								ChannelNumber, ChannelName = GetChannelName(string.sub(ChannelName, 10))
								if ChannelNumber == 0 then
									print(L['KF']..' : '..L['Could not find the private channel been stored for the announcement. Channel setting will be chaged to the default.'])
									value = 1
									KF.db.Modules.SmartTracker.General.PrivateChannelName = nil
								else
									KF.db.Modules.SmartTracker.General.PrivateChannelName = ChannelName
								end
							else
								KF.db.Modules.SmartTracker.General.PrivateChannelName = nil
							end
							
							KF.db.Modules.SmartTracker.General.CooldownEndAnnounce = value
						end,
						values = function()
							local ChannelColor
							ChannelList = {
								[0] = '|cffff5675'..L['Disable'],
								[1] = format('|cff%02x%02x%02x', ChatTypeInfo['SYSTEM'].r*255, ChatTypeInfo['SYSTEM'].g*255, ChatTypeInfo['SYSTEM'].b*255)..L['Self'],
								[2] = format('|cff%02x%02x%02x', ChatTypeInfo['SAY'].r*255, ChatTypeInfo['SAY'].g*255, ChatTypeInfo['SAY'].b*255)..L['Say'],
								[3] = format('|cff%02x%02x%02x', ChatTypeInfo['PARTY'].r*255, ChatTypeInfo['PARTY'].g*255, ChatTypeInfo['PARTY'].b*255)..L['Party'],
								[4] = format('|cff%02x%02x%02x', ChatTypeInfo['RAID'].r*255, ChatTypeInfo['RAID'].g*255, ChatTypeInfo['RAID'].b*255)..L['Raid'],
								[5] = format('|cff%02x%02x%02x', ChatTypeInfo['GUILD'].r*255, ChatTypeInfo['GUILD'].g*255, ChatTypeInfo['GUILD'].b*255)..L['Guild'],
							}
							local PrivateChannelList = { GetChannelList() }
							for i = 1, #PrivateChannelList/2 do
								local _, ChannelName = GetChannelName(PrivateChannelList[i*2-1])
								if not ChannelName:find(' ') then
									ChannelColor = ChatTypeInfo[('CHANNEL'..PrivateChannelList[i*2-1])]
									table.insert(ChannelList, PrivateChannelList[i*2-1]..'. '..format('|cff%02x%02x%02x', ChannelColor.r*255, ChannelColor.g*255, ChannelColor.b*255)..PrivateChannelList[i*2])
								end
							end
							return ChannelList
						end,
					},
					
				},
			},
			Space2 = {
				type = 'description',
				name = ' ',
				order = 5,
			},
			Scan = {
				type = 'group',
				name = '|cff1784d1>>|r |cffffffff'..L["Scan Group Member's Setting"]..' |cff1784d1<<',
				order = 6,
				guiInline = true,
				get = function(info) return KF.db.Modules.SmartTracker.Scan[(info[#info])] end,
				set = function(info, value)
					KF.db.Modules.SmartTracker.Scan[(info[#info])] = value
				end,
				disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
				args = {
					AutoScanning = {
						type = 'toggle',
						name = function() return ' '..NameColor('2eb7e4')..L['Auto Scan'] end,
						order = 1,
						desc = L["RaidCooldown will check group member's setting automatically when there is no data."],
					},
					CheckChanging = {
						type = 'toggle',
						name = function() return ' '..NameColor('2eb7e4')..L['Check Changing'] end,
						order = 2,
						desc = L['If group member CHANGE his setting(specialization or talent or glyph), reinspect him.|n|nThis function works only when that member is near you.'],
					},
					Update = {
						type = 'toggle',
						name = function() return (KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable ~= false and KF.db.Modules.SmartTracker.Scan.AutoScanning ~= false and ' |cff2eb7e4' or ' |cff838383')..L['Update After Scanning'] end,
						order = 3,
						desc = function() return L["After new member's scanning, scan old member's setting for updating."]..(KF.db.Modules.SmartTracker.Scan.AutoScanning == false and '|n|n|cffff0000!!|r |cff2eb7e4'..L['Auto Scan']..'|r '..L['function required'] or '') end,
						set = function(info, value)
							if KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or KF.db.Modules.SmartTracker.Scan.AutoScanning == false then
								return
							else
								KF.db.Modules.SmartTracker.Scan[(info[#info])] = value
							end
						end,
					},
				},
			},
			Space3 = {
				type = 'description',
				name = ' ',
				order = 7,
			},
			Appearance = {
				type = 'group',
				name = '|cff1784d1>>|r |cffffffff'..L['Appearance']..' |cff1784d1<<',
				order = 8,
				guiInline = true,
				disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
				args = {
					Bar = {
						type = 'group',
						name = L['Cooltime Bar'],
						order = 1,
						guiInline = true,
						args = {
							Direction = {
								type = 'select',
								name = function() return ' '..NameColor('2eb7e4')..L['Bar Direction'] end,
								order = 1,
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.Bar_Direction or 2
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.Bar_Direction = value
									KF:RaidCooldown_ChangeBarDirection()
									KF:RaidCooldown_RefreshCooldownBarData()
								end,
								values = {
									[1] = L['Up'],
									[2] = L['Down'],
								},
							},
							Height = {
								type = 'range',
								name = function() return NameColor('2eb7e4')..L['Bar Height'] end,
								order = 2,
								desc = '',
								min = 12,
								max = 40,
								step = 1,
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.Bar_Height or 16
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.Bar_Height = value
									KF:RaidCooldown_RefreshCooldownBarData()
								end,
							},
							Fontsize = {
								type = 'range',
								name = function() return NameColor('2eb7e4')..L['Fontsize'] end,
								order = 3,
								desc = '',
								min = 8,
								max = 30,
								step = 1,
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.Bar_Fontsize or 10
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.Bar_Fontsize = value
									KF:RaidCooldown_RefreshCooldownBarData()
								end,
							},
						},
					},
					RaidIcon = {
						type = 'group',
						name = L['RaidIcon'],
						order = 2,
						guiInline = true,
						args = {
							Size = {
								type = 'range',
								name = function() return NameColor('2eb7e4')..L['Size'] end,
								order = 1,
								desc = '',
								min = 20,
								max = 60,
								step = 1,
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.RaidIcon_Size or 35
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.RaidIcon_Size = value
									KF:RaidCooldown_SettingRaidIcon()
								end,
							},
							Spacing = {
								type = 'range',
								name = function() return NameColor('2eb7e4')..L['Spacing'] end,
								order = 2,
								desc = '',
								min = 0,
								max = 20,
								step = 1,
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing or 5
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing = value
									KF:RaidCooldown_SettingRaidIcon()
								end,
							},
							Fontsize = {
								type = 'range',
								name = function() return NameColor('2eb7e4')..L['Fontsize'] end,
								order = 3,
								desc = '',
								min = 8,
								max = 30,
								step = 1,
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.RaidIcon_Fontsize or 13
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.RaidIcon_Fontsize = value
									KF:RaidCooldown_SettingRaidIcon()
								end,
							},
							Space = {
								type = 'description',
								name = ' ',
								order = 4,
							},
							StartPoint = {
								type = 'select',
								name = function() return ' '..NameColor('2eb7e4')..L['StartPoint'] end,
								order = 5,
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.RaidIcon_StartPoint or 1
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.RaidIcon_StartPoint = value
									KF:RaidCooldown_SettingRaidIcon()
								end,
								values = {
									[1] = L['Left'],
									[2] = L['Right'],
								},
							},
							Direction = {
								type = 'select',
								name = function() return ' '..NameColor('2eb7e4')..L['Direction'] end,
								order = 6,
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction or 3
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction = value
									KF:RaidCooldown_SettingRaidIcon()
								end,
								values = {
									[1] = L['Up'],
									[2] = L['Down'],
									[3] = L['Upper'],
									[4] = L['Below'],
								},
							},
							DisplayMax = {
								type = 'toggle',
								name = function() return ' '..NameColor('2eb7e4')..L['Display MaxCount'] end,
								order = 7,
								desc = '',
								descStyle = 'inline',
								get = function()
									return KF.db.Modules.SmartTracker.Appearance.RaidIcon_DisplayMax
								end,
								set = function(_, value)
									KF.db.Modules.SmartTracker.Appearance.RaidIcon_DisplayMax = value
								end,
							},
						},
					},
					Color = {
						type = 'group',
						name = L['Color'],
						order = 6,
						guiInline = true,
						args = {
							MainFrame = {
								type = 'color',
								name = function() return ' '..NameColor('2eb7e4')..L['MainFrame'] end,
								order = 1,
								hasAlpha = false,
								get = function()
									red = KF.db.Modules.SmartTracker.Appearance.Color_MainFrame[1]
									green = KF.db.Modules.SmartTracker.Appearance.Color_MainFrame[2]
									blue = KF.db.Modules.SmartTracker.Appearance.Color_MainFrame[3]
									
									return red or 1, green or 1, blue or 1, 1
								end,
								set = function(_, r, g, b)
									KF.db.Modules.SmartTracker.Appearance.Color_MainFrame = { r, g, b, }
									KnightRaidCooldown.Tab:SetBackdropColor(r, g, b)
								end,
							},
							BarBackground = {
								type = 'color',
								name = function() return ' '..NameColor('2eb7e4')..L['Bar Background'] end,
								order = 2,
								hasAlpha = true,
								get = function()
									red = KF.db.Modules.SmartTracker.Appearance.Color_BarBackground[1]
									green = KF.db.Modules.SmartTracker.Appearance.Color_BarBackground[2]
									blue = KF.db.Modules.SmartTracker.Appearance.Color_BarBackground[3]
									alpha = KF.db.Modules.SmartTracker.Appearance.Color_BarBackground[4]
									
									return red or 1, green or 1, blue or 1, alpha or 0.2
								end,
								set = function(_, r, g, b, a)
									KF.db.Modules.SmartTracker.Appearance.Color_BarBackground = { r, g, b, a, }
									KF:RaidCooldown_RefreshCooldownBarData()
								end,
							},
							ChargedBar = {
								type = 'color',
								name = function() return ' '..NameColor('2eb7e4')..L['Charged Bar'] end,
								order = 3,
								hasAlpha = false,
								get = function()
									red = KF.db.Modules.SmartTracker.Appearance.Color_ChargedBar[1]
									green = KF.db.Modules.SmartTracker.Appearance.Color_ChargedBar[2]
									blue = KF.db.Modules.SmartTracker.Appearance.Color_ChargedBar[3]
									
									return red or 1, green or 1, blue or 1, 1
								end,
								set = function(_, r, g, b)
									KF.db.Modules.SmartTracker.Appearance.Color_ChargedBar = { r, g, b, }
									KF:RaidCooldown_RefreshCooldownBarData()
								end,
							},
						},
					},
				},
			},
			RaidIcon = {
				type = 'group',
				name = '     |cff2eb7e4'..L['RaidIcon'],
				order = 500,
				desc = '',
				descStyle = 'inline',
				args = {
					General = {
						type = 'group',
						name = '|cff1784d1>>|r |cffffffff'..L['RaidIcon']..' |cff1784d1<<',
						order = 1,
						guiInline = true,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
						args = {
							SelectIcon = {
								type = 'select',
								name = function() return ' '..NameColor('2eb7e4')..L['Select'] end,
								order = 1,
								get = function() return SelectRaidIcon end,
								set = function(_, value)
									SelectRaidIcon = value
									IsModified = nil
									RaidIconMessage = nil
									
									if value == '' or value == '0' then
										IconInfo = {}
									else
										IconInfo = {
											['spellID'] = tonumber(value),
											['Class'] = KF.db.Modules.SmartTracker.RaidIcon[tonumber(value)]['Class'] or nil,
											['Level'] = KF.db.Modules.SmartTracker.RaidIcon[tonumber(value)]['Level'] or nil,
											['Spec'] = KF.db.Modules.SmartTracker.RaidIcon[tonumber(value)]['Spec'] or nil,
											['Talent'] = KF.db.Modules.SmartTracker.RaidIcon[tonumber(value)]['Talent'] or nil,
										}
									end
								end,
								values = function()
									local list = { [''] = '|cffff5675'..NONE, ['0'] = '|cff2eb7e4'..L['Create New Icon'], }
									
									for spellID, isTable in pairs(KF.db.Modules.SmartTracker.RaidIcon) do
										if type(isTable) == 'table' then
											list[tostring(spellID)] = GetSpellInfo(spellID)
										end
									end
									
									return list
								end,
							},
							Space = {
								type = 'description',
								name = ' ',
								order = 2,
								width = 'half',
							},
							Description = {
								type = 'description',
								name = function()
									if RaidIconMessage == 'SaveNew' then
										return L['New RaidIcon Setting have been saved successfully.']
									elseif RaidIconMessage == 'SaveOld' then
										return L['All changes have been saved successfully.']
									elseif RaidIconMessage == 'Delete' then
										return L['Are you sure you want to delete this icon?|nIf yes, press the Delete button again.']
									end
									return ''
								end,
								order = 3,
								width = 'double',
							},
						},
					},
				},
			},
		},
	}


	if KF.Table then
		local ClassCount, SpellCount = 0, 1
		local function RaidCooldown_Construct_ClassSpellOption(class)
			KF_Config.Options.args.RaidCooldown.args[class] = {
				type = 'group',
				name = '     '..L[class],
				order = 100 + ClassCount,
				desc = '',
				descStyle = 'inline',
				args = {
					DESC = {
						type = 'description',
						name = '|cff1784d1>> |cffffffff'..L['Display Skill Setting']..' : '..L[class]..' |cff1784d1<<|n|n   |cff1784d1- |cfff88ef4['..L['Out of Combat']..'] |cffffffff:|n        '..L['Shows cooldown while not in combat with a boss.']..'|n|n   |cff1784d1- |cff93daff['..L['Announce Off']..'] |cffffffff:|n        '..L['Displays cooldown timer without announcing in the selected channel.']..'|n|n   |cff1784d1- |cffff9614['..L['Announce On']..'] |cffffffff:|n        '..L["Displays cooldown timer and announces when they're available in the selected channel."],
						order = 1,
					},
					SpellList = {
						type = 'group',
						name = ' ',
						order = 2,
						guiInline = true,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
						args = {
							Survival = {
								type = 'group',
								name = L['Survival Spells'],
								order = 1,
								guiInline = true,
								args = {},
							},
							Interrupt = {
								type = 'group',
								name = L['Interrupt Spells'],
								order = 3,
								guiInline = true,
								args = {},
							},
							Utility = {
								type = 'group',
								name = L['Utility Spells'],
								order = 5,
								guiInline = true,
								args = {},
							},
						},
					},
				},
			}
			ClassCount = ClassCount + 1
			
			SpellCount = 1
			for spellID, spellTable in pairs(KF.Table['RaidCooldownSpell'][string.upper(class)]) do
				KF_Config.Options.args.RaidCooldown.args[class].args.SpellList.args[(spellTable[3])].args[tostring(spellID)] = {
					type = 'select',
					name = function() return '  |T'..GetSpellTexture(spellID)..':20:20:0:0:64:64:7:57:7:57|t  '..NameColor('2eb7e4')..GetSpellInfo(spellID) end,
					order = SpellCount,
					desc = function()
						KF:HookScript(GameTooltip, 'OnShow', function()
							GameTooltip:SetHyperlink(GetSpellLink(spellID))
							GameTooltip:Show()
							KF:Unhook(GameTooltip, 'OnShow')
						end)
					end,
					values = {
						[0] = '|cffff5675'..L['Disable'],
						[1] = '|cfff88ef4'..L['Out of Combat'],
						[2] = '|cff93daff'..L['Announce Off'],
						[3] = '|cffff9614'..L['Announce On'],
					},
					get = function() return KF.db.Modules.SmartTracker[string.upper(class)][spellID] or 0 end,
					set = function(_, value)
						KF.db.Modules.SmartTracker[string.upper(class)][spellID] = value
						KF:RaidCooldown_RefreshCooldownBarData()
					end,
				}
				SpellCount = SpellCount + 1
			end
		end
		RaidCooldown_Construct_ClassSpellOption('Warrior')
		RaidCooldown_Construct_ClassSpellOption('Hunter')
		RaidCooldown_Construct_ClassSpellOption('Shaman')
		RaidCooldown_Construct_ClassSpellOption('Monk')
		RaidCooldown_Construct_ClassSpellOption('Rogue')
		RaidCooldown_Construct_ClassSpellOption('DeathKnight')
		RaidCooldown_Construct_ClassSpellOption('Mage')
		RaidCooldown_Construct_ClassSpellOption('Druid')
		RaidCooldown_Construct_ClassSpellOption('Paladin')
		RaidCooldown_Construct_ClassSpellOption('Priest')
		RaidCooldown_Construct_ClassSpellOption('Warlock')


		local TalentSpellTable = {
			['WARRIOR'] = {
				[55694] = 4, [107566] = 7, [102060] = 9, [46924] = 10, [46968] = 11, [118000] = 12,
				[114028] = 13, [114029] = 14, [114030] = 15, [107574] = 16, [12292] = 17, [107570] = 18,
			},
			['HUNTER'] = {
				[34490] = 4, [19386] = 5, [109248] = 6, [109304] = 7, [82726] = 10, [120679] = 11,
				[131894] = 13, [130392] = 14, [120697] = 15, [117050] = 16, [109259] = 17, [120360] = 18,
			},
			['SHAMAN'] = {
				[108270] = 2, [108271] = 3, [51485] = 5, [108273] = 6, [108285] = 7, [108287] = 9,
				[16166] = 10, [16188] = 11, [108280] = 13, [108281] = 14,
			},
			['MONK'] = {
				[116841] = 2, [115399] = 9, [116844] = 10, [119392] = 11, [119381] = 12,
				[122278] = 14, [122783] = 15, [116847] = 16, [123904] = 17,
			},
			['ROGUE'] = {
				[74001] = 6, [36554] = 11,
			},
			['DEATHKNIGHT'] = {
				[123693] = 2, [115989] = 3, [49039] = 4, [51052] = 5, [96268] = 7,
				[108194] = 9, [48743] = 10, [108199] = 16, [108200] = 17, [108201] = 18,
			},
			['MAGE'] = {
				[12043] = 1, [108843] = 2, [108839] = 3, [115610] = 4, [11426] = 6, [113724] = 7,
				[111264] = 8, [102051] = 9, [110959] = 10, [11958] = 12, [1463] = 18,
			},
			['DRUID'] = {
				[102280] = 2, [108238] = 5, [102351] = 6, [102359] = 8, [132469] = 9, [106731] = 11,
				[106737] = 12, [99] = 13, [102793] = 14, [5211] = 15, [108288] = 16, [124974] = 18,
			},
			['PALADIN'] = {
				[85499] = 1, [105593] = 4, [20066] = 5, [114039] = 10, [105809] = 13,
				[114165] = 16, [114158] = 17, [114157] = 18,
			},
			['PRIEST'] = {
				[108920] = 1, [108921] = 2, [123040] = 8, [19236] = 10, [112833] = 11,
				[10060] = 14, [121135] = 16, [110744] = 17, [120517] = 18,
			},
			['WARLOCK'] = {
				[108359] = 1, [5484] = 4, [6789] = 5, [30283] = 6, [108416] = 8,
				[110913] = 9, [108482] = 12, [108501] = 14, [108503] = 15, [108505] = 16,
			},
		}

		KF_Config.Options.args.RaidCooldown.args.RaidIcon.args.General.args.ConfigSpace = {
			type = 'group',
			name = ' ',
			order = 6,
			guiInline = true,
			hidden = function() return not (SelectRaidIcon and SelectRaidIcon ~= '') end,
			args = {
				Title = {
					type = 'description',
					name = function() return ' '..NameColor('2eb7e4')..(IconInfo['spellID'] and GetSpellInfo(IconInfo['spellID']) or L['Create New Icon']) end,
					order = 1,
					fontSize = 'large',
					image = function()
						if SelectRaidIcon == nil or SelectRaidIcon == '' then
							return nil
						else
							return (IconInfo['spellID'] and GetSpellTexture(IconInfo['spellID']) or 'Interface\\Icons\\INV_Misc_QuestionMark'), 30, 30
						end
					end,
					imageCoords = {0.1, 0.9, 0.1, 0.9},
					width = 'double',
				},
				Save = {
					type = 'execute',
					name = function() return (KF.db.Modules.SmartTracker.Enable ~= false and IsModified == true and IconInfo['spellID'] and IconInfo['Class'] and GetSpellInfo(IconInfo['spellID']) and '|cff2eb7e4' or '|cff808080')..L['Save'] end,
					order = 2,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						if SelectRaidIcon ~= '0' then
							if P['KnightFrame'].Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)] then
								KF.db.Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)] = false
							else
								KF.db.Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)] = nil
							end
						end
						
						KF.db.Modules.SmartTracker.RaidIcon[IconInfo.spellID] = {
							['Class'] = IconInfo['Class'] or nil,
							['Level'] = IconInfo['Level'] or nil,
							['Spec'] = IconInfo['Spec'] or nil,
							['Talent'] = IconInfo['Talent'] or nil,
						}
						
						IsModified = nil
						SelectRaidIcon = tostring(IconInfo['spellID'])
						
						if SelectRaidIcon ~= '0' then
							RaidIconMessage = 'SaveOld'
						else
							RaidIconMessage = 'SaveNew'
						end
						
						KF:RaidCooldown_SettingRaidIcon()
					end,
					disabled = function() return KF.db.Modules.SmartTracker.Enable == false or not IsModified or not (IconInfo['spellID'] and IconInfo['Class'] and GetSpellInfo(IconInfo['spellID'])) end,
				},
				Reset = {
					type = 'execute',
					name = function() return (KF.db.Modules.SmartTracker.Enable ~= false and IsModified == true and '|cff2eb7e4' or '|cff808080')..L['Reset'] end,
					order = 3,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						IsModified = nil
						RaidIconMessage = nil
						
						if SelectRaidIcon == '0' then
							IconInfo = {}
						else
							IconInfo = {
								['spellID'] = tonumber(SelectRaidIcon),
								['Class'] = KF.db.Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)]['Class'] or nil,
								['Level'] = KF.db.Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)]['Level'] or nil,
								['Spec'] = KF.db.Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)]['Spec'] or nil,
								['Talent'] = KF.db.Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)]['Talent'] or nil,
							}
						end
					end,
					disabled = function() return not IsModified end,
				},
				Delete = {
					type = 'execute',
					name = function() return (KF.db.Modules.SmartTracker.Enable ~= false and SelectRaidIcon ~= '0' and '|cffff5675' or '|cff808080')..L['Delete'] end,
					order = 4,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						if RaidIconMessage ~= 'Delete' then
							RaidIconMessage = 'Delete'
						else
							if P['KnightFrame'].Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)] then
								KF.db.Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)] = false
							else
								KF.db.Modules.SmartTracker.RaidIcon[tonumber(SelectRaidIcon)] = nil
							end
							
							IsModified = nil
							SelectRaidIcon = nil
							RaidIconMessage = nil
							
							KF:RaidCooldown_SettingRaidIcon()
						end
					end,
					disabled = function() return KF.db.Modules.SmartTracker.Enable == false or SelectRaidIcon == '0' end,
				},
				Description = {
					type = 'description',
					name = function()
						if GetSpellInfo(IconInfo['spellID']) then
							KnightRaidCooldownTooltip:ClearLines()
							KnightRaidCooldownTooltip:SetSpellByID(IconInfo['spellID'])
						
							return _G['KnightRaidCooldownTooltipTextLeft'..KnightRaidCooldownTooltip:NumLines()]:GetText()..'|n|n '
						elseif IsModified == true and not GetSpellInfo(IconInfo['spellID']) then
							return '|n |cffff9614SYSTEM|r : '..L['Invalid Spell ID. Please Check Spell ID.']..'|n '
						end
						return '|n|n '
					end,
					order = 5,
				},
				SpellID = {
					type = 'input',
					name = function() return ' '..NameColor('2eb7e4')..L['Spell ID']..'|r  '..NameColor('ff5675')..'('..L['Required']..')' end,
					order = 6,
					get = function() return tostring(IconInfo['spellID'] or '') end,
					set = function(_, value)
						value = tonumber(value)
						RaidIconMessage = nil
						
						if IconInfo['spellID'] ~= value then
							IsModified = true
						end
						
						IconInfo['spellID'] = value
						IconInfo['Talent'] = nil
					end,
				},
				Class = {
					type = 'select',
					name = function() return ' '..NameColor('2eb7e4')..CLASS..'|r  '..NameColor('ff5675')..'('..L['Required']..')' end,
					order = 7,
					get = function() return IconInfo['Class'] end,
					set = function(_, value)
						IsModified = true
						RaidIconMessage = nil
						
						IconInfo['Class'] = value
						IconInfo['Spec'] = nil
						IconInfo['Talent'] = nil
					end,
					values = {
						['WARRIOR'] = L['Warrior'], ['HUNTER'] = L['Hunter'], ['SHAMAN'] = L['Shaman'], ['MONK'] = L['Monk'],
						['ROGUE'] = L['Rogue'], ['DEATHKNIGHT'] = L['DeathKnight'], ['MAGE'] = L['Mage'], ['DRUID'] = L['Druid'],
						['PALADIN'] = L['Paladin'], ['PRIEST'] = L['Priest'], ['WARLOCK'] = L['Warlock'],
					},
				},
				Level = {
					type = 'input',
					name = function() return ' '..NameColor('2eb7e4')..LEVEL end,
					order = 8,
					get = function() return tostring(IconInfo['Level'] or '') end,
					set = function(_, value)
						IsModified = true
						RaidIconMessage = nil
						
						IconInfo['Level'] = tonumber(value)
					end,
				},
				Spec = {
					type = 'select',
					name = function() return ' '..NameColor('2eb7e4')..SPECIALIZATION end,
					order = 9,
					get = function() return IconInfo['Class'] and IconInfo['Spec'] end,
					set = function(_, value)
						IsModified = true
						RaidIconMessage = nil
						
						if value == '' then
							IconInfo['Spec'] = nil
						elseif value then
							IconInfo['Spec'] = value
						end
					end,
					values = function()
						local key = IconInfo['Class']
						local list = { [''] = '|cffff5675'..NONE, }
						
						if key and KF.Table['ClassRole'][key] then
							for specName, SavedData in pairs(KF.Table['ClassRole'][key]) do
								list[specName] = SavedData['Color']..specName
							end
						end
						
						return list
					end,
				},
				Talent = {
					type = 'select',
					name = function() return ' '..NameColor('2eb7e4')..TALENT end,
					order = 10,
					get = function()
						if IconInfo['Class'] then
							if not IconInfo['Talent'] and IconInfo['spellID'] and TalentSpellTable[IconInfo.Class][IconInfo.spellID] then
								IconInfo['Talent'] = TalentSpellTable[IconInfo.Class][IconInfo.spellID]
							end
							
							return tostring(IconInfo['Talent'])
						end
					end,
					set = function(_, value)
						IsModified = true
						RaidIconMessage = nil
						
						if value == '' then
							IconInfo['Talent'] = nil
						elseif value and IconInfo['Class'] then
							value = tonumber(value)
							IconInfo['Talent'] = value
							
							for spellID, SlotNumber in pairs(TalentSpellTable[IconInfo.Class]) do
								if SlotNumber == value then
									IconInfo['spellID'] = spellID
								end
							end
						end
					end,
					values = function()
						local key = IconInfo['Class']
						local list = { [''] = '|cffff5675'..NONE, }
						
						if key and TalentSpellTable[key] then
							for spellID, SlotNumber in pairs(TalentSpellTable[key]) do
								list[tostring(SlotNumber)] = GetSpellInfo(spellID)
							end
						end
						
						return list
					end,
				},
			},
		}
	end
end
]]