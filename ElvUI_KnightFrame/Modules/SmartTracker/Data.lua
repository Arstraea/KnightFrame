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
		Charge		= Spell that chargable. (Boolean)
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

--[[
	
	['WARRIOR'] = {
		
	},
	['SHAMAN'] = {
		
	},
	['MONK'] = {
		
	},
	['ROGUE'] = {
		
	},
	['DEATHKNIGHT'] = {
		
	},
	['DRUID'] = {
		
	},
	['PRIEST'] = {
		
	},
]]

do	-- WARRIOR DATA
	Info.SmartTracker_Data.WARRIOR = {
		[355] = { Time = 8, Target = true },								-- 도발
		[871] = { Time = 180 },												-- 방패의 벽
		[2565] = { Time = 12, Charge = true },								-- 방패 막기
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
		
		
		[100] = { Time = 20, Target = true, Charge = true,					-- 돌진
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
		
		[46968] = { Time = 40,												-- 충격파
			Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName, ParamTable)
				if CooldownCache.List[SpellID][1].Count >= 3 then
					return Cooldown - 20
				end
				
				return Cooldown
			end
		},
	}
	
	
end


do	-- HUNTER DATA
	Info.SmartTracker_Data.HUNTER = {
		[20736] = { Time = 8, Target = true },								-- 견제 사격
		[147362] = { Time = 24, Target = true },							-- 반격의 사격
		[34600] = { Time = 30 },											-- 뱀 덫
		[13813] = { Time = 30 },											-- 폭발의 덫
		[1499] = { Time = 30 },												-- 빙결의 덫
		[1543] = { Time = 20 },												-- 섬광
		[13809] = { Time = 30 },											-- 얼음의 덫
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
		
		
		[19263] = { Time = 180, Charge = true,								-- 공격 저지
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
					for i = 1, NUM_GLYPH_SLOTS do
						if InspectCache.Glyph[i] == 361 then
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
								
								return 0			-- 문양: 눈속임
							end
						end
					end
				end
				
				return Cooldown, true
			end,
		}
	}
	
	Info.SmartTracker_ConvertSpell[60192] = 1499							-- 빙결의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82939] = 13813							-- 폭발의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82941] = 13809							-- 얼음의 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[82948] = 34600							-- 뱀 덫 (덫 투척)
	Info.SmartTracker_ConvertSpell[148467] = 19263							-- 공저 (2분쿨)
	
	Info.SmartTracker_SPELL_CAST_SUCCESS_Spell[5384] = true					-- 죽은척 하기
end


do	-- MONK DATA
	
end


