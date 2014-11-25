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
		Time	= Cooltime - Number
		Reset	= Spell that reset when boss combat is end - Boolean
		Target	= Target type spell - Boolean
		Charge	= Spell that chargable - Boolean
		NotToMe	= Spell that can't target me - Boolean
		Hidden	= Spell that not displayed in config - Boolean
		
		Spec = {
			[Global string of Spec in L table] = ChangedCooltime - Number
			
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
				   /run for i=1,GetNumGlyphs() do print(GetGlyphInfo(i)) end
		},
		
		Event = {
			[Event] = false or ChangedCooltime - Number
			
			#NOTE: If we must make a specific event condition for catching spell then use this parts.
			
			#NOTE: If you submit the event and value is exists then system will catch and register that spell by this event in combat log
				   and if value is false then system will block this spell that catched by this event.
			
			#NOTE: If there is no specific condition in this area then system will catch this following event
				    = SPELL_RESURRECT, SPELL_AURA_APPLIED, SPELL_AURA_REFRESH, SPELL_CAST_SUCCESS, SPELL_INTERRUPT, SPELL_SUMMON
		},
		
		
		Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName)
			#NOTE: If spell needs specific calcurating by difficult condition then use func.
		end,
	}
	
]]

--[[
	
	['WARRIOR'] = {
		
	},
	['HUNTER'] = {
		
	},
	['SHAMAN'] = {
		
	},
	['MONK'] = {
		
	},
	['ROGUE'] = {
		
	},
	['DEATHKNIGHT'] = {
		
	},
	['MAGE'] = {
		
	},
	['DRUID'] = {
		
	},
	PALADIN = {
		
	},
	['PRIEST'] = {
		
	},
]]

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
			Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName)
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
		[66235] = { Time = 0, Hidden = true,								-- 헌신적인 수호자 (회생 효과)
			Event = {
				SPELL_HEAL = true
			},
			Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName)
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
			Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName)
				local UserSpec = InspectCache and InspectCache.Spec or CooldownCache.Spec
				
				if UserSpec == L['Spec_Paladin_Retribution'] and UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.ImprovedSpell and InspectCache.ImprovedSpell[157493] then
					return Cooldown - 30			-- 향상된 희생의 손길
				end
				
				return Cooldown, true
			end
		},
		
		[1044] = { Time = 25, Target = true, Charge = true,					-- 자유의 손길
			Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName)
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
		
		[31842] = { Time = 180,												-- 응징의 격노
			Glyph = {
				[1203] = - 90						-- 문양: 자비로운 격노
			}
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
			Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName)
				if InspectCache then
					for i = 1, MAX_TALENT_TIERS * NUM_TALENT_COLUMNS do
						if Data.Talent and Data.Talent[i] == 17591 then
							return Cooldown / 20	-- 특성: 불굴의 정신력
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
			Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName)
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
		},
	}
	
	Info.SmartTracker_ConvertSpell[105593] = 853							-- 심판의 주먹
	
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
			Func = function(Cooldown, CooldownCache, InspectCache, Event, UserGUID, UserName, UserClass, SpellID, DestName)
				local UserSpec = InspectCache and InspectCache.Spec or CooldownCache.Spec
				
				if UserSpec == L['Spec_Warlock_Destruction'] and UnitLevel(CooldownCache.Name) >= 100 or InspectCache and InspectCache.ImprovedSpell and InspectCache.ImprovedSpell[157126] then
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