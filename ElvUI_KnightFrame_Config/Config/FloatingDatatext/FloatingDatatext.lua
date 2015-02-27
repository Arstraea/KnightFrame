local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (KF and KF.Modules and KF.Modules.FloatingDatatext and KF_Config) then return end
--------------------------------------------------------------------------------
--<< KnightFrame : Floating Datatext OptionTable							>>--
--------------------------------------------------------------------------------
local DT = E:GetModule('DataTexts')
local DatatextInfo = {}
local SelectedDatatext = ''
local IsModified, Message


local function NameColor(Color)
	return KF.db.Enable ~= false and KF.db.Modules.FloatingDatatext.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
end


local function CompareTable(MainTable, TableToCompare)
	for Tag, Data in pairs(MainTable) do
		if not TableToCompare[Tag] or TableToCompare[Tag] ~= Data then
			return false
		end
	end
	
	return true
end


--<< Floating Datatext >>--
KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.FloatingDatatext = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Floating Datatext']) end,
	order = 100 + OptionIndex,
	disabled = function() return KF.db.Enable == false end,
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(KF.db.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Floating Datatext'] end,
			order = 1,
			desc = '',
			descStyle = 'inline',
			get = function() return KF.db.Modules.FloatingDatatext.Enable end,
			set = function(_, value)
				KF.db.Modules.FloatingDatatext.Enable = value
				
				KF.Modules.FloatingDatatext()
			end,
			width = 'full',
		},
		SelectDatatext = {
			type = 'select',
			name = function() return ' '..NameColor()..L['Select'] end,
			order = 2,
			get = function() return SelectedDatatext end,
			set = function(_, value)
				SelectedDatatext = value
				IsModified = nil
				Message = nil
				
				DatatextInfo = nil
				DatatextInfo = E:CopyTable({}, Info.FloatingDatatext_Default)
				
				if value ~= '0' then
					KF:FloatingDatatext_Delete(0)
					
					E:CopyTable(DatatextInfo, KF.db.Modules.FloatingDatatext[value])
					DatatextInfo.Name = value
				end
			end,
			values = function()
				local list = { [''] = NameColor('ceff00')..L['Please Select'], ['0'] = NameColor()..L['Create new one'] }
				
				for datatextName, IsDatatextData in pairs(KF.db.Modules.FloatingDatatext) do
					if type(IsDatatextData) == 'table' then
						list[datatextName] = (IsDatatextData.Enable == false and '|cff712633' or '')..datatextName
					end
				end
				
				return list
			end,
			hidden = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false end
		},
		Space = {
			type = 'description',
			name = ' ',
			order = 3,
			width = 'half'
		},
		Description = {
			type = 'description',
			name = function() return Message or ' ' end,
			order = 4,
			width = 'double',
			hidden = function() return SelectedDatatext == '0' and (DatatextInfo.Name == '' or not DatatextInfo.Name) end
		},
		Name_NewDatatext = {
			type = 'input',
			name = function() return ' '..NameColor()..L['Input New Name'] end,
			order = 5,
			desc = '',
			descStyle = 'inline',
			get = function() return '' end,
			set = function(_, value)
				if value ~= '' and value ~= nil then
					DatatextInfo.Name = value
					
					KF:FloatingDatatext_Create(0, DatatextInfo)
					
					local ACD = LibStub('AceConfigDialog-3.0')
					
					KF.UIParent.Datatext[0]:SetScript('OnUpdate', function(self)
						if (not ACD.OpenFrames.ElvUI or not ACD.OpenFrames.ElvUI:IsShown()) then
							self:SetAlpha(0)
						else
							self:SetAlpha(1)
						end
					end)
				end
			end,
			hidden = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or SelectedDatatext == '' or (DatatextInfo.Name and DatatextInfo.Name ~= '') end,
		},
		ConfigSpace = {
			type = 'group',
			name = ' ',
			order = 100,
			guiInline = true,
			get = function(info) return DatatextInfo[(info[#info])] end,
			set = function(info, value)
				Message = nil
				
				if DatatextInfo[(info[#info])] ~= value then
					IsModified = true
				end
				
				DatatextInfo[(info[#info])] = value
				
				KF:FloatingDatatext_Create(SelectedDatatext == '0' and 0 or SelectedDatatext, DatatextInfo)
			end,
			hidden = function() return  KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or SelectedDatatext == '' or DatatextInfo.Name == '' or not DatatextInfo.Name end,
			args = {
				Name = {
					type = 'input',
					name = function() return ' '..NameColor()..L['Datatext Name'] end,
					order = 1,
					desc = '',
					descStyle = 'inline',
					set = function(_, value)
						if value ~= '' and value ~= nil then
							Message = nil
							
							if DatatextInfo.Name ~= value then
								IsModified = true
							end
							
							DatatextInfo.Name = value
						end
					end
				},
				Space = {
					type = 'description',
					name = ' ',
					order = 2,
					width = 'normal'
				},
				Save = {
					type = 'execute',
					name = function() return (KF.db.Enable ~= false and KF.db.Modules.FloatingDatatext.Enable ~= false and not (SelectedDatatext ~= '0' and not IsModified) and DatatextInfo.Name and DatatextInfo.Name ~= '' and KF:Color_Value() or '|cff808080')..L['Save'] end,
					order = 3,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						local CurrentDatatextName = (SelectedDatatext == '0' or (DatatextInfo.Name ~= SelectedDatatext)) and DatatextInfo.Name or SelectedDatatext
						
						if not (SelectedDatatext ~= '0' and DatatextInfo.Name == SelectedDatatext) and KF.db.Modules.FloatingDatatext[CurrentDatatextName] and
							Message ~= L['The data of datatext that uses the same name already exists.']..'|n'..L['Are you sure you want to OVERWRITE it?'] then
							
							Message = L['The data of datatext that uses the same name already exists.']..'|n'..L['Are you sure you want to OVERWRITE it?']
							return
						elseif KF.db.Modules.FloatingDatatext[CurrentDatatextName] then
							KF:FloatingDatatext_Delete(CurrentDatatextName)
						elseif SelectedDatatext ~= '0' and DatatextInfo.Name ~= SelectedDatatext then
							KF:FloatingDatatext_Delete(SelectedDatatext, true)
							E.db.movers[CurrentDatatextName] = E.db.movers[SelectedDatatext]
							E.db.movers[SelectedDatatext] = nil
							
							KF.db.Modules.FloatingDatatext[SelectedDatatext] = nil
						end
						
						if SelectedDatatext == '0' then
							KF:FloatingDatatext_Delete(0, true)
							E.db.movers[CurrentDatatextName] = E.db.movers[0]
							E.db.movers[0] = nil
						end
						
						local SaveData = E:CopyTable({}, DatatextInfo)
						SaveData.Name = nil
						KF.db.Modules.FloatingDatatext[CurrentDatatextName] = SaveData
						
						IsModified = nil
						
						if not IsOverwriting and SelectedDatatext == '0' then
							Message = format(L['New data has been saved successfully and %s was created.'], KF:Color_Value(CurrentDatatextName))
						elseif IsOverwriting then
							Message = format(L['All changes have been saved to %s data.'], KF:Color_Value(CurrentDatatextName))
						else
							Message = L['All changes have been saved successfully.']
						end
						
						SelectedDatatext = CurrentDatatextName
						
						KF:FloatingDatatext_Create(SelectedDatatext)
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or (SelectedDatatext ~= '0' and not IsModified) or not DatatextInfo.Name or DatatextInfo.Name == '' end
				},
				Reset = {
					type = 'execute',
					name = function() return (KF.db.Enable ~= false and KF.db.Modules.FloatingDatatext.Enable ~= false and IsModified == true and KF:Color_Value() or '|cff808080')..L['Reset'] end,
					order = 4,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						IsModified = nil
						Message = nil
						
						if SelectedDatatext ~= '0' then
							DatatextInfo = E:CopyTable({}, Info.FloatingDatatext_Default)
							
							KF:FloatingDatatext_Delete(0)
							
							E:CopyTable(DatatextInfo, KF.db.Modules.FloatingDatatext[SelectedDatatext])
							DatatextInfo.Name = SelectedDatatext
							
							KF:FloatingDatatext_Create(SelectedDatatext, DatatextInfo)
						else
							local SavedName = DatatextInfo.Name
							DatatextInfo = E:CopyTable({}, Info.FloatingDatatext_Default)
							DatatextInfo.Name = SavedName
							
							KF:FloatingDatatext_Create(0, DatatextInfo)
						end
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or not IsModified end
				},
				Delete = {
					type = 'execute',
					name = function() return (KF.db.Enable ~= false and KF.db.Modules.FloatingDatatext.Enable ~= false and SelectedDatatext ~= '0' and '|cffff5675' or '|cff808080')..L['Delete'] end,
					order = 5,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						if Message ~= format(L['Are you sure you want to delete this %s?|nIf yes, press the Delete button again.'], KF:Color_Value(SelectedDatatext)..' '..L['Datatext']) then
							Message = format(L['Are you sure you want to delete this %s?|nIf yes, press the Delete button again.'], KF:Color_Value(SelectedDatatext)..' '..L['Datatext'])
						else
							if E.db.KnightFrame and E.db.KnightFrame.Modules and E.db.KnightFrame.Modules.FloatingDatatext then
								E.db.KnightFrame.Modules.FloatingDatatext[SelectedDatatext] = nil
							end
							KF.db.Modules.FloatingDatatext[SelectedDatatext] = nil
							
							Message = format(L['%s has been deleted.'], KF:Color_Value(SelectedDatatext))
							KF:FloatingDatatext_Delete(SelectedDatatext)
							
							SelectedDatatext = ''
							IsModified = nil
						end
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or SelectedDatatext == '0' end
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 10
				},
				Enable = {
					type = 'toggle',
					name = function() return ' '..(SelectedDatatext ~= '0' and NameColor() or '|cff808080')..L['Enable'] end,
					order = 11,
					desc = '',
					descStyle = 'inline',
					get = function()
						return SelectedDatatext == '0' or DatatextInfo.Enable
					end,
					set = function(_, value)
						if SelectedDatatext ~= '0' then
							Message = nil
							
							if DatatextInfo.Enable ~= value then
								IsModified = true
							end
							
							DatatextInfo.Enable = value
							
							KF:FloatingDatatext_Create(SelectedDatatext, DatatextInfo)
						end
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false end
				},
				IgnoreCursor = {
					type = 'toggle',
					name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..L['Ignore Cursor'] end,
					order = 12,
					desc = '',
					descStyle = 'inline',
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or DatatextInfo.Enable == false end
				},
				Space3 = {
					type = 'description',
					name = ' ',
					order = 13,
					width = 'half'
				},
				HideWhenPetBattle = {
					type = 'toggle',
					name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..L['Hide when PetBattle'] end,
					order = 14,
					desc = '',
					descStyle = 'inline',
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or DatatextInfo.Enable == false end
				},
				Space4 = {
					type = 'description',
					name = ' ',
					order = 99
				},
				Display = {
					type = 'group',
					name = L['Display'],
					order = 100,
					guiInline = true,
					get = function(info) return DatatextInfo.Display[(info[#info])] or '' end,
					set = function(info, value)
						Message = nil
						
						if DatatextInfo.Display[(info[#info])] ~= value then
							IsModified = true
						end
						
						DatatextInfo.Display[(info[#info])] = value
						
						KF:FloatingDatatext_Create(SelectedDatatext == '0' and 0 or SelectedDatatext, DatatextInfo)
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or DatatextInfo.Enable == false end,
					args = {
						Mode = {
							type = 'select',
							name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..L['Datatext Module'] end,
							order = 1,
							set = function(info, value)
								Message = nil
								
								if DatatextInfo.Display.Mode ~= value then
									IsModified = true
									
									if value == '0' then -- Clear each role's data
										DatatextInfo.Display.Tank = ''
										DatatextInfo.Display.Melee = ''
										DatatextInfo.Display.Caster = ''
										DatatextInfo.Display.Healer = ''
									end
								end
								
								DatatextInfo.Display.Mode = value
								
								KF:FloatingDatatext_Create(SelectedDatatext == '0' and 0 or SelectedDatatext, DatatextInfo)
							end,
							values = function()
								local list = { [''] = '|cffceff00'..L['Please Select'], ['0'] = KF:Color_Value(L['by Spec Role']) }
								
								for name, _ in pairs(DT.RegisteredDataTexts) do
									list[name] = name
								end
								
								return list
							end
						},
						PvPMode = {
							type = 'select',
							name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..L['PvP Mode'] end,
							order = 2,
							values = function()
								local list = { [''] = '|cffceff00'..L['Please Select'], }
								
								for name, _ in pairs(DT.RegisteredDataTexts) do
									list[name] = name
								end
								
								return list
							end
						},
						Tank = {
							type = 'select',
							name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..ROLE..' : |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\tank:13:13:1:0|t '..(DatatextInfo.Enable ~= false and NameColor('ffffff') or '')..L['Tank'] end,
							order = 3,
							hidden = function() return DatatextInfo.Display.Mode ~= '0' end,
							values = function()
								local list = { [''] = '|cffceff00'..L['Please Select'] }
								
								for name, _ in pairs(DT.RegisteredDataTexts) do
									list[name] = name
								end
								
								return list
							end
						},
						Melee = {
							type = 'select',
							name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..ROLE..' : |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\dps:13:13:1:0|t '..(DatatextInfo.Enable ~= false and NameColor('ffffff') or '')..L['Melee'] end,
							order = 4,
							hidden = function() return DatatextInfo.Display.Mode ~= '0' end,
							values = function()
								local list = { [''] = '|cffceff00'..L['Please Select'] }
								
								for name, _ in pairs(DT.RegisteredDataTexts) do
									list[name] = name
								end
								
								return list
							end,
						},
						Caster = {
							type = 'select',
							name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..ROLE..' : |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\dps:13:13:1:0|t '..(DatatextInfo.Enable ~= false and NameColor('ffffff') or '')..L['Caster'] end,
							order = 5,
							hidden = function() return DatatextInfo.Display.Mode ~= '0' end,
							values = function()
								local list = { [''] = '|cffceff00'..L['Please Select'] }
								
								for name, _ in pairs(DT.RegisteredDataTexts) do
									list[name] = name
								end
								
								return list
							end,
						},
						Healer = {
							type = 'select',
							name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..ROLE..' : |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\healer:13:13:1:0|t '..(DatatextInfo.Enable ~= false and NameColor('ffffff') or '')..L['Healer'] end,
							order = 6,
							hidden = function() return DatatextInfo.Display.Mode ~= '0' end,
							values = function()
								local list = { [''] = '|cffceff00'..L['Please Select'] }
								
								for name, _ in pairs(DT.RegisteredDataTexts) do
									list[name] = name
								end
								
								return list
							end,
						},
					},
				},
				Space5 = {
					type = 'description',
					name = ' ',
					order = 199
				},
				Backdrop = {
					type = 'group',
					name = L['Backdrop'],
					order = 200,
					guiInline = true,
					get = function(info) return DatatextInfo.Backdrop[(info[#info])] end,
					set = function(info, value)
						Message = nil
						
						if DatatextInfo.Backdrop[(info[#info])] ~= value then
							IsModified = true
						end
						
						DatatextInfo.Backdrop[(info[#info])] = value
						
						KF:FloatingDatatext_Create(SelectedDatatext == '0' and 0 or SelectedDatatext, DatatextInfo)
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or DatatextInfo.Enable == false or DatatextInfo.Backdrop.Enable == false end,
					args = {
						Enable = {
							type = 'toggle',
							name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..L['Enable'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
							disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or DatatextInfo.Enable == false end
						},
						Transparency = {
							type = 'toggle',
							name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Backdrop.Enable ~= false and NameColor() or '')..L['Transparency'] end,
							order = 2,
							desc = '',
							descStyle = 'inline'
						},
						CustomColor = {
							type = 'toggle',
							name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Backdrop.Enable ~= false and NameColor() or '')..L['Use Custom Color'] end,
							order = 3,
							desc = '',
							descStyle = 'inline'
						},
						Space = {
							type = 'description',
							name = ' ',
							order = 4
						},
						Width = {
							type = 'range',
							name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Backdrop.Enable ~= false and NameColor() or '')..L['Width'] end,
							order = 5,
							desc = '',
							descStyle = 'inline',
							min = 50,
							max = 300,
							step = 1
						},
						Height = {
							type = 'range',
							name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Backdrop.Enable ~= false and NameColor() or '')..L['Height'] end,
							order = 6,
							desc = '',
							descStyle = 'inline',
							min = 10,
							max = 50,
							step = 1
						},
						Texture = {
							type = "select", dialogControl = 'LSM30_Statusbar',
							name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Backdrop.Enable ~= false and NameColor() or '')..L['Texture'] end,
							order = 7,
							desc = '',
							descStyle = 'inline',
							values = function() return AceGUIWidgetLSMlists.statusbar end
						},
						Space2 = {
							type = 'description',
							name = ' ',
							order = 8,
							hidden = function() return DatatextInfo.Backdrop.CustomColor == false end
						},
						Color = {
							type = 'group',
							name = L['Color'],
							order = 100,
							guiInline = true,
							hidden = function() return DatatextInfo.Backdrop.CustomColor == false end,
							args = {
								CustomColor_Border = {
									type = 'color',
									name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Backdrop.Enable ~= false and NameColor() or '')..L['Border'] end,
									order = 1,
									hasAlpha = false,
									get = function(info)
										return DatatextInfo.Backdrop[(info[#info])].r, DatatextInfo.Backdrop[(info[#info])].g, DatatextInfo.Backdrop[(info[#info])].b
									end,
									set = function(info, r, g, b)
										Message = nil
										
										local SaveData = { r = r, g = g, b = b }
										
										if CompareTable(SaveData, DatatextInfo.Backdrop[(info[#info])]) then
											IsModified = true
										end
										
										DatatextInfo.Backdrop[(info[#info])] = SaveData
										
										KF:FloatingDatatext_Create(SelectedDatatext == '0' and 0 or SelectedDatatext, DatatextInfo)
									end
								},
								CustomColor_Backdrop = {
									type = 'color',
									name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Backdrop.Enable ~= false and NameColor() or '')..L['Backdrop'] end,
									order = 2,
									hasAlpha = false,
									get = function(info)
										return DatatextInfo.Backdrop[(info[#info])].r, DatatextInfo.Backdrop[(info[#info])].g, DatatextInfo.Backdrop[(info[#info])].b, DatatextInfo.Backdrop[(info[#info])].a
									end,
									set = function(info, r, g, b, a)
										Message = nil
										
										local SaveData = { r = r, g = g, b = b, a = a }
										
										if CompareTable(SaveData, DatatextInfo.Backdrop[(info[#info])]) then
											IsModified = true
										end
										
										DatatextInfo.Backdrop[(info[#info])] = SaveData
										
										KF:FloatingDatatext_Create(SelectedDatatext == '0' and 0 or SelectedDatatext, DatatextInfo)
									end,
									hidden = function() return DatatextInfo.Backdrop.Transparency ~= false end
								},
								CustomColor_Backdrop_Transparency = {
									type = 'color',
									name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Backdrop.Enable ~= false and NameColor() or '')..L['Backdrop (Transparency)'] end,
									order = 3,
									hasAlpha = false,
									get = function(info)
										return DatatextInfo.Backdrop[(info[#info])].r, DatatextInfo.Backdrop[(info[#info])].g, DatatextInfo.Backdrop[(info[#info])].b, DatatextInfo.Backdrop[(info[#info])].a
									end,
									set = function(info, r, g, b, a)
										Message = nil
										
										local SaveData = { r = r, g = g, b = b, a = a, }
										
										if CompareTable(SaveData, DatatextInfo.Backdrop[(info[#info])]) then
											IsModified = true
										end
										
										DatatextInfo.Backdrop[(info[#info])] = SaveData
										
										KF:FloatingDatatext_Create(SelectedDatatext == '0' and 0 or SelectedDatatext, DatatextInfo)
									end,
									hidden = function() return DatatextInfo.Backdrop.Transparency == false end
								}
							}
						}
					}
				},
				Space6 = {
					type = 'description',
					name = ' ',
					order = 299
				},
				Font = {
					type = 'group',
					name = L['Font'],
					order = 300,
					guiInline = true,
					get = function(info) return DatatextInfo.Font[(info[#info])] end,
					set = function(info, value)
						Message = nil
						
						if DatatextInfo.Font[(info[#info])] ~= value then
							IsModified = true
						end
						
						DatatextInfo.Font[(info[#info])] = value
						
						KF:FloatingDatatext_Create(SelectedDatatext == '0' and 0 or SelectedDatatext, DatatextInfo)
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or DatatextInfo.Enable == false or DatatextInfo.Font.UseCustomFontStyle == false end,
					args = {
						UseCustomFontStyle = {
							type = 'toggle',
							name = function() return ' '..(DatatextInfo.Enable ~= false and NameColor() or '')..L['Use Custom FontStyle'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
							width = 'full',
							disabled = function() return KF.db.Enable == false or KF.db.Modules.FloatingDatatext.Enable == false or DatatextInfo.Enable == false end
						},
						Space = {
							type = 'description',
							name = ' ',
							order = 2
						},
						Font = {
							type = 'select', dialogControl = 'LSM30_Font',
							name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Font.UseCustomFontStyle ~= false and NameColor() or '')..L['Font'] end,
							order = 3,
							values = function()
								return AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font or {}
							end
						},
						FontSize = {
							type = 'range',
							name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Font.UseCustomFontStyle ~= false and NameColor() or '')..L['Font Size'] end,
							order = 4,
							desc = '',
							descStyle = 'inline',
							min = 6,
							max = 22,
							step = 1
						},
						FontStyle = {
							type = 'select',
							name = function() return ' '..(DatatextInfo.Enable ~= false and DatatextInfo.Font.UseCustomFontStyle ~= false and NameColor() or '')..L['Font Outline'] end,
							order = 5,
							desc = '',
							descStyle = 'inline',
							values = {
								NONE = L['None'],
								OUTLINE = 'OUTLINE',
								
								MONOCHROMEOUTLINE = 'MONOCROMEOUTLINE',
								THICKOUTLINE = 'THICKOUTLINE'
							}
						}
					}
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
		},
	},
}