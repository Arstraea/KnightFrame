local L = LibStub:GetLibrary('AceLocale-3.0'):NewLocale('ElvUI', 'enUS', true)
if not L then return end

--Cache global variables
--Lua functions
local unpack, select = unpack, select

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Locale													>>--
--------------------------------------------------------------------------------
do	-- General
	BINDING_NAME_InspectMouseover = '|cffffffff - Inspect mouseover'
	BINDING_NAME_SpecSwitch = '|cffffffff- Toggle Spec'
	
	L['Tank'] = '탱커'
	L['Caster'] = '캐스터'
	L['Melee'] = '밀리'
	L['No Spec'] = '전문화X'
	
	L['LeftClick'] = 'Left Click'
	L['RightClick'] = 'Right Click'
	
	L['raid'] = '레이드 파티'
	L['party'] = '파티'
	
	CRIT_ABBR = '크리'
	MANA_REGEN = '마젠'
	
	L['Raid Utility Filter'] = '공대생존기 필터'
	
	L['Creater of this addon, %s is in %s group. Please whisper me about opinion of %s addon.'] = true
	L['You canceled KnightFrame install ago. If you wants to run KnightFrame install process again, please type /kf_install command.'] = 'You canceled |cff1784d1KnightFrame|r install ago. If you wants to run install process again, please type |cff1784d1/kf_install|r command.'
end


do	-- ElvUI_KnightFrame_Config
	L['KnightFrame Config addon is not exists.'] = '|cff1784d1KnightFrame Config|r addon is not exists.'
end