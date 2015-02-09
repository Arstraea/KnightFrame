local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (KF and KF.Modules and KF.Modules.SmartTracker and KF_Config) then return end
--------------------------------------------------------------------------------
--<< KnightFrame : Smart Tracker OptionTable								>>--
--------------------------------------------------------------------------------
local ST = SmartTracker

local TrackerInfo = {}
local SelectedWindow = L['SmartTracker_MainWindow']
local SelectedIcon = 'RaidIcon'


local function Color(TrueColor, FalseColor)
	return KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable ~= false and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
end


local function WindowColor(TrueColor, FalseColor)
	return KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable ~= false and KF.db.Modules.SmartTracker.Window[SelectedWindow] and KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
end


local function IconColor(TrueColor, FalseColor)
	return KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable ~= false and KF.db.Modules.SmartTracker.Icon[SelectedIcon] and KF.db.Modules.SmartTracker.Icon[SelectedIcon].Enable and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
end


KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.SmartTracker = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Smart Tracker']) end,
	order = 100 + OptionIndex,
	disabled = function() return KF.db.Enable == false end,
	childGroups = 'tab',
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(KF.db.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Smart Tracker'] end,
			order = 1,
			desc = '',
			descStyle = 'inline',
			get = function() return KF.db.Modules.SmartTracker.Enable end,
			set = function(_, value)
				KF.db.Modules.SmartTracker.Enable = value
				
				KF.Modules.SmartTracker()
			end,
			width = 'full',
		},
		General = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['General'] end,
			order = 100,
			get = function(info) return KF.db.Modules.SmartTracker[(info[#info - 1])][(info[#info])] end,
			set = function(info, value)
				KF.db.Modules.SmartTracker[(info[#info - 1])][(info[#info])] = value
			end,
			args = {
				Space = {
					type = 'description',
					name = ' ',
					order = 1
				},
				General = {
					type = 'group',
					name = function() return Color('ffffffff', 'ff787878')..L['General Setting'] end,
					order = 2,
					guiInline = true,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
					args = {
						DetailSpellTooltip = {
							type = 'toggle',
							name = function() return ' '..Color()..L['Detail SpellTooltip'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
						},
						EraseWhenUserLeftGroup = {
							type = 'toggle',
							name = function() return ' '..Color()..L['Erase leaved user'] end,
							order = 2,
							desc = L["Erase specific user's all cooltime bar who left group."],
						}
					}
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 3
				},
				Scan = {
					type = 'group',
					name = function() return Color('ffffffff', 'ff787878')..L['Inspect Parts'] end,
					order = 4,
					guiInline = true,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
					args = {
						AutoScanning = {
							type = 'toggle',
							name = function() return ' '..Color()..L['Auta Scanning'] end,
							order = 1,
							desc = L["SmartTracker will check new member of groups automatically."],
						},
						UpdateInspectCache = {
							type = 'toggle',
							name = function() return ' '..Color()..L['Update old data'] end,
							order = 2,
							desc = L["After new member's scanning, scan old member's setting for updating."],
						},
						ScanWhenReadyCheck = {
							type = 'toggle',
							name = function() return ' '..Color()..L['Update all when ready check.'] end,
							order = 3,
							desc = '',
							descStyle = 'inline',
						}
					}
				},
				CreditSpace = {
					type = 'description',
					name = ' ',
					order = 998
				},
				Credit = {
					type = 'header',
					name = KF_Config.Credit,
					order = 999
				}
			}
		},
		SortOrder = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['Sort Order'] end,
			order = 200,
			get = function(info) return KF.db.Modules.SmartTracker[(info[#info - 1])][(info[#info])] end,
			set = function(info, value)
				KF.db.Modules.SmartTracker[(info[#info - 1])][(info[#info])] = value
			end,
			args = {
				Space = {
					type = 'description',
					name = ' ',
					order = 1
				},
				Role = {
					type = 'group',
					name = function() return Color('ffffffff', 'ff787878')..L['By Role'] end,
					order = 2,
					guiInline = true,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
					args = {
						
					}
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 3
				},
				Class = {
					type = 'group',
					name = function() return Color('ffffffff', 'ff787878')..L['By Class'] end,
					order = 4,
					guiInline = true,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
					args = {
						
					}
				},
				CreditSpace = {
					type = 'description',
					name = ' ',
					order = 998
				},
				Credit = {
					type = 'header',
					name = KF_Config.Credit,
					order = 999
				}
			}
		},
		ClassColor = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['Class Color'] end,
			order = 300,
			get = function(info)
				return KF.db.Modules.SmartTracker[(info[#info - 2])][(info[#info - 1])][tonumber(info[#info])][1],
					   KF.db.Modules.SmartTracker[(info[#info - 2])][(info[#info - 1])][tonumber(info[#info])][2],
					   KF.db.Modules.SmartTracker[(info[#info - 2])][(info[#info - 1])][tonumber(info[#info])][3],
					   KF.db.Modules.SmartTracker[(info[#info - 2])][(info[#info - 1])][tonumber(info[#info])][4]
			end,
			set = function(info, r, g, b, a)
				KF.db.Modules.SmartTracker[(info[#info - 2])][(info[#info - 1])][tonumber(info[#info])] = { r, g, b, a }
				
				for i, Bar in ipairs(KF.UIParent.ST_Window[SelectedWindow].ContainedBar) do
					if Bar.Data then
						Bar.Data.SettingComplete = nil
					end
				end
			end,
			args = {
				CreditSpace = {
					type = 'description',
					name = ' ',
					order = 998
				},
				Credit = {
					type = 'header',
					name = KF_Config.Credit,
					order = 999
				}
			}
		},
		Window = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['Window Setting'] end,
			order = 400,
			childGroups = 'tab',
			args = {
				Space1 = {
					type = 'description',
					name = ' ',
					order = 1
				},
				SelectWindow = {
					type = 'select',
					name = function() return ' '..Color(nil, 'ff787878')..L['Select'] end,
					order = 2,
					get = function() return SelectedWindow end,
					set = function(_, value)
						SelectedWindow = value
						
						wipe(TrackerInfo)
						E:CopyTable(TrackerInfo, Info.SmartTracker_Default_Window)
						
						if value ~= '0' then
							E:CopyTable(TrackerInfo, KF.db.Modules.SmartTracker.Window[value])
							TrackerInfo.Name = value
						end
					end,
					values = function()
						local list = {} --, ['0'] = NameColor2()..L['Create new one'] }
						
						for WindowName, IsWindowData in pairs(KF.db.Modules.SmartTracker.Window) do
							if type(IsWindowData) == 'table' then
								list[WindowName] = (IsWindowData.Enable == false and '|cff712633' or '')..(WindowName)
							end
						end
						
						return list
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 3,
					width = 'half'
				},
				Enable = {
					type = 'toggle',
					name = function() return ' '..Color('ffffffff', 'ff787878')..L['Enable']..' : '..Color(nil, 'ff787878')..SelectedWindow end,
					order = 4,
					get = function() return KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable end,
					set = function(_, value)
						KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable = value
						
						ST:Window_Create(SelectedWindow)
					end,
					hidden = function() return SelectedWindow == '0' end,
				},
				Space3 = {
					type = 'description',
					name = ' ',
					order = 50,
				},
				--[[
				Description = {
					type = 'description',
					name = function() return Message or ' ' end,
					order = 5,
					width = 'double',
					hidden = function() return SelectedWindow == '0' and (TrackerInfo.Name == '' or not TrackerInfo.Name) end
				},
				Name_NewTracker = {
					type = 'input',
					name = function() return ' '..NameColor2()..L['Input New Name'] end,
					order = 6,
					desc = '',
					descStyle = 'inline',
					get = function() return '' end,
					set = function(_, value)
						if value ~= '' and value ~= nil then
							if KF.db.Modules.SmartTracker.Window[value] or value == L['SmartTracker_MainWindow'] then
								Message = L['Window that named same is already exists. Please enter a another name.']
							else
								
							end
						end
					end,
					hidden = function() return KF.db.Enable == false or KF.db.Modules.CustomPanel.Enable == false or SelectedPanel == '' or (PanelInfo.Name and PanelInfo.Name ~= '') end
				},
				]]
				Appearance = {
					type = 'group',
					name = function() return WindowColor('', 'ff787878')..L['Appearance'] end,
					order = 100,
					get = function(info) return KF.db.Modules.SmartTracker.Window[SelectedWindow][(info[#info - 2])][(info[#info])] end,
					args = {
						Space = {
							type = 'description',
							name = ' ',
							order = 1
						},
						Bar = {
							type = 'group',
							name = function() return WindowColor('ffffffff', 'ff787878')..L['Cooldown Bar'] end,
							order = 2,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Window[SelectedWindow] or KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable == false end,
							args = {
								Bar_Direction = {
									type = 'select',
									name = function() return ' '..WindowColor()..L['Bar Direction'] end,
									order = 1,
									desc = '',
									descStyle = 'inline',
									disabled = true,
									values = function()
										return { UP = L['Upper the tab'], DOWN = L['Below the tab'] }
									end
								},
								Bar_Height = {
									type = 'range',
									name = function() return ' '..WindowColor()..L['Bar Height'] end,
									order = 2,
									desc = '',
									descStyle = 'inline',
									set = function(info, value)
										KF.db.Modules.SmartTracker.Window[SelectedWindow][(info[#info - 2])][(info[#info])] = value
										
										ST:Window_Size(KF.UIParent.ST_Window[SelectedWindow])
									end,
									min = 8,
									max = 30,
									step = 1
								},
								Bar_FontSize = {
									type = 'range',
									name = function() return ' '..WindowColor()..L['Bar Fontsize'] end,
									order = 3,
									desc = '',
									descStyle = 'inline',
									set = function(info, value)
										KF.db.Modules.SmartTracker.Window[SelectedWindow][(info[#info - 2])][(info[#info])] = value
										
										ST:Bar_Rearrange(KF.UIParent.ST_Window[SelectedWindow])
									end,
									min = 6,
									max = 28,
									step = 1
								},
								Count_TargetUser = {
									type = 'range',
									name = function() return ' '..WindowColor()..L['Number of Target Display'] end,
									order = 4,
									set = function(info, value)
										KF.db.Modules.SmartTracker.Window[SelectedWindow][(info[#info - 2])][(info[#info])] = value
										
										for i, Bar in ipairs(KF.UIParent.ST_Window[SelectedWindow].ContainedBar) do
											if Bar.Data then
												Bar.Data.SettingComplete = nil
											end
										end
									end,
									min = 1,
									max = 6,
									step = 1
								},
							}
						},
						Space2 = {
							type = 'description',
							name = ' ',
							order = 3
						},
						Color = {
							type = 'group',
							name = function() return WindowColor('ffffffff', 'ff787878')..COLOR end,
							order = 4,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Window[SelectedWindow] or KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable == false end,
							get = function(info)
								return KF.db.Modules.SmartTracker.Window[SelectedWindow].Appearance[(info[#info])][1] or 1,
									   KF.db.Modules.SmartTracker.Window[SelectedWindow].Appearance[(info[#info])][2] or 1,
									   KF.db.Modules.SmartTracker.Window[SelectedWindow].Appearance[(info[#info])][3] or 1,
									   KF.db.Modules.SmartTracker.Window[SelectedWindow].Appearance[(info[#info])][4] or 1
							end,
							args = {
								Color_WindowTab = {
									type = 'color',
									name = function() return ' '..WindowColor()..L['Window Tab Color'] end,
									order = 1,
									set = function(info, r, g, b, a)
										KF.db.Modules.SmartTracker.Window[SelectedWindow].Appearance[(info[#info])] = { r, g, b, a }
										
										KF.UIParent.ST_Window[SelectedWindow].Tab:SetBackdropColor(r, g, b)
									end,
								},
								Color_BehindBar = {
									type = 'color',
									name = function() return ' '..WindowColor()..L['Bar Background Color'] end,
									order = 2,
									hasAlpha = true,
									set = function(info, r, g, b, a)
										KF.db.Modules.SmartTracker.Window[SelectedWindow].Appearance[(info[#info])] = { r, g, b, a }
										
										for i, Bar in ipairs(KF.UIParent.ST_Window[SelectedWindow].ContainedBar) do
											if Bar.Data then
												Bar.Data.SettingComplete = nil
											end
										end
									end,
								}
							}
						},
						CreditSpace = {
							type = 'description',
							name = ' ',
							order = 998
						},
						Credit = {
							type = 'header',
							name = KF_Config.Credit,
							order = 999
						}
					}
				},
				Display = {
					type = 'group',
					name = function() return WindowColor('', 'ff787878')..L['Display Condition'] end,
					order = 200,
					get = function(info) return KF.db.Modules.SmartTracker.Window[SelectedWindow][(info[#info - 2])][(info[#info - 1])][(info[#info])] end,
					set = function(info, value)
						KF.db.Modules.SmartTracker.Window[SelectedWindow][(info[#info - 2])][(info[#info - 1])][(info[#info])] = value
						
						ST:SetDisplay('Window', 'ST_Window', SelectedWindow, KF.UIParent.ST_Window[SelectedWindow])
					end,
					args = {
						Space = {
							type = 'description',
							name = ' ',
							order = 1
						},
						Situation = {
							type = 'group',
							name = function() return WindowColor('ffffffff', 'ff787878')..L['Group Situation'] end,
							order = 2,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Window[SelectedWindow] or KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable == false end,
							args = {
								Solo = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['Solo Playing'] end,
									order = 1,
									desc = '',
									descStyle = 'inline'
								},
								Group = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['Group Playing'] end,
									order = 2,
									desc = '',
									descStyle = 'inline'
								}
							}
						},
						Space2 = {
							type = 'description',
							name = ' ',
							order = 3
						},
						Location = {
							type = 'group',
							name = function() return WindowColor('ffffffff', 'ff787878')..L['Location Condition'] end,
							order = 4,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Window[SelectedWindow] or KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable == false end,
							args = {
								Field = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['In Field'] end,
									order = 1,
									desc = '',
									descStyle = 'inline'
								},
								Instance = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['In Instance'] end,
									order = 2,
									desc = '',
									descStyle = 'inline'
								},
								RaidDungeon = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['In RaidDungeon'] end,
									order = 3,
									desc = '',
									descStyle = 'inline'
								},
								PvPGround = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['In PvPGround'] end,
									order = 4,
									desc = '',
									descStyle = 'inline'
								},
							}
						},
						Space3 = {
							type = 'description',
							name = ' ',
							order = 5
						},
						AmICondition = {
							type = 'group',
							name = function() return WindowColor('ffffffff', 'ff787878')..L['Player Condition'] end,
							order = 6,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Window[SelectedWindow] or KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable == false end,
							args = {
								Tank = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L["When I'm Tank"] end,
									order = 1,
									desc = '',
									descStyle = 'inline'
								},
								Healer = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L["When I'm Healer"] end,
									order = 2,
									desc = '',
									descStyle = 'inline'
								},
								Caster = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L["When I'm Caster"] end,
									order = 3,
									desc = '',
									descStyle = 'inline'
								},
								Melee = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L["When I'm Melee"] end,
									order = 4,
									desc = '',
									descStyle = 'inline'
								},
								GroupLeader = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L["When I'm GroupLeader"] end,
									order = 4,
									desc = '',
									descStyle = 'inline'
								}
							}
						},
						Space4 = {
							type = 'description',
							name = ' ',
							order = 7
						},
						Filter = {
							type = 'group',
							name = function() return WindowColor('ffffffff', 'ff787878')..L['Filtering by Role'] end,
							order = 8,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Window[SelectedWindow] or KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable == false end,
							args = {
								Tank = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['Display Tank'] end,
									order = 1,
									desc = '',
									descStyle = 'inline'
								},
								Healer = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['Display Healer'] end,
									order = 2,
									desc = '',
									descStyle = 'inline'
								},
								Caster = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['Display Caster'] end,
									order = 3,
									desc = '',
									descStyle = 'inline'
								},
								Melee = {
									type = 'toggle',
									name = function() return ' '..WindowColor()..L['Display Melee'] end,
									order = 4,
									desc = '',
									descStyle = 'inline'
								}
							}
						},
						CreditSpace = {
							type = 'description',
							name = ' ',
							order = 998
						},
						Credit = {
							type = 'header',
							name = KF_Config.Credit,
							order = 999
						}
					}
				}
			}
		},
		Icon = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['Icon Setting'] end,
			order = 500,
			childGroups = 'tab',
			args = {
				Space1 = {
					type = 'description',
					name = ' ',
					order = 1
				},
				SelectIcon = {
					type = 'select',
					name = function() return ' '..Color(nil, 'ff787878')..L['Select'] end,
					order = 2,
					get = function() return SelectedIcon end,
					set = function(_, value)
						SelectedIcon = value
						
						wipe(TrackerInfo)
						E:CopyTable(TrackerInfo, Info.SmartTracker_Default_Icon)
						
						if value ~= '0' then
							E:CopyTable(TrackerInfo, KF.db.Modules.SmartTracker.Icon[value])
							TrackerInfo.Name = value
						end
					end,
					values = function()
						local list = {} --, ['0'] = NameColor2()..L['Create new one'] }
						
						for AnchorName, IsAnchorData in pairs(KF.db.Modules.SmartTracker.Icon) do
							if type(IsAnchorData) == 'table' then
								list[AnchorName] = (IsAnchorData.Enable == false and '|cff712633' or '')..(AnchorName)
							end
						end
						
						return list
					end
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 3,
					width = 'half'
				},
				Enable = {
					type = 'toggle',
					name = function() return ' '..Color('ffffffff', 'ff787878')..L['Enable']..' : '..Color(nil, 'ff787878')..SelectedIcon end,
					order = 4,
					get = function() return KF.db.Modules.SmartTracker.Icon[SelectedIcon].Enable end,
					set = function(_, value)
						KF.db.Modules.SmartTracker.Icon[SelectedIcon].Enable = value
						
						ST:IconAnchor_Create(SelectedIcon)
					end,
					hidden = function() return SelectedIcon == '0' end,
				},
				Space3 = {
					type = 'description',
					name = ' ',
					order = 50,
				},
				--[[
				Name_NewTracker = {
					type = 'input',
					name = function() return ' '..NameColor2()..L['Input New Name'] end,
					order = 5,
					desc = '',
					descStyle = 'inline',
					get = function() return '' end,
					set = function(_, value)
						if value ~= '' and value ~= nil then
							if KF.db.Modules.SmartTracker.Window[value] or value == L['SmartTracker_MainWindow'] then
								Message = L['Window that named same is already exists. Please enter a another name.']
							else
								
							end
						end
					end,
					hidden = function() return KF.db.Enable == false or KF.db.Modules.CustomPanel.Enable == false or SelectedPanel == '' or (PanelInfo.Name and PanelInfo.Name ~= '') end
				},
				]]
				Appearance = {
					type = 'group',
					name = function() return IconColor('', 'ff787878')..L['Appearance'] end,
					order = 100,
					get = function(info) return KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info])] end,
					set = function(info, value)
						KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info])] = value
					end,
					args = {
						Space = {
							type = 'description',
							name = ' ',
							order = 1
						},
						Icon = {
							type = 'group',
							name = function() return IconColor('ffffffff', 'ff787878')..L['Spell Icon'] end,
							order = 2,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Icon[SelectedIcon] or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Enable == false end,
							args = {
								Icon_Width = {
									type = 'range',
									name = function() return ' '..IconColor()..L['Icon Width'] end,
									order = 1,
									desc = '',
									descStyle = 'inline',
									set = function(info, value)
										KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info])] = value
										
										ST:IconAnchor_Size(KF.UIParent.ST_Icon[SelectedIcon])
										ST:Icon_Size(KF.UIParent.ST_Icon[SelectedIcon])
									end,
									min = 16,
									max = 128,
									step = 1
								},
								Icon_Height = {
									type = 'range',
									name = function() return ' '..IconColor()..L['Icon Height'] end,
									order = 2,
									desc = '',
									descStyle = 'inline',
									set = function(info, value)
										KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info])] = value
										
										ST:IconAnchor_Size(KF.UIParent.ST_Icon[SelectedIcon])
										ST:Icon_Size(KF.UIParent.ST_Icon[SelectedIcon])
									end,
									min = 16,
									max = 128,
									step = 1
								},
								Spacing = {
									type = 'range',
									name = function() return ' '..IconColor()..L['Icon Spacing'] end,
									order = 3,
									desc = '',
									descStyle = 'inline',
									set = function(info, value)
										KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info])] = value
										
										ST:IconAnchor_Size(KF.UIParent.ST_Icon[SelectedIcon])
										ST:Icon_Rearrange(KF.UIParent.ST_Icon[SelectedIcon])
									end,
									min = 0,
									max = 50,
									step = 1
								},
								FontSize = {
									type = 'range',
									name = function() return ' '..IconColor()..L['Count FontSize'] end,
									order = 4,
									desc = '',
									descStyle = 'inline',
									set = function(info, value)
										KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info])] = value
										
										for i, Icon in ipairs(KF.UIParent.ST_Icon[SelectedIcon].ContainedIcon) do
											Icon.text:SetFont(Icon.text:GetFont(), value, 'OUTLINE')
										end
									end,
									min = 6,
									max = 28,
									step = 1
								},
							}
						},
						Space2 = {
							type = 'description',
							name = ' ',
							order = 3
						},
						Arrangement = {
							type = 'group',
							name = function() return IconColor('ffffffff', 'ff787878')..L['Icon Arrangement'] end,
							order = 4,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Icon[SelectedIcon] or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Enable == false end,
							args = {
								Orientation = {
									type = 'select',
									name = function() return ' '..IconColor()..L['Icon Orientation'] end,
									order = 1,
									desc = '',
									descStyle = 'inline',
									set = function(info, value)
										KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info])] = value
										
										if KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Orientation == 'Horizontal' and (KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Top To Bottom' or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Bottom To Top') or
											KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Orientation == 'Vertical' and (KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Left to Right' or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Right to Left') then
											
											KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement = 'Center'
										end
										
										ST:Icon_Rearrange(KF.UIParent.ST_Icon[SelectedIcon])
										ST:IconAnchor_Size(KF.UIParent.ST_Icon[SelectedIcon])
									end,
									values = {
										Horizontal = L['Horizontal'],
										Vertical = L['Vertical']
									},
								},
								Arrangement = {
									type = 'select',
									name = function() return ' '..IconColor()..L['Icon Align'] end,
									order = 2,
									desc = '',
									descStyle = 'inline',
									get = function()
										if KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Orientation == 'Horizontal' and (KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Top To Bottom' or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Bottom To Top') or
											KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Orientation == 'Vertical' and (KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Left to Right' or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Right to Left') then
											
											KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement = 'Center'
										end
										
										return KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement
									end,
									set = function(info, value)
										KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info])] = value
										
										if KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Orientation == 'Horizontal' and (KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Top To Bottom' or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Bottom To Top') or
											KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Orientation == 'Vertical' and (KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Left to Right' or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement == 'Right to Left') then
											
											KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Arrangement = 'Center'
										end
										
										ST:Icon_Rearrange(KF.UIParent.ST_Icon[SelectedIcon])
									end,
									values = function()
										local list = { Center = L['Center'] }
										
										if KF.db.Modules.SmartTracker.Icon[SelectedIcon].Appearance.Orientation == 'Horizontal' then
											list['Left to Right'] = L['Left to Right']
											list['Right to Left'] = L['Right to Left']
										else
											list['Top To Bottom'] = L['Top To Bottom']
											list['Bottom To Top'] = L['Bottom To Top']
										end
										
										return list
									end,
								}
							}
						},
						CreditSpace = {
							type = 'description',
							name = ' ',
							order = 998
						},
						Credit = {
							type = 'header',
							name = KF_Config.Credit,
							order = 999
						}
					}
				},
				Display = {
					type = 'group',
					name = function() return IconColor('', 'ff787878')..L['Display Condition'] end,
					order = 200,
					get = function(info) return KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info - 1])][(info[#info])] end,
					set = function(info, value)
						KF.db.Modules.SmartTracker.Icon[SelectedIcon][(info[#info - 2])][(info[#info - 1])][(info[#info])] = value
						
						ST:SetDisplay('Icon', 'ST_Icon', SelectedIcon, KF.UIParent.ST_Icon[SelectedIcon])
					end,
					args = {
						Space = {
							type = 'description',
							name = ' ',
							order = 1
						},
						Situation = {
							type = 'group',
							name = function() return IconColor('ffffffff', 'ff787878')..L['Group Situation'] end,
							order = 2,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Icon[SelectedIcon] or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Enable == false end,
							args = {
								Solo = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L['Solo Playing'] end,
									order = 1,
									desc = '',
									descStyle = 'inline'
								},
								Group = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L['Group Playing'] end,
									order = 2,
									desc = '',
									descStyle = 'inline'
								}
							}
						},
						Space2 = {
							type = 'description',
							name = ' ',
							order = 3
						},
						Location = {
							type = 'group',
							name = function() return IconColor('ffffffff', 'ff787878')..L['Location Condition'] end,
							order = 4,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Icon[SelectedIcon] or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Enable == false end,
							args = {
								Field = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L['In Field'] end,
									order = 1,
									desc = '',
									descStyle = 'inline'
								},
								Instance = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L['In Instance'] end,
									order = 2,
									desc = '',
									descStyle = 'inline'
								},
								RaidDungeon = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L['In RaidDungeon'] end,
									order = 3,
									desc = '',
									descStyle = 'inline'
								},
								PvPGround = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L['In PvPGround'] end,
									order = 4,
									desc = '',
									descStyle = 'inline'
								}
							}
						},
						Space3 = {
							type = 'description',
							name = ' ',
							order = 5
						},
						AmICondition = {
							type = 'group',
							name = function() return IconColor('ffffffff', 'ff787878')..L['Player Condition'] end,
							order = 6,
							guiInline = true,
							disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Icon[SelectedIcon] or KF.db.Modules.SmartTracker.Icon[SelectedIcon].Enable == false end,
							args = {
								Tank = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L["When I'm Tank"] end,
									order = 1,
									desc = '',
									descStyle = 'inline'
								},
								Healer = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L["When I'm Healer"] end,
									order = 2,
									desc = '',
									descStyle = 'inline'
								},
								Caster = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L["When I'm Caster"] end,
									order = 3,
									desc = '',
									descStyle = 'inline'
								},
								Melee = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L["When I'm Melee"] end,
									order = 4,
									desc = '',
									descStyle = 'inline'
								},
								GroupLeader = {
									type = 'toggle',
									name = function() return ' '..IconColor()..L["When I'm GroupLeader"] end,
									order = 4,
									desc = '',
									descStyle = 'inline'
								}
							}
						},
						CreditSpace = {
							type = 'description',
							name = ' ',
							order = 998
						},
						Credit = {
							type = 'header',
							name = KF_Config.Credit,
							order = 999
						}
					}
				}
			}
		}
	}
}

local SpellCount
local ClassTable = { 'Warrior', 'Hunter', 'Shaman', 'Monk', 'Rogue', 'DeathKnight', 'Mage', 'Druid', 'Paladin', 'Priest', 'Warlock' }

local SpellTooltipHelper = CreateFrame('Frame')
SpellTooltipHelper:Hide()
SpellTooltipHelper:SetScript('OnUpdate', function(self)
	if self.SpellID and GameTooltip:IsShown() then
		GameTooltip:SetHyperlink(GetSpellLink(self.SpellID))
		GameTooltip:Show()
	end
	
	self.SpellID = nil
	self:Hide()
end)

for i, Class in ipairs(ClassTable) do
	KF_Config.Options.args.SmartTracker.args.ClassColor.args['Space'..i] = {
		type = 'description',
		name = ' ',
		order = i * 2 - 1
	}
	
	KF_Config.Options.args.SmartTracker.args.ClassColor.args[strupper(Class)] = {
		type = 'group',
		name = function(info) return '|TInterface\\ICONS\\ClassIcon_'..Class..':16:16:0:0:64:64:7:58:7:58|t '..Color(RAID_CLASS_COLORS[strupper(Class)].colorStr, 'ff787878')..LOCALIZED_CLASS_NAMES_MALE[string.upper(Class)] end,
		order = i * 2,
		guiInline = true,
		desc = '',
		descStyle = 'inline',
		disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false end,
		args = {
			['1'] = {
				type = 'color',
				name = function() return Color(nil, 'ff787878')..format(L['Charged Bar Color %d'], 1) end,
				order = 1,
			},
			['2'] = {
				type = 'color',
				name = function() return Color(nil, 'ff787878')..format(L['Charged Bar Color %d'], 2) end,
				order = 2,
			}
		}
	}
	
	KF_Config.Options.args.SmartTracker.args.Window.args[Class] = {
		type = 'group',
		name = function(info) return '|TInterface\\ICONS\\ClassIcon_'..info[#info]..':16:16:0:0:64:64:7:58:7:58|t '..WindowColor(RAID_CLASS_COLORS[strupper(Class)].colorStr, 'ff787878')..LOCALIZED_CLASS_NAMES_MALE[string.upper(Class)] end,
		order = 299 + i,
		desc = '',
		descStyle = 'inline',
		args = {
			Space = {
				type = 'description',
				name = ' ',
				order = 1
			}
		}
	}
	
	SpellCount = 2
	for SpellID in pairs(Info.SmartTracker_Data[strupper(Class)]) do
		if not Info.SmartTracker_Data[strupper(Class)][SpellID].Hidden then
			KF_Config.Options.args.SmartTracker.args.Window.args[Class].args[tostring(SpellID)] = {
				type = 'toggle',
				name = function() return ' |T'..GetSpellTexture(SpellID)..':20:20:0:0:64:64:7:57:7:57|t '..WindowColor('ff2eb7e4')..GetSpellInfo(SpellID)..(Info.SmartTracker_Data[strupper(Class)][SpellID].Desc or '') end,
				order = SpellCount,
				desc = function()
					SpellTooltipHelper.SpellID = SpellID
					SpellTooltipHelper:Show()
				end,
				get = function() return KF.db.Modules.SmartTracker.Window[SelectedWindow].SpellList[strupper(Class)][SpellID] == true end,
				set = function(_, value)
					KF.db.Modules.SmartTracker.Window[SelectedWindow].SpellList[strupper(Class)][SpellID] = value
					
					ST:BuildTrackingSpellList(SelectedWindow)
					ST:RedistributeCooldownData(KF.UIParent.ST_Window[SelectedWindow])
				end,
				disabled = function() return KF.db.Enable == false or KF.db.Modules.SmartTracker.Enable == false or not KF.db.Modules.SmartTracker.Window[SelectedWindow] or KF.db.Modules.SmartTracker.Window[SelectedWindow].Enable == false end,
			}
			SpellCount = SpellCount + 1
		end
	end
end