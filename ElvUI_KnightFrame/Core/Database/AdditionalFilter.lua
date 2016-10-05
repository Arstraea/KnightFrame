--Cache global variables
--Lua functions
local _G = _G
local unpack, select, type, tinsert = unpack, select, type, tinsert

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local GetSpellInfo = GetSpellInfo

local function RegistFilter(Filter, SpellID, Priority, Enable)
	if Enable == nil then
		Enable = true
	end
	
	if GetSpellInfo(SpellID) and G.unitframe.aurafilters[Filter] then
		G.unitframe.aurafilters[Filter].spells[SpellID] = { enable = Enable, priority = Priority or 0 }
	end
end


do	-- GENERAL
	-- WHITELIST
	RegistFilter('Whitelist', 146555)		-- 분노의 북		Drums of Rage
	RegistFilter('Whitelist', 178207)		-- 격노의 북		Drums of Fury
	RegistFilter('Whitelist', 102342)		-- 무쇠 껍질		Ironbark
	RegistFilter('Whitelist', 114030)		-- 경계				Vigilance
	RegistFilter('Whitelist', 77764)		-- 쇄도의 포효		Stampeding Roar
	RegistFilter('Whitelist', 77761)		-- 쇄도의 포효		Stampeding Roar
	RegistFilter('Whitelist', 106898)		-- 쇄도의 포효		Stampeding Roar
	
	-- AuraBarColors
	G.unitframe.AuraBarColors[2825] = { r = .09, g = .51, b = .82 }		-- 피의 욕망		Bloodlust
	G.unitframe.AuraBarColors[32182] = { r = .09, g = .51, b = .82 }		-- 영웅심			Heroism
	G.unitframe.AuraBarColors[80353] = { r = .09, g = .51, b = .82 }		-- 고대의 격분		Ancient Hysteria
	G.unitframe.AuraBarColors[90355] = { r = .09, g = .51, b = .82 }		-- 시간 왜곡		Ancient Hysteria
	G.unitframe.AuraBarColors[146555] = { r = .09, g = .51, b = .82 }		-- 분노의 북		Drums of Rage
	G.unitframe.AuraBarColors[178207] = { r = .09, g = .51, b = .82 }		-- 격노의 북		Drums of Fury
	G.unitframe.AuraBarColors[156990] = { r = 1, g = .8, b = 0 }			-- 마라아드의 진실	Maraad's Truth
	G.unitframe.AuraBarColors[156989] = { r = .18, g = .72, b = .89 }		-- 리아드린의 정의	Liadrin's Righteousness
	G.unitframe.AuraBarColors[156987] = { r = 1, g = .3, b = .3 }			-- 투랄리온의 응징	Uther's Insight
	G.unitframe.AuraBarColors[156988] = {									-- 우서의 통찰		Uther's Insight
		r = RAID_CLASS_COLORS.PALADIN.r,
		g = RAID_CLASS_COLORS.PALADIN.g,
		b = RAID_CLASS_COLORS.PALADIN.b
	}
	G.unitframe.AuraBarColors[77764] = {									-- 쇄도의 포효		Stampeding Roar
		r = RAID_CLASS_COLORS.DRUID.r,
		g = RAID_CLASS_COLORS.DRUID.g,
		b = RAID_CLASS_COLORS.DRUID.b
	}
	G.unitframe.AuraBarColors[77761] = {									-- 쇄도의 포효		Stampeding Roar
		r = RAID_CLASS_COLORS.DRUID.r,
		g = RAID_CLASS_COLORS.DRUID.g,
		b = RAID_CLASS_COLORS.DRUID.b
	}
	G.unitframe.AuraBarColors[106898] = {									-- 쇄도의 포효		Stampeding Roar
		r = RAID_CLASS_COLORS.DRUID.r,
		g = RAID_CLASS_COLORS.DRUID.g,
		b = RAID_CLASS_COLORS.DRUID.b
	}
	
	-- Legendary
	G.unitframe.AuraBarColors[187616] = { r = .09, g = .51, b = .82 }		-- 니스라무스		Nithramus
	G.unitframe.AuraBarColors[187617] = { r = .09, g = .51, b = .82 }		-- 에테랄루스		Sanctus
	G.unitframe.AuraBarColors[187618] = { r = .09, g = .51, b = .82 }		-- 에테랄루스		Etheralus
	G.unitframe.AuraBarColors[187619] = { r = .09, g = .51, b = .82 }		-- 토라수스			Thorasus
	G.unitframe.AuraBarColors[187620] = { r = .09, g = .51, b = .82 }		-- 말루스			Maalus
	
	
	-- Raid Utility Filter Group
	G.unitframe.aurafilters[(L['Raid Utility Filter'])] = {
		type = 'Whitelist',
		spells = {}
	}
	RegistFilter(L['Raid Utility Filter'], 97463)	-- 재집결의 함성			Rallying Cry
	RegistFilter(L['Raid Utility Filter'], 98007)	-- 정신의 고리 토템			Spirit Link Totem
	RegistFilter(L['Raid Utility Filter'], 145629)	-- 대마법 지대				Anti-Magic Shell
	RegistFilter(L['Raid Utility Filter'], 31821)	-- 헌신의 오라				Devotion Aura
	RegistFilter(L['Raid Utility Filter'], 81782)	-- 신의 권능: 방벽			Power Word: Barrier
	RegistFilter(L['Raid Utility Filter'], 179202, 6)	-- 안주의 눈					Eye of Anzu
	
	RegistFilter(L['Raid Utility Filter'], 156423)	-- 드레나이 민첩성 물약		Draenic Agility Potion
	RegistFilter(L['Raid Utility Filter'], 156426)	-- 드레나이 지능 물약		Draenic Intellect Potion
	RegistFilter(L['Raid Utility Filter'], 156428)	-- 드레나이 힘 물약			Draenic Strength Potion
	RegistFilter(L['Raid Utility Filter'], 156430)	-- 드레나이 방어도 물약		Draenic Armor Potion
	
