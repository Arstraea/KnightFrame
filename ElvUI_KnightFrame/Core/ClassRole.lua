local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 4
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.Table then
	KF.Table['ClassRole'] = {
		['WARRIOR'] = {
			[L['Spec_Warrior_Arms']] = {		--무기
				['Color'] = '|cff9a9a9a',
				['Role'] = 'Melee',
			},
			[L['Spec_Warrior_Fury']] = {		--분노
				['Color'] = '|cffb50000',
				['Role'] = 'Melee',
			},
			[L['Spec_Warrior_Protection']] = {	--방어
				['Color'] = '|cff088fdc',
				['Role'] = 'Tank',
			},
		},
		['HUNTER'] = {
			[L['Spec_Hunter_Beast']] = {		--야수
				['Color'] = '|cffffdb00',
				['Role'] = 'Melee',
			},
			[L['Spec_Hunter_Marksmanship']] = {	--사격
				['Color'] = '|cffea5455',
				['Role'] = 'Melee',
			},
			[L['Spec_Hunter_Survival']] = {		--생존
				['Color'] = '|cffbaf71d',
				['Role'] = 'Melee',
			},
		},
		['SHAMAN'] = {
			[L['Spec_Shaman_Elemental']] = {	--정기
				['Color'] = '|cff2be5fa',
				['Role'] = 'Caster',
			},
			[L['Spec_Shaman_Enhancement']] = {	--고양
				['Color'] = '|cffe60000',
				['Role'] = 'Melee',
			},
			[L['Spec_Shaman_Restoration']] = {	--복원
				['Color'] = '|cff00ff0c',
				['Role'] = 'Healer',
			},
		},
		['MONK'] = {
			[L['Spec_Monk_Brewmaster']] = {		--양조
				['Color'] = '|cffbcae6d',
				['Role'] = 'Tank',
			},
			[L['Spec_Monk_Mistweaver']] = {		--운무
				['Color'] = '|cffb6f1b7',
				['Role'] = 'Healer',
			},
			[L['Spec_Monk_Windwalker']] = {		--풍운
				['Color'] = '|cffb2c6de',
				['Role'] = 'Melee',
			},
		},
		['ROGUE'] = {
			[L['Spec_Rogue_Assassination']] = {	--암살
				['Color'] = '|cff129800',
				['Role'] = 'Melee',
			},
			[L['Spec_Rogue_Combat']] = {		--전투
				['Color'] = '|cffbc0001',
				['Role'] = 'Melee',
			},
			[L['Spec_Rogue_Subtlety']] = {		--잠행
				['Color'] = '|cfff48cba',
				['Role'] = 'Melee',
			},
		},
		['DEATHKNIGHT'] = {
			[L['Spec_DeathKnight_Blood']] = {	--혈기
				['Color'] = '|cffbc0001',
				['Role'] = 'Tank',
			},
			[L['Spec_DeathKnight_Frost']] = {	--냉기
				['Color'] = '|cff1784d1',
				['Role'] = 'Melee',
			},
			[L['Spec_DeathKnight_Unholy']] = {	--부정
				['Color'] = '|cff00ff10',
				['Role'] = 'Melee',
			},
		},
		['MAGE'] = {
			[L['Spec_Mage_Arcane']] = {			--비전
				['Color'] = '|cffdcb0fb',
				['Role'] = 'Caster',
			},
			[L['Spec_Mage_Fire']] = {			--화염
				['Color'] = '|cffff3615',
				['Role'] = 'Caster',
			},
			[L['Spec_Mage_Frost']] = {			--냉기
				['Color'] = '|cff1784d1',
				['Role'] = 'Caster',
			},		
		},
		['DRUID'] = {
			[L['Spec_Druid_Balance']] = {		--조화
				['Color'] = '|cffff7d0a',
				['Role'] = 'Caster',
			},
			[L['Spec_Druid_Feral']] = {			--야성
				['Color'] = '|cffffdb00',
				['Role'] = 'Melee',
			},
			[L['Spec_Druid_Guardian']] = {		--수호
				['Color'] = '|cff088fdc',
				['Role'] = 'Tank',
			},
			[L['Spec_Druid_Restoration']] = {	--회복
				['Color'] = '|cff64df62',
				['Role'] = 'Healer',
			},
		},
		['PALADIN'] = {
			[L['Spec_Paladin_Holy']] = {		--신성
				['Color'] = '|cfff48cba',
				['Role'] = 'Healer',
			},		
			[L['Spec_Paladin_Protection']] = {	--보호
				['Color'] = '|cff84e1ff',
				['Role'] = 'Tank',
			},
			[L['Spec_Paladin_Retribution']] = {	--징벌
				['Color'] = '|cffe60000',
				['Role'] = 'Melee',
			},
		},
		['PRIEST'] = {
			[L['Spec_Priest_Discipline']] = {	--수양
				['Color'] = '|cffffffff',
				['Role'] = 'Healer',
			},
			[L['Spec_Priest_Holy']] = {			--신성
				['Color'] = '|cff6bdaff',
				['Role'] = 'Healer',
			},
			[L['Spec_Priest_Shadow']] = {		--암흑
				['Color'] = '|cff7e52c1',
				['Role'] = 'Caster',
			},
		},
		['WARLOCK'] = {
			[L['Spec_Warlock_Affliction']] = {	--고통
				['Color'] = '|cff00ff10',
				['Role'] = 'Caster',
			},
			[L['Spec_Warlock_Demonology']] = {	--악마
				['Color'] = '|cff9482c9',
				['Role'] = 'Caster',
			},
			[L['Spec_Warlock_Destruction']] = {	--파괴
				['Color'] = '|cffba1706',
				['Role'] = 'Caster',
			},
		},
	}
end