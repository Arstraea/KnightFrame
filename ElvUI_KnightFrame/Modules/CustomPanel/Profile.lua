local E, L, V, P, G = unpack(ElvUI)
local KF, DB, Info, Timer = unpack(select(2, ...))

DB.Modules.CustomPanel = {
	Enable = true
}


Info.CustomPanel_Default = {
	Enable = true,
	HideWhenPetBattle = true,
	Width = 300,
	Height = 100,
	panelBackdrop = true,
	Texture = {
		Enable = false,
		Alpha = 0.5,
		Path = ''
	},
	Tab = {
		Enable = true,
		Transparency = false,
		ButtonLeft = {},
		ButtonRight = {}
	},
	DP = {
		Enable = true,
		Transparency = false,
		ButtonLeft = {},
		ButtonRight = {}
	},
	Chat = {}
}


KF.DBFunction.CustomPanel = {
	Load = function(TableToSave, TableToLoad)
		if TableToLoad.Modules and TableToLoad.Modules.CustomPanel and type(TableToLoad.Modules.CustomPanel) == 'table' then
			for panelName, IsPanelData in pairs(TableToLoad.Modules.CustomPanel) do
				if type(IsPanelData) == 'table' then
					TableToSave.Modules.CustomPanel[panelName] = E:CopyTable({}, Info.CustomPanel_Default)
				end
			end
		end
	end,
	Save = function()
		for panelName, IsPanelData in pairs(DB.Modules.CustomPanel) do
			if type(IsPanelData) == 'table' then
				DB.Modules.CustomPanel[panelName] = KF:CompareTable(IsPanelData, Info.CustomPanel_Default)
				
				if DB.Modules.CustomPanel[panelName] == nil then
					DB.Modules.CustomPanel[panelName] = {}
				end
			end
		end
		
		if E.db.movers then
			for panelName, frame in pairs(KF.Frame) do
				if panelName ~= 0 and E.db.movers and E.db.movers[frame.mover.name] then
					E.db.movers[panelName] = E.db.movers[frame.mover.name]
				end
				
				E.db.movers[frame.mover.name] = nil
			end
		end
	end
}