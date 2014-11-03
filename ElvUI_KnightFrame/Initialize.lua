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
	
	MyRealm = gsub(E.myrealm,'[%s%-]','')
}

local Core = E:NewModule(Information.Name, 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0')
Core.db = {}
Core.DBFunction = {}
Core.InitializeFunction = {}
Core.Events = {}
Core.Callbacks = {}

Core.Modules = {}

Core.UIParent = CreateFrame('Frame', Information.Name..'UIParent', E.UIParent)
Core.UIParent:SetAllPoints(E.UIParent)
Core.UIParent.MoverType = {}

local Timer = {}
local Empty = { Cancel = function() end }
setmetatable(Timer, { __index = function() return Empty end })

Engine[1] = Core
Engine[2] = Information
Engine[3] = Timer

_G[AddOnName] = Engine

--local KF, Info, Timer = unpack(select(2, ...))