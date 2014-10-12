-- Last Code Checking Date		: 2014. 6. 16
-- Last Code Checking Version	: 3.0_02
-- Last Testing ElvUI Version	: 6.9997

local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Toolkit		 											>>--
--------------------------------------------------------------------------------
function KF:Color_Value(InputText)
	return E:RGBToHex(E.media.rgbvaluecolor[1], E.media.rgbvaluecolor[2], E.media.rgbvaluecolor[3])..(InputText and InputText..'|r' or '')
end	


function KF:Color_Class(Class, InputText)
	return (Class and '|c'..RAID_CLASS_COLORS[Class].colorStr or '')..(InputText and InputText..'|r' or '')
end


function KF:TextSetting(self, Text, Style, ...)
	if Style and Style.Tag then
		self[Style.Tag] = self[Style.Tag] or self:CreateFontString(nil, 'OVERLAY')
		self = self[Style.Tag]
	else
		Style = Style or {}
		self.text = self.text or self:CreateFontString(nil, 'OVERLAY')
		self = self.text
	end
	
	self:FontTemplate(Style.Font and E.LSM:Fetch('font', Style.Font), Style.FontSize, Style.FontOutline)
	self:SetJustifyH(Style.directionH or 'CENTER')
	self:SetJustifyV(Style.directionV or 'MIDDLE')
	self:SetText(Text)
	
	if ... then
		self:Point(...)
	else
		self:SetInside()
	end
end


function PrintTable(TableToCheck, row, InputTableName)
	row = row or 0
	if InputTableName then
		print(((' '):rep(row*2))..'|cff2eb7e4 [ Table|r : '..InputTableName..'|cff2eb7e4 ]')
		InputTableName = InputTableName..'-'
	else
		InputTableName = ''
	end
	for k, v in pairs(TableToCheck) do
		if type(v) == 'table' then
			PrintTable(v, row + 1, InputTableName..k)
		elseif type(v) == 'function' then
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : FUNCTION')
		elseif type(v) == 'userdata' then
		else
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : '..(type(v) == 'boolean' and (v==true and '|cff1784d1TRUE|r' or '|cffff0000FALSE|r') or v))
		end
	end
end