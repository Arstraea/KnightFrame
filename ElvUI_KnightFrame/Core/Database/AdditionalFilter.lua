local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

local function RegistFilter(Filter, SpellID, Priority)
	local SpellName = GetSpellInfo(SpellID)
	
	if SpellName and G.unitframe.aurafilters[Filter] then
		G.unitframe.aurafilters[Filter].spells[SpellName] = { enable = true, priority = Priority or 0 }
	end
end


do	-- GENERAL
	-- WHITELIST
	RegistFilter('Whitelist', 146555)		-- 분노의 북		Drums of Rage
	RegistFilter('Whitelist', 178207)		-- 격노의 북		Drums of Fury
	RegistFilter('Whitelist', 172106)		-- 여우의 상		Aspect of the Fox
	RegistFilter('Whitelist', 102342)		-- 무쇠 껍질		Ironbark
	RegistFilter('Whitelist', 114030)		-- 경계				Vigilance
	
	-- AuraBarColors
	G.unitframe.AuraBarColors[GetSpellInfo(2825)] = { r = .09, g = .51, b = .82 }		-- 피의 욕망		Bloodlust
	G.unitframe.AuraBarColors[GetSpellInfo(32182)] = { r = .09, g = .51, b = .82 }		-- 영웅심			Heroism
	G.unitframe.AuraBarColors[GetSpellInfo(80353)] = { r = .09, g = .51, b = .82 }		-- 고대의 격분		Ancient Hysteria
	G.unitframe.AuraBarColors[GetSpellInfo(90355)] = { r = .09, g = .51, b = .82 }		-- 시간 왜곡		Ancient Hysteria
	G.unitframe.AuraBarColors[GetSpellInfo(146555)] = { r = .09, g = .51, b = .82 }		-- 분노의 북		Drums of Rage
	G.unitframe.AuraBarColors[GetSpellInfo(178207)] = { r = .09, g = .51, b = .82 }		-- 격노의 북		Drums of Fury
	G.unitframe.AuraBarColors[GetSpellInfo(172106)] = {									-- 여우의 상		Aspect of the Fox
		r = RAID_CLASS_COLORS.HUNTER.r,
		g = RAID_CLASS_COLORS.HUNTER.g,
		b = RAID_CLASS_COLORS.HUNTER.b
	}
	G.unitframe.AuraBarColors[GetSpellInfo(156990)] = { r = 1, g = .8, b = 0 }			-- 마라아드의 진실	Maraad's Truth
	G.unitframe.AuraBarColors[GetSpellInfo(156989)] = { r = .18, g = .72, b = .89 }		-- 리아드린의 정의	Liadrin's Righteousness
	G.unitframe.AuraBarColors[GetSpellInfo(156987)] = { r = 1, g = .3, b = .3 }			-- 투랄리온의 응징	Uther's Insight
	G.unitframe.AuraBarColors[GetSpellInfo(156988)] = {									-- 우서의 통찰		Uther's Insight
		r = RAID_CLASS_COLORS.PALADIN.r,
		g = RAID_CLASS_COLORS.PALADIN.g,
		b = RAID_CLASS_COLORS.PALADIN.b
	}
	
	-- Raid Utility Filter Group
	G.unitframe.aurafilters[(L['Raid Utility Filter'])] = {
		type = 'whitelist',
		spells = {}
	}
	RegistFilter(L['Raid Utility Filter'], 31821)	-- 헌오
	RegistFilter(L['Raid Utility Filter'], 98007)	-- 정신의 고리 토템
	
	RegistFilter(L['Raid Utility Filter'], 156430)	-- 드레나이 방어도 물약
	RegistFilter(L['Raid Utility Filter'], 156423)	-- 드레나이 민첩성 물약
	
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
		RegistFilter('RaidDebuffs', 159178)			-- 꿰뚫기				Open Wounds
		RegistFilter('RaidDebuffs', 162497)			-- 추적 사냥			On the Hunt
		
		-- The Butcher
		RegistFilter('RaidDebuffs', 156152, 2)		-- 상처 출혈			Gushing Wounds
		RegistFilter('RaidDebuffs', 156147)			-- 식칼					The Cleaver
		RegistFilter('RaidDebuffs', 156151, 1)		-- 고기다지개			The Tenderizer
		
		-- Tectus
		RegistFilter('RaidDebuffs', 172066)			-- 독 방출 중			Radiating Poison
		
		-- Brackenspore
		
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
		RegistFilter('RaidDebuffs', 156297)			-- 산성 격류			Acid Torrent
		
		-- Blast Furnace
		RegistFilter('RaidDebuffs', 155225, 1)		-- 융해					Melt
		
		-- Ka'graz
		RegistFilter('RaidDebuffs', 155277, 1)		-- 타오르는 광휘		Blazing Radiance
		
		-- Beastlord Darmac
		RegistFilter('RaidDebuffs', 154960, 1)		-- 봉쇄됨				Pinned Down
		
		-- Blackhand
		RegistFilter('RaidDebuffs', 175583)			-- 살아있는 불길		Living Blaze
		RegistFilter('RaidDebuffs', 156743, 1)		-- 관통상				Impaled
end


do	-- BuffWatch
	tinsert(G.unitframe.buffwatch.PALADIN, {		-- 신념의 봉화			Beacon of Faith
		enabled = true, id = 156910, point = 'TOPRIGHT', color = { r = .18, g = .72, b = .89 }, 
		style = 'coloredIcon', displayText = false, decimalThreshold = 5,
		textColor = { r = 1, g = 1, b = 1 }, textThreshold = -1, xOffset = 0, yOffset = 0
	})
end