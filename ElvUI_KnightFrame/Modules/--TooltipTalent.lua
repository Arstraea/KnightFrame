local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent then
	-----------------------------------------------------------
	-- [ Knight : Tooltip Talent							]--
	-----------------------------------------------------------
	GameTooltip:HookScript('OnTooltipSetUnit', function(self, ...)
		if KF.db.Extra_Functions.TooltipTalent ~= false then
			local _, unit = self:GetUnit()
			if (not unit) then
				local mFocus = GetMouseFocus()
				if (mFocus) and (mFocus.unit) then
					unit = mFocus.unit;
				end
			end
			if (not unit) or (not UnitIsPlayer(unit)) then
				return;
			end
			
			local userClass, talentSpec
			if UnitIsUnit(unit, 'player') then
				talentSpec = GetSpecialization()
				if talentSpec then
					_, talentSpec = GetSpecializationInfo(talentSpec)
				end
				userClass = E.myclass
			else
				_, userClass = UnitClass(unit)
				unit = UnitGUID(unit)
				
				local inspectCache
				for index in pairs(E:GetModule('Tooltip').InspectCache) do
					inspectCache = E:GetModule('Tooltip').InspectCache[index]
					if inspectCache.GUID == unit then
						talentSpec = inspectCache.TalentSpec
						break
					end
				end
			end
			
			if talentSpec then
				local talentRole = KF.Memory['Table']['ClassRole'][userClass][talentSpec]['Role']
				GameTooltip:AddDoubleLine(TALENTS..' : ', KF.Memory['Table']['ClassRole'][userClass][talentSpec]['Color']..talentSpec..'|r|cffffffff ('..(talentRole == 'Tank' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:14:14:0:1|t' or talentRole == 'Healer' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:14:14:0:0|t' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:14:14:0:-1|t')..L[talentRole]..')')
			end
		end
	end)
end