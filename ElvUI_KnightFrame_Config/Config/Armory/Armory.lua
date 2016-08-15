--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (KF and KF.Modules and (KF.Modules.CharacterArmory or KF.Modules.InspectArmory) and KF_Config) then return end

local function Color(TrueColor, FalseColor)
	return KF.db.Enable ~= false and (KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable ~= false or KF.db.Modules.Armory.Inspect and KF.db.Modules.Armory.Inspect.Enable ~= false) and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
end

local EnchantString_Old, EnchantString_New = '', ''
local SelectedEnchantString

KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.Armory = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Armory']) end,
	order = 100 + OptionIndex,
	childGroups = 'tab',
	args = {
		EnchantString = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['Enchant String'] end,
			order = 300,
			args = {
				Space = {
					type = 'description',
					name = ' ',
					order = 1
				},
				ConfigSpace = {
					type = 'group',
					name = function() return Color('ffffffff', 'ff787878')..L['Add New Replacing Order'] end,
					order = 2,
					guiInline = true,
					args = {
						TargetString = {
							type = 'input',
							name = function() return ' '..Color()..L['Target Enchant'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
							get = function() return EnchantString_Old end,
							set = function(_, value)
								EnchantString_Old = value
							end,
							disabled = function() return KF.db.Enable == false or (not(KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable == true) and not(KF.db.Modules.Armory.Inspect and KF.db.Modules.Armory.Inspect.Enable == true)) end,
						},
						NewString = {
							type = 'input',
							name = function() return ' '..Color()..L['String To Replacing'] end,
							order = 2,
							desc = '',
							descStyle = 'inline',
							get = function() return EnchantString_New end,
							set = function(_, value)
								EnchantString_New = value
							end,
							disabled = function() return KF.db.Enable == false or (not(KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable == true) and not(KF.db.Modules.Armory.Inspect and KF.db.Modules.Armory.Inspect.Enable == true)) end,
						},
						Space = {
							type = 'description',
							name = ' ',
							order = 3,
							width = 'half'
						},
						List = {
							type = 'select',
							name = function() return ' '..Color()..L['Delete Replacing Order'] end,
							order = 4,
							get = function() return SelectedEnchantString end,
							set = function(_, value)
								SelectedEnchantString = value
							end,
							values = function()
								local List = {}
								
								for Old, New in pairs(KnightFrameDB.ArmoryDB.EnchantString) do
									if not SelectedEnchantString then
										SelectedEnchantString = Old
									end
									
									List[Old] = Old
								end
								
								if not next(List) then
									List[''] = NONE
									
									SelectedEnchantString = ''
								end
								
								return List
							end,
							disabled = function() return KF.db.Enable == false or (not(KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable == true) and not(KF.db.Modules.Armory.Inspect and KF.db.Modules.Armory.Inspect.Enable == true)) end,
						},
						Space2 = {
							type = 'description',
							name = ' ',
							order = 5,
							width = 'half'
						},
						AddButton = {
							type = 'execute',
							name = function() return ((KF.db.Enable == false or (not(KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable == true) and not(KF.db.Modules.Armory.Inspect and KF.db.Modules.Armory.Inspect.Enable == true)) or EnchantString_Old == '' or EnchantString_New == '') and '|cff787878' or KF:Color_Value())..L['Add New Order'] end,
							order = 6,
							desc = '',
							descStyle = 'inline',
							func = function()
								if EnchantString_Old ~= '' and EnchantString_New ~= '' then
									KnightFrameDB.ArmoryDB.EnchantString[EnchantString_Old] = EnchantString_New
									
									EnchantString_Old = ''
									EnchantString_New = ''
									
									if CharacterArmory then
										CharacterArmory:Update_Gear()
									end
									
									if InspectArmory and InspectArmory.LastDataSetting then
										InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
									end
								elseif KnightFrameDB.ArmoryDB.EnchantString[EnchantString_Old] and EnchantString_New == '' then
									KnightFrameDB.ArmoryDB.EnchantString[EnchantString_Old] = nil
								end
							end,
							disabled = function()
								return KF.db.Enable == false or (not(KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable == true) and not(KF.db.Modules.Armory.Inspect and KF.db.Modules.Armory.Inspect.Enable == true)) or EnchantString_Old == '' or EnchantString_New == ''
							end
						},
						Space3 = {
							type = 'description',
							name = ' ',
							order = 7,
							width = 'normal'
						},
						DeleteButton = {
							type = 'execute',
							name = function() return Color(nil, 'ff787878')..L['Delete'] end,
							order = 8,
							desc = '',
							descStyle = 'inline',
							func = function()
								if KnightFrameDB.ArmoryDB.EnchantString[SelectedEnchantString] then
									KnightFrameDB.ArmoryDB.EnchantString[SelectedEnchantString] = nil
									SelectedEnchantString = ''
									
									if CharacterArmory then
										CharacterArmory:Update_Gear()
									end
									
									if InspectArmory and InspectArmory.LastDataSetting then
										InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
									end
								end
							end,
							disabled = function() return KF.db.Enable == false or (not(KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable == true) and not(KF.db.Modules.Armory.Inspect and KF.db.Modules.Armory.Inspect.Enable == true)) end,
							hidden = function()
								return SelectedEnchantString == ''
							end
						}
					}
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 3
				},
				List = {
					type = 'group',
					name = function() return Color('ffffffff', 'ff787878')..L['Replacing List'] end,
					order = 4,
					guiInline = true,
					args = {
						List = {
							type = 'description',
							name = function()
								local List = ''
								local Order = 1
								
								if KnightFrameDB.ArmoryDB.EnchantString and next(KnightFrameDB.ArmoryDB.EnchantString) then
									for Old, New in pairs(KnightFrameDB.ArmoryDB.EnchantString) do
										List = List..'    '..Color('ffffffff', 'ff787878')..Order..'. '..Color('ffFF7E7E', 'ff787878')..Old..'|r  '..Color('ffceff00', 'ff787878')..'->|r  '..Color(nil, 'ff787878')..New..'|r|n'
										Order = Order + 1
									end
								else
									List = '    '..Color('FFFF7E7E', 'ff787878')..L['There is no replacing order.']
								end
								
								return List
							end,
							order = 1,
							disabled = function() return KF.db.Enable == false or (not(KF.db.Modules.Armory.Character and KF.db.Modules.Armory.Character.Enable == true) and not(KF.db.Modules.Armory.Inspect and KF.db.Modules.Armory.Inspect.Enable == true)) end,
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


local BackdropKeyTable = {
	['0'] = 'HIDE',
	['1'] = 'CUSTOM',
	['2'] = 'Space'
}

local BackgroundList = {
	['0'] = HIDE,
	['1'] = L['Custom'],
	['2'] = L['Space BG']
}

local DisplayMethodList = {
	Always = L['Always Display'],
	MouseoverOnly = L['Mouseover'],
	Hide = HIDE
}

local FontStyleList = {
	NONE = NONE,
	OUTLINE = 'OUTLINE',
	
	MONOCHROMEOUTLINE = 'MONOCROMEOUTLINE',
	THICKOUTLINE = 'THICKOUTLINE'
}

if KF.Modules.CharacterArmory then
	local function CA_Color(TrueColor, FalseColor)
		return KF.db.Enable ~= false and KF.db.Modules.Armory.Character.Enable ~= false and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
	end
	
	KF_Config.Options.args.Armory.args.CAEnable = {
		type = 'toggle',
		name = function() return ' '..(KF.db.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Character Armory'] end,
		order = 1,
		desc = '',
		descStyle = 'inline',
		get = function() return KF.db.Modules.Armory.Character.Enable end,
		set = function(_, value)
			KF.db.Modules.Armory.Character.Enable = value
			
			KF.Modules.CharacterArmory()
		end
	}
	
	local SelectedCABG
	KF_Config.Options.args.Armory.args.Character = {
		type = 'group',
		name = function() return CA_Color('', 'ff787878')..L['Character Armory'] end,
		order = 400,
		args = {
			NoticeMissing = {
				type = 'toggle',
				name = function() return ' '..CA_Color()..L['Notice Missing Enchant or Gems'] end,
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function() return KF.db.Modules.Armory.Character.NoticeMissing end,
				set = function(_, value)
					KF.db.Modules.Armory.Character.NoticeMissing = value
					
					CharacterArmory:Update_Gear()
					CharacterArmory:Update_Display(true)
				end,
				disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end,
				width = 'full'
			},
			Space1 = {
				type = 'description',
				name = ' ',
				order = 2
			},
			Backdrop = {
				type = 'group',
				name = function() return CA_Color('ffffffff', 'ff787878')..L['Backdrop'] end,
				order = 3,
				guiInline = true,
				args = {
					SelectedBG = {
						type = 'select',
						name = function() return ' '..CA_Color()..L['Select Backdrop'] end,
						order = 1,
						get = function()
							for Index, Key in pairs(BackdropKeyTable) do
								if Key == KF.db.Modules.Armory.Character.Backdrop.SelectedBG then
									return Index
								end
							end
							
							return '1'
						end,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Backdrop.SelectedBG = BackdropKeyTable[value]
							
							CharacterArmory:Update_BG()
						end,
						values = function() return BackgroundList end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					CustomAddress = {
						type = 'input',
						name = function() return ' '..CA_Color()..L['Custom Backdrop Image Address'] end,
						order = 2,
						desc = '',
						descStyle = 'inline',
						get = function() return KF.db.Modules.Armory.Character.Backdrop.CustomAddress end,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Backdrop.CustomAddress = value
							
							CharacterArmory:Update_BG()
						end,
						width = 'double',
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end,
						hidden = function() return KF.db.Modules.Armory.Character.Backdrop.SelectedBG ~= 'CUSTOM' end
					},
				}
			},
			Space2 = {
				type = 'description',
				name = ' ',
				order = 4
			},
			Gradation = {
				type = 'group',
				name = function() return CA_Color('ffffffff', 'ff787878')..L['Gradation'] end,
				order = 5,
				guiInline = true,
				args = {
					Display = {
						type = 'toggle',
						name = function() return ' '..CA_Color()..L['Display Gradation'] end,
						order = 1,
						get = function() return KF.db.Modules.Armory.Character.Gradation.Display end,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Gradation.Display = value
							
							CharacterArmory:Update_Gear()
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					Color = {
						type = 'color',
						name = function() return ' '..(KF.db.Enable == true and KF.db.Modules.Armory.Character.Enable == true and KF.db.Modules.Armory.Character.Gradation.Display == true and KF:Color_Value() or '')..L['Default Color'] end,
						order = 2,
						get = function() 
							return KF.db.Modules.Armory.Character.Gradation.Color[1],
								   KF.db.Modules.Armory.Character.Gradation.Color[2],
								   KF.db.Modules.Armory.Character.Gradation.Color[3],
								   KF.db.Modules.Armory.Character.Gradation.Color[4]
						end,
						set = function(Info, r, g, b, a)
							KF.db.Modules.Armory.Character.Gradation.Color = { r, g, b, a }
							
							CharacterArmory:Update_Gear()
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false or KF.db.Modules.Armory.Character.Gradation.Display == false end
					},
				}
			},
			Space3 = {
				type = 'description',
				name = ' ',
				order = 6
			},
			Level = {
				type = 'group',
				name = function() return CA_Color('ffffffff', 'ff787878')..L['Item Level'] end,
				order = 7,
				guiInline = true,
				get = function(info) return KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value)
					KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
					
					for _, SlotName in pairs(Info.Armory_Constants.GearList) do
						if CharacterArmory[SlotName] and CharacterArmory[SlotName].ItemLevel then
							CharacterArmory[SlotName].ItemLevel:FontTemplate(
								E.LSM:Fetch('font', KF.db.Modules.Armory.Character.Level.Font)
								,
								KF.db.Modules.Armory.Character.Level.FontSize
								,
								KF.db.Modules.Armory.Character.Level.FontStyle
							)
						end
					end
				end,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..CA_Color()..L['Display Method'] end,
						order = 1,
						set = function(info, value)
							KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
							
							CharacterArmory:Update_Gear()
							CharacterArmory:Update_Display(true)
						end,
						values = DisplayMethodList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					ShowUpgradeLevel = {
						type = 'toggle',
						name = function() return ' '..CA_Color()..L['Show Upgrade Level'] end,
						order = 2,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Level.ShowUpgradeLevel = value
							
							CharacterArmory:Update_Gear()
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					Space = {
						type = 'description',
						name = ' ',
						order = 3
					},
					Font = {
						type = 'select', dialogControl = 'LSM30_Font',
						name = function() return ' '..CA_Color()..L['Font'] end,
						order = 4,
						values = function()
							return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					FontSize = {
						type = 'range',
						name = function() return ' '..CA_Color()..L['Font Size'] end,
						order = 5,
						desc = '',
						descStyle = 'inline',
						min = 6,
						max = 22,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					FontStyle = {
						type = 'select',
						name = function() return ' '..CA_Color()..L['Font Outline'] end,
						order = 6,
						desc = '',
						descStyle = 'inline',
						values = FontStyleList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					}
				}
			},
			Space4 = {
				type = 'description',
				name = ' ',
				order = 8
			},
			Enchant = {
				type = 'group',
				name = function() return CA_Color('ffffffff', 'ff787878')..L['Enchant String'] end,
				order = 9,
				guiInline = true,
				get = function(info) return KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value)
					KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
					
					for _, SlotName in pairs(Info.Armory_Constants.GearList) do
						if CharacterArmory[SlotName] and CharacterArmory[SlotName].ItemEnchant then
							CharacterArmory[SlotName].ItemEnchant:FontTemplate(
								E.LSM:Fetch('font', KF.db.Modules.Armory.Character.Enchant.Font)
								,
								KF.db.Modules.Armory.Character.Enchant.FontSize
								,
								KF.db.Modules.Armory.Character.Enchant.FontStyle
							)
						end
					end
				end,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..CA_Color()..L['Display Method'] end,
						order = 1,
						set = function(info, value)
							KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
							
							CharacterArmory:Update_Gear()
							CharacterArmory:Update_Display(true)
						end,
						values = DisplayMethodList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					WarningSize = {
						type = 'range',
						name = function() return ' '..CA_Color()..L['Warning Size'] end,
						order = 2,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Enchant.WarningSize = value
							
							for _, SlotName in pairs(Info.Armory_Constants.GearList) do
								if CharacterArmory[SlotName] and CharacterArmory[SlotName].EnchantWarning then
									CharacterArmory[SlotName].EnchantWarning:Size(value)
								end
							end
						end,
						min = 6,
						max = 50,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					WarningIconOnly = {
						type = 'toggle',
						name = function() return ' '..CA_Color()..L['Show Warning Only'] end,
						order = 3,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Enchant.WarningIconOnly = value
							
							CharacterArmory:Update_Gear()
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end,
					},
					Space = {
						type = 'description',
						name = ' ',
						order = 4
					},
					Font = {
						type = 'select', dialogControl = 'LSM30_Font',
						name = function() return ' '..CA_Color()..L['Font'] end,
						order = 5,
						values = function()
							return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					FontSize = {
						type = 'range',
						name = function() return ' '..CA_Color()..L['Font Size'] end,
						order = 6,
						desc = '',
						descStyle = 'inline',
						min = 6,
						max = 22,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					FontStyle = {
						type = 'select',
						name = function() return ' '..CA_Color()..L['Font Outline'] end,
						order = 7,
						desc = '',
						descStyle = 'inline',
						values = FontStyleList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					}
				}
			},
			Space5 = {
				type = 'description',
				name = ' ',
				order = 10
			},
			Durability = {
				type = 'group',
				name = function() return CA_Color('ffffffff', 'ff787878')..DURABILITY end,
				order = 11,
				guiInline = true,
				get = function(info) return KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] end,
				set = function(info, value)
					KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
					
					for _, SlotName in pairs(Info.Armory_Constants.GearList) do
						if CharacterArmory[SlotName] and CharacterArmory[SlotName].Durability then
							CharacterArmory[SlotName].Durability:FontTemplate(
								E.LSM:Fetch('font', KF.db.Modules.Armory.Character.Durability.Font)
								,
								KF.db.Modules.Armory.Character.Durability.FontSize
								,
								KF.db.Modules.Armory.Character.Durability.FontStyle
							)
						end
					end
				end,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..CA_Color()..L['Display Method'] end,
						order = 1,
						set = function(info, value)
							KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
							
							CharacterArmory:Update_Durability()
							CharacterArmory:Update_Display(true)
						end,
						values = {
							Always = L['Always Display'],
							DamagedOnly = L['Only Damaged'],
							MouseoverOnly = L['Mouseover'],
							Hide = HIDE
						},
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					Space = {
						type = 'description',
						name = ' ',
						order = 2
					},
					Font = {
						type = 'select', dialogControl = 'LSM30_Font',
						name = function() return ' '..CA_Color()..L['Font'] end,
						order = 3,
						values = function()
							return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					FontSize = {
						type = 'range',
						name = function() return ' '..CA_Color()..L['Font Size'] end,
						order = 4,
						desc = '',
						descStyle = 'inline',
						min = 6,
						max = 22,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					FontStyle = {
						type = 'select',
						name = function() return ' '..CA_Color()..L['Font Outline'] end,
						order = 5,
						desc = '',
						descStyle = 'inline',
						values = FontStyleList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					}
				}
			},
			Space6 = {
				type = 'description',
				name = ' ',
				order = 12
			},
			Gem = {
				type = 'group',
				name = function() return CA_Color('ffffffff', 'ff787878')..L['Gem Socket'] end,
				order = 13,
				guiInline = true,
				get = function(Info) return KF.db.Modules.Armory.Character[(Info[#Info - 1])][(Info[#Info])] end,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..CA_Color()..L['Display Method'] end,
						order = 1,
						set = function(Info, value)
							KF.db.Modules.Armory.Character[(Info[#Info - 1])][(Info[#Info])] = value
							
							CharacterArmory:Update_Gear()
							CharacterArmory:Update_Display(true)
						end,
						values = DisplayMethodList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					SocketSize = {
						type = 'range',
						name = function() return ' '..CA_Color()..L['Socket Size'] end,
						order = 2,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Gem.SocketSize = value
							
							for _, SlotName in pairs(Info.Armory_Constants.GearList) do
								for i = 1, MAX_NUM_SOCKETS do
									if CharacterArmory[SlotName] and CharacterArmory[SlotName]['Socket'..i] then
										CharacterArmory[SlotName]['Socket'..i]:Size(value)
									else
										break
									end
								end
							end
						end,
						min = 6,
						max = 50,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
					WarningSize = {
						type = 'range',
						name = function() return ' '..CA_Color()..L['Warning Size'] end,
						order = 3,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Gem.WarningSize = value
							
							for _, SlotName in pairs(Info.Armory_Constants.GearList) do
								if CharacterArmory[SlotName] and CharacterArmory[SlotName].SocketWarning then
									CharacterArmory[SlotName].SocketWarning:Size(value)
								end
							end
						end,
						min = 6,
						max = 50,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
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
end


if KF.Modules.InspectArmory then
	local function IA_Color(TrueColor, FalseColor)
		return KF.db.Enable ~= false and KF.db.Modules.Armory.Inspect.Enable ~= false and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
	end
	
	KF_Config.Options.args.Armory.args.IAEnable = {
		type = 'toggle',
		name = function() return ' '..(KF.db.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Inspect Armory'] end,
		order = 2,
		desc = '',
		descStyle = 'inline',
		get = function() return KF.db.Modules.Armory.Inspect.Enable end,
		set = function(_, value)
			KF.db.Modules.Armory.Inspect.Enable = value
			
			KF.Modules.InspectArmory()
		end
	}
	
	KF_Config.Options.args.Armory.args.Inspect = {
		type = 'group',
		name = function() return Color('', 'ff787878')..L['Inspect Armory'] end,
		order = 500,
		args = {
			NoticeMissing = {
				type = 'toggle',
				name = function() return ' '..IA_Color()..L['Notice Missing Enchant or Gems'] end,
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function() return KF.db.Modules.Armory.Inspect.NoticeMissing end,
				set = function(_, value)
					KF.db.Modules.Armory.Inspect.NoticeMissing = value
					
					if InspectArmory.LastDataSetting then
						InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
					end
					InspectArmory:Update_Display(true)
				end,
				disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end,
				width = 'full'
			},
			Space1 = {
				type = 'description',
				name = ' ',
				order = 2
			},
			Backdrop = {
				type = 'group',
				name = function() return IA_Color('ffffffff', 'ff787878')..L['Backdrop'] end,
				order = 3,
				guiInline = true,
				args = {
					SelectedBG = {
						type = 'select',
						name = function() return ' '..IA_Color()..L['Select Backdrop'] end,
						order = 1,
						get = function()
							for Index, Key in pairs(BackdropKeyTable) do
								if Key == KF.db.Modules.Armory.Inspect.Backdrop.SelectedBG then
									return Index
								end
							end
							
							return '1'
						end,
						set = function(_, value)
							KF.db.Modules.Armory.Inspect.Backdrop.SelectedBG = BackdropKeyTable[value]
							
							InspectArmory:Update_BG()
						end,
						values = function() return BackgroundList end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					CustomAddress = {
						type = 'input',
						name = function() return ' '..IA_Color()..L['Custom Backdrop Image Address'] end,
						order = 2,
						desc = '',
						descStyle = 'inline',
						get = function() return KF.db.Modules.Armory.Inspect.Backdrop.CustomAddress end,
						set = function(_, value)
							KF.db.Modules.Armory.Inspect.Backdrop.CustomAddress = value
							
							InspectArmory:Update_BG()
						end,
						width = 'double',
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end,
						hidden = function() return KF.db.Modules.Armory.Inspect.Backdrop.SelectedBG ~= 'CUSTOM' end
					},
				}
			},
			Space2 = {
				type = 'description',
				name = ' ',
				order = 4
			},
			Gradation = {
				type = 'group',
				name = function() return IA_Color('ffffffff', 'ff787878')..L['Gradation'] end,
				order = 5,
				guiInline = true,
				args = {
					Display = {
						type = 'toggle',
						name = function() return ' '..IA_Color()..L['Display Gradation'] end,
						order = 1,
						get = function() return KF.db.Modules.Armory.Inspect.Gradation.Display end,
						set = function(_, value)
							KF.db.Modules.Armory.Inspect.Gradation.Display = value
							
							if InspectArmory and InspectArmory.LastDataSetting then
								InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
							end
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					Color = {
						type = 'color',
						name = function() return ' '..(KF.db.Enable == true and KF.db.Modules.Armory.Inspect.Enable == true and KF.db.Modules.Armory.Inspect.Gradation.Display == true and KF:Color_Value() or '')..L['Default Color'] end,
						order = 2,
						get = function() 
							return KF.db.Modules.Armory.Inspect.Gradation.Color[1],
								   KF.db.Modules.Armory.Inspect.Gradation.Color[2],
								   KF.db.Modules.Armory.Inspect.Gradation.Color[3],
								   KF.db.Modules.Armory.Inspect.Gradation.Color[4]
						end,
						set = function(Info, r, g, b, a)
							KF.db.Modules.Armory.Inspect.Gradation.Color = { r, g, b, a }
							
							if InspectArmory.LastDataSetting then
								InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
							end
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false or KF.db.Modules.Armory.Inspect.Gradation.Display == false end
					},
				}
			},
			Space3 = {
				type = 'description',
				name = ' ',
				order = 6
			},
			Level = {
				type = 'group',
				name = function() return IA_Color('ffffffff', 'ff787878')..L['Item Level'] end,
				order = 7,
				guiInline = true,
				get = function(info) return KF.db.Modules.Armory.Inspect[(info[#info - 1])][(info[#info])] end,
				set = function(info, value)
					KF.db.Modules.Armory.Inspect[(info[#info - 1])][(info[#info])] = value
					
					for _, SlotName in pairs(Info.Armory_Constants.GearList) do
						if InspectArmory[SlotName] and InspectArmory[SlotName].Gradation and InspectArmory[SlotName].Gradation.ItemLevel then
							InspectArmory[SlotName].Gradation.ItemLevel:FontTemplate(
								E.LSM:Fetch('font', KF.db.Modules.Armory.Inspect.Level.Font)
								,
								KF.db.Modules.Armory.Inspect.Level.FontSize
								,
								KF.db.Modules.Armory.Inspect.Level.FontStyle
							)
						end
					end
				end,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..IA_Color()..L['Display Method'] end,
						order = 1,
						set = function(info, value)
							KF.db.Modules.Armory.Inspect[(info[#info - 1])][(info[#info])] = value
							
							if InspectArmory.LastDataSetting then
								InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
							end
							InspectArmory:Update_Display(true)
						end,
						values = DisplayMethodList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					ShowUpgradeLevel = {
						type = 'toggle',
						name = function() return ' '..IA_Color()..L['Show Upgrade Level'] end,
						order = 2,
						set = function(_, value)
							KF.db.Modules.Armory.Inspect.Level.ShowUpgradeLevel = value
							
							if InspectArmory.LastDataSetting then
								InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
							end
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					Space = {
						type = 'description',
						name = ' ',
						order = 3
					},
					Font = {
						type = 'select', dialogControl = 'LSM30_Font',
						name = function() return ' '..IA_Color()..L['Font'] end,
						order = 4,
						values = function()
							return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					FontSize = {
						type = 'range',
						name = function() return ' '..IA_Color()..L['Font Size'] end,
						order = 5,
						desc = '',
						descStyle = 'inline',
						min = 6,
						max = 22,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					FontStyle = {
						type = 'select',
						name = function() return ' '..IA_Color()..L['Font Outline'] end,
						order = 6,
						desc = '',
						descStyle = 'inline',
						values = FontStyleList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					}
				}
			},
			Space4 = {
				type = 'description',
				name = ' ',
				order = 8
			},
			Enchant = {
				type = 'group',
				name = function() return IA_Color('ffffffff', 'ff787878')..L['Enchant String'] end,
				order = 9,
				guiInline = true,
				get = function(info) return KF.db.Modules.Armory.Inspect[(info[#info - 1])][(info[#info])] end,
				set = function(info, value)
					KF.db.Modules.Armory.Inspect[(info[#info - 1])][(info[#info])] = value
					
					for _, SlotName in pairs(Info.Armory_Constants.GearList) do
						if InspectArmory[SlotName] and InspectArmory[SlotName].Gradation and InspectArmory[SlotName].Gradation.ItemEnchant then
							InspectArmory[SlotName].Gradation.ItemEnchant:FontTemplate(
								E.LSM:Fetch('font', KF.db.Modules.Armory.Inspect.Enchant.Font)
								,
								KF.db.Modules.Armory.Inspect.Enchant.FontSize
								,
								KF.db.Modules.Armory.Inspect.Enchant.FontStyle
							)
						end
					end
				end,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..IA_Color()..L['Display Method'] end,
						order = 1,
						set = function(info, value)
							KF.db.Modules.Armory.Inspect[(info[#info - 1])][(info[#info])] = value
							
							if InspectArmory.LastDataSetting then
								InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
							end
							InspectArmory:Update_Display(true)
						end,
						values = DisplayMethodList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					WarningSize = {
						type = 'range',
						name = function() return ' '..IA_Color()..L['Warning Size'] end,
						order = 2,
						set = function(_, value)
							KF.db.Modules.Armory.Inspect.Enchant.WarningSize = value
							
							for _, SlotName in pairs(Info.Armory_Constants.GearList) do
								if InspectArmory[SlotName] and InspectArmory[SlotName].EnchantWarning then
									InspectArmory[SlotName].EnchantWarning:Size(value)
								end
							end
						end,
						min = 6,
						max = 50,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					WarningIconOnly = {
						type = 'toggle',
						name = function() return ' '..IA_Color()..L['Show Warning Only'] end,
						order = 3,
						set = function(_, value)
							KF.db.Modules.Armory.Inspect.Enchant.WarningIconOnly = value
							
							if InspectArmory.LastDataSetting then
								InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
							end
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end,
					},
					Space = {
						type = 'description',
						name = ' ',
						order = 4
					},
					Font = {
						type = 'select', dialogControl = 'LSM30_Font',
						name = function() return ' '..IA_Color()..L['Font'] end,
						order = 5,
						values = function()
							return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					FontSize = {
						type = 'range',
						name = function() return ' '..IA_Color()..L['Font Size'] end,
						order = 6,
						desc = '',
						descStyle = 'inline',
						min = 6,
						max = 22,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					FontStyle = {
						type = 'select',
						name = function() return ' '..IA_Color()..L['Font Outline'] end,
						order = 7,
						desc = '',
						descStyle = 'inline',
						values = FontStyleList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					}
				}
			},
			Space5 = {
				type = 'description',
				name = ' ',
				order = 10
			},
			Gem = {
				type = 'group',
				name = function() return IA_Color('ffffffff', 'ff787878')..L['Gem Socket'] end,
				order = 11,
				guiInline = true,
				get = function(Info) return KF.db.Modules.Armory.Inspect[(Info[#Info - 1])][(Info[#Info])] end,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..IA_Color()..L['Display Method'] end,
						order = 1,
						set = function(Info, value)
							KF.db.Modules.Armory.Inspect[(Info[#Info - 1])][(Info[#Info])] = value
							
							if InspectArmory.LastDataSetting then
								InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
							end
							InspectArmory:Update_Display(true)
						end,
						values = DisplayMethodList,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					SocketSize = {
						type = 'range',
						name = function() return ' '..IA_Color()..L['Socket Size'] end,
						order = 2,
						set = function(_, value)
							KF.db.Modules.Armory.Inspect.Gem.SocketSize = value
							
							for _, SlotName in pairs(Info.Armory_Constants.GearList) do
								for i = 1, MAX_NUM_SOCKETS do
									if InspectArmory[SlotName] and InspectArmory[SlotName]['Socket'..i] then
										InspectArmory[SlotName]['Socket'..i]:Size(value)
									else
										break
									end
								end
							end
						end,
						min = 6,
						max = 50,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
					WarningSize = {
						type = 'range',
						name = function() return ' '..IA_Color()..L['Warning Size'] end,
						order = 3,
						set = function(_, value)
							KF.db.Modules.Armory.Inspect.Gem.WarningSize = value
							
							for _, SlotName in pairs(Info.Armory_Constants.GearList) do
								if InspectArmory[SlotName] and InspectArmory[SlotName].SocketWarning then
									InspectArmory[SlotName].SocketWarning:Size(value)
								end
							end
						end,
						min = 6,
						max = 50,
						step = 1,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Inspect.Enable == false end
					},
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
end