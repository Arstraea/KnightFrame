local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

-----------------------------------------------------------
-- [ Knight : Spell Data								]--
-----------------------------------------------------------
Info.SmartTracker_Data = {}
Info.SmartTracker_ConvertSpell = {}
Info.SmartTracker_SPELL_CAST_SUCCESS_Spell = {}

--[[  << Table Format >>

	[SpellID] = {
		Time	= Cooltime (Number)
		Reset	= Spell that reset when boss combat is end (Boolean)
		Target	= Target type spell (Boolean)
		Charge	= Spell that chargable (Boolean)
		
		Spec = {
			[Global string of Spec in L table] = ChangedCooltime(Number)
			
			#NOTE: Global string of Spec in L table = L['Spec_'..ClassName..'_'..SpecName] (ex: L['Spec_Paladin_Holy']).
		}
		
		Talent = {
			[TalentID(Number)] = ChangedCooltime(Number)
			...
		}
		
		Glyph = {
			[GlyphID(Number)] = ChangedCooltime(Number)
			...
			
			#NOTE: I use GlyphID that 4th returning parameter of GetGlyphSocketInfo(SocketID).
		}
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
		
		
		[80240] = { Time = 25, Target = true,								-- 대혼란
			Glyph = {
				[146962] = 35
			}
		},
		
		
		[77801] = { Time = 120, Charge = true,								-- 악마의 영혼
			Glyph = {
				[159665] = -60
			}
		},
		
		
		[48020] = { Time = 30,												-- 악마의 마법진: 순간이동
			Glyph = {
				[63309] = -4
			}
		},
		
		
		[104773] = { Time = 180, Reset = true,								-- 영원한 결의
			Glyph = {
				[146964] = -60,						-- 문양: 영원한 결의
				[159697] = 60,						-- 문양: 강화된 결의
				[148683] = -180						-- 문양: 무한한 결의
			}
		},
		
		
		[86121] = { Time = 0,												-- 영혼 바꾸기
			Glyph = {
				[56225] = 30						-- 문양: 영혼 바꾸기
			}
		},
		
		
		[755] = { Time = 0,													-- 생명력 집중
			Glyph = {
				[56238] = 10
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