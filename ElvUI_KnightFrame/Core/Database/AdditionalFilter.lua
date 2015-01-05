local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

local function RegistFilter(Filter, SpellID, Priority)
	local SpellName = GetSpellInfo(SpellID)
	
	if G.unitframe.aurafilters[Filter] then
		G.unitframe.aurafilters[Filter].spells[SpellName] = { enable = true, priority = Priority or 0 }
	end
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
		
		-- The Butcher
		RegistFilter('RaidDebuffs', 156152, 2)		-- 상처 출혈			Gushing Wounds
		RegistFilter('RaidDebuffs', 156147)			-- 식칼					The Cleaver
		RegistFilter('RaidDebuffs', 156151, 1)		-- 고기다지개			The Tenderizer
		
		-- Brackenspore
		
		-- Ko'ragh
		RegistFilter('RaidDebuffs', 162186)			-- 마법 방출: 비전		Expel Magic: Arcane
		RegistFilter('RaidDebuffs', 162184)			-- 마법 방출: 암흑		Expel Magic: Shadow
		RegistFilter('RaidDebuffs', 172886)			-- 무효화의 징표		Mark of Nullification
		
		-- Mar'gok
		RegistFilter('RaidDebuffs', 156225)			-- 낙인					Branded
		RegistFilter('RaidDebuffs', 164004)			-- 낙인: 변위			Branded: Displacement
		RegistFilter('RaidDebuffs', 164005)			-- 낙인: 경화			Branded: Fortification
		RegistFilter('RaidDebuffs', 164006)			-- 낙인: 복제			Branded: Replication
end