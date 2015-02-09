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
function KF:SkipDefaultInstallProcess()
	if not E.private.install_complete then
		if E.db.KnightFrame and E.db.KnightFrame.Install_Complete then
			if ElvUIInstallFrame and ElvUIInstallFrame:IsShown() then
				ElvUIInstallFrame:Hide()
			end
			E.private.install_complete = E.version
		else
			E.Install_ = E.Install
			
			function E:Install()
				KF:Install()
			end
		end
	end
end
KF:SkipDefaultInstallProcess()




--------------------------------------------------------------------------------
--<< KnightFrame : Profile													>>--
--------------------------------------------------------------------------------
KF.InitializeFunction.LoadDB = function()
	P.KnightFrame = E:CopyTable({}, KF.db)
	
	if E.db.KnightFrame then
		KF:DBConversions(E.db)
		
		for ModuleName, Function in pairs(KF.DBFunction) do
			if type(Function.Load) == 'function' then
				Function.Load(KF.db, E.db.KnightFrame)
			end
		end
		
		E:CopyTable(KF.db, E.db.KnightFrame)
	end
	
	Info.CurrentSetDBKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	E.UpdateAll_ = E.UpdateAll
	function E:UpdateAll(IgnoreInstall)
		local NeedUpdate
		local NewProfileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
		
		if Info.CurrentSetDBKey ~= NewProfileKey then
			KF.Events.PLAYER_LOGOUT.KnightFrame_SaveDB(nil, Info.CurrentSetDBKey)
			
			KF:UpdateAll('SwitchProfile')
			
			NeedUpdate = true
		end
		
		E:UpdateAll_(IgnoreInstall)
		
		if NeedUpdate then
			local Default = E:CopyTable({}, P.KnightFrame)
			
			if ElvDB.profiles[NewProfileKey] and ElvDB.profiles[NewProfileKey].KnightFrame then
				KF:DBConversions(ElvDB.profiles[NewProfileKey])
				
				for ModuleName, Function in pairs(KF.DBFunction) do
					if type(Function.Load) == 'function' then
						Function.Load(Default, ElvDB.profiles[NewProfileKey].KnightFrame)
					end
				end
				
				E:CopyTable(Default, ElvDB.profiles[NewProfileKey].KnightFrame)
			end
			
			KF.db = Default
			Info.CurrentSetDBKey = NewProfileKey
			
			local KF_Config = E:GetModule('KnightFrame_Config', true)
			
			if not (E.private.install_complete and ElvDB.profiles[NewProfileKey] and ElvDB.profiles[NewProfileKey].KnightFrame and ElvDB.profiles[NewProfileKey].KnightFrame.Install_Complete) then
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
	end
	
	-- Original Code (Version)		: ElvUI(6.94)
	-- Original Code Location		: ElvUI\Core\Core.lua
	E.data.RegisterCallback(E, 'OnProfileChanged', 'UpdateAll')
	E.data.RegisterCallback(E, 'OnProfileCopied', 'UpdateAll')
end


-- Save Profile
KF:RegisterEventList('PLAYER_LOGOUT', function(_, TargetTable)
	if TargetTable and ElvDB.profiles[TargetTable].KnightFrame then
		for ModuleName, Function in pairs(KF.DBFunction) do
			if type(Function.Save) == 'function' then
				Function.Save()
			end
		end
		
		KF:CompareTable(KF.db, P.KnightFrame, ElvDB.profiles[TargetTable].KnightFrame)
	elseif E.db.KnightFrame then
		for ModuleName, Function in pairs(KF.DBFunction) do
			if type(Function.Save) == 'function' then
				Function.Save()
			end
		end
		
		KF:CompareTable(KF.db, P.KnightFrame, E.db.KnightFrame)
	end
end, 'KnightFrame_SaveDB')

function KF:Test()
	KF:CompareTable(KF.db, P.KnightFrame, E.db.KnightFrame)
	PrintTable(E.db.KnightFrame.Modules.EmbedMeter)
end




--------------------------------------------------------------------------------
--<< KnightFrame : Initializae	 											>>--
--------------------------------------------------------------------------------
function KF:Initialize()
	if KF.InitializeFunction then
		for _, InitializeFunction in pairs(KF.InitializeFunction) do
			InitializeFunction()
		end
		
		KF.InitializeFunction = nil
	end
	
	if not (E.db.KnightFrame and E.db.KnightFrame.Install_Complete) then
		KF:Install()
		return
	elseif E.db.KnightFrame.Install_Complete == 'NotUpdated' then
		print(L['KF']..' : '..L['You canceled KnightFrame install ago. If you wants to run KnightFrame install process again, please type /kf_install command.'])
	elseif E.db.KnightFrame.Install_Complete ~= Info.Version then
		E.db.KnightFrame.PatchCheck = true
	end
	
	KF:SkipDefaultInstallProcess()
	
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