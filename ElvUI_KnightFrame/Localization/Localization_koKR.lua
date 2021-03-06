﻿local GetLocale = GetLocale

if GetLocale() ~= 'koKR' then return end

--Cache global variables
--Lua functions
local unpack, select = unpack, select

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Locale													>>--
--------------------------------------------------------------------------------
do	-- General
	BINDING_NAME_InspectMouseover = '|cffffffff- 마우스오버 살펴보기'
	BINDING_NAME_SpecSwitch = '|cffffffff- 특성 스왑'
	
	L['Tank'] = '탱커'
	L['Caster'] = '캐스터'
	L['Melee'] = '밀리'
	L['No Spec'] = '전문화X'
	
	L['LeftClick'] = '좌클릭'
	L['RightClick'] = '우클릭'
	
	L['raid'] = '레이드 파티'
	L['party'] = '파티'
	
	CRIT_ABBR = '크리'
	MANA_REGEN = '마젠'
	
	L['Raid Utility Filter'] = '공대생존기 필터'
	
	L['Creater of this addon, %s is in %s group. Please whisper me about opinion of %s addon.'] = '본 애드온 제작자인 제가 %s 아이디로 %s 안에 있습니다! 귓속말로 %s 에 대하여 의견을 이야기해주세요.' 
	L['You canceled KnightFrame install ago. If you wants to run KnightFrame install process again, please type /kf_install command.'] = '과거에 |cff1784d1KnightFrame|r 설치를 하지 않고 설치창을 닫았습니다. 다시 설치를 하고 싶으시면 |cff1784d1/kf_install|r 명령어를 입력하세요.'
end


do	-- ElvUI_KnightFrame_Config
	L['KnightFrame Config addon is not exists.'] = '|cff1784d1나이트프레임 옵션 팩|r 애드온이 존재하지 않습니다.'
end


