local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--------------------------------------------------------------------------------
--<< KnightFrame : Panel - Button By LDB Registered							>>--
--------------------------------------------------------------------------------
function KF:CustomPanel_Button_RegisterLDB()
	for AddOnName, Data in LibStub:GetLibrary('LibDataBroker-1.1'):DataObjectIterator() do
		if not KF.UIParent.Button[AddOnName] then
			KF.UIParent.Button[AddOnName] = {
				Text = strsub(Data.text and (Data.text == 'n/a' and AddOnName or Data.text) or AddOnName, 1, 1)
			}
			
			if Data.OnTooltipShow then
				KF.UIParent.Button[AddOnName].OnEnter = function(Button)
					GameTooltip:SetOwner(Button, 'ANCHOR_TOP', 0, 2)
					GameTooltip:ClearLines()
					Data.OnTooltipShow(GameTooltip)
					GameTooltip:Show()
					
					Button.text:SetText(KF:Color_Value(KF.UIParent.Button[AddOnName].Text))
				end
			end
			
			if Data.OnEnter then
				KF.UIParent.Button[AddOnName].OnEnter = function(Button)
					GameTooltip:SetOwner(Button, 'ANCHOR_TOP', 0, 2)
					GameTooltip:ClearLines()
					Data.OnEnter(Button)
					GameTooltip:Show()
					
					Button.text:SetText(KF:Color_Value(KF.UIParent.Button[AddOnName].Text))
				end
			end
			
			if Data.OnLeave then
				KF.UIParent.Button[AddOnName].OnLeave = function(Button)
					Data.OnLeave(Button)
					GameTooltip:Hide()
					Button.text:SetText(KF.UIParent.Button[AddOnName].Text)
				end
			end
			
			KF.UIParent.Button[AddOnName].OnClick = function(Button, PressedButton)
				if Data.OnClick then
					Data.OnClick(Button, PressedButton)
				end
			end
		end
	end
end

KF:RegisterEventList('ADDON_LOADED', KF.CustomPanel_Button_RegisterLDB)