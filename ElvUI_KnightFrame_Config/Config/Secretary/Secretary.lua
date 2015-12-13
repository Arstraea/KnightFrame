local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (KF and KF.Modules and KF.Modules.Secretary and KF_Config) then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Secretary OptionTable									>>--
--------------------------------------------------------------------------------
local SC = KnightFrame_Secretary


local function Color(TrueColor, FalseColor)
	return KF.db.Enable ~= false and KF.db.Modules.Secretary.Enable ~= false and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
end

local function Alarm_Color(TrueColor, FalseColor)
	return KF.db.Enable ~= false and KF.db.Modules.Secretary.Enable ~= false and KF.db.Modules.Secretary.Alarm.Enable ~= false and (TrueColor == '' and '' or TrueColor and '|c'..TrueColor or KF:Color_Value()) or FalseColor and '|c'..FalseColor or ''
end



KF_Config.OptionsCategoryCount = KF_Config.OptionsCategoryCount + 1
local OptionIndex = KF_Config.OptionsCategoryCount
KF_Config.Options.args.Secretary = {
	type = 'group',
	name = function() return '|cffffffff'..OptionIndex..'. '..KF:Color_Value(L['Secretary']) end,
	order = 100 + OptionIndex,
	disabled = function() return KF.db.Enable == false end,
	childGroups = 'tab',
	args = {
		Enable = {
			type = 'toggle',
			name = function() return ' '..(KF.db.Enable ~= false and '|cffffffff' or '')..L['Enable']..' : '..(KF.db.Enable ~= false and KF:Color_Value() or '')..L['Secretary'] end,
			order = 1,
			desc = '',
			descStyle = 'inline',
			get = function() return KF.db.Modules.Secretary.Enable end,
			set = function(_, value)
				KF.db.Modules.Secretary.Enable = value
				
				KF.Modules.Secretary()
			end,
			width = 'full',
		},
		Alarm = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['Alarm'] end,
			order = 100,
			get = function(info) return KF.db.Modules.Secretary.Alarm[(info[#info - 1])][(info[#info])] end,
			set = function(info, value)
				KF.db.Modules.Secretary.Alarm[(info[#info - 1])][(info[#info])] = value
			end,
			args = {
				Space = {
					type = 'description',
					name = ' ',
					order = 1
				},
				Enable = {
					type = 'toggle',
					name = function() return ' '..Color('ffffffff', 'ff787878')..L['Enable']..' : '..Color(nil, 'ff787878')..L['Alarm'] end,
					order = 2,
					desc = function()
						return Color('ffcccccc', 'ff787878')..L['This function will notice you when specific events was happened.']
					end,
					descStyle = 'inline',
					get = function() return KF.db.Modules.Secretary.Alarm.Enable end,
					set = function(_, value)
						KF.db.Modules.Secretary.Alarm.Enable = value
						
						KF.Modules.Secretary()
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.Secretary.Enable == false end,
					width = 'full'
				},
				Space1 = {
					type = 'description',
					name = ' ',
					order = 3
				},
				AlarmMethod = {
					type = 'group',
					name = function() return Alarm_Color('ffffffff', 'ff787878')..L['Alarm Method'] end,
					order = 4,
					guiInline = true,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.Secretary.Enable == false or KF.db.Modules.Secretary.Alarm.Enable == false end,
					args = {
						Blink = {
							type = 'toggle',
							name = function() return ' '..Alarm_Color(nil, 'ff787878')..L['Blink Client'] end,
							order = 1,
							desc = function()
								return Alarm_Color('ffcccccc', 'ff787878')..L['Blink wow client in system tray when you minimized and event happen.']
							end,
							descStyle = 'inline',
							width = 'full'
						},
						Sound = {
							type = 'toggle',
							name = function() return ' '..Alarm_Color(nil, 'ff787878')..L['TurnOn Sound'] end,
							order = 2,
							desc = function()
								return Alarm_Color('ffcccccc', 'ff787878')..L["Turn on sounds when you turn off wow's sound and event happen."]
							end,
							descStyle = 'inline',
							width = 'full'
						}
					}
				},
				Space2 = {
					type = 'description',
					name = ' ',
					order = 5
				},
				Event = {
					type = 'group',
					name = function() return Alarm_Color('ffffffff', 'ff787878')..L['Event to Alarm'] end,
					order = 6,
					guiInline = true,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.Secretary.Enable == false or KF.db.Modules.Secretary.Alarm.Enable == false end,
					args = {
						ContentsQueue = {
							type = 'toggle',
							name = function() return ' '..Alarm_Color(nil, 'ff787878')..L['Contents Queue'] end,
							order = 1,
							desc = '',
							descStyle = 'inline',
							set = function(info, value)
								KF.db.Modules.Secretary.Alarm.Event.ContentsQueue = value
								
								if KF.db.Modules.Secretary.Alarm.Event.ContentsQueue then
									SC:RegisterEvent('LFG_PROPOSAL_SHOW')
									SC:RegisterEvent('LFG_PROPOSAL_SUCCEEDED')
									SC:RegisterEvent('LFG_PROPOSAL_FAILED')
									SC:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
									KF:RegisterEventList('LFG_ROLE_CHECK_SHOW', SC.Alarm_PopupSetting, 'Alarm_Initialize')
								else
									SC:UnregisterEvent('LFG_PROPOSAL_SHOW')
									SC:UnregisterEvent('LFG_PROPOSAL_SUCCEEDED')
									SC:UnregisterEvent('LFG_PROPOSAL_FAILED')
									SC:UnregisterEvent('UPDATE_BATTLEFIELD_STATUS')
									KF:UnregisterEventList('LFG_ROLE_CHECK_SHOW', 'Alarm_Initialize')
								end
							end
						},
						ReadyCheck = {
							type = 'toggle',
							name = function() return ' '..Alarm_Color(nil, 'ff787878')..READY_CHECK end,
							order = 2,
							desc = '',
							descStyle = 'inline',
							set = function(_, value)
								KF.db.Modules.Secretary.Alarm.Event.ReadyCheck = value
								
								if KF.db.Modules.Secretary.Alarm.Event.ReadyCheck then
									SC:RegisterEvent('READY_CHECK')
									SC:RegisterEvent('READY_CHECK_CONFIRM')
									SC:RegisterEvent('READY_CHECK_FINISHED')
								else
									SC:UnregisterEvent('READY_CHECK')
									SC:UnregisterEvent('READY_CHECK_CONFIRM')
									SC:UnregisterEvent('READY_CHECK_FINISHED')
								end
							end
						},
						Summon = {
							type = 'toggle',
							name = function() return ' '..Alarm_Color(nil, 'ff787878')..SUMMON end,
							order = 3,
							desc = '',
							descStyle = 'inline',
							set = function(_, value)
								KF.db.Modules.Secretary.Alarm.Event.Summon = value
								
								if KF.db.Modules.Secretary.Alarm.Event.Summon then
									SC:RegisterEvent('CONFIRM_SUMMON')
									SC:RegisterEvent('CANCEL_SUMMON')
								else
									SC:UnregisterEvent('CONFIRM_SUMMON')
									SC:UnregisterEvent('CANCEL_SUMMON')
								end
							end
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
		ToggleObjectiveFrame = {
			type = 'group',
			name = function() return Color('', 'ff787878')..L['ToggleObjectiveFrame'] end,
			order = 200,
			get = function(info) return KF.db.Modules.Secretary.ToggleObjectiveFrame[(info[#info - 1])][(info[#info])] end,
			set = function(info, value)
				KF.db.Modules.Secretary.ToggleObjectiveFrame[(info[#info - 1])][(info[#info])] = value
			end,
			args = {
				Space = {
					type = 'description',
					name = ' ',
					order = 1
				},
				Enable = {
					type = 'toggle',
					name = function() return ' '..Color('ffffffff', 'ff787878')..L['Enable']..' : '..Color(nil, 'ff787878')..L['ToggleObjectiveFrame'] end,
					order = 2,
					desc = function()
						return Color('ffcccccc', 'ff787878')..L['This function will toggle objective frame automatically in specific situation.']
					end,
					descStyle = 'inline',
					get = function() return KF.db.Modules.Secretary.ToggleObjectiveFrame.Enable end,
					set = function(_, value)
						KF.db.Modules.Secretary.ToggleObjectiveFrame.Enable = value
						
						KF.Modules.Secretary()
					end,
					disabled = function() return KF.db.Enable == false or KF.db.Modules.Secretary.Enable == false end,
					width = 'full'
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