local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

-----------------------------------------------------------
-- [ Knight : Spell Data								]--
-----------------------------------------------------------
Info.SmartTracker_ResetCooldownMapID = {
	-- WARLORD OF DRAENORE
	[1228] = 'HighMoul',
	
	-- MIST OF PANDARIA
	[1136] = 'Siege of Orgrimmar',
	[1098] = 'Throne of Thunder',
	[1009] = 'Heart of Fear',
	[1008] = "Mogu'shan Vaults",
	[996] = 'Terrace of Endless Spring',
	
	-- Wrath of the Lich King
	[631] = 'Icecrown',
}

-----------------------------------------------------------
-- [ Knight : Spell Data								]--
-----------------------------------------------------------
Info.SmartTracker_Data = {}
Info.SmartTracker_ConvertSpell = {}
Info.SmartTracker_SPELL_CAST_SUCCESS_Spell = {}

--[[  << Table Format >>
	[SpellID] = {
		Time		= Cooltime. (Number)
		Reset		= Spell that reset when boss combat is end. (Boolean)
		Target		= Target type spell. (Boolean)
		Charge		= Spell that chargable. (Function(UserGUID) or stack number)
		NotToMe		= Spell that can't target me. (Boolean)
		NeedParameter = Spell that need parameter in COMBAT_EVENT_LOG (Boolean)
		Hidden		= Spell that not displayed in config. (Boolean)
		Text		= Text that display other texts besides spell name. (String)
		Desc		= Text that display in config after spell name. (String)
		Level		= Need level to cast this spell (Number)
		TalentID	= If this spell is come from talent then write talent id (Number)
		GlyphID		= If this spell is come from glyph then write glyph id (Number)
		Spec		= Spell that needs specific specialization (SpecString or table)
		
		
		Spec = {
			[Global string of Spec in L table] = ChangedCooltime (Number)
			
			#NOTE: Global string of Spec in L table = L['Spec_'..ClassName..'_'..SpecName] (ex: L['Spec_Paladin_Holy']).
		},
		
		Talent = {
			[TalentID(Number)] = ChangedCooltime (Number)
			...
		},
		
		Glyph = {
			[Glyph ID(Number)] = ChangedCooltime (Number)
			...
			
			#NOTE: I use Glyph's SpellID that 4th returning parameter of GetGlyphSocketInfo(SocketID).
			#NOTE: Display all glyphs list of login character
				   /run local a, b for i=1,GetNumGlyphs() do _, _, _, _, a, b = GetGlyphInfo(i) print(a, b) end
		},
		
		Event = {
			[Event] = false or ChangedCooltime - Number
			
			#NOTE: If we must make a specific event condition for catching spell then use this parts.
			
			#NOTE: If you submit the event and value is exists then system will catch and register that spell by this event in combat log
				   and if value is false then system will block this spell that catched by this event.
			
			#NOTE: If there is no specific condition in this area then system will catch this following event
				    = SPELL_RESURRECT, SPELL_AURA_APPLIED, SPELL_AURA_REFRESH, SPELL_CAST_SUCCESS, SPELL_INTERRUPT, SPELL_SUMMON
		},
		
		Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName, ParamTable)
			#NOTE: If spell needs specific calcurating by difficult condition then use func.
		end
	}
]]

do	-- WARRIOR DATA
	Info.SmartTracker_Data.WARRIOR = {
		[355] = { Time = 8, Target = true, Level = 12 },												-- 도발
		[2565] = { Time = 12, Charge = 2, Level = 18, Spec = L['Spec_Warrior_Protection'] },			-- 방패 막기
		[12975] = { Time = 180, Level = 38, Spec = L['Spec_Warrior_Protection'] },						-- 최후의 저항
		[5246] = { Time = 90, Level = 52 },																-- 위협의 외침
		[103840] = { Time = 30, TalentID = 15758 },														-- 예견된 승리
		[6552] = { Time = 15, Target = true, Level = 24 },												-- 자루 공격
		[18499] = { Time = 30, Level = 54 },															-- 광전사의 격노
		[1160] = { Time = 60, Level = 56, Spec = L['Spec_Warrior_Protection'] },						-- 사기의 외침
		[23920] = { Time = 25, Level = 66 },															-- 주문 반사
		[3411] = { Time = 30, Target = true, NotToMe = true, Level = 72 },								-- 가로막기
		[114192] = { Time = 180, Level = 87, Spec = L['Spec_Warrior_Protection'] },						-- 도발 깃발
		[55694] = { Time = 60, TalentID = 16036 },														-- 격노의 재생력
		[107570] = { Time = 30, Target = true, TalentID = 15759 },										-- 폭풍망치
		[118000] = { Time = 60, TalentID = 16037 },														-- 용의 포효
		[114028] = { Time = 30, TalentID = 15765 },														-- 대규모 주문 반사
		[114029] = { Time = 30, Target = true, NotToMe = true, TalentID = 15766 },						-- 수비대장
		[114030] = { Time = 120, Target = true, NotToMe = true, TalentID = 19676 },						-- 경계
		[107574] = { Time = 180, TalentID = 19138 },													-- 투신
		[12292] = { Time = 60, TalentID = 19139 },														-- 피범벅
		[46924] = { Time = 60, TalentID = 19140 },														-- 칼날폭풍
		[152277] = { Time = 60, TalentID = 21205 },														-- 쇠날발톱
		[176289] = { Time = 45, TalentID = 21206 },														-- 공성파쇄기
		
		[871] = { Time = 180, Level = 48, Spec = L['Spec_Warrior_Protection'],							-- 방패의 벽
			Func = function(Cooldown, CooldownCache, _, _, _, UserName)
				return Cooldown - (UnitLevel(UserName) and UnitLevel(UserName) >= 60 and 60 or 0)
			end
		},
		
		[1719] = { Time = 180, Level = 87,																-- 무모한 희생
			Spec = {
				[(L['Spec_Warrior_Arms'])] = true,
				[(L['Spec_Warrior_Fury'])] = true
			},
		},
		
		[118038] = { Time = 120, Level = 56,															-- 투사의 혼
			Spec = {
				[(L['Spec_Warrior_Arms'])] = true,
				[(L['Spec_Warrior_Fury'])] = true
			},
		},
		
		[97462] = { Time = 180, Level = 83,																-- 재집결의 함성
			Spec = { 
				[(L['Spec_Warrior_Arms'])] = true,
				[(L['Spec_Warrior_Fury'])] = true
			},
		},
		
		[100] = { Time = 20, Target = true, Level = 3,													-- 돌진
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Talent[16035] then
					return 2
				end
			end,
			Talent = {
				[15775] = -8						-- 문양: 돌진
			}
		},
		
		[6544] = { Time = 45, Level = 85,																-- 영웅의 도약
			Func = function(Cooldown, CooldownCache, InspectCache)
				if (InspectCache and InspectCache.Spec or CooldownCache.Spec) == L['Spec_Warrior_Protection'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157449]) and CooldownCache.List[355] then
					CooldownCache.List[355][1].ActivateTime = GetTime() - 8 + SmartTracker.FADE_TIME
				end 								-- 드레노어의 선물: 영웅의 도약 연마
				
				return Cooldown
			end
		},
		
		[46968] = { Time = 40, TalentID = 15760 },														-- 충격파
		[132168] = { Time = .5, Hidden = true,															-- 충격파 (쿨타임 감소용)
			Event = {
				SPELL_AURA_APPLIED = true,
				SPELL_MISSED = true
			},
			Func = function(Cooldown, CooldownCache, _, _, _, _, _, SpellID)
				if CooldownCache.List[46968] and CooldownCache.List[SpellID][1].Count and CooldownCache.List[SpellID][1].Count >= 3 then
					CooldownCache.List[46968][1].Cooltime = 20
				end
				
				return Cooldown, true
			end
		},
	}
	
	Info.SmartTracker_ConvertSpell[178368] = 6544														-- 영웅의 도약
	Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[6544] = true												-- 영웅의 도약
