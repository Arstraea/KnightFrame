local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 24
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return end

V.KnightFrame = {
	['SwitchEquipment'] = {
		['Enable'] = true,
		
		['Primary'] = '',
		['Secondary'] = '',
		['PvP'] = '',
	},
}