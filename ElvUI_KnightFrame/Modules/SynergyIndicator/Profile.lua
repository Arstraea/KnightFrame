local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.SynergyIndicator = {
	Enable = true,
	
	TopPanel_Height = 14,
	
	BackUp = {
		Use_ConsolidatedBuffs = true,
		Use_TopPanel = false
	}
}