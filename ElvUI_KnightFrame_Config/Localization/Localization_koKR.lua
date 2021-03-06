﻿if GetLocale() ~= 'koKR' then return end

--Cache global variables
--Lua functions
local unpack = unpack

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)

do	--General
	L['Install'] = '설치'
	L['Warning'] = '경고'
	L['Disable'] = '사용 안함'
	L['function required'] = '기능 필요'
	L['Re-Install KnightFrame'] = '나이트프레임 재설치'
	L['Check PatchNote'] = '패치노트 확인'
	
	L['Reset'] = '초기화'
	L['Delete'] = '삭제'
	L['Select'] = '선택'
	L['Please Select'] = '선택하세요'
	L['Create new one'] = '새로만들기'
	L['Input New Name'] = '새로운 이름 입력'
	L['Hide when PetBattle'] = '애완동물대전 시 숨김'
	L['Transparency'] = '반투명 하게'
	L['Use Custom Color'] = '색상 따로 설정'
		L['Border'] = '테두리'
	
	L['All changes have been saved successfully.'] = '변경 사항이 저장되었습니다.'
	L['Are you sure you want to OVERWRITE it?'] = '덮어쓰시겠습니까?'
	L['Are you sure you want to delete this %s?|nIf yes, press the Delete button again.'] = '정말 이 %s을 삭제하시겠습니까?|n삭제하시려면 버튼을 한번 더 누르세요.'
	L['%s has been deleted.'] = '%s이 삭제되었습니다.'
end


do	--Install Process Description
	--Page 1
	L['KnightFrame is an external addon of ElvUI|nto change layout setting and add some of extra functions.'] = '|cff1784d1KnightFrame|r은 |cff1784d1ElvUI|r 의 기본 레이아웃 변경과|n몇 가지의 기능 추가를 위해 제작된 외부애드온입니다.'
	L['This page will be closed by clicking [Skip Process] button or closs button and you can see again by typing /kf_install command or clicking Install button in ElvUI Config - KnightFrame menu.'] = '이 창은 아래의 |cffff5675[건너뛰기]|r 버튼이나 우측상단의 |cffff5675[X]|r 버튼을 누르면 닫히며,|n|cff2eb7e4/kf_install|r, 혹은 |cff2eb7e4/나이트프레임설치|r 명령어를 채팅창에 입력하거나|n|cff1784d1ElvUI|r 설정창의 |cff1784d1KnightFrame|r 메뉴에서 다시 실행할 수 있습니다.'
	L['Please press the next button to go onto the next step.'] = '|cff2eb7e4[다음]|r 버튼을 눌러 설치과정을 진행하세요.'
	
	--Page 2
	L['UI Layout Theme'] = '레이아웃 배치 테마'
	L['Layout to Install'] = '설치할 레이아웃'
	L['Did not selected yet.'] = '아직 선택하지 않았습니다.'
	L['KnightFrame provides 2 layout theme.|nYou can preview those layout setting by clicking each preview button.|nPlease select one, then you can go onto the next step.'] = '|cff1784d1KnightFrame|r은 2가지 배치방식의 레이아웃을 제공합니다.|n각 패널의 |cff2eb7e4[미리보기]|r 버튼을 클릭해 레이아웃을 확인할 수 있습니다.|n설치할 레이아웃을 선택해야 다음 단계로 넘어갈 수 있습니다.'
	
	--Page 3
	L['Mover Arrangement'] = '프레임 위치 재정렬'
	L['You selected %s layout theme,|nand we needs to arrange movers position.'] = '당신은 %s 레이아웃을 선택하셨습니다.|n이제 선택한 레이아웃의 모습으로 프레임을 재정렬해야 합니다.'
	L['If you click the button below and when process is over,|n|cffff0000YOUR PRESENT MOVER SETTING WILL BE OVERWRITED!!|r|n|nIf you wants to preserve your custom mover profile, do not click the button and just go onto the next step.'] = '|cffff0000이 작업을 지시하고 설치과정이 끝나게 되면,|n현재 당신의 프레임 배치 데이터들을 덮어쓰게 됩니다!!|r|n|n만약 현재의 프레임 배치를 보존하고 싶으면|n지시를 내리지 말고 그냥 다음 단계로 넘어가세요.|r'
	L['Install Mover setting?'] = '프레임 위치값을 설치할까요?'
	L['Arrange Movers'] = '프레임 정렬하기'
	L['Do not arrange'] = '정렬하지 않기'
	
	--Page 4
	L['Profile Install'] = '프로필 설치'
	L['We also needs to install profile setting for becoming %s layout theme.'] = '%s 레이아웃으로 완벽히 변하려면|n대부분의 프로필 설정값들을 변경해야 합니다.'
	L['If you click the button below and when process is over,|n|cffff0000YOUR UNITFRAME AND ACTIONBAR SETTING WILL BE REMOVED!!|r|n|nIf you wants to preserve your custom option setting or just use extra functions, do not click the button and just go onto the next step.'] = '|cffff0000이 작업을 지시하고 설치과정이 끝나게 되면,|n현재 당신의 유닛프레임과 행동단축바 설정들이 사라집니다!!|r|n|n만약 현재의 설정값을 보존하고 싶거나 그저 추가기능을 사용하고 싶을 뿐이면,|n지시를 내리지 말고 그냥 다음 단계로 넘어가세요.'
	L['Install Profile?'] = '프로필을 설치할까요?'
	L['Install Profile'] = '프로필 설치'
	L['Do not install'] = '설치 안함'
	
	--Page 5
	L['Sub Install'] = '부가 설치'
	L['KnightFrame provides sub-install. Check explanation of sub-install and this is completely optional, so If you want not, just go onto the next step.'] = '|cff1784d1KnightFrame|r은 부가 설치를 지원합니다. 각 부가설치의 내용을 확인해보시고, 부가 설치는 선택사항이니 원하지 않으면 다음 단계로 넘어가세요.'
	L['Current Order'] = '현재 명령'
	L['Do not install any sub-install.'] = '어떤 부가 설치도 하지 않음'
	L['Add Important Raid Debuff'] = '중요 레이드디버프 추가'
	L['Add some of missing important raid debuff to unitframe filter.'] = '유닛프레임에 레이드에서 중요한 몇몇 누락된 디버프 값들을 입력합니다.'
	
	--Page 6
	L['Installation Complete'] = '설치 완료'
	L['Now installation precess is end. If you click the button below then KnightFrame will overwrite your current config profile for constructing UI layout theme and then reload.'] = '설치과정이 끝났습니다. 아래의 |cff2eb7e4설치 완료|r 버튼을 누르면|n|cff1784d1KnightFrame|r은 당신이 설치 과정에서 설정한 대로 현재의 프로필에|n설정값 데이터들을 입력하고 리로드할겁니다.'
	L['If you have any suggestion, please send an email to me: qjr2513@naver.com'] = '사용하면서 건의사항이 있으면 |cff2eb7e4qjr2513@naver.com|r 으로 메일주세요.'
