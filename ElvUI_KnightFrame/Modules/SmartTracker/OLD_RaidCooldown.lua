local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 27
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return
elseif KF.UIParent and KF.db.Modules.SmartTracker.Enable ~= false then
	-----------------------------------------------------------
	-- [ Knight : Default Value								]--
	-----------------------------------------------------------
	local TT = E:GetModule('Tooltip')
	local Default = {
		['MainFrame_Tab_AddOnName'] = '  Raid Cooldown',
		['MainFrame_Tab_Height'] = 20,
		['CooldownBar_FadeTime'] = 0.4,
	}
	local NowBossBattle = false
	
	
	-----------------------------------------------------------
	-- [ Knight : Define Table								]--
	-----------------------------------------------------------
	local Value = {}
	local Table = {
		['Cooldown_Cache'] = {},
		['Cooldown_BarList'] = {},
		
		['RaidIcon_List'] = {},
		['RaidIcon_LinkBySpellID'] = {},
		['RaidIcon_LinkByNumber'] = {},
		
		['BattleResurrection_CastMember'] = {},
		['BattleResurrection_ResurrectedMember'] = {},
		
		['Inspect_Cache'] = {},
		['Inspect_InspectOrder'] = {},
		['Inspect_InspectDelayed'] = {},
		['Inspect_UpdateOrder'] = {},
		['Inspect_UpdateDelayed'] = {},
	}
	local Func = {}
	
	
	-----------------------------------------------------------
	-- [ Knight : Table Data								]--
	-----------------------------------------------------------
	do
		Table['ChangeCDByTalent'] = {
			['HUNTER'] = {
				[3] = { 19263, -60, }, --웅크린 호랑이, 숨은 키메라 : 공격저지- 60
				[103] = { 781, -10, }, --웅크린 호랑이, 숨은 키메라 : 철수 -10
			},
			['MAGE'] = {
				[16] = { 12051, -10, }, --마법의 기원
			},
		}
		
		Table['ChangeCDByGlyph'] = {
			--WARRIOR
			[63329] = { 871, 120, }, --방벽
			[63325] = { 6544, -15, }, --전사 영도
			[63328] = { 23920, -5, }, --전사 주반
			--HUNTER
			[119384] = { 19801, 10, }, --평정
			--SHAMAN
			[55441] = { 8177, 35, }, --마훔토템
			[55451] = { 57994, 3, }, --날카로운 바람
			[55454] = { 58875, -22.5, }, --정령의 걸음
			[63270] = { 51490, -10, }, --천둥
			[55455] = { 2894, -120, }, --불의 정령토템
			[63291] = { 51514, -10, }, --사술
			[55439] = { 370, 6, }, --정화
			--MONK
			[123391] = { 115080, 120, }, --절명의 손길
			--ROGUE
			[56810] = { 5938, -2, }, --독칼
			[56805] = { 1766, 4, }, --발차기
			--DEATHKNIGHT
			[58673] = { 48792, -90, }, --얼음같은 인내력
			[63331] = { 77606, -30, }, --어둠 복제
			[58686] = { 47528, -2, },--정신 얼리기
			--MAGE
			[56376] = { 122, -5, }, --얼음회오리
			[56368] = { 11129, 45, }, --발화
			[62210] = { 12042, 90, }, --신비한 마법 강화
			[115703] = { 2139, 4, }, --마법 차단
			--DRUID
			[114223] = { 61336, -60, }, --드루 생본
			[116238] = { 106922, 120, }, --드루 우르속의 힘
			[116203] = { 16689, -30, }, --자연의 손아귀
			[59219] = { 1850, -60, }, --질주
			[116216] = { 106839, 10, }, --두개골 강타
			[114237] = { 770, 9, }, --요정의 침묵
			--PALADIN
			[54925] = { 96231, 5, }, --비난
			[54939] = { 633, 120, }, --신앙
			--PRIEST
			[63229] = { 47585, -15, }, --사제 분산
			[55678] = { 6346, -60, }, --공포의 수호물
			[55691] = { 32375, -1, }, --대규모 무효화
			[55688] = { 64044, -10, }, --정신적 두려움
			--WARLOCK
			[56244] = { 5787, 5, }, --공포
			[63309] = { 48020, -4, }, --악마의 마법진
			[56226] = { 86121, 30, }, --영혼 바꾸기
			[58080] = { 18223, 10, }, --피로의 저주
			[56238] = { 755, 10, }, --생명력 집중
		}
		
		Table['ConvertSpellID'] = {
			--WARLOCK
			[95750] = 20707, --영석
			[111859] = 108501, --흑마법서: 봉사
			[111895] = 108501, --흑마법서: 봉사
			[111896] = 108501, --흑마법서: 봉사
			[111897] = 108501, --흑마법서: 봉사
			[111898] = 108501, --흑마법서: 봉사
			[86121] = false, --영혼바꾸기에 체크하지않음
			[86213] = 86121, --영혼바꾸기: 내보내기에 체크
			
			--HUNTER
			[60192] = 1499, --빙덫 투척
			[82948] = 34600, --뱀덫 투척
			[82941] = 13809, --얼덫 투척
			[82939] = 13813, --폭덫 투척
			
			--DRUID
			[77764] = 77761, --쇄포
			[106898] = 77761, --쇄포
			[16979] = 102401, --야생의 돌진(곰)
			[49376] = 102401, --야생의 돌진(표범)
			[102383] = 102401, --야생의 돌진(올빼미)
			[102416] = 102401, --야생의 돌진(바다표범)
			[102417] = 102401, --야생의 돌진(순록)
			
			--MONK
			[120954] = 115203, --강화주(문양)
		}
		
		Table['BattleResurrection'] = {
			[61999] = {
				['Class'] = 'DEATHKNIGHT',
				['Level'] = 72,
			},
			[20484] = {
				['Class'] = 'DRUID',
				['Level'] = 56,
			},
			[20707] = {
				['Class'] = 'WARLOCK',
				['Level'] = 18,
			},
		}
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : Toolkit									]--
	-----------------------------------------------------------
	do
		Func['TimeFormat'] = function(InputTime)
			if InputTime > 60 then
				return string.format('%d:%.2d', InputTime / 60, InputTime % 60)
			elseif InputTime < 10 then
				return string.format('|cffb90624%.1f|r', InputTime)
			else
				return string.format('%d', InputTime)
			end
		end
	
	
		Func['GetRoleIcon'] = function(userGUID)
			local RoleIcon = ''
			local userSpec, userClass
			
			if Table['Inspect_Cache'][userGUID] and Table['Inspect_Cache'][userGUID]['Specialization'] then
				userSpec = Table['Inspect_Cache'][userGUID]['Specialization']
				userClass = Table['Inspect_Cache'][userGUID]['Class']
			end
			
			if not userSpec and not userClass and Table['Cooldown_Cache'][userGUID] and Table['Cooldown_Cache'][userGUID]['Specialization'] then
				userSpec = Table['Cooldown_Cache'][userGUID]['Specialization']
				userClass = Table['Cooldown_Cache'][userGUID]['Class']
			end
			
			if userSpec and userClass then
				local role = KF.Table['ClassRole'][userClass][userSpec]['Role']
				if role == 'Tank' then
					RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\tank.tga:12:12:0:|t'
				elseif role == 'Healer' then
					RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\healer.tga:12:12:0:0|t'
				else
					RoleIcon = '|TInterface\\AddOns\\ElvUI_KnightFrame\\Media\\Graphics\\dps.tga:12:12:0:0|t'
				end
			end
			
			return RoleIcon
		end
		
		
		Func['Announcer'] = function(userGUID, spellID)
			local Channel = KF.db.Modules.SmartTracker.General.CooldownEndAnnounce or 0
			if Channel == 0 then return end
			
			local ChannelList = {
				[1] = 'self',
				[2] = 'SAY',
				[3] = 'PARTY',
				[4] = 'RAID',
				[5] = 'GUILD',
			}
			
			--Get Channel or Change Channel by situation
			if Channel > 5 then
				Channel = GetChannelName(KF.db.Modules.SmartTracker.General.PrivateChannelName or 0)
				if Channel == 0 then
					print(L['KF']..' : '..L['Could not find the private channel been stored for the announcement. Channel setting will be chaged to the default.'])
					KF.db.Modules.SmartTracker.General.CooldownEndAnnounce = 1
					KF.db.Modules.SmartTracker.General.PrivateChannelName = nil
					Channel = 'self'
				end
			elseif (Channel == 3 or Channel == 4) then
				if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
					Channel = Value['CurrentInstance_Type'] == 'pvp' and 'self' or 'INSTANCE_CHAT'
				elseif KF.CurrentGroupMode == 'NoGroup' then
					Channel = 'self'
				elseif (KF.CurrentGroupMode == 'party' and Channel == 4) or (Channel == 4 and not (KF.Arstraea[E.myname] or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player'))) then
					Channel = 'PARTY'
				else
					Channel = ChannelList[Channel]
				end
			elseif Channel == 5 and not IsInGuild() then
				Channel = 'self'
			elseif KF.CurrentGroupMode == 'raid' and Channel == 2 then
				Channel = 'YELL'
			else
				Channel = ChannelList[Channel] or 'nil'
			end
			
			--Announce
			if Channel == 'self' then
				print(L['KF']..' : '..format(L["%s's %s is available!!"], KF:Color_Class(Table['Cooldown_Cache'][userGUID]['Class'], Table['Cooldown_Cache'][userGUID]['Name']), GetSpellLink(spellID)))
			elseif type(Channel) == 'number' then
				SendChatMessage(format(L["%s's %s is available!!"], Table['Cooldown_Cache'][userGUID]['Name'], GetSpellLink(spellID)), 'CHANNEL', nil, Channel)
			elseif Channel ~= 'nil' then
				SendChatMessage(format(L["%s's %s is available!!"], Table['Cooldown_Cache'][userGUID]['Name'], GetSpellLink(spellID)), Channel)
			end
		end
		
		
		Func['CalcCooldown'] = function(eventType, userGUID, userName, userClass, spellID, destName)
			local Cooldown = KF.Table['RaidCooldownSpell'][userClass][spellID][1]
			
			if Table['Inspect_Cache'][userGUID] then
				local userSpec = Table['Inspect_Cache'][userGUID]['Specialization'] or Table['Cooldown_Cache'][userGUID]['Specialization']
				
				if userSpec then
					if destName and destName:find('|cff') then destName = strsub(destName, 11, -3) end
					
					--Change Cooldown By Specialization
					if userClass == 'WARRIOR' and userSpec == L['Spec_Warrior_Protection'] and spellID == 871 then
						Cooldown = Cooldown - 60
					elseif userClass == 'HUNTER' and userSpec == L['Spec_Hunter_Survival'] and (spellID == 1499 or spellID == 13809 or spellID == 34600) then
						Cooldown = Cooldown - 6
					elseif userClass == 'DRUID' and userSpec == L['Spec_Druid_Restoration'] and spellID == 740 and UnitLevel(userName) >= 82 then
						Cooldown = Cooldown - 300
					elseif userClass == 'ROGUE' and eventType == 'SPELL_INTERRUPT' and spellID == 1766 and (Table['Inspect_Cache'][userGUID]['Glyph'][2] == 56805 or Table['Inspect_Cache'][userGUID]['Glyph'][4] == 56805 or Table['Inspect_Cache'][userGUID]['Glyph'][6] == 56805) then
						Cooldown = Cooldown - 6
					elseif userClass == 'PALADIN' and userSpec == L['Spec_Paladin_Retribution'] and spellID == 31884 then
						Cooldown = Cooldown - 60
					elseif userClass == 'PRIEST' and userSpec == L['Spec_Priest_Shadow'] and spellID == 108968 then
						Cooldown = Cooldown + 300
					end
					--[[
					if userClass == 'HUNTER' and destName and spellID == 131894 then
						local CheckID = UnitName(userName..'-target')
						UnitHealth(destName)/UnitHealthMax(destName) <= 0.2 then
						
						local asdfasdf = UnitName(userName..'-target')
						print(asdfasdf)
						print(asdfasdf ~= nil and UnitHealth(userName..'-target') or 'nil')
						
						Cooldown = Cooldown - 60 --저승까마귀 생명력 20% 이하 대상에게 사용 시 60초감소
					end]]
					
					--Change Cooldown By Talent
					if Table['ChangeCDByTalent'][userClass] then
						for SlotNumber, Data in pairs(Table['ChangeCDByTalent'][userClass]) do
							if Data[1] == spellID then
								SlotNumber = SlotNumber > 100 and SlotNumber - 100 or SlotNumber
								
								if Table['Inspect_Cache'][userGUID]['Talent'][SlotNumber] == true then
									Cooldown = Cooldown + Data[2]
								end
							end
						end
					end
					
					--Change Cooldown By Glyph
					for glyphID, Data in pairs(Table['ChangeCDByGlyph']) do
						if Data[1] == spellID then
							for i = 1, 6 do
								if Table['Inspect_Cache'][userGUID]['Glyph'][i] == glyphID then
									Cooldown = Cooldown + Data[2]
									break
								end
							end
						end
					end
					
					return Cooldown, nil
				end
			end
			
			return Cooldown, true
		end
		
		
		-- Refresh Cooltime
		KF.Update['RaidCooldown_RefreshCooldown'] = {
			['Condition'] = function() return Value['RefreshCooldown'] end,
			['Delay'] = 0,
			['Action'] = function()
				local HasData, RemainCooltime, NeedRefreshCooldownBarData
				
				for userGUID in pairs(Table['Cooldown_Cache']) do
					HasData = nil
					
					for spellID in pairs(Table['Cooldown_Cache'][userGUID]['List']) do
						HasData = true
						
						RemainCooltime = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow
						
						if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Chargy'] and RemainCooltime <= 0 then
							if Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] ~= 0 then
								if KF.db.Modules.SmartTracker[Table['Cooldown_Cache'][userGUID]['Class']][spellID] == 3 then
									Func['Announcer'](userGUID, spellID)
								end
								
								Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime2'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime']
							else
								Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime2']
							end
							
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor2']
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName2']
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName2'] = nil
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['Chargy'] = nil
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime2'] = nil
							
							RemainCooltime = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow
							
							NeedRefreshCooldownBarData = true
						end
						
						if RemainCooltime <= 0 then
							if KF.db.Modules.SmartTracker[Table['Cooldown_Cache'][userGUID]['Class']][spellID] == 3 and not (Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] and Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['NoAnnounce']) then
								Func['Announcer'](userGUID, spellID)
							end
							
							Table['Cooldown_Cache'][userGUID]['List'][spellID] = nil
							
							NeedRefreshCooldownBarData = true
						end
					end
					
					if not HasData then
						Table['Cooldown_Cache'][userGUID] = nil
					end
				end
				
				if NeedRefreshCooldownBarData then
					KF:RaidCooldown_RefreshCooldownBarData()
				elseif HasData == nil then
					Value['RefreshCooldown'] = nil
				end
			end,
		}
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : Cooldown Bar								]--
	-----------------------------------------------------------
	do
		Func['CooldownBar_Create'] = function()
			if Func['DisplayableBarNumber']() > #Table['Cooldown_BarList'] then
				local BarNumber = #Table['Cooldown_BarList'] + 1
				local bar = CreateFrame('Frame', nil, KnightRaidCooldown)
				bar:SetAlpha(0)
				bar:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				bar:SetFrameLevel(3)
				
				bar.SpellIconFrame = CreateFrame('Button', nil, bar)
				bar.SpellIconFrame:SetBackdrop({
					bgFile = false,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				bar.SpellIconFrame:Point('LEFT', bar)
				bar.SpellIconFrame:RegisterForClicks('AnyUp')
				bar.SpellIcon = bar.SpellIconFrame:CreateTexture(nil, 'OVERLAY')
				bar.SpellIcon:SetTexCoord(unpack(E.TexCoords))
				bar.SpellIcon:SetInside()
				bar.SpellIconFrame:SetScript('OnEnter', function(self)
					if Table['Cooldown_BarList'][BarNumber]['Data']['FrameType'] == 'NamePlate' or not Table['Cooldown_BarList'][BarNumber]['Data'] then return end
					
					self:SetScript('OnUpdate', function()
						if Table['Cooldown_BarList'][BarNumber]['Data']['FrameType'] ~= 'NamePlate' and Table['Cooldown_BarList'][BarNumber]['Data']['spellID'] then
							if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then -- 1 : Up / 2 : Down
								GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
							else
								GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
							end
							GameTooltip:ClearLines()
							
							if KF.db.Modules.SmartTracker.General.ShowDetailTooltip == true or IsShiftKeyDown() then
								GameTooltip:SetHyperlink(GetSpellLink(Table['Cooldown_BarList'][BarNumber]['Data']['spellID']))
								GameTooltip:AddLine('|n')
							else
								GameTooltip:AddLine(GetSpellInfo(Table['Cooldown_BarList'][BarNumber]['Data']['spellID']))
							end
							GameTooltip:AddDoubleLine(' - |cff2eb7e4'..L['RightClick'], L['Remove this cooltime bar.'], 1, 1, 1, 1, 1, 1)
							GameTooltip:AddDoubleLine(' - Shift + |cff2eb7e4'..L['RightClick'], L['Clear this spell config to forbid displaying.'], 1, 1, 1, 1, 1, 1)
							GameTooltip:Show()
						end
					end)
					self:SetScript('OnClick', function(_, button)
						if button ~= 'RightButton' or Table['Cooldown_BarList'][BarNumber]['Data']['FrameType'] == 'NamePlate' then
							return
						else
							GameTooltip:Hide()
							if IsShiftKeyDown() then
								KF.db.Modules.SmartTracker[Table['Cooldown_Cache'][Table['Cooldown_BarList'][BarNumber]['Data']['GUID']]['Class']][Table['Cooldown_BarList'][BarNumber]['Data']['spellID']] = 0
								KF:RaidCooldown_RefreshCooldownBarData()
							elseif not Table['Cooldown_Cache'][Table['Cooldown_BarList'][BarNumber]['Data']['GUID']]['List'][Table['Cooldown_BarList'][BarNumber]['Data']['spellID']]['Fade'] or Table['Cooldown_Cache'][Table['Cooldown_BarList'][BarNumber]['Data']['GUID']]['List'][Table['Cooldown_BarList'][BarNumber]['Data']['spellID']]['Fade']['FadeType'] == 'IN' then
								if Table['Cooldown_Cache'][Table['Cooldown_BarList'][BarNumber]['Data']['GUID']]['List'][Table['Cooldown_BarList'][BarNumber]['Data']['spellID']]['Chargy'] then
									Table['Cooldown_Cache'][Table['Cooldown_BarList'][BarNumber]['Data']['GUID']]['List'][Table['Cooldown_BarList'][BarNumber]['Data']['spellID']]['ActivateTime'] = 0
								else
									Table['Cooldown_Cache'][Table['Cooldown_BarList'][BarNumber]['Data']['GUID']]['List'][Table['Cooldown_BarList'][BarNumber]['Data']['spellID']]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, }
								end
							end
						end
					end)
					self:SetScript('OnLeave', function() self:SetScript('OnUpdate', nil) self:SetScript('OnClick', nil) GameTooltip:Hide() end)
				end)
				
				bar.CooldownBar2 = CreateFrame('Statusbar', nil, bar)
				bar.CooldownBar2:SetMinMaxValues(0,100)
				bar.CooldownBar2:SetValue(100)
				bar.CooldownBar2:SetStatusBarTexture(E['media'].normTex)
				bar.CooldownBar2:SetFrameLevel(4)
				bar.CooldownBar2:Point('TOPLEFT', bar.SpellIconFrame, 'TOPRIGHT', 0, -1)
				bar.CooldownBar2:Point('BOTTOMRIGHT', bar, -1, 1)
				
				bar.CooldownBar = CreateFrame('Statusbar', nil, bar)
				bar.CooldownBar:SetMinMaxValues(0,100)
				bar.CooldownBar:SetStatusBarTexture(E['media'].normTex)
				bar.CooldownBar:SetFrameLevel(5)
				bar.CooldownBar:Point('TOPLEFT', bar.SpellIconFrame, 'TOPRIGHT', 0, -1)
				bar.CooldownBar:Point('BOTTOMRIGHT', bar, -1, 1)
				
				KF:TextSetting(bar.CooldownBar, nil, { ['Tag'] = 'Time', ['FontSize'] = KF.db.Modules.SmartTracker.Appearance.Bar_Fontsize, ['FontOutline'] = 'OUTLINE', ['directionH'] = 'RIGHT', }, 'RIGHT', bar.CooldownBar, -2, 0)
				bar.Time = bar.CooldownBar.Time
				
				KF:TextSetting(bar.CooldownBar, nil, { ['FontSize'] = KF.db.Modules.SmartTracker.Appearance.Bar_Fontsize, ['FontOutline'] = 'OUTLINE', ['directionH'] = 'LEFT', }, 'LEFT', bar.CooldownBar, 5, 0)
				bar.CooldownBar.text:Point('RIGHT', bar.Time, 'LEFT', -5, 0)
				
				Table['Cooldown_BarList'][BarNumber] = bar
				
				KF.Update['RaidCooldownBar'..BarNumber] = {
					['Condition'] = function() if Table['Cooldown_BarList'][BarNumber]:IsShown() and Table['Cooldown_BarList'][BarNumber]['Data'] then return true end end,
					['Delay'] = 0,
					['Action'] = function(elapsed) Func['CooldownBar_OnUpdate'](BarNumber, elapsed) end,
				}
				
				return bar
			end
		end
		
		
		Func['CooldownBar_OnUpdate'] = function(BarNumber, elapsed)
			local bar = Table['Cooldown_BarList'][BarNumber]
			local userGUID = bar['Data']['GUID']
			
			if bar['Data']['FrameType'] == 'NamePlate' then
				if not bar['Data']['StopUpdate'] then
					bar:SetAlpha(1)
					bar:SetBackdropColor(0, 0, 0, 0)
					bar:SetBackdropBorderColor(0, 0, 0, 0)
					bar.SpellIconFrame:SetBackdropBorderColor(0, 0, 0, 0)
					bar.CooldownBar2:SetStatusBarColor(0, 0, 0, 0)
					bar.CooldownBar:SetStatusBarColor(0, 0, 0, 0)
					bar.SpellIcon:SetTexture(nil)
					bar.Time:SetText(nil)
					
					bar.CooldownBar.text:SetText('|TInterface\\AddOns\\ElvUI\\media\\textures\\'..(bar['Data']['ArrowUp'] and 'arrowup' or 'arrowdown')..'.tga:10:10:-4:-1:64:64:0:64:0:64:206:255:0|t'..KF:Color_Class(Table['Cooldown_Cache'][userGUID]['Class'], Table['Cooldown_Cache'][userGUID]['Name']))
					Table['Cooldown_BarList'][BarNumber]['Data']['StopUpdate'] = true
				end
				
				if Table['Inspect_Cache'][userGUID] then
					if Table['Inspect_Cache'][userGUID]['Specialization'] and (not Table['Cooldown_Cache'][userGUID]['Specialization'] or Table['Cooldown_Cache'][userGUID]['Specialization'] ~= Table['Inspect_Cache'][userGUID]['Specialization']) then
						Table['Cooldown_Cache'][userGUID]['Specialization'] = Table['Inspect_Cache'][userGUID]['Specialization']
					end
					
					if Table['Cooldown_Cache'][userGUID]['Specialization'] then
						bar.CooldownBar.text:SetText('|TInterface\\AddOns\\ElvUI\\media\\textures\\'..(bar['Data']['ArrowUp'] and 'arrowup' or 'arrowdown')..'.tga:10:10:-4:-1:64:64:0:64:0:64:206:255:0|t'..KF:Color_Class(Table['Cooldown_Cache'][userGUID]['Class'], Table['Cooldown_Cache'][userGUID]['Name'])..Func['GetRoleIcon'](userGUID))
					end					
				end
			elseif bar['Data']['FrameType'] == 'CooldownBar' then
				local bar_color = RAID_CLASS_COLORS[Table['Cooldown_Cache'][userGUID]['Class']]
				local spellID = tonumber(bar['Data']['spellID'])
				
				local RemainCooltime = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow
				
				if not bar['Data']['StopUpdate'] then
					local spellName, _, spellIcon = GetSpellInfo(spellID)
					bar.SpellIcon:SetTexture(spellIcon)
					
					bar:SetBackdropBorderColor(unpack(E['media'].bordercolor))
					bar.SpellIconFrame:SetBackdropBorderColor(unpack(E['media'].bordercolor))
					bar:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Appearance.Color_BarBackground))
					
					if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Chargy'] then
						bar.CooldownBar2:SetStatusBarColor(bar_color.r, bar_color.g, bar_color.b)
						bar.CooldownBar:SetStatusBarColor(unpack(KF.db.Modules.SmartTracker.Appearance.Color_ChargedBar))
						
						if KF.Table['RaidCooldownSpell'][Table['Cooldown_Cache'][userGUID]['Class']][spellID][2] then
							bar.CooldownBar.text:SetText(spellName..' (2) |cffceff00▶|r '..Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor']..Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName']..(Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName'] == Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName2'] and '|r x '..Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor']..'2|r' or '|r, '..Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor2']..Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName2']))
						else
							bar.CooldownBar.text:SetText(spellName..' (2)')
						end
					else
						bar.CooldownBar2:SetStatusBarColor(0, 0, 0, 0)
						bar.CooldownBar:SetStatusBarColor(bar_color.r, bar_color.g, bar_color.b)
						
						if KF.Table['RaidCooldownSpell'][Table['Cooldown_Cache'][userGUID]['Class']][spellID][2] then
							bar.CooldownBar.text:SetText(spellName..' |cffceff00▶|r '..Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor']..Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName']..'|r')
						else
							bar.CooldownBar.text:SetText(spellName)
						end
					end
					
					Table['Cooldown_BarList'][BarNumber]['Data']['StopUpdate'] = true
				end
				
				if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] then
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['fadeTimer'] = (Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['fadeTimer'] or 0) + elapsed
					
					if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['fadeTimer'] < Default['CooldownBar_FadeTime'] then
						if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['FadeType'] == 'IN' then
							bar:SetAlpha(Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['fadeTimer'] / Default['CooldownBar_FadeTime'])
						else
							bar:SetAlpha((Default['CooldownBar_FadeTime'] - Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['fadeTimer']) / Default['CooldownBar_FadeTime'])
						end
					else
						if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['FadeType'] == 'IN' then
							bar:SetAlpha(1)
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] = nil
						else
							bar:SetAlpha(0)
							Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = 0
							KF.Update['RaidCooldown_RefreshCooldown']['Action']()
							return
						end
					end
				elseif bar:GetAlpha() ~= 1 then
					bar:SetAlpha(1)
				end
				
				if Table['Cooldown_Cache'][userGUID]['List'][spellID]['NeedCalculating'] and ((Table['Inspect_Cache'][userGUID] and Table['Inspect_Cache'][userGUID]['Specialization']) or Table['Cooldown_Cache'][userGUID]['Specialization']) then
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'], Table['Cooldown_Cache'][userGUID]['List'][spellID]['NeedCalculating'] = Func['CalcCooldown'](Table['Cooldown_Cache'][userGUID]['List'][spellID]['Event'], userGUID, Table['Cooldown_Cache'][userGUID]['Name'], Table['Cooldown_Cache'][userGUID]['Class'], spellID, Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName'])
				end
				
				if not Table['Cooldown_Cache'][userGUID]['List'][spellID]['Chargy'] and (KF.TimeNow > Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - Default['CooldownBar_FadeTime']) and not Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] then
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] = { ['FadeType'] = KF.TimeNow, }
				end
				
				bar.CooldownBar:SetValue(100 - (KF.TimeNow - Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime']) / Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] * 100)
				bar.Time:SetText(Func['TimeFormat'](RemainCooltime))
			end
		end
		
		
		Func['CooldownBar_UpdateAppearance'] = function(CurrentLine)
			local frame = Table['Cooldown_BarList'][CurrentLine]
			if not frame then return end
			
			frame:ClearAllPoints()
			frame:Point('LEFT', KnightRaidCooldown.DisplayArea)
			frame:Point('RIGHT', KnightRaidCooldown.DisplayArea)
			if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then
				if CurrentLine == 1 then
					frame:Point('BOTTOM', KnightRaidCooldown.DisplayArea, 0, 2 + (Value['IsRaidIconShow'] == true and KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 3 and KF.db.Modules.SmartTracker.Appearance.RaidIcon_Size + KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing * 2 or 0))
				else
					frame:Point('BOTTOM', Table['Cooldown_BarList'][CurrentLine - 1], 'TOP', 0, -1)
				end
			else
				if CurrentLine == 1 then
					frame:Point('TOP', KnightRaidCooldown.DisplayArea, 0, -2 - (Value['IsRaidIconShow'] == true and KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 4 and KF.db.Modules.SmartTracker.Appearance.RaidIcon_Size + KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing * 2 or 0))
				else
					frame:Point('TOP', Table['Cooldown_BarList'][CurrentLine - 1], 'BOTTOM', 0, 1)
				end
			end
			frame:SetHeight(KF.db.Modules.SmartTracker.Appearance.Bar_Height)
			frame.SpellIconFrame:Size(KF.db.Modules.SmartTracker.Appearance.Bar_Height)
			frame.Time:SetFont(frame.Time:GetFont(), KF.db.Modules.SmartTracker.Appearance.Bar_Fontsize, 'OUTLINE')
			frame.CooldownBar.text:SetFont(frame.CooldownBar.text:GetFont(), KF.db.Modules.SmartTracker.Appearance.Bar_Fontsize, 'OUTLINE')
			
			frame:Show()
		end
		
		
		function KF:RaidCooldown_RefreshCooldownBarData()
			local CurrentWheelLine = KnightRaidCooldown.CurrentWheelLine
			local BarNumber = Func['DisplayableBarNumber']()
			
			KnightRaidCooldown.DisplayArea.text:SetText(L['Enable to display']..' : |cff2eb7e4'..BarNumber)
			
			local CurrentLine = 1
			local PrevUserExists, NameSetting, BarExists, RemainCooltime, CurrentLineFrame, NextLineFrame
			
			KF.Update['RaidCooldown_RefreshCooldown']['Action']()
			
			for userGUID in pairs(Table['Cooldown_Cache']) do
				NameSetting = nil
				BarExists = nil
				
				for spellID in pairs(Table['Cooldown_Cache'][userGUID]['List']) do
					if BarExists == nil then BarExists = false end
					
					RemainCooltime = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow
					
					if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Display']() == true then
						if CurrentWheelLine > 0 then
							PrevUserExists = nil
							CurrentWheelLine = CurrentWheelLine - 1
							
							if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] then
								if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['FadeType'] == 'IN' then
									Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] = nil
								elseif Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['FadeType'] + Default['CooldownBar_FadeTime'] < KF.TimeNow then
									Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = 0
								end
							end
						else
							CurrentLineFrame = Table['Cooldown_BarList'][CurrentLine] or Func['CooldownBar_Create']()
							
							if CurrentLineFrame and CurrentLine <= BarNumber then
								Func['CooldownBar_UpdateAppearance'](CurrentLine)
								
								if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 2 and not NameSetting then
									BarExists = true
									NameSetting = true
									Table['Cooldown_BarList'][CurrentLine]['Data'] = {
										['FrameType'] = 'NamePlate',
										['GUID'] = userGUID,
									}
									
									CurrentLine = CurrentLine + 1
									NextLineFrame = Table['Cooldown_BarList'][CurrentLine] or Func['CooldownBar_Create']()
								
									if not (NextLineFrame and CurrentLine <= BarNumber) then
										Value['CooltimeRemainExists'] = true
										break
									else
										Func['CooldownBar_UpdateAppearance'](CurrentLine)
									end
								elseif KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then
									NextLineFrame = Table['Cooldown_BarList'][CurrentLine + 1] or Func['CooldownBar_Create']()
									
									if NextLineFrame and CurrentLine + 1 <= BarNumber then
										BarExists = true
										NameSetting = true
										
										Func['CooldownBar_UpdateAppearance'](CurrentLine + 1)
										
										Table['Cooldown_BarList'][CurrentLine + 1]['Data'] = {
											['FrameType'] = 'NamePlate',
											['GUID'] = userGUID,
										}
									else
										NameSetting = nil
										Table['Cooldown_BarList'][CurrentLine]['Data'] = {
											['FrameType'] = 'NamePlate',
											['GUID'] = userGUID,
										}
										
										if BarExists == false then
											Table['Cooldown_BarList'][CurrentLine]['Data']['ArrowUp'] = true
										else
											Value['CooltimeRemainExists'] = true
										end
									end
								end
								
								if NameSetting then
									Table['Cooldown_BarList'][CurrentLine]['Data'] = {
										['FrameType'] = 'CooldownBar',
										['GUID'] = userGUID,
										['spellID'] = spellID,
									}
								end
								
								CurrentLine = CurrentLine + 1
							elseif Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] then
								if Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['FadeType'] == 'IN' then
									Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] = nil
									Value['CooltimeRemainExists'] = true
								elseif Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade']['FadeType'] + Default['CooldownBar_FadeTime'] < KF.TimeNow then
									Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = 0
								end
							else
								Value['CooltimeRemainExists'] = true
							end
						end
					end
				end
				
				if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 and NameSetting then
					CurrentLine = CurrentLine + 1
				end
				
				if BarExists == false and CurrentLine == 1 then
					PrevUserExists = true
				end
			end
			
			for i = CurrentLine, #Table['Cooldown_BarList'] do
				Table['Cooldown_BarList'][i]['Data'] = nil
				Table['Cooldown_BarList'][i]:Hide()
			end
			
			if KnightRaidCooldown.CurrentWheelLine > 0 and CurrentLine + (PrevUserExists and 1 or 0) <= BarNumber then
				KnightRaidCooldown.CurrentWheelLine = KnightRaidCooldown.CurrentWheelLine - 1
				KF:RaidCooldown_RefreshCooldownBarData()
			end
		end
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : RaidIcon									]--
	-----------------------------------------------------------
	do
		Func['RaidIcon_Create'] = function(spellID)
			local Icon = CreateFrame('Button', nil, KnightRaidCooldown)
			Icon:SetBackdrop({
				bgFile = E['media'].blankTex,
				edgeFile = E['media'].blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			Icon:SetFrameLevel(3)
			Icon:SetBackdropColor(0, 0, 0, 0.8)
			Icon:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			Icon:SetScript('OnEnter', function(self)
				self:SetBackdropBorderColor(unpack(E['media'].rgbvaluecolor))
				self.DisplayTooltip = true
				
				if KF.db.Modules.SmartTracker.Appearance.RaidIcon_StartPoint == 2 then
					if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then
						GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
					else
						GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
					end
				else --Default Location is 1(LEFTSIDE of MainFrame)
					if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then
						GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
					else
						GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
					end
				end
			end)
			Icon:SetScript('OnLeave', function(self)
				self:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				self.DisplayTooltip = nil
				GameTooltip:Hide()
			end)
			
			Icon.SpellIcon = Icon:CreateTexture(nil, 'OVERLAY')
			Icon.SpellIcon:SetTexCoord(unpack(E.TexCoords))
			Icon.SpellIcon:SetTexture(select(3, GetSpellInfo(spellID)))
			Icon.SpellIcon:SetInside()
			
			KF:TextSetting(Icon, nil, { ['FontSize'] = KF.db.Modules.SmartTracker.Appearance.RaidIcon_Fontsize, ['FontOutline'] = 'OUTLINE', ['directionH'] = 'RIGHT', }, 'BOTTOMRIGHT', -1, 4)
			
			Icon:Hide()
			Table['RaidIcon_List'][spellID] = Icon
			
			KF.Update['RaidCooldown_RaidIcon_'..spellID] = {
				['Condition'] = function()
					if Table['RaidIcon_List'][spellID]:IsShown() then
						for _ in pairs(Table['RaidIcon_List'][spellID]['Data']) do
							return true
						end
					end
				end,
				['Delay'] = 0,
				['Action'] = function()
					Icon.SpellCount = #Table['RaidIcon_List'][spellID]['Data']
					for _, userGUID in pairs(Table['RaidIcon_List'][spellID]['Data']) do
						if Table['Cooldown_Cache'][userGUID] and Table['Cooldown_Cache'][userGUID]['List'][spellID] then
							Icon.SpellCount = Icon.SpellCount - 1
						end
					end
					
					if Icon.SpellCount == 0 then
						Icon.SpellIcon:SetAlpha(0.2)
						Icon.text:SetText('|cffb90624'..Icon.SpellCount..(KF.db.Modules.SmartTracker.Appearance.RaidIcon_DisplayMax ~= false and '/'..#Table['RaidIcon_List'][spellID]['Data'] or ''))
					else
						Icon.SpellIcon:SetAlpha(1)
						Icon.text:SetText(Icon.SpellCount..(KF.db.Modules.SmartTracker.Appearance.RaidIcon_DisplayMax ~= false and '/'..#Table['RaidIcon_List'][spellID]['Data'] or ''))
					end
					
					if Icon.DisplayTooltip then
						GameTooltip:ClearLines()
						
						if KF.db.Modules.SmartTracker.General.ShowDetailTooltip ~= false or IsShiftKeyDown() then
							GameTooltip:SetHyperlink(GetSpellLink(spellID))
							GameTooltip:AddLine('|n|cff1784d1>>|r '..L['Castable User']..' |cff1784d1<<', 1, 1, 1)
						else
							GameTooltip:AddLine('|cff1784d1>>|r '..GetSpellInfo(spellID)..' |cff1784d1<<', 1, 1, 1)
						end
					end
					
					local userName, RemainCooltime
					for _, userGUID in pairs(Table['RaidIcon_List'][spellID]['Data']) do
						userName = Table['Inspect_Cache'][userGUID]['Name']
						RemainCooltime = Table['Cooldown_Cache'][userGUID] and Table['Cooldown_Cache'][userGUID]['List'][spellID] and Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow or nil
						if RemainCooltime and RemainCooltime <= 0 then
							KF:RaidCooldown_RefreshCooldownBarData()
						end
						if Icon.DisplayTooltip then GameTooltip:AddDoubleLine(' '..Func['GetRoleIcon'](userGUID)..' '..(UnitIsDeadOrGhost(userName) and '|cff778899'..userName..' ('..DEAD..')' or KF:Color_Class(Table['Inspect_Cache'][userGUID]['Class'], userName)), RemainCooltime and '|cffb90624'..Func['TimeFormat'](RemainCooltime) or '|cff2eb7e4'..L['Enable To Cast'], 1, 1, 1, 1, 1, 1) end
					end
					
					if Icon.DisplayTooltip then GameTooltip:Show() end
				end,
			}
			return Icon
		end
		
		
		Func['RaidIcon_UpdateAppearance'] = function()
			local spellID
			
			for IconNumber = 1, #Table['RaidIcon_LinkByNumber'] do
				spellID = Table['RaidIcon_LinkByNumber'][IconNumber]
				
				--RaidIcon : Size, Spacing, StartPoint, Direction
				Table['RaidIcon_List'][spellID]:Size(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Size)
				Table['RaidIcon_List'][spellID]:ClearAllPoints()
				if IconNumber == 1 then
					if KnightRaidCooldown.Brez:IsShown() then
						if KF.db.Modules.SmartTracker.Appearance.RaidIcon_StartPoint == 2 then
							if KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 1 then
								Table['RaidIcon_List'][spellID]:Point('BOTTOMLEFT', KnightRaidCooldown.Brez, 'TOPLEFT', 0, KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing)
							elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 2 then
								Table['RaidIcon_List'][spellID]:Point('TOPLEFT', KnightRaidCooldown.Brez, 'BOTTOMLEFT', 0, -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing))
							elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 4 then
								Table['RaidIcon_List'][spellID]:Point('TOPRIGHT', KnightRaidCooldown.Brez, 'TOPLEFT', -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing), 0)
							else --Default is 3(UPPER of MainFrame)
								Table['RaidIcon_List'][spellID]:Point('BOTTOMRIGHT', KnightRaidCooldown.Brez, 'BOTTOMLEFT', -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing), 0)
							end
						else --Default Location is 1(LEFTSIDE of MainFrame)
							if KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 1 then
								Table['RaidIcon_List'][spellID]:Point('BOTTOMRIGHT', KnightRaidCooldown.Brez, 'TOPRIGHT', 0, KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing)
							elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 2 then
								Table['RaidIcon_List'][spellID]:Point('TOPRIGHT', KnightRaidCooldown.Brez, 'BOTTOMRIGHT', 0, -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing))
							elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 4 then
								Table['RaidIcon_List'][spellID]:Point('TOPLEFT', KnightRaidCooldown.Brez, 'TOPRIGHT', KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing, 0)
							else --Default is 3(UPPER of MainFrame)
								Table['RaidIcon_List'][spellID]:Point('BOTTOMLEFT', KnightRaidCooldown.Brez, 'BOTTOMRIGHT', KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing, 0)
							end
						end
					else
						Table['RaidIcon_List'][spellID]:Point('CENTER', KnightRaidCooldown.Brez)
					end
				else
					if KF.db.Modules.SmartTracker.Appearance.RaidIcon_StartPoint == 2 then
						if KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 1 then
							Table['RaidIcon_List'][spellID]:Point('BOTTOMLEFT', Table['RaidIcon_List'][Table['RaidIcon_LinkByNumber'][IconNumber - 1]], 'TOPLEFT', 0, KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing)
						elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 2 then
							Table['RaidIcon_List'][spellID]:Point('TOPLEFT', Table['RaidIcon_List'][Table['RaidIcon_LinkByNumber'][IconNumber - 1]], 'BOTTOMLEFT', 0, -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing))
						elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 4 then
							Table['RaidIcon_List'][spellID]:Point('TOPRIGHT', Table['RaidIcon_List'][Table['RaidIcon_LinkByNumber'][IconNumber - 1]], 'TOPLEFT', -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing), 0)
						else --Default is 3(UPPER of MainFrame)
							Table['RaidIcon_List'][spellID]:Point('BOTTOMRIGHT', Table['RaidIcon_List'][Table['RaidIcon_LinkByNumber'][IconNumber - 1]], 'BOTTOMLEFT', -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing), 0)
						end
					else --Default Location is 1(LEFTSIDE of MainFrame)
						if KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 1 then
							Table['RaidIcon_List'][spellID]:Point('BOTTOMRIGHT', Table['RaidIcon_List'][Table['RaidIcon_LinkByNumber'][IconNumber - 1]], 'TOPRIGHT', 0, KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing)
						elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 2 then
							Table['RaidIcon_List'][spellID]:Point('TOPRIGHT', Table['RaidIcon_List'][Table['RaidIcon_LinkByNumber'][IconNumber - 1]], 'BOTTOMRIGHT', 0, -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing))
						elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 4 then
							Table['RaidIcon_List'][spellID]:Point('TOPLEFT', Table['RaidIcon_List'][Table['RaidIcon_LinkByNumber'][IconNumber - 1]], 'TOPRIGHT', KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing, 0)
						else --Default is 3(UPPER of MainFrame)
							Table['RaidIcon_List'][spellID]:Point('BOTTOMLEFT', Table['RaidIcon_List'][Table['RaidIcon_LinkByNumber'][IconNumber - 1]], 'BOTTOMRIGHT', KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing, 0)
						end
					end
				end

				--RaidIcon : FontSize
				Table['RaidIcon_List'][spellID].text:SetFont(Table['RaidIcon_List'][spellID].text:GetFont(), KF.db.Modules.SmartTracker.Appearance.RaidIcon_Fontsize, 'OUTLINE')
			end
			
			--BrezIcon : Size, Spacing, StartPoint, Direction
			KnightRaidCooldown.Brez:Size(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Size)
			KnightRaidCooldown.BrezIconFrame:Size(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Size - 8)
			KnightRaidCooldown.Brez:ClearAllPoints()
			if KF.db.Modules.SmartTracker.Appearance.RaidIcon_StartPoint == 2 then
				if KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 1 then
					KnightRaidCooldown.Brez:Point('BOTTOMLEFT', KnightRaidCooldown.Tab, 'TOPRIGHT', KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing, KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing)
				elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 2 then
					KnightRaidCooldown.Brez:Point('TOPLEFT', KnightRaidCooldown.Tab, 'BOTTOMRIGHT', KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing, -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing))
				elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 4 then
					KnightRaidCooldown.Brez:Point('TOPRIGHT', KnightRaidCooldown.Tab, 'BOTTOMRIGHT', 0, -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing))
				else --Default is 3(UPPER of MainFrame)
					KnightRaidCooldown.Brez:Point('BOTTOMRIGHT', KnightRaidCooldown.Tab, 'TOPRIGHT', 0, KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing)
				end
			else --Default Location is 1(LEFTSIDE of MainFrame)
				if KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 1 then
					KnightRaidCooldown.Brez:Point('BOTTOMRIGHT', KnightRaidCooldown.Tab, 'TOPLEFT', -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing), KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing)
				elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 2 then
					KnightRaidCooldown.Brez:Point('TOPRIGHT', KnightRaidCooldown.Tab, 'BOTTOMLEFT', -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing), -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing))
				elseif  KF.db.Modules.SmartTracker.Appearance.RaidIcon_Direction == 4 then
					KnightRaidCooldown.Brez:Point('TOPLEFT', KnightRaidCooldown.Tab, 'BOTTOMLEFT', 0, -(KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing))
				else --Default is 3(UPPER of MainFrame)
					KnightRaidCooldown.Brez:Point('BOTTOMLEFT', KnightRaidCooldown.Tab, 'TOPLEFT', 0, KF.db.Modules.SmartTracker.Appearance.RaidIcon_Spacing)
				end
			end
			
			--BrezIcon : Fontsize
			KnightRaidCooldown.BrezNum:SetFont(KnightRaidCooldown.BrezNum:GetFont(), KF.db.Modules.SmartTracker.Appearance.RaidIcon_Fontsize, 'OUTLINE')
		end
		
		
		function KF:RaidCooldown_SettingRaidIcon()
			--Clear Cache
			for spellID in pairs(Table['RaidIcon_List']) do
				Table['RaidIcon_List'][spellID]['Data'] = nil
				Table['RaidIcon_List'][spellID]:Hide()
			end
			KnightRaidCooldown.Brez['Data'] = {}
			KnightRaidCooldown.Brez:Hide()
			
			Value['IsRaidIconShow'] = false
			
			if KF.CurrentGroupMode ~= 'NoGroup' then
				_, Value['CurrentInstance_Type'] = IsInInstance()
				
				local hasData = {}
				local userClass, userLevel, linkNumber
				for userGUID in pairs(Table['Inspect_Cache']) do
					userClass = Table['Inspect_Cache'][userGUID]['Class']
					userLevel = Table['Inspect_Cache'][userGUID]['Level']
					
					for spellID, Conditions in pairs(KF.db.Modules.SmartTracker.RaidIcon) do
						if type(Conditions) == 'table' and not ((Conditions.Class and Conditions.Class ~= userClass) or
								(Conditions.Level and Conditions.Level > userLevel) or
								(Conditions.Spec and Conditions.Spec ~= Table['Inspect_Cache'][userGUID]['Specialization']) or
								(Conditions.Talent and not Table['Inspect_Cache'][userGUID]['Talent'][Conditions.Talent])) then
							
							if not Table['RaidIcon_List'][spellID] then
								Func['RaidIcon_Create'](spellID)
							end
							
							if not Table['RaidIcon_List'][spellID]['Data'] then
								Table['RaidIcon_List'][spellID]['Data'] = {}
							end
							
							if not Table['RaidIcon_LinkBySpellID'][spellID] then
								linkNumber = #Table['RaidIcon_LinkByNumber'] + 1
								
								Table['RaidIcon_LinkBySpellID'][spellID] = linkNumber
								Table['RaidIcon_LinkByNumber'][linkNumber] = spellID
							end
							
							hasData[spellID] = true
							Value['IsRaidIconShow'] = true
							
							Table['RaidIcon_List'][spellID]:Show()
							Table['RaidIcon_List'][spellID]['Data'][#Table['RaidIcon_List'][spellID]['Data'] + 1] = userGUID
						end
					end
					
					for spellID, Conditions in pairs(Table['BattleResurrection']) do
						if not ((Conditions.Class and Conditions.Class ~= userClass) or
								(Conditions.Level and Conditions.Level > userLevel) or
								(Conditions.Spec and Conditions.Spec ~= Table['Inspect_Cache'][userGUID]['Specialization']) or
								(Conditions.Talent and not Table['Inspect_Cache'][userGUID]['Talent'][Conditions.Talent])) then
							
							KnightRaidCooldown.Brez['Data'][userGUID] = spellID
							
							if not (Value['CurrentInstance_Type'] == 'pvp' or Value['CurrentInstance_Type'] == 'arena') then
								Value['IsRaidIconShow'] = true
								KnightRaidCooldown.Brez:Show()
							end
						end
					end
				end
				
				local spellID
				for i = 1, #Table['RaidIcon_LinkByNumber'] do
					spellID = Table['RaidIcon_LinkByNumber'][i]
					
					if spellID and not hasData[spellID] then
						Table['RaidIcon_LinkBySpellID'][spellID] = nil
						
						for k = i + 1, #Table['RaidIcon_LinkByNumber'] do
							Table['RaidIcon_LinkByNumber'][k - 1] = Table['RaidIcon_LinkByNumber'][k]
						end
						Table['RaidIcon_LinkByNumber'][#Table['RaidIcon_LinkByNumber']] = nil
						
					end
				end
				
				Func['RaidIcon_UpdateAppearance']()
			else
				Table['RaidIcon_LinkBySpellID'] = {}
				Table['RaidIcon_LinkByNumber'] = {}
			end
			
			KF:RaidCooldown_RefreshCooldownBarData()
		end
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : System									]--
	-----------------------------------------------------------
	do
		Func['RegisterCooldown'] = function(eventType, userGUID, userClass, userName, spellID, destGUID, destColor, destName)
			if Table['Cooldown_Cache'][userGUID] then
				if spellID == 11958 then --매서운 한파
					if Table['Cooldown_Cache'][userGUID]['List'][45438] then Table['Cooldown_Cache'][userGUID]['List'][45438]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][122] then Table['Cooldown_Cache'][userGUID]['List'][122]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][120] then Table['Cooldown_Cache'][userGUID]['List'][120]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
				elseif spellID == 23989 then --만반의 준비
					for spell in pairs(Table['Cooldown_Cache'][userGUID]['List']) do
						if KF.Table['RaidCooldownSpell'][userClass][spell][1] < 300 then Table['Cooldown_Cache'][userGUID]['List'][spell]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					end
				elseif spellID == 14185 then --마음가짐
					if Table['Cooldown_Cache'][userGUID]['List'][2983] then Table['Cooldown_Cache'][userGUID]['List'][2983]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][1856] then Table['Cooldown_Cache'][userGUID]['List'][1856]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][180] then Table['Cooldown_Cache'][userGUID]['List'][180]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][51722] then Table['Cooldown_Cache'][userGUID]['List'][51722]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
				elseif spellID == 108285 then --원소의 부름
					if Table['Cooldown_Cache'][userGUID]['List'][8143] then Table['Cooldown_Cache'][userGUID]['List'][8143]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][51485] then Table['Cooldown_Cache'][userGUID]['List'][51485]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][108273] then Table['Cooldown_Cache'][userGUID]['List'][108273]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][2484] then Table['Cooldown_Cache'][userGUID]['List'][2484]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][108269] then Table['Cooldown_Cache'][userGUID]['List'][108269]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][108279] then Table['Cooldown_Cache'][userGUID]['List'][108279]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][8177] then Table['Cooldown_Cache'][userGUID]['List'][8177]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
					if Table['Cooldown_Cache'][userGUID]['List'][108270] then Table['Cooldown_Cache'][userGUID]['List'][108270]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, } end
				end
			end
			
			if eventType == 'SPELL_RESURRECT' and NowBossBattle then
				Table['BattleResurrection_CastMember'][#Table['BattleResurrection_CastMember'] + 1] = { ['userGUID'] = userGUID, ['userClass'] = userClass, ['userName'] = userName, ['destGUID'] = destGUID, ['destColor'] = destColor, ['destName'] = destName, }
			end
			
			if not KF.db.Modules.SmartTracker.RaidIcon[spellID] and not Table['BattleResurrection'][spellID] and (not KF.db.Modules.SmartTracker[userClass] or not KF.db.Modules.SmartTracker[userClass][spellID] or KF.db.Modules.SmartTracker[userClass][spellID] == '0') then
				return
			elseif not Table['Cooldown_Cache'][userGUID] then
				Table['Cooldown_Cache'][userGUID] = {
					['Name'] = userName,
					['Class'] = userClass,
					['List'] = {},
				}
			end
			
			if not Table['Cooldown_Cache'][userGUID]['List'][spellID] then
				Table['Cooldown_Cache'][userGUID]['List'][spellID] = {
					['Display'] = function()
						if KF.db.Modules.SmartTracker[userClass] and KF.db.Modules.SmartTracker[userClass][spellID] == 1 then
							return NowBossBattle and 'InCombat' or true
						elseif KF.db.Modules.SmartTracker[userClass] and KF.db.Modules.SmartTracker[userClass][spellID] and KF.db.Modules.SmartTracker[userClass][spellID] ~= 0 then
							return true
						elseif KF.db.Modules.SmartTracker.RaidIcon[spellID] then
							return 'RaidIcon'
						end
					end,
					['Fade'] = { ['FadeType'] = 'IN', },
				}
			elseif Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + 0.5 > KF.TimeNow then -- because combat log check more than 1 time, so it needs to forbid just one.
				return
			elseif Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] then
				Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] = { ['FadeType'] = 'IN', }
			end
			
			Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'], Table['Cooldown_Cache'][userGUID]['List'][spellID]['NeedCalculating'] = Func['CalcCooldown'](event, userGUID, userName, userClass, spellID, destName)
			if eventType == 'SPELL_INTERRUPT' then Table['Cooldown_Cache'][userGUID]['List'][spellID]['Event'] = eventType end
			
			if (Table['Cooldown_Cache'][userGUID]['Class'] == 'PALADIN' and (spellID == 1022 or spellID == 6940 or spellID == 1044 or spellID == 1038) and (Table['Inspect_Cache'][userGUID] and Table['Inspect_Cache'][userGUID]['Talent'][12] == true)) or (Table['Cooldown_Cache'][userGUID]['Class'] == 'HUNTER' and spellID == 148467) then
				if Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName'] then
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime2'] = Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime']
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor2'] = destColor
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName2'] = destName
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['Chargy'] = true
				else
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor'] = destColor
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName'] = destName
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = KF.TimeNow
				end
			elseif KF.Table['RaidCooldownSpell'][userClass][spellID][2] == true then
				-- Save target name if system can display destname
				Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestColor'] = destColor
				Table['Cooldown_Cache'][userGUID]['List'][spellID]['DestName'] = destName
				Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = KF.TimeNow
			else
				Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = KF.TimeNow
			end
			
			Value['RefreshCooldown'] = true
			KF:RaidCooldown_RefreshCooldownBarData()
		end
		
		
		KF:RegisterEventList('UNIT_SPELLCAST_SUCCEEDED', function(...)
			local _, unitType, _, _, _, spellID = ...
			local userName = UnitName(unitType)
			
			if not UnitIsPlayer(unitType) or UnitIsEnemy('player', unitType) then
				return
			elseif KF.db.Modules.SmartTracker.Scan.CheckChanging == true and (spellID == 63644 or spellID == 63645 or spellID == 113873 or spellID == 111621) then
				--Change Specialization or talent or glyph
				Table['Inspect_InspectOrder'][userName] = nil
				Table['Inspect_InspectDelayed'][userName] = nil
				
				if not KF.Update['RaidCooldownInspect']['Condition']() then
					Value['Inspect_ScanByChanging'] = true
					KF.Update['CheckGroupMembersNumber']['Condition'] = true
				end
			end
			
			if (spellID ~= 59752 and spellID ~= 86659 and spellID ~= 86669 and spellID ~= 86698 and spellID ~= 32375) then return end
			
			local userGUID = UnitGUID(unitType)
			local _, userClass = UnitClass(unitType)
			
			if KF.Table['RaidCooldownSpell'][userClass] and userName and userGUID then
				spellID = Table['ConvertSpellID'][spellID] or spellID
				
				if spellID and KF.Table['RaidCooldownSpell'][userClass][spellID] then
					Func['RegisterCooldown']('SPELL_CAST_SUCCESS', userGUID, userClass, userName, spellID, nil, nil)
				end
			end
		end)
		
		KF:RegisterEventList('COMBAT_LOG_EVENT_UNFILTERED', function(...)
			local _, _, eventType, _, userGUID, userName, userFlag, _, destGUID, destName, destFlag, _, spellID = ...
			
			if bit.band(userFlag, (COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE)) == 0 or
				(eventType ~= 'SPELL_RESURRECT' and eventType ~= 'SPELL_AURA_APPLIED' and eventType ~= 'SPELL_AURA_REFRESH' and eventType ~= 'SPELL_CAST_SUCCESS' and eventType ~= 'SPELL_INTERRUPT' and eventType ~= 'SPELL_SUMMON') then return end
			
			local userClass
			if userName then
				if not UnitIsPlayer(userName) then -- find pet master
					if UnitName('pet') == userName then
						userName = E.myname
						userGUID = E.myguid or UnitGUID('player')
					elseif KF.CurrentGroupMode ~= 'NoGroup' then
						if IsInRaid() and not UnitPlayerOrPetInRaid(userName) then return
						elseif IsInGroup() and not UnitPlayerOrPetInParty(userName) then return	end
						for i = 1, MAX_RAID_MEMBERS do
							if UnitExists(KF.CurrentGroupMode..i..'pet') and UnitIsUnit(userName, KF.CurrentGroupMode..i..'pet') then
								userName = UnitName(KF.CurrentGroupMode..i)
								userGUID = UnitGUID(KF.CurrentGroupMode..i)
							end
						end
					end
				end
				if not UnitIsPlayer(userName) then return end
				_, userClass = UnitClass(userName)
			end
			
			local destColor
			if destName then
				if GetPlayerInfoByGUID(destGUID) then
					if destName:find('-') then destName = string.split('-', destName) end
					_, destColor = GetPlayerInfoByGUID(destGUID)
					destColor = KF:Color_Class(destColor)
				else
					destFlag = bit.band(destFlag, COMBATLOG_OBJECT_REACTION_MASK)
					if destFlag == 16 then
						destColor = '|cff20ff20' --friendly
					else
						destColor = '|cffcd4c37' --hostile
					end
				end
			end
			
			if KF.Table['RaidCooldownSpell'][userClass] and userName and userGUID then
				spellID = Table['ConvertSpellID'][spellID] or spellID
				
				if spellID and KF.Table['RaidCooldownSpell'][userClass][spellID] then
					if userName:find('-') then userName = string.split('-', userName) end
					
					Func['RegisterCooldown'](eventType, userGUID, userClass, userName, spellID, destGUID, destColor, destName)
				end
			end
		end)
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : Inspect for calculating exact cooldown	]--
	-----------------------------------------------------------
	do
		local function CheckPlayerTalent()
			local myGUID = E.myguid or UnitGUID('player')
			
			if myGUID then
				E.myguid = myGUID
				
				--Player Info
				if not Table['Inspect_Cache'][myGUID] then
					Table['Inspect_Cache'][myGUID] = {
						['Name'] = E.myname,
						['Class'] = E.myclass,
						['Glyph'] = {},
						['Talent'] = {},
					}
				end
				Table['Inspect_Cache'][myGUID]['Level'] = UnitLevel('player')
				
				--Specialization
				local Spec = GetSpecialization()
				if Spec ~= nil and Spec > 0 then
					_, Spec = GetSpecializationInfo(Spec)
					if Spec ~= nil then Table['Inspect_Cache'][myGUID]['Specialization'] = Spec end
				else
					Table['Inspect_Cache'][myGUID]['Specialization'] = nil
				end
				
				--Talent
				for i = 1, 18 do
					local _, _, _, _, isSelected = GetTalentInfo(i)
					if isSelected == true then
						Table['Inspect_Cache'][myGUID]['Talent'][i] = true
					else
						Table['Inspect_Cache'][myGUID]['Talent'][i] = nil
					end
				end
				
				--Glyph
				for i = 1, 6 do
					_, _, _, Table['Inspect_Cache'][myGUID]['Glyph'][i] = GetGlyphSocketInfo(i)
				end
				
				KF:RaidCooldown_SettingRaidIcon()
			end
		end
		KF:RegisterEventList('ACTIVE_TALENT_GROUP_CHANGED', CheckPlayerTalent)
		KF:RegisterEventList('PLAYER_TALENT_UPDATE', CheckPlayerTalent)
		KF:RegisterEventList('CHARACTER_POINTS_CHANGED', CheckPlayerTalent)
		KF:RegisterEventList('GLYPH_UPDATED', CheckPlayerTalent)
		
		
		KF:RegisterEventList('INSPECT_READY', function(_, userGUID)
			if Value['InspectingUnitGUID'] and Value['InspectingUnitGUID'] == userGUID then
				Value['InspectingUnitGUID'] = nil
			end
			
			if KF.CurrentGroupMode == 'NoGroup' then return end
			
			local _, userClass, _, _, _, userName = GetPlayerInfoByGUID(userGUID)
			
			if userName == E.myname or not UnitExists(userName) or (Table['Inspect_InspectOrder'][userName] == nil and Table['Inspect_InspectDelayed'][userName] == nil) then return end
			
			if not Table['Inspect_Cache'][userGUID] then
				Table['Inspect_Cache'][userGUID] = {
					['Name'] = userName,
					['Class'] = userClass,
					['Glyph'] = {},
					['Talent'] = {},
				}
			end
			
			local userSpec = GetInspectSpecialization(userName)
			if userSpec ~= nil and userSpec > 0 then
				_, userSpec = GetSpecializationInfoByID(userSpec)
				if userSpec ~= nil then Table['Inspect_Cache'][userGUID]['Specialization'] = userSpec end
			else
				Table['Inspect_Cache'][userGUID]['Specialization'] = nil
			end
			
			for i = 1, 6 do
				_, _, _, Table['Inspect_Cache'][userGUID]['Glyph'][i] = GetGlyphSocketInfo(i, nil, true, userName)
			end
			
			_, _, userClass = UnitClass(userName) --convert Class to ClassID
			for i = 1, 18 do
				local _, _, _, _, isSelected = GetTalentInfo(i, true, nil, userName, userClass)
				if isSelected == true then
					Table['Inspect_Cache'][userGUID]['Talent'][i] = true
				else
					Table['Inspect_Cache'][userGUID]['Talent'][i] = nil
				end
			end
			Table['Inspect_Cache'][userGUID]['Level'] = UnitLevel(userName)
			
			KF:RaidCooldown_SettingRaidIcon()
			
			local PrevInspectType = Value['CurrentInspectType']
			if Table['Inspect_InspectOrder'][userName] ~= true or (Table['Inspect_UpdateOrder'][userName] ~= nil or Table['Inspect_UpdateDelayed'][userName] ~= nil) then
				Table['Inspect_InspectOrder'][userName] = true
				Table['Inspect_InspectDelayed'][userName] = nil
				Table['Inspect_UpdateOrder'][userName] = nil
				Table['Inspect_UpdateDelayed'][userName] = nil
			end
			
			local NowInspecting, NeedInspecting, NeedUpdating = KF.Update['RaidCooldownInspect']['Action'](nil, true)
			if Value['ActiveGroupMemberInspect'] ~= nil and NeedInspecting == 0 then
				if not NowInspecting and NeedUpdating == 0 then
					local userGUID
					for i = 1, MAX_RAID_MEMBERS do
						userGUID = UnitGUID(KF.CurrentGroupMode..i)
						
						if userGUID and (not Table['Inspect_Cache'][userGUID] or not Table['Inspect_Cache'][userGUID]['Specialization']) then
							Table['Inspect_UpdateOrder'][UnitName(KF.CurrentGroupMode..i)] = 0
							NowInspecting = true
						end
					end
					
					if NowInspecting and PrevInspectType ~= 'NeedUpdating' then
						Value['ActiveGroupMemberInspect'] = true
						print(L['KF']..' : '..L["Updating old member's setting."])
					elseif not NowInspecting then
						Value['ActiveGroupMemberInspect'] = nil
						KnightRaidCooldown.Tab.text:SetText('|cff2eb7e4'..Default['MainFrame_Tab_AddOnName'])
						
						if Value['Inspect_ScanByChanging'] == true then
							Value['Inspect_ScanByChanging'] = nil
						else
							print(L['KF']..' : |cff2eb7e4'..L['Inspect Complete']..'|r. '..L["All members specialization, talent setting, glyph setting is saved. RaidCooldown will calcurating each spell's cooltime by this data.|r"])
						end
					end
				elseif Value['ActiveGroupMemberInspect'] ~= nil and NowInspecting == 'NeedUpdating' and PrevInspectType == 'NeedInspecting' then
					print(L['KF']..' : '..L["Updating old member's setting."])
				end
			end
		end)
		
		
		hooksecurefunc('NotifyInspect', function(Unit)
			Value['InspectingUnitGUID'] = UnitGUID(Unit)
		end)
		
		
		local NeedInspecting, NeedUpdating, InspectType, DoInspect
		KF.Update['RaidCooldownInspect'] = {
			['Condition'] = function()
				if Value['ActiveGroupMemberInspect'] and not (KF.Update['NotifyInspect'] and KF.Update['NotifyInspect']['Condition'] == true) then
					return true
				end
			end,
			['Delay'] = 0.5,
			['Action'] = function(_, HoldInspecting)
				NeedInspecting = 0	--Number of Need Inspecting
				NeedUpdating = 0	--Number of Need Updating
				InspectType = nil
				DoInspect = nil
				
				for MemberName in pairs(Table['Inspect_InspectOrder']) do
					if not UnitExists(MemberName) then
						Table['Inspect_UpdateDelayed'][MemberName] = nil
						Table['Inspect_UpdateOrder'][MemberName] = nil
						Table['Inspect_InspectDelayed'][MemberName] = nil
						Table['Inspect_InspectOrder'][MemberName] = nil
					elseif Table['Inspect_InspectOrder'][MemberName] ~= true then
						InspectType = 'NeedInspecting'
						
						if (not CanInspect(MemberName) or Table['Inspect_InspectOrder'][MemberName] >= 3) then
							Table['Inspect_InspectDelayed'][MemberName] = 0
							Table['Inspect_InspectOrder'][MemberName] = nil
							Value['InspectDelayedMemberExists'] = true
						else
							NeedInspecting = NeedInspecting + 1
							
							if not DoInspect and CanInspect(MemberName) then
								DoInspect = true
								Table['Inspect_InspectOrder'][MemberName] = Table['Inspect_InspectOrder'][MemberName] + 1
								Value['ActiveGroupMemberInspect'] = MemberName
							end
						end
					end
				end
				
				for _ in pairs(Table['Inspect_InspectDelayed']) do
					NeedInspecting = NeedInspecting + 1
				end
				
				if not DoInspect and Value['InspectDelayedMemberExists'] then
					E:CopyTable(Table['Inspect_InspectOrder'], Table['Inspect_InspectDelayed'])
					Table['Inspect_InspectDelayed'] = {}
					Value['InspectDelayedMemberExists'] = nil
				end
				
				if NeedInspecting == 0 and KF.db.Modules.SmartTracker.Scan.Update ~= false and not DoInspect then
					for MemberName in pairs(Table['Inspect_UpdateOrder']) do
						InspectType = 'NeedUpdating'
						
						if not CanInspect(MemberName) or Table['Inspect_UpdateOrder'][MemberName] >= 3 then
							Table['Inspect_UpdateDelayed'][MemberName] = 0
							Table['Inspect_UpdateOrder'][MemberName] = nil
							Value['UpdateDelayedMemberExists'] = true
						else
							NeedUpdating = NeedUpdating + 1
							
							if not DoInspect and CanInspect(MemberName) then
								DoInspect = true
								Table['Inspect_UpdateOrder'][MemberName] = Table['Inspect_UpdateOrder'][MemberName] + 1
								Value['ActiveGroupMemberInspect'] = MemberName
							end
						end
					end
					
					for _ in pairs(Table['Inspect_UpdateDelayed']) do
						NeedUpdating = NeedUpdating + 1
					end
					
					if not DoInspect and Value['UpdateDelayedMemberExists'] then
						E:CopyTable(Table['Inspect_UpdateOrder'], Table['Inspect_UpdateDelayed'])
						Table['Inspect_UpdateDelayed'] = {}
						Value['UpdateDelayedMemberExists'] = nil
					end
				end
				
				if NeedUpdating > 0 then
					KnightRaidCooldown.InspectMembers.Number:SetText('|cffceff00'..NeedUpdating)
				elseif NeedInspecting > 0 then
					KnightRaidCooldown.InspectMembers.Number:SetText('|cff2eb7e4'..NeedInspecting)
				elseif NeedInspecting == 0 and NeedUpdating == 0 then
					KnightRaidCooldown.InspectMembers.Number:SetText(nil)
					
					if Value['ActiveGroupMemberInspect'] ~= nil and not UnitExists(Value['ActiveGroupMemberInspect']) then
						Value['ActiveGroupMemberInspect'] = nil
						KnightRaidCooldown.Tab.text:SetText('|cff2eb7e4'..Default['MainFrame_Tab_AddOnName'])
						
						if Value['Inspect_ScanByChanging'] == true then
							Value['Inspect_ScanByChanging'] = nil
						else
							print(L['KF']..' : |cff2eb7e4'..L['Inspect Complete']..'|r. '..L["All members specialization, talent setting, glyph setting is saved. RaidCooldown will calcurating each spell's cooltime by this data.|r"])
						end
					end
				end
				
				if Value['InspectingUnitGUID'] then
					return InspectType, NeedInspecting, NeedUpdating
				elseif DoInspect and Value['ActiveGroupMemberInspect'] and not HoldInspecting then
					NotifyInspect(Value['ActiveGroupMemberInspect'])
				end
				
				Value['CurrentInspectType'] = InspectType
				return InspectType, NeedInspecting, NeedUpdating
			end,
		}
		
		
		--[[
		function TT:Inspect_OnUpdate(elapsed)
			self.nextUpdate = (self.nextUpdate - elapsed);
			if (self.nextUpdate <= 0) then
				self:Hide();
				if UnitGUID('mouseover') == TT.currentGUID and not TT:IsInspectFrameOpen() and not (KF.Update['NotifyInspect'] and KF.Update['NotifyInspect']['Condition'] == true) and KF.Update['RaidCooldownInspect']['Condition']() == nil then
					TT.lastGUID = TT.currentGUID
					TT.lastInspectRequest = KF.TimeNow;
					TT:RegisterEvent('INSPECT_READY');
					BlizzardNotifyInspect(TT.currentUnit);
				end
			end
		end
		]]
		
		-- calculate number of inspect member and order inspect after calculating
		local SavedNeedInspecting, GroupMemberCount = 0, 0
		KF.Update['CheckGroupMembersNumber'] = {
			['Condition'] = false,
			['Delay'] = 0,
			['Action'] = function()
				for MemberName in pairs(Table['Inspect_InspectOrder']) do
					if not UnitExists(MemberName) then
						Table['Inspect_UpdateDelayed'][MemberName] = nil
						Table['Inspect_UpdateOrder'][MemberName] = nil
						Table['Inspect_InspectDelayed'][MemberName] = nil
						Table['Inspect_InspectOrder'][MemberName] = nil
					end
				end
				
				for MemberName in pairs(Table['Inspect_InspectDelayed']) do
					if not UnitExists(MemberName) then
						Table['Inspect_UpdateDelayed'][MemberName] = nil
						Table['Inspect_UpdateOrder'][MemberName] = nil
						Table['Inspect_InspectDelayed'][MemberName] = nil
						Table['Inspect_InspectOrder'][MemberName] = nil
					end
				end
				
				local Old_NeedInspecting = SavedNeedInspecting
				SavedNeedInspecting = 0
				
				local AlreadyChecked = 0
				local NeedUpdatingMemberTable = {}
				local Check = nil
				local isFirst = nil
				
				local MemberName
				
				for i = 1, MAX_RAID_MEMBERS do
					if UnitExists(KF.CurrentGroupMode..i) and not UnitIsUnit(KF.CurrentGroupMode..i, 'player') then
						MemberName = UnitName(KF.CurrentGroupMode..i)
						if MemberName then
							if MemberName == UNKNOWNOBJECT then
								SavedNeedInspecting = SavedNeedInspecting - MAX_RAID_MEMBERS
							elseif Table['Inspect_InspectOrder'][MemberName] == true then
								AlreadyChecked = AlreadyChecked + 1
								
								if KF.db.Modules.SmartTracker.Scan.Update ~= false and Table['Inspect_UpdateOrder'][MemberName] == nil and Table['Inspect_UpdateDelayed'][MemberName] == nil then
									NeedUpdatingMemberTable[MemberName] = 0
								end
							else
								SavedNeedInspecting = SavedNeedInspecting + 1
								
								if Table['Inspect_InspectOrder'][MemberName] == nil and Table['Inspect_InspectDelayed'][MemberName] == nil then
									isFirst = true
									Table['Inspect_InspectOrder'][MemberName] = 0
								end
								
								Check = 'NeedInspecting'
							end
						else
							SavedNeedInspecting = SavedNeedInspecting - MAX_RAID_MEMBERS
						end
					end
				end
				
				if SavedNeedInspecting + AlreadyChecked ~= GroupMemberCount - 1 then
					return
				end
				
				if Check == 'NeedInspecting' then
					if KF.db.Modules.SmartTracker.Scan.AutoScanning ~= false or Value['ForceInspect'] == true then
						if isFirst and not Value['Inspect_ScanByChanging'] and not (Old_NeedInspecting and Old_NeedInspecting >= SavedNeedInspecting) then print(L['KF']..' : |cffceff00'..SavedNeedInspecting..'|r members Check Start.') end
						
						if KF.db.Modules.SmartTracker.Scan.Update ~= false then
							E:CopyTable(Table['Inspect_UpdateOrder'], NeedUpdatingMemberTable)
						else
							Table['Inspect_UpdateDelayed'] = {}
							Table['Inspect_UpdateOrder'] = {}
						end
						
						Value['ForceInspect'] = nil
						Value['ActiveGroupMemberInspect'] = true
					else
						KnightRaidCooldown.Tab.text:SetText('|cffff0000'..Default['MainFrame_Tab_AddOnName'])
					end
				end
				
				KF.Update['CheckGroupMembersNumber']['Condition'] = false
			end,
		}
		
		
		Func['PrepareGroupInspect'] = function(OrderType)
			KF.Event['GROUP_ROSTER_UPDATE']['CheckGroupMode']()
			
			if KF.CurrentGroupMode == 'NoGroup' then
				Table['Inspect_UpdateDelayed'] = {}
				Table['Inspect_UpdateOrder'] = {}
				Table['Inspect_InspectDelayed'] = {}
				Table['Inspect_InspectOrder'] = {}
				Value['ActiveGroupMemberInspect'] = nil
				
				Table['BattleResurrection_CastMember'] = {}
				Table['BattleResurrection_ResurrectedMember'] = {}
				KnightRaidCooldown.Brez['Data'] = {}
				KnightRaidCooldown.Brez:Hide()
				
				Table['Inspect_Cache'] = {}
				CheckPlayerTalent()
				KnightRaidCooldown.Tab.text:SetText('|cff2eb7e4'..Default['MainFrame_Tab_AddOnName'])
				
				GroupMemberCount = 0
				KnightRaidCooldown.InspectMembers:Hide()
				
				if KF.db.Modules.SmartTracker.General.HideWhenSolo ~= false and (KnightRaidCooldown:GetAlpha() == 1 or KnightRaidCooldown:IsShown()) then
					E:UIFrameFadeOut(KnightRaidCooldown, 1)
					KnightRaidCooldown.fadeInfo.finishedFunc = function() KnightRaidCooldown:Hide() end
				end
				
				if KF.db.Modules.SmartTracker.General.EraseWhenUserLeftGroup ~= false then
					E.myguid = E.myguid or UnitGUID('player')
					
					for userGUID in pairs(Table['Cooldown_Cache']) do
						if userGUID ~= E.myguid then
							for spellID in pairs(Table['Cooldown_Cache'][userGUID]['List']) do
								Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, }
							end
						end
					end
				end
				return
			elseif OrderType then
				Value['ForceInspect'] = OrderType
				Table['Inspect_UpdateDelayed'] = {}
				Table['Inspect_UpdateOrder'] = {}
				Table['Inspect_InspectDelayed'] = {}
				Table['Inspect_InspectOrder'] = {}
			end
			
			KnightRaidCooldown.InspectMembers:Show()
			if KnightRaidCooldown:GetAlpha() == 0 or not KnightRaidCooldown:IsShown() then
				KnightRaidCooldown:Show()
				E:UIFrameFadeIn(KnightRaidCooldown, 1)
			end
			
			local MemberName
			for SavedGUID in pairs(Table['Inspect_Cache']) do
				if SavedGUID ~= E.myguid then
					MemberName = Table['Inspect_Cache'][SavedGUID]['Name']
					if not UnitExists(MemberName) then
						Table['Inspect_Cache'][SavedGUID] = nil
						
						Table['Inspect_UpdateDelayed'][MemberName] = nil
						Table['Inspect_UpdateOrder'][MemberName] = nil
						Table['Inspect_InspectDelayed'][MemberName] = nil
						Table['Inspect_InspectOrder'][MemberName] = nil
						
						if KF.db.Modules.SmartTracker.General.EraseWhenUserLeftGroup ~= false and Table['Cooldown_Cache'][SavedGUID] then
							for spellID in pairs(Table['Cooldown_Cache'][SavedGUID]['List']) do
								Table['Cooldown_Cache'][SavedGUID]['List'][spellID]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, }
							end
						end
					end
				end
			end
			
			CheckPlayerTalent()
			
			KF.Update['CheckGroupMembersNumber']['Condition'] = true
			
			KF:RaidCooldown_SettingRaidIcon()
			GroupMemberCount = GetNumGroupMembers()
		end
		KF:RegisterEventList('GROUP_ROSTER_UPDATE', function() Func['PrepareGroupInspect']() end, 'RaidCooldown_PrepareGroupInspect')
		KF:RegisterEventList('READY_CHECK', function() Func['PrepareGroupInspect'](true) end, 'RaidCooldown_PrepareGroupInspect')
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : Initialize RaidCooldown					]--
	-----------------------------------------------------------
	CreateFrame('Frame', 'KnightRaidCooldown', KF.UIParent)
	KnightRaidCooldown:SetMovable(true)
	KnightRaidCooldown:SetClampedToScreen(true)
	KnightRaidCooldown.CurrentWheelLine = 0
	
	
	
	
	KnightRaidCooldown.DisplayArea = CreateFrame('Frame', nil, KnightRaidCooldown)
	KnightRaidCooldown.DisplayArea:SetFrameLevel(2)
	KnightRaidCooldown.DisplayArea:SetBackdrop({
		bgFile = E['media'].blankTex,
		edgeFile = E['media'].blankTex,
		tile = false, tileSize = 0, edgeSize = E.mult,
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	KnightRaidCooldown.DisplayArea:SetBackdropColor(1, 1, 1, 0.2)
	KnightRaidCooldown.DisplayArea:SetBackdropBorderColor(unpack(E['media'].bordercolor))
	KnightRaidCooldown.DisplayArea:EnableMouseWheel()
	KnightRaidCooldown.DisplayArea:SetScript('OnMouseWheel', function(_, spining)
		--마우스 휠을 위로 굴리면 spining 에 1값 리턴, 아래로 굴리면 spining 에 -1값 리턴
		if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then
			if spining == 1 and Value['CooltimeRemainExists'] then
				KnightRaidCooldown.CurrentWheelLine = KnightRaidCooldown.CurrentWheelLine + 1
			elseif spining == -1 and KnightRaidCooldown.CurrentWheelLine > 0 then
				KnightRaidCooldown.CurrentWheelLine = KnightRaidCooldown.CurrentWheelLine - 1
			end
		elseif KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 2 then
			if spining == -1 and Value['CooltimeRemainExists'] then
				KnightRaidCooldown.CurrentWheelLine = KnightRaidCooldown.CurrentWheelLine + 1
			elseif spining == 1 and KnightRaidCooldown.CurrentWheelLine > 0 then
				KnightRaidCooldown.CurrentWheelLine = KnightRaidCooldown.CurrentWheelLine - 1
			end
		end
		KF:RaidCooldown_RefreshCooldownBarData()
	end)
	KF:TextSetting(KnightRaidCooldown.DisplayArea, L['Enable to display']..' : |cff2eb7e4'..Func['DisplayableBarNumber'](), { ['FontSize'] = 11, ['directionH'] = 'RIGHT', })
	
	
	
	
	KnightRaidCooldown.Tab = CreateFrame('Frame', 'KnightRaidCooldownTab', KnightRaidCooldown)
	KnightRaidCooldown.Tab:SetBackdrop({
		bgFile = E['media'].normTex,
		edgeFile = E['media'].blankTex,
		tile = false, tileSize = 0, edgeSize = E.mult,
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	KnightRaidCooldown.Tab:SetBackdropBorderColor(unpack(E['media'].bordercolor))
	KnightRaidCooldown.Tab:SetFrameLevel(3)
	KnightRaidCooldown.Tab:Height(Default['MainFrame_Tab_Height'] - 2)
	KF:TextSetting(KnightRaidCooldown.Tab, '|cff2eb7e4'..Default['MainFrame_Tab_AddOnName'], { ['FontSize'] = 10, ['FontOutline'] = 'OUTLINE', ['directionH'] = 'LEFT', }, 'LEFT', 4, 0)
	KnightRaidCooldown.Tab:SetScript('OnMouseDown', function() if KnightRaidCooldown.DisplayArea:GetAlpha() > 0 then KnightRaidCooldown:StartMoving() end end)
	KnightRaidCooldown.Tab:SetScript('OnMouseUp', function()
		if KnightRaidCooldown.DisplayArea:GetAlpha() > 0 then
			KnightRaidCooldown:StopMovingOrSizing()
			local point, _, secondaryPoint, x, y = KnightRaidCooldown:GetPoint()
			KnightRaidCooldownMover:ClearAllPoints()
			KnightRaidCooldownMover:Point(point, E.UIParent, secondaryPoint, x, y)
			E:SaveMoverPosition('KnightRaidCooldownMover')
			KnightRaidCooldown:ClearAllPoints()
			KnightRaidCooldown:SetPoint(point, KnightRaidCooldownMover, 0, 0)
		end
	end)
	
	
	
	
	KnightRaidCooldown.ResizeGrip = CreateFrame('Frame', nil, KnightRaidCooldown.DisplayArea)
	KnightRaidCooldown.ResizeGrip:Size(16)
	KnightRaidCooldown.ResizeGrip:SetFrameStrata('HIGH')
	KnightRaidCooldown.DisplayArea.texture = KnightRaidCooldown.ResizeGrip:CreateTexture(nil, 'OVERLAY')
	KnightRaidCooldown.DisplayArea.texture:SetInside()
	KnightRaidCooldown.DisplayArea.texture:SetTexCoord(unpack(E.TexCoords))
	KnightRaidCooldown.ResizeGrip:SetScript('OnMouseDown', function()
		if KnightRaidCooldown.DisplayArea:GetAlpha() > 0 then
			KnightRaidCooldown:SetResizable(true)
			local x, y = KnightRaidCooldownMover:GetLeft(), KnightRaidCooldownMover:GetBottom()
			
			KnightRaidCooldownMover:ClearAllPoints()
			if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then
				KnightRaidCooldownMover:Point('BOTTOMLEFT', E.UIParent, x, y)
				KnightRaidCooldown:StartSizing('TOPRIGHT')
			else
				y = -(E.UIParent:GetTop() - KnightRaidCooldownMover:GetTop())
				KnightRaidCooldownMover:Point('TOPLEFT', E.UIParent, x, y)
				KnightRaidCooldown:StartSizing('BOTTOMRIGHT')
			end
		end
	end)
	KnightRaidCooldown.ResizeGrip:SetScript('OnMouseUp', function()
		if KnightRaidCooldown.DisplayArea:GetAlpha() > 0 then
			KnightRaidCooldown:StopMovingOrSizing()
			KnightRaidCooldown:SetResizable(false)
			
			KnightRaidCooldown:ClearAllPoints()
			if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then -- 1 : Up / 2 : Down
				KnightRaidCooldown:Point('BOTTOMLEFT', KnightRaidCooldownMover)
			else
				KnightRaidCooldown:Point('TOPLEFT', KnightRaidCooldownMover)
			end
			E:SaveMoverPosition('KnightRaidCooldownMover')
		end
	end)
	
	
	
	
	KnightRaidCooldown.ToggleDisplay = CreateFrame('Button', nil, KnightRaidCooldown.Tab)
	KnightRaidCooldown.ToggleDisplay:Size(14)
	KnightRaidCooldown.ToggleDisplay:Point('RIGHT', -2, 0)
	KnightRaidCooldown.ToggleDisplay.Texture = KnightRaidCooldown.ToggleDisplay:CreateTexture(nil, 'OVERLAY')
	KnightRaidCooldown.ToggleDisplay.Texture:SetTexCoord(0.25, 0.5, 0, 1)
	KnightRaidCooldown.ToggleDisplay.Texture:SetInside()
	KnightRaidCooldown.ToggleDisplay.Texture:SetTexture('Interface\\Glues\\CharacterSelect\\Glues-AddOn-Icons')
	KnightRaidCooldown.ToggleDisplay:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
		GameTooltip:ClearLines()
		GameTooltip:Point('LEFT', self, 'RIGHT', 0, 0)
		if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then -- 1 : Up / 2 : Down
			if KnightRaidCooldown.DisplayArea:GetAlpha() > 0 then
				GameTooltip:AddLine(L['Lock Display Area.'], 1, 1, 1)
			else
				GameTooltip:AddLine(L['Unlock Display Area.'], 1, 1, 1)
			end
		else
			if KnightRaidCooldown.DisplayArea:GetAlpha() > 0 then
				GameTooltip:AddLine(L['Lock Display Area.'], 1, 1, 1)
			else
				GameTooltip:AddLine(L['Unlock Display Area.'], 1, 1, 1)
			end
		end
		GameTooltip:Show()
	end)
	KnightRaidCooldown.ToggleDisplay:SetScript('OnClick', function(self)
		GameTooltip:Hide()
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
		GameTooltip:Point('LEFT', self, 'RIGHT', 0, 0)
		GameTooltip:ClearLines()
		if KnightRaidCooldown.DisplayArea:GetAlpha() > 0 then
			GameTooltip:AddLine(L['Unlock Display Area.'], 1, 1, 1)
			
			KnightRaidCooldown.DisplayArea:SetAlpha(0)
			KF.db.Modules.SmartTracker.Appearance.Area_Visible = false
			KnightRaidCooldown.ToggleDisplay.Texture:SetTexCoord(0, 0.25, 0, 1)
			print(L['KF']..' : '..L['Lock Display Area.'])
		else
			GameTooltip:AddLine(L['Lock Display Area.'], 1, 1, 1)
			KnightRaidCooldown.DisplayArea:SetAlpha(1)
			KF.db.Modules.SmartTracker.Appearance.Area_Visible = true
			KnightRaidCooldown.ToggleDisplay.Texture:SetTexCoord(0.25, 0.5, 0, 1)
			print(L['KF']..' : '..L['Unlock Display Area.'])
		end
		GameTooltip:Show()
	end)
	KnightRaidCooldown.ToggleDisplay:SetScript('OnLeave', function() GameTooltip:Hide() end)
	
	
	
	
	KnightRaidCooldown.InspectMembers = CreateFrame('Button', nil, KnightRaidCooldown.Tab)
	KnightRaidCooldown.InspectMembers:Size(14)
	KnightRaidCooldown.InspectMembers:Point('RIGHT', KnightRaidCooldown.ToggleDisplay, 'LEFT', 0, 0)
	KnightRaidCooldown.InspectMembers.Texture = KnightRaidCooldown.InspectMembers:CreateTexture(nil, 'OVERLAY')
	KnightRaidCooldown.InspectMembers.Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	KnightRaidCooldown.InspectMembers.Texture:SetInside()
	KnightRaidCooldown.InspectMembers.Texture:SetTexture('Interface\\MINIMAP\\TRACKING\\None')
	KnightRaidCooldown.InspectMembers:Hide()
	KnightRaidCooldown.InspectMembers:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
		
		self:SetScript('OnUpdate', function()
			GameTooltip:ClearLines()
			GameTooltip:Point('LEFT', self, 'RIGHT', 0, 0)
			
			if Value['ActiveGroupMemberInspect'] ~= nil and Value['ActiveGroupMemberInspect'] ~= true then
				GameTooltip:AddLine((Value['ActiveGroupMemberInspect'] == 'NeedUpdating' and '|cffceff00Updating' or '|cff2eb7e4Inspecting')..'|cffffffff : '..KF:Color_Class(select(2, UnitClass(Value['ActiveGroupMemberInspect'])), Value['ActiveGroupMemberInspect']))
			else
				GameTooltip:AddLine(L['Inspect All Members.'], 1, 1, 1)
			end
			GameTooltip:Show()
		end)
	end)
	KnightRaidCooldown.InspectMembers:SetScript('OnClick', function()
		Func['PrepareGroupInspect'](true)
	end)
	KnightRaidCooldown.InspectMembers:SetScript('OnLeave', function(self) self:SetScript('OnUpdate', nil) GameTooltip:Hide() end)
	KnightRaidCooldown.InspectMembers.Number = KnightRaidCooldown.InspectMembers:CreateFontString(nil, 'OVERLAY')
	KnightRaidCooldown.InspectMembers.Number:FontTemplate(nil, 12, 'OUTLINE')
	KnightRaidCooldown.InspectMembers.Number:SetJustifyH('CENTER')
	KnightRaidCooldown.InspectMembers.Number:Point('CENTER', KnightRaidCooldown.InspectMembers, 0, 1)
	
	
	
	
	
	local ResetCooldownMapID = {
		[1136] = true, -- Siege of Orgrimmar
		[1098] = true, -- throne of thunder
		[1009] = true, -- Heart of Fear
		[1008] = true, -- Mogu'shan Vaults
		[996] = true,  -- Terrace of Endless Spring
	}
	local BossFrameCheck, AreaWhenBattleStart, GroupTypeWhenBattleStart, TimeWhenBossFrameIsDown, CurrentMapID
	KF.Update['CheckBossFrameHideTime'] = {
		['Condition'] = false,
		['Delay'] = 0,
		['Action'] = function()
			if BossFrameCheck == false and not (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
				BossFrameCheck = true
				TimeWhenBossFrameIsDown = KF.TimeNow
			elseif BossFrameCheck == true and (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
				BossFrameCheck = false
				TimeWhenBossFrameIsDown = 0
			end
		end,
	}
	
	KF:RegisterCallback('BossBattleStart', function()
		KF:RaidCooldown_RefreshCooldownBarData()
		
		CurrentMapID = select(8, GetInstanceInfo())
		
		if ResetCooldownMapID[CurrentMapID] then
			NowBossBattle = true
			
			AreaWhenBattleStart = CurrentMapID
			
			KF.Event['GROUP_ROSTER_UPDATE']['CheckGroupMode']()
			GroupTypeWhenBattleStart = KF.CurrentGroupMode
			
			BossFrameCheck = false
			Table['BattleResurrection_CastMember'] = {}
			Table['BattleResurrection_ResurrectedMember'] = {}
			KF.Update['CheckBossFrameHideTime']['Condition'] = true
		end
	end, 'RaidCooldown')
	KF:RegisterCallback('BossBattleEnd', function()
		KF:RaidCooldown_RefreshCooldownBarData()
		Table['BattleResurrection_CastMember'] = {}
		Table['BattleResurrection_ResurrectedMember'] = {}
		
		CurrentMapID = select(8, GetInstanceInfo())
		
		NowBossBattle = false
		
		if not (IsInInstance() and AreaWhenBattleStart ~= CurrentMapID) and GroupTypeWhenBattleStart == KF.CurrentGroupMode then
			print(L['KF']..' : '..L['Reset skills that have a cool time more than 5 minutes'])
			
			local Check
			for userGUID in pairs(Table['Cooldown_Cache']) do
				local _, className, _, _, _, userName = GetPlayerInfoByGUID(userGUID)
				
				
				if Table['Cooldown_Cache'][userGUID]['List'] then
					for spellID in pairs(Table['Cooldown_Cache'][userGUID]['List']) do
						if KF.Table['RaidCooldownSpell'][Table['Cooldown_Cache'][userGUID]['Class']][spellID][1] >= 300 then-- Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] < (TimeWhenBossFrameIsDown or KF.TimeNow) then
							Check = nil
							
							for i = 1, #Table['Cooldown_BarList'] do
								if Table['Cooldown_BarList'][i]['Data'] and Table['Cooldown_BarList'][i]['Data']['spellID'] == spellID and Table['Cooldown_BarList'][i]['Data']['GUID'] == userGUID then
									Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] = { ['FadeType'] = KF.TimeNow, ['NoAnnounce'] = true, }
									
									--print(KF:Color_Class(className, userName)..' 님의 '..GetSpellLink(spellID)..' 주문 바에 있어 삭제')
									Check = true
									break
								end
							end
							
							if not Check then
								Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] = 0
								--print(KF:Color_Class(className, userName)..' 님의 '..GetSpellLink(spellID)..' 주문 시전한 시간 0으로 조절')
							end
						end
					end
				end
			end
			KF.Update['CheckBossFrameHideTime']['Condition'] = false
		end
	end, 'RaidCooldown')
	
	KF:RegisterEventList('ZONE_CHANGED_NEW_AREA', function()
		_, Value['CurrentInstance_Type'], Value['CurrentInstance_DifficultyID'] = GetInstanceInfo()
		
		if Value['CurrentInstance_Type'] == 'arena' then
			KnightRaidCooldown.Brez:Hide()
			for userGUID in pairs(Table['Cooldown_Cache']) do
				for spellID in pairs(Table['Cooldown_Cache'][userGUID]['List']) do
					Table['Cooldown_Cache'][userGUID]['List'][spellID]['Fade'] = { ['FadeType'] = KF.TimeNow, }
				end
			end
		elseif Value['CurrentInstance_Type'] == 'pvp' then
			KnightRaidCooldown.Brez:Hide()
		elseif KnightRaidCooldown.Brez['Data'] then
			for _ in pairs(KnightRaidCooldown.Brez['Data']) do
				KnightRaidCooldown.Brez:Show()
				break
			end
		end
	end, 'KnightRaidCooldown')
	
	
	
	KnightRaidCooldown.Brez = CreateFrame('Button', nil, KnightRaidCooldown)
	KnightRaidCooldown.Brez:SetBackdrop({
		bgFile = E['media'].blankTex,
		edgeFile = E['media'].blankTex,
		tile = false, tileSize = 0, edgeSize = E.mult,
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	KnightRaidCooldown.Brez:SetFrameLevel(4)
	KnightRaidCooldown.Brez:SetBackdropBorderColor(unpack(E['media'].bordercolor))
	KnightRaidCooldown.Brez:SetScript('OnEnter', function(self)
		self:SetBackdropBorderColor(unpack(E['media'].rgbvaluecolor))
		self.DisplayTooltip = true
		
		if KF.db.Modules.SmartTracker.Appearance.RaidIcon_StartPoint == 2 then
			if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then
				GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
			else
				GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
			end
		else --Default Location is 1(LEFTSIDE of MainFrame)
			if KF.db.Modules.SmartTracker.Appearance.Bar_Direction == 1 then
				GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
			else
				GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
			end
		end
	end)
	KnightRaidCooldown.Brez:SetScript('OnLeave', function(self)
		self:SetBackdropBorderColor(unpack(E['media'].bordercolor))
		self.DisplayTooltip = nil
		GameTooltip:Hide()
	end)
	
	KnightRaidCooldown.BrezIconFrame = CreateFrame('Frame', nil, KnightRaidCooldown.Brez)
	KnightRaidCooldown.BrezIconFrame:SetBackdrop({
		bgFile = E['media'].blankTex,
		edgeFile = E['media'].blankTex,
		tile = false, tileSize = 0, edgeSize = E.mult,
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	KnightRaidCooldown.BrezIconFrame:SetFrameLevel(5)
	KnightRaidCooldown.BrezIconFrame:SetBackdropColor(0, 0, 0)
	KnightRaidCooldown.BrezIconFrame:SetBackdropBorderColor(unpack(E['media'].bordercolor))
	KnightRaidCooldown.BrezIconFrame:Point('CENTER', KnightRaidCooldown.Brez)
	
	KnightRaidCooldown.BrezIcon = KnightRaidCooldown.BrezIconFrame:CreateTexture(nil, 'OVERLAY')
	KnightRaidCooldown.BrezIcon:SetTexCoord(unpack(E.TexCoords))
	KnightRaidCooldown.BrezIcon:SetInside()
	KnightRaidCooldown.BrezIcon:SetTexture(select(3, GetSpellInfo(83968)))
	
	KnightRaidCooldown.BrezNum = KnightRaidCooldown.BrezIconFrame:CreateFontString(nil, 'OVERLAY')
	KnightRaidCooldown.BrezNum:SetJustifyH('RIGHT')
	KnightRaidCooldown.BrezNum:Point('BOTTOMRIGHT',KnightRaidCooldown.Brez, -1, 4)
	
	KnightRaidCooldown.Brez:Hide()
	
	KF.Update['RaidCooldownBrezIcon'] = {
		['Condition'] = function()
			if KnightRaidCooldown.Brez:IsShown() then
				for _ in pairs(KnightRaidCooldown.Brez['Data']) do
					return true
				end
			end
		end,
		['Delay'] = 0,
		['Action'] = function()
			Value['BrezCount'] = 0
			Value['BrezMaxCount'] = 0
			
			if not Value['CurrentInstance_Type'] then
				_, Value['CurrentInstance_Type'], Value['CurrentInstance_DifficultyID'] = GetInstanceInfo()
			end
			
			if Value['CurrentInstance_Type'] == 'raid' and IsEncounterInProgress() then
				Value['BrezMaxCount'] = (Value['CurrentInstance_DifficultyID'] == 3 or Value['CurrentInstance_DifficultyID'] == 5) and 1 or 3
				for Tag, SavedData in pairs(Table['BattleResurrection_CastMember']) do
					if not UnitIsDeadOrGhost(SavedData['destName']) then
						if not Table['BattleResurrection_ResurrectedMember'][SavedData['destName']] or Table['BattleResurrection_ResurrectedMember'][SavedData['destName']] ~= KF.TimeNow then
							Table['BattleResurrection_ResurrectedMember'][#Table['BattleResurrection_ResurrectedMember'] + 1] = SavedData
							Table['BattleResurrection_ResurrectedMember'][SavedData['destName']] = KF.TimeNow
						end
						Table['BattleResurrection_CastMember'][Tag] = nil
					end
				end
				
				if CannotBeResurrected() then
					KnightRaidCooldown.BrezIcon:SetAlpha(0.4)
					KnightRaidCooldown.Brez:SetBackdropColor(1, 0.1, 0.1)
					KnightRaidCooldown.BrezNum:SetText('|cffff2d2dX')
				else
					KnightRaidCooldown.BrezIcon:SetAlpha(1)
					KnightRaidCooldown.Brez:SetBackdropColor(0.8, 0.8, 0.8)
					KnightRaidCooldown.BrezNum:SetText('|cff93daff'..(Value['BrezMaxCount'] - #Table['BattleResurrection_ResurrectedMember']))
				end
				
				if KnightRaidCooldown.Brez.DisplayTooltip then
					GameTooltip:ClearLines()
					
					local isFirst = true
					local Check, userName
					for i = 1, #Table['BattleResurrection_ResurrectedMember'] do
						if isFirst then GameTooltip:AddLine('|cff1784d1>>|r '..L['Resurrected User']..' |cff1784d1<<', 1,1,1) isFirst = nil end
						GameTooltip:AddDoubleLine(' |cffceff00'..i..'.|r '..Func['GetRoleIcon'](Table['BattleResurrection_ResurrectedMember'][i]['destGUID'])..' ' ..Table['BattleResurrection_ResurrectedMember'][i]['destColor']..Table['BattleResurrection_ResurrectedMember'][i]['destName'], 'from '..KF:Color_Class(Table['BattleResurrection_ResurrectedMember'][i]['userClass'], Table['BattleResurrection_ResurrectedMember'][i]['userName'])..' '..Func['GetRoleIcon'](Table['BattleResurrection_ResurrectedMember'][i]['userGUID']), 1, 1, 1, 1, 1, 1)
					end
					
					if CannotBeResurrected() then
						GameTooltip:AddLine('|n - |cffff5675'..L['Brez Available']..' : 0', 1, 1, 1)
					else
						GameTooltip:AddLine(format((isFirst and '' or '|n')..' - |cffffdc3c'..L['Brez Available']..'|r : |cff2eb7e4%s', (Value['BrezMaxCount'] - #Table['BattleResurrection_ResurrectedMember'])), 1, 1, 1)
						
						for BrezSpellID in pairs(Table['BattleResurrection']) do
							Check = nil
							for userGUID, spellID in pairs(KnightRaidCooldown.Brez['Data']) do
								if spellID == BrezSpellID then
									if not Check then
										Check = true
										GameTooltip:AddLine('|n|cff1784d1>>|r '..GetSpellInfo(spellID)..' |cff1784d1<<', 1, 1, 1)
										isFirst = nil
									end
									userName = Table['Inspect_Cache'][userGUID]['Name']
									GameTooltip:AddDoubleLine(' '..Func['GetRoleIcon'](userGUID)..' '..(UnitIsDeadOrGhost(userName) and '|cff778899'..userName..' ('..DEAD..')' or KF:Color_Class(Table['Inspect_Cache'][userGUID]['Class'], userName)), Table['Cooldown_Cache'][userGUID] and Table['Cooldown_Cache'][userGUID]['List'][spellID] and '|cffb90624'..Func['TimeFormat'](Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow) or '|cff2eb7e4'..L['Enable To Cast'], 1, 1, 1, 1, 1, 1)
								end
							end
						end
					end
					GameTooltip:Show()
				end
			else
				for userGUID, spellID in pairs(KnightRaidCooldown.Brez['Data']) do
					Value['BrezMaxCount'] = Value['BrezMaxCount'] + 1
					if not (Table['Cooldown_Cache'][userGUID] and Table['Cooldown_Cache'][userGUID]['List'][spellID]) then
						Value['BrezCount'] = Value['BrezCount'] + 1
					end
				end
				
				if Value['BrezCount'] == 0 or CannotBeResurrected() then
					KnightRaidCooldown.BrezIcon:SetAlpha(0.2)
					KnightRaidCooldown.Brez:SetBackdropColor(0.2, 0.2, 0.2)
					KnightRaidCooldown.BrezNum:SetText('|cffb90624'..Value['BrezCount']..(Value['BrezMaxCount'] < 10 and KF.db.Modules.SmartTracker.Appearance.RaidIcon_DisplayMax ~= false and '/'..Value['BrezMaxCount'] or ''))
				else
					KnightRaidCooldown.BrezIcon:SetAlpha(1)
					KnightRaidCooldown.Brez:SetBackdropColor(0.8, 0.8, 0.8)
					KnightRaidCooldown.BrezNum:SetText(Value['BrezCount']..(Value['BrezMaxCount'] < 10 and KF.db.Modules.SmartTracker.Appearance.RaidIcon_DisplayMax ~= false and '/'..Value['BrezMaxCount'] or ''))
				end
				
				if KnightRaidCooldown.Brez.DisplayTooltip then
					GameTooltip:ClearLines()
					
					local isFirst = true
					local Check, userName
					for BrezSpellID in pairs(Table['BattleResurrection']) do
						Check = nil
						for userGUID, spellID in pairs(KnightRaidCooldown.Brez['Data']) do
							if spellID == BrezSpellID then
								if not Check then
									Check = true
									GameTooltip:AddLine((isFirst and '' or '|n')..'|cff1784d1>>|r '..GetSpellInfo(spellID)..' |cff1784d1<<', 1, 1, 1)
									isFirst = nil
								end
								userName = Table['Inspect_Cache'][userGUID]['Name']
								GameTooltip:AddDoubleLine(' '..Func['GetRoleIcon'](userGUID)..' '..(UnitIsDeadOrGhost(userName) and '|cff778899'..userName..' ('..DEAD..')' or KF:Color_Class(Table['Inspect_Cache'][userGUID]['Class'], userName)), Table['Cooldown_Cache'][userGUID] and Table['Cooldown_Cache'][userGUID]['List'][spellID] and '|cffb90624'..Func['TimeFormat'](Table['Cooldown_Cache'][userGUID]['List'][spellID]['ActivateTime'] + Table['Cooldown_Cache'][userGUID]['List'][spellID]['Cooltime'] - KF.TimeNow) or '|cff2eb7e4'..L['Enable To Cast'], 1, 1, 1, 1, 1, 1)
							end
						end
					end
					
					GameTooltip:Show()
				end
			end
		end,
	}
	
	KF.Modules[#KF.Modules + 1] = 'SmartCooldown'
	KF.Modules['SmartCooldown'] = function(RemoveOrder)
		
		if KF.db.Modules.SmartTracker.General.HideWhenSolo ~= false then
			KnightRaidCooldown:SetAlpha(0)
			KnightRaidCooldown:Hide()
		end
		
		if KF.db.Modules.SmartTracker.Appearance.Area_Visible == false then
			KnightRaidCooldown.DisplayArea:SetAlpha(0)
			KnightRaidCooldown.ToggleDisplay.Texture:SetTexCoord(0, 0.25, 0, 1)
		end
		KnightRaidCooldown.BrezNum:FontTemplate(nil, KF.db.Modules.SmartTracker.Appearance.RaidIcon_Fontsize, 'OUTLINE')
		
		
		_, Value['CurrentInstance_Type'] = IsInInstance()
		
		
	end
end