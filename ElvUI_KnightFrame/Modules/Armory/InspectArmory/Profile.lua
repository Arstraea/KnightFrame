local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.Armory.Inspect = {
	Enable = true,
	
	NoticeMissing = true,
	
	Backdrop = {
		SelectedBG = 'Space',
		CustomAddress = ''
	},
	
	Gradation = {
		Display = true,
		Color = { .41, .83, 1 }
	},
	
	Level = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		ShowUpgradeLevel = false,
		Font = nil,
		FontSize = 10,
		FontStyle = nil
	},
	
	Enchant = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		WarningSize = 12,
		WarningIconOnly = false,
		Font = nil,
		FontSize = 8,
		FontStyle = nil
	},
	
	Gem = {
		Display = 'Always', -- Always, MouseoverOnly, Hide
		SocketSize = 10,
		WarningSize = 12
	}
}