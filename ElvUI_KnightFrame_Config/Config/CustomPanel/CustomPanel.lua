local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (KF and KF.Modules and KF.Modules.CustomPanel and KF_Config) then return end
--------------------------------------------------------------------------------
--<< KnightFrame : Custom Panel OptionTable									>>--
--------------------------------------------------------------------------------
local PanelInfo = {}
local SelectedPanel = ''
local IsModified, Message


local function NameColor(Color)
	return DB.Enable ~= false and DB.Modules.CustomPanel.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
end


local function Create_ButtonConfig(frame, direction, number)
	E.Options.args.KnightFrame.args.CustomPanel.args.ConfigSpace.args[frame].args[direction].args[tostring(number)] = {
		type = 'select',
		name = '',
		order = number,
		desc = '',
		descStyle = 'inline',
		values = function()
			local list = { [''] = '|cff712633'..L['Disable'], }
			
			for buttonType in pairs(KF.UIParent.Button) do
				if buttonType ~= 'AreaToHide' then
					list[buttonType] = buttonType
				end
			end
			
			return list
		end
	}
end


--<< Panel Options >>--
KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.CustomPanel = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Custom Panel']) end,
	order = 100 + OptionIndex,
	disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false end,
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(DB.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(DB.Enable ~= false and KF:Color_Value() or '')..L['Custom Panel'] end,
			order = 1,
			desc = '',
			descStyle = 'inline',
			get = function() return DB.Modules.CustomPanel.Enable end,
			set = function(_, value)
				DB.Modules.CustomPanel.Enable = value
				
				KF.Modules.CustomPanel()
				KF:CallbackFire('CustomPanel_Toggle')
			end,
			width = 'full',
			disabled = function() return DB.Enable == false end
		},
		SelectPanel = {
			type = 'select',
			name = function() return ' '..(DB.Modules.CustomPanel.Enable ~= false and NameColor() or '')..L['Select'] end,
			order = 2,
			get = function() return SelectedPanel end,
			set = function(_, value)
				SelectedPanel = value
				IsModified = nil
				Message = nil
				
				PanelInfo = E:CopyTable({}, Info.CustomPanel_Default)
				
				if value ~= '0' then
					KF:CustomPanel_Delete(0)
					
					E:CopyTable(PanelInfo, DB.Modules.CustomPanel[value])
					PanelInfo.Name = value
				end
			end,
			values = function()
				local list = { [''] = (DB.Modules.CustomPanel.Enable ~= false and NameColor('ceff00') or '')..L['Please Select'], ['0'] = (DB.Modules.CustomPanel.Enable ~= false and NameColor() or '')..L['Create new one'], }
				
				for panelName, IsPanelData in pairs(DB.Modules.CustomPanel) do
					if type(IsPanelData) == 'table' then
						list[panelName] = (IsPanelData.Enable == false and '|cff712633' or '')..panelName
					end
				end
				
				return list
			end
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
			hidden = function() return SelectedPanel == '0' and (PanelInfo.Name == '' or not PanelInfo.Name) end
		},
		Name_NewPanel = {
			type = 'input',
			name = function() return ' '..(DB.Modules.CustomPanel.Enable ~= false and NameColor() or '')..L['Input New Name'] end,
			order = 5,
			desc = '',
			descStyle = 'inline',
			get = function() return '' end,
			set = function(_, value)
				if value ~= '' and value ~= nil then
					if _G[value] then
						Message = L['Frame that named same is already exists. Please enter a another name.']
					else
						PanelInfo.Name = value
						
						KF:CustomPanel_Create(0, PanelInfo)
						
						local ACD = LibStub('AceConfigDialog-3.0')
						
						KF.UIParent.Frame[0]:SetScript('OnUpdate', function(self)
							if (not ACD.OpenFrames.ElvUI or not ACD.OpenFrames.ElvUI:IsShown()) then
								self:SetAlpha(0)
							else
								self:SetAlpha(1)
							end
						end)
					end
				end
			end,
			hidden = function() return SelectedPanel == '' or (PanelInfo.Name and PanelInfo.Name ~= '') end
		},
		ConfigSpace = {
			type = 'group',
			name = ' ',
			order = 100,
			guiInline = true,
			get = function(info) return PanelInfo[(info[#info])] end,
			set = function(info, value)
				Message = nil
				
				if PanelInfo[(info[#info])] ~= value then
					IsModified = true
				end
				
				PanelInfo[(info[#info])] = value
				
				KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
			end,
			hidden = function() return SelectedPanel == '' or PanelInfo.Name == '' or not PanelInfo.Name end,
			args = {
				Name = {
					type = 'input',
					name = function() return ' '..NameColor()..L['Panel Name'] end,
					order = 1,
					desc = '',
					descStyle = 'inline',
					set = function(_, value)
						if value ~= '' and value ~= nil then
							if _G[value] then
								Message = L['Frame that named same is already exists. Please enter a another name.']
							else
								Message = nil
								
								if PanelInfo.Name ~= value then
									IsModified = true
								end
								
								PanelInfo.Name = value
							end
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
					name = function() return (DB.Enable ~= false and DB.Modules.CustomPanel.Enable ~= false and not (SelectedPanel ~= '0' and not IsModified) and PanelInfo.Name and PanelInfo.Name ~= '' and KF:Color_Value() or '|cff808080')..L['Save'] end,
					order = 3,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						local CurrentPanelName = (SelectedPanel == '0' or (PanelInfo.Name ~= SelectedPanel)) and PanelInfo.Name or SelectedPanel
						
						if not (SelectedPanel ~= '0' and PanelInfo.Name == SelectedPanel) and DB.Modules.CustomPanel[CurrentPanelName] and
							Message ~= L['Custom Panel that named same is already exists.']..'|n'..L['Are you sure you want to OVERWRITE it?'] then
							
							Message = L['Custom Panel that named same is already exists.']..'|n'..L['Are you sure you want to OVERWRITE it?']
							return
						elseif DB.Modules.CustomPanel[CurrentPanelName] then
							KF:CustomPanel_Delete(CurrentPanelName)
						elseif SelectedPanel ~= '0' and PanelInfo.Name ~= SelectedPanel then
							KF:CustomPanel_Delete(SelectedPanel, true)
							E.db.movers[CurrentPanelName] = E.db.movers[SelectedPanel]
							E.db.movers[SelectedPanel] = nil
							
							DB.Modules.CustomPanel[SelectedPanel] = nil
							
							KF:CallbackFire('CustomPanel_RewritePanelName', SelectedPanel, CurrentPanelName)
						end
						
						if SelectedPanel == '0' then
							KF:CustomPanel_Delete(0, true)
							E.db.movers[CurrentPanelName] = E.db.movers[0]
							E.db.movers[0] = nil
						end
						
						local SaveData = E:CopyTable({}, PanelInfo)
						SaveData.Name = nil
						DB.Modules.CustomPanel[CurrentPanelName] = SaveData
						
						IsModified = nil
						
						if not IsOverwriting and SelectedPanel == '0' then
							Message = format(L['New data has been saved successfully and %s was created.'], KF:Color_Value(CurrentPanelName))
						elseif IsOverwriting then
							Message = format(L['All changes have been saved to %s data.'], KF:Color_Value(CurrentPanelName))
						else
							Message = L['All changes have been saved successfully.']
						end
						
						SelectedPanel = CurrentPanelName
						
						KF:CustomPanel_Create(SelectedPanel)
						KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel)
					end,
					disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or (SelectedPanel ~= '0' and not IsModified) or not PanelInfo.Name or PanelInfo.Name == '' end
				},
				Reset = {
					type = 'execute',
					name = function() return (DB.Enable ~= false and DB.Modules.CustomPanel.Enable ~= false and IsModified == true and KF:Color_Value() or '|cff808080')..L['Reset'] end,
					order = 4,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						IsModified = nil
						Message = nil
						
						if SelectedPanel ~= '0' then
							PanelInfo = E:CopyTable({}, Info.CustomPanel_Default)
							
							KF:CustomPanel_Delete(0)
							
							E:CopyTable(PanelInfo, DB.Modules.CustomPanel[SelectedPanel])
							PanelInfo.Name = SelectedPanel
							
							KF:CustomPanel_Create(SelectedPanel, PanelInfo)
							KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel)
						else
							local SavedName = PanelInfo.Name
							PanelInfo = E:CopyTable({}, Info.CustomPanel_Default)
							PanelInfo.Name = SavedName
							
							KF:CustomPanel_Create(0, PanelInfo)
						end
					end,
					disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or not IsModified end
				},
				Delete = {
					type = 'execute',
					name = function() return (DB.Enable ~= false and DB.Modules.CustomPanel.Enable ~= false and SelectedPanel ~= '0' and '|cffff5675' or '|cff808080')..L['Delete'] end,
					order = 5,
					desc = '',
					descStyle = 'inline',
					width = 'half',
					func = function()
						if Message ~= format(L['Are you sure you want to delete this %s?|nIf yes, press the Delete button again.'], KF:Color_Value(SelectedPanel)..' '..L['Panel']) then
							Message = format(L['Are you sure you want to delete this %s?|nIf yes, press the Delete button again.'], KF:Color_Value(SelectedPanel)..' '..L['Panel'])
						else
							DB.Modules.CustomPanel[SelectedPanel] = nil
							
							Message = format(L['%s has been deleted.'], KF:Color_Value(SelectedPanel))
							KF:CustomPanel_Delete(SelectedPanel)
							
							KF:CallbackFire('CustomPanel_Delete', SelectedPanel)
							
							SelectedPanel = ''
							IsModified = nil
						end
					end,
					disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or SelectedPanel == '0' end
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 10
				},
				Enable = {
					type = 'toggle',
					name = function() return ' '..(SelectedPanel ~= '0' and NameColor() or '|cff808080')..L['Enable'] end,
					order = 11,
					desc = '',
					descStyle = 'inline',
					get = function()
						return SelectedPanel == '0' or PanelInfo.Enable
					end,
					set = function(_, value)
						if SelectedPanel ~= '0' then
							Message = nil
							
							if PanelInfo.Enable ~= value then
								IsModified = true
							end
							
							PanelInfo.Enable = value
							
							KF:CustomPanel_Create(SelectedPanel, PanelInfo)
							
							if not value then
								KF:CallbackFire('CustomPanel_Delete', SelectedPanel)
							end
						end
					end
				},
				Space3 = {
					type = 'description',
					name = ' ',
					order = 12,
					width = 'normal'
				},
				Space4 = {
					type = 'description',
					name = ' ',
					order = 13,
					width = 'half'
				},
				HideWhenPetBattle = {
					type = 'toggle',
					name = function() return ' '..(PanelInfo.Enable ~= false and NameColor() or '')..L['Hide when PetBattle'] end,
					order = 14,
					desc = '',
					descStyle = 'inline',
					disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false end
				},
				Space5 = {
					type = 'description',
					name = ' ',
					order = 99
				},
				General = {
					type = 'group',
					name = L['General'],
					order = 100,
					guiInline = true,
					disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false end,
					set = function(info, value)
						Message = nil
						
						if PanelInfo[(info[#info])] ~= value then
							IsModified = true
						end
						
						PanelInfo[(info[#info])] = value
						
						KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
						
						if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
					end,
					args = {
						Width = {
							type = 'range',
							name = function() return ' '..(PanelInfo.Enable ~= false and NameColor() or '')..L['Width'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
							min = 150,
							max = 700,
							step = 1
						},
						Height = {
							type = 'range',
							name = function() return ' '..(PanelInfo.Enable ~= false and NameColor() or '')..L['Height'] end,
							order = 2,
							desc = '',
							descStyle = 'inline',
							min = 150,
							max = 600,
							step = 1
						}
					}
				},
				Space6 = {
					type = 'description',
					name = ' ',
					order = 199
				},
				Backdrop = {
					type = 'group',
					name = L['Backdrop'],
					order = 200,
					guiInline = true,
					get = function(info) return PanelInfo.Texture[(info[#info])] end,
					set = function(info, value)
						Message = nil
						
						if PanelInfo.Texture[(info[#info])] ~= value then
							IsModified = true
						end
						
						PanelInfo.Texture[(info[#info])] = value
						
						KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
					end,
					disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false end,
					args = {
						panelBackdrop = {
							type = 'toggle',
							name = function() return ' '..(PanelInfo.Enable ~= false and NameColor() or '')..L['Panel Backdrop'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
							get = function() return PanelInfo.panelBackdrop end,
							set = function(_, value)
								Message = nil
								
								if PanelInfo.panelBackdrop ~= value then
									IsModified = true
								end
								
								PanelInfo.panelBackdrop = value
								
								KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
							end
						},
						Enable = {
							type = 'toggle',
							name = function() return ' '..(PanelInfo.Enable ~= false and NameColor() or '')..L['Enable Texture'] end,
							order = 2,
							desc = '',
							descStyle = 'inline'
						},
						Alpha = {
							type = 'range',
							name = function() return ' '..(PanelInfo.Enable ~= false and PanelInfo.Texture.Enable ~= false and PanelInfo.Texture.Path ~= '' and NameColor() or '')..L['Texture Alpha'] end,
							order = 3,
							desc = '',
							descStyle = 'inline',
							min = 0,
							max = 100,
							step = 1,
							get = function() return PanelInfo.Texture.Alpha * 100 end,
							set = function(_, value)
								if value > 0 then
									value = value / 100
								end
								
								Message = nil
								
								if PanelInfo.Texture.Alpha ~= value then
									IsModified = true
								end
								
								PanelInfo.Texture.Alpha = value
								
								KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
							end,
							disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false or PanelInfo.Texture.Enable == false or PanelInfo.Texture.Path == '' end
						},
						Path = {
							type = 'input',
							name = function() return ' '..(PanelInfo.Enable ~= false and PanelInfo.Texture.Enable ~= false and NameColor() or '')..L['Texture Path'] end,
							order = 4,
							desc = L['Specify a filename located inside the World of Warcraft directory. Textures folder that you wish to have set as a panel background.\n\nPlease Note:\n-The image size recommended is 256x128\n-You must do a complete game restart after adding a file to the folder.\n-The file type must be tga format.\n\nExample: Interface\\AddOns\\ElvUI\\media\\textures\\copy\n\nOr for most users it would be easier to simply put a tga file into your WoW folder, then type the name of the file here.'],
							width = 'full',
							disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false or PanelInfo.Texture.Enable == false end
						},
					}
				},
				Space7 = {
					type = 'description',
					name = ' ',
					order = 299
				},
				Tab = {
					type = 'group',
					name = L['Panel Tab'],
					order = 300,
					guiInline = true,
					get = function(info) return PanelInfo.Tab[(info[#info])] end,
					set = function(info, value)
						Message = nil
						
						if PanelInfo.Tab[(info[#info])] ~= value then
							IsModified = true
						end
						
						PanelInfo.Tab[(info[#info])] = value
						
						KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
						
						if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
					end,
					disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false or PanelInfo.Tab.Enable == false end,
					args = {
						Enable = {
							type = 'toggle',
							name = function() return ' '..(PanelInfo.Enable ~= false and NameColor() or '')..L['Enable'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
							set = function(info, value)
								Message = nil
								
								if PanelInfo.Tab[(info[#info])] ~= value then
									IsModified = true
								end
								
								PanelInfo.Tab[(info[#info])] = value
								
								KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
								
								if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
							end,
							disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false end
						},
						Transparency = {
							type = 'toggle',
							name = function() return ' '..(PanelInfo.Enable ~= false and PanelInfo.Tab.Enable ~= false and NameColor() or '')..L['Transparency'] end,
							order = 2,
							desc = '',
							descStyle = 'inline'
						},
						ButtonLeft = {
							type = 'group',
							name = function(info)
								for i = 1, #PanelInfo[(info[#info - 1])][(info[#info])] do
									Create_ButtonConfig((info[#info - 1]), (info[#info]), i + 1)
								end
								return (PanelInfo.Enable ~= false and PanelInfo.Tab.Enable ~= false and NameColor('cccccc') or '|cff808080')..L['Left Button']
							end,
							order = 100,
							guiInline = true,
							get = function(info) return PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] or '' end,
							set = function(info, value)
								Message = nil
								
								if PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] ~= value then
									IsModified = true
								end
								
								if value == '' then
									tremove(PanelInfo[(info[#info - 2])][(info[#info - 1])], tonumber((info[#info])))
								else
									PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] = value
									
									if not E.Options.args.KnightFrame.args.CustomPanel.args.ConfigSpace.args[(info[#info - 2])].args[(info[#info - 1])].args[tostring(tonumber((info[#info])) + 1)] then
										Create_ButtonConfig((info[#info - 2]), (info[#info - 1]), tonumber((info[#info])) + 1)
									end
								end
								
								KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
								
								if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
							end,
							hidden = function(info)
								if (info[#info]) == 'ButtonLeft' or (info[#info]) == '1' then
									return false
								else
									return #PanelInfo[(info[#info - 2])][(info[#info - 1])] + 1 < tonumber((info[#info]))
								end
							end,
							args = {
								['1'] = {
									type = 'select',
									name = '',
									order = 1,
									desc = '',
									descStyle = 'inline',
									values = function()
										local list = { [''] = '|cff712633'..L['Disable'], }
										
										for buttonType in pairs(KF.UIParent.Button) do
											if buttonType ~= 'AreaToHide' then
												list[buttonType] = buttonType
											end
										end
										
										return list
									end
								}
							}
						},
						ButtonRight = {
							type = 'group',
							name = function(info)
								for i = 1, #PanelInfo[(info[#info - 1])][(info[#info])] do
									Create_ButtonConfig((info[#info - 1]), (info[#info]), i + 1)
								end
								return (PanelInfo.Enable ~= false and PanelInfo.Tab.Enable ~= false and NameColor('cccccc') or '|cff808080')..L['Right Button']
							end,
							order = 200,
							guiInline = true,
							get = function(info) return PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] or '' end,
							set = function(info, value)
								Message = nil
								
								if PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] ~= value then
									IsModified = true
								end
								
								if value == '' then
									tremove(PanelInfo[(info[#info - 2])][(info[#info - 1])], tonumber((info[#info])))
								else
									PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] = value
									
									if not KF_Config.Options.args.CustomPanel.args.ConfigSpace.args[(info[#info - 2])].args[(info[#info - 1])].args[tostring(tonumber((info[#info])) + 1)] then
										Create_ButtonConfig((info[#info - 2]), (info[#info - 1]), tonumber((info[#info])) + 1)
									end
								end
								
								KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
								
								if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
							end,
							hidden = function(info)
								if (info[#info]) == 'ButtonRight' or (info[#info]) == '1' then
									return false
								else
									return #PanelInfo[(info[#info - 2])][(info[#info - 1])] + 1 < tonumber((info[#info]))
								end
							end,
							args = {
								['1'] = {
									type = 'select',
									name = '',
									order = 1,
									desc = '',
									descStyle = 'inline',
									values = function()
										local list = { [''] = '|cff712633'..L['Disable'], }
										
										for buttonType in pairs(KF.UIParent.Button) do
											if buttonType ~= 'AreaToHide' then
												list[buttonType] = buttonType
											end
										end
										
										return list
									end
								}
							}
						},
					},
				},
				Space8 = {
					type = 'description',
					name = ' ',
					order = 399
				},
				DP = {
					type = 'group',
					name = L['Data Panel'],
					order = 400,
					guiInline = true,
					get = function(info) return PanelInfo.DP[(info[#info])] end,
					set = function(info, value)
						Message = nil
						
						if PanelInfo.DP[(info[#info])] ~= value then
							IsModified = true
						end
						
						PanelInfo.DP[(info[#info])] = value
						
						KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
						
						if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
					end,
					disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false or PanelInfo.DP.Enable == false end,
					args = {
						Enable = {
							type = 'toggle',
							name = function() return ' '..(PanelInfo.Enable ~= false and NameColor() or '')..L['Enable'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
							set = function(info, value)
								Message = nil
								
								if PanelInfo.DP[(info[#info])] ~= value then
									IsModified = true
								end
								
								PanelInfo.DP[(info[#info])] = value
								
								KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
								
								if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
							end,
							disabled = function() return DB.Enable == false or DB.Modules.CustomPanel.Enable == false or PanelInfo.Enable == false end
						},
						Transparency = {
							type = 'toggle',
							name = function() return ' '..(PanelInfo.Enable ~= false and PanelInfo.DP.Enable ~= false and NameColor() or '')..L['Transparency'] end,
							order = 2,
							desc = '',
							descStyle = 'inline'
						},
						ButtonLeft = {
							type = 'group',
							name = function(info)
								for i = 1, #PanelInfo[(info[#info - 1])][(info[#info])] do
									Create_ButtonConfig((info[#info - 1]), (info[#info]), i + 1)
								end
								return (PanelInfo.Enable ~= false and PanelInfo.DP.Enable ~= false and NameColor('cccccc') or '|cff808080')..L['Left Button']
							end,
							order = 100,
							guiInline = true,
							get = function(info) return PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] or '' end,
							set = function(info, value)
								Message = nil
								
								if PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] ~= value then
									IsModified = true
								end
								
								if value == '' then
									tremove(PanelInfo[(info[#info - 2])][(info[#info - 1])], tonumber((info[#info])))
								else
									PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] = value
									
									if not KF_Config.Options.args.CustomPanel.args.ConfigSpace.args[(info[#info - 2])].args[(info[#info - 1])].args[tostring(tonumber((info[#info])) + 1)] then
										Create_ButtonConfig((info[#info - 2]), (info[#info - 1]), tonumber((info[#info])) + 1)
									end
								end
								
								KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
								
								if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
							end,
							hidden = function(info)
								if (info[#info]) == 'ButtonLeft' or (info[#info]) == '1' then
									return false
								else
									return #PanelInfo[(info[#info - 2])][(info[#info - 1])] + 1 < tonumber((info[#info]))
								end
							end,
							args = {
								['1'] = {
									type = 'select',
									name = '',
									order = 1,
									desc = '',
									descStyle = 'inline',
									values = function()
										local list = { [''] = '|cff712633'..L['Disable'], }
										
										for buttonType in pairs(KF.UIParent.Button) do
											if buttonType ~= 'AreaToHide' then
												list[buttonType] = buttonType
											end
										end
										
										return list
									end
								}
							}
						},
						ButtonRight = {
							type = 'group',
							name = function(info)
								for i = 1, #PanelInfo[(info[#info - 1])][(info[#info])] do
									Create_ButtonConfig((info[#info - 1]), (info[#info]), i + 1)
								end
								return (PanelInfo.Enable ~= false and PanelInfo.DP.Enable ~= false and NameColor('cccccc') or '|cff808080')..L['Right Button']
							end,
							order = 200,
							guiInline = true,
							get = function(info) return PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] or '' end,
							set = function(info, value)
								Message = nil
								
								if PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] ~= value then
									IsModified = true
								end
								
								if value == '' then
									tremove(PanelInfo[(info[#info - 2])][(info[#info - 1])], tonumber((info[#info])))
								else
									PanelInfo[(info[#info - 2])][(info[#info - 1])][tonumber((info[#info]))] = value
									
									if not KF_Config.Options.args.CustomPanel.args.ConfigSpace.args[(info[#info - 2])].args[(info[#info - 1])].args[tostring(tonumber((info[#info])) + 1)] then
										Create_ButtonConfig((info[#info - 2]), (info[#info - 1]), tonumber((info[#info])) + 1)
									end
								end
								
								KF:CustomPanel_Create(SelectedPanel == '0' and 0 or SelectedPanel, PanelInfo)
								
								if SelectedPanel ~= '0' then KF:CallbackFire('CustomPanel_PanelSettingChanged', SelectedPanel) end
							end,
							hidden = function(info)
								if (info[#info]) == 'ButtonRight' or (info[#info]) == '1' then
									return false
								else
									return #PanelInfo[(info[#info - 2])][(info[#info - 1])] + 1 < tonumber((info[#info]))
								end
							end,
							args = {
								['1'] = {
									type = 'select',
									name = '',
									order = 1,
									desc = '',
									descStyle = 'inline',
									values = function()
										local list = { [''] = '|cff712633'..L['Disable'], }
										
										for buttonType in pairs(KF.UIParent.Button) do
											if buttonType ~= 'AreaToHide' then
												list[buttonType] = buttonType
											end
										end
										
										return list
									end
								}
							}
						},
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
	hidden = function() return KF_Config.ReadyToRunKF == false end,
}