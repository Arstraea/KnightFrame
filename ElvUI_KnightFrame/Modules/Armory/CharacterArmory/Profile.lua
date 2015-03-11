local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.Armory = KF.db.Modules.Armory or {}
	
KF.db.Modules.Armory.Character = {
	Enable = true,
	
	NoticeMissing = true,
	
	Background = {
		SelectedBG = 'Space',
		CustomAddress = ''
	},
	
	Gradation = {
		DisplayGradation = true,
		Color = { .41, .83, 1 }
	},
	
	Level = {
		DisplayLevel = true,
		
		Font = nil,
		FontSize = 10,
		FontStyle = nil
	},
	
	Enchant = {
		DisplayEnchant = true,
		DisplayWhenMouseoverOnly = false,
		WarningSize = 12,
		
		Font = nil,
		FontSize = 8,
		FontStyle = nil
	},
	
	Gem = {
		DisplaySocket = true,
		SocketSize = 12,
		WarningSize = 12
	}
}