local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

DB.Modules.Armory = DB.Modules.Armory or {}
	
DB.Modules.Armory.Character = {
	Enable = true,
	NoticeMissing = true,
	
	GradationColor = { .41, .83, 1 },
	BackgroundImage = 'Interface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\Space'
}