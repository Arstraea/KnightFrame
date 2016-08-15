--Cache global variables
--Lua functions
local _G = _G
local unpack, select, gsub = unpack, select, gsub

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API . Variables
local GetSpellInfo = GetSpellInfo
local ITEM_LEVEL = ITEM_LEVEL
local ITEM_LEVEL_ALT = ITEM_LEVEL_ALT
local ENCHANTED_TOOLTIP_LINE = ENCHANTED_TOOLTIP_LINE
local ITEM_SET_BONUS = ITEM_SET_BONUS
local ITEM_UPGRADE_TOOLTIP_FORMAT = ITEM_UPGRADE_TOOLTIP_FORMAT
local EMPTY_SOCKET_BLUE = EMPTY_SOCKET_BLUE
local EMPTY_SOCKET_COGWHEEL = EMPTY_SOCKET_COGWHEEL
local EMPTY_SOCKET_HYDRAULIC = EMPTY_SOCKET_HYDRAULIC
local EMPTY_SOCKET_META = EMPTY_SOCKET_META
local EMPTY_SOCKET_NO_COLOR = EMPTY_SOCKET_NO_COLOR
local EMPTY_SOCKET_PRISMATIC = EMPTY_SOCKET_PRISMATIC
local EMPTY_SOCKET_RED = EMPTY_SOCKET_RED
local EMPTY_SOCKET_YELLOW = EMPTY_SOCKET_YELLOW
local ITEM_BIND_ON_EQUIP = ITEM_BIND_ON_EQUIP
local ITEM_BIND_ON_PICKUP = ITEM_BIND_ON_PICKUP
local ITEM_BIND_TO_ACCOUNT = ITEM_BIND_TO_ACCOUNT
local ITEM_BIND_TO_BNETACCOUNT = ITEM_BIND_TO_BNETACCOUNT

Info.Armory_Constants = {
	ItemLevelKey = ITEM_LEVEL:gsub('%%d', '(.+)'),
	ItemLevelKey_Alt = ITEM_LEVEL_ALT:gsub('%%d', '.+'):gsub('%(.+%)', '%%((.+)%%)'),
	EnchantKey = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)'),
	ItemSetBonusKey = ITEM_SET_BONUS:gsub('%%s', '(.+)'),
	ItemUpgradeKey = ITEM_UPGRADE_TOOLTIP_FORMAT:gsub('%%d', '(.+)'),
	
	GearList = {
		'HeadSlot', 'HandsSlot', 'NeckSlot', 'WaistSlot', 'ShoulderSlot', 'LegsSlot', 'BackSlot', 'FeetSlot', 'ChestSlot', 'Finger0Slot',
		'ShirtSlot', 'Finger1Slot', 'TabardSlot', 'Trinket0Slot', 'WristSlot', 'Trinket1Slot', 'SecondaryHandSlot', 'MainHandSlot'
	},
	
	EnchantableSlots = {
		NeckSlot = true, BackSlot = true, Finger0Slot = true, Finger1Slot = true, MainHandSlot = true, SecondaryHandSlot = true
	},
	
	UpgradeColor = {
		[16] = '|cffff9614',
		[12] = '|cfff88ef4',
		[10] = '|cffff9614',
		[8] = '|cff2eb7e4',
		[5] = '|cfff88ef4',
		[4] = '|cffceff00'
	},
	
	GemColor = {
		RED = { 1, .2, .2, },
		YELLOW = { .97, .82, .29, },
		BLUE = { .47, .67, 1, }
	},
	
	EmptySocketString = {
		[EMPTY_SOCKET_BLUE] = true,
		[EMPTY_SOCKET_COGWHEEL] = true,
		[EMPTY_SOCKET_HYDRAULIC] = true,
		[EMPTY_SOCKET_META] = true,
		[EMPTY_SOCKET_NO_COLOR] = true,
		[EMPTY_SOCKET_PRISMATIC] = true,
		[EMPTY_SOCKET_RED] = true,
		[EMPTY_SOCKET_YELLOW] = true
	},
	
	ItemBindString = { -- Usually transmogrify string is located upper than bind string so we need to check this string for adding a transmogrify string in tooltip.
		[ITEM_BIND_ON_EQUIP] = true,
		[ITEM_BIND_ON_PICKUP] = true,
		[ITEM_BIND_TO_ACCOUNT] = true,
		[ITEM_BIND_TO_BNETACCOUNT] = true
	},
	
	CanTransmogrifySlot = {
		HeadSlot = true, ShoulderSlot = true, BackSlot = true, ChestSlot = true, WristSlot = true,
		HandsSlot = true, WaistSlot = true, LegsSlot = true, FeetSlot = true, MainHandSlot = true, SecondaryHandSlot = true
	},
	
	CanIllusionSlot = {
		MainHandSlot = true, SecondaryHandSlot = true
	},
	
	ProfessionList = {},
	
	BlizzardBackdropList = {
		['Alliance-bliz'] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Alliance]],
		['Horde-bliz'] = [[Interface\LFGFrame\UI-PVP-BACKGROUND-Horde]],
		['Arena-bliz'] = [[Interface\PVPFrame\PvpBg-NagrandArena-ToastBG]]
	}
}

local ProfessionName, ProfessionTexture
for ProfessionID, ProfessionKey in pairs({
	[105206] = 'Alchemy',
	[110396] = 'BlackSmithing',
	[110400] = 'Enchanting',
	[110403] = 'Engineering',
	[110417] = 'Inscription',
	[110420] = 'JewelCrafting',
	[110423] = 'LeatherWorking',
	[110426] = 'Tailoring',
	
	[110413] = 'Herbalism',
	[102161] = 'Mining',
	[102216] = 'Skinning'
}) do
	ProfessionName, _, ProfessionTexture = GetSpellInfo(ProfessionID)
	
	Info.Armory_Constants.ProfessionList[ProfessionName] = {
		Key = ProfessionKey,
		Texture = ProfessionTexture
	}
end