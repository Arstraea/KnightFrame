--Cache global variables
--Lua functions
local _G = _G
local unpack, select = unpack, select

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

V.general.chatBubbles = 'disabled'
V.bags.bagBar = true

P.hideTutorial = 1