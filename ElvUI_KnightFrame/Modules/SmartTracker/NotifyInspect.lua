local Revision = 1.2
local ENI = _G['EnhancedNotifyInspect'] or CreateFrame('Frame', 'EnhancedNotifyInspect', UIParent)

if not ENI.Revision or ENI.Revision < Revision then
	ENI.InspectList = {}
	ENI.Revision = Revision
	ENI.UpdateInterval = 1
	
	if not ENI.Original_BlizzardNotifyInspect then
		local BlizNotifyInspect = _G['NotifyInspect']
		ENI.Original_BlizzardNotifyInspect = BlizNotifyInspect
	end
	
	ENI:SetScript('OnEvent', function(self, Event, ...)
		if self[Event] then
			self[Event](...)
		end
	end)
	ENI:Hide()
	
	local playerRealm = gsub(GetRealmName(),'[%s%-]','')
	
	local UnitID, Count
	ENI.TryInspect = function()
		for i = 1, #ENI.InspectList do
			if ENI.InspectList[(ENI.InspectList[i])] then
				UnitID = ENI.InspectList[(ENI.InspectList[i])].UnitID
				Count = ENI.InspectList[(ENI.InspectList[i])].InspectTryCount
				
				if UnitID and UnitIsConnected(UnitID) and CanInspect(UnitID) and not (Count and Count <= 0) then
					ENI.CurrentInspectUnitGUID = UnitGUID(UnitID)
					
					if Count then
						ENI.InspectList[(ENI.InspectList[i])].InspectTryCount = ENI.InspectList[(ENI.InspectList[i])].InspectTryCount - 1
					end
					
					ENI.Original_BlizzardNotifyInspect(UnitID)
					
					if ENI.InspectList[(ENI.InspectList[i])].CancelInspectByManual then
						RequestInspectHonorData()
					end
				else
					ENI.CancelInspect(ENI.InspectList[i])
				end
				return
			end
		end
		
		if ENI.NowInspecting and not ENI.NowInspecting._cancelled then
			ENI.NowInspecting:Cancel()
		end
	end
	
	ENI.NotifyInspect = function(Unit, InspectFirst, InspectTryCount)
		if Unit ~= 'target' and UnitIsUnit(Unit, 'target') then
			Unit = 'target'
		end
		
		if Unit ~= 'focus' and UnitIsUnit(Unit, 'focus') then
			Unit = 'focus'
		end
		
		if UnitInParty(Unit) or UnitInRaid(Unit) then
			Unit = GetUnitName(Unit, true)
		end
		
		if UnitIsPlayer(Unit) and CanInspect(Unit) then
			local TableIndex = GetUnitName(Unit, true)
			
			if not ENI.InspectList[TableIndex] then
				if InspectFirst then
					tinsert(ENI.InspectList, 1, TableIndex)
				else
					tinsert(ENI.InspectList, TableIndex)
				end
				
				ENI.InspectList[TableIndex] = {
					UnitID = Unit,
					InspectTryCount = InspectTryCount,
					CancelInspectByManual = InspectFirst
				}
				
				if not ENI.NowInspecting or ENI.NowInspecting._cancelled then
					ENI.NowInspecting = C_Timer.NewTicker(ENI.UpdateInterval, ENI.TryInspect)
				end
				
				ENI:Show()
			elseif InspectFirst and ENI.InspectList[TableIndex] then
				ENI.CancelInspect(TableIndex)
				ENI.NotifyInspect(Unit, InspectFirst, InspectTryCount)
			end
		end
		
		return Unit
	end
	
	ENI.CancelInspect = function(Unit)
		if ENI.InspectList[Unit] then
			for i = 1, #ENI.InspectList do
				if ENI.InspectList[i] == Unit then
					tremove(ENI.InspectList, i)
					break
				end
			end
			
			ENI.InspectList[Unit] = nil
		end
	end
	
	ENI.INSPECT_READY = function(InspectedUnitGUID)
		if InspectedUnitGUID == ENI.CurrentInspectUnitGUID then
			local Name, Realm
			
			_, _, _, _, _, Name, Realm = GetPlayerInfoByGUID(InspectedUnitGUID)
			
			if Name then
				Name = Name..(Realm and Realm ~= '' and Realm ~= playerRealm and '-'..Realm or '')
				
				if ENI.InspectList[Name] then
					if ENI.InspectList[Name].CancelInspectByManual then
						return
					end
					
					ENI.CancelInspect(Name)
				end
			end
			
			ENI.CurrentInspectUnitGUID = nil
		end
	end
	ENI:RegisterEvent('INSPECT_READY')
end