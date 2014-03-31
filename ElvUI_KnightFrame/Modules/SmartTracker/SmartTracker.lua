local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 28
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return
elseif KF.UIParent then
	local SC = CreateFrame('Frame', 'KnightSmartTracker', E.UIParent)
	
	local CORE_FRAME_LEVEL = 10
	local TAB_HEIGHT = 20
	
	--<< Key Table >>--
	
	
	function SC:CreateSmartTrackerFrame()
		do --<< Core >>--
			self:SetFrameStrata('HIGH')
			self:SetFrameLevel(CORE_FRAME_LEVEL)
			self:SetMovable(true)
			self:SetClampedToScreen(true)
			self:SetMinResize(200, 500) -- 미니멈 높이사이즈 조절필요
			
			self:SetScript('OnEvent', function(self, Event, ...) if self[Event] then self[Event](Event, ...) end end)
		end
		
		do --<< Tab >>--
			self.Tab = CreateFrame('Frame', 'KnightRaidCooldownTab', self)
			self.Tab:Height(TAB_HEIGHT)
			self.Tab:SetFrameLevel(CORE_FRAME_LEVEL + 1)
			self.Tab:SetBackdrop({
				bgFile = E.media.normTex,
				edgeFile = E.media.blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			self.Tab:SetBackdropColor(unpack(KF.db.Modules.SmartTracker.Appearance.Color_MainFrame))
			self.Tab:SetBackdropBorderColor(unpack(E.media.bordercolor))
			KF:TextSetting(self.Tab, nil, { ['FontSize'] = 10, ['FontOutline'] = 'OUTLINE', ['directionH'] = 'LEFT', }, 'LEFT', 4, 0)
			--[[
			self.Tab:SetScript('OnMouseDown', function() if self.DisplayArea:GetAlpha() > 0 then self:StartMoving() end end)
			self.Tab:SetScript('OnMouseUp', function()
				if self.DisplayArea:GetAlpha() > 0 then
					self:StopMovingOrSizing()
					local point, _, secondaryPoint, x, y = self:GetPoint()
					KnightRaidCooldownMover:ClearAllPoints()
					KnightRaidCooldownMover:Point(point, E.UIParent, secondaryPoint, x, y)
					E:SaveMoverPosition('KnightRaidCooldownMover')
					self:ClearAllPoints()
					self:SetPoint(point, KnightRaidCooldownMover, 0, 0)
				end
			end)
			]]
		end
		
		
		self.CreateSmartTrackerFrame = nil
	end
	
	KF.Modules[#KF.Modules + 1] = 'SmartTracker'
	KF.Modules['SmartTracker'] = function(RemoveOrder)
		if not RemoveOrder and KF.db.Enable ~= false and KF.db.Modules.SmartTracker.Enable then
			if SC.CreateSmartTrackerFrame then
				SC:CreateSmartTrackerFrame()
			end
			
			if KF.db.Modules.SmartTracker.General.HideWhenSolo ~= false then
				SC:SetAlpha(0)
				SC:Hide()
			end
		else
			SC:UnregisterAllEvents()
		end
	end
end