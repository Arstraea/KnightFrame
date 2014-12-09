local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.SmartTracker = {
	Enable = true,
	
	General = {
		DetailSpellTooptip = false,
		EraseWhenUserLeftGroup = true,
	},
	
	Scan = {
		AutoScanning = true,
		UpdateInspectCache = true,
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
	
	Window = {
		[1] = {
			Enable = true,
			
			Appearance = {
				Location = 'TOPLEFTElvUIParentTOPLEFT11-258',
				
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
					Solo = true,
					Group = true,
					Instance = true,
					RaidDungeon = true,
					PvPGround = true
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
					
				},
				HUNTER = {
					
				},
				SHAMAN = {
					
				},
				MONK = {
					
				},
				ROGUE = {
					
				},
				DEATHKNIGHT = {
					
				},
				MAGE = {
					
				},
				DRUID = {
					
				},
				PALADIN = {
					
				},
				PRIEST = {
					
				},
				WARLOCK = {
					
				}
			}
		}
	},
	
	Icon = {
	
	}
	--[[
	['General'] = {
		['HideWhenSolo'] = true,
		['EraseWhenUserLeftGroup'] = true,
		['ShowDetailTooltip'] = false,
		
		['CooldownEndAnnounce'] = 1,
	},
	
	['Scan'] = {
		['AutoScanning'] = true,
		['CheckChanging'] = true,
		['Update'] = false,
	},
	
	
	
	['WARRIOR'] = {
		[97462] = 2, --재집결
		[114030] = 2, --경계
		[871] = 2, --방벽
		[12975] = 2, --최저
		[1160] = 2, --사기의 외침
		[114207] = 2,--해골 깃발
	},
	['HUNTER'] = {
		[19263] = 2, --공저
	},
	['SHAMAN'] = {
		[108280] = 2, --치유해일 토템
		[16190] = 2, --마나해일 토템
		[98008] = 2, --정신고리 토템
		[120668] = 2, --폭풍채찍 토템
	},
	['MONK'] = {
		[115203] = 2, --강화주
		[115213] = 2, --해악 방지
		[115176] = 2, --명상
		[116849] = 2, --기의 고치
		[122783] = 2, --마법 해소
		[115310] = 2, --재활
	},
	['ROGUE'] = {
		[114018] = 1, --은폐의 장막
	},
	['DEATHKNIGHT'] = {
		[48792] = 2, --얼인
		[49222] = 2, --뼈의 보호막
		[55233] = 2, --흡혈
		[61999] = 2, --아군 되살리기
		[48743] = 2, --죽음의 서약
		[51052] = 2, --대마지
	},
	['MAGE'] = {
		[45438] = 2, --얼방
	},
	['DRUID'] = {
		[20484] = 2, --환생
		[740] = 2, --평온
		[106922] = 2, --우르속의 힘
		[102342] = 2, --무쇠껍질
		[22812] = 2, --나무 껍질
		[61336] = 2, --생존본능
		[77761] = 2, --쇄포
	},
	['PALADIN'] = {
		[31821] = 2, --헌신의 오라
		[6940] = 2, --희손
		[86659] = 2, --고왕수:보기
		[633] = 3, --신축
		[498] = 2, --신의 가호
		[1022] = 2, --보축
		[642] = 2, --무적
		[31850] = 2, --헌수
	},
	['PRIEST'] = {
		[64843] = 2, --천찬
		[62618] = 2, --방벽
		[33206] = 2, --고억
		[47788] = 2, --수호영혼
		[19236] = 2, --구원의 기도
	},
	['WARLOCK'] = {
		[20707] = 2, --영석
	},
	
	['RaidIcon'] = {
		[97462] = {
			['Class'] = 'WARRIOR',
			['Level'] = 83,
		},
		[98008] = {
			['Class'] = 'SHAMAN',
			['Level'] = 70,
			['Spec'] = L['Spec_Shaman_Restoration'],
		},
		[108280] = {
			['Class'] = 'SHAMAN',
			['Level'] = 65,
		},
		[31821] = {
			['Class'] = 'PALADIN',
			['Level'] = 60,
		},
		[76577] = {
			['Class'] = 'ROGUE',
			['Level'] = 85,
		},
		[51052] = {
			['Class'] = 'DEATHKNIGHT',
			['Talent'] = 5,
		},
		[740] = {
			['Class'] = 'DRUID',
			['Level'] = 74,
		},
		[64843] = {
			['Class'] = 'PRIEST',
			['Level'] = 78,
			['Spec'] = L['Spec_Priest_Holy'],
		},
		[62618] = {
			['Class'] = 'PRIEST',
			['Level'] = 70,
			['Spec'] = L['Spec_Priest_Discipline'],
		},
		[115310] = {
			['Class'] = 'MONK',
			['Level'] = 78,
			['Spec'] = L['Spec_Monk_Mistweaver'],
		},
		[15286] = {
			['Class'] = 'PRIEST',
			['Level'] = 78,
			['Spec'] = L['Spec_Priest_Shadow'],
		},
	},
	]]
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
			Solo = true,
			Group = true,
			Instance = true,
			RaidDungeon = true,
			PvPGround = true
		},
		
		Filter = {
			Tanker = true,
			Healer = true,
			Caster = true,
			Melee = true
		}
	},
	
	SpellList = {
		WARRIOR = {
			
		},
		HUNTER = {
			
		},
		SHAMAN = {
			
		},
		MONK = {
			
		},
		ROGUE = {
			
		},
		DEATHKNIGHT = {
			
		},
		MAGE = {
			
		},
		DRUID = {
			
		},
		PALADIN = {
			
		},
		PRIEST = {
			
		},
		WARLOCK = {
		
		}
	}
}


