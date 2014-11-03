local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(ElvUI_KnightFrame)
local KF_Config = E:NewModule('KnightFrame_Config')


KF_Config.OptionsCategoryCount = 0
KF_Config.Install_Layout_Data = { Moonlight = {}, Kimsungjae = {} }
KF_Config.Install_Profile_Data = { Moonlight = {}, Kimsungjae = {} }
KF_Config.Install_SubPack_Data = {}


function KF_Config:Credit()
	return KF:Color_Value('Created By')..' |cffffffffArstraea|r |cffceff00(kr)|r |cffffffff/|r '..KF:Color_Value('E-mail')..' |cffffffff: qjr2513|r|cffceff00@naver.com|r'
end