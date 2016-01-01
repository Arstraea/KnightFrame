local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

if ElvDB and ElvDB.profiles then
	for ProfileKey in pairs(ElvDB.profiles) do
		if ElvDB.profiles[ProfileKey].KnightFrame and ElvDB.profiles[ProfileKey].KnightFrame.UseProfile then
			-- Profile parts
			KF:CompareTable({
				general = {
					loginmessage = false,
					afk = false,
					autoRepair = 'GUILD',
					vendorGrays = true,
					valuecolor = { r = 46/255, g = 183/255, b = 227/255 },
					
					minimap = {
						size = 157,
						locationText = 'SHOW'
					},
					
					experience = {
						orientation = 'HORIZONTAL'
					},
					
					reputation = {
						orientation = 'HORIZONTAL'
					},
					
					threat = {
						enable = false
					},
					
					totems = {
						growthDirection = 'HORIZONTAL'
					}
				},
				bags = {
					bagBar = {
						growthDirection = 'HORIZONTAL',
						size = 24,
						spacing = 1,
						mouseover = true
					}
				},
				nameplate = {
					fontOutline = 'OUTLINE',
					nonTargetAlpha = 0.35,
					healthBar = {
						width = 120,
						height = 4,
						text = {
							enable = true,
							format = 'PERCENT'
						},
					},
					castBar = {
						height = 7,
						color = { r = 1, g = 1, b = 1 }
					},
					raidHealIcon = {
						xOffset = 0,
						yOffset = 12,
						attachTo = 'TOP'
					},
					buffs = {
						fontSize = 8,
						fontOutline = 'OUTLINE',
						numAuras = 5
					},
					debuffs = {
						fontSize = 8,
						fontOutline = 'OUTLINE',
						numAuras = 5
					}
				},
				auras = {
					fontSize = 12,
					fontOutline = 'OUTLINE',
					countYOffset = 17,
					timeYOffset = 6
				},
				chat = {
					scrollDownInterval = 0,
					emotionIcons = false,
					chatHistory = false,
					keywords = '%MYNAME%, ElvUI, KnightFrame, KF',
					separateSizes = false,
					panelWidth = 424,
					panelTabBackdrop = true,
					panelTabTransparency = true,
					fadeUndockedTabs = false
				},
				datatexts = {
					fontOutline = 'OUTLINE',
					panels = {
						LeftChatDataPanel = {
							left = 'Call to Arms',
							middle = 'Time',
							right = 'System'
						},
						RightChatDataPanel = {
							left = 'Bags',
							middle = 'Durability',
							right = 'Gold'
						},
					}
				},
				tooltip = {
					cursorAnchor = true,
					inspectInfo = false,
					itemCount = 'BOTH',
					visibility = {
						unitFrames = 'SHIFT'
					},
				},
				unitframe = {
					smoothbars = true,
					fontOutline = 'OUTLINE',
					OORAlpha = .4,
					smartRaidFilter = false,
					colors = {
						colorhealthbyvalue = false,
						customhealthbackdrop = true,
						auraBarByType = false,
						transparentHealth = true,
						transparentPower = true,
						castColor = { r = 1, g = 1, b = 1 },
						health = { r = 1, g = 1, b = 1 },
						health_backdrop = { r = 0.07, g = 0.07, b = 0.07 },
						tapped = { r = 0, g = 0, b = 0 },
						disconnected = { r = 0.49, g = 0.51, b = 0.07 },
						auraBarBuff = { r = 1, g = 1, b = 1 }
					},
					units = {
						player = {
							width = 260,
							height = 45,
							lowmana = 0,
							health = {
								text_format = '[healthcolor][health:current-percent]',
								position = 'BOTTOMRIGHT',
								yOffset = -6
							},
							power = {
								height = 8,
								position = 'BOTTOMLEFT',
								xOffset = 2,
								yOffset = -6
							},
							name = {
								text_format = '[difficultycolor][level] [namecolor][name]'
							},
							portrait = {
								enable = true,
								overlay = true
							},
							debuffs = {
								perrow = 14
							},
							castbar = {
								width = 260,
								height = 20,
								format = 'CURRENTMAX'
							}
						},
						target = {
							width = 260,
							height = 45,
							health = {
								text_format = '[healthcolor][health:current-percent]',
								position = 'BOTTOMRIGHT',
								yOffset = -6
							},
							power = {
								height = 8,
								position = 'BOTTOMLEFT',
								hideonnpc = false,
								xOffset = 2,
								yOffset = -6
							},
							name = {
								text_format = '[namecolor][name:medium] [difficultycolor][level] [shortclassification]'
							},
							portrait = {
								enable = true,
								overlay = true
							},
							buffs = {
								perrow = 14
							},
							debuffs = {
								perrow = 14,
								playerOnly = {
									enemy = false
								}
							},
							castbar = {
								width = 260,
								height = 20,
								format = 'CURRENTMAX'
							}
						},
						targettarget = {
							width = 140,
							height = 31,
							health = {
								text_format = '[healthcolor][health:percent]',
								xOffset = 1
							},
							power = {
								height = 5
							},
							name = {
								position = 'LEFT',
								xOffset = 5
							},
							debuffs = {
								anchorPoint = 'TOPLEFT',
								yOffset = 2
							}
						},
						focus = {
							width = 140,
							height = 31,
							health = {
								text_format = '[healthcolor][health:percent]',
								xOffset = 1
							},
							power = {
								height = 5
							},
							name = {
								position = 'LEFT',
								xOffset = 5
							},
							debuffs = {
								yOffset = 2
							},
							castbar = {
								width = 400,
								height = 24,
								format = 'CURRENTMAX'
							}
						},
						focustarget = {
							enable = true,
							width = 140,
							height = 31,
							health = {
								text_format = '[healthcolor][health:percent]',
								xOffset = 1
							},
							power = {
								enable = true,
								height = 5
							},
							name = {
								position = 'LEFT',
								xOffset = 5
							}
						},
						pet = {
							height = 31,
							power = {
								height = 4
							},
							buffs = {
								enable = true,
								sizeOverride = 0
							},
							debuffs = {
								enable = true,
								yOffset = 1,
								anchorPoint = 'TOPLEFT'
							}
						},
						boss = {
							width = 260,
							height = 45,
							health = {
								text_format = '[healthcolor][health:current-percent]',
								position = 'BOTTOMRIGHT',
								yOffset = -6
							},
							power = {
								height = 8,
								text_format = '[powercolor][power:percent]',
								position = 'BOTTOMLEFT',
								xOffset = 2,
								yOffset = -6
							},
							portrait = {
								enable = true,
								overlay = true
							},
							name = {
								position = 'CENTER'
							},
							buffs = {
								fontSize = 16,
								sizeOverride = 30,
								xOffset = -4,
								yOffset = 1
							},
							debuffs = {
								numrows = 1,
								perrow = 14,
								anchorPoint = 'TOPRIGHT',
								playerOnly = false,
								yOffset = 2,
								sizeOverride = 0
							},
							castbar = {
								width = 260,
								format = 'CURRENTMAX'
							}
						},
						arena = {
							width = 260,
							height = 45,
							health = {
								text_format = '[healthcolor][health:current-percent]',
								position = 'BOTTOMRIGHT',
								yOffset = -6
							},
							power = {
								height = 8,
								position = 'BOTTOMLEFT',
								xOffset = 2,
								yOffset = -6
							},
							name = {
								position = 'CENTER'
							},
							buffs = {
								fontSize = 16,
								sizeOverride = 30,
								yOffset = 0
							},
							debuffs = {
								perrow = 11,
								anchorPoint = 'TOPLEFT',
								xOffset = 8,
								sizeOverride = 0
							},
							castbar = {
								width = 260,
								format = 'CURRENTMAX'
							},
							pvpTrinket = {
								size = 38,
								xOffset = -42
							}
						},
						party = {
							verticalSpacing = 15,
							healPrediction = true,
							width = 230,
							height = 45,
							health = {
								text_format = '[healthcolor][health:current-percent]',
								position = 'BOTTOMRIGHT',
								yOffset = -6
							},
							power = {
								height = 8,
								position = 'BOTTOMLEFT',
								xOffset = 2,
								yOffset = -6
							},
							name = {
								position = 'CENTER'
							},
							buffs = {
								anchorPoint = 'RIGHT',
								yOffset = -15,
								sizeOverride = 23
							},
							debuffs = {
								perrow = 8,
								attachTo = 'BUFFS',
								anchorPoint = 'BOTTOMLEFT',
								xOffset = 3,
								yOffset = 20,
								sizeOverride = 18
							},
							roleIcon = {
								position = 'TOPRIGHT'
							},
							targetsGroup = {
								enable = true,
								height = 26,
								anchorPoint = 'TOPRIGHT',
								xOffset = 103,
								yOffset = -26
							},
						},
						raid = {
							growthDirection = 'RIGHT_UP',
							horizontalSpacing = 5,
							verticalSpacing = 5,
							numGroups = 5,
							healPrediction = true,
							height = 56,
							health = {
								text_format = '[healthcolor][health:current]',
								yOffset = -5
							},
							power = {
								height = 6
							},
							buffs = {
								enable = true,
								anchorPoint = 'CENTER',
								clickThrough = true,
								useBlacklist = false,
								noDuration = false,
								playerOnly = false,
								perrow = 1,
								useFilter = L['Raid Utility Filter'],
								noConsolidated = false,
								sizeOverride = 24
							},
							buffIndicator = {
								size = 10,
								fontSize = 15
							},
							rdebuffs = {
								fontSize = 12,
								size = 35
							},
							roleIcon = {
								position = 'CENTER'
							},
						},
						raid40 = {
							growthDirection = 'RIGHT_UP',
							horizontalSpacing = 5,
							verticalSpacing = 5,
							healPrediction = true,
							height = 34,
							health = {
								text_format = '[healthcolor][health:percent]',
								yOffset = 2
							},
							power = {
								enable = true,
								height = 5
							},
							name = {
								position = 'TOP',
								yOffset = 1
							},
							rdebuffs = {
								enable = true,
								size = 24
							},
							roleIcon = {
								enable = true,
								position = 'TOPRIGHT'
							},
							buffIndicator = {
								size = 10,
								fontSize = 15
							}
						},
						bodyguard = {
							enable = false,
						},
						tank = {
							enable = false,
							targetsGroup = {
								enable = false
							}
						},
						assist = {
							enable = false,
							targetsGroup = {
								enable = false
							}
						}
					}
				},
				actionbar = {
					fontOutline = 'OUTLINE',
					macrotext = true,
					bar1 = {
						point = 'TOPLEFT',
						backdrop = true,
						heightMult = 2,
						buttonsize = 27,
						buttonspacing = 4
					},
					bar2 = {
						enabled = true,
						buttonsPerRow = 6,
						point = 'TOPLEFT',
						backdrop = true,
						buttonsize = 27,
						buttonspacing = 4
					},
					bar3 = {
						buttons = 12,
						buttonsPerRow = 12,
						buttonsize = 27,
						buttonspacing = 4
					},
					bar4 = {
						point = 'TOPLEFT',
						buttonsize = 27,
						buttonspacing = 4
					},
					bar5 = {
						point = 'TOPLEFT',
						backdrop = true,
						buttons = 12,
						buttonsize = 27,
						buttonspacing = 4
					},
					barPet = {
						buttonsPerRow = 10,
						point = 'TOPLEFT',
						buttonsize = 16,
						buttonspacing = 2
					},
					stanceBar = {
						backdrop = true,
						buttonsize = 16,
						buttonspacing = 2
					}
				},
				KnightFrame = {
					Modules = {
						SmartTracker = {
							Icon = {
								RaidIcon = {
									ShowBattleResurrectionIcon = true,
									Appearance = {
										Location = 'TOPLEFT,ElvUIParent,TOPLEFT,11,-186',
										
										Icon_Height = 30,
										Arrangement = 'Left to Right'	-- Left to Right, Right to Left, Center, Top To Bottom, Bottom To Top
									},
									Display = {
										Location = {
											Field = true
										}
									},
									SpellList = {
										{ [31821] = 'PALADIN' },
										{ [62618] = 'PRIEST' },
										{ [64843] = 'PRIEST' },
										{ [98008] = 'SHAMAN' },
										{ [108280] = 'SHAMAN' },
										{ [152256] = 'SHAMAN' },
										{ [115310] = 'MONK' },
										{ [740] = 'DRUID' },
										{ [97462] = 'WARRIOR' },
										{ [76577] = 'ROGUE' },
										{ [15286] = 'PRIEST' }
									},
								},
								SupportIcon = {
									ShowBattleResurrectionIcon = false,
									Appearance = {
										Location = 'BOTTOM,ElvUIParent,BOTTOM,0,432',
										
										Icon_Height = 30
									},
									SpellList = {
										{ [6940] = 'PALADIN' },
										{ [33206] = 'PRIEST' },
										{ [47788] = 'PRIEST' },
										{ [116849] = 'MONK' },
										{ [102342] = 'DRUID' },
										{ [114030] = 'WARRIOR' }
									},
								}
							}
						}
					}
				}
			}, ElvDB.profiles[ProfileKey], ElvDB.profiles[ProfileKey])
			
			ElvDB.profiles[ProfileKey].KnightFrame.UseProfile = nil
		end
	end