end


do	-- print message
	L['You canceled KnightFrame install. If you wants to run KnightFrame install process again, please type /kf_install command.'] = '|cff1784d1KnightFrame|r 설치를 하지 않고 설치창을 닫았습니다. 다시 설치를 하고 싶으시면 |cff1784d1/kf_install|r 명령어를 입력하세요.'
end


do	-- Modules
	do -- CustomPanel
		L['Custom Panel'] = '커스텀 패널'
		L['Panel Name'] = '대화창 이름'
		L['Enable Texture'] = '배경그림 사용'
		L['Texture Alpha'] = '배경그림 투명도'
		L['Texture Path'] = '배경그림 파일위치'
		L['Left Button'] = '좌측에서부터 버튼 삽입'
		L['Right Button'] = '우측에서부터 버튼 삽입'
		
		-- need fixing
		L['Panel that named same is already exists. Please enter a another name.'] = '이미 같은 이름을 사용하는 프레임이 있습니다. 다른 이름을 입력하세요.'
		L['Custom Panel that named same is already exists.'] = '이미 같은 이름을 사용하는 커스텀 패널의 데이터가 있습니다.'
		L['New data has been saved successfully and %s was created.'] = '새로운 데이터가 저장되었고 %s 가 생성되었습니다.'
		L['All changes have been saved to %s data.'] = '변경된 데이터가 %s 데이터에 덮어씌워졌습니다.'
	end
	
	do -- FloatingDatatext
		L['Datatext Name'] = '정보문자 이름'
		L['Ignore Cursor'] = '커서반응 끄기'
		L['Datatext Module'] = '사용할 정보문자'
		L['by Spec Role'] = '전문화 역할에 따라'
		L['PvP Mode'] = 'PvP 시 변경'
		L['Texture'] = '텍스쳐'
		L['Use Custom FontStyle'] = '이 정보문자만 글꼴스타일 따로설정'
	end
	
	do -- Smart Tracker
		-- General
		L['General Setting'] = '일반 설정'
			L['Detail SpellTooltip'] = '스킬툴팁 항상보기'
			L['Erase leaved user'] = '파탈 유저 지우기'
				L["Erase specific user's all cooltime bar who left group."] = '파티를 탈퇴하는 유저들의 쿨타임 바를 자동으로 지웁니다.|n|n(플레이어가 파티를 나갈 때엔 플레이어의 쿨타임을 제외한 모든 바를 삭제하게 됩니다.)'
		L['Inspect Parts'] = '살펴보기 부분 설정'
			L['Auta Scanning'] = '자동 살펴보기'
				L["SmartTracker will check new member of groups automatically."] = '구성원이 새로 합류해 해당 유저의 데이터가 없으면 자동으로 캐릭터 세팅을 검사합니다.'
			L['Update old data'] = '기존 파티원 재검사'
				L["After new member's scanning, scan old member's setting for updating."] = '새로운 멤버의 검사가 끝난 후, 세팅 업데이트를 위해 기존 멤버들을 재검사합니다.'
			L['Update when ready check'] = '전준시 재검사'
				L['When leader check ready then update all members setting again.'] = '전투준비를 했을 때 모든 유저의 데이터를 재검사합니다.'
				
		
		-- Sort Order
		L['Sort Order'] = '정렬 방법'
			L['By Role'] = '역할에 따른 순서'
			L['By Class'] = '직업에 따른 순서'
		
		-- Class Color
		L['Class Color'] = '직업별 색상설정'
			L['Charged Bar Color %d'] = '바 충전 색상 %d번'
		
		-- Window Setting
		L['Window Setting'] = '창 설정'
			L['Appearance'] = '외형'
				L['Cooldown Bar'] = '쿨다운 바'
					L['Bar Direction'] = '바 생성방향'
						L['Upper the tab'] = '탭 위로 쌓기'
						L['Below the tab'] = '탭 아래로 놓기'
					L['Bar Height'] = '바 세로길이'
					L['Bar Fontsize'] = '글자 크기'
					L['Number of Target Display'] = '표시할 스킬 대상 수'
				
				L['Window Tab Color'] = '윈도우 탭 색상'
				L['Bar Background Color'] = '바 뒷배경 색상'
			
			L['Display Condition'] = '표시 조건 설정'
				L['Group Situation'] = '파티 상황'
					L['Solo Playing'] = '솔플 시 표시'
					L['Group Playing'] = '그룹 때 표시'
				L['Location Condition'] = '장소 조건'
					L['In Field'] = '필드에서 표시'
					L['In Instance'] = '인스에서 표시'
					L['In RaidDungeon'] = '레이드에서 표시'
					L['In PvPGround'] = 'PvP에서 표시'
				L['Player Condition'] = '내 캐릭 상태조건'
					L["When I'm Tank"] = '탱커일 때 표시'
					L["When I'm Healer"] = '힐러일 때 표시'
					L["When I'm Caster"] = '캐스터일 때 표시'
					L["When I'm Melee"] = '밀리일 때 표시'
					L["When I'm GroupLeader"] = '파티장일 때 표시'
				L['Filtering by Role'] = '역할에 따른 바 필터링'
					L['Display Tank'] = '탱커유저 바 표시'
					L['Display Healer'] = '힐러유저 바 표시'
					L['Display Caster'] = '캐스터유저 바 표시'
					L['Display Melee'] = '밀리유저 바 표시'
		
		-- Icon Setting
		L['Icon Setting'] = '아이콘 설정'
			L['Spell Icon'] = '주문 아이콘'
				L['Icon Width'] = '아이콘 가로길이'
				L['Icon Height'] = '아이콘 세로길이'
				L['Icon Spacing'] = '아이콘 간격'
				L['Count FontSize'] = '주문수 글자 크기'
				
			L['Icon Arrangement'] = '아이콘 배치방법'
				L['Icon Orientation'] = '아이콘 생성방향'
				L['Icon Align'] = '정렬방법'
	end
	
	do -- Armory
		L['Armory'] = '전투정보실'
		L['Character Armory'] = '캐릭터 전정실'
		L['Inspect Armory'] = '살펴보기 전정실'
		
		L['Enchant String'] = '마법부여'
			L['Replacing List'] = '교체 목록'
			L['There is no replacing order.'] = '지정한 교체 요청이 없습니다.'
			L['Add New Replacing Order'] = '마법부여 글자 추가'
			L['Target Enchant'] = '대상 마법부여'
			L['String To Replacing'] = '교체할 글자'
			L['Add New Order'] = '새로운 주문 입력'
			L['Delete Replacing Order'] = '교체주문 삭제'
			
		L['Notice Missing Enchant or Gems'] = '마부&보석 누락 경고 표시'
		
		L['Select Backdrop'] = '배경 선택'
			L['Custom'] = '개인 설정'
			L['Space BG'] = '우주'
			L['The Empire BG'] = 'Empire길드'
			L['Castle BG'] = '고성'
			L['Custom Backdrop Image Address'] = '개인 배경파일 경로'
		
		L['Gradation'] = '그라데이션'
			L['Display Gradation'] = '그라데이션 표시'
			L['Default Color'] = '기본 표시색'
		
		L['Display Method'] = '표시 방법'
			L['Show Upgrade Level'] = '업글레벨 표시'
			L['Warning Size'] = '경고표시 크기'
			L['Show Warning Only'] = '경고만 표시'
			L['Only Damaged'] = '손상된 것만'
		
		L['Gem Socket'] = '보석홈'
			L['Socket Size'] = '소켓 크기'
		
	end
	
	do -- Secretary
		L['Secretary'] = '비서 기능'
			-- Alarm
			L['This function will notice you when specific events was happened.'] = '알람기능은 사용자가 원하는 상황일 때에 설정한 방법으로 알려줍니다.'
			L['Alarm Method'] = '알람 방법'
				L['Blink Client'] = '창 깜박이기'
					L['Blink wow client in system tray when you minimized and event happen.'] = '와우를 최소화한 상태에서 이벤트가 발생하면 시작줄에 깜박이게 합니다.'
				L['TurnOn Sound'] = '사운드 켜기'
					L["Turn on sounds when you turn off wow's sound and event happen."] = '와우소리를 끈 상태에서 이벤트가 발생하면 소리를 켜 알립니다.'
			
			L['ToggleObjectiveFrame'] = '임무창 자동숨김'
			L['This function will toggle objective frame automatically in specific situation.'] = '이 기능은 특정한 상황에 돌입했을 때 임무창을 자동으로 숨겨줍니다.'
		
		L['Event to Alarm'] = '알릴 이벤트'
			L['Contents Queue'] = '컨텐츠 입장확인'
	end
	
	do -- SynergyIndicator
		L['Synergy Indicator'] = '시너지 표시기'
	end
	
	
	L['ExpRep Display'] = '경험치 평판 표시기'
		L['Frame To Embed'] = '고정할 프레임'
		L['Embed Location'] = '고정할 위치'
		L['Lock ExpRep Display'] = '디스플레이 고정'
	
	
	
	L['Misc'] = '기타'
	L['Minimap Backdrop When FarmMode'] = '채집모드 사용 시 미니맵 배경 표시'
	
	L['Switch Equipment'] = '장비세트 자동변경'
		L['Change equipment set when changing specialization or entering a pvp area(battleground or arena).'] = '전문화를 변경하거나 전장, 투기장에 입장하면 지정한 장비세트를 자동으로 입습니다.'
		L['Primary'] = '전문화 1'
		L['Secondary'] = '전문화 2'
		L['PvP Area'] = '전장,투기장 진입 시'
	
	L['Embed Meter'] = '미터기 고정'
		L["Embed MeterAddon to ElvUI's Chat Panel or KnightFrame's Custom Panel."] = '미터기애드온을 ElvUI 의 좌우 채팅창이나 나이트프레임의 커스텀 패널에 고정합니다.'
		
	L['TimeFormat'] = '시간단위 변경'
	
	L['Knight Inspect'] = '살펴보기'
		L['Adds additional information to your character panel.'] = '전투정보실처럼 보이도록 캐릭터 프레임에 마부보석 정보를 표시합니다.'
	
	L['Full Values'] = '실수치로 표시'
	
	L['Tooltip Talent'] = '툴팁에 특성표시'
	L['Show Chat Tab'] = '채팅창 탭 항상보기'
	L['Toggle WatchFrame'] = '퀘스트창 자동숨김'
	
	L['Bank Open'] = '은행에서 가방 자동열기'
	
	--[[
	L['RaidCooldown'] = '레이드쿨다운'
	
	--General
		L['Hide When Solo'] = '솔로잉시 숨기기'
			L["Hides RaidCooldown's window when not in a party or raid."] = '파티나 레이드 상태가 아닐 땐 레이드쿨다운을 숨깁니다.'
		
		L['Erase Bar'] = '바 자동 지우기'
			
		
		L['Detail Tooltip'] = '자세한 스킬 툴팁'
		
		L['Cooldown End Announce'] = '쿨타임 종료 알림'
			L["Announce will send this option's selected channel."] = '특정 채널을 선택하면, 종료시 알림으로 설정한 스킬들이 재사용 가능해질 때 채널로 알려줍니다.'
			L['Self'] = '자신만 보기'
			L['Say'] = '일반'
			L['Party'] = '파티'
			L['Raid'] = '레이드'
			L['Guild'] = '길드'
			
	L["Scan Group Member's Setting"] = '파티원 세팅 검사'
		L['Auto Scan'] = '자동 검사'
			
		L['Check Changing'] = '변경 시 재검사'
			L['If group member CHANGE his setting(specialization or talent or glyph), reinspect him.|n|nThis function works only when that member is near you.'] = '파티원이 전문화나 특성, 문양을 |cffff0000변경|r하면 해당 유저를 다시 검사합니다.|n|n이 기능은 그 유저가 당신 근처에 있을 때에만 작동합니다.'
		L['Update After Scanning'] = '검사 후 업데이트'
		L['Update all when ready check.'] = '전투준비 때 모두 업데이트'
	
	L['Cooltime Bar'] = '쿨타임 바'
			
		
		L['RaidIcon'] = '레이드 아이콘'
			L['Spacing'] = '간격'
			L['StartPoint'] = '시작 기준위치'
				L['Left'] = '좌측'
				L['Right'] = '우측'
			L['Direction'] = '방향'
				L['Upper'] = '메인프레임 위'
				L['Below'] = '메인프레임 아래'
			L['Display MaxCount'] = '최대수량 표시'
		
		L['MainFrame'] = '메인프레임'
		L['Bar Background'] = '바 뒷배경'
		L['Charged Bar'] = '충전된 바'
	
	L['Display Skill Setting'] = '쿨타임을 표시할 스킬 설정'
		L['Survival Spells'] = '생존기'
		L['Interrupt Spells'] = '차단기'
		L['Utility Spells'] = '유틸리티'
		
		L['Out of Combat'] = '보스전 외 표시'
			L['Shows cooldown while not in combat with a boss.'] = '해당 스킬을 표시하지만 보스전에 돌입하면 표시하지 않습니다. (도적의 은폐의 장막 같은 스킬에 추천)'
		L['Announce Off'] = '표시, 알림X'
			L['Displays cooldown timer without announcing in the selected channel.'] = '해당 스킬을 표시하지만 쿨타임이 끝났을 때 알리진 않습니다.'
		L['Announce On'] = '표시, 알림O'
			L["Displays cooldown timer and announces when they're available in the selected channel."] = '해당 스킬을 표시하며, 쿨타임이 끝났을 때 설정해둔 채널로 알립니다.'
	
	L['Create New Icon'] = '새로운 아이콘 만들기'
		L['Reset'] = '초기화'
		L['Delete'] = '삭제'
		
		L['Invalid Spell ID. Please Check Spell ID.'] = '올바르지 않은 주문ID 입니다. 주문ID를 다시 확인하세요.'
		L['New RaidIcon Setting has been saved successfully.'] = '새로운 레이드아이콘 정보를 생성했습니다.'
		
		L['Spell ID'] = '주문ID'
		L['Required'] = '필수입력'
	]]
end