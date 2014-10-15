local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 27
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return
elseif KF.UIParent then
	-----------------------------------------------------------
	-- [ Knight : Spell Data								]--
	-----------------------------------------------------------
	KF.Table['RaidCooldownSpell'] = {
		['WARRIOR'] = {
			[97462] = { 180, false, 'Survival', }, --재집결
			[114030] = { 120, true, 'Survival', }, --경계
			[871] = { 180, false, 'Survival', }, --방벽
			[12975] = { 180, false, 'Survival', }, --최저
			[114203] = { 180, false, 'Survival', }, --사기의 깃발
			[114029] = { 30, true, 'Survival', }, --수비대장
			[1160] = { 60, false, 'Survival', }, --사기의 외침
			[118038] = { 120, false, 'Survival', }, --투사의 혼
			[55694] = { 60, false, 'Survival', }, --격노의 재생력
			[103840] = { 30, false, 'Survival', }, --예견된 승리
			
			[102060] = { 40, false, 'Interrupt', }, --훼방의 외침
			[6552] = { 15, true, 'Interrupt', }, --자루 공격
			[57755] = { 30, true, 'Interrupt', }, --영웅의 투척
			
			[114207] = { 180, false, 'Utility', }, --해골 깃발
			[114028] = { 60, false, 'Utility', }, --대규모 반사
			[107574] = { 180, false, 'Utility', }, --투신
			[114192] = { 180, false, 'Utility', }, --도발 깃발
			[107566] = { 40, false, 'Utility', }, --충격의 외침
			[46924] = { 60, false, 'Utility', }, --칼날 폭풍
			[46968] = { 20, false, 'Utility', }, --충격파
			[118000] = { 60, false, 'Utility', }, --용의 포효
			[12292] = { 60, false, 'Utility', }, --피범벅
			[107570] = { 30, false, 'Utility', }, --폭풍망치
			[676] = { 60, true, 'Utility', }, --무장 해제
			[18499] = { 30, false, 'Utility', }, --광전사의 격노
			[64382] = { 300, true, 'Utility', }, --분쇄의 투척
			[355] = { 8, true, 'Utility', }, --도발
			[6544] = { 45, false, 'Utility', }, --영웅의 도약
			[5246] = { 60, false, 'Utility', }, --위협의 외침
			[23920] = { 25, false, 'Utility', }, --주문 반사
			[1719] = { 300, false, 'Utility', }, --무모한 희생
		},
		['HUNTER'] = {
			[148467] = { 120, false, 'Survival', }, --공격저지
			[109304] = { 120, false, 'Survival', }, --활기
			
			[34490] = { 24, true, 'Interrupt', }, --침묵의 사격
			[147362] = { 24, true, 'Interrupt', }, --반격의 사격
			
			[781] = { 20, false, 'Utility', }, --철수
			[19386] = { 45, true, 'Utility', }, --비룡 쐐기			
			[82726] = { 30, false, 'Utility', }, --열정
			[109248] = { 45, false, 'Utility', }, --구속의 사격
			[120679] = { 30, false, 'Utility', }, --광포한 야수
			[131894] = { 120, false, 'Utility', }, --저승까마귀
			[130392] = { 20, true, 'Utility', }, --점멸의 일격
			[120697] = { 90, false, 'Utility', }, --스라소니 돌진
			[117050] = { 15, false, 'Utility', }, --글레이브 투척
			[109259] = { 60, false, 'Utility', }, --강화사격
			[120360] = { 30, false, 'Utility', }, --탄막
			[20736] = { 8, true, 'Utility', }, --견제 사격
			[1499] = { 30, false, 'Utility', }, --빙결의 덫
			[13809] = { 30, false, 'Utility', }, --얼음의 덫
			[34600] = { 30, false, 'Utility', }, --뱀 덫
			[19503] = { 30, true, 'Utility', }, --산탄 사격
			[1543] = { 20, false, 'Utility', }, --섬광
			[3045] = { 180, false, 'Utility', }, --속사
			[19574] = { 60, false, 'Utility', }, --야수의 격노
			[51753] = { 60, false, 'Utility', }, --위장술
			[19577] = { 60, false, 'Utility', }, --위협
			[53271] = { 45, true, 'Utility', }, --주인의 부름
			[121818] = { 300, false, 'Utility', }, --쇄도
			[19801] = { 0, true, 'Utility', }, --평정의 사격
			[126393] = { 600, true, 'Utility', }, --기렌 전투부활
		},
		['SHAMAN'] = {
			[108271] = { 90, false, 'Survival', }, --영혼 이동
			[108280] = { 180, false, 'Survival', }, --치유해일 토템
			[98008] = { 180, false, 'Survival', }, --정신고리 토템
			[108270] = { 60, false, 'Survival', }, --돌의 보루 토템
			[30823] = { 60, false, 'Survival', }, --주술의 분노
			
			[57994] = { 12, true, 'Interrupt', }, --날카로운 바람
			
			[370] = { 0, true, 'Utility', }, --정화
			[16190] = { 180, false, 'Utility', }, --마나해일 토템
			[8143] = { 60, false, 'Utility', }, --진동토템
			[108281] = { 120, false, 'Utility', }, --고대의 인도
			[51485] = { 30, false, 'Utility', }, --구속의 토템
			[108273] = { 60, false, 'Utility', }, --바람걸음 토템
			[2484] = { 30, false, 'Utility', }, --속박의 토템
			[108279] = { 60, false, 'Utility', }, --고요한 마음의 토템
			[108269] = { 45, false, 'Utility', }, --축전 토템
			[8177] = { 25, false, 'Utility', }, --마법흡수 토템
			[2894] = { 300, false, 'Utility', }, --불의 정령 토템
			[51514] = { 45, true, 'Utility', }, --사술
			[51490] = { 45, false, 'Utility', }, --천둥폭풍
			[58875] = { 120, false, 'Utility', }, --정령의 걸음
			[108235] = { 180, false, 'Utility', }, --원소의 부름
			[108287] = { 10, false, 'Utility', }, --토템 재배치
			[16166] = { 90, false, 'Utility', }, --정기의 깨달음
			[16188] = { 60, false, 'Utility', }, --고대의 신속함
			[2062] = { 300, false, 'Utility', }, --대지의 정령 토템
			[114049] = { 180, false, 'Utility', }, --지배력
			[51533] = { 120, false, 'Utility', }, --야수 정령
			[120668] = { 300, false, 'Utility', }, --폭풍채찍 토템
			[79206] = { 120, false, 'Utility', }, --영혼나그네의 은총
		},
		['MONK'] = {
			[115203] = { 180, false, 'Survival', }, --강화주
			[115213] = { 180, false, 'Survival', }, --해악 방지
			[115176] = { 180, false, 'Survival', }, --명상
			[116849] = { 120, true, 'Survival', }, --기의 고치
			[115310] = { 180, false, 'Survival', }, --재활
			[122470] = { 90, false, 'Survival', }, --업보의 손아귀
			[122278] = { 90, false, 'Survival', }, --해악 감퇴
			[122783] = { 90, false, 'Survival', }, --마법 해소
			[116680] = { 45, false, 'Survival', }, --집중의 천둥 차
			[115295] = { 30, false, 'Survival', }, --방어 자세
			[115315] = { 30, false, 'Survival', }, --흑우 조각상
			
			[116705] = { 15, true, 'Interrupt', }, --손날 찌르기
			
			[115399] = { 45, false, 'Utility', }, --원기주
			[137562] = { 120, false, 'Utility' }, --민활주
			[116844] = { 45, false, 'Utility', }, --평화의 고리
			[116841] = { 30, true, 'Utility', }, --범의 욕망
			[119392] = { 30, false, 'Utility', }, --황소 쇄도
			[119381] = { 45, false, 'Utility', }, --팽이 차기
			[116847] = { 30, false, 'Utility', }, --비취 돌풍
			[123904] = { 180, false, 'Utility', }, --백호 쉬엔의 원령
			[115078] = { 15, true, 'Utility', }, --마비
			[117368] = { 60, true, 'Utility', }, --무기 낚아채기
			[115080] = { 90, true, 'Utility', }, --절명의 손길
			[115546] = { 8, true, 'Utility', }, --조롱
			[101643] = { 45, false, 'Utility', }, --해탈
			[119996] = { 25, false, 'Utility', }, --해탈: 전환
			[115288] = { 60, false, 'Utility', }, --기력 회복주
			[113656] = { 25, false, 'Utility', }, --분노의 주먹
			[101545] = { 25, false, 'Utility', }, --비룡차기
			[122057] = { 35, false, 'Utility', }, --충돌
		},
		['ROGUE'] = {
			[31224] = { 60, false, 'Survival', }, --그망
			[74001] = { 120, false, 'Survival', }, --전투 준비
			[1856] = { 180, false, 'Survival', }, --소멸
			[76577] = { 180, false, 'Survival', }, --연막
			[5277] = { 120, false, 'Survival', }, --회피
			
			[1766] = { 15, true, 'Interrupt', }, --발차기
			
			[2983] = { 60, false, 'Utility', }, --전질
			[51722] = { 60, true, 'Utility', }, --장분
			[14185] = { 300, false, 'Utility', }, --마음가짐
			[36554] = { 20, true, 'Utility', }, --그림자 밟기
			[408] = { 20, true, 'Utility', }, --급소 가격
			[2094] = { 120, true, 'Utility', }, --실명
			[1725] = { 30, false, 'Utility', }, --혼란
			[1776] = { 10, true, 'Utility', }, --후려치기
			[114842] = { 60, false, 'Utility', }, --그림자 걷기
			[5938] = { 10, true, 'Utility', }, --독칼
			[57934] = { 30, true, 'Utility', }, --속임수 거래
			[51713] = { 60, false, 'Utility', }, --어둠의 춤
			[121471] = { 180, false, 'Utility', }, --어둠의 칼날
			[79140] = { 120, true, 'Utility', }, --원한
			[51690] = { 120, true, 'Utility', }, --광기의 학살자
			[13750] = { 180, false, 'Utility', }, --아드레날린 촉진
			[114018] = { 300, false, 'Utility', }, --은폐의 장막
		},
		['DEATHKNIGHT'] = {
			[48792] = { 180, false, 'Survival', }, --얼음같은 인내력
			[55233] = { 60, false, 'Survival', }, --흡혈
			[114556] = { 180, false, 'Survival', }, --연옥
			[49222] = { 60, false, 'Survival', }, --뼈보
			[48982] = { 30, false, 'Survival', }, --룬전환
			[48743] = { 120, false, 'Survival', }, --죽음의 서약
			[48707] = { 45, false, 'Survival', }, --대마보
			[51052] = { 120, false, 'Survival', }, --대마지
			[81256] = { 90, false, 'Survival', }, --춤추는 룬무기
			[49039] = { 120, false, 'Survival', }, --리치의 혼
			[47568] = { 300, false, 'Survival', }, --룬무기 강화
			[108201] = { 120, false, 'Survival', }, --더럽혀진 대지
			
			[47528] = { 15, true, 'Interrupt', }, --정신 얼리기
			[47476] = { 60, true, 'Interrupt', }, --질식시키기
			[108194] = { 30, true, 'Interrupt', }, --어둠의 질식
			
			[42650] = { 600, false, 'Utility', }, --사자의 군대
			[49206] = { 180, false, 'Utility', }, --가고일 부르기
			[49016] = { 180, true, 'Utility', }, --부정의 광기
			[51271] = { 60, false, 'Utility', }, --얼음 기둥
			[61999] = { 600, true, 'Utility', }, --아군 되살리기
			[115989] = { 90, false, 'Utility', }, --부정의 파멸충
			[96268] = { 30, false, 'Utility', }, --죽음의 진군
			[108199] = { 60, false, 'Utility', }, --고어핀드의 손아귀
			[108200] = { 60, false, 'Utility', }, --냉혹한 겨울
			[46584] = { 120, false, 'Utility', }, --시체 되살리기
			[49576] = { 25, true, 'Utility', }, --죽음의 손아귀
			[77606] = { 60, true, 'Utility', }, --어둠 복제
			[123693] = { 25, false, 'Utility', }, --역병 착취
		},
		['MAGE'] = {
			[45438] = { 300, false, 'Survival', }, --얼방
			[108978] = { 180, false, 'Survival', }, --시간돌리기
			[110959] = { 90, false, 'Survival', }, --상급 투명화
			[115610] = { 25, false, 'Survival', }, --시간의 보호막
			[11426] = { 25, false, 'Survival', }, --얼음 보호막
			[111264] = { 20, true, 'Survival', }, --얼음 수호물
			[1463] = { 25, false, 'Survival', }, --주문술사 보호막
			
			[102051] = { 20, true, 'Interrupt', }, --서리투성이 턱
			[2139] = { 28, true, 'Interrupt', }, --마법 차단
			
			[11958] = { 180, false, 'Utility', }, --매서운 한파
			[12051] = { 120, false, 'Utility', }, --환기
			[12043] = { 90, false, 'Utility', }, --냉정
			[108839] = { 45, false, 'Utility', }, --빙하
			[108843] = { 25, false, 'Utility', }, --타오르는 속도
			[113724] = { 30, false, 'Utility', }, --서리 고리
			[122] = { 25, false, 'Utility', }, --얼음 회오리
			[1953] = { 15, false, 'Utility', }, --점멸
			[55342] = { 180, false, 'Utility', }, --환영 복제
			[66] = { 300, false, 'Utility', }, --투명화
			[44572] = { 30, true, 'Utility', }, --동결
			[80353] = { 300, false, 'Utility', }, --시간 왜곡
			[12042] = { 90, false, 'Utility', }, --신비한 마법 강화
			[11129] = { 45, true, 'Utility', }, --발화
			[31661] = { 20, false, 'Utility', }, --용의 숨결
			[84714] = { 60, false, 'Utility', }, --얼어붙은 구슬
			[12472] = { 180, false, 'Utility', }, --얼음 핏줄
		},
		['DRUID'] = {
			[106922] = { 180, false, 'Survival', }, --우르속의 힘
			[102342] = { 60, true, 'Survival', }, --무쇠껍질
			[61336] = { 180, false, 'Survival', }, --생존본능
			[22812] = { 60, false, 'Survival', }, --나무 껍질
			[108238] = { 120, false, 'Survival', }, --소생
			[740] = { 480, false, 'Survival', }, --평온
			[124974] = { 90, false, 'Survival', }, --자연의 경계
			[102351] = { 30, true, 'Survival', }, --세나리온의 보호
			[108288] = { 360, false, 'Survival', }, --야생의 정수
			
			[106839] = { 15, true, 'Interrupt', }, --두개골 강타
			[78675] = { 60, true, 'Interrupt', }, --태양 광선
			[770] = { 0, true, 'Interrupt', }, --요정의 불꽃
			
			[50334] = { 180, false, 'Utility', }, --광폭화
			[29166] = { 180, true, 'Utility', }, --정신 자극
			[20484] = { 600, true, 'Utility', }, --환생
			[77761] = { 120, false, 'Utility', }, --쇄포 (곰)
			[106731] = { 180, false, 'Utility', }, --화신
			[102280] = { 30, false, 'Utility', }, --야수 탈주
			[102401] = { 15, false, 'Utility', }, --야생의 돌진
			[102359] = { 30, true, 'Utility', }, --대규모 휘감기
			[132469] = { 30, false, 'Utility', }, --태풍
			[106737] = { 60, false, 'Utility', }, --자연의 군대
			[99] = { 30, false, 'Utility', }, --혼란의 포효
			[102793] = { 60, false, 'Utility', }, --우르솔의 회오리
			[5211] = { 50, true, 'Utility', }, --거센 강타
			[16689] = { 45, false, 'Utility', }, --자연의 손아귀
			[1850] = { 180, false, 'Utility', }, --질주
			[102795] = { 60, true, 'Utility', }, --격한 포옹
			[6795] = { 8, true, 'Utility', }, --포효
			[5229] = { 60, false, 'Utility', }, --격노
			[48505] = { 90, false, 'Utility', }, --별똥별
			[112071] = { 180, false, 'Utility', }, --천공의 정렬
			[5217] = { 30, false, 'Utility', }, --호랑이의 분노
		},
		['PALADIN'] = {
			[498] = { 60, false, 'Survival', }, --가호
			[86659] = { 180, false, 'Survival', }, --고왕수:보기
			[642] = { 300, false, 'Survival', }, --무적
			[31850] = { 180, false, 'Survival', }, --헌수
			[114039] = { 30, true, 'Survival', }, --정화의 손길
			[6940] = { 120, true, 'Survival', }, --희손
			[633] = { 600, true, 'Survival', }, --신축
			[1022] = { 300, true, 'Survival', }, --보축
			[31821] = { 180, false, 'Survival', }, --헌신의 오라
			
			[96231] = { 15, true, 'Interrupt', }, --비난
			
			[31884] = { 180, false, 'Utility', }, --응징의 격노
			[105593] = { 30, true, 'Utility', }, --심판의 주먹
			[20066] = { 15, true, 'Utility', }, --참회
			[1038] = { 120, true, 'Utility', }, --구원의 손길
			[114165] = { 20, true, 'Utility', }, --성스러운 빛기둥
			[114158] = { 60, false, 'Utility', }, --빛의 망치
			[54428] = { 120, false, 'Utility', }, --신성한 기도
			[853] = { 60, false, 'Utility', }, --심판의 망치
			[62124] = { 8, true, 'Utility', }, --심판의 손길
			[1044] = { 25, true, 'Utility', }, --자유의 손길
			[115750] = { 120, false, 'Utility', }, --눈부신 빛
			[119072] = { 8.23, false, 'Utility', }, --신의 격노
			[86698] = { 180, false, 'Utility', }, --고왕수:징기
			[85499] = { 45, false, 'Utility', }, --빛의 속도
			[31842] = { 180, false, 'Utility', }, --신의 은총
			[114157] = { 60, true, 'Utility', }, --사형 선고
			[105809] = { 120, false, 'Utility', }, --신성한 복수자
			[86669] = { 180, false, 'Utility', }, --고왕수:신기
		},
		['PRIEST'] = {
			[62618] = { 180, false, 'Survival', }, --방벽
			[33206] = { 180, true, 'Survival', }, --고억
			[47788] = { 180, true, 'Survival', }, --수호영혼
			[47585] = { 120, false, 'Survival', }, --분산
			[64843] = { 180, false, 'Survival', }, --천찬
			[19236] = { 120, false, 'Survival', }, --구원의 기도
			[120517] = { 40, false, 'Survival', }, --후광
			[724] = { 180, false, 'Survival', }, --빛샘
			[15286] = { 180, false, 'Survival', }, --흡혈의 선물
			
			[15487] = { 45, true, 'Interrupt', }, --침묵
			
			[108920] = { 30, false, 'Utility', }, --공허의 촉수
			[108921] = { 45, false, 'Utility', }, --영혼의 마귀
			[605] = { 30, true, 'Utility', }, --정신 지배
			[123040] = { 60, false, 'Utility', }, --환각의 마귀
			[112833] = { 30, false, 'Utility', }, --유령의 가면
			[121135] = { 25, false, 'Utility', }, --빛의 길
			[586] = { 30, false, 'Utility', }, --소실
			[8122] = { 30, false, 'Utility', }, --영혼의 절규
			[109964] = { 60, false, 'Utility', }, --혼의 너울
			[81700] = { 30, false, 'Utility', }, --대천사
			[6346] = { 180, true, 'Utility', }, --공포의 수호물
			[88625] = { 30, true, 'Utility', }, --신의 권능: 응징
			[32375] = { 15, false, 'Utility', }, --대규모 무효화
			[64044] = { 45, true, 'Utility', }, --정신적 두려움
			[73325] = { 90, true, 'Utility', }, --신의의 도약
			[64901] = { 360, false, 'Utility', }, --희찬
			[108968] = { 300, true, 'Utility', }, --공허의 전환
			[10060] = { 120, true, 'Utility', }, --마력 주입
			[89485] = { 45, false, 'Utility', }, --내면의 집중력
			[34433] = { 180, false, 'Utility', }, --어둠의 마귀
			[110744] = { 15, false, 'Utility', }, --천상의 별
		},
		['WARLOCK'] = {
			[6229] = { 30, false, 'Survival', }, --황혼의 수호
			[6789] = { 45, true, 'Survival', }, --죽음의 고리			
			[104773] = { 180, false, 'Survival', }, --영원한 결의
			[108359] = { 120, false, 'Survival', }, --어둠의 재생력
			[108416] = { 60, false, 'Survival', }, --희생의 서약
			[108482] = { 60, false, 'Survival', }, --해방된 의지
			[110913] = { 180, false, 'Survival', }, --어둠의 거래
			[119899] = { 30, false, 'Survival', }, --임프 : 상처 지지기

			[19647] = { 24, true, 'Interrupt', }, --지옥사냥개 : 주문 잠금
			[103967] = { 12, false, 'Interrupt', }, --탈태 : 흡혈박쥐 떼
			
			[755] = { 0, false, 'Utility', }, --생명력 집중
			[1122] = { 360, false, 'Utility', }, --지옥불정령 소환
			[5484] = { 40, false, 'Utility', }, --공포의 울부짖음
			[5782] = { 0, true, 'Utility', }, --공포
			[6360] = { 25, false, 'Utility', }, --서큐버스 : 채찍질
			[18223] = { 0, true, 'Utility', }, --피로의 저주
			[18540] = { 360, false, 'Utility', }, --파멸의 수호병 소환
			[19505] = { 15, true, 'Utility', }, --지옥사냥개 : 마법 삼키기
			[20707] = { 600, true, 'Utility', }, --영석
			[29858] = { 120, false, 'Utility', }, --영혼 붕괴
			[29893] = { 120, false, 'Utility', }, --영혼의 샘 창조
			[30283] = { 30, false, 'Utility', }, --어둠의 격노
			[48020] = { 30, false, 'Utility', }, --악마의 마법진: 순간이동
			[80240] = { 25, true, 'Utility', }, --대혼란
			[86121] = { 0, true, 'Utility', }, --영혼 바꾸기
			[108415] = { 10, false, 'Utility', }, --영혼의 고리
			[108501] = { 120, false, 'Utility', }, --흑마법서: 봉사
			[108503] = { 120, false, 'Utility', }, --흑마법서: 희생
			[108505] = { 120, true, 'Utility', }, --아키몬드의 복수
			[111397] = { 10, true, 'Utility', }, --핏빛 두려움
			[113858] = { 120, false, 'Utility', }, --악마의 영혼: 불안정
			[113860] = { 120, false, 'Utility', }, --악마의 영혼: 불행
			[113861] = { 120, false, 'Utility', }, --악마의 영혼: 지식
			[120451] = { 60, false, 'Utility', }, --소로스의 불길
		},
	}
end