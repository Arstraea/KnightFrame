local AceLocale = LibStub:GetLibrary('AceLocale-3.0')
local L = AceLocale:NewLocale('ElvUI', 'koKR')
if not L then return end

local E = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2013. 9. 25
-- Last Code Checking Version	: 2.2_04
-- Last Testing ElvUI Version	: 6.53

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


function PrintTable(TableToCheck, row, InputTableName)
	row = row or 0
	if InputTableName then
		print(((' '):rep(row*2))..'|cff2eb7e4 [ Table|r : '..InputTableName..'|cff2eb7e4 ]')
		InputTableName = InputTableName..'-'
	else
		InputTableName = ''
	end
	for k, v in pairs(TableToCheck) do
		if type(v) == 'table' then
			PrintTable(v, row + 1, InputTableName..k)
		elseif type(v) == 'function' then
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : FUNCTION')
		elseif type(v) == 'userdata' then
		else
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : '..(type(v) == 'boolean' and (v==true and '|cff1784d1TRUE|r' or '|cffff0000FALSE|r') or v))
		end
	end
end