end

function KF:DBConversions(Data)
	if Data.KnightFrame then
		if Data.KnightFrame.Layout then
			Data.KnightFrame.Modules = Data.KnightFrame.Modules or {}
			E:CopyTable(Data.KnightFrame.Modules, Data.KnightFrame.Layout)
			Data.KnightFrame.Layout = nil
		end
		
		if Data.KnightFrame.Extra_Functions then
			Data.KnightFrame.Modules = Data.KnightFrame.Modules or {}
			E:CopyTable(Data.KnightFrame.Modules, Data.KnightFrame.Extra_Functions)
			Data.KnightFrame.Extra_Functions = nil
		end
		
		if Data.KnightFrame.Modules then
			if Data.KnightFrame.Modules.AuraTracker ~= nil then
				Data.KnightFrame.Modules.SynergyTracker = Data.KnightFrame.Modules.AuraTracker
				Data.KnightFrame.Modules.AuraTracker = nil
			end
			
			if Data.KnightFrame.Modules.RaidCooldown ~= nil then
				Data.KnightFrame.Modules.SmartTracker = Data.KnightFrame.Modules.RaidCooldown
				Data.KnightFrame.Modules.RaidCooldown = nil
			end
			
			if Data.KnightFrame.Modules.FloatingDatatext then
				local NeedErase
				for DatatextName in pairs(Data.KnightFrame.Modules.FloatingDatatext) do
					if type(Data.KnightFrame.Modules.FloatingDatatext[DatatextName]) == 'table' and Data.KnightFrame.Modules.FloatingDatatext[DatatextName].Display then
						NeedErase = 0
						
						for Mode, datatextType in pairs(Data.KnightFrame.Modules.FloatingDatatext[DatatextName].Display) do
							if datatextType == 'DPS Utility |cff2eb7e4(KF)' then
								NeedErase = NeedErase + 1
								
								Data.KnightFrame.Modules.FloatingDatatext[DatatextName].Display[Mode] = ''
							elseif datatextType ~= '0' and datatextType ~= '' then
								NeedErase = NeedErase - 1
							end
						end
						
						if NeedErase > 0 then
							Data.KnightFrame.Modules.FloatingDatatext[DatatextName] = nil
						end
					end
				end
			end
		end
		
		if Data.Install_Complete == '3.1_14' then
			Data.Install_Complete = '3.1_15'
		end
		
		if Data.Install_Complete == '3.1_15' then
			if Data.KnightFrame.Modules then
				if Data.KnightFrame.Modules.Armory and Data.KnightFrame.Modules.Armory.Inspect then
					Data.KnightFrame.Modules.Armory.Inspect.Enable = false
				end
				
				if Data.KnightFrame.Modules.SmartTracker and Data.KnightFrame.Modules.SmartTracker.Icon and Data.KnightFrame.Modules.SmartTracker.Icon then
					for GroupName in pairs(Data.KnightFrame.Modules.SmartTracker.Icon) do
						if Data.KnightFrame.Modules.SmartTracker.Icon[GroupName].SpellList then
							for i, Group in pairs(Data.KnightFrame.Modules.SmartTracker.Icon[GroupName].SpellList) do
								if Group[172106] then
									Data.KnightFrame.Modules.SmartTracker.Icon[GroupName].SpellList[i][172106] = nil
								elseif Group[159916] then
									Data.KnightFrame.Modules.SmartTracker.Icon[GroupName].SpellList[i][159916] = nil
								end
							end
						end
					end
				end
			end
			
			Data.Install_Complete = '3.1_16'
		end
	end
end 