﻿local AceLocale = LibStub:GetLibrary('AceLocale-3.0')
local L = AceLocale:NewLocale('ElvUI', 'koKR')
if not L then return end

local E = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

--[[ ColorTable
	<<Color>>	 << # Code >>	   << R, G, B >>	   << RGB Percent >>
	AquaBlue		2eb7e4			46, 183, 228		0.18, 0.72, 0.89
	SkyBlue			93daff			147, 218, 255		0.58, 0.85, 1
	Default RGB		1784d1			23, 132, 209		0.09, 0.52, 0.82
	Red				ff0000
	Pink			ff5675			255, 86, 117		1, 0.34, 0.46
	Purple			f88ef4
	Legend Color	ff9614
]]


do	--General
	BINDING_NAME_InspectMouseover = '|cffffffff- 마우스오버 살펴보기'
	BINDING_NAME_SpecSwitch = '|cffffffff- 특성 스왑'
	
	L['raid'] = '레이드 파티'
	L['party'] = '파티'
	L['instance'] = '무작 파티'
	L['battleground'] = '전장'
	L['Not Implemented'] = '미구현'
	L['DataTexts'] = '정보문자'
	
	L['LeftClick'] = '좌클릭'
	L['RightClick'] = '우클릭'
end


do	--Frame Name
	L['MiddleChatPanel'] = '중앙 채팅창 패널'
	L['MeterAddonPanel'] = '미터기 애드온 패널'
	L['ActionBarPanel'] = '액션바 패널'
	L['KnightInspectFrame'] = '살펴보기 창'
	L['Panel Tab'] = '상단 탭'
	L['Data Panel'] = '하단 탭'
end


do	--Inspect
	L[" Server's "] = ' 서버의 '
end


do	--Print Message
	L['KnightFrame Config addon is not exists.'] = '|cff1784d1나이트프레임 옵션 팩|r 애드온이 존재하지 않습니다.'
	L['You canceled KnightFrame install ago. If you wants to run KnightFrame install process again, please type /kf_install command.'] = '과거에 |cff1784d1KnightFrame|r 설치를 하지 않고 설치창을 닫았습니다. 다시 설치를 하고 싶으시면 |cff1784d1/kf_install|r 명령어를 입력하세요.'
	
	L['Lock ExpRep Tooltip.'] = '|cff2eb7e4경험치&평판|r 상세 정보패널을 |cffceff00고정|r합니다.'
	L['Unlock ExpRep Tooltip.'] = '|cff2eb7e4경험치&평판|r 상세 정보패널의 고정을 |cffff5353해제|r합니다.'
	
	L["You can't inspect while dead."] = '죽은 상태에선 살펴보기를 할 수 없습니다.'
	L[" Inspect. Sometimes this work will take few second by waiting server's response."] = ' 유저를 살펴봅니다. 서버의 응답을 기다리느라 시간이 조금 걸릴 수도 있습니다.'
	L['Mouseover Inspect needs to freeze mouse moving until inspect is over.'] = '|cff2eb7e4마우스오버 살펴보기|r는 살펴보기가 끝날 때 까지 |cffff5675마우스를 유저에게서 떼면 안됩니다|r.'
	L['Mouseover Inspect is canceled because cursor left user to inspect.'] = '마우스가 살펴보던 마우스오버 대상에게서 이탈하여 |cffff5675살펴보기가 취소되었습니다|r.'
	L['Inspect is canceled because target was lost or changed.'] = '타겟을 전환했거나 살펴보던 대상이 사라져 |cffff5675살펴보기가 취소되었습니다|r.'
	
	L['You have equipped equipment set:'] = '다음의 장비세트로 교체했습니다:'
	
	L['Hide Watchframe because of entering boss battle.'] = '보스와의 전투를 감지하여 퀘스트프레임을 숨깁니다.'
	L['Lock Display Area.'] = '표시 창을 |cffceff00고정|r합니다.'
	L['Unlock Display Area.'] = '표시 창을 |cffff5353고정 해제|r합니다.'
	L['Reset skills that have a cool time more than 5 minutes'] = '5분 이상 쿨타임을 가진 스킬의 쿨타임바를 리셋합니다.'
	L['Could not find the private channel been stored for the announcement. Channel setting will be chaged to the default.'] = '쿨타임 종료 알림을 위해 지정했었던던 채널을 찾을 수 없습니다. 기본값으로 변경합니다.'
	L["%s's %s is available!!"] = '%s 님의 %s 재사용 가능!!'
