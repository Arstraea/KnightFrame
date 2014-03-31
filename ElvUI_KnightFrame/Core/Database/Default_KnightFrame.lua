local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 24
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Default Structure										>>--
--------------------------------------------------------------------------------
KF.db = {
	['Enable'] = true,
	
	['Modules'] = {},
}


KF.db['Skins'] = {
	['Enable'] = true,
	['ACP'] = true,
	['DBM-Core'] = false,
	['Skada'] = true,
	['Omen'] = true,
	['Recount'] = true,
}


KF.db['Modules'] = {
	['TopPanel'] = {
		['Enable'] = true,
		['Height'] = 12,
	},
	
	['ExpRepDisplay'] = {
		['Enable'] = true,
		['EmbedPanel'] = nil,
		['EmbedLocation'] = nil,
		['Lock'] = false,
	},
	
	['WorldStateAlwaysUpFrame'] = 'TOPElvUIParentTOP0-54',
	
	['MinimapBackdropWhenFarmMode'] = true,
	
	['LocalizedTimeFormat'] = true,
	
	['BankOpen'] = true,
	['FullValues'] = true,
	
	['ShowChatTab'] = true,
	['TooltipTalent'] = true,
	
	['SpellAlert'] = {
		['Enable'] = true,
		
		[87024] = { -- 소작
			[1] = {
				['Message'] = '소작!!! 두번죽이지 말아줘요 ;ㅁ;',
			},
		},
		[41425] = { -- 저체온증
			[1] = {
				['Message'] = '얼방 사용했슴!! 살려주세요.. ㅠㅁㅠ',
			},
		},
		[94794] = { -- 니트로 부작용
			[1] = {
				['Message'] = '니트로 삑사리났음!! 힐힐힐!! ㅠㅠ 아이고, 나죽네!!',
			},
		},
		[19263] = { -- 공저
			[1] = {
				['Message'] = '공격저지 켰어요~',
			},
		},
	},
}