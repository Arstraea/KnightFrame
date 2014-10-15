﻿local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if KF.Modules.SwitchEquipment then
	local function GetEquipmentSetIndex(EquipmentSetName)
		for i = 1, GetNumEquipmentSets() do
			if GetEquipmentSetInfo(i) == EquipmentSetName then
				return i
			end
		end
		
		return nil
	end


	local EquipmentSetTable = {}
	local function SettingTable_EquipmentSet()
		EquipmentSetTable = { [''] = '|cff712633'..L['Disable'] }
		
		local name, missing
		for i = 1, GetNumEquipmentSets() do
			name, _, _, _, _, _, _, missing = GetEquipmentSetInfo(i)
			EquipmentSetTable[tostring(i)] = (missing > 0 and '|cffff0000' or '')..name
		end
	end


	local function NameColor(Color)
		return DB.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
	end


	KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
	local OptionIndex = KF_Config.OptionsCategoryCount
	KF_Config.Options.args.SwitchEquipment = {
		type = 'group',
		name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Switch Equipment']) end,
		order = 700,
		args = {
			Enable = {
				type = 'toggle',
				name = function() return ' '..NameColor()..L['Enable'] end,
				order = 1,
				desc = '',
				descStyle = 'inline',
				get = function(info) return E.private.KnightFrame.SwitchEquipment.Enable end,
				set = function(_, value)
					E.private.KnightFrame.SwitchEquipment.Enable = value
					
					--KF.SwitchEquipment_ignoreOnEvent = nil
					KF.Modules.SwitchEquipment(not value)
				end,
				disabled = function() return DB.Enable == false end
			},
			Description = {
				type = 'description',
				name = L['Change equipment set when changing specialization or entering a pvp area(battleground or arena).'],
				order = 2,
				width = 'double'
			},
			ConfigSpace = {
				type = 'group',
				name = function()
					SettingTable_EquipmentSet()
					
					return ' '
				end,
				order = 100,
				guiInline = true,
				get = function(info)
					local value = E.private.KnightFrame.SwitchEquipment[info[#info]]
					local index = GetEquipmentSetIndex(value)
					
					if index then
						return tostring(index)
					elseif value ~= '' then
						print(L['KF']..' : '..format(L['There is no equipment set named %s in %s option.'], '|cff712633'..value..'|r', KF:Color_Value(info[#info]))..' '..L['Please check and set again.'])
						E.private.KnightFrame.SwitchEquipment[info[#info]] = ''
					end
					
					return ''
				end,
				set = function(info, value)
					if value == '' then
						E.private.KnightFrame.SwitchEquipment[info[#info]] = value
					else
						value = EquipmentSetTable[value]
						
						if GetEquipmentSetInfoByName(value) then
							E.private.KnightFrame.SwitchEquipment[info[#info]] = value
						else
							print(L['KF']..' : '..format(L['There is no equipment set named %s.'], '|cff712633'..value..'|r')..' '..L['Please check and set again.'])
						end
					end
				end,
				hidden = function() return DB.Enable == false or E.private.KnightFrame.SwitchEquipment.Enable == false end,
				args = {
					Primary = {
						type = 'select',
						name = function()
							local Spec = GetSpecialization(false, false, 1)
							local SpecRole
							
							if Spec then
								_, Spec, _, _, _, SpecRole = GetSpecializationInfo(Spec)
							end
							
							return ' '..(E.private.KnightFrame.SwitchEquipment.Enable ~= false and NameColor()..L['Primary']..':|r '..(DB.Enable ~= false and E.private.KnightFrame.SwitchEquipment.Enable ~= false and Spec and Info.ClassRole[E.myclass][Spec] and Info.ClassRole[E.myclass][Spec].Color or '') or L['Primary']..':|r ')..(Spec and Spec..(SpecRole == 'TANK' and ' |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\tank:13:13:1:0|t ' or SpecRole == 'HEALER' and ' |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\healer:13:13:1:0|t ' or ' |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\dps:13:13:1:0|t') or L['No Spec'])
						end,
						order = 1,
						desc = '',
						descStyle = 'inline',
						values = function() return EquipmentSetTable end,
					},
					Secondary = {
						type = 'select',
						name = function()
							local Spec = GetSpecialization(false, false, 2)
							local SpecRole
							
							if Spec then
								_, Spec, _, _, _, SpecRole = GetSpecializationInfo(Spec)
							end
							
							return ' '..(E.private.KnightFrame.SwitchEquipment.Enable ~= false and NameColor()..L['Secondary']..':|r '..(DB.Enable ~= false and E.private.KnightFrame.SwitchEquipment.Enable ~= false and Spec and Info.ClassRole[E.myclass][Spec] and Info.ClassRole[E.myclass][Spec].Color or '') or L['Secondary']..':|r ')..(Spec and Spec..(SpecRole == 'TANK' and ' |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\tank:13:13:1:0|t ' or SpecRole == 'HEALER' and ' |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\healer:13:13:1:0|t ' or ' |TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\dps:13:13:1:0|t') or L['No Spec'])
						end,
						order = 2,
						desc = '',
						descStyle = 'inline',
						values = function() return EquipmentSetTable end
					},
					PvP = {
						type = 'select',
						name = function()
							return ' '..(E.private.KnightFrame.SwitchEquipment.Enable ~= false and NameColor() or '')..L['PvP Area']
						end,
						order = 3,
						desc = '',
						descStyle = 'inline',
						values = function() return EquipmentSetTable end
					}
				}
			}
		}
	}
end