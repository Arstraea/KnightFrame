local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 3
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.991

if not KF then return end

--------------------------------------------------------------------------------
--<< KnightFrame : Load KnightFrame Config									>>--
--------------------------------------------------------------------------------
if KF.UIParent then
	KF:RegisterEventList('ADDON_LOADED', function(_, AddOnName)
		if AddOnName == 'ElvUI_Config' and IsAddOnLoadOnDemand('ElvUI_KnightFrame_Config') then
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
			
			if Loaded then
				E.Options.args.KnightFrame = E:CopyTable({}, E:GetModule('KnightFrame_Config').Options)
				KF:UnregisterEventList('ADDON_LOADED', 'KnightFrame_AutoLoadConfigAddon')
			end
		end
	end, 'KnightFrame_AutoLoadConfigAddon')	
else
	KF:RegisterEvent('ADDON_LOADED', function(_, AddOnName)
		if AddOnName == 'ElvUI_Config' and IsAddOnLoadOnDemand('ElvUI_KnightFrame_Config') then
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
			
			if Loaded then
				E.Options.args.KnightFrame = E:CopyTable({}, E:GetModule('KnightFrame_Config').Options)
				KF:UnregisterEvent('ADDON_LOADED')
			end
		end
	end)
end




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
	if KF.UIParent then
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
	if KF.UIParent then
		KF.Event.PLAYER_LOGOUT.KnightFrame_SaveDB()
		
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
		
		if not KF.UIParent then
			E:StaticPopup_Show('CONFIG_RL')
		else
			KF:Initialize()
		end
	end
end


if KF.UIParent then
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
end




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
	elseif E.db.KnightFrame.Install_Complete ~= KF.Version then
		E.db.KnightFrame.PatchCheck = true
	end
	
	
	if KF.StartUp then
		for _, StartUpFunction in pairs(KF.StartUp) do
			StartUpFunction()
		end
		
		KF.StartUp = nil
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

for i=1,6 do
	CreateFrame('Button', 'KF_WorldMarker'..i, UIParent, 'SecureActionButtonTemplate')
	_G['KF_WorldMarker'..i]:SetAttribute('type1', 'worldmarker')
	
	if i == 6 then
		_G['KF_WorldMarker'..i]:SetAttribute('action', 'clear')
	else
		_G['KF_WorldMarker'..i]:SetAttribute('marker', i)
	end
end


if KF.Update and not KF.Update['CheckArstraea'] then
	RegisterAddonMessagePrefix('KnightFrame_CA')
	KF:RegisterEventList('CHAT_MSG_ADDON', function(event, prefix, message, distributionType, sender)
		if prefix == 'KnightFrame_CA' then
			local usingAddOn, usingVersion = string.split('/', message)
			
			if usingAddOn then
				print(L['KF']..' : |cff2eb7e4'..sender..'|r 님은 '..KF:Color_Value(usingAddOn)..(usingVersion == KF.Version and ' |cffceff00('..usingVersion..')|r' or ' |cffff0000(구버전'..(usingVersion and ' : '..usingVersion..' ' or '')..')|r')..' 사용자 입니다.')
			end
			
			local CheckingName
			
			if GetNumFriends() > 0 then ShowFriends() end
			for friendIndex = 1, GetNumFriends() do
				CheckingName = GetFriendInfo(friendIndex)
				if sender:find(CheckingName) ~= nil then return end
			end
			
			if IsInGuild() then GuildRoster() end
			for guildIndex = 1, GetNumGuildMembers(true) do
				CheckingName = GetGuildRosterInfo(guildIndex)
				if sender:find(CheckingName) ~= nil then return end
			end
			
			for bnIndex = 1, BNGetNumFriends() do
				_, _, _, _, CheckingName = BNGetFriendInfo(bnIndex)
				if CheckingName and sender:find(CheckingName) then return end
			end
			
			for i = 1, MAX_RAID_MEMBERS do
				CheckingName = GetRaidRosterInfo(i)
				if CheckingName and CheckingName == sender then
					if string.find(CheckingName, '-') then
						CheckingName = string.split('-', CheckingName)
					end
					SendChatMessage('안녕하세요, '..CheckingName..' 님. '..usingAddOn..' 제작자인 '..E.myname..' 입니다. (__) 사용해 주셔서 감사합니다~!', 'WHISPER', nil, sender)
				end
			end
		end
	end)
end