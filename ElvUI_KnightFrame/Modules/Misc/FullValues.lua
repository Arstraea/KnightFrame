--Cache global variables
--Lua functions
local _G = _G
local unpack, select, floor, assert, gsub, format = unpack, select, floor, assert, string.gsub, string.format

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local GetMouseFocus = GetMouseFocus
local GetAttribute = GetAttribute
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local DEAD = DEAD

--------------------------------------------------------------------------------
--<< KnightFrame : Full Values in Tooltip and UnitFrame						>>--
--------------------------------------------------------------------------------
--<< Tooltip HP >>--
-- Original Code (Version)		: ElvUI(10.08)
-- Original Code Location		: ElvUI\modules\tooltip\tooltip.lua
local TT = E:GetModule('Tooltip')
function TT:GameTooltipStatusBar_OnValueChanged(tt, value)
	if not value or not self.db.healthBar.text or not tt.text then return end
	
	local unit = select(2, tt:GetParent():GetUnit())
	
	if(not unit) then
		local GMF = GetMouseFocus()
		
		if GMF and GMF:GetAttribute('unit') then
			unit = GMF:GetAttribute('unit')
		end
	end
	
	local min, max = tt:GetMinMaxValues()
	
	if(value > 0 and max == 1) then
		tt.text:SetText(format('%d%%', floor(value * 100)))
		
		tt:SetStatusBarColor(.6, .6, .6) -- ElvUI\modules\tooltip\tooltip.lua -> local TAPPED_COLOR = { r=.6, g=.6, b=.6 }
	elseif(value == 0 or (unit and UnitIsDeadOrGhost(unit))) then
		tt.text:SetText(DEAD)
	else
		tt.text:SetText((KF.db.Modules.FullValues ~= false and value..' / '..max or E:ShortValue(value)..' / '..E:ShortValue(max)))
	end
end




--<< UnitFrame HP >>--
-- Original Code (Version)		: ElvUI(10.08)
-- Original Code Location		: ElvUI\Core\math.lua
local styles = {
	['CURRENT'] = '%s',
	['CURRENT_MAX'] = '%s - %s',
	['CURRENT_PERCENT'] =  '%s - %s%%',
	['CURRENT_MAX_PERCENT'] = '%s - %s | %s%%',
	['PERCENT'] = '%s%%',
	['DEFICIT'] = '-%s',
	['KF_CURRENT'] = '%s',
	['KF_PERCENT'] = '%s%%',
	['KF_CURRENT_PERCENT'] =  '%s%%|n%s',
	['KF_CURRENT_MAX_PERCENT'] = '%s%%|n%s - %s',
}

function E:GetFormattedText(style, min, max) --ElvUI\Core\math.lua
	assert(styles[style], 'Invalid format style: '..style)
	assert(min, 'You need to provide a current value. Usage: E:GetFormattedText(style, min, max)')
	assert(max, 'You need to provide a maximum value. Usage: E:GetFormattedText(style, min, max)')

	if max == 0 then max = 1 end
	
	style = KF.db.Modules.FullValues ~= false and styles['KF_'..style] and 'KF_'..style or style
	
	local useStyle = styles[style]
	
	if style == 'DEFICIT' then
		local deficit = max - min
		if deficit <= 0 then
			return ''
		else
			return string.format(useStyle, E:ShortValue(deficit))
		end
	elseif style == 'PERCENT' then
		local s = format(useStyle, format("%.1f", min / max * 100))
		s = s:gsub(".0%%", "%%")
		return s
	elseif style == 'CURRENT' or ((style == 'CURRENT_MAX' or style == 'CURRENT_MAX_PERCENT' or style == 'CURRENT_PERCENT') and min == max) then
		return string.format(styles['CURRENT'], E:ShortValue(min))
	elseif style == 'CURRENT_MAX' then
		return format(useStyle,  E:ShortValue(min), E:ShortValue(max))
	elseif style == 'CURRENT_PERCENT' then
		local s = format(useStyle, E:ShortValue(min), format("%.1f", min / max * 100))
		s = s:gsub(".0%%", "%%")
		return s
	elseif style == 'CURRENT_MAX_PERCENT' then
		local s = format(useStyle, E:ShortValue(min), E:ShortValue(max), format("%.1f", min / max * 100))
		s = s:gsub(".0%%", "%%")
		return s
	elseif style == 'KF_CURRENT' then
		return string.format(styles['CURRENT'], min)
	elseif style == 'KF_PERCENT' then
		if min == max then
			return ''
		else
			local s = format(useStyle, format("%.1f", min / max * 100))
			s = s:gsub(".0%%", "%%")
			return s
		end
	elseif style == 'KF_CURRENT_PERCENT' then
		if min == max then
			return string.format(styles['CURRENT'], min)
		else
			local s =  string.format(useStyle, format("%.1f", min / max * 100), min)
			s = s:gsub('.0%%', '%%')
			return s
		end
	elseif style == 'KF_CURRENT_MAX_PERCENT' then
		local s = string.format(useStyle, format("%.1f", min / max * 100), min, max)
		s = s:gsub('.0%%', '%%')
		return s
	end
end