local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Load KnightFrame Config									>>--
--------------------------------------------------------------------------------
KF:RegisterEventList('ADDON_LOADED', function(_, AddOnName)
	if AddOnName == 'ElvUI_Config' then
		local Loaded, Reason = LoadAddOn('ElvUI_KnightFrame_Config')
		
		if not Loaded then
			if Reason == 'DISABLED' then
				EnableAddOn('ElvUI_KnightFrame_Config')
				LoadAddOn('ElvUI_KnightFrame_Config')
			else
				print(L['KF']..' : '..L['KnightFrame Config addon is not exists.'])
				return
			end
		else
			E.Options.args.KnightFrame = E:GetModule('KnightFrame_Config').Options
			KF:UnregisterEventList('ADDON_LOADED', 'KnightFrame_AutoLoadConfigAddon')
		end
	end
end, 'KnightFrame_AutoLoadConfigAddon')




--------------------------------------------------------------------------------
--<< KnightFrame : Install	 												>>--
--------------------------------------------------------------------------------
function KF:Install()
	local Loaded, Reason = LoadAddOn('ElvUI_KnightFrame_Config')
	
	if not Loaded then
		if Reason == 'DISABLED' then
			EnableAddOn('ElvUI_KnightFrame_Config')
			LoadAddOn('ElvUI_KnightFrame_Config')
		else
			print(L['KF']..' : '..L['KnightFrame Config addon is not exists.'])
			return
		end
	end
	
	KF:InstallWindow_StartInstallProcess()
end
KF:RegisterChatCommand('kf_install', 'Install')


-- Run KF Install instead of ElvUI Install 
if not E.private.install_complete then
	if E.db.KnightFrame and E.db.KnightFrame.Install_Complete then
		E.private.install_complete = E.version
	else
		E.Install_ = E.Install
		
		function E:Install()
			KF:Install()
		end
	end
end




--------------------------------------------------------------------------------
--<< KnightFrame : Profile													>>--
--------------------------------------------------------------------------------
function KF:LoadDB()
	P.KnightFrame = E:CopyTable({}, KF.db)
	
	if E.db.KnightFrame then
		KF:DBConversions(E.db.KnightFrame)
		
		for ModuleName, Function in pairs(KF.DBFunction) do
			if type(Function.Load) == 'function' then
				Function.Load(KF.db, E.db.KnightFrame)
			end
		end
		
		E:CopyTable(KF.db, E.db.KnightFrame)
	end
	
	KF.LoadDB = nil
end


function KF:DBReloadFunction(self, ProfileKey)
	if E.db.KnightFrame and E.db.KnightFrame.Install_Complete then
		KF.Events.PLAYER_LOGOUT.KnightFrame_SaveDB()
		
		KF:UpdateAll('SwitchProfile')
	end
	
	local Default = E:CopyTable({}, P.KnightFrame)
	
	if ElvDB.profiles[ProfileKey] and ElvDB.profiles[ProfileKey].KnightFrame then
		KF:DBConversions(ElvDB.profiles[ProfileKey].KnightFrame)
		
		for ModuleName, Function in pairs(KF.DBFunction) do
			if type(Function.Load) == 'function' then
				Function.Load(Default, ElvDB.profiles[ProfileKey].KnightFrame)
			end
		end
		
		E:CopyTable(Default, ElvDB.profiles[ProfileKey].KnightFrame)
	end
	
	KF.db = Default
	E:UpdateAll(true)
	
	local KF_Config = E:GetModule('KnightFrame_Config')
	
	if not (E.private.install_complete and ElvDB.profiles[ProfileKey] and ElvDB.profiles[ProfileKey].KnightFrame and ElvDB.profiles[ProfileKey].KnightFrame.Install_Complete) then
		if KF_Config then
			KF_Config.ReadyToRunKF = false
		end
		
		KF:Install()
	else
		if KF_Config then
			KF_Config.ReadyToRunKF = true
		end
		
		if KnightFrame_InstallWindow and KnightFrame_InstallWindow:IsShown() then
			KnightFrame_InstallWindow:Hide()
		end
		
		KF:Initialize()
	end