do	-- Modules
	do	-- CustomPanel
		L['MiddleChatPanel'] = '중앙 채팅창 패널'
		L['MeterAddonPanel'] = '미터기 애드온 패널'
		L['ActionBarPanel'] = '액션바 패널'
		
		L['Panel Tab'] = '상단 탭'
		L['Data Panel'] = '하단 탭'
	end
	
	
	do	-- FloatingDatatext
		L['Floating Datatext'] = '독립형 정보문자'
		L['Current Spec'] = '현재 전문화'
		L['Equipped Set'] = '장착중인 장비세트'
		L['Toggle Talent frame.'] = '특성창을 엽니다.'
		L['Change Loot Specialization.'] = '전리품 획득시 전문화를 변경합니다.'
	end
	
	
	do	-- SmartTracker
		-- General
			L['Smart Tracker'] = '스마트 추적기'
			L['SmartTracker_MainWindow'] = '메인 창'
			L['SmartTracker_WindowTag'] = '|cffffffff[|cffceff00'..'스마트추적기 창'..'|cffffffff]|r|n'
			L['SmartTracker_IconTag'] = '|cffffffff[|cffceff00'..'스마트추적기 아이콘'..'|cffffffff]|r|n'
			L['Enable to display'] = '표시가능한 바 개수'
			L['Enable To Cast'] = '시전 가능'
			L['Castable User'] = '시전가능 유저'
			L['Remove this cooltime bar.'] = '해당 쿨타임 바 삭제'
			L['Clear this spell config to forbid displaying.'] = '해당 주문 표시옵션 해제'
			L['IconGroup %d'] = '%d번 그룹'
			L['Battle Resurrection'] = '전투 부활'
			L['Brez Available'] = '전투부활 가능 수'
			L['Now Charging'] = '다음 충전까지'
			L['Resurrection Situation'] = '전투부활 사용현황'
			L['Icon Grouping'] = '아이콘 묶기'
				L['Assign spell to this group'] = '이 그룹에 주문 배정'
				L['Erase assigned spell'] = '배정한 주문 삭제'
				L['Create New Group'] = '새로운 그룹 생성'
				L['Disband this group.'] = '이 그룹 해체'
				L['Disband all groups.'] = '모든 그룹 해체'
				L["Show this spell's icon in frame."] = '이 주문의 아이콘으로 표시'
				L['Exclude %s from Icon tracking list.'] = '%s 를 아이콘 추적 목록에서 제외'
				L['Exclude all %s from this group.'] = '%s 를 이 그룹에서 모두 제외'
				L['Assign to %s.'] = '%s 으로 배정'
				L['Make a new %s and assign to it.'] = '%s 을 새로 만든 후 배정'
				L['Exclude from this group and revert it.'] = '그룹 배정 취소'
		
		-- Message
			L['Lock Display Area.'] = '표시 창을 |cffceff00고정|r합니다.'
			L['Unlock Display Area.'] = '표시 창을 |cffff5353고정 해제|r합니다.'
			L["%s member's setting check start."] = '파티원 %s명의 세팅을 검사합니다.'
			L["Now updating old member's setting."] = '기존 파티원의 세팅을 업데이트합니다.'
			L['Inspect Complete'] = '검사 완료'
			L["All members specialization, talent, glyph setting is saved. SmartTracker will calcurating each spell's cooltime by this data.|r"] = '모든 파티원의 전문화, 특성, 문양설정을 저장했습니다. 이 기록을 기준으로 주문의 쿨타임을 검사합니다.'
			L['Reset major cooltime that had used in previous boss battle.'] = '이전 보스전투에서 쓰였던 주요 스킬들의 쿨타임을 리셋합니다.'
			
		-- ETC
			L['Hunter_Now_FeignDeath'] = '죽은척 하는 중임 >ㅁ<'
	end
	
	
	do	-- Armory
		L['Not Enchanted'] = '마부하지 않음'
		L['Empty Socket'] = '개의 빈 소켓'
		L['%s Points Available!!'] = '%s 포인트 사용 가능'
		L['Character model may differ because it was constructed by the inspect data.'] = '대상에게서 전송받은 데이터로 재현한 캐릭터 모델입니다. 캐릭터의 생김세가 다를 수 있습니다.'
		L['Specialization data seems to be crashed. Please inspect again.'] = '특성 정보가 잘못 로드되었습니다. 대상을 다시 살펴보길 권장합니다.'
		L['PvP talents become available at level %s.'] = '명예 특성은 캐릭터 레벨이 %s 이상일 때부터 사용할 수 있습니다.'
		
		L["Try inspecting %s. Sometimes this work will take few second for waiting server's response."] = '%s 유저를 살펴봅니다. 서버의 응답을 기다리느라 시간이 조금 걸릴 수도 있습니다.'
		L['Mouseover Inspect must hold your mouse position until inspect is over.'] = '|cff2eb7e4마우스오버 살펴보기|r는 살펴보기가 끝날 때 까지 |cffff5675마우스를 유저에게서 떼면 안됩니다|r.'
		L['Inspect is canceled because target was changed or lost.'] = '살펴보던 대상이 바뀌거나 사라져 |cffff5675살펴보기가 취소되었습니다|r.'
		L["You can't inspect while dead."] = '죽은 상태에선 살펴보기를 할 수 없습니다.'
	end
	
	
	do	-- Secretary
		L['Alarm'] = '알림'
		L['Hide Objectiveframe because of entering boss battle.'] = '보스와의 전투를 감지하여 임무창을 숨깁니다.'
	end
	
	
	do	-- SwitchEquipment
		L['You have equipped %s set.'] = '장비세트 %s 를 착용하였습니다.'
	end
	
	
	do	-- in MISC
		do	-- Calculator
			L['Command_Calculator'] = { 'rPtks', '계산' }
			L['Input formula is incorrect.'] = '입력한 식이 잘못되었습니다.'
			L['Formula'] = '식'
			L['Anshwer'] = '답'
		end
		
		do	
		
		end
		
		do	-- ExpRepDisplay
			L['Lock ExpRep Tooltip.'] = '|cff2eb7e4경험치&평판|r 상세 정보패널을 |cffceff00고정|r합니다.'
			L['Unlock ExpRep Tooltip.'] = '|cff2eb7e4경험치&평판|r 상세 정보패널의 고정을 |cffff5353해제|r합니다.'
		end
	end
end




--------------------------------------------------------------------------------
--<< KnightFrame : Slash Commands											>>--
--------------------------------------------------------------------------------
E:RegisterChatCommand('ㄷㅊ', 'ToggleConfig')
E:RegisterChatCommand('기', ReloadUI)
E:RegisterChatCommand('키', E.ActionBars.ActivateBindMode)
E:RegisterChatCommand('vkxkf', LeaveParty)
E:RegisterChatCommand('파탈', LeaveParty)

KF:RegisterChatCommand('test', 'Test')
KF:RegisterChatCommand('ㅅㄷㄴㅅ', 'Test')
KF:RegisterChatCommand('ㅏㄹ_ㅑㅜㄴㅅ미ㅣ', 'Install')
KF:RegisterChatCommand('skdlxmvmfpdlatjfcl', 'Install')
KF:RegisterChatCommand('나이트프레임설치', 'Install')


--------------------------------------------------------------------------------
--<< KnightFrame : Time Format												>>--
--------------------------------------------------------------------------------
L['KF_LocalizedTimeFormat'] = {
	[0] = { '%d일', '%dd' }, -- Day
	[1] = { '%d시간', '%dh' }, -- Hour
	[2] = { '%d분', '%dm' }, -- Minute
	[3] = { '%d초', '%d' }, -- Second
	[4] = { '%.1f', '%.1f' }, -- Decimal Form
}