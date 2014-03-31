local AceLocale = LibStub:GetLibrary('AceLocale-3.0')
local L = AceLocale:NewLocale('ElvUI', 'deDE')
if not L then return end

local E = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.Memory then
	-- This table will allow TimeFormat in Extra_Functions.
	-- In Korea, it's hard to realize elvui's default time format. (So I guess Elv separated timeformat table for modifying easily.)
	-- If you wants to replace time format by launguage, write this table.
	
		-- Change Forward String
		-- For Example, Korean is like this
		-- [0] = { '%d일', '%dd' }, -- Day
		-- [1] = { '%d시간', '%dh' }, -- Hour
		-- [2] = { '%d분', '%dm' }, -- Minute
		-- [3] = { '%d초', '%d' }, -- Second
		-- [4] = { '%.1f', '%.1f' }, -- Decimal Form
	
	--[[
	KF.Memory['Table']['LocalizedTimeFormat'] = {	
		[0] = { '%d', '%dd' }, -- Day
		[1] = { '%d', '%dh' }, -- Hour
		[2] = { '%d', '%dm' }, -- Minute
		[3] = { '%d', '%d' }, -- Second
		[4] = { '%.1f', '%.1f' }, -- Decimal Form
	}
	]]
end