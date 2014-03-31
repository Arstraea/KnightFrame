local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KF_Config = E:GetModule('KnightFrame_Config')

function KF:InstallWindow_StartInstallProcess()
	KF_Config:InstallWindow_Initialize()
	KF_Config:InstallWindow_SetPage(1)
end