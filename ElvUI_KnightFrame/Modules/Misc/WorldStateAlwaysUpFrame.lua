--Cache global variables
--Lua functions
local _G = _G
local unpack, select = unpack, select

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local CreateFrame = CreateFrame

--------------------------------------------------------------------------------
--<< KnightFrame : Initialize KnightFrame TopPanel							>>--
--------------------------------------------------------------------------------
CreateFrame('Frame', 'KF_WorldStateAlwaysUpFrame', KF.UIParent):Size(160, 70)
KF_WorldStateAlwaysUpFrame:SetFrameStrata('LOW')

WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:Point('CENTER', KF_WorldStateAlwaysUpFrame)

KF.InitializeFunction.WorldStateFrame = function()
	KF_WorldStateAlwaysUpFrame:SetPoint(unpack({string.split(Info.MoverDelimiter, KF.db.Modules.WorldStateAlwaysUpFrame)}))
	E:CreateMover(KF_WorldStateAlwaysUpFrame, 'KF_WorldStateAlwaysUpFrameMover', L['FrameTag']..L['KF_WorldStateAlwaysUpFrame'])
end