local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Synergy Tracker SpellTable								>>--
--------------------------------------------------------------------------------
Info.SynergyTracker_Filters = {
	Critical = { -- 극대화
		[GetSpellInfo(1459)] = L['Mage'],																			-- Arcane Brilliance			신비한 총명함
		[GetSpellInfo(61316)] = L['Mage'],																			-- Dalaran Brilliance			달라란의 총명함
		[GetSpellInfo(24932)] = L['Druid']..'('..L['Spec_Druid_Feral']..')',										-- Leader of The Pact			무리의 우두머리
		[GetSpellInfo(116781)] = L['Monk']..'('..L['Spec_Monk_Brewmaster']..', '..L['Spec_Monk_Windwalker']..')',	-- Legacy of the White Tiger	백호의 유산
		
		[GetSpellInfo(24604)] = L['Wolves']..'('..L['Hunter']..'|r)',												-- Furious Howl					사나운 울음소리
		[GetSpellInfo(90309)] = L['Devilsaurs']..'('..L['Hunter']..'|r)',											-- Terrifying Roar				공포의 포효
	},
	Haste = { -- 가속
		[GetSpellInfo(113742)] = L['Rogue'],																		-- Swiftblade's Cunning			스위프트블레이드의 간교함
		[GetSpellInfo(116956)] = L['Shaman'],																		-- Grace of Air					바람의 은총
		[GetSpellInfo(49868)] = L['Priest']..'('..L['Spec_Priest_Shadow']..')',										-- Mind Quickening				사고 촉진
		[GetSpellInfo(55610)] = L['DeathKnight']..'('..L['Spec_DeathKnight_Frost']..', '..L['Spec_DeathKnight_Unholy']..')', -- Improved Icy Talons			부정의 오라
	},
	MultiStrike = { -- 연속타격
		[GetSpellInfo(113742)] = L['Rogue'],																		-- Swiftblade's Cunning			스위프트블레이드의 간교함
		[GetSpellInfo(109773)] = L['Warlock'],																		-- Dark Intent					검은 의도
		[GetSpellInfo(49868)] = L['Priest']..'('..L['Spec_Priest_Shadow']..')',										-- Mind Quickening				사고 촉진
	},
	Versatility = { -- 유연성
		[GetSpellInfo(1126)] = L['Druid'],																			-- Mark of The Wild				야생의 징표
		[GetSpellInfo(167187)] = L['Paladin']..'('..L['Spec_Paladin_Retribution']..')',								-- Sanctity Aura				신성한 오라
		[GetSpellInfo(167188)] = L['Warrior']..'('..L['Spec_Warrior_Arms']..', '..L['Spec_Warrior_Fury']..')',		-- Inspiring Presence			고무적인 존재
	},
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	AllStats = { -- 모든 능력치
		[GetSpellInfo(20217)] = L['Paladin'],																		-- Blessing Of Kings			왕의 축복
		[GetSpellInfo(1126)] = L['Druid'],																			-- Mark of The Wild				야생의 징표
		[GetSpellInfo(115921)] = L['Monk']..'('..L['Spec_Monk_Mistweaver']..')',									-- Legacy of The Emperor		황제의 유산
		[GetSpellInfo(116781)] = L['Monk']..'('..L['Spec_Monk_Brewmaster']..', '..L['Spec_Monk_Windwalker']..')',	-- Legacy of the White Tiger	백호의 유산
	},
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	AttackPower = { -- 전투력
		[GetSpellInfo(6673)] = L['Warrior'],																		-- Battle Shout					전투의 외침
		[GetSpellInfo(57330)] = L['DeathKnight'],																	-- Horn of Winter				겨울의 뿔피리
		[GetSpellInfo(19506)] = L['Hunter'],																		-- Trueshot Aura				정조준 오라
	},
	SpellPower = { -- 주문력
		[GetSpellInfo(1459)] = L['Mage'],																			-- Arcane Brilliance			신비한 총명함
		[GetSpellInfo(61316)] = L['Mage'],																			-- Dalaran Brilliance			달라란의 총명함
		[GetSpellInfo(109773)] = L['Warlock'],																		-- Dark Intent					검은 의도
		[GetSpellInfo(128433)] = L['Serpents']..'('..L['Hunter']..'|r)',											-- Serpent's Cunning			독사의 교활함
	},
	Mastery = { -- 특화도
		[GetSpellInfo(116956)] = L['Shaman'],																		-- Grace of Air					바람의 은총
		[GetSpellInfo(19740)] = L['Paladin'],																		-- Blessing of Might			힘의 축복
		[GetSpellInfo(24907)] = L['Druid']..'('..L['Spec_Druid_Balance']..')',										-- Moonkin Aura					달빛야수 오라
		[GetSpellInfo(155522)] = L['DeathKnight']..'('..L['Spec_DeathKnight_Blood']..')',							-- Power of the Grave			무덤의 힘
		
		[GetSpellInfo(93435)] = L['Cats']..'('..L['Hunter']..'|r)',													-- Roar of Courage				용기의 포효
		[GetSpellInfo(160039)] = L['Hydra']..'('..L['Hunter']..'|r)',												-- 예리한 감각
		[GetSpellInfo(160073)] = L['Tallstriders']..'('..L['Hunter']..'|r)',										-- 평원 보행
		[GetSpellInfo(128997)] = L['Spirit Beasts']..'('..L['Hunter']..'|r)',										-- Spirit Beast Blessing		야수 정령의 축복
	},
	Stamina = { -- 체력
		[GetSpellInfo(469)] = L['Warrior'],																			-- Commanding Shout				지휘의 외침
		[GetSpellInfo(166928)] = L['Warlock'],																		-- Blood Pact					피의 서약
		[GetSpellInfo(21562)] = L['Priest'],																		-- Power Word: Fortitude		신의 권능 : 인내
	}
}


	--[[
	['AttackPower'] = { -- Attack Power 전투력 증가
		['MainIcon'] = select(3, GetSpellInfo(57330)),
		
		
	},
	['AttackSpeed'] = { -- Attack Speed 가속 증가
		['MainIcon'] = select(3, GetSpellInfo(30809)),
		
		[GetSpellInfo(128432)] = L['Hyenas']..'('..L['Hunter']..'|r)',												-- Cackling Howl				불쾌한 울음소리
		
		[GetSpellInfo(30809)] = L['Shaman']..'('..L['Spec_Shaman_Enhancement']..')',								-- Unleashed Rage				해방된 분노
	},
	['SpellPower'] = { -- Spell Power 주문력 증가
		['MainIcon'] = select(3, GetSpellInfo(1459)),
		[GetSpellInfo(77747)] = L['Shaman'],																		-- Burning Wrath				불타는 분노
		[GetSpellInfo(126309)] = L['Water Striders']..'('..L['Hunter']..'|r)',										-- Still Water					잔잔한 물
	},
	['SpellHaste'] = { -- Spell Haste 주문가속 증가
		['MainIcon'] = select(3, GetSpellInfo(49868)),
		[GetSpellInfo(51470)] = L['Shaman']..'('..L['Spec_Shaman_Elemental']..')',									-- Elemental Oath				정령의 서약
		
		[GetSpellInfo(135678)] = L['Sporebats']..'('..L['Hunter']..'|r)',											-- Energizing Spores			활력의 포자
	},
	['Critical'] = { -- Critical 크리 5% 증가
		['MainIcon'] = select(3, GetSpellInfo(24932)),
		
		[GetSpellInfo(126373)] = L['Quilen']..'('..L['Hunter']..'|r)',												-- Feearless Roar				용맹한 울음소리
		
		[GetSpellInfo(61316)] = L['Mage'],																			-- Dalaran Brilliance			달라란의 총명함
		[GetSpellInfo(1459)] = L['Mage'],																			-- Arcane Brilliance			신비한 총명함
		
		[GetSpellInfo(126309)] = L['Water Striders']..'('..L['Hunter']..'|r)',										-- Still Water					잔잔한 물
	},
	['AllStats'] = { -- All Stats 능력치 증가
		['MainIcon'] = select(3, GetSpellInfo(20217)),
		[GetSpellInfo(90363)] = L['Shale Spiders']..'('..L['Hunter']..'|r)',										-- Embrace of the Shale Spider	혈암거미의 은총
		
	},
	['Mastery'] = { -- Mastery 특화도 증가
		['MainIcon'] = select(3, GetSpellInfo(19740)),
		
		
		
		
	},
	['Stamina'] = { -- Stamina 체력 증가
		['MainIcon'] = select(3, GetSpellInfo(21562)),
		[GetSpellInfo(90364)] = L['Silithids']..'('..L['Hunter']..'|r)',											-- Qiraji Fortitude				퀴라지의 인내
		
	},
	['Elixirs'] = { -- Elixirs 영약 도핑
		['MainIcon'] = select(3, GetSpellInfo(105696)),
		[GetSpellInfo(105696)] = false,
		[GetSpellInfo(105689)] = false,
		[GetSpellInfo(105691)] = false,
		[GetSpellInfo(105694)] = false,
		[GetSpellInfo(105693)] = false,
	},
	['Foods'] = { -- Foods 음식 도핑
		['MainIcon'] = select(3, GetSpellInfo(104264)),
		[GetSpellInfo(104264)] = false,
	},
	['BloodLustDebuff'] = { -- BloodLust Debuff 소진효과
		['Type'] = 'HARMFUL',
		['MainIcon'] = select(3, GetSpellInfo(57724)),
		[GetSpellInfo(95809)] = false,
		[GetSpellInfo(80354)] = false,
		[GetSpellInfo(57723)] = false,
		[GetSpellInfo(57724)] = false,
	},
	['ResurrectionDebuff'] = { -- Resurrection Debuff 부활 디버프
		['Type'] = 'HARMFUL',
		['MainIcon'] = select(3, GetSpellInfo(95223)),
		[GetSpellInfo(15007)] = false,																				-- Resurrection Sickness		부활후유증
		[GetSpellInfo(97821)] = false,																				-- Void-Touched					공허의 손길
		[GetSpellInfo(95223)] = false,																				-- Recently Mass Resurrected	최근 대규모 부활을 받음
	},
	['WeakenedArmor'] = { -- Weakened Armor 방어도 감소 효과
		['Type'] = 'HARMFUL',
		['MainIcon'] = select(3, GetSpellInfo(113746)),
		[GetSpellInfo(113746)] = false,
		[GetSpellInfo(770)] = L['Druid'],																			-- Faerie Fire					요정의 불꽃
		[GetSpellInfo(50285)] = L['Tallstriders']..'('..L['Hunter']..'|r)',											-- Dust Cloud					먼지 구름
		[GetSpellInfo(8647)] = L['Rogue'],																			-- Expose Armor					약점 노출
		[GetSpellInfo(20243)] = L['Warrior']..'('..L['Spec_Warrior_Protection']..')',								-- Devastate					압도
		[GetSpellInfo(7386)] = L['Warrior'],																		-- Sunder Armor					방어구 가르기
		[GetSpellInfo(50498)] = L['Raptors']..'('..L['Hunter']..'|r)',												-- Tear Armor					갑옷 찢기
	},
	['PhysicalVulnerability'] = { -- Physical Vulnerability 물리피해 증가 효과
		['Type'] = 'HARMFUL',
		['MainIcon'] = select(3, GetSpellInfo(81326)),
		[GetSpellInfo(81326)] = false,
		[GetSpellInfo(50518)] = L['Ravagers']..'('..L['Hunter']..'|r)',												-- Ravage						약탈
		[GetSpellInfo(55749)] = L['Worms']..'('..L['Hunter']..'|r)',												-- Acid Spit					산성 숨결
		[GetSpellInfo(81328)] = L['DeathKnight']..'('..L['Spec_DeathKnight_Frost']..')',							-- Brittle Bones				부러진 뼈
		[GetSpellInfo(57386)] = L['Rhinos']..'('..L['Hunter']..'|r)',												-- Stampede						쇄도
		[GetSpellInfo(51160)] = L['DeathKnight']..'('..L['Spec_DeathKnight_Unholy']..')',							-- Ebon Plaguebringer			칠흑의 역병인도자
		[GetSpellInfo(86346)] = L['Warrior']..'('..L['Spec_Warrior_Arms']..','..L['Spec_Warrior_Fury']..')',		-- Colossus Smash				거인의 강타
		[GetSpellInfo(35290)] = L['Boars']..'('..L['Hunter']..'|r)',												-- Gore							들이받기
		[GetSpellInfo(111529)] = L['Paladin']..'('..L['Spec_Paladin_Retribution']..')',								-- Judgments of the Bold		대담한 자의 심판
	},
	['WeakenedBlows'] = { -- Weakened Blows 물리 공격력 감소 효과
		['Type'] = 'HARMFUL',
		['MainIcon'] = select(3, GetSpellInfo(115798)),
		[GetSpellInfo(115798)] = false,
		[GetSpellInfo(106832)] = L['Druid']..'('..L['Spec_Druid_Feral']..','..L['Spec_Druid_Guardian']..')',		-- Thrash						난타
		[GetSpellInfo(53595)] = L['Paladin']..'('..L['Spec_Paladin_Protection']..','..L['Spec_Paladin_Retribution']..')', -- Hammer of the Righteous 정의의 망치
		[GetSpellInfo(6343)] = L['Warrior'],																		-- Thunder Clap					천둥 벼락
		[GetSpellInfo(81132)] = L['DeathKnight']..'('..L['Spec_DeathKnight_Blood']..')',							-- Scarlet Fever				핏빛 열병
		[GetSpellInfo(8042)] = L['Shaman'],																			-- Earth Shock					대지 충격
		[GetSpellInfo(50256)] = L['Bears']..'('..L['Hunter']..'|r)',												-- Demoralizing Roar			위협의 포효
		[GetSpellInfo(109466)] = L['Warlock'],																		-- Curse of Enfeeblement		무력화 저주
		[GetSpellInfo(121253)] = L['Monk']..'('..L['Spec_Monk_Brewmaster']..')',									-- Keg Smash					맥주통 휘두르기
	},
	['SlowSpellCasting'] = { -- Slow SpellCasting 주문 시전속도 감소 효과
		['Type'] = 'HARMFUL',
		['MainIcon'] = select(3, GetSpellInfo(5761)),
		[GetSpellInfo(58604)] = L['Core Hounds']..'('..L['Hunter']..'|r)',											-- Lava Breath					용암 숨결
		[GetSpellInfo(90314)] = L['Foxes']..'('..L['Hunter']..'|r)',												-- Tailspin						꼬리 흔들기
		[GetSpellInfo(50274)] = L['Sporebats']..'('..L['Hunter']..'|r)',											-- Spore Cloud					포자 구름
		[GetSpellInfo(109466)] = L['Warlock'],																		-- Curse of Enfeeblement		무력화 저주
		[GetSpellInfo(5761)] = L['Rogue'],																			-- Mind-numbing Poison			정신 마비 독
		[GetSpellInfo(126402)] = L['Goats']..'('..L['Hunter']..'|r)',												-- Trample						밟아 뭉개기
	},
	['IncreaseMagicDamageTaken'] = { -- Increase Magic Damage Taken 마법피해 5% 증가 효과
		['Type'] = 'HARMFUL',
		['MainIcon'] = select(3, GetSpellInfo(1490)),
		[GetSpellInfo(34889)] = L['Dragonhawks']..'('..L['Hunter']..'|r)',											-- Fire Breath					불의 숨결
		[GetSpellInfo(24844)] = L['Wind Serpents']..'('..L['Hunter']..'|r)',										-- Lightning Breath				번개 숨결
		[GetSpellInfo(1490)] = L['Warlock'],																		-- Curse of the Elements		원소의 저주
		[GetSpellInfo(58410)] = L['Rogue'],																			-- Master Poisoner				독의 대가
	},
	['MortalWounds'] = { -- Mortal Wounds 치유량 감소 효과
		['Type'] = 'HARMFUL',
		['MainIcon'] = select(3, GetSpellInfo(115804)),
		[GetSpellInfo(115804)] = false,
		[GetSpellInfo(8679)] = L['Rogue'],																			-- Wound Poison					상처 감염 독
		[GetSpellInfo(82654)] = L['Hunter'],																		-- Widow Venom					과부거미의 독
		[GetSpellInfo(54680)] = L['Devilsaurs']..'('..L['Hunter']..'|r)',											-- Monstrous Bite				거대한 이빨
		[GetSpellInfo(100130)] = L['Warrior']..'('..L['Spec_Warrior_Fury']..')',									-- Wild Strike					난폭한 일격
		[GetSpellInfo(12294)] = L['Warrior']..'('..L['Spec_Warrior_Arms']..')',										-- Mortal Strike				필사의 일격
	},
	]]