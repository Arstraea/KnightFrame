local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2013. 10. 10
-- Last Code Checking Version	: 2.2_05
-- Last Testing ElvUI Version	: 6.59

--General
local function Update_Color()
	L['KF'] = KF:Color_Value('Knight Frame')
	L['FrameTag'] = KF:Color_Value('[')..' |r|cffffffffKnight Frame|r '..KF:Color_Value(']')..'|n|n'
	BINDING_HEADER_KnightFrame = KF:Color_Value('Knight Frame')
end
E['valueColorUpdateFuncs'][Update_Color] = true
Update_Color()

--Colorize Class Name and localize specialization name
local ClassName = {}
FillLocalizedClassList(ClassName)

L['Warrior'] = KF:Color_Class('WARRIOR', ClassName['WARRIOR'])
_, L['Spec_Warrior_Arms'] = GetSpecializationInfoByID(71)
_, L['Spec_Warrior_Fury'] = GetSpecializationInfoByID(72)
_, L['Spec_Warrior_Protection'] = GetSpecializationInfoByID(73)

L['Hunter'] = KF:Color_Class('HUNTER', ClassName['HUNTER'])
_, L['Spec_Hunter_Beast'] = GetSpecializationInfoByID(253)
_, L['Spec_Hunter_Marksmanship'] = GetSpecializationInfoByID(254)
_, L['Spec_Hunter_Survival'] = GetSpecializationInfoByID(255)

L['Shaman'] = KF:Color_Class('SHAMAN', ClassName['SHAMAN'])
_, L['Spec_Shaman_Elemental'] = GetSpecializationInfoByID(262)
_, L['Spec_Shaman_Enhancement'] = GetSpecializationInfoByID(263)
_, L['Spec_Shaman_Restoration'] = GetSpecializationInfoByID(264)

L['Monk'] = KF:Color_Class('MONK', ClassName['MONK'])
_, L['Spec_Monk_Brewmaster'] = GetSpecializationInfoByID(268)
_, L['Spec_Monk_Mistweaver'] = GetSpecializationInfoByID(270)
_, L['Spec_Monk_Windwalker'] = GetSpecializationInfoByID(269)

L['Rogue'] = KF:Color_Class('ROGUE', ClassName['ROGUE'])
_, L['Spec_Rogue_Assassination'] = GetSpecializationInfoByID(259)
_, L['Spec_Rogue_Combat'] = GetSpecializationInfoByID(260)
_, L['Spec_Rogue_Subtlety'] = GetSpecializationInfoByID(261)

L['DeathKnight'] = KF:Color_Class('DEATHKNIGHT', ClassName['DEATHKNIGHT'])
_, L['Spec_DeathKnight_Blood'] = GetSpecializationInfoByID(250)
_, L['Spec_DeathKnight_Frost'] = GetSpecializationInfoByID(251)
_, L['Spec_DeathKnight_Unholy'] = GetSpecializationInfoByID(252)

L['Mage'] = KF:Color_Class('MAGE', ClassName['MAGE'])
_, L['Spec_Mage_Arcane'] = GetSpecializationInfoByID(62)
_, L['Spec_Mage_Fire'] = GetSpecializationInfoByID(63)
_, L['Spec_Mage_Frost'] = GetSpecializationInfoByID(64)

L['Druid'] = KF:Color_Class('DRUID', ClassName['DRUID'])
_, L['Spec_Druid_Balance'] = GetSpecializationInfoByID(102)
_, L['Spec_Druid_Feral'] = GetSpecializationInfoByID(103)
_, L['Spec_Druid_Guardian'] = GetSpecializationInfoByID(104)
_, L['Spec_Druid_Restoration'] = GetSpecializationInfoByID(105)

L['Paladin'] = KF:Color_Class('PALADIN', ClassName['PALADIN'])
_, L['Spec_Paladin_Holy'] = GetSpecializationInfoByID(65)
_, L['Spec_Paladin_Protection'] = GetSpecializationInfoByID(66)
_, L['Spec_Paladin_Retribution'] = GetSpecializationInfoByID(70)

L['Priest'] = KF:Color_Class('PRIEST', ClassName['PRIEST'])
_, L['Spec_Priest_Discipline'] = GetSpecializationInfoByID(256)
_, L['Spec_Priest_Holy'] = GetSpecializationInfoByID(257)
_, L['Spec_Priest_Shadow'] = GetSpecializationInfoByID(258)

L['Warlock'] = KF:Color_Class('WARLOCK', ClassName['WARLOCK'])
_, L['Spec_Warlock_Affliction'] = GetSpecializationInfoByID(265)
_, L['Spec_Warlock_Demonology'] = GetSpecializationInfoByID(266)
_, L['Spec_Warlock_Destruction'] = GetSpecializationInfoByID(267)