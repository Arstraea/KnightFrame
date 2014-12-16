local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

-----------------------------------------------------------
-- [ Knight : Add Important Raid Debuff					]--
-----------------------------------------------------------
local function RegistRaidDebuffSpell(spellID, priority)
	local spellName = GetSpellInfo(spellID)
	
	if spellName then
		if not E.global.unitframe.aurafilters.RaidDebuffs.spells[spellName] then
			E.global.unitframe.aurafilters.RaidDebuffs.spells[spellName] = {
				enable = true,
				priority = 0,
			}
		end
		
		if priority and E.global.unitframe.aurafilters.RaidDebuffs.spells[spellName].priority == 0 then
			E.global.unitframe.aurafilters.RaidDebuffs.spells[spellName].priority = priority
		end
	end
end


function KF_Config:Install_SubPackData_RaidDebuffs()
	-- Mogu'shan Vaults
		-- The Stone Guard
		RegistRaidDebuffSpell(130395)
		
		-- Feng the Accursed
		RegistRaidDebuffSpell(131788)
		RegistRaidDebuffSpell(131792)
		
		-- Gara'jal the Spiritbinder
		RegistRaidDebuffSpell(117723)
		RegistRaidDebuffSpell(122181)
	
	
	
	-- Heart of Fear
		-- Garalon
		RegistRaidDebuffSpell(123081, 1)
		
		-- Wind Lord Mel'jarak
		RegistRaidDebuffSpell(122055)
		
		-- Grand Empress Shek'zeer
		RegistRaidDebuffSpell(123707)
		RegistRaidDebuffSpell(123788)
	
	
	
	-- Terrace of Endless Spring
		-- Tsulong
		RegistRaidDebuffSpell(122768)
		
		
		
	-- Throne of Thunder
		-- Council of Elders
		RegistRaidDebuffSpell(136922, 1)
		RegistRaidDebuffSpell(136992, 1)
		
		-- Ji-Kun
		RegistRaidDebuffSpell(140092)
		RegistRaidDebuffSpell(134366, 1)
		RegistRaidDebuffSpell(134256)
		
		-- Primordius
		RegistRaidDebuffSpell(136050, 1)
		RegistRaidDebuffSpell(136228, 1)
		
		-- Qon
		RegistRaidDebuffSpell(136193)
		RegistRaidDebuffSpell(134647)
		
		-- Twin Consorts
		RegistRaidDebuffSpell(137341, 1)
		
	
	-- Siege of Orgrimmar
		-- Iron Juggernaut
		RegistRaidDebuffSpell(144467)
		
		-- Malkorok
		RegistRaidDebuffSpell(142863, 1)
		RegistRaidDebuffSpell(142864, 1)
		RegistRaidDebuffSpell(142865, 1)
		
		
	-- Highmoul
		-- Kargath Bladefist
		RegistRaidDebuffSpell(159178)	-- 꿰뚫기
		
		-- The Butcher
		RegistRaidDebuffSpell(156152, 2)-- 상처 출혈
		RegistRaidDebuffSpell(156147)	-- 식칼
		RegistRaidDebuffSpell(156151, 1)-- 고기다지개
		
		-- Brackenspore
		
		
		-- Mar'gok
		RegistRaidDebuffSpell(156225)	-- 낙인
		RegistRaidDebuffSpell(164004)	-- 낙인: 변위
		RegistRaidDebuffSpell(164005)	-- 낙인: 경화
		RegistRaidDebuffSpell(164006)	-- 낙인: 복제
end