do	-- MAGE DATA
	Info.SmartTracker_Data.MAGE = {
		[44572] = { Time = 30, Target = true },								-- 동결
		[66] = { Time = 300 },												-- 투명화
		[110959] = { Time = 90 },											-- 상급 투명화
		[159916] = { Time = 120 },											-- 마법 증폭
		[113724] = { Time = 45 },											-- 서리 고리
		[157997] = { Time = 25, Charge = true },							-- 서리 회오리
		[157980] = { Time = 25, Charge = true },							-- 초신성
		[157981] = { Time = 25, Charge = true },							-- 화염 폭풍
		[11426] = { Time = 25 },											-- 얼음 보호막
		[12472] = { Time = 180 },											-- 얼음 핏줄
		[80353] = { Time = 300, Reset = true },								-- 시간 왜곡
		[108839] = { Time = 20, Charge = true },							-- 얼음발
		[45438] = { Time = 300 },											-- 얼음 방패
		[43987] = { Time = 60 },											-- 원기 회복의 식탁 창조
		[1953] = { Time = 15, Charge = true },								-- 점멸
		[157913] = { Time = 45 },											-- 무의 존재
		[108843] = { Time = 25 },											-- 타오르는 속도
		[108978] = { Time = 90 },											-- 시간 돌리기
		[111264] = { Time = 20, Target = true },							-- 얼음 수호물
		[102051] = { Time = 20, Target = true },							-- 서리투성이 턱
		[55342] = { Time = 120 },											-- 환영 복제
		[152087] = { Time = 90 },											-- 굴절의 수정
		[31661] = { Time = 20 },											-- 용의 숨결
		
		[12051] = { Time = 120,												-- 환기
			Func = function(Cooldown, CooldownCache, InspectCache)
				if (InspectCache and InspectCache.Spec or CooldownCache.Spec) == L['Spec_Mage_Arcane'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157493]) then
					return Cooldown - 30			-- 환기 연마
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
				if InspectCache and InspectCache.Spec == L['Spec_Mage_Fire'] and InspectCache.Talent[21631] and ParamTable[7] and CooldownCache.List[11129] then
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
				if InspectCache and InspectCache.Spec == L['Spec_Mage_Fire'] and InspectCache.Talent[21631] and ParamTable[7] and CooldownCache.List[11129] then
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
				if InspectCache and InspectCache.Spec == L['Spec_Mage_Fire'] and InspectCache.Talent[21631] and ParamTable[7] and CooldownCache.List[11129] then
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
				if InspectCache and InspectCache.Spec == L['Spec_Mage_Fire'] and InspectCache.Talent[21631] and CooldownCache.List[11129] then
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


do	-- PALADIN DATA
	Info.SmartTracker_Data.PALADIN = {
		[85499] = { Time = 45 },											-- 빛의 속도
		[1022] = { Time = 300, Reset = true, Target = true, Charge = true },-- 보호의 손길
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
		
		[31850] = { Time = 180,												-- 헌신적인 수호자
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					for i = 1, NUM_GLYPH_SLOTS do
						if InspectCache.Glyph[i] == 1144 and GetTime() - CooldownCache.List[31850][1].ActivateTime < 10 then
							return Cooldown, true	-- 문양: 헌신적인 수호자
						end
					end
					
					return 60
				end
				
				return Cooldown, true
			end
		},
		[66235] = { Time = 0, Hidden = 'Both',								-- 헌신적인 수호자 (회생 효과)
			Event = {
				SPELL_HEAL = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					for i = 1, NUM_GLYPH_SLOTS do
						if InspectCache.Glyph[i] == 1144 then
							CooldownCache.List[31850][1].NeedCalculating = nil
							return 0				-- 문양: 헌신적인 수호자
						end
					end
				end
				
				return 0
			end
		},
		
		[1038] = { Time = 120, Target = true, Charge = true },				-- 구원의 손길
		
		[6940] = { Time = 120, Target = true, Charge = true,				-- 희생의 손길
			Func = function(Cooldown, CooldownCache, InspectCache)
				if (InspectCache and InspectCache.Spec or CooldownCache.Spec) == L['Spec_Paladin_Retribution'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157493]) then
					return Cooldown - 30			-- 향상된 희생의 손길
				end
				
				return Cooldown, true
			end
		},
		
		[1044] = { Time = 25, Target = true, Charge = true,					-- 자유의 손길
			Func = function(Cooldown, CooldownCache, InspectCache, _, _, UserName, _, _, DestName)
				if InspectCache then
					for i = 1, NUM_GLYPH_SLOTS do
						if InspectCache.Glyph[i] == 1147 and UserName ~= DestName then
							return Cooldown - 5		-- 문양: 해방자
						end
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
					for i = 1, MAX_TALENT_TIERS * NUM_TALENT_COLUMNS do
						if Data.Talent and Data.Talent[i] == 17591 then
							return Cooldown / 2		-- 특성: 불굴의 정신력
						end
					end
				end
				
				return Cooldown, true
			end
		},
		
		[853] = { Time = 60, Target = true,									-- 심판의 망치
			Talent = {
				[17573] = -30						-- 특성: 심판의 주먹
			}
		},
		
		[4987] = { Time = 8, Target = true, Charge = true,					-- 정화
			Event = {
				SPELL_DISPEL = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if InspectCache then
					for i = 1, NUM_GLYPH_SLOTS do
						if InspectCache.Glyph[i] == 1208 then
							return Cooldown + 4		-- 문양: 정화
						end
					end
				end
				
				return Cooldown, true
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


do	-- WARLOCK DATA
	Info.SmartTracker_Data.WARLOCK = {
		[18540] = { Time = 600, Reset = true },								-- 파멸의 수호병 소환
		[120451] = { Time = 60 },											-- 소로스의 불길
		[698] = { Time = 120 },												-- 소환 의식
		[1122] = { Time = 600, Reset = true },								-- 지옥불정령 소환
		[30283] = { Time = 30 },											-- 어둠의 격노
		[108359] = { Time = 120 },											-- 어둠의 재생력
		[29858] = { Time = 120 },											-- 영혼 붕괴
		[20707] = { Time = 600, Reset = true, Target = true },				-- 영혼석
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
		
		
		[80240] = { Time = 25, Target = true, NotToMe = true,				-- 대혼란
			Glyph = {
				[1071] = 35
			},
			Func = function(Cooldown, CooldownCache, InspectCache)
				if (InspectCache and InspectCache.Spec or CooldownCache.Spec) == L['Spec_Warlock_Destruction'] and (UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.DraenorePerks and InspectCache.DraenorePerks[157126]) then
					return Cooldown - 5				-- 향상된 대혼란
				end
				
				return Cooldown, true
			end
		},
		
		
		[77801] = { Time = 120, Charge = true,								-- 악마의 영혼
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