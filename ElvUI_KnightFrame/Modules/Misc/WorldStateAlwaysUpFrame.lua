local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Initialize KnightFrame TopPanel							>>--
--------------------------------------------------------------------------------
CreateFrame('Frame', 'KF_WorldStateAlwaysUpFrame', KF.UIParent):Size(160, 70)
KF_WorldStateAlwaysUpFrame:SetFrameStrata('LOW')

WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:Point('CENTER', KF_WorldStateAlwaysUpFrame)

KF.InitializeFunction.WorldStateFrame = function()
	KF_WorldStateAlwaysUpFrame:SetPoint(unpack({string.split('\031', DB.Modules.WorldStateAlwaysUpFrame)}))
	E:CreateMover(KF_WorldStateAlwaysUpFrame, 'KF_WorldStateAlwaysUpFrameMover', L['FrameTag']..L['KF_WorldStateAlwaysUpFrame'])
end