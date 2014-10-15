local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:GetModule('KnightFrame_Config')

function KF:InstallWindow_StartInstallProcess()
	KF_Config:InstallWindow_Initialize()
	KF_Config:InstallWindow_SetPage(1)
end