end


do	-- MIST OF PANDARIA
	-- Mogu'shan Vaults
		-- The Stone Guard
		RegistFilter('RaidDebuffs', 130395)
		
		-- Feng the Accursed
		RegistFilter('RaidDebuffs', 131788)
		RegistFilter('RaidDebuffs', 131792)
		
		-- Gara'jal the Spiritbinder
		RegistFilter('RaidDebuffs', 117723)
		RegistFilter('RaidDebuffs', 122181)
	
	
	-- Heart of Fear
		-- Garalon
		RegistFilter('RaidDebuffs', 123081, 1)
		
		-- Wind Lord Mel'jarak
		RegistFilter('RaidDebuffs', 122055)
		
		-- Grand Empress Shek'zeer
		RegistFilter('RaidDebuffs', 123707)
		RegistFilter('RaidDebuffs', 123788)
	
	
	-- Terrace of Endless Spring
		-- Tsulong
		RegistFilter('RaidDebuffs', 122768)
	
	
	-- Throne of Thunder
		-- Council of Elders
		RegistFilter('RaidDebuffs', 136922, 1)
		RegistFilter('RaidDebuffs', 136992, 1)
		
		-- Ji-Kun
		RegistFilter('RaidDebuffs', 140092)
		RegistFilter('RaidDebuffs', 134366, 1)
		RegistFilter('RaidDebuffs', 134256)
		
		-- Primordius
		RegistFilter('RaidDebuffs', 136050, 1)
		RegistFilter('RaidDebuffs', 136228, 1)
		
		-- Qon
		RegistFilter('RaidDebuffs', 136193)
		RegistFilter('RaidDebuffs', 134647)
		
		-- Twin Consorts
		RegistFilter('RaidDebuffs', 137341, 1)
	
	
	-- Siege of Orgrimmar
		-- Iron Juggernaut
		RegistFilter('RaidDebuffs', 144467)
		
		-- Malkorok
		RegistFilter('RaidDebuffs', 142863, 1)
		RegistFilter('RaidDebuffs', 142864, 1)
		RegistFilter('RaidDebuffs', 142865, 1)
end


