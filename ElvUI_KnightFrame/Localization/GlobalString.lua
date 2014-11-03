local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--General
local function Update_Color()
	L['KF'] = KF:Color_Value('Knight Frame')
	L['FrameTag'] = KF:Color_Value('[')..' |r|cffffffffKnight Frame|r '..KF:Color_Value(']')..'|n|n'
	BINDING_HEADER_KnightFrame = KF:Color_Value('Knight Frame')
end
E.valueColorUpdateFuncs[Update_Color] = true
Update_Color()


for ClassName, SpecializationIDTable in pairs({
	Warrior = {
		Arms = 71,
		Fury = 72,
		Protection = 73
	},
	Hunter = {
		Beast = 253,
		Marksmanship = 254,
		Survival = 255
	},
	Shaman = {
		Elemental = 262,
		Enhancement = 263,
		Restoration = 264
	},
	Monk = {
		Brewmaster = 268,
		Mistweaver = 270,
		Windwalker = 269
	},
	Rogue = {
		Assassination = 259,
		Combat = 260,
		Subtlety = 261
	},
	DeathKnight = {
		Blood = 250,
		Frost = 251,
		Unholy = 252
	},
	Mage = {
		Arcane = 62,
		Fire = 63,
		Frost = 64
	},
	Druid = {
		Balance = 102,
		Feral = 103,
		Guardian = 104,
		Restoration = 105
	},
	Paladin = {
		Holy = 65,
		Protection = 66,
		Retribution = 70
	},
	Priest = {
		Discipline = 256,
		Holy = 257,
		Shadow = 258
	},
	Warlock = {
		Affliction = 265,
		Demonology = 266,
		Destruction = 267
	}
}) do
	L[ClassName] = KF:Color_Class(string.upper(ClassName), LOCALIZED_CLASS_NAMES_MALE[string.upper(ClassName)])
	
	for Name, ID in pairs(SpecializationIDTable) do
		_, L['Spec_'..ClassName..'_'..Name] = GetSpecializationInfoByID(ID)
	end
end