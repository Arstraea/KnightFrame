local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:NewModule('KnightFrame', 'AceEvent-3.0', 'AceConsole-3.0', 'AceHook-3.0')

-- Last Code Checking Date		: 2014. 2. 6
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

--------------------------------------------------------------------------------
--<< KnightFrame : Define Elements 											>>--
--------------------------------------------------------------------------------
KF.AddOnName = 'KnightFrame'
KF.Version = GetAddOnMetadata('ElvUI_KnightFrame', 'Version')
KF.LayoutDefault = {}
KF.DBFunction = {}


--------------------------------------------------------------------------------
--<< KnightFrame : Structures	 											>>--
--------------------------------------------------------------------------------
if E.db.KnightFrame and E.db.KnightFrame.Install_Complete then
	KF.Table = {}
	KF.Update = {}
	KF.StartUp = {}
	KF.Modules = {}
	
	
	-- KnightFrame UIParent
	KF.UIParent = CreateFrame('Frame', 'KnightFrameUIParent', E.UIParent)
	KF.UIParent:SetPoint('TOPLEFT', E.UIParent)
	KF.UIParent:SetPoint('BOTTOMRIGHT', E.UIParent)
	
	-- KnightFrame Updater
	KF.UpdateFrame = CreateFrame('Frame')
	KF.UpdateFrame:SetScript('OnUpdate', function(_, elapsed)
		KF.TimeNow = GetTime()
		
		for _, Contents in pairs(KF.Update) do
			if not Contents.LastUpdate then
				Contents.LastUpdate = 0
			end
			
			if Contents.Condition and ((type(Contents.Condition) == 'function' and Contents.Condition() == true) or Contents.Condition == true) and Contents.LastUpdate + (Contents.Delay or 5) <= KF.TimeNow then
				Contents.LastUpdate = KF.TimeNow
				Contents.Action(elapsed)
			end
		end
	end)
	
	
	-- Check Arstraea
	KF.Arstraea = {
		['Arstraea-헬스크림'] = true,
		['Arstrint-헬스크림'] = true,
		['Arstrita-헬스크림'] = true,
		['Arstreas-헬스크림'] = true,
		['Arstripor-헬스크림'] = true,
		['Arstrium-헬스크림'] = true,
		['Arstrinor-헬스크림'] = true,
		['Arstriel-헬스크림'] = true,
	}
end