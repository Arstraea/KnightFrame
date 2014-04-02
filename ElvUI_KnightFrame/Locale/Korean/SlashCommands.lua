local AceLocale = LibStub:GetLibrary('AceLocale-3.0')
local L = AceLocale:NewLocale('ElvUI', 'koKR')
if not L then return end

local E = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 4. 2
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return end

local function Calculater(msg)
	local origHandler = geterrorhandler()
	seterrorhandler(function (msg)
		print('식이 잘못되었습니다.')
	end)
	msg = 'local answer='..msg..';if answer then SendChatMessage(\'식: '..msg..'\',\'SAY\');SendChatMessage(\'답: \'..answer,\'SAY\') end'
	RunScript(msg)
	seterrorhandler(origHandler)
end

KF:RegisterChatCommand('test', 'Test')
KF:RegisterChatCommand('ㅅㄷㄴㅅ', 'Test')
KF:RegisterChatCommand('KI', 'TryKnightInspect')


E:RegisterChatCommand('ㄷㅊ', 'ToggleConfig')
KF:RegisterChatCommand('기', ReloadUI)
KF:RegisterChatCommand('키', E.ActionBars.ActivateBindMode)
KF:RegisterChatCommand('vkxkf', LeaveParty)
KF:RegisterChatCommand('파탈', LeaveParty)
KF:RegisterChatCommand('rPtks', Calculater)
KF:RegisterChatCommand('계산', Calculater)
KF:RegisterChatCommand('ㅏㄹ_ㅑㅜㄴㅅ미ㅣ', 'Install')
KF:RegisterChatCommand('나이트프레임설치', 'Install')