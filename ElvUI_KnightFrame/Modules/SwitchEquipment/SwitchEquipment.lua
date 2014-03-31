local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

--- Last Code Checking Date		: 2014. 3. 24
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Switch Equipment											>>--
	--------------------------------------------------------------------------------
	local ActiveGearSet, ChangingGearSet, SettingComplete
	
	
	local function GetCurrentEquipmentSet()
		for i = 1, GetNumEquipmentSets() do
			local EquipmentSetName, _, _, IsEquipped = GetEquipmentSetInfo(i)
			
			if IsEquipped then
				return EquipmentSetName
			end
		end
	end


	local function OnEvent(event)
		if event == 'EQUIPMENT_SWAP_FINISHED' then
			if ChangingGearSet then
				print(L['KF']..' : '..L['You have equipped equipment set:']..' '..KF:Color_Value(ChangingGearSet))
				
				ChangingGearSet = nil
			end
		elseif not InCombatLockdown() and not ChangingGearSet and E.private.KnightFrame.SwitchEquipment.Enable ~= false then
			ActiveGearSet = GetCurrentEquipmentSet()
			
			local SpecGroup = GetActiveSpecGroup() == 1 and 'Primary' or 'Secondary'
			
			if E.private.KnightFrame.SwitchEquipment.PvP ~= '' and (KF.InstanceType == 'pvp' or KF.InstanceType == 'arena') then
				SpecGroup = 'PvP'
			end
			
			if E.private.KnightFrame.SwitchEquipment[SpecGroup] ~= '' and E.private.KnightFrame.SwitchEquipment[SpecGroup] ~= ActiveGearSet and GetEquipmentSetInfoByName(E.private.KnightFrame.SwitchEquipment[SpecGroup]) then
				ChangingGearSet = E.private.KnightFrame.SwitchEquipment[SpecGroup]
				UseEquipmentSet(ChangingGearSet)
			end
		end
	end
	
	
	KF.Modules[#KF.Modules + 1] = 'SwitchEquipment'
	KF.Modules['SwitchEquipment'] = function(RemoveOrder)
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
end