do	-- WARLORD OF DRAENORE
	-- Highmoul
		-- Kargath Bladefist
		RegistFilter('RaidDebuffs', 158986, 1)		-- 광전사의 돌격		Berserker Rush
		RegistFilter('RaidDebuffs', 159178)			-- 꿰뚫기				Open Wounds
		RegistFilter('RaidDebuffs', 162497, 1)		-- 추적 사냥			On the Hunt
		
		-- The Butcher
		RegistFilter('RaidDebuffs', 156152, 2)		-- 상처 출혈			Gushing Wounds
		RegistFilter('RaidDebuffs', 156147)			-- 식칼					The Cleaver
		RegistFilter('RaidDebuffs', 156151, 1)		-- 고기다지개			The Tenderizer
		
		-- Tectus
		RegistFilter('RaidDebuffs', 172066)			-- 독 방출 중			Radiating Poison
		RegistFilter('RaidDebuffs', 162346)			-- 수정 포화			Crystalline Barrage
		
		-- Brackenspore
		RegistFilter('RaidDebuffs', 159220)			-- 괴저 숨결			Necrotic Breath
		
		-- Twin Ogron
		RegistFilter('RaidDebuffs', 163372)			-- 불안정한 비전		Arcane Volatility
		RegistFilter('RaidDebuffs', 158026, 1)		-- 약화의 포효			Enfeebling Roar
		RegistFilter('RaidDebuffs', 158241, 2)		-- 태우기				Blaze
		
		-- Ko'ragh
		RegistFilter('RaidDebuffs', 162186)			-- 마법 방출: 비전		Expel Magic: Arcane
		RegistFilter('RaidDebuffs', 162184)			-- 마법 방출: 암흑		Expel Magic: Shadow
		RegistFilter('RaidDebuffs', 172886, 1)		-- 무효화의 징표		Mark of Nullification
		
		-- Mar'gok
		RegistFilter('RaidDebuffs', 156225)			-- 낙인					Branded
		RegistFilter('RaidDebuffs', 164004)			-- 낙인: 변위			Branded: Displacement
		RegistFilter('RaidDebuffs', 164005)			-- 낙인: 경화			Branded: Fortification
		RegistFilter('RaidDebuffs', 164006)			-- 낙인: 복제			Branded: Replication
	
	
	-- Blackrock Foundry
		-- Oregorger
		RegistFilter('RaidDebuffs', 159632)			-- 끝없는 허기			Insatiable Hunger
		RegistFilter('RaidDebuffs', 156297)			-- 산성 격류			Acid Torrent
		
		-- Blast Furnace
		RegistFilter('RaidDebuffs', 156934, 2)		-- 파열					Rupture
		RegistFilter('RaidDebuffs', 155225, 2)		-- 융해					Melt
		RegistFilter('RaidDebuffs', 155192, 1)		-- 폭탄					Bomb
		RegistFilter('RaidDebuffs', 176121, 1)		-- 변덕스러운 불		Volatile Fire
		
		-- Ka'graz
		RegistFilter('RaidDebuffs', 154932, 1)		-- 녹아내린 격류		Molten Torrent
		RegistFilter('RaidDebuffs', 155277, 1)		-- 타오르는 광휘		Blazing Radiance
		
		-- Kromog
		RegistFilter('RaidDebuffs', 157059, 1)		-- 휘감는 대지의 룬		Rune of Grasping Earth
		
		-- Beastlord Darmac
		RegistFilter('RaidDebuffs', 154960, 1)		-- 봉쇄됨				Pinned Down
		
		-- Blackhand
		RegistFilter('RaidDebuffs', 175583)			-- 살아있는 불길		Living Blaze
		RegistFilter('RaidDebuffs', 156743, 1)		-- 관통상				Impaled
	
	
	-- Hellfire Citadel
		-- Normal Mob
		RegistFilter('RaidDebuffs', 184587, 1)			-- 필멸의 손길				Touch of Mortality
		
		--Gorefiend
		RegistFilter('RaidDebuffs', 181295, 2)			-- 소화							Digest
		RegistFilter('RaidDebuffs', 179977, 3)			-- 파멸의 손길				Touch of Doom
		RegistFilter('RaidDebuffs', 186770, 4)			-- 영혼의 웅덩이			Pool of Souls
		RegistFilter('RaidDebuffs', 179864, 1)			-- 죽음의 그림자			Shadow of Death
		RegistFilter('RaidDebuffs', 179909, 1)			-- 이어진 운명				Shared Fate (self root)
		RegistFilter('RaidDebuffs', 179908, 1)			-- 이어진 운명				Shared Fate (other players root)
		
		-- Shadow-Lord Iskar
		RegistFilter('RaidDebuffs', 181957, 5)			-- 실체없는 바람			Phantasmal Winds
		RegistFilter('RaidDebuffs', 182200, 2)			-- 지옥 회전 표창			Fel Chakram
		RegistFilter('RaidDebuffs', 182178, 2)			-- 지옥 회전 표창			Fel Chakram
		RegistFilter('RaidDebuffs', 182325, 3)			-- 실체없는 상처			Phantasmal Wounds
		RegistFilter('RaidDebuffs', 185510, 4)			-- 어둠의 결속				Dark Bindings
		RegistFilter('RaidDebuffs', 182600, 1)			-- 지옥 불꽃					Fel Fire
		RegistFilter('RaidDebuffs', 179219, 4)			-- 실체없는 지옥 폭탄	Phantasmal Fel Bomb
		RegistFilter('RaidDebuffs', 181753, 5)			-- 지옥 폭탄					Fel Bomb
		RegistFilter('RaidDebuffs', 185239, 0, false)	-- 안주의 광휘				Radiance of Anzu
		
		-- Soulbound Construct (Socrethar)
		RegistFilter('RaidDebuffs', 182038, 1)			-- 으스러진 방어			Shattered Defenses
		RegistFilter('RaidDebuffs', 188666, 3)			-- 끝없는 굶주림			Eternal Hunger (Add fixate, Mythic only)
		
		-- Tyrant Velhari
		RegistFilter('RaidDebuffs', 185241, 2)			-- 규탄의 칙령				Edict of Condemnation
		RegistFilter('RaidDebuffs', 180526, 1)			-- 타락의 샘					Font of Corruption
		
		-- Fel Lord Zakuun
		RegistFilter('RaidDebuffs', 181508, 3)			-- 파괴의 씨앗				Seed of Destruction
		RegistFilter('RaidDebuffs', 181653, 0, false)	-- 지옥 수정					Fel Crystals (Too Close)
		RegistFilter('RaidDebuffs', 182008, 1)			-- 잠재적 마력				Latent Energy (Cannot soak)
		RegistFilter('RaidDebuffs', 189030, 2)			-- 오염물						Befouled
		
		-- Xhul' horac
		RegistFilter('RaidDebuffs', 185656, 3)			-- 어둠지옥 파멸			Shadowfel Annihilation
		RegistFilter('RaidDebuffs', 186407, 4)			-- 지옥의 쇄도				Fel Surge
		RegistFilter('RaidDebuffs', 186333, 4)			-- 공허의 쇄도				Void Surge
		RegistFilter('RaidDebuffs', 186500, 5)			-- 지옥의 사슬				Chains of Fel
		
		-- Mannoroth
		RegistFilter('RaidDebuffs', 186526, 5)			-- 폭발적인 파멸의 쐐기
		
		-- Archimonde
		RegistFilter('RaidDebuffs', 188070, 6)			-- 군단의 징표				Mark of the Legion
		RegistFilter('RaidDebuffs', 183586, 4)			-- 파멸의 불					Doomfire
		RegistFilter('RaidDebuffs', 184964, 6)			-- 구속된 고통				Shackled Torment
		RegistFilter('RaidDebuffs', 186123, 3)			-- 불러일으킨 혼돈		Wrought Chaos
		RegistFilter('RaidDebuffs', 185014, 3)			-- 집중된 혼돈				Focused Chaos
		RegistFilter('RaidDebuffs', 186952, 2)			-- 황천 추방					Nether Banish
		RegistFilter('RaidDebuffs', 186961, 2)			-- 황천 추방					Nether Banish
		RegistFilter('RaidDebuffs', 189891, 2)			-- 황천 가르기				Nether Tear
		RegistFilter('RaidDebuffs', 183634, 5)			-- 어둠지옥 폭발			Shadowfel Burst
		RegistFilter('RaidDebuffs', 189895, 5)			-- 공허의 별 시선고정	Void Star Fixate
