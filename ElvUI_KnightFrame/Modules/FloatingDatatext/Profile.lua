local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.FloatingDatatext = {
	Enable = true
}


Info.FloatingDatatext_Default = {
	Enable = true,
	IgnoreCursor = false,
	HideWhenPetBattle = true,
	Display = {
		Mode = '',
		PvPMode = '',
		Tank = '',
		Melee = '',
		Caster = '',
		Healer = ''
	},
	Backdrop = {
		Enable = false,
		Transparency = false,
		CustomColor = false,
		Width = 100,
		Height = 22,
		Texture = 'Minimalist',
		CustomColor_Border = { r = 0.1, g = 0.1, b = 0.1 },
		CustomColor_Backdrop = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
		CustomColor_Backdrop_Transparency = { r = 0.06, g = 0.06, b = 0.06, a = 0.8 }
	},
	Font = {
		UseCustomFontStyle = false,
		Font = 'ElvUI Pixel',
		FontSize = 10,
		FontStyle = 'OUTLINE'
	}
}


KF.DBFunction.FloatingDatatext = {
	Load = function(TableToSave, TableToLoad)
		if TableToLoad.Modules and TableToLoad.Modules.FloatingDatatext and type(TableToLoad.Modules.FloatingDatatext) == 'table' then
			for datatextName, IsDatatextData in pairs(TableToLoad.Modules.FloatingDatatext) do
				if type(IsDatatextData) == 'table' then
					TableToSave.Modules.FloatingDatatext[datatextName] = E:CopyTable({}, Info.FloatingDatatext_Default)
				end
			end
		end
	end,
	Save = function()
		for datatextName, IsDatatextData in pairs(KF.db.Modules.FloatingDatatext) do
			if type(IsDatatextData) == 'table' then
				KF:CompareTable(IsDatatextData, Info.FloatingDatatext_Default, KF.db.Modules.FloatingDatatext[datatextName], { ReplaceDifferentValue = true, DeleteSameValue = true })
				
				if KF.db.Modules.FloatingDatatext[datatextName] == nil then
					KF.db.Modules.FloatingDatatext[datatextName] = {}
				end
			end
		end
		
		if E.db.movers and KF.UIParent.Datatext then
			for datatextName, frame in pairs(KF.UIParent.Datatext) do
				if datatextName ~= 0 and E.db.movers and E.db.movers[frame.mover.name] then
					E.db.movers[datatextName] = E.db.movers[frame.mover.name]
				end
				
				E.db.movers[frame.mover.name] = nil
			end
		end
	end,
}