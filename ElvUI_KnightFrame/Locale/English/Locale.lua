local AceLocale = LibStub:GetLibrary('AceLocale-3.0')
local L = AceLocale:NewLocale('ElvUI', 'enUS', true)
if not L then return end

local E = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')


do	--General
	BINDING_NAME_InspectMouseover = '|cffffffff - Mouseover Inspect'
	
	L['raid'] = true
	L['party'] = true
	L['battleground'] = true
end


do	--Frame Name
	L['MiddleChatPanel'] = 'Middle Chat Panel'
	L['MeterAddonPanel'] = 'Meter Addon Panel'
	L['ActionBarPanel'] = 'ActionBar Panel'
	L['KnightInspectFrame'] = 'Knight Inspect'
end


do	--Inspect
	L[" Server's "] = true
	
	L['ModelFrame'] = 'Char'
	L['SpecializationFrame'] = 'Spec'
	L['PvPInfoFrame'] = 'PvP'
	
	L['This is not a inspect bug.|nI think this user is not wearing any gears.'] = 'This is not a inspect bug.|nI think this user is |cffff5675not wearing any gears|r.'
end

do	--Print Message
	L['KnightFrame Config addon is not exists.'] = '|cff1784d1KnightFrame Config addon|r is not exists.'
	
	L['Lock ExpRep Tooltip.'] = '|cffceff00Lock|r |cff2eb7e4Exp&Rep|r Tooltip.'
	L['Unlock ExpRep Tooltip.'] = '|cffff5353Unlock|r |cff2eb7e4Exp&Rep|r Tooltip.'
	
	L["You can't inspect while dead."] = true
	L[" Inspect. Sometimes this work will take few second by waiting server's response."] = true
	L['Mouseover Inspect needs to freeze mouse moving until inspect is over.'] = '|cff2eb7e4Mouseover Inspect|r needs to freeze mouse moving |cffff5675until inspect is over|r.'
	L['Mouseover Inspect is canceled because cursor left user to inspect.'] = '|cffff5675Mouseover Inspect is canceled|r because cursor left user to inspect.'
	L['Inspect is canceled because target was lost or changed.'] = '|cffff5675Inspect is canceled|r because target was lost or changed.'
	
	L['Hide Watchframe because of entering boss battle.'] = true
	
	L['Lock Display Area.'] = '|cffceff00Lock|r Display Area'
	L['Unlock Display Area.'] = '|cffff5353Unlock|r Display Area'
	
	L['Reset skills that have a cool time more than 5 minutes'] = true
end


do	--Datatexts
	L['Friends'] = true
	CRIT_ABBR = 'Crit'
	MANA_REGEN = 'ManaRegen'
	L['Stats'] = 'AllStats'
end


do	--Specialization and Role
	L['Tank'] = true
	L['Caster'] = true
	L['Melee'] = true
	L['NoSpec'] = 'No Spec'
end


do	--Extra Function

	--<< Tracker >>--
	L['Applied'] = true
	L['Non-applied'] = true
	L['EnableClass'] = 'Enable Class'
	
	L['Elixirs'] = true
	L['Foods'] = true
	L['Bloodlust Debuff'] = true
	L['Resurrection Debuff'] = true
	L['Magic-Damage'] = true
	L['Armor-Reducing'] = true
	L['Physical Vulnerability'] = true
	L['AP-Reducing'] = true
	L['Increasing Casting'] = true
	L['Heal-Reducing'] = true
	L['Dangerous Utility'] = true
	L['Turtle Utility'] = true
	
	local Exotic = '|cff1784d1(Exotic)|r'
	L['Wolves'] = true
	L['Cats'] = true
	L['Hyenas'] = true
	L['Serpents'] = true
	L['Quilen'] = 'Quilen'..Exotic
	L['Silithids'] = 'Silithids'..Exotic
	L['Water Striders'] = 'Water Striders'..Exotic
	L['Spirit Beasts'] = 'Spirit Beasts'..Exotic
	L['Shale Spiders'] = 'Shale Spiders'..Exotic
	L['Devilsaurs'] = 'Devilsaurs'..Exotic
	L['Dragonhawks'] = true
	L['Wind Serpents'] = true
	L['Tallstriders'] = true
	L['Raptors'] = true
	L['Boars'] = true
	L['Ravagers'] = true
	L['Worms'] = 'Worms'..Exotic
	L['Rhinos'] = 'Rhinos'..Exotic
	L['Bears'] = true
	L['Foxes'] = true
	L['Sporebats'] = true
	L['Goats'] = true
	L['Core Hounds'] = 'Core Hounds'..Exotic
	
	
	--<< ItemLevel >>--
	L['Average'] = true
	
	
	--<< RaidCooldown >>--
	L['Enable to display'] = true
	L['Inspect All Members.'] = true
	L['RightClick'] = true
	L['Remove this cooltime bar.'] = true
	L['Clear this spell config to forbid displaying.'] = true
	L['Castable User'] = true
	L['Enable To Cast'] = true
end