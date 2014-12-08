local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

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
		end,
	}
]]

do	-- WARRIOR DATA
	Info.SmartTracker_Data.WARRIOR = {
		[355] = { Time = 8, Target = true },								-- 도발
		[871] = { Time = 180 },												-- 방패의 벽
		[2565] = { Time = 12, Charge = 2 },									-- 방패 막기
		[12975] = { Time = 180 },											-- 최후의 저항
		[5246] = { Time = 90 },												-- 위협의 외침
		[103840] = { Time = 30 },											-- 예견된 승리
		[6552] = { Time = 15, Target = true },								-- 자루 공격
		[18499] = { Time = 30 },											-- 광전사의 격노
		[1160] = { Time = 60 },												-- 사기의 외침
		[23920] = { Time = 25 },											-- 주문 반사
		[3411] = { Time = 30, Target = true, NotToMe = true },				-- 가로막기
		[114192] = { Time = 180 },											-- 도발 깃발
		[55694] = { Time = 60 },											-- 격노의 재생력
		[107570] = { Time = 30, Target = true },							-- 폭풍망치
		[118000] = { Time = 60 },											-- 용의 포효
		[114028] = { Time = 30 },											-- 대규모 주문 반사
		[114029] = { Time = 30, Target = true, NotToMe = true },			-- 수비대장
		[114030] = { Time = 120, Target = true, NotToMe = true },			-- 경계
		[107574] = { Time = 180 },											-- 투신
		[12292] = { Time = 60 },											-- 피범벅
		[46924] = { Time = 60 },											-- 칼날폭풍
		[152277] = { Time = 60 },											-- 쇠날발톱
		[176289] = { Time = 45 },											-- 공성파쇄기
		[118038] = { Time = 120 },											-- 투사의 혼
		[97462] = { Time = 180 },											-- 재집결의 함성
		[1719] = { Time = 180 },											-- 무모한 희생
		
		
		[100] = { Time = 20, Target = true,									-- 돌진
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Talent[16035] then
					return 2
				end
			end,
			Talent = {
				[15775] = -8						-- 문양: 돌진
			}
		},
		
		[6544] = { Time = 45,												-- 영웅의 도약
			Func = function(Cooldown, CooldownCache, InspectCache)
				if (InspectCache and InspectCache.Spec or CooldownCache.Spec) == L['Spec_Warrior_Protection'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157449]) and CooldownCache.List[355] then
					CooldownCache.List[355][1].ActivateTime = GetTime() - 8 + SmartTracker.FADE_TIME
				end 								-- 드레노어의 선물: 영웅의 도약 연마
				
				return Cooldown
			end
		},
		
		[46968] = { Time = 40 },											-- 충격파
		[132168] = { Time = .5, Hidden = true,								-- 충격파 (쿨타임 감소용)
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
	
	Info.SmartTracker_ConvertSpell[178368] = 6544							-- 영웅의 도약
	Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[6544] = true					-- 영웅의 도약
end


do	-- HUNTER DATA
	Info.SmartTracker_Data.HUNTER = {
		[20736] = { Time = 8, Target = true },								-- 견제 사격
		[147362] = { Time = 24, Target = true },							-- 반격의 사격
		[1543] = { Time = 20 },												-- 섬광
		[172106] = { Time = 180 },											-- 여우의 상
		[51753] = { Time = 60 },											-- 위장술
		[19577] = { Time = 60 },											-- 위협
		[54216] = { Time = 45, Target = true },								-- 주인의 부름
		[109248] = { Time = 45 },											-- 구속의 사격
		[3045] = { Time = 120 },											-- 속사
		[19386] = { Time = 45, Target = true },								-- 비룡 쐐기
		[109304] = { Time = 120 },											-- 활기
		[109259] = { Time = 45, Target = true },							-- 강화 사격
		
		[5384] = { Time = 360,												-- 죽은척하기
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
		
		[19801] = { Time = 0, Target = true,								-- 평정의 사격
			Glyph = {
				[691] = 10							-- 특성: 평정의 사격
			}
		},
		
		[781] = { Time = 20,												-- 철수
			Talent = {
				[19364] = -10						-- 특성: 웅크린 호랑이, 숨은 키메라
			}
		},
		
		
		[19263] = { Time = 180, Charge = 2,									-- 공격 저지
			Talent = {
				[19364] = -60						-- 특성: 웅크린 호랑이, 숨은 키메라
			}
		},
		
		[34477] = { Time = 30, Target = true,								-- 눈속임
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
		
		[34600] = { Time = 30,												-- 뱀 덫
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
		
		[13813] = { Time = 30,												-- 폭발의 덫
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
		
		[1499] = { Time = 30,												-- 빙결의 덫
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
		
		[13809] = { Time = 30,												-- 얼음의 덫
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
	
	Info.SmartTracker_ConvertSpell[60192] = 1499							-- 빙결의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82939] = 13813							-- 폭발의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82941] = 13809							-- 얼음의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82948] = 34600							-- 뱀 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[148467] = 19263							-- 공저 (2분쿨)
	
	Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[5384] = true					-- 죽은척 하기
end


do	-- SHAMAN DATA
	Info.SmartTracker_Data.SHAMAN = {
		[108273] = { Time = 60 },											-- 바람걸음 토템
		[108270] = { Time = 60 },											-- 돌의 보루 토템
		[2484] = { Time = 30 },												-- 속박의 토템
		[8143] = { Time = 60 },												-- 진동의 토템
		[5394] = { Time = 30 },												-- 치유의 토템
		[2062] = { Time = 300, Reset = true },								-- 대지의 정령 토템
		[108269] = { Time = 45 },											-- 축전 토템
		[2825] = { Time = 300, Reset = true },								-- 피의 욕망
		[114049] = { Time = 180 },											-- 지배력
		[98008] = { Time = 180 },											-- 정신의 고리 토템
		[108280] = { Time = 180 },											-- 치유의 해일 토템
		[108271] = { Time = 90 },											-- 영혼 이동
		[51485] = { Time = 30 },											-- 구속의 토템
		[16166] = { Time = 120 },											-- 정기의 깨달음
		[108281] = { Time = 120 },											-- 고대의 인도
		[152256] = { Time = 300, Reset = true },							-- 폭풍의 정령 토템
		[152255] = { Time = 45 },											-- 마그마 분출
		[157153] = { Time = 30 },											-- 폭우의 토템
		
		[30884] = { Time = 30 },											-- 자연의 수호자
		
		[51886] = { Time = 8, Target = true,								-- 영혼 정화
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
		
		[108285] = { Time = 180,											-- 원소의 부름
			Func = function(Cooldown, CooldownCache)
				for _, SpellID in pairs({ 8177, 108273, 108270, 2484, 8143, 5394, 108269, 51485, 157153 }) do
					if CooldownCache.List[SpellID] then
						CooldownCache.List[SpellID][1].EraseThisCooltimeCache = true
					end
				end
				
				return Cooldown
			end
		},
		
		[16188] = { Time = 90,												-- 고대의 신속함
			Event = {
				SPELL_AURA_REMOVED = true
			}
		},
		
		[57994] = { Time = 12, Target = true,								-- 날카로운 바람
			Glyph = {
				[220] = 3							-- 문양: 날카로운 바람
			}
		},
		
		[8177] = { Time = 25,												-- 마법흡수 토템
			Glyph = {
				[227] = 20,							-- 문양: 마법흡수 토템
				[1165] = -3							-- 문양: 마법흡수
			}
		},
		
		[51514] = { Time = 45, Target = true,								-- 사술
			Glyph = {
				[753] = -10							-- 문양: 사술
			}
		},
		
		[58875] = { Time = 60,												-- 정령의 걸음
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown * (InspectCache.Glyph[214] and 3 / 4 or 1)
				end
				
				return Cooldown, true				-- 문양: 정령의 걸음
			end
		},
		
		[370] = { Time = 0, Target = true,									-- 정화
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown + (InspectCache.Glyph[216] and 6 or 0)
				end
				
				return Cooldown, true				-- 문양: 정화
			end
		},
		
		[51490] = { Time = 35,												-- 천둥폭풍
			Glyph = {
				[735] = -10							-- 문양: 천둥
			}
		},
		
		[51533] = { Time = 120,												-- 야수 정령
			Glyph = {
				[1163] = -60						-- 문양: 덧없는 정령
			}
		},
		
		[2894] = { Time = 300, Reset = true,								-- 불의 정령 토템
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown * (InspectCache.Glyph[217] and 1 / 2 or 1)
				end
				
				return Cooldown, true				-- 문양: 불의 정령 토템
			end
		},
		
		[79206] = { Time = 120,												-- 영혼나그네의 은총
			Glyph = {
				[1170] = -60						-- 문양: 영혼나그네의 집중
			}
		},
		
		[30823] = { Time = 60,												-- 주술의 분노
			Glyph = {
				[1168] = 60							-- 문양: 주술의 결의
			}
		}
	}
	
	Info.SmartTracker_ConvertSpell[165339] = 114049							-- 지배력 (정기)
	Info.SmartTracker_ConvertSpell[165341] = 114049							-- 지배력 (고양)
	Info.SmartTracker_ConvertSpell[165344] = 114049							-- 지배력 (고양)
end


do	-- MONK DATA
	Info.SmartTracker_Data.MONK = {
		[116841] = { Time = 30 },											-- 범의 욕망
		[115546] = { Time = 8, Target = true },								-- 조롱
		[113656] = { Time = 25 },											-- 분노의 주먹
		[101545] = { Time = 25 },											-- 비룡차기
		[122470] = { Time = 90, Target = true },							-- 업보의 손아귀
		[115203] = { Time = 180 },											-- 강화주
		[137562] = { Time = 120 },											-- 민활주
		[116705] = { Time = 15, Target = true },							-- 손날 찌르기
		[115288] = { Time = 60 },											-- 기력 회복주
		[115078] = { Time = 15, Target = true },							-- 마비
		[115176] = { Time = 180 },											-- 명상
		--[101643] = { Time = 45 },											-- 해탈
		[116680] = { Time = 45 },											-- 집중의 천둥 차
		[115310] = { Time = 180 },											-- 재활
		[115399] = { Time = 60, Charge = 2 },								-- 원기주
		[116844] = { Time = 45, Target = true },							-- 평화의 고리
		[119392] = { Time = 30 },											-- 황소 쇄도
		[119381] = { Time = 45 },											-- 팽이 차기
		[122278] = { Time = 90 },											-- 해악 감퇴
		[122783] = { Time = 90 },											-- 마법 해소
		[123904] = { Time = 180 },											-- 백호 쉬엔의 원령
		[152173] = { Time = 90 },											-- 평온
		[157535] = { Time = 90 },											-- 옥룡의 숨결
		
		[115450] = { Time = 8, Target = true,								-- 해독
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
		
		[116849] = { Time = 120, Target = true,								-- 기의 고치
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
		
		[115080] = { Time = 90, Target = true,								-- 절명의 손길
			Func = function(Cooldown, _, InspectCache)
				if InspectCache then
					return Cooldown + (InspectCache.Glyph[1014] and 120 or 0)
				end
				
				return Cooldown, true				-- 문양: 절명의 손길
			end
		},
		
		[119996] = { Time = 25,												-- 해탈: 전환
			Glyph = {
				[1011] = -5							-- 문양: 해탈
			}
		},
		
		[115295] = { Time = 30,												-- 방어 자세
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
		[31224] = { Time = 60 },											-- 그림자 망토
		[408] = { Time = 20, Target = true },								-- 급소 가격
		[51713] = { Time = 60 },											-- 어둠의 춤
		[76577] = { Time = 180 },											-- 연막탄
		[114018] = { Time = 300 },											-- 은폐의 장막
		[57934] = { Time = 30, Target = true },								-- 속임수 거래
		[2094] = { Time = 120, Target = true },								-- 실명
		[2983] = { Time = 60 },												-- 전력 질주
		[1725] = { Time = 30 },												-- 혼란
		[1776] = { Time = 10, Target = true },								-- 후려치기
		[74001] = { Time = 120 },											-- 전투 준비
		[31230] = { Time = 90 },											-- 구사일생
		[36554] = { Time = 20, Target = true },								-- 그림자 밟기
		[152151] = { Time = 120, Target = true }, 							-- 그림자 분신
		[79140] = { Time = 120, Target = true },							-- 원한
		[51690] = { Time = 120 },											-- 광기의 학살자
		[13750] = { Time = 180 },											-- 아드레날린 촉진
		
		[5938] = { Time = 10, Target = true,								-- 독칼
			Glyph = {
				[410] = -3							-- 문양: 독칼
			}
		},
		
		[5277] = { Time = 120,												-- 회피
			Glyph = {
				[1160] = -30						-- 문양: 교묘함
			}
		},
		
		[137619] = { Time = 60, Target = true,								-- 죽음의 표적
			
		},
		
		[1766] = { Time = 15, Target = true,								-- 발차기
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
		
		[14185] = { Time = 300, Reset = true,								-- 마음가짐
			-- 전질, 소멸, 회피
		},
		
		[1856] = { Time = 90,												-- 소멸
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
		[48707] = { Time = 45 },											-- 대마법 보호막
		[49222] = { Time = 60 },											-- 뼈의 보호막
		[42650] = { Time = 600, Reset = true },								-- 사자의 군대
		[47568] = { Time = 300 },											-- 룬 무기 강화
		[61999] = { Time = 600, Target = true },							-- 아군 되살리기
		[56222] = { Time = 8, Target = true },								-- 어둠의 명령
		[108194] = { Time = 30, Target = true },							-- 어둠의 질식
		[48743] = { Time = 120 },											-- 죽음의 서약
		[55233] = { Time = 60 },											-- 흡혈
		[49028] = { Time = 90 },											-- 춤추는 룬 무기
		[51271] = { Time = 60 },											-- 얼음 기둥
		[47476] = { Time = 60, Target = true },								-- 질식시키기
		[49206] = { Time = 180 },											-- 가고일 부르기
		[115989] = { Time = 90 },											-- 부정의 파멸충
		[49039] = { Time = 120 },											-- 리치의 혼
		[51052] = { Time = 120 },											-- 대마법 지대
		[108199] = { Time = 60, Target = true },							-- 고어핀드의 손아귀
		[108200] = { Time = 60 },											-- 냉혹한 겨울
		[108201] = { Time = 120 },											-- 더렵혀진 대지
		[152280] = { Time = 30 },											-- 파멸
		[152279] = { Time = 120 },											-- 신드라고사의 숨결
		
		[48982] = { Time = 40, Charge = 2,									-- 룬 전환
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
		
		[77606] = { Time = 60, Target = true,								-- 어둠 복제
			Glyph = {
				[769] = -30							-- 문양: 어둠 복제
			}
		},
		
		[48792] = { Time = 180,												-- 얼음같은 인내력
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					return Cooldown * (InspectCache.Glyph[515] and 1 / 2 or 1)
				end
				
				return Cooldown, true				-- 문양: 얼음같은 인내력
			end
		},
		
		[47528] = { Time = 15, Target = true,								-- 정신 얼리기
			Glyph = {
				[527] = -1							-- 문양: 정신 얼리기
			}
		},
		
		[49576] = { Time = 25, NeedParameter = true,						-- 죽음의 손아귀
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
		[44572] = { Time = 30, Target = true },								-- 동결
		[66] = { Time = 300 },												-- 투명화
		[110959] = { Time = 90 },											-- 상급 투명화
		[159916] = { Time = 120 },											-- 마법 증폭
		[113724] = { Time = 45 },											-- 서리 고리
		[157997] = { Time = 25, Charge = 2 },								-- 서리 회오리
		[157980] = { Time = 25, Charge = 2 },								-- 초신성
		[157981] = { Time = 25, Charge = 2 },								-- 화염 폭풍
		[11426] = { Time = 25 },											-- 얼음 보호막
		[12472] = { Time = 180 },											-- 얼음 핏줄
		[80353] = { Time = 300, Reset = true },								-- 시간 왜곡
		[108839] = { Time = 20, Charge = 3 },								-- 얼음발
		[45438] = { Time = 300 },											-- 얼음 방패
		[43987] = { Time = 60 },											-- 원기 회복의 식탁 창조
		[157913] = { Time = 45 },											-- 무의 존재
		[108843] = { Time = 25 },											-- 타오르는 속도
		[108978] = { Time = 90 },											-- 시간 돌리기
		[111264] = { Time = 20, Target = true },							-- 얼음 수호물
		[102051] = { Time = 20, Target = true },							-- 서리투성이 턱
		[55342] = { Time = 120 },											-- 환영 복제
		[152087] = { Time = 90 },											-- 굴절의 수정
		[31661] = { Time = 20 },											-- 용의 숨결
		
		[1953] = { Time = 15,												-- 점멸
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Glyph[325] then
					return 2						-- 문양: 신속한 이동
				end
			end
		},
		
		[12051] = { Time = 120,												-- 환기
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
		
		[11129] = { Time = 45, Target = true,								-- 발화
			Glyph = {
				[316] = 45							-- 문양: 발화
			}
		},
		[133] = { Time = 0, Hidden = true, NeedParameter = true,			-- 화염구 (덧불 특성용)
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
		[44614] = { Time = 0, Hidden = true, NeedParameter = true,			-- 얼음불꽃 화살 (덧불 특성용)
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
		[11366] = { Time = 0, Hidden = true, NeedParameter = true,			-- 불덩이 작렬 (덧불 특성용)
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
		[108853] = { Time = 0, Hidden = true,								-- 지옥불 작렬 (덧불 특성용)
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
		
		
		
		
		
		
		[12043] = { Time = 90,												-- 냉정
			Event = {
				SPELL_AURA_REMOVED = true
			}
		},
		
		[2139] = { Time = 24, Target = true,								-- 마법 차단
			Glyph = {
				[871] = 4							-- 문양: 마법 차단
			}
		},
		
		[12042] = { Time = 90,												-- 신비의 마법 강화
			Glyph = {
				[651] = 90							-- 문양: 신비의 마법 강화
			}
		},
		
		[122] = { Time = 30,												-- 얼음 회오리
			Glyph = {
				[318] = -5							-- 문양: 얼음 회오리
			}
		},
		
		[475] = { Time = 8, Target = true,									-- 저주 해제
			Event = {
				SPELL_DISPEL = true
			},
		},
		
		[11958] = { Time = 180 },											-- 매서운 한파
	}
end


do	-- DRUID DATA
	Info.SmartTracker_Data.DRUID = {
		[106839] = { Time = 15, Target = true },							-- 두개골 강타
		[61336] = { Time = 120, Charge = 2 },								-- 생존 본능
		[1850] = { Time = 180 },											-- 질주
		[6795] = { Time = 8, Target = true },								-- 포효
		[5217] = { Time = 30 },												-- 호랑이의 분노
		[20484] = { Time = 600, Target = true, Reset = true },				-- 환생
		[77764] = { Time = 120 },											-- 쇄도의 포효
		[22812] = { Time = 60 },											-- 나무 껍질
		[112071] = { Time = 180 },											-- 천체의 정렬
		[78675] = { Time = 60, Target = true },								-- 태양 광선
		[62606] = { Time = 12, Charge = 2 },								-- 야생의 방어
		[102342] = { Time = 60, Target = true },							-- 무쇠껍질
		[132158] = { Time = 60 },											-- 자연의 신속함
		[740] = { Time = 180, Reset = true },								-- 평온
		[102280] = { Time = 30 },											-- 야수 탈주
		[108238] = { Time = 120 },											-- 소생
		[102351] = { Time = 30 },											-- 세나리온 수호물
		[102359] = { Time = 30, Target = true },							-- 대규모 휘감기
		[132469] = { Time = 30 },											-- 태풍
		[99] = { Time = 30 },												-- 행동 불가의 포효
		[102793] = { Time = 60 },											-- 우르솔의 회오리
		[5211] = { Time = 50 },												-- 거센 강타
		[108292] = { Time = 360, Reset = true },							-- 야생의 정수
		[124974] = { Time = 90 },											-- 자연의 경계
		[155835] = { Time = 60 },											-- 뻣뻣한 털
		
		
		[102401] = { Time = 15, Target = true,								-- 야생의 돌진
			Event = {
				SPELL_CAST_SUCCESS = true
			}
		},
		
		[50334] = { Time = 60 },											-- 광폭화 (수호)
		[106951] = { Time = 180 },											-- 광폭화 (야성)
		
		[102558] = { Time = 180 },											-- 화신: 우르속의 자손 (수호)
		[102543] = { Time = 180 },											-- 화신: 밀림의 왕 (야성)
		[102560] = { Time = 180 },											-- 화신: 엘룬의 선택 (조화)
		[33891] = { Time = 180 },											-- 화신: 생명의 나무 (회복)
		
		[102706] = { Time = 20, Charge = 2 },								-- 자연의 군대 (수호)
		[102703] = { Time = 20, Charge = 2 },								-- 자연의 군대 (야성)
		[33831] = { Time = 20, Charge = 2 },								-- 자연의 군대 (조화)
		[102693] = { Time = 20, Charge = 2 },								-- 자연의 군대 (회복)
		
		[88423] = { Time = 8, Target = true,								-- 자연의 치유력
			Event = {
				SPELL_DISPEL = true
			}
		},
		
		[2782] = { Time = 8, Target = true,									-- 해제
			Event = {
				SPELL_DISPEL = true
			}
		},
	}
	
	Info.SmartTracker_ConvertSpell[77761] = 77764							-- 쇄도의 포효
	Info.SmartTracker_ConvertSpell[106898] = 77764							-- 쇄도의 포효
	Info.SmartTracker_ConvertSpell[16979] = 102401							-- 야생의 돌진 (곰)
	Info.SmartTracker_ConvertSpell[49376] = 102401							-- 야생의 돌진 (표범)
	Info.SmartTracker_ConvertSpell[102383] = 102401							-- 야생의 돌진 (올빼미)
	Info.SmartTracker_ConvertSpell[102416] = 102401							-- 야생의 돌진 (바다표범)
	Info.SmartTracker_ConvertSpell[102417] = 102401							-- 야생의 돌진 (순록)
end


do	-- PALADIN DATA
	Info.SmartTracker_Data.PALADIN = {
		[85499] = { Time = 45 },											-- 빛의 속도
		[96231] = { Time = 15, Target = true },								-- 비난
		[105809] = { Time = 120 },											-- 신성한 복수자
		[10326] = { Time = 15, Target = true },								-- 악령 퇴치
		[32124] = { Time = 8, Target = true },								-- 집행
		[20066] = { Time = 15, Target = true },								-- 참회
		[115750] = { Time = 120 },											-- 눈부신 빛
		[114039] = { Time = 30, Target = true },							-- 정화의 손길
		[114158] = { Time = 60 },											-- 빛의 망치
		[114157] = { Time = 60, Target = true },							-- 사형 선고
		[86659] = { Time = 180 },											-- 고대 왕의 수호자
		
		[1022] = { Time = 300, Reset = true, Target = true,					-- 보호의 손길
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and  SmartTracker.InspectCache[UserGUID].Talent[17593] then
					return 2						-- 특성: 온화함			
				end
			end
		},
		
		[31850] = { Time = 180,												-- 헌신적인 수호자
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
		[66235] = { Time = 0, Hidden = 'Both',								-- 헌신적인 수호자 (회생 효과)
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
		
		[1038] = { Time = 120, Target = true,								-- 구원의 손길
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Talent[17593] then
					return 2						-- 특성: 온화함
				end
			end
		},
		
		[6940] = { Time = 120, Target = true,								-- 희생의 손길
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
		
		[1044] = { Time = 25, Target = true,								-- 자유의 손길
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
		
		[31821] = { Time = 180,												-- 헌신의 오라
			Glyph = {
				[184] = -60							-- 문양: 헌신의 오라
			}
		},
		
		[31884] = { Time = 180,												-- 응징의 격노 (징기)
			Desc = ' ('..L['Spec_Paladin_Retribution']..')'
		},
		
		[31842] = { Time = 180,												-- 응징의 격노 (신기)
			Glyph = {
				[1203] = - 90						-- 문양: 자비로운 격노
			},
			Desc = ' ('..L['Spec_Paladin_Holy']..')'
		},
		
		[642] = { Time = 300, Reset = true,									-- 천상의 보호막
			Talent = {
				[17591] = -150						-- 특성: 불굴의 정신력
			}
		},
		
		[498] = { Time = 60,												-- 신의 가호
			Talent = {
				[17591] = -30						-- 특성: 불굴의 정신력
			}
		},
		
		[633] = { Time = 600, Reset = true, Target = true,					-- 신의 축복
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
		
		[853] = { Time = 60, Target = true,									-- 심판의 망치
			Talent = {
				[17573] = -30						-- 특성: 심판의 주먹
			}
		},
		
		[4987] = { Time = 8, Target = true,									-- 정화
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
		
		[157007] = { Time = 15,												-- 통찰의 봉화
			Event = {
				SPELL_CAST_SUCCESS = true,
			}
		}
	}
	
	Info.SmartTracker_ConvertSpell[105593] = 853							-- 심판의 주먹
	Info.SmartTracker_ConvertSpell[114916] = 114157							-- 사형 선고
	Info.SmartTracker_ConvertSpell[114917] = 114157							-- 사형 선고 (집행 유예)
	
	Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[86659] = true				-- 고대 왕의 수호자
end


do	-- PRIEST DATA
	Info.SmartTracker_Data.PRIEST = {
		[32375] = { Time = 15 },											-- 대규모 무효화
		[10060] = { Time = 120 },											-- 마력 주입
		[73325] = { Time = 90, Target = true },								-- 신의의 도약
		[8122] = { Time = 45 },												-- 영혼의 절규
		[15286] = { Time = 180 },											-- 흡혈의 선물
		[108945] = { Time = 45 },											-- 천사의 보루
		[33206] = { Time = 180, Target = true },							-- 고통 억제
		[81700] = { Time = 30 },											-- 대천사
		[62618] = { Time = 180 },											-- 신의 권능: 방벽
		[126135] = { Time = 180 },											-- 빛샘
		[88625] = { Time = 30, Target = true },								-- 빛의 권능: 응징
		[47788] = { Time = 180, Target = true },							-- 수호 영혼
		[64843] = { Time = 180 },											-- 천상의 찬가
		[19236] = { Time = 120 },											-- 구원의 기도
		[112833] = { Time = 30 },											-- 유령의 가면
		[123040] = { Time = 60 },											-- 환각의 마귀
		[108920] = { Time = 30 },											-- 공허 촉수
		[109964] = { Time = 60 },											-- 혼의 너울
		
		[121536] = { Time = 10, Charge = 3 },								-- 천사의 깃털
		
		[527] = { Time = 8, Target = true,									-- 정화
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
		
		[47585] = { Time = 120,												-- 분산
			Glyph = {
				[708] = -15							-- 문양: 분산
			}
		},
		
		[6346] = { Time = 180, Target = true,								-- 공포의 수호물
			Glyph = {
				[254] = -60							-- 문양: 공포의 수호물
			}
		},
		
		[586] = { Time = 30,												-- 소실
			Glyph = {
				[1158] = 60							-- 문양: 어둠의 마법
			}
		},
		
		[64044] = { Time = 45, Target = true,								-- 정신적 두려움
			Glyph = {
				[260] = -10							-- 문양: 정신적 두려움
			}
		},
		
		[15487] = { Time = 45, Target = true,								-- 침묵
			Glyph = {
				[1156] = -25						-- 문양: 침묵
			}
		},
	}
	
	
end


do	-- WARLOCK DATA
	Info.SmartTracker_Data.WARLOCK = {
		[18540] = { Time = 600, Reset = true },								-- 파멸의 수호병 소환
		[120451] = { Time = 60 },											-- 소로스의 불길
		[698] = { Time = 120 },												-- 소환 의식
		[1122] = { Time = 600, Reset = true },								-- 지옥불정령 소환
		[30283] = { Time = 30 },											-- 어둠의 격노
		[108359] = { Time = 120 },											-- 어둠의 재생력
		[29858] = { Time = 120 },											-- 영혼 붕괴
		[29893] = { Time = 120 },											-- 영혼의 샘 창조
		[108416] = { Time = 60 },											-- 희생의 서약
		[5484] = { Time = 40 },												-- 공포의 울부짖음
		[6789] = { Time = 45, Target = true },								-- 죽음의 고리
		[110913] = { Time = 180, Reset = true },							-- 어둠의 거래
		[111397] = { Time = 60 },											-- 핏빛 두려움
		[108482] = { Time = 120 },											-- 해방된 의지
		[108501] = { Time = 120 },											-- 흑마법서: 봉사
		[137587] = { Time = 60 },											-- 킬제덴의 교활함
		[108508] = { Time = 60 },											-- 만노로스의 분노
		[119899] = { Time = 30 },											-- 임프: 상처지지기
		[17767] = { Time = 120 },											-- 공허방랑자: 어둠의 보루
		[6360] = { Time = 25 },												-- 서큐버스: 채찍질
		[19647] = { Time = 24, Target = true },								-- 지옥사냥개: 주문 잠금
		
		[20707] = { Time = 600, Reset = true, Target = true,				-- 영혼석
			Event = {
				SPELL_CAST_SUCCESS = true,
				SPELL_RESURRECT = true
			}
		},
		
		[80240] = { Time = 25, Target = true,								-- 대혼란
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
		
		
		[77801] = { Time = 120,												-- 악마의 영혼
			Charge = function(UserGUID)
				if SmartTracker.InspectCache[UserGUID] and SmartTracker.InspectCache[UserGUID].Talent[19296] then
					return 2
				end
			end,
			Glyph = {
				[1173] = -60
			}
		},
		
		
		[48020] = { Time = 30,												-- 악마의 마법진: 순간이동
			Glyph = {
				[758] = -4
			}
		},
		
		
		[104773] = { Time = 180, Reset = true,								-- 영원한 결의
			Glyph = {
				[759] = -60,						-- 문양: 영원한 결의
				[1180] = 60,						-- 문양: 강화된 결의
				[911] = -180						-- 문양: 무한한 결의
			}
		},
		
		
		[755] = { Time = 0,													-- 생명력 집중
			Glyph = {
				[280] = 10
			}
		}
	}
	
	Info.SmartTracker_ConvertSpell[95750] = 20707							-- 영혼석 부활
	Info.SmartTracker_ConvertSpell[112927] = 18540							-- 공포수호병 소환
	Info.SmartTracker_ConvertSpell[112921] = 1122							-- 심연불정령 소환
	Info.SmartTracker_ConvertSpell[111859] = 108501							-- 흑마법서: 봉사 (임프)
	Info.SmartTracker_ConvertSpell[111895] = 108501							-- 흑마법서: 봉사 (공허방랑자)
	Info.SmartTracker_ConvertSpell[111896] = 108501							-- 흑마법서: 봉사 (서큐버스)
	Info.SmartTracker_ConvertSpell[111897] = 108501							-- 흑마법서: 봉사 (지옥사냥개)
	Info.SmartTracker_ConvertSpell[113858] = 77801							-- 악마의 영혼: 불안정
	Info.SmartTracker_ConvertSpell[113861] = 77801							-- 악마의 영혼: 지식
	Info.SmartTracker_ConvertSpell[113860] = 77801							-- 악마의 영혼: 불행
end