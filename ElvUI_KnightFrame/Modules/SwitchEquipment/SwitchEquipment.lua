local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Switch Equipment											>>--
--------------------------------------------------------------------------------
local ActiveGearSet, ChangingGearSet, SettingComplete


local function GetCurrentEquipmentSet()
	local EquipmentSetName, IsEquipped
	for i = 1, GetNumEquipmentSets() do
		EquipmentSetName, _, _, IsEquipped = GetEquipmentSetInfo(i)
		
		if IsEquipped then
			return EquipmentSetName
		end
	end
end


local function OnEvent(event)
	if event == 'EQUIPMENT_SWAP_FINISHED' then
		if ChangingGearSet then
			print(L['KF']..' : '..format(L['You have equipped %s set.'], KF:Color_Value(ChangingGearSet)))
			
			ChangingGearSet = nil
		end
	elseif not InCombatLockdown() and not ChangingGearSet and E.private.KnightFrame.SwitchEquipment.Enable ~= false then
		ActiveGearSet = GetCurrentEquipmentSet()
		
		local SpecGroup = GetActiveSpecGroup() == 1 and 'Primary' or 'Secondary'
		
		if E.private.KnightFrame.SwitchEquipment.PvP ~= '' and (Info.InstanceType == 'pvp' or Info.InstanceType == 'arena') then
			SpecGroup = 'PvP'
		end
		
		if E.private.KnightFrame.SwitchEquipment[SpecGroup] ~= '' and E.private.KnightFrame.SwitchEquipment[SpecGroup] ~= ActiveGearSet and GetEquipmentSetInfoByName(E.private.KnightFrame.SwitchEquipment[SpecGroup]) then
			ChangingGearSet = E.private.KnightFrame.SwitchEquipment[SpecGroup]
			UseEquipmentSet(ChangingGearSet)
		end
	end
end


KF.Modules[#KF.Modules + 1] = 'SwitchEquipment'
KF.Modules.SwitchEquipment = function(RemoveOrder)
	if not RemoveOrder and E.private.KnightFrame.SwitchEquipment.Enable ~= false then
		KF:RegisterCallback('CurrentAreaChanged', OnEvent, 'SwitchEquipment')
		KF:RegisterEventList('ACTIVE_TALENT_GROUP_CHANGED', OnEvent, 'SwitchEquipment')
		KF:RegisterEventList('EQUIPMENT_SWAP_FINISHED', OnEvent, 'SwitchEquipment')
	else
		KF:UnregisterCallback('CurrentAreaChanged', 'SwitchEquipment')
		KF:UnregisterEventList('ACTIVE_TALENT_GROUP_CHANGED', 'SwitchEquipment')
		KF:UnregisterEventList('EQUIPMENT_SWAP_FINISHED', 'SwitchEquipment')
	end
end