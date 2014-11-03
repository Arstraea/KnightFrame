local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Synergy Tracker SpellTable								>>--
--------------------------------------------------------------------------------
Info.SynergyIndicator_Filters = {
	--	{ SpellID, CastableClass/CastableTalent..., FilterRepresentIcon }
	Critical = { -- 극대화
		{ 1459, 'Mage' },									-- Arcane Brilliance			신비한 총명함
		{ 61316, 'Mage' },									-- Dalaran Brilliance			달라란의 총명함
		{ 24932, 'Druid/Feral', true },						-- Leader of The Pact			무리의 우두머리
		{ 116781, 'Monk/Brewmaster/Windwalker' },			-- Legacy of the White Tiger	백호의 유산
		true,
		{ 24604, 'Wolves/Hunter' },							-- Furious Howl					사나운 울음소리
		{ 160052, 'Raptors/Hunter' },						-- Strength of the Pack			무리의 힘
		{ 126373, 'Quilen/Hunter' },						-- Fearless Roar				용맹한 울음소리
		{ 126309, 'Water Striders/Hunter' },				-- Still Water					잔잔한 물
		{ 90309, 'Devilsaurs/Hunter' }						-- Terrifying Roar				공포의 포효
	},
	Haste = { -- 가속
		{ 113742, 'Rogue' },								-- Swiftblade's Cunning			스위프트블레이드의 간교함
		{ 116956, 'Shaman' },								-- Grace of Air					바람의 은총
		{ 49868, 'Priest/Shadow', true },					-- Mind Quickening				사고 촉진
		{ 55610, 'DeathKnight/Frost/Unholy' },				-- Improved Icy Talons			부정의 오라
		true,
		{ 160074, 'Wasp/Hunter' },							-- Speed of the Swarm			무리의 속도
		{ 135678, 'Sporebats/Hunter' },						-- Energizing Spores			활력의 포자
		{ 128432, 'Hyenas/Hunter' }							-- Cackling Howl				불쾌한 울음소리
	},
	MultiStrike = { -- 연속타격
		{ 113742, 'Rogue', true },							-- Swiftblade's Cunning			스위프트블레이드의 간교함
		{ 109773, 'Warlock' },								-- Dark Intent					검은 의도
		{ 49868, 'Priest/Shadow' },							-- Mind Quickening				사고 촉진
		true,
		{ 24844, 'Wind Serpents/Hunter' },					-- Breath of the Winds			바람 숨결
		{ 57386, 'Clefthooves/Hunter' },					-- Wild Strength				야생의 힘
		{ 159736, 'Chimaeras/Hunter' },						-- Duality						이중성
		{ 58604, 'Core Hounds/Hunter' }						-- Double Bite					문 데 또 물기
	},
	Versatility = { -- 유연성
		{ 1126, 'Druid' },									-- Mark of The Wild				야생의 징표
		{ 167187, 'Paladin/Retribution' },					-- Sanctity Aura				신성한 오라
		{ 167188, 'Warrior/Arms/Fury', true },				-- Inspiring Presence			고무적인 존재
		true,
		{ 159735, 'Birds of Prey/Hunter' },					-- Tenacity						강인함
		{ 173035, 'Stags/Hunter' },							-- Grace						우아함
		{ 35290, 'Boars/Hunter' },							-- Indomitable					백절불굴
		{ 50518, 'Ravagers/Hunter' },						-- Chitinous Armor				키틴질 방어구
		{ 57386, 'Clefthooves/Hunter' },					-- Wild Strength				야생의 힘
		{ 160077, 'Worms/Hunter' }							-- Strength of the Earth		대지의 힘
	},
	---------------------------------------------------------------------------------------------------------------------
	AllStats = { -- 모든 능력치
		{ 20217, 'Paladin' },								-- Blessing Of Kings			왕의 축복
		{ 1126, 'Druid', true },							-- Mark of The Wild				야생의 징표
		{ 115921, 'Monk/Mistweaver' },						-- Legacy of The Emperor		황제의 유산
		{ 116781, 'Monk/Brewmaster/Windwalker' },			-- Legacy of the White Tiger	백호의 유산
		true,
		{ 160017, 'Gorillas/Hunter' },						-- Blessing of Kongs			유인원의 축복
		{ 160077, 'Worms/Hunter' }							-- Strength of the Earth		대지의 힘
	},
	---------------------------------------------------------------------------------------------------------------------
	AttackPower = { -- 전투력
		{ 6673, 'Warrior' },								-- Battle Shout					전투의 외침
		{ 19506, 'Hunter', true },							-- Trueshot Aura				정조준 오라
		{ 57330, 'DeathKnight' }							-- Horn of Winter				겨울의 뿔피리
	},
	SpellPower = { -- 주문력
		{ 1459, 'Mage', true },								-- Arcane Brilliance			신비한 총명함
		{ 61316, 'Mage' },									-- Dalaran Brilliance			달라란의 총명함
		{ 109773, 'Warlock' },								-- Dark Intent					검은 의도
		true,
		{ 128433, 'Serpents/Hunter' },						-- Serpent's Cunning			독사의 교활함
		{ 126309, 'Water Striders/Hunter' },				-- Still Water					잔잔한 물
		{ 90364, 'Silithids/Hunter' }						-- Qiraji Fortitude				퀴라지의 인내
	},
	Mastery = { -- 특화도
		{ 116956, 'Shaman' },								-- Grace of Air					바람의 은총
		{ 19740, 'Paladin', true },							-- Blessing of Might			힘의 축복
		{ 24907, 'Druid/Balance' },							-- Moonkin Aura					달빛야수 오라
		{ 155522, 'DeathKnight/Blood' },					-- Power of the Grave			무덤의 힘
		true,
		{ 160073, 'Tallstriders/Hunter' },					-- Plainswalking				평원 보행
		{ 93435, 'Cats/Hunter' },							-- Roar of Courage				용기의 포효
		{ 160039, 'Hydras/Hunter' },						-- Keen Senses					예리한 감각
		{ 128997, 'Spirit Beasts/Hunter' }					-- Spirit Beast Blessing		야수 정령의 축복
	},
	Stamina = { -- 체력
		{ 469, 'Warrior' },									-- Commanding Shout				지휘의 외침
		{ 21562, 'Priest', true },							-- Power Word: Fortitude		신의 권능 : 인내
		{ 166928, 'Warlock' },								-- Blood Pact					피의 서약
		true,
		{ 50256, 'Bears/Hunter' },							-- Invigorating Roar			활기의 포효
		{ 160014, 'Goats/Hunter' },							-- Sturdiness					건강함
		{ 90364, 'Silithids/Hunter' }						-- Qiraji Fortitude				퀴라지의 인내
	},
	---------------------------------------------------------------------------------------------------------------------
	Elixirs = { -- Elixirs 영약 도핑
		{ 105696, nil, true },
		{ 105689 },
		{ 105691 },
		{ 105694 },
		{ 105693 }
	},
	Foods = { -- Foods 음식 도핑
		{ 104264, nil, true }
	},
	ResurrectionDebuff = { -- Resurrection Debuff 부활 디버프
		--[GetSpellInfo(15007)] = false,					-- Resurrection Sickness		부활후유증
		--[GetSpellInfo(97821)] = false,					-- Void-Touched					공허의 손길
		{ 95223, nil, true },								-- Recently Mass Resurrected	최근 대규모 부활을 받음
		Type = 'HARMFUL', ShownWhenHasAura = true
	},
	BloodLustDebuff = { -- BloodLust Debuff 소진효과
		{ 95809 },
		{ 80354 },
		{ 57723 },
		{ 57724, nil, true },
		Type = 'HARMFUL', ShownWhenHasAura = true
	}
}

