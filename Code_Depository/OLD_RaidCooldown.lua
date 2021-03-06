﻿local E, L, V, P, G, _  = unpack(ElvUI)
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
		
		
		Func['CalcCooldown'] = function()
			
		end
		
		
		-- Refresh Cooltime
		
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : Cooldown Bar								]--
	-----------------------------------------------------------
	do
		
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
	-- [ Knight : Initialize RaidCooldown					]--
	-----------------------------------------------------------
	
	
	
	
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