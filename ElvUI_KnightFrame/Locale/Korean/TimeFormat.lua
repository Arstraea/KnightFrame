local AceLocale = LibStub:GetLibrary('AceLocale-3.0')
local L = AceLocale:NewLocale('ElvUI', 'koKR')
if not L then return end

local E = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2013. 9. 25
-- Last Code Checking Version	: 2.2_04
-- Last Testing ElvUI Version	: 6.53

if not KF then return end

L['KF_LocalizedTimeFormat'] = {
	[0] = { '%d일', '%dd' }, -- Day
	[1] = { '%d시간', '%dh' }, -- Hour
	[2] = { '%d분', '%dm' }, -- Minute
	[3] = { '%d초', '%d' }, -- Second
	[4] = { '%.1f', '%.1f' }, -- Decimal Form
}