for Filter in pairs(Info.SynergyIndicator_Filters) do
	local SpellName, StringTable, Icon
	for i = 1, #Info.SynergyIndicator_Filters[Filter] do
		if type(Info.SynergyIndicator_Filters[Filter][i]) == 'table' then
			SpellName, _, Icon = GetSpellInfo(Info.SynergyIndicator_Filters[Filter][i][1])
			
			Info.SynergyIndicator_Filters[Filter][i][1] = SpellName
			
			if Info.SynergyIndicator_Filters[Filter][i][2] and type(Info.SynergyIndicator_Filters[Filter][i][2]) == 'string' then
				StringTable = { strsplit('/', Info.SynergyIndicator_Filters[Filter][i][2]) }
				
				Info.SynergyIndicator_Filters[Filter][i][2] = L[(StringTable[1])]
				
				if #StringTable > 1 then
					Info.SynergyIndicator_Filters[Filter][i][2] = Info.SynergyIndicator_Filters[Filter][i][2]..' ('
					
					for k = 2, #StringTable do
						Info.SynergyIndicator_Filters[Filter][i][2] = Info.SynergyIndicator_Filters[Filter][i][2]..((Info.ClassRole[strupper(StringTable[1])] and L['Spec_'..StringTable[1]..'_'..(StringTable[k])] or L[(StringTable[k])])..'|r, ')
					end
					
					Info.SynergyIndicator_Filters[Filter][i][2] = strsub(Info.SynergyIndicator_Filters[Filter][i][2], 1, -3)..')'
				end
			end
			
			if Info.SynergyIndicator_Filters[Filter][i][3] then
				Info.SynergyIndicator_Filters[Filter].MainIcon = Icon
				tremove(Info.SynergyIndicator_Filters[Filter][i], 3)
			end
		end
	end
end