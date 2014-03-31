local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 3. 31
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.995

if not KF then return
elseif KF.UIParent then
	local OpenAllBagsInBank
	
	KF.StartUp['BankOpen'] = function()
		if E.private.bags.enable == false and not IsAddOnLoaded('AdiBags') then
			OpenAllBagsInBank = function()
				for i = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
					ToggleBag(i)
				end
			end
		end
	end
	
	KF.Modules[#KF.Modules + 1] = 'BankOpen'
	KF.Modules['BankOpen'] = function(RemoveOrder)
		if not RemoveOrder and KF.db.Modules.BankOpen ~= false then
			if OpenAllBagsInBank then
				KF:RegisterEventList('BANKFRAME_OPENED', function() OpenAllBagsInBank() end, 'BankOpen')
			end
			
			KF:RegisterEventList('GUILDBANKFRAME_OPENED', function() OpenAllBags() end, 'BankOpen')
			KF:RegisterEventList('GUILDBANKFRAME_CLOSED', function() CloseAllBags() end, 'BankOpen')
		else
			KF:UnregisterEventList('BANKFRAME_OPENED', 'BankOpen')
			KF:UnregisterEventList('GUILDBANKFRAME_OPENED', 'BankOpen')
			KF:UnregisterEventList('GUILDBANKFRAME_CLOSED', 'BankOpen')
		end
	end
end