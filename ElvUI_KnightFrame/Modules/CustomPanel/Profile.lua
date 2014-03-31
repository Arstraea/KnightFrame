local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 19
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return end

KF.db.Modules['CustomPanel'] = {
	['Enable'] = true,
}


KF_CustomPanel_Default = {
	['Enable'] = true,
	['HideWhenPetBattle'] = true,
	['Width'] = 300,
	['Height'] = 100,
	['panelBackdrop'] = true,
	['Texture'] = {
		['Enable'] = false,
		['Alpha'] = 0.5,
		['Path'] = '',
	},
	['Tab'] = {
		['Enable'] = true,
		['Transparency'] = false,
		['ButtonLeft'] = {},
		['ButtonRight'] = {},
	},
	['DP'] = {
		['Enable'] = true,
		['Transparency'] = false,
		['ButtonLeft'] = {},
		['ButtonRight'] = {},
	},
}


if KF.DBFunction then
	KF.DBFunction['CustomPanel'] = {
		['Load'] = function(DB, TableToLoad)
			if TableToLoad.Modules and TableToLoad.Modules.CustomPanel and type(TableToLoad.Modules.CustomPanel) == 'table' then
				for panelName, IsPanelData in pairs(TableToLoad.Modules.CustomPanel) do
					if type(IsPanelData) == 'table' then
						DB.Modules.CustomPanel[panelName] = E:CopyTable({}, KF_CustomPanel_Default)
					end
				end
			end
		end,
		['Save'] = function()
			for panelName, IsPanelData in pairs(KF.db.Modules.CustomPanel) do
				if type(IsPanelData) == 'table' then
					KF.db.Modules.CustomPanel[panelName] = KF:CompareTable(IsPanelData, KF_CustomPanel_Default)
					
					if KF.db.Modules.CustomPanel[panelName] == nil then
						KF.db.Modules.CustomPanel[panelName] = {}
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
		end,
	}
end