end


do	-- Legion
	-- Il'gynoth
		-- 
		RegistFilter('RaidDebuffs', 208929)
		
	-- Ursoc
		-- 돌진대상자
		RegistFilter('RaidDebuffs', 198006, 6)
		
		-- 돌진디버프
		RegistFilter('RaidDebuffs', 198108, 6)
end


do	-- BuffWatch
	local function AddBuffWatch(Class, SpellID, Data)
		if KF.db.Modules.AddBuffWatch[SpellID] then
			return
		end
		
		if E.global and E.global.unitframe and E.global.unitframe.buffwatch and E.global.unitframe.buffwatch[Class] and type(E.global.unitframe.buffwatch[Class]) == 'table' then
			for i = 1, #E.global.unitframe.buffwatch[Class] do
				if E.global.unitframe.buffwatch[Class][i].id == SpellID then
					KF.db.Modules.AddBuffWatch[SpellID] = true
					return
				end
			end
		else
			return
		end
		
		Data.id = SpellID
		tinsert(E.global.unitframe.buffwatch[Class], Data)
		
		KF.db.Modules.AddBuffWatch[SpellID] = true
	end
	
	KF.Modules[#KF.Modules + 1] = 'AddBuffWatch'
	KF.Modules.AddBuffWatch = function()
		-- 신념의 봉화			Beacon of Faith
		AddBuffWatch('PALADIN', 156910, {
			enabled = true, point = 'TOPRIGHT', color = { r = .18, g = .72, b = .89 }, 
			style = 'coloredIcon', displayText = false, decimalThreshold = 5,
			textColor = { r = 1, g = 1, b = 1 }, textThreshold = -1, xOffset = 0, yOffset = 0
		})
		
		AddBuffWatch('PALADIN', 223306, {
			enabled = true, point = 'BOTTOMRIGHT', color = { r = .87, g = .7, b = .09 }, 
			style = 'coloredIcon', displayText = false, decimalThreshold = 5,
			textColor = { r = 1, g = 1, b = 1 }, textThreshold = -1, xOffset = 0, yOffset = 0
		})
		
		-- 의지의 명료함		Clarity of Will
		AddBuffWatch('PRIEST', 152118, {
			enabled = true, point = 'BOTTOM', color = { r = .89, g = 1, b = .6 }, 
			style = 'coloredIcon', displayText = false, decimalThreshold = 5,
			textColor = { r = 1, g = 1, b = 1 }, textThreshold = -1, xOffset = 0, yOffset = 0
		})
	end
end