local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 5
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return
elseif KF.UIParent then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Panel - Button By LDB Registered							>>--
	--------------------------------------------------------------------------------
	function KF:CustomPanelButton_RegisterLDB()
		for AddOnName, Data in LibStub:GetLibrary('LibDataBroker-1.1'):DataObjectIterator() do
			if not KF.Button[AddOnName] then
				KF.Button[AddOnName] = {}
				
				KF.Button[AddOnName]['Text'] = strsub(Data.text and (Data.text == 'n/a' and AddOnName or Data.text) or AddOnName, 1, 1)
				
				if Data.OnTooltipShow then
					KF.Button[AddOnName]['OnEnter'] = function(Button)
						GameTooltip:SetOwner(Button, 'ANCHOR_TOP', 0, 2)
						GameTooltip:ClearLines()
						Data.OnTooltipShow(GameTooltip)
						GameTooltip:Show()
						
						Button.text:SetText(KF:Color_Value(KF.Button[AddOnName]['Text']))
					end
				else
					KF.Button[AddOnName]['OnEnter'] = 'AddOn_Default'
				end
				
				if Data.OnEnter then
					KF.Button[AddOnName]['OnEnter'] = function(Button)
						GameTooltip:SetOwner(Button, 'ANCHOR_TOP', 0, 2)
						GameTooltip:ClearLines()
						Data.OnEnter(Button)
						GameTooltip:Show()
						
						Button.text:SetText(KF:Color_Value(KF.Button[AddOnName]['Text']))
					end
				else
					KF.Button[AddOnName]['OnEnter'] = 'AddOn_Default'
				end
				
				if Data.OnLeave then
					KF.Button[AddOnName]['OnLeave'] = function(Button)
						Data.OnLeave(Button)
						GameTooltip:Hide()
						Button.text:SetText(KF.Button[AddOnName]['Text'])
					end
				else
					KF.Button[AddOnName]['OnLeave'] = 'AddOn_Default'
				end
				
				KF.Button[AddOnName]['OnMouseDown'] = 'AddOn_Default'
				KF.Button[AddOnName]['OnMouseUp'] = 'AddOn_Default'
				
				KF.Button[AddOnName]['OnClick'] = function(Button, PressedButton)
					if Data.OnClick then
						Data.OnClick(Button, PressedButton)
					end
				end
			end
		end
	end
	
	KF:RegisterEventList('ADDON_LOADED', KF.CustomPanelButton_RegisterLDB)
end