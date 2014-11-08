local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.CustomPanel = {
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
	Load = function(TargetTable, TableToLoad)
		if TableToLoad.Modules and TableToLoad.Modules.CustomPanel and type(TableToLoad.Modules.CustomPanel) == 'table' then
			for panelName, IsPanelData in pairs(TableToLoad.Modules.CustomPanel) do
				if type(IsPanelData) == 'table' then
					TargetTable.Modules.CustomPanel[panelName] = E:CopyTable({}, Info.CustomPanel_Default)
				end
			end
		end
	end,
	Save = function()
		for panelName, IsPanelData in pairs(KF.db.Modules.CustomPanel) do
			if type(IsPanelData) == 'table' then
				KF.db.Modules.CustomPanel[panelName] = KF:CompareTable(IsPanelData, Info.CustomPanel_Default)
				
				if KF.db.Modules.CustomPanel[panelName] == nil then
					KF.db.Modules.CustomPanel[panelName] = {}
				end
			end
		end
		
		if E.db.movers and KF.UIParent.Panel then
			for panelName, Panel in pairs(KF.UIParent.Panel) do
				if panelName ~= 0 and E.db.movers and E.db.movers[Panel.mover.name] then
					E.db.movers[panelName] = E.db.movers[Panel.mover.name]
				end
				
				E.db.movers[Panel.mover.name] = nil
			end
		end
	end
}