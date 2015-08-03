local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.Armory = KF.db.Modules.Armory or {}

local ClientVersion = select(4, GetBuildInfo())

KnightFrame_ArmoryDB = type(KnightFrame_ArmoryDB) == 'table' and KnightFrame_ArmoryDB or { EnchantString = {} }
KnightFrame_ArmoryDB.EnchantString = KnightFrame_ArmoryDB.EnchantString or {}

if next(KnightFrame_ArmoryDB) then
	for SavedVersion in pairs(KnightFrame_ArmoryDB) do
		if type(SavedVersion) == 'number' and SavedVersion < ClientVersion then
			tremove(KnightFrame_ArmoryDB, SavedVersion)
		end
	end
end
KnightFrame_ArmoryDB[ClientVersion] = KnightFrame_ArmoryDB[ClientVersion] or { Specialization = {} }
KnightFrame_ArmoryDB[ClientVersion].Specialization = KnightFrame_ArmoryDB[ClientVersion].Specialization or {}