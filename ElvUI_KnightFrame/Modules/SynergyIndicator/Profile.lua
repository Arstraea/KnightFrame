local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

DB.Modules.SynergyIndicator = {
	Enable = true,
	
	TopPanel_Height = 14,
	
	BackUp = {
		Use_ConsolidatedBuffs = true,
		Use_TopPanel = false
	}
}