if GetLocale() ~= 'koKR' then return end

local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)

do	--General
	L['Install'] = '설치'
	L['Warning'] = '경고'
	L['Disable'] = '사용 안함'
	L['function required'] = '기능 필요'
	L['Re-Install KnightFrame'] = '나이트프레임 재설치'
	L['Check PatchNote'] = '패치노트 확인'
	
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
	L['Custom Panel'] = '커스텀 패널'
		L['Panel Name'] = '대화창 이름'
		L['Enable Texture'] = '배경그림 사용'
		L['Texture Alpha'] = '배경그림 투명도'
		L['Texture Path'] = '배경그림 파일위치'
		L['Left Button'] = '좌측에서부터 버튼 삽입'
		L['Right Button'] = '우측에서부터 버튼 삽입'
	
	
		L['Datatext Name'] = '정보문자 이름'
		L['Ignore Cursor'] = '커서반응 끄기'
		L['Datatext Module'] = '사용할 정보문자'
		L['by Spec Role'] = '전문화 역할에 따라'
		L['PvP Mode'] = 'PvP 시 변경'
		L['Texture'] = '텍스쳐'
		L['Use Custom FontStyle'] = '이 정보문자만 글꼴스타일 따로설정'
		
	L['Top Panel'] = '상단 패널'
	
	L['ExpRep Display'] = '경험치 평판 표시기'
		L['Frame To Embed'] = '고정할 프레임'
		L['Embed Location'] = '고정할 위치'
		L['Lock ExpRep Display'] = '디스플레이 고정'
	
	L['Frame that named same is already exists. Please enter a another name.'] = '이미 같은 이름을 사용하는 프레임이 있습니다. 다른 이름을 입력하세요.'
	L['Custom Panel that named same is already exists.'] = '이미 같은 이름을 사용하는 커스텀 패널의 데이터가 있습니다.'
	L['New data has been saved successfully and %s was created.'] = '새로운 데이터가 저장되었고 %s 가 생성되었습니다.'
	L['All changes have been saved to %s data.'] = '변경된 데이터가 %s 데이터에 덮어씌워졌습니다.'
	
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
	L['Synergy Tracker'] = '시너지 추적기'
	L['Bank Open'] = '은행에서 가방 자동열기'
	
	L['RaidCooldown'] = '레이드쿨다운'
	
	--General
		L['Hide When Solo'] = '솔로잉시 숨기기'
			L["Hides RaidCooldown's window when not in a party or raid."] = '파티나 레이드 상태가 아닐 땐 레이드쿨다운을 숨깁니다.'
		
		L['Erase Bar'] = '바 자동 지우기'
			L["Erase specific user's all cooltime bar who left group."] = '파티를 탈퇴하는 유저들의 쿨타임 바를 자동으로 지웁니다.|n|n(플레이어가 파티를 나갈 때엔 플레이어의 쿨타임을 제외한 모든 바를 삭제하게 됩니다.)'
		
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
			L["RaidCooldown will check group member's setting automatically when there is no data."] = '파티원이 새로 합류하여 해당 유저의 데이터가 없으면 자동으로 검사합니다.'
		L['Check Changing'] = '변경 시 재검사'
			L['If group member CHANGE his setting(specialization or talent or glyph), reinspect him.|n|nThis function works only when that member is near you.'] = '파티원이 전문화나 특성, 문양을 |cffff0000변경|r하면 해당 유저를 다시 검사합니다.|n|n이 기능은 그 유저가 당신 근처에 있을 때에만 작동합니다.'
		L['Update After Scanning'] = '검사 후 업데이트'
			L["After new member's scanning, scan old member's setting for updating."] = '새로운 멤버의 검사가 끝난 후, 세팅을 업데이트하기 위해 기존에 있던 멤버들을 재검사합니다.'
	
	L['Appearance'] = '외형'
		L['Cooltime Bar'] = '쿨타임 바'
			L['Bar Direction'] = '바 생성방향'
			L['Bar Height'] = '바 세로길이'
			L['Fontsize'] = '글자 크기'
		
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
end