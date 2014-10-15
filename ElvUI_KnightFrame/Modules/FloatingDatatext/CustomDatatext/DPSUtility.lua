local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 5
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Additional DataText - Damage Utility Tracker				>>--
	--------------------------------------------------------------------------------
	local DT = E:GetModule('DataTexts')
	
	local SkullBanner = GetSpellInfo(114207)
	local SkullBanner_RemainTime
	local SkullBanner_Exists
	
	local StormLashTotem = GetSpellInfo(120668)
	local StormLashTotem_RemainTime
	local StormLashTotem_Exists
	
	local function OnUpdate(self)
		if SkullBanner_RemainTime and KF.TimeNow >= SkullBanner_RemainTime then
			SkullBanner_RemainTime = nil
		end
		
		if StormLashTotem_RemainTime and KF.TimeNow >= StormLashTotem_RemainTime then
			StormLashTotem_RemainTime = nil
		end
		
		
		local text
		
		if SkullBanner_Exists then
			text = '|c'..(SkullBanner_RemainTime and RAID_CLASS_COLORS['WARRIOR']['colorStr'] or 'ff808080')..SkullBanner..(SkullBanner_RemainTime and ' |cffffffff('..floor(SkullBanner_RemainTime - KF.TimeNow)..')' or '')
		end
		
		if StormLashTotem_Exists then
			text = (text and text..KF:Color_Value(' / ') or '')..'|c'..(StormLashTotem_RemainTime and RAID_CLASS_COLORS['SHAMAN']['colorStr'] or 'ff808080')..StormLashTotem..(StormLashTotem_RemainTime and ' |cffffffff('..floor(StormLashTotem_RemainTime - KF.TimeNow)..')' or '')
		end
		
		self.text:SetText(text)
		
		if not SkullBanner_RemainTime and not StormLashTotem_RemainTime then
			self:SetScript('OnUpdate', nil)
		end
	end
	
	
	local function GROUP_ROSTER_UPDATE(self)
		SkullBanner_Exists = nil
		StormLashTotem_Exists = nil
		self.text:SetText(nil)
		
		if KF.CurrentGroupMode ~= 'NoGroup' then
			for i = 1, MAX_RAID_MEMBERS do
				local unit = KF.CurrentGroupMode..i
				
				if UnitExists(unit) and not UnitIsUnit(unit, 'player') then
					local _, userClass = UnitClass(unit)
					local userLevel = UnitLevel(unit)
					
					if userLevel >= 87 and userClass == 'WARRIOR' then
						SkullBanner_Exists = true
					elseif userLevel >= 78 and userClass == 'SHAMAN' then
						StormLashTotem_Exists = true
					end
					
					if SkullBanner_Exists and StormLashTotem_Exists then break end
				end
			end
			
			if SkullBanner_Exists or StormLashTotem_Exists then
				OnUpdate(self)
			end
		end
	end
	
	
	local function OnEvent(self, event, ...)
		if event == 'GROUP_ROSTER_UPDATE' then
			GROUP_ROSTER_UPDATE(self)
		elseif event == 'UNIT_SPELLCAST_SUCCEEDED' then
			local _, _, _, _, spellID = ...
			
			if spellID == 114207 or spellID == 120668 then
				if spellID == 114207 then
					SkullBanner_RemainTime = KF.TimeNow + 10
				else
					StormLashTotem_RemainTime = KF.TimeNow + 10
				end
				
				self:SetScript('OnUpdate', OnUpdate)
			end
		end
	end
	
	
	local function Initialize(self)
		GROUP_ROSTER_UPDATE(self)
		OnUpdate(self)
	end
	
	
	DT:RegisterDatatext('DPS Utility |cff2eb7e4(KF)', {'GROUP_ROSTER_UPDATE', 'UNIT_SPELLCAST_SUCCEEDED', }, OnEvent, Initialize)
end