end


do	-- HUNTER DATA
	Info.SmartTracker_Data.HUNTER = {
		[20736] = { Time = 8, Target = true, Level = 52 },												-- 견제 사격
		[147362] = { Time = 24, Target = true, Level = 22 },											-- 반격의 사격
		[1543] = { Time = 20, Level = 38 },																-- 섬광
		[172106] = { Time = 180, Level = 84 },															-- 여우의 상
		[51753] = { Time = 60, Level = 85 },															-- 위장술
		[19577] = { Time = 60, TalentID = 19359 },														-- 위협
		[54216] = { Time = 45, Target = true, Level = 74 },												-- 주인의 부름
		[109248] = { Time = 45, GlyphID = 19347 },														-- 구속의 사격
		[3045] = { Time = 120, Level = 54, Spec = L['Spec_Hunter_Marksmanship'] },						-- 속사
		[19386] = { Time = 45, Target = true, GlyphID = 19348 },										-- 비룡 쐐기
		[109304] = { Time = 120, GlyphID = 19350 },														-- 활기
		[109259] = { Time = 45, Target = true, GlyphID = 19358 },										-- 강화 사격
		
		[5384] = { Time = 360, Level = 32,																-- 죽은척하기
			Text = L['Hunter_Now_FeignDeath'],
			Func = function(Cooldown, CooldownCache, InspectCache, _, _, UserName, UserClass, SpellID)
				if not CooldownCache.List[SpellID][2] then
					CooldownCache.List[SpellID][2] = {
						ForbidFadeIn = true,
						ActivateTime = CooldownCache.List[SpellID][1].ActivateTime,
						Cooltime = 30,
						ChargedColor = true
					}
				end
				
				local SpellName = GetSpellInfo(SpellID)
					
				if SpellName and not (UnitExists(UserName) and UnitAura(UserName, SpellName)) then
					tremove(CooldownCache.List[SpellID], 1)
					CooldownCache.List[SpellID][1].ActivateTime = GetTime()
					
					return 30
				end
				
				return Cooldown, true
			end
		},
		
		[19801] = { Time = 0, Target = true, Level = 35,												-- 평정의 사격
			Glyph = {
				[691] = 10							-- 특성: 평정의 사격
			}
		},
		
		[781] = { Time = 20, Level = 14,																-- 철수
			Talent = {
				[19364] = -10						-- 특성: 웅크린 호랑이, 숨은 키메라
			}
		},
		
		
		[19263] = { Time = 180, Charge = 2, Level = 78,													-- 공격 저지
			Talent = {
				[19364] = -60						-- 특성: 웅크린 호랑이, 숨은 키메라
			}
		},
		
		[34477] = { Time = 30, Target = true, Level = 42,												-- 눈속임
			Event = {
				SPELL_CAST_SUCCESS = true,
			},
			Func = function(Cooldown, CooldownCache, InspectCache, _, _, UserName, _, _, DestName)
				if InspectCache then
					if InspectCache.Glyph[361] then
						if DestName == UnitName('pet') then
							return 0
						else
							for i = 1, MAX_RAID_MEMBERS do
								if UnitName(Info.CurrentGroupMode..i) == UserName then
									if UnitName(Info.CurrentGroupMode..i..'pet') == DestName then
										return 0
									else
										return Cooldown
									end
								end
							end
							
							return 0
						end
					else
						return Cooldown
					end
				end
				
				return Cooldown, true				-- 문양: 눈속임
			end,
		},
		
		[34600] = { Time = 30, GlyphID = 1131,															-- 뱀 덫
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Huner_Survival'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157751]) then
						return Cooldown / 2			-- 드레노어의 선물: 향상된 덫
					else
						return Cooldown
					end
				end
				
				return Cooldown, true
			end
		},
		
		[13813] = { Time = 30, Level = 38,																-- 폭발의 덫
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Huner_Survival'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157751]) then
						return Cooldown / 2			-- 드레노어의 선물: 향상된 덫
					else
						return Cooldown
					end
				end
				
				return Cooldown, true
			end
		},
		
		[1499] = { Time = 30, Level = 28,																-- 빙결의 덫
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Huner_Survival'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157751]) then
						return Cooldown / 2			-- 드레노어의 선물: 향상된 덫
					else
						return Cooldown
					end
				end
				
				return Cooldown, true
			end
		},
		
		[13809] = { Time = 30, Level = 46,																-- 얼음의 덫
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Huner_Survival'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157751]) then
						return Cooldown / 2			-- 드레노어의 선물: 향상된 덫
					else
						return Cooldown
					end
				end
				
				return Cooldown, true
			end
		}
	}
	
	Info.SmartTracker_ConvertSpell[60192] = 1499														-- 빙결의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82939] = 13813														-- 폭발의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82941] = 13809														-- 얼음의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82948] = 34600														-- 뱀 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[148467] = 19263														-- 공저 (2분쿨)
	
	Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[5384] = true												-- 죽은척 하기
end


