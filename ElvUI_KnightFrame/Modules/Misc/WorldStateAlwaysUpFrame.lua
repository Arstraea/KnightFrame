local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 6
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Initialize KnightFrame TopPanel							>>--
	--------------------------------------------------------------------------------
	CreateFrame('Frame', 'KF_WorldStateAlwaysUpFrame', KF.UIParent):Size(160, 70)
	KF_WorldStateAlwaysUpFrame:SetFrameStrata('LOW')
	
	WorldStateAlwaysUpFrame:ClearAllPoints()
	WorldStateAlwaysUpFrame:Point('CENTER', KF_WorldStateAlwaysUpFrame)
	
	KF.StartUp['WorldStateFrame'] = function()
		KF_WorldStateAlwaysUpFrame:SetPoint(unpack({string.split('\031', KF.db.Modules.WorldStateAlwaysUpFrame)}))
		E:CreateMover(KF_WorldStateAlwaysUpFrame, 'KF_WorldStateAlwaysUpFrameMover', L['FrameTag']..L['KF_WorldStateAlwaysUpFrame'])
	end
end