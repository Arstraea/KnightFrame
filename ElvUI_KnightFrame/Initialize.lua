-- Last Code Checking Date		: 2014. 6. 13
-- Last Code Checking Version	: 3.1_01
-- Last Testing ElvUI Version	: 6.9997

local AddOnName, Engine = ...
local E, L, V, P, G  = unpack(ElvUI)

local Information = {
	Name = 'KnightFrame',
	Version = GetAddOnMetadata(AddOnName, 'Version'),
	Developer = {
		['Arstraea-헬스크림'] = true,
		['Arstrint-헬스크림'] = true,
		['Arstrita-헬스크림'] = true,
		['Arstreas-헬스크림'] = true,
		['Arstripor-헬스크림'] = true,
		['Arstrium-헬스크림'] = true,
		['Arstrinor-헬스크림'] = true,
		['Arstriel-헬스크림'] = true
	},
	
	myrealm = gsub(E.myrealm,'[%s%-]','')
}

local Core = E:NewModule(Information.Name, 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0')
Core.InitializeFunction = {}
Core.DBFunction = {}
Core.Callbacks = {}
Core.Events = {}

Core.Modules = {}

Core.UIParent = CreateFrame('Frame', Information.Name..'UIParent', E.UIParent)
Core.UIParent:SetAllPoints(E.UIParent)
Core.UIParent.MoverType = {}

local DB = {}

local Timer = {}
local Empty = { Cancel = function() end }
setmetatable(Timer, { __index = function() return Empty end })

Engine[1] = Core
Engine[2] = DB
Engine[3] = Information
Engine[4] = Timer

_G[AddOnName] = Engine

--local KF, DB, Info, Timer = unpack(select(2, ...))