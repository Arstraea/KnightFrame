local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

if not (E.private.install_complete and E.db.KnightFrame and E.db.KnightFrame.Install_Complete) then
	KF_Config.ReadyToRunKF = false
else
	KF_Config.ReadyToRunKF = true
end


KF_Config.OptionsCategoryCount = 0
KF_Config.Options = {
	type = 'group',
	name = function() return KF:Color_Value('Knight Frame') end,
	order = -1,
	desc = '',
	childGroups = 'tree',
	args = {
		Header = {
			type = 'header',
			name = function() return KF:Color_Value('[')..' |cffffffffElv UI - '..L['KF']..KF:Color_Value(' ]') end,
			order = 1
		},
		KnightFrameLogo = {
			type = 'description',
			name = '',
			order = 2,
			image = function() return 'Interface\\AddOns\\ElvUI_KnightFrame_Config\\Media\\Graphics\\Config_KnightFrame.tga', 1024, 256 end
		},
		Space = {
			type = 'description',
			name = '',
			order = 3,
			width = 'normal',
			hidden = function() return KF_Config.ReadyToRunKF == false end
		},
		Space2 = {
			type = 'description',
			name = '',
			order = 4,
			width = 'half',
			hidden = function() return KF_Config.ReadyToRunKF == false end
		},
		Enable = {
			type = 'toggle',
			name = function() return ' '..L['KF']..' |cffffffff'..L['Enable'] end,
			order = 5,
			desc = '|cffffdc3c(|cffffffff'..L['Installed']..' : |cffceff00'..Info.Version..'|cffffdc3c)|n ',
			descStyle = 'inline',
			get = function()
				if E.db.KnightFrame and E.db.KnightFrame.Install_Complete then
					return KF.db.Enable
				else
					return E.db.KnightFrame.Enable
				end
			end,
			set = function(_, value)
				if E.db.KnightFrame and E.db.KnightFrame.Install_Complete then
					KF.db.Enable = value
				else
					E.db.KnightFrame.Enable = value
				end
				
				E:StaticPopup_Show('CONFIG_RL')
			end,
			hidden = function() return KF_Config.ReadyToRunKF == false end
		},
		Install = {
			type = 'execute',
			name = function() return '|cffffffff> '..KF:Color_Value(L['Install KnightFrame'])..' |cffffffff< ' end,
			order = 6,
			--desc = L["Re-Install profile to reset |cff1784d1KnightFrame|r options."],
			func = function() KF:Install() E:ToggleConfig() end,
			width = 'full',
			hidden = function() return KF_Config.ReadyToRunKF end
		},
		Space3 = {
			type = 'description',
			name = ' ',
			order = 7,
			hidden = function() return KF_Config.ReadyToRunKF == false end,
		},
		ReInstall = {
			type = 'execute',
			name = function() return '|cffffffff> '..KF:Color_Value(L['Re-Install KnightFrame'])..' |cffffffff< ' end,
			order = 8,
			desc = L["Re-Install profile to reset |cff1784d1KnightFrame|r options."],
			func = function() KF:Install() E:ToggleConfig() end,
			width = 'full',
			hidden = function() return KF_Config.ReadyToRunKF == false end
		},
		CheckPatchNote = {
			type = 'execute',
			name = function() return '|cffffffff> '..KF:Color_Value(L['Check PatchNote'])..' |cffffffff< ' end,
			order = 9,
			desc = '',
			descStyle = 'inline',
			func = function() end,
			width = 'full',
			disabled = true,
			hidden = function() return KF_Config.ReadyToRunKF == false end
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
--[[

if IsAddOnLoaded('ElvUI_AddOnSkins') then
	KF_Config.SkinDisabled = true
end

--<< UI Customize & Skins Options >>--
KF_Config.Options.args.UICustomize_Skins = {
	type = 'group',
	name = function() return '|cffffffff3. '..KF:Color_Value('전투 정보실') end,
	order = 300,
	childGroups = 'select',
	hidden = function() return KF_Config.ReadyToRunKF == false end,
	args = {
		Skins = {
			type = 'group',
			name = '|cff1784d1>>|r |cffffffff'..L['Skins']..' |cff1784d1<<',
			order = 101,
			guiInline = true,
			get = function(info) return KF.db.Skins[(info[#info])] and IsAddOnLoaded(info[#info]) end,
			set = function(info, value) KF.db.Skins[(info[#info])] = value E:StaticPopup_Show('PRIVATE_RL') end,
			disabled = function(info) return KF.db.Enable == false or KF_Config.SkinDisabled or not IsAddOnLoaded(info[#info]) end,
			args = {
				Enable = {
					type = 'toggle',
					name = function() return ' |cff'..(KF.db.Enable ~= false and not KF_Config.SkinDisabled and '2eb7e4' or '838383')..L['Enable'] end,
					order = 1,
					desc = '',
					descStyle = 'inline',
					get = function()
						if KF_Config.SkinDisabled then
							return false
						else
							return KF.db.Skins.Enable
						end
					end,
					disabled = function()
						return KF.db.Enable == false or KF_Config.SkinDisabled
					end,
				},
				Description = {
					type = 'description',
					name = L['If you using the ElvUI_AddOnSkins addon, this functions will be disabled.'],
					order = 2,
					width = 'double',
					hidden = function() if not KF_Config.SkinDisabled then return true end end,
				},
				Space = {
					type = 'description',
					name = ' ',
					order = 3,
				},
				['ACP'] = {
					type = 'toggle',
					name = function(info) return ' |cff'..(KF.db.Enable ~= false and not KF_Config.SkinDisabled and IsAddOnLoaded(info[#info]) and '2eb7e4' or '838383')..'ACP' end,
					order = 10,
				},
				['DBM-Core'] = {
					type = 'toggle',
					name = function(info) return ' |cff'..(KF.db.Enable ~= false and not KF_Config.SkinDisabled and IsAddOnLoaded(info[#info]) and '2eb7e4' or '838383')..'DBM' end,
					order = 11,
				},
				['Skada'] = {
					type = 'toggle',
					name = function(info) return ' |cff'..(KF.db.Enable ~= false and not KF_Config.SkinDisabled and IsAddOnLoaded(info[#info]) and '2eb7e4' or '838383')..'Skada' end,
					order = 12,
				},
				['Omen'] = {
					type = 'toggle',
					name = function(info) return ' |cff'..(KF.db.Enable ~= false and not KF_Config.SkinDisabled and IsAddOnLoaded(info[#info]) and '2eb7e4' or '838383')..'Omen' end,
					order = 13,
				},
				['Recount'] = {
					type = 'toggle',
					name = function(info) return ' |cff'..(KF.db.Enable ~= false and not KF_Config.SkinDisabled and IsAddOnLoaded(info[#info]) and '2eb7e4' or '838383')..'Recount' end,
					order = 14,
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
}]]