do	-- SHAMAN DATA
	Info.SmartTracker_Data.SHAMAN = {
		[108273] = { Time = 60, TalentID = 19261 },														-- 바람걸음 토템
		[108270] = { Time = 60, TalentID = 19263 },														-- 돌의 보루 토템
		[2484] = { Time = 30, Level = 26 },																-- 속박의 토템
		[8143] = { Time = 60, Level = 54 },																-- 진동의 토템
		[5394] = { Time = 30, Level = 30 },																-- 치유의 토템
		[2062] = { Time = 300, Reset = true, Level = 58 },												-- 대지의 정령 토템
		[108269] = { Time = 45, Level = 63 },															-- 축전 토템
		[2825] = { Time = 300, Reset = true, Level = 70 },												-- 피의 욕망
		[114049] = { Time = 180, Level = 87 },															-- 지배력
		[98008] = { Time = 180, Level = 70, Spec = L['Spec_Shaman_Restoration'] },						-- 정신의 고리 토템
		[108280] = { Time = 180, Level = 65, Spec = L['Spec_Shaman_Restoration'] },						-- 치유의 해일 토템
		[108271] = { Time = 90, TalentID = 19264 },														-- 영혼 이동
		[51485] = { Time = 30, TalentID = 19260 },														-- 구속의 토템
		[16166] = { Time = 120, TalentID = 19271 },														-- 정기의 깨달음
		[108281] = { Time = 120, TalentID = 19269 },													-- 고대의 인도
		[152256] = { Time = 300, Reset = true, TalentID = 21199 },										-- 폭풍의 정령 토템
		[152255] = { Time = 45, TalentID = 21200 },														-- 마그마 분출
		[157153] = { Time = 30, TalentID = 21674 },														-- 폭우의 토템
		
		[30884] = { Time = 30, TalentID = 19262 },														-- 자연의 수호자
		
		[51886] = { Time = 8, Target = true, Level = 18, Spec = L['Spec_Shaman_Restoration'],			-- 영혼 정화
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Glyph[1207] then
					return 2						-- 문양: 영혼 정화
				end
			end,
			Glyph = {
				[1207] = 4							-- 문양: 영혼 정화
			},
			Event = {
				SPELL_DISPEL = true
			}
		},
		
		[108285] = { Time = 180, TalentID = 19275,														-- 원소의 부름
			Func = function(Cooldown, CooldownCache)
				for _, SpellID in pairs({ 8177, 108273, 108270, 2484, 8143, 5394, 108269, 51485, 157153 }) do
					if CooldownCache.List[SpellID] then
						CooldownCache.List[SpellID][1].EraseThisCooltimeCache = true
					end
				end
				
				return Cooldown
			end
		},
		
		[16188] = { Time = 90, TalentID = 19272,														-- 고대의 신속함
			Event = {
				SPELL_AURA_REMOVED = true
			}
		},
		
		[57994] = { Time = 12, Target = true, Level = 16,												-- 날카로운 바람
			Glyph = {
				[220] = 3							-- 문양: 날카로운 바람
			}
		},
		
		[8177] = { Time = 25, Level = 38,																-- 마법흡수 토템
			Glyph = {
				[227] = 20,							-- 문양: 마법흡수 토템
				[1165] = -3							-- 문양: 마법흡수
			}
		},
		
		[51514] = { Time = 45, Target = true, Level = 75,												-- 사술
			Glyph = {
				[753] = -10							-- 문양: 사술
			}
		},
		
		[58875] = { Time = 60, Level = 60, Spec = L['Spec_Shaman_Enhancement'],							-- 정령의 걸음
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown * (InspectCache.Glyph[214] and 3 / 4 or 1)
				end
				
				return Cooldown, true				-- 문양: 정령의 걸음
			end
		},
		
		[370] = { Time = 0, Target = true, Level = 12,													-- 정화
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown + (InspectCache.Glyph[216] and 6 or 0)
				end
				
				return Cooldown, true				-- 문양: 정화
			end
		},
		
		[51490] = { Time = 35, Level = 10, Spec = L['Spec_Shaman_Elemental'],							-- 천둥폭풍
			Glyph = {
				[735] = -10							-- 문양: 천둥
			}
		},
		
		[51533] = { Time = 120, Level = 60, Spec = L['Spec_Shaman_Enhancement'],						-- 야수 정령
			Glyph = {
				[1163] = -60						-- 문양: 덧없는 정령
			}
		},
		
		[2894] = { Time = 300, Reset = true, Level = 66,												-- 불의 정령 토템
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown * (InspectCache.Glyph[217] and 1 / 2 or 1)
				end
				
				return Cooldown, true				-- 문양: 불의 정령 토템
			end
		},
		
		[79206] = { Time = 120, Level = 85, Spec = L['Spec_Shaman_Elemental'],							-- 영혼나그네의 은총
			Glyph = {
				[1170] = -60						-- 문양: 영혼나그네의 집중
			}
		},
		
		[30823] = { Time = 60, Level = 65,																-- 주술의 분노
			Glyph = {
				[1168] = 60							-- 문양: 주술의 결의
			}
		}
	}
	
	Info.SmartTracker_ConvertSpell[165339] = 114049														-- 지배력 (정기)
	Info.SmartTracker_ConvertSpell[165341] = 114049														-- 지배력 (고양)
	Info.SmartTracker_ConvertSpell[165344] = 114049														-- 지배력 (고양)
end


do	-- MONK DATA
	Info.SmartTracker_Data.MONK = {
		[116841] = { Time = 30, TalentID = 19818 },														-- 범의 욕망
		[115546] = { Time = 8, Target = true, Level = 14 },												-- 조롱
		[113656] = { Time = 25, Level = 10, Spec = L['Spec_Monk_Windwalker'] },							-- 분노의 주먹
		[101545] = { Time = 25, Level = 18, Spec = L['Spec_Monk_Windwalker'] },							-- 비룡차기
		[122470] = { Time = 90, Target = true, Level = 22, Spec = L['Spec_Monk_Windwalker'] },			-- 업보의 손아귀
		[115203] = { Time = 180, Level = 24 },															-- 강화주
		[137562] = { Time = 120, Level = 30 },															-- 민활주
		[116705] = { Time = 15, Target = true, Level = 32 },											-- 손날 찌르기
		[115288] = { Time = 60, Level = 36, Spec = L['Spec_Monk_Windwalker'] },							-- 기력 회복주
		[115078] = { Time = 15, Target = true, Level = 44 },											-- 마비
		[115176] = { Time = 180, Level = 82, Spec = L['Spec_Monk_Brewmaster'] },						-- 명상
		--[101643] = { Time = 45, Level = 87 },															-- 해탈
		[116680] = { Time = 45, Level = 66, Spec = L['Spec_Monk_Mistweaver'] },							-- 집중의 천둥 차
		[115310] = { Time = 180, Level = 78, Spec = L['Spec_Monk_Mistweaver'] },						-- 재활
		[115399] = { Time = 60, Charge = 2, TalentID = 19772 },											-- 원기주
		[116844] = { Time = 45, Target = true, TalentID = 19993 },										-- 평화의 고리
		[119392] = { Time = 30, TalentID = 19994 },														-- 황소 쇄도
		[119381] = { Time = 45, TalentID = 19995 },														-- 팽이 차기
		[122278] = { Time = 90, TalentID = 20175 },														-- 해악 감퇴
		[122783] = { Time = 90, TalentID = 20173 },														-- 마법 해소
		[123904] = { Time = 180, TalentID = 20184 },													-- 백호 쉬엔의 원령
		[152173] = { Time = 90, TalentID = 21191 },														-- 평온
		[157535] = { Time = 90, TalentID = 157535 },													-- 옥룡의 숨결
		
		[115450] = { Time = 8, Target = true, Level = 20,												-- 해독
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Glyph[1209] then
					return 2						-- 문양: 해독
				end
			end,
			Event = {
				SPELL_DISPEL = true
			},
			Func = function(Cooldown, _, InspectCache)
				if InspectCache then
					return Cooldown + (InspetCache.Glyph[1209] and 4 or 0)
				end
				
				return Cooldown, true				-- 문양: 해독
			end
		},
		
		[116849] = { Time = 120, Target = true, Level = 50, Spec = L['Spec_Monk_Mistweaver'],			-- 기의 고치
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Monk_Mistweaver'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157401]) then
						return Cooldown - 20
					else
						return Cooldown
					end
				end
				
				return Cooldown, true				-- 드레노어의 선물: 기의 고치 연마
			end
		},
		
		[115080] = { Time = 90, Target = true, Level = 22,												-- 절명의 손길
			Func = function(Cooldown, _, InspectCache)
				if InspectCache then
					return Cooldown + (InspectCache.Glyph[1014] and 120 or 0)
				end
				
				return Cooldown, true				-- 문양: 절명의 손길
			end
		},
		
		[119996] = { Time = 25, Level = 87,																-- 해탈: 전환
			Glyph = {
				[1011] = -5							-- 문양: 해탈
			}
		},
		
		[115295] = { Time = 30, Level = 26,																-- 방어 자세
			Charge = function(UserGUID, UserName)
				if (SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Spec or SmartTracker.CooldownCache[UserGUID] and SmartTracker.CooldownCache[UserGUID].Spec) == L['Spec_Monk_Brewmaster'] and (UnitLevel(UserName) >= 100 or SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].DraenorePerks and SmartTracker.InspectCache[UserGUID].DraenorePerks[157363]) then
					return 2						-- 드레노어의 선물: 방어 자세 연마
				end
			end
		}
	}
