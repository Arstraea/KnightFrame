local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.SmartTracker = {
	Enable = true,
	
	General = {
		DetailSpellTooltip = false,
		EraseWhenUserLeftGroup = true,
	},
	
	Scan = {
		AutoScanning = true,
		UpdateInspectCache = true,
		ScanWhenReadyCheck = true
	},
	
	SortOrder = {
		Role = {
			'Tank',
			'Healer',
			'Melee',
			'Caster'
		},
		Class = {
			'WARRIOR',
			'HUNTER',
			'SHAMAN',
			'MONK',
			'ROGUE',
			'DEATHKNIGHT',
			'MAGE',
			'DRUID',
			'PALADIN',
			'PRIEST',
			'WARLOCK'
		},
	},
	
	ClassColor = {
		WARRIOR = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		},
		HUNTER = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		},
		SHAMAN = {
			{ .44, .69, 1 }, { .45, .38, 1 }
		},
		MONK = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		},
		ROGUE = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		},
		DEATHKNIGHT = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		},
		MAGE = {
			{ .28, .57, 1 }, { 0, .38, .82 }
		},
		DRUID = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		},
		PALADIN = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		},
		PRIEST = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		},
		WARLOCK = {
			{ .44, .69, 1 }, { 0, .38, .82 }
		}
	},
	
	Window = {
		[(L['SmartTracker_MainWindow'])] = {
			Enable = true,
			
			Appearance = {
				Location = 'TOPLEFTElvUIParentTOPLEFT11-220',
				
				Area_Width = 360,
				Area_Height = 394,
				Area_Show = true,
				
				Bar_Direction = 'DOWN',
				Bar_Height = 16,
				Bar_FontSize = 10,
				
				Count_TargetUser = 3,
				
				Color_WindowTab = { 1, 1, 1 },
				Color_BehindBar = { 1, 1, 1, 0.2 },
				Color_Charged1 = { .38, .82, 1 },
				Color_Charged2 = { 0, .38, .82 }
			},
			
			Display = {
				Situation = {
					Solo = false,
					Group = true,
				},
				
				Location = {
					Field = false,
					Instance = true,
					RaidDungeon = true,
					PvPGround = true
				},
				
				AmICondition = {
					Tank = true,
					Healer = true,
					Caster = true,
					Melee = true,
					GroupLeader = true
				},
				
				Filter = {
					Tank = true,
					Healer = true,
					Caster = true,
					Melee = true
				}
			},
			
			SpellList = {
				WARRIOR = {
					[97462] = true,
					[114192] = true,
					[114029] = true,
					[12975] = true,
					[871] = true,
					[114030] = true,
					[1160] = true,
					[55694] = true
				},
				HUNTER = {
					[5384] = true,
					[172106] = true
				},
				SHAMAN = {
					[152256] = true,
					[98008] = true,
					[108280] = true
				},
				MONK = {
					[115203] = true,
					[115176] = true,
					[115295] = true,
					[115080] = true,
					[116849] = true,
					[115310] = true
				},
				ROGUE = {
					[76577] = true
				},
				DEATHKNIGHT = {
					[49028] = true,
					[108199] = true,
					[55233] = true,
					[51052] = true,
					[48792] = true
				},
				MAGE = {
					[159916] = true
				},
				DRUID = {
					[740] = true,
					[77764] = true,
					[102342] = true,
					[62606] = true,
					[61336] = true,
					[22812] = true
				},
				PALADIN = {
					[1022] = true,
					[31850] = true,
					[114039] = true,
					[31821] = true,
					[498] = true,
					[642] = true,
					[86659] = true,
					[633] = true,
					[6940] = true
				},
				PRIEST = {
					[47788] = true,
					[62618] = true,
					[33206] = true,
					[15286] = true,
					[64843] = true
				},
				WARLOCK = {
					
				}
			}
		}
	},
	
	Icon = {
		
	}
}


