local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2013. 9. 24
-- Last Code Checking Version	: 2.2_04
-- Last Testing ElvUI Version	: 6.53

if not KF or not KF_Config then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Extra Function OptionTable								>>--
--------------------------------------------------------------------------------
local function NameColor(Color)
	return KF.db.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
end


KF_Config.Options.args.Extra_Functions = {
	type = 'group',
	name = function() return '|cffffffff4. '..KF:Color_Value(L['Extra Functions']) end,
	order = 400,
	childGroups = 'select',
	hidden = function() return KF_Config.ReadyToRunKF == false end,
	args = {
		Misc = {
			type = 'group',
			name = function() return KF:Color_Value('>>')..' |cffffffff'..L['Extra Functions']..KF:Color_Value(' <<') end,
			order = 999,
			guiInline = true,
			disabled = function() return KF.db.Enable == false end,
			args = {
				LocalizedTimeFormat = {
					type = 'toggle',
					name = function() return ' '..NameColor()..L['TimeFormat'] end,
					order = 1,
					desc = '',
					descStyle = 'inline',
					get = function() return KF.db.Extra_Functions.LocalizedTimeFormat end,
					set = function(_, value)
						KF.db.Extra_Functions.LocalizedTimeFormat = value
						
						KF.InitializeFunction['Extra_Functions']['LocalizedTimeFormats'](not value)
					end,
					hidden = function() return not L['KF_LocalizedTimeFormat'] end,
				},
				ArmoryMode = {
					type = 'toggle',
					name = function() return ' '..NameColor()..L['Armory Mode'] end,
					order = 2,
					desc = L['Adds additional information to your character panel.'],
					get = function() return KF.db.Extra_Functions.ArmoryMode.Enable end,
					set = function(_, value)
						KF.db.Extra_Functions.ArmoryMode.Enable = value
						
						KF.InitializeFunction['Extra_Functions']['ArmoryMode'](not value)
					end,
				},
				FullValues = {
					type = 'toggle',
					name = function() return ' '..NameColor()..L['Full Values'] end,
					order = 3,
					desc = '',
					descStyle = 'inline',
					get = function() return KF.db.Extra_Functions.FullValues end,
					set = function(_, value)
						KF.db.Extra_Functions.FullValues = value
						
						E:GetModule('UnitFrames'):Update_AllFrames()
					end,
				},
				--[[
				TooltipTalent = {
					type = 'toggle',
					name = function() return ' '..NameColor()..L['Tooltip Talent'] end,
					order = 4,
					desc = '',
					descStyle = 'inline',
					get = function() return KF.db.Extra_Functions.TooltipTalent end,
					set = function(_, value)
						KF.db.Extra_Functions.TooltipTalent = value
					end,
				},
				]]
				ShowChatTab = {
					type = 'toggle',
					name = function() return ' '..NameColor()..L['Show Chat Tab'] end,
					order = 5,
					desc = '',
					descStyle = 'inline',
					get = function() return KF.db.Extra_Functions.ShowChatTab end,
					set = function(_, value)
						KF.db.Extra_Functions.ShowChatTab = value
						
						E:StaticPopup_Show('CONFIG_RL')
					end,
				},
				ToggleWatchFrame = {
					type = 'toggle',
					name = function() return ' '..NameColor()..L['Toggle WatchFrame'] end,
					order = 6,
					desc = '',
					descStyle = 'inline',
					get = function() return KF.db.Extra_Functions.ToggleWatchFrame end,
					set = function(_, value)
						KF.db.Extra_Functions.ToggleWatchFrame = value
						
						KF.InitializeFunction['Extra_Functions']['ToggleWatchFrame'](not value)
					end,
				},
			},
		},
		CreditSpace = {
			type = 'description',
			name = ' ',
			order = 998,
		},
		Credit = {
			type = 'header',
			name = KF_Config.Credit,
			order = 999,
		},
	},
}