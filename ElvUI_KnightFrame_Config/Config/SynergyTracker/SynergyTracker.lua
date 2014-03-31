local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

-- Last Code Checking Date		: 2013. 9. 24
-- Last Code Checking Version	: 2.2_04
-- Last Testing ElvUI Version	: 6.53

if not KF or not KF_Config then return end

local function NameColor(Color)
	return KF.db.Enable ~= false and (Color and '|cff'..Color or KF:Color_Value()) or ''
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