Info.SmartTracker_Default_Icon = {
	Appearance = {
		Icon_Width = 35,
		Icon_Height = 35,
		Spacing = 5,
		
		Arrangement = 'CENTER',		-- Left to Right, Right to Left, Center, 'Top To Bottom', 'Bottom To Top'
		Orientation = 'Horizontal',	-- Horizontal, Vertical
		
		FontSize = 13,
		DisplayMax = true
	},
	
	SpellList = {
	
	},
}


KF.DBFunction.SmartTracker = {
	Load = function(TableToSave, TableToLoad)
		if TableToLoad.Modules and TableToLoad.Modules.SmartTracker then
			if type(TableToLoad.Modules.SmartTracker.Window) == 'table' then
				for WindowName, IsWindowData in pairs(TableToLoad.Modules.SmartTracker.Window) do
					if type(IsWindowData) == 'table' then
						if WindowName == 1 then
							E:CopyTable(TableToSave.Modules.SmartTracker.Window[WindowName], IsWindowData)
						else
							TableToSave.Modules.SmartTracker.Window[WindowName] = E:CopyTable({}, Info.SmartTracker_Default_Window)
						end
					end
				end
			end
			
			if type(TableToLoad.Modules.SmartTracker.Icon) == 'table' then
				for IconName, IsIconData in pairs(TableToLoad.Modules.SmartTracker.Icon) do
					if type(IsIconData) == 'table' then
						TableToSave.Modules.SmartTracker.Icon[IconName] = E:CopyTable({}, Info.SmartTracker_Default_Icon)
					end
				end
			end
		end
	end,
	Save = function()
		for WindowName, IsWindowData in pairs(KF.db.Modules.SmartTracker.Window) do
			if type(IsWindowData) == 'table' then
				KF.db.Modules.SmartTracker.Window[WindowName] = KF:CompareTable(IsWindowData, Info.SmartTracker_Default_Window)
				
				if KF.db.Modules.SmartTracker.Window[WindowName] == nil then
					KF.db.Modules.SmartTracker.Window[WindowName] = {}
				end
			end
		end
		
		for IconName, IsIconData in pairs(KF.db.Modules.SmartTracker.Icon) do
			if type(IsIconData) == 'table' then
				KF.db.Modules.SmartTracker.Icon[IconName] = KF:CompareTable(IsIconData, Info.SmartTracker_Default_Icon)
				
				if KF.db.Modules.SmartTracker.Icon[IconName] == nil then
					KF.db.Modules.SmartTracker.Icon[IconName] = {}
				end
			end
		end
		
		if E.db.movers then
			if KF.UIParent.ST_Window then
				for WindowName, Window in pairs(KF.UIParent.ST_Window) do
					if WindowName ~= 1 and E.db.movers[Window.mover.name] then
						E.db.movers[WindowName] = E.db.movers[Window.mover.name]
						E.db.movers[Window.mover.name] = nil
					end
				end
			end
			
			if KF.UIParent.ST_Icon then
				for IconName, Icon in pairs(KF.UIParent.ST_Icon) do
					if E.db.movers[Icon.mover.name] then
						E.db.movers[IconName] = E.db.movers[Icon.mover.name]
						E.db.movers[Icon.mover.name] = nil
					end
				end
			end
		end
	end
}