Info.SmartTracker_Default_Window = {
	Enable = true,
	
	Appearance = {
		Area_Width = 395,
		Area_Height = 277,
		Area_Show = true,
		
		Bar_Direction = 'DOWN',
		Bar_Height = 16,
		Bar_FontSize = 10,
		
		Count_TargetUser = 3,
		
		Color_WindowTab = { 1, 1, 1 },
		Color_BehindBar = { 1, 1, 1, 0.2 },
		Color_Charged1 = { .38, .82, 1 },
		Color_Charged2 = { 0, .38, .82 }
	},
	
	Display = {
		Situation = {
			Solo = false,
			Group = true,
		},
		
		Location = {
			Field = false,
			Instance = true,
			RaidDungeon = true,
			PvPGround = true
		},
		
		AmICondition = {
			Tank = true,
			Healer = true,
			Caster = true,
			Melee = true,
			GroupLeader = true
		},
		
		Filter = {
			Tanker = true,
			Healer = true,
			Caster = true,
			Melee = true
		}
	},
	
	SpellList = {
		WARRIOR = {},
		HUNTER = {},
		SHAMAN = {},
		MONK = {},
		ROGUE = {},
		DEATHKNIGHT = {},
		MAGE = {},
		DRUID = {},
		PALADIN = {},
		PRIEST = {},
		WARLOCK = {}
	}
}


Info.SmartTracker_Default_Icon = {
	Enable = true,
	ShowBattleResurrectionIcon = false,
	
	Appearance = {
		Icon_Width = 35,
		Icon_Height = 35,
		Spacing = 5,
		FontSize = 10,
		DisplayMax = true,
		
		Orientation = 'Horizontal',	-- Horizontal, Vertical
		Arrangement = 'Center'		-- Left to Right, Right to Left, Center, Top To Bottom, Bottom To Top
	},
	
	Display = {
		Situation = {
			Solo = false,
			Group = true,
		},
		
		Location = {
			Field = false,
			Instance = true,
			RaidDungeon = true,
			PvPGround = true
		},
		
		AmICondition = {
			Tank = true,
			Healer = true,
			Caster = true,
			Melee = true,
			GroupLeader = true
		}
	},
	
	SpellList = {},
}


KF.DBFunction.SmartTracker = {
	Load = function(TableToSave, TableToLoad)
		if TableToLoad.Modules and TableToLoad.Modules.SmartTracker then
			if type(TableToLoad.Modules.SmartTracker.Window) == 'table' then
				for WindowName, IsWindowData in pairs(TableToLoad.Modules.SmartTracker.Window) do
					if type(IsWindowData) == 'table' and not TableToSave.Modules.SmartTracker.Window[WindowName] then
						TableToSave.Modules.SmartTracker.Window[WindowName] = E:CopyTable({}, Info.SmartTracker_Default_Window)
					end
				end
			end
			
			if type(TableToLoad.Modules.SmartTracker.Icon) == 'table' then
				for IconName, IsIconData in pairs(TableToLoad.Modules.SmartTracker.Icon) do
					if type(IsIconData) == 'table' and not TableToSave.Modules.SmartTracker.Icon[IconName] then
						TableToSave.Modules.SmartTracker.Icon[IconName] = E:CopyTable({}, Info.SmartTracker_Default_Icon)
					end
				end
			end
		end
	end,
	Save = function()
		for WindowName, IsWindowData in pairs(KF.db.Modules.SmartTracker.Window) do
			if type(IsWindowData) == 'table' then
				KF:CompareTable(IsWindowData, Info.SmartTracker_Default_Window, KF.db.Modules.SmartTracker.Window[WindowName], true)
				
				if KF.db.Modules.SmartTracker.Window[WindowName] == nil then
					KF.db.Modules.SmartTracker.Window[WindowName] = {}
				end
			end
		end
		
		for IconName, IsIconData in pairs(KF.db.Modules.SmartTracker.Icon) do
			if type(IsIconData) == 'table' then
				KF:CompareTable(IsIconData, Info.SmartTracker_Default_Icon, KF.db.Modules.SmartTracker.Icon[IconName], true)
				
				if KF.db.Modules.SmartTracker.Icon[IconName] == nil then
					KF.db.Modules.SmartTracker.Icon[IconName] = {}
				end
			end
		end
		
		if E.db.movers then
			if KF.UIParent.ST_Window then
				for WindowName, Window in pairs(KF.UIParent.ST_Window) do
					if E.db.movers[Window.mover.name] and WindowName ~= Window.mover.name then
						E.db.movers[WindowName] = E.db.movers[Window.mover.name]
						E.db.movers[Window.mover.name] = nil
					end
				end
			end
			
			if KF.UIParent.ST_Icon then
				for AnchorName, Anchor in pairs(KF.UIParent.ST_Icon) do
					if E.db.movers[Anchor.mover.name] and AnchorName ~= Anchor.mover.name then
						E.db.movers[AnchorName] = E.db.movers[Anchor.mover.name]
						E.db.movers[Anchor.mover.name] = nil
					end
				end
			end
		end
	end
}