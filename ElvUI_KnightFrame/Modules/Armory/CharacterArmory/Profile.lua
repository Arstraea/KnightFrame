local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.Armory = KF.db.Modules.Armory or {}
	
KF.db.Modules.Armory.Character = {
	Enable = true,
	
	NoticeMissing = true,
	ShowDurabilityWhenDamagedOnly = false,
	
	Background = {
		SelectedBG = 'Space',
		CustomAddress = ''
	},
	
	Gradation = {
		DisplayGradation = true,
		Color = { .41, .83, 1 }
	},
	
	Level = {
		DisplayLevel = 'Always', -- Always, MouseoverOnly, Hide
		ShowUpgradeLevel = false,
		
		Font = nil,
		FontSize = 10,
		FontStyle = nil
	},
	
	Enchant = {
		DisplayEnchant = 'Always', -- Always, MouseoverOnly, Hide
		WarningSize = 12,
		WarningIconOnly = false,
		
		Font = nil,
		FontSize = 8,
		FontStyle = nil
	},
	
	Gem = {
		DisplaySocket = 'Always', -- Always, MouseoverOnly, Hide
		SocketSize = 12,
		WarningSize = 12
	}
}