end


do	--Datatexts
	L['Friends'] = '친구'
	CRIT_ABBR = '크리'
	MANA_REGEN = '마젠'
	
	L['Current Spec'] = '현재 전문화'
	L['Equipment Set'] = '장착중인 장비세트'
	L['Change Specialization group.'] = '전문화를 서로 교체합니다.'
	L['Toggle Talent frame.'] = '특성창을 엽니다.'
	L['Change Loot Specialization.'] = '전리품 획득시 전문화를 변경합니다.'
end


do	--Specialization and Role
	L['Tank'] = '탱커'
	L['Caster'] = '캐스터'
	L['Melee'] = '밀리'
	L['No Spec'] = '전문화X'
end


do	--Extra Function
	L['Extra Functions'] = '추가 기능'

	--<< Tracker >>--
	L['Applied'] = '적용중'
	L['Non-applied'] = '비적용중'
	
	L['Elixirs'] = '영약 도핑'
	L['Foods'] = '음식 도핑'
	L['Bloodlust Debuff'] = '블러드 디버프'
	L['Resurrection Debuff'] = '부활 디버프'
	L['Increase Magic Damage Taken'] = '마법피해 증가'
	L['Weakened Armor'] = '방어도 감소'
	L['Physical Vulnerability'] = '물리피해 증가'
	L['Weakened Blows'] = '물리공격력 감소'
	L['Slow Spell Casting'] = '시전시간 증가'
	L['Mortal Wonds'] = '받는치유량 감소'
	
	local Exotic = '|cff1784d1(특수)|r'
	L['Wolves'] = '늑대'
	L['Cats'] = '살쾡이'
	L['Hyenas'] = '하이에나'
	L['Serpents'] = '뱀'
	L['Quilen'] = '기렌'..Exotic
	L['Silithids'] = '실리시드'..Exotic
	L['Water Striders'] = '소금쟁이'..Exotic
	L['Spirit Beasts'] = '야수정령'..Exotic
	L['Shale Spiders'] = '혈암거미'..Exotic
	L['Devilsaurs'] = '데빌사우루스'..Exotic
	L['Dragonhawks'] = '용매'
	L['Wind Serpents'] = '천둥매'
	L['Tallstriders'] = '타조'
	L['Raptors'] = '랩터'
	L['Boars'] = '멧돼지'
	L['Ravagers'] = '칼날발톱'
	L['Worms'] = '벌레'..Exotic
	L['Rhinos'] = '코뿔소'..Exotic
	L['Bears'] = '곰'
	L['Foxes'] = '여우'
	L['Sporebats'] = '포자날개'
	L['Goats'] = '염소'
	L['Core Hounds'] = '심장부사냥개'..Exotic
	
	
	--<< Armory Mode >>--
	L['Armory Mode'] = '전정실 모드'
	L['Notice Missing'] = '에러 표시'
	L['Average'] = '평균'
	L['Not Enchanted'] = '마부하지 않음'
	L['Missing Buckle'] = '죔쇠를 하지 않음'
	L['Missing Socket'] = '소켓추가하지 않음'
	L['Missing Tinkers'] = '땜질하지 않음'
	L['This is not profession only.'] = '전문기술 전용 강화효과가 아님'
	L['Missing Eye of the Black Prince'] = '|cffff9614[검은 왕자의 눈]|r을 박지 않음'
	L['Empty Socket'] = '개의 빈 소켓'
	
	
	--<< Secretary >>--
	L['Notice'] = '알림'
	
	
	--<< RaidCooldown >>--
	L['Enable to display'] = '표시가능한 바 개수'
	L['Inspect All Members.'] = '파티원 세팅 검사'
	L['Remove this cooltime bar.'] = '해당 쿨타임 바 삭제'
	L['Clear this spell config to forbid displaying.'] = '해당 주문 표시옵션 해제'
	L['Castable User'] = '시전 가능한 유저'
	L['Enable To Cast'] = '시전 가능'
	L['Resurrected User'] = '부활한 유저'
	L['Brez Available'] = '전투부활 가능 수'
end