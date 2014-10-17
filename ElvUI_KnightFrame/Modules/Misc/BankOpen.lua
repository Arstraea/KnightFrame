local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

local OpenAllBagsInBank

local function Open_AllBags()
	OpenAllBags()
end

local function Cloase_AllBags()
	CloseAllBags()
end


KF.InitializeFunction.BankOpen = function()
	if E.private.bags.enable == false and not IsAddOnLoaded('AdiBags') then
		OpenAllBagsInBank = function()
			for i = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
				ToggleBag(i)
			end
		end
	end
end

KF.Modules[#KF.Modules + 1] = 'BankOpen'
KF.Modules.BankOpen = function(RemoveOrder)
	if not RemoveOrder and DB.Modules.BankOpen ~= false then
		if OpenAllBagsInBank then
			KF:RegisterEventList('BANKFRAME_OPENED', OpenAllBagsInBank, 'BankOpen')
		end
		
		KF:RegisterEventList('GUILDBANKFRAME_OPENED', Open_AllBags, 'BankOpen')
		KF:RegisterEventList('GUILDBANKFRAME_CLOSED', Cloase_AllBags, 'BankOpen')
	else
		KF:UnregisterEventList('BANKFRAME_OPENED', 'BankOpen')
		KF:UnregisterEventList('GUILDBANKFRAME_OPENED', 'BankOpen')
		KF:UnregisterEventList('GUILDBANKFRAME_CLOSED', 'BankOpen')
	end
end