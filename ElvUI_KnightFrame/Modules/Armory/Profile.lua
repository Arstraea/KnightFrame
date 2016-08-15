--Cache global variables
--Lua functions
local _G = _G
local unpack, select, type, next, pairs, tremove = unpack, select, type, next, pairs, tremove

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local GetBuildInfo = GetBuildInfo

KF.db.Modules.Armory = KF.db.Modules.Armory or {}

local ClientVersion = select(4, GetBuildInfo())

KnightFrameDB.ArmoryDB = KnightFrameDB.ArmoryDB or {}
KnightFrameDB.ArmoryDB.EnchantString = KnightFrameDB.ArmoryDB.EnchantString or {}

if next(KnightFrameDB.ArmoryDB) then
	for SavedVersion in pairs(KnightFrameDB.ArmoryDB) do
		if type(SavedVersion) == 'number' and SavedVersion < ClientVersion then
			tremove(KnightFrameDB.ArmoryDB, SavedVersion)
		end
	end
end
KnightFrameDB.ArmoryDB[ClientVersion] = KnightFrameDB.ArmoryDB[ClientVersion] or { Specialization = {} }
KnightFrameDB.ArmoryDB[ClientVersion].Specialization = KnightFrameDB.ArmoryDB[ClientVersion].Specialization or {}