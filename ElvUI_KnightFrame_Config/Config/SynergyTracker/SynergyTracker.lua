local E, L, V, P, G, _ = unpack(ElvUI)
local KF, DB, Info, Update = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

--[[
local function NameColor(Color)
	return DB.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
end

KF_Config.Options.args.Extra_Functions.args.Misc.args.AuraTracker = {
	type = 'toggle',
	name = function() return ' '..NameColor()..L['Aura Tracker'] end,
	order = 7,
	desc = '',
	descStyle = 'inline',
	get = function() return KF.db.Extra_Functions.AuraTracker end,
	set = function(_, value)
		KF.db.Extra_Functions.AuraTracker = value
		
		KF.InitializeFunction['Extra_Functions']['AuraTracker'](not value)
	end,
}

if IsAddOnLoaded('ElvUI_Config') then
	E.Options.args.auras.args.consolidatedBuffs.args.WarningDisabledFunctionByKnightFrame = {
		type = 'group',
		name = KF:Color_Value('>>')..' |cffffffffNotice '..KF:Color_Value('<<'),
		order = 999,
		guiInline = true,
		args = {
		
		},
		hidden = function() return KF.db.Extra_Functions.AuraTracker == false end,
	}
end
]]