local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 17
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.992

if not KF then return
elseif KF.Table then
	KF.Table['ItemEnchant_Profession_Inscription'] = {
		['NeedLevel'] = 600,
		['4912'] = true, -- 비밀 소뿔 새김무늬			Secret Ox Horn Inscription
		['4913'] = true, -- 비밀 학날개 새김무늬		Secret Crane Wing Inscription
		['4914'] = true, -- 비밀 호랑이 발톱 새김무늬	Secret Tiger Claw Inscription
		['4915'] = true, -- 비밀 호랑이 송곳니 새김무늬	Secret Tiger Fang Inscription
	}
	
	
	KF.Table['ItemEnchant_Profession_LeatherWorking'] = {
		['NeedLevel'] = 575,
		['4875'] = true, -- 모피 안감 - 힘				Fur Lining - Strength
		['4877'] = true, -- 모피 안감 - 지능			Fur Lining - Intellect
		['4878'] = true, -- 모피 안감 - 체력			Fur Lining - Stamina
		['4879'] = true, -- 모피 안감 - 민첩성			Fur Lining - Agility
	}
	
	
	KF.Table['ItemEnchant_Profession_Tailoring'] = {
		['NeedLevel'] = 550,
		['4892'] = true, -- 빛매듭 자수					Lightweave Embroidery
		['4893'] = true, -- 암흑빛 자수					Darkglow Embroidery
		['4894'] = true, -- 칼날 자수					Swordguard Embroidery
	}
end