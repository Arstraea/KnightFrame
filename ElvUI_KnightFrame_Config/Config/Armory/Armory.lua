local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (KF and KF.Modules and (KF.Modules.CharacterArmory or KF.Modules.InspectArmory) and KF_Config) then return end

local function Color(TrueColor, FalseColor)
	return KF.db.Enable ~= false and (KF.db.Modules.Armory.Character.Enable ~= false or KF.db.Modules.Armory.Inspect.Enable ~= false) and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
end

local EnchantString_Old, EnchantString_New, SelectedEnchantString = '', '', ''

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
							disabled = function() return KF.db.Enable == false or (KF.db.Modules.Armory.Character.Enable == false and KF.db.Modules.Armory.Inspect.Enable == false) end,
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
							disabled = function() return KF.db.Enable == false or (KF.db.Modules.Armory.Character.Enable == false and KF.db.Modules.Armory.Inspect.Enable == false) end,
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
								local List = {
									[''] = NONE,
								}
								
								for Old, New in pairs(KnightFrame_ArmoryDB.EnchantString) do
									List[Old] = Old
								end
								
								return List
							end,
							disabled = function() return KF.db.Enable == false or (KF.db.Modules.Armory.Character.Enable == false and KF.db.Modules.Armory.Inspect.Enable == false) end,
						},
						Space2 = {
							type = 'description',
							name = ' ',
							order = 5,
							width = 'half'
						},
						AddButton = {
							type = 'execute',
							name = function() return ((KF.db.Enable == false or (KF.db.Modules.Armory.Character.Enable == false and KF.db.Modules.Armory.Inspect.Enable == false) or EnchantString_Old == '' or EnchantString_New == '') and '|cff787878' or KF:Color_Value())..L['Add New Order'] end,
							order = 6,
							desc = '',
							descStyle = 'inline',
							func = function()
								if EnchantString_Old ~= '' and EnchantString_New ~= '' then
									KF_Config.Options.args.Armory.args.EnchantString.args.AddNewReplacingOrder.args.HelpDescription.name = ''
									
									KnightFrame_ArmoryDB.EnchantString[EnchantString_Old] = EnchantString_New
									
									EnchantString_Old = ''
									EnchantString_New = ''
									
									if CharacterArmory then
										CharacterArmory:Update_Gear()
									end
									
									if InspectArmory and InspectArmory.LastDataSetting then
										InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
									end
								elseif KnightFrame_ArmoryDB.EnchantString[EnchantString_Old] and EnchantString_New == '' then
									KnightFrame_ArmoryDB.EnchantString[EnchantString_Old] = nil
								else
									KF_Config.Options.args.Armory.args.EnchantString.args.AddNewReplacingOrder.args.HelpDescription.name = '    |cffFF7E7E'..L['You must input string that target and new both.']
								end
							end,
							disabled = function()
								return KF.db.Enable == false or (KF.db.Modules.Armory.Character.Enable == false and KF.db.Modules.Armory.Inspect.Enable == false) or EnchantString_Old == '' or EnchantString_New == ''
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
								if KnightFrame_ArmoryDB.EnchantString[SelectedEnchantString] then
									KnightFrame_ArmoryDB.EnchantString[SelectedEnchantString] = nil
									SelectedEnchantString = ''
									
									if CharacterArmory then
										CharacterArmory:Update_Gear()
									end
									
									if InspectArmory and InspectArmory.LastDataSetting then
										InspectArmory:InspectFrame_DataSetting(InspectArmory.CurrentInspectData)
									end
								end
							end,
							disabled = function() return KF.db.Enable == false or (KF.db.Modules.Armory.Character.Enable == false and KF.db.Modules.Armory.Inspect.Enable == false) end,
							hidden = function()
								return SelectedEnchantString == ''
							end
						},
						HelpDescription = {
							type = 'description',
							name = '',
							order = 998,
							width = 'full'
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
								
								if KnightFrame_ArmoryDB.EnchantString and next(KnightFrame_ArmoryDB.EnchantString) then
									for Old, New in pairs(KnightFrame_ArmoryDB.EnchantString) do
										List = List..'    '..Color('ffffffff', 'ff787878')..Order..'. '..Color('ffFF7E7E', 'ff787878')..Old..'|r  '..Color('ffceff00', 'ff787878')..'->|r  '..Color(nil, 'ff787878')..New..'|r|n'
										Order = Order + 1
									end
								else
									List = '    |cffFF7E7E'..L['There is no replacing order.']
								end
								
								return List
							end,
							order = 1,
							disabled = function() return KF.db.Enable == false or (KF.db.Modules.Armory.Character.Enable == false and KF.db.Modules.Armory.Inspect.Enable == false) end,
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


local BackgroundKeyTable = {
	['1'] = 'HIDE',
	['2'] = 'CUSTOM',
	['3'] = 'Space',
	['4'] = 'Horde',
	['5'] = 'Alliance',
}

if KF.Modules.CharacterArmory then
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
		name = function() return Color('', 'ff787878')..L['Character Armory'] end,
		order = 400,
		args = {
			NoticeMissing = {
				type = 'toggle',
				name = function() return ' '..Color()..'마부 안한거 경고' end,
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function() return KF.db.Modules.Armory.Character.NoticeMissing end,
				set = function(_, value)
					KF.db.Modules.Armory.Character.NoticeMissing = value
					
				end,
			},
			Space1 = {
				type = 'description',
				name = ' ',
				order = 2
			},
			Background = {
				type = 'group',
				name = function() return Color('ffffffff', 'ff787878')..'배경 설정' end,
				order = 3,
				guiInline = true,
				args = {
					SelectedBG = {
						type = 'select',
						name = function() return ' '..Color()..'배경 뭐로할래' end,
						order = 1,
						get = function()
							for Index, Key in pairs(BackgroundKeyTable) do
								if Key == KF.db.Modules.Armory.Character.Background.SelectedBG then
									return Index
								end
							end
							
							return '1'
						end,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Background.SelectedBG = BackgroundKeyTable[value]
							
							CharacterArmory:Update_BG()
						end,
						values = function()
							return {
								['1'] = '숨기기',
								['2'] = '직접 선택',
								['3'] = '우주배경',
								['4'] = '호드배경',
								['5'] = '얼라배경',
							}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end,
					},
					CustomAddress = {
						type = 'input',
						name = function() return ' '..Color()..L['Custom Background Image Address'] end,
						order = 2,
						desc = '',
						descStyle = 'inline',
						get = function() return KF.db.Modules.Armory.Character.Background.CustomAddress end,
						set = function(_, value)
							KF.db.Modules.Armory.Character.Background.CustomAddress = value
							
							CharacterArmory:Update_BG()
						end,
						width = 'double',
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end,
						hidden = function() return KF.db.Modules.Armory.Character.Background.SelectedBG ~= 'CUSTOM' end
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
				name = function() return Color('ffffffff', 'ff787878')..'그라데이션 설정' end,
				order = 5,
				guiInline = true,
				args = {
					Display = {
						type = 'toggle',
						name = function() return ' '..Color()..'배경 뭐로할래' end,
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
						name = function() return ' '..(KF.db.Enable == true and KF.db.Modules.Armory.Character.Enable == true and KF.db.Modules.Armory.Character.Gradation.Display == true and KF:Color_Value() or '')..'그라데이션 표시' end,
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
				name = function() return Color('ffffffff', 'ff787878')..'아이템레벨 설정' end,
				order = 7,
				guiInline = true,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..Color()..'템렙 표시방법?' end,
						order = 1,
						get = function(Info) return KF.db.Modules.Armory.Character[(Info[#Info - 1])][(Info[#Info])] end,
						set = function(info, value)
							KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
							
							CharacterArmory:Update_Display(true)
							CharacterArmory:Update_Gear()
						end,
						values = function()
							return {
								['Always'] = '항상 표시',
								['MouseoverOnly'] = '마우스오버',
								['Hide'] = '숨기기'
							}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
				}
			},
			Space4 = {
				type = 'description',
				name = ' ',
				order = 8
			},
			Enchant = {
				type = 'group',
				name = function() return Color('ffffffff', 'ff787878')..'마법부여 설정' end,
				order = 9,
				guiInline = true,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..Color()..'마부 표시방법?' end,
						order = 1,
						get = function(Info) return KF.db.Modules.Armory.Character[(Info[#Info - 1])][(Info[#Info])] end,
						set = function(info, value)
							KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
							
							CharacterArmory:Update_Display(true)
							CharacterArmory:Update_Gear()
						end,
						values = function()
							return {
								['Always'] = '항상 표시',
								['MouseoverOnly'] = '마우스오버',
								['Hide'] = '숨기기'
							}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
				}
			},
			Space5 = {
				type = 'description',
				name = ' ',
				order = 10
			},
			Durability = {
				type = 'group',
				name = function() return Color('ffffffff', 'ff787878')..'내구도 설정' end,
				order = 11,
				guiInline = true,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..Color()..'내구도 표시방법?' end,
						order = 1,
						get = function(Info) return KF.db.Modules.Armory.Character[(Info[#Info - 1])][(Info[#Info])] end,
						set = function(info, value)
							KF.db.Modules.Armory.Character[(info[#info - 1])][(info[#info])] = value
							
							CharacterArmory:Update_Durability()
							CharacterArmory:Update_Display(true)
						end,
						values = function()
							return {
								['Always'] = '항상 표시',
								['DamagedOnly'] = '손상시에만',
								['MouseoverOnly'] = '마우스오버',
								['Hide'] = '숨기기'
							}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
				}
			},
			Space6 = {
				type = 'description',
				name = ' ',
				order = 12
			},
			Gem = {
				type = 'group',
				name = function() return Color('ffffffff', 'ff787878')..'보석홈 설정' end,
				order = 13,
				guiInline = true,
				args = {
					Display = {
						type = 'select',
						name = function() return ' '..Color()..'보석홈 표시방법?' end,
						order = 1,
						get = function(Info) return KF.db.Modules.Armory.Character[(Info[#Info - 1])][(Info[#Info])] end,
						set = function(Info, value)
							KF.db.Modules.Armory.Character[(Info[#Info - 1])][(Info[#Info])] = value
							
							CharacterArmory:Update_Display(true)
							CharacterArmory:Update_Gear()
						end,
						values = function()
							return {
								['Always'] = '항상 표시',
								['MouseoverOnly'] = '마우스오버',
								['Hide'] = '숨기기'
							}
						end,
						disabled = function() return KF.db.Enable == false or KF.db.Modules.Armory.Character.Enable == false end
					},
				}
			}
		}
	}
end


if KF.Modules.InspectArmory then
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
			
		}
	}
end