end


do	-- ROGUE DATA
	Info.SmartTracker_Data.ROGUE = {
		[31224] = { Time = 60, Level = 58 },															-- 그림자 망토
		[408] = { Time = 20, Target = true, Level = 40 },												-- 급소 가격
		[51713] = { Time = 60, Level = 80 },															-- 어둠의 춤
		[76577] = { Time = 180, Level = 85 },															-- 연막탄
		[114018] = { Time = 300, Level = 76 },															-- 은폐의 장막
		[57934] = { Time = 30, Target = true, Level = 78 },												-- 속임수 거래
		[2094] = { Time = 120, Target = true, Level = 38 },												-- 실명
		[2983] = { Time = 60, Level = 26 },																-- 전력 질주
		[1725] = { Time = 30, Level = 28 },																-- 혼란
		[1776] = { Time = 10, Target = true, Level = 22 },												-- 후려치기
		[74001] = { Time = 120, TalentID = 19238 },														-- 전투 준비
		[31230] = { Time = 90, TalentID = 19239 },														-- 구사일생
		[36554] = { Time = 20, Target = true, TalentID = 19243 },										-- 그림자 밟기
		[152151] = { Time = 120, Target = true, TalentID = 21187 },			 							-- 그림자 분신
		[79140] = { Time = 120, Target = true, Level = 80, Spec = L['Spec_Rogue_Assassination'] },		-- 원한
		[51690] = { Time = 120, Level = 80, Spec = L['Spec_Rogue_Combat'] },							-- 광기의 학살자
		[13750] = { Time = 180, Level = 40, Spec = L['Spec_Rogue_Combat'] },							-- 아드레날린 촉진
		
		[5938] = { Time = 10, Target = true, Level = 74,												-- 독칼
			Glyph = {
				[410] = -3							-- 문양: 독칼
			}
		},
		
		[5277] = { Time = 120, Level = 8,																-- 회피
			Glyph = {
				[1160] = -30						-- 문양: 교묘함
			}
		},
		
		[137619] = { Time = 60, Target = true, TalentID = 19249,										-- 죽음의 표적
			
		},
		
		[1766] = { Time = 15, Target = true, Level = 18,												-- 발차기
			Glyph = {
				[926] = 4							-- 문양: 발차기
			},
			Event = {
				SPELL_CAST_SUCCESS = true,
				SPELL_INTERRUPT = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache, Event)
				if InspectCache then
					if Event == 'SPELL_INTERRUPT' and InspectCache.Glyph[926] then
						return Cooldown - 6
					else
						return Cooldown
					end
				end
				
				return Cooldown, true				-- 문양: 발차기
			end,
		},
		
		[14185] = { Time = 300, Reset = true, Level = 68,												-- 마음가짐
			Func = function(Cooldown, CooldownCache)
				for _, SpellID in pairs({ 2983, 1856, 5277 }) do
					if CooldownCache.List[SpellID] then
						CooldownCache.List[SpellID][1].EraseThisCooltimeCache = true
					end
				end
				
				return Cooldown
			end
		},
		
		[1856] = { Time = 90, Level = 34,																-- 소멸
			Glyph = {
				[1162] = -60						-- 문양: 사라짐
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Rogue_Subtlety'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157666]) then
						return Cooldown - 30
					else
						return Cooldown
					end
				end
				
				return Cooldown, true				-- 드레노어의 선물: 향상된 소멸
			end
		},
	}
end


do	-- DEATHKNIGHT DATA
	Info.SmartTracker_Data.DEATHKNIGHT = {
		[48707] = { Time = 45, Level = 68 },															-- 대마법 보호막
		[49222] = { Time = 60, Level = 78, Spec = L['Spec_DeathKnight_Blood'] },						-- 뼈의 보호막
		[42650] = { Time = 600, Reset = true, Level = 80 },												-- 사자의 군대
		[47568] = { Time = 300, Level = 76 },															-- 룬 무기 강화
		[61999] = { Time = 600, Target = true, Level = 72 },											-- 아군 되살리기
		[56222] = { Time = 8, Target = true, Level = 58, Spec = L['Spec_DeathKnight_Blood'] },			-- 어둠의 명령
		[108194] = { Time = 30, Target = true, TalentID = 19223 },										-- 어둠의 질식
		[48743] = { Time = 120, TalentID = 19226 },														-- 죽음의 서약
		[55233] = { Time = 60, Level = 76, Spec = L['Spec_DeathKnight_Blood'] },						-- 흡혈
		[49028] = { Time = 90, Level = 74, Spec = L['Spec_DeathKnight_Blood'] },						-- 춤추는 룬 무기
		[51271] = { Time = 60, Level = 68, Spec = L['Spec_DeathKnight_Frost'] },						-- 얼음 기둥
		[47476] = { Time = 60, Target = true, Level = 58 },												-- 질식시키기
		[49206] = { Time = 180, Level = 74, Spec = L['Spec_DeathKnight_Unholy'] },						-- 가고일 부르기
		[115989] = { Time = 90, TalentID = 19217 },														-- 부정의 파멸충
		[49039] = { Time = 120, TalentID = 19218 },														-- 리치의 혼
		[51052] = { Time = 120, TalentID = 19219 },														-- 대마법 지대
		[108199] = { Time = 60, Target = true, TalentID = 19230 },										-- 고어핀드의 손아귀
		[108200] = { Time = 60, TalentID = 19231 },														-- 냉혹한 겨울
		[108201] = { Time = 120, TalentID = 19232 },													-- 더렵혀진 대지
		[152280] = { Time = 30, TalentID = 21208 },														-- 파멸
		[152279] = { Time = 120, TalentID = 21209 },													-- 신드라고사의 숨결
		
		[48982] = { Time = 40, Charge = 2, Level = 64,													-- 룬 전환
			Glyph = {
				[1115] = -10						-- 문양: 룬 전환
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_DeathKnight_Blood'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157336]) then
						return Cooldown - 10
					else
						return Cooldown
					end
				end
				
				return Cooldown, true				-- 드레노어의 선물: 향상된 룬 전환
			end
		},
		
		[77606] = { Time = 60, Target = true, Level = 85,												-- 어둠 복제
			Glyph = {
				[769] = -30							-- 문양: 어둠 복제
			}
		},
		
		[48792] = { Time = 180, Level = 62,																-- 얼음같은 인내력
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown * (InspectCache.Glyph[515] and 1 / 2 or 1)
				end
				
				return Cooldown, true				-- 문양: 얼음같은 인내력
			end
		},
		
		[47528] = { Time = 15, Target = true, Level = 57,												-- 정신 얼리기
			Glyph = {
				[527] = -1							-- 문양: 정신 얼리기
			}
		},
		
		[49576] = { Time = 25, NeedParameter = true,													-- 죽음의 손아귀
			Event = {
				SPELL_CAST_SUCCESS = true,
				SPELL_MISSED = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache, Event, _, _, _, _, _, ParamTable)
				if InspectCache then
					if InspectCache.Glyph[553] and Event == 'SPELL_MISSED' and ParamTable[1] == 'IMMUNE' then
						return 0
					elseif (InspectCache.Spec or CooldownCache.Spec) == L['Spec_DeathKnight_Blood'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157337]) then
						return Cooldown - 5			-- 드레노어의 선물: 향상된 죽음의 손아귀
					else
						return Cooldown
					end
				end
				
				return Cooldown, true				-- 문양: 되돌아오는 손아귀
			end
		},
	}
end


do	-- MAGE DATA
	Info.SmartTracker_Data.MAGE = {
		[44572] = { Time = 30, Target = true, Level = 66, Spec = L['Spec_Mage_Frost'] },				-- 동결
		[66] = { Time = 300, Level = 56 },																-- 투명화
		[110959] = { Time = 90, TalentID = 16207 },														-- 상급 투명화
		[159916] = { Time = 120, Level = 87 },															-- 마법 증폭
		[113724] = { Time = 45, TalentID = 16019 },														-- 서리 고리
		[157997] = { Time = 25, Charge = 2, TalentID = 21693 },											-- 서리 회오리
		[157980] = { Time = 25, Charge = 2, TalentID = 19301 },											-- 초신성
		[157981] = { Time = 25, Charge = 2, TalentID = 21692 },											-- 화염 폭풍
		[11426] = { Time = 25, TalentID = 16025 },														-- 얼음 보호막
		[12472] = { Time = 180, Level = 36, Spec = L['Spec_Mage_Frost'] },								-- 얼음 핏줄
		[80353] = { Time = 300, Reset = true, Level = 84 },												-- 시간 왜곡
		[108839] = { Time = 20, Charge = 3, TalentID = 16013 },											-- 얼음발
		[45438] = { Time = 300, Level = 15 },															-- 얼음 방패
		[43987] = { Time = 60, Level = 72 },															-- 원기 회복의 식탁 창조
		[157913] = { Time = 45, TalentID = 21689 },														-- 무의 존재
		[108843] = { Time = 25, TalentID = 16012 },														-- 타오르는 속도
		[108978] = { Time = 90, TalentID = 16023 },														-- 시간 돌리기
		[111264] = { Time = 20, Target = true, TalentID = 16020 },										-- 얼음 수호물
		[102051] = { Time = 20, Target = true, TalentID = 16021 },										-- 서리투성이 턱
		[55342] = { Time = 120, TalentID = 16031 },														-- 환영 복제
		[152087] = { Time = 90, TalentID = 21144 },														-- 굴절의 수정
		[31661] = { Time = 20, Level = 62, Spec = L['Spec_Mage_Fire'] },								-- 용의 숨결
		
		[1953] = { Time = 15, Level = 7,																-- 점멸
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Glyph[325] then
					return 2						-- 문양: 신속한 이동
				end
			end
		},
		
		[12051] = { Time = 120, Level = 40, Spec = L['Spec_Mage_Arcane'],								-- 환기
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Mage_Arcane'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157493]) then
						return Cooldown - 30		-- 환기 연마
					else
						return Cooldown
					end
				end
				
				return Cooldown, true
			end
		},
		
		[11129] = { Time = 45, Target = true, Level = 77,												-- 발화
			Glyph = {
				[316] = 45							-- 문양: 발화
			}
		},
		[133] = { Time = 0, Hidden = true, NeedParameter = true,										-- 화염구 (덧불 특성용)
			Event = {
				SPELL_DAMAGE = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache, _, _, _, _, _, _, ParamTable)
				if (InspectCache and InspectCache.Spec or CooldownCache.Spec) == L['Spec_Mage_Fire'] and InspectCache.Talent[21631] and ParamTable[7] and CooldownCache.List[11129] then
					CooldownCache.List[11129][1].ActivateTime = CooldownCache.List[11129][1].ActivateTime - 1
				end
				
				return 0
			end
		},
		[44614] = { Time = 0, Hidden = true, NeedParameter = true,										-- 얼음불꽃 화살 (덧불 특성용)
			Event = {
				SPELL_DAMAGE = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache, _, _, _, _, _, _, ParamTable)
				if (InspectCache and InspectCache.Spec or CooldownCache.Spec) == L['Spec_Mage_Fire'] and InspectCache.Talent[21631] and ParamTable[7] and CooldownCache.List[11129] then
					CooldownCache.List[11129][1].ActivateTime = CooldownCache.List[11129][1].ActivateTime - 1
				end
				
				return 0
			end
		},
		[11366] = { Time = 0, Hidden = true, NeedParameter = true,										-- 불덩이 작렬 (덧불 특성용)
			Event = {
				SPELL_DAMAGE = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache, _, _, _, _, _, _, ParamTable)
				if (InspectCache and InspectCache.Spec or CooldownCache.Spec) == L['Spec_Mage_Fire'] and InspectCache.Talent[21631] and ParamTable[7] and CooldownCache.List[11129] then
					CooldownCache.List[11129][1].ActivateTime = CooldownCache.List[11129][1].ActivateTime - 1
				end
				
				return 0
			end
		},
		[108853] = { Time = 0, Hidden = true,															-- 지옥불 작렬 (덧불 특성용)
			Event = {
				SPELL_DAMAGE = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if (InspectCache and InspectCache.Spec or CooldownCache.Sped) == L['Spec_Mage_Fire'] and InspectCache.Talent[21631] and CooldownCache.List[11129] then
					CooldownCache.List[11129][1].ActivateTime = CooldownCache.List[11129][1].ActivateTime - 1
				end
				
				return 0
			end
		},
		
		[12043] = { Time = 90, Spec = L['Spec_Mage_Arcane'],											-- 냉정
			Event = {
				SPELL_AURA_REMOVED = true
			}
		},
		
		[2139] = { Time = 24, Target = true, Level = 8,													-- 마법 차단
			Glyph = {
				[871] = 4							-- 문양: 마법 차단
			}
		},
		
		[12042] = { Time = 90, Level = 62, Spec = L['Spec_Mage_Arcane'],								-- 신비의 마법 강화
			Glyph = {
				[651] = 90							-- 문양: 신비의 마법 강화
			}
		},
		
		[122] = { Time = 30, Level = 3,																	-- 얼음 회오리
			Glyph = {
				[318] = -5							-- 문양: 얼음 회오리
			}
		},
		
		[475] = { Time = 8, Target = true, Level = 29,													-- 저주 해제
			Event = {
				SPELL_DISPEL = true
			}
		},
		
		[11958] = { Time = 180, TalentID = 19029,														-- 매서운 한파
			Func = function(Cooldown, CooldownCache)
				for _, SpellID in pairs({ 45438, 12043, 122 }) do
					if CooldownCache.List[SpellID] then
						CooldownCache.List[SpellID][1].EraseThisCooltimeCache = true
					end
				end
				
				return Cooldown
			end
		}
	}
end


do	-- DRUID DATA
	Info.SmartTracker_Data.DRUID = {
		[1850] = { Time = 180, Level = 24 },															-- 질주
		[6795] = { Time = 8, Target = true, Level = 8 },												-- 포효
		[5217] = { Time = 30, Level = 10, Spec = L['Spec_Druid_Feral'] },								-- 호랑이의 분노
		[20484] = { Time = 600, Target = true, Reset = true, Level = 56 },								-- 환생
		[77764] = { Time = 120, Level = 84 },															-- 쇄도의 포효
		[112071] = { Time = 180, Level = 68, Spec = L['Spec_Druid_Balance'] },							-- 천체의 정렬
		[78675] = { Time = 60, Target = true, Level = 28, Spec = L['Spec_Druid_Balance'] },				-- 태양 광선
		[62606] = { Time = 12, Charge = 2, Level = 10, Spec = L['Spec_Druid_Guardian'] },				-- 야생의 방어
		[102342] = { Time = 60, Target = true, Level = 64, Spec = L['Spec_Druid_Restoration'] },		-- 무쇠껍질
		[132158] = { Time = 60, Spec = L['Spec_Druid_Restoration'] },									-- 자연의 신속함
		[740] = { Time = 180, Reset = true, Level = 74, Spec = L['Spec_Druid_Restoration'] },			-- 평온
		[102280] = { Time = 30, TalentID = 18570 },														-- 야수 탈주
		[108238] = { Time = 120, TalentID = 19283 },													-- 소생
		[102351] = { Time = 30, TalentID = 18574 },														-- 세나리온 수호물
		[102359] = { Time = 30, Target = true, TalentID = 18576 },										-- 대규모 휘감기
		[132469] = { Time = 30, TalentID = 18577 },														-- 태풍
		[99] = { Time = 30, TalentID = 18581 },															-- 행동 불가의 포효
		[102793] = { Time = 60, TalentID = 18582 },														-- 우르솔의 회오리
		[5211] = { Time = 50, TalentID = 18583 },														-- 거센 강타
		[108292] = { Time = 360, Reset = true, TalentID = 18584 },										-- 야생의 정수
		[124974] = { Time = 90, TalentID = 18586 },														-- 자연의 경계
		[155835] = { Time = 60, TalentID = 21654 },														-- 뻣뻣한 털
		
		[106839] = { Time = 15, Target = true, Level = 64,												-- 두개골 강타
			Spec = {
				[(L['Spec_Druid_Feral'])] = true,
				[(L['Spec_Druid_Guardian'])] = true
			}
		},
		
		[61336] = { Time = 120, Charge = 2, Level = 56,													-- 생존 본능
			Spec = {
				[(L['Spec_Druid_Feral'])] = true,
				[(L['Spec_Druid_Guardian'])] = true
			}
		},
		
		[22812] = { Time = 60, Level = 44,																-- 나무 껍질
			Spec = {
				[(L['Spec_Druid_Balance'])] = true,
				[(L['Spec_Druid_Guardian'])] = true,
				[(L['Spec_Druid_Restoration'])] = true
			}
		},
		
		[102401] = { Time = 15, Target = true, TalentID = 18571,										-- 야생의 돌진
			Event = {
				SPELL_CAST_SUCCESS = true
			}
		},
		
		[106952] = { Time = 180, Level = 48,															-- 광폭화
			Spec = {
				[(L['Spec_Druid_Feral'])] = true,
				[(L['Spec_Druid_Guardian'])] = true
			}
		},
		
		[102558] = { Time = 180, TalentID = 21706 },													-- 화신: 우르속의 자손 (수호)
		[102543] = { Time = 180, TalentID = 21705 },													-- 화신: 밀림의 왕 (야성)
		[102560] = { Time = 180, TalentID = 18579 },													-- 화신: 엘룬의 선택 (조화)
		[33891] = { Time = 180, TalentID = 21707 },														-- 화신: 생명의 나무 (회복)
		
		[102706] = { Time = 20, Charge = 2, TalentID = 21709 },											-- 자연의 군대 (수호)
		[102703] = { Time = 20, Charge = 2, TalentID = 21708 },											-- 자연의 군대 (야성)
		[33831] = { Time = 20, Charge = 2, TalentID = 18580 },											-- 자연의 군대 (조화)
		[102693] = { Time = 20, Charge = 2, TalentID = 21710 },											-- 자연의 군대 (회복)
		
		[88423] = { Time = 8, Target = true, Level = 22, Spec = L['Spec_Druid_Restoration'],			-- 자연의 치유력
			Event = {
				SPELL_DISPEL = true
			}
		},
		
		[2782] = { Time = 8, Target = true,																-- 해제
			Spec = {
				[(L['Spec_Druid_Balance'])] = true,
				[(L['Spec_Druid_Guardian'])] = true,
				[(L['Spec_Druid_Restoration'])] = true
			},
			Event = {
				SPELL_DISPEL = true
			}
		},
	}
	
	Info.SmartTracker_ConvertSpell[50334] = 106952														-- 광폭화 (곰)
	Info.SmartTracker_ConvertSpell[106951] = 106952														-- 광폭화 (표범)
	Info.SmartTracker_ConvertSpell[77761] = 77764														-- 쇄도의 포효
	Info.SmartTracker_ConvertSpell[106898] = 77764														-- 쇄도의 포효
	Info.SmartTracker_ConvertSpell[16979] = 102401														-- 야생의 돌진 (곰)
	Info.SmartTracker_ConvertSpell[49376] = 102401														-- 야생의 돌진 (표범)
	Info.SmartTracker_ConvertSpell[102383] = 102401														-- 야생의 돌진 (올빼미)
	Info.SmartTracker_ConvertSpell[102416] = 102401														-- 야생의 돌진 (바다표범)
	Info.SmartTracker_ConvertSpell[102417] = 102401														-- 야생의 돌진 (순록)
end


do	-- PALADIN DATA
	Info.SmartTracker_Data.PALADIN = {
		[85499] = { Time = 45, TalentID = 17565 },														-- 빛의 속도
		[96231] = { Time = 15, Target = true, Level = 36 },												-- 비난
		[105809] = { Time = 120, TalentID = 17597 },													-- 신성한 복수자
		[10326] = { Time = 15, Target = true, Level = 46 },												-- 악령 퇴치
		[62124] = { Time = 8, Target = true, Level = 15 },												-- 집행
		[20066] = { Time = 15, Target = true, TalentID = 17575 },										-- 참회
		[115750] = { Time = 120, TalentID = 17577 },													-- 눈부신 빛
		[114039] = { Time = 30, Target = true, TalentID = 17589 },										-- 정화의 손길
		[114158] = { Time = 60, TalentID = 17607 },														-- 빛의 망치
		[114157] = { Time = 60, Target = true, TalentID = 17609 },										-- 사형 선고
		[86659] = { Time = 180, Level = 75, Spec = L['Spec_Paladin_Protection'] },						-- 고대 왕의 수호자
		
		[1022] = { Time = 300, Reset = true, Target = true, Level = 48,									-- 보호의 손길
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and  SmartTracker.InspectCache[UserGUID].Talent[17593] then
					return 2						-- 특성: 온화함			
				end
			end
		},
		
		[31850] = { Time = 180, Level = 70,																-- 헌신적인 수호자
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					if InspectCache.Glyph[1144] then
						if GetTime() - CooldownCache.List[31850][1].ActivateTime < 10 then
							return Cooldown, true	-- 문양: 헌신적인 수호자
						else
							return 60
						end
					else
						return Cooldown
					end
				end
				
				return Cooldown, true
			end
		},
		[66235] = { Time = 0, Hidden = true,															-- 헌신적인 수호자 (회생 효과)
			Event = {
				SPELL_HEAL = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache and InspectCache.Glyph[1144] then
					CooldownCache.List[31850][1].NeedCalculating = nil
				end									-- 문양: 헌신적인 수호자
				
				return 0
			end
		},
		
		[1038] = { Time = 120, Target = true, Level = 66,												-- 구원의 손길
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Talent[17593] then
					return 2						-- 특성: 온화함
				end
			end
		},
		
		[6940] = { Time = 120, Target = true, Level = 80,												-- 희생의 손길
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Talent[17593] then
					return 2						-- 특성: 온화함
				end
			end,
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Paladin_Retribution'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157493]) then
						return Cooldown - 30
					else
						return Cooldown
					end
				end
				
				return Cooldown, true				-- 드레노어의 선물: 향상된 희생의 손길
			end
		},
		
		[1044] = { Time = 25, Target = true, Level = 52,												-- 자유의 손길
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Talent[17593] then
					return 2						-- 특성: 온화함
				end
			end,
			Func = function(Cooldown, CooldownCache, InspectCache, _, _, UserName, _, _, DestName)
				if InspectCache then
					if InspectCache.Glyph[1147] and UserName ~= DestName then
						return Cooldown - 5			-- 문양: 해방자
					else
						return Cooldown
					end
				end
				
				return Cooldown, true
			end
		},
		
		[31821] = { Time = 180, Level = 60,	Spec = L['Spec_Paladin_Holy'],								-- 헌신의 오라
			Glyph = {
				[184] = -60							-- 문양: 헌신의 오라
			}
		},
		
		[31884] = { Time = 120, Level = 72, Spec = L['Spec_Paladin_Retribution'],						-- 응징의 격노 (징기)
			Desc = ' ('..L['Spec_Paladin_Retribution']..')'
		},
		
		[31842] = { Time = 180, Level = 72, Spec = L['Spec_Paladin_Holy'],								-- 응징의 격노 (신기)
			Glyph = {
				[1203] = - 90						-- 문양: 자비로운 격노
			},
			Desc = ' ('..L['Spec_Paladin_Holy']..')'
		},
		
		[642] = { Time = 300, Reset = true, Level = 18,													-- 천상의 보호막
			Talent = {
				[17591] = -150						-- 특성: 불굴의 정신력
			}
		},
		
		[498] = { Time = 60, Level = 26,																-- 신의 가호
			Talent = {
				[17591] = -30						-- 특성: 불굴의 정신력
			}
		},
		
		[633] = { Time = 600, Reset = true, Target = true, Level = 16,									-- 신의 축복
			Glyph = {
				[198] = 120							-- 문양: 신앙
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown * (InspectCache.Talent[17591] and 1 / 2 or 1)
				end
				
				return Cooldown, true				-- 특성: 불굴의 정신력
			end
		},
		
		[853] = { Time = 60, Target = true, Level = 7,													-- 심판의 망치
			Talent = {
				[17573] = -30						-- 특성: 심판의 주먹
			}
		},
		
		[4987] = { Time = 8, Target = true, Level = 20,													-- 정화
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Glyph[1208] then
					return 2						-- 문양: 정화
				end
			end,
			Event = {
				SPELL_DISPEL = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown + (InspectCache.Glyph[1208] and 4 or 0)
				end
				
				return Cooldown, true				-- 문양: 정화
			end,
		},
		
		[157007] = { Time = 15, TalentID = 21671,														-- 통찰의 봉화
			Event = {
				SPELL_CAST_SUCCESS = true,
			}
		}
	}
	
	Info.SmartTracker_ConvertSpell[105593] = 853														-- 심판의 주먹
	Info.SmartTracker_ConvertSpell[114916] = 114157														-- 사형 선고
	Info.SmartTracker_ConvertSpell[114917] = 114157														-- 사형 선고 (집행 유예)
	
	Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[86659] = true											-- 고대 왕의 수호자
end


do	-- PRIEST DATA
	Info.SmartTracker_Data.PRIEST = {
		[32375] = { Time = 15, Level = 72 },															-- 대규모 무효화
		[10060] = { Time = 120, TalentID = 19765 },														-- 마력 주입
		[73325] = { Time = 90, Target = true, Level = 84 },												-- 신의의 도약
		[8122] = { Time = 45, TalentID = 19768 },														-- 영혼의 절규
		[15286] = { Time = 180, Level = 78, Spec = L['Spec_Priest_Shadow'] },							-- 흡혈의 선물
		[108945] = { Time = 45, TalentID = 19754 },														-- 천사의 보루
		[33206] = { Time = 180, Target = true, Level = 58, Spec = L['Spec_Priest_Discipline'] },		-- 고통 억제
		[81700] = { Time = 30, Level = 50, Spec = L['Spec_Priest_Discipline'] },						-- 대천사
		[62618] = { Time = 180, Level = 70, Spec = L['Spec_Priest_Discipline'] },						-- 신의 권능: 방벽
		[126135] = { Time = 180, Level = 36, Spec = L['Spec_Priest_Holy'] },							-- 빛샘
		[88625] = { Time = 30, Target = true, Level = 10, Spec = L['Spec_Priest_Holy'] },				-- 빛의 권능: 응징
		[47788] = { Time = 180, Target = true, Level = 70, Spec = L['Spec_Priest_Holy'] },				-- 수호 영혼
		[64843] = { Time = 180, Level = 78, Spec = L['Spec_Priest_Holy'] },								-- 천상의 찬가
		[19236] = { Time = 120, TalentID = 19752 },														-- 구원의 기도
		[112833] = { Time = 30, TalentID = 19753 },														-- 유령의 가면
		[123040] = { Time = 60, TalentID = 19769 },														-- 환각의 마귀
		[108920] = { Time = 30, TalentID = 19762 },														-- 공허 촉수
		[109964] = { Time = 60, TalentID = 21754 },														-- 혼의 너울
		
		[121536] = { Time = 10, Charge = 3, 19757 },													-- 천사의 깃털
		
		[527] = { Time = 8, Target = true, Level = 22,													-- 정화
			Spec = {
				[(L['Spec_Priest_Discipline'])] = true,
				[(L['Spec_Priest_Holy'])] = true
			},
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Glyph[1211] then
					return 2						-- 문양: 재계
				end
			end,
			Glyph = {
				[1211] = 4							-- 문양: 재계
			},
			Event = {
				SPELL_DISPEL = true
			}
		},
		
		[47585] = { Time = 120, Level = 60, Spec = L['Spec_Priest_Shadow'],								-- 분산
			Glyph = {
				[708] = -15							-- 문양: 분산
			}
		},
		
		[6346] = { Time = 180, Target = true, Level = 54,												-- 공포의 수호물
			Glyph = {
				[254] = -60							-- 문양: 공포의 수호물
			}
		},
		
		[586] = { Time = 30, Level = 24,																-- 소실
			Glyph = {
				[1158] = 60							-- 문양: 어둠의 마법
			}
		},
		
		[64044] = { Time = 45, Target = true, Level = 74, Spec = L['Spec_Priest_Shadow'],				-- 정신적 두려움
			Glyph = {
				[260] = -10							-- 문양: 정신적 두려움
			}
		},
		
		[15487] = { Time = 45, Target = true, Level = 52,												-- 침묵
			Spec = {
				[(L['Spec_Priest_Discipline'])] = true,
				[(L['Spec_Priest_Holy'])] = true
			},
			Glyph = {
				[1156] = -25						-- 문양: 침묵
			}
		},
	}
end


do	-- WARLOCK DATA
	Info.SmartTracker_Data.WARLOCK = {
		[18540] = { Time = 600, Reset = true, Level = 58 },												-- 파멸의 수호병 소환
		[120451] = { Time = 60, Level = 79, Spec = L['Spec_Warlock_Destruction'] },						-- 소로스의 불길
		[698] = { Time = 120, Level = 42 },																-- 소환 의식
		[1122] = { Time = 600, Reset = true, Level = 49 },												-- 지옥불정령 소환
		[30283] = { Time = 30, TalentID = 19286 },														-- 어둠의 격노
		[108359] = { Time = 120, TalentID = 19279 },													-- 어둠의 재생력
		[29858] = { Time = 120, Level = 66 },															-- 영혼 붕괴
		[29893] = { Time = 120, Level = 68 },															-- 영혼의 샘 창조
		[108416] = { Time = 60, TalentID = 19288 },														-- 희생의 서약
		[5484] = { Time = 40, TalentID = 19284 },														-- 공포의 울부짖음
		[6789] = { Time = 45, Target = true, TalentID = 19285 },										-- 죽음의 고리
		[110913] = { Time = 180, Reset = true, TalentID = 19289 },										-- 어둠의 거래
		[111397] = { Time = 60, TalentID = 19290 },														-- 핏빛 두려움
		[108482] = { Time = 120, TalentID = 19292 },													-- 해방된 의지
		[108501] = { Time = 120, TalentID = 19294 },													-- 흑마법서: 봉사
		[137587] = { Time = 60, TalentID = 19297 },														-- 킬제덴의 교활함
		[108508] = { Time = 60, TalentID = 19298 },														-- 만노로스의 분노
		[119899] = { Time = 30, Level = 56 },															-- 임프: 상처지지기
		[17767] = { Time = 120, Level = 55 },															-- 공허방랑자: 어둠의 보루
		[6360] = { Time = 25, Level = 56 },																-- 서큐버스: 채찍질
		[19647] = { Time = 24, Target = true, Level = 50 },												-- 지옥사냥개: 주문 잠금
		
		[20707] = { Time = 600, Reset = true, Target = true, Level = 18,								-- 영혼석
			Event = {
				SPELL_CAST_SUCCESS = true,
				SPELL_RESURRECT = true
			}
		},
		
		[80240] = { Time = 25, Target = true, Level = 36, Spec = L['Spec_Warlock_Destruction'],			-- 대혼란
			Glyph = {
				[1071] = 35
			},
			Event = {
				SPELL_CAST_SUCCESS = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache or CooldownCache.Spec then
					if (InspectCache.Spec or CooldownCache.Spec) == L['Spec_Warlock_Destruction'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157126]) then
						return Cooldown - 5				-- 드레노어의 선물: 향상된 대혼란
					else
						return Cooldown
					end
				end
				
				return Cooldown, true
			end
		},
		
		[77801] = { Time = 120, Level = 84,																-- 악마의 영혼
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Talent[19296] then
					return 2
				end
			end,
			Glyph = {
				[1173] = -60
			}
		},
		
		[48020] = { Time = 30, Level = 76,																-- 악마의 마법진: 순간이동
			Glyph = {
				[758] = -4
			}
		},
		
		[104773] = { Time = 180, Reset = true, Level = 64,												-- 영원한 결의
			Glyph = {
				[759] = -60,						-- 문양: 영원한 결의
				[1180] = 60,						-- 문양: 강화된 결의
				[911] = -180						-- 문양: 무한한 결의
			}
		},
		
		[755] = { Time = 0, Level = 11,																	-- 생명력 집중
			Spec = {
				[(L['Spec_Warlock_Affliction'])] = true,
				[(L['Spec_Warlock_Demonology'])] = true
			},
			Glyph = {
				[280] = 10
			}
		}
	}
	
	Info.SmartTracker_ConvertSpell[95750] = 20707														-- 영혼석 부활
	Info.SmartTracker_ConvertSpell[112927] = 18540														-- 공포수호병 소환
	Info.SmartTracker_ConvertSpell[112921] = 1122														-- 심연불정령 소환
	Info.SmartTracker_ConvertSpell[111859] = 108501														-- 흑마법서: 봉사 (임프)
	Info.SmartTracker_ConvertSpell[111895] = 108501														-- 흑마법서: 봉사 (공허방랑자)
	Info.SmartTracker_ConvertSpell[111896] = 108501														-- 흑마법서: 봉사 (서큐버스)
	Info.SmartTracker_ConvertSpell[111897] = 108501														-- 흑마법서: 봉사 (지옥사냥개)
	Info.SmartTracker_ConvertSpell[113858] = 77801														-- 악마의 영혼: 불안정
	Info.SmartTracker_ConvertSpell[113861] = 77801														-- 악마의 영혼: 지식
	Info.SmartTracker_ConvertSpell[113860] = 77801														-- 악마의 영혼: 불행
end