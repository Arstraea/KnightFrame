local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.EmbedMeter = {
	Enable = true,
	DisplayOnlyDuringCombat = false
}


if IsAddOnLoaded('Skada') or IsAddOnLoaded('SkadaU') then
	KF.db.Modules.EmbedMeter.Skada = {}
end