end


-- Save Profile
function KF:CompareTable(MainTable, TableToCompare)
	local RemainValueTable = {}
	local RemainValue
	
	for option, value in pairs(MainTable) do
		RemainValue = nil
		
		if type(value) == 'table' and TableToCompare[option] ~= nil and type(TableToCompare[option]) == 'table' then
			RemainValue = KF:CompareTable(MainTable[option], TableToCompare[option])
		elseif value ~= TableToCompare[option] or TableToCompare[option] == nil or type(value) ~= type(TableToCompare[option]) then
			RemainValue = value
		end
		
		if RemainValue ~= nil then
			RemainValueTable[option] = RemainValue
		end
	end
	
	for _ in pairs(RemainValueTable) do
		return RemainValueTable
	end
end

KF:RegisterEventList('PLAYER_LOGOUT', function()
	if E.db.KnightFrame then
		for ModuleName, Function in pairs(KF.DBFunction) do
			if type(Function.Save) == 'function' then
				Function.Save()
			end
		end
		
		E.db.KnightFrame = KF:CompareTable(KF.db, P.KnightFrame)
	end
end, 'KnightFrame_SaveDB')




--------------------------------------------------------------------------------
--<< KnightFrame : Initializae	 											>>--
--------------------------------------------------------------------------------
function KF:Initialize()
	-- Original Code (Version)		: ElvUI(6.94)
	-- Original Code Location		: ElvUI\Core\Core.lua
	if KF.LoadDB then
		KF:LoadDB()
		
		E.data.RegisterCallback(E, 'OnProfileChanged', KF.DBReloadFunction)
		E.data.RegisterCallback(E, 'OnProfileCopied', KF.DBReloadFunction)
	end
	
	if not (E.db.KnightFrame and E.db.KnightFrame.Install_Complete) then
		KF:Install()
		return
	elseif E.db.KnightFrame.Install_Complete == 'NotUpdated' then
		print(L['KF']..' : '..L['You canceled KnightFrame install ago. If you wants to run KnightFrame install process again, please type /kf_install command.'])
	elseif E.db.KnightFrame.Install_Complete ~= Info.Version then
		E.db.KnightFrame.PatchCheck = true
	end
	
	if KF.InitializeFunction then
		for _, InitializeFunction in pairs(KF.InitializeFunction) do
			InitializeFunction()
		end
		
		KF.InitializeFunction = nil
	end
	
	if KF.db.Enable then
		KF:UpdateAll()
	end
end
E:RegisterModule(KF:GetName())

-- Raid Marker
_G['BINDING_NAME_CLICK KF_WorldMarker1:LeftButton'] = '|cffffffff- '..WORLD_MARKER1
_G['BINDING_NAME_CLICK KF_WorldMarker2:LeftButton'] = '|cffffffff- '..WORLD_MARKER2
_G['BINDING_NAME_CLICK KF_WorldMarker3:LeftButton'] = '|cffffffff- '..WORLD_MARKER3
_G['BINDING_NAME_CLICK KF_WorldMarker4:LeftButton'] = '|cffffffff- '..WORLD_MARKER4
_G['BINDING_NAME_CLICK KF_WorldMarker5:LeftButton'] = '|cffffffff- '..WORLD_MARKER5
_G['BINDING_NAME_CLICK KF_WorldMarker6:LeftButton'] = '|cffffffff- '..REMOVE_WORLD_MARKERS

for i = 1, 6 do
	CreateFrame('Button', 'KF_WorldMarker'..i, UIParent, 'SecureActionButtonTemplate')
	_G['KF_WorldMarker'..i]:SetAttribute('type1', 'worldmarker')
	
	if i == 6 then
		_G['KF_WorldMarker'..i]:SetAttribute('action', 'clear')
	else
		_G['KF_WorldMarker'..i]:SetAttribute('marker', i)
	end
end