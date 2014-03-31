local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-- Last Code Checking Date		: 2014. 2. 19
-- Last Code Checking Version	: 3.0_01
-- Last Testing ElvUI Version	: 6.94

if not KF then return end

KF.db.Modules['FloatingDatatext'] = {
	['Enable'] = true,
}


KF_FloatingDatatext_Default = {
	['Enable'] = true,
	['IgnoreCursor'] = false,
	['HideWhenPetBattle'] = true,
	['Display'] = {
		['Mode'] = '',
		['PvPMode'] = '',
		['Tank'] = '',
		['Melee'] = '',
		['Caster'] = '',
		['Healer'] = '',
	},
	['Backdrop'] = {
		['Enable'] = false,
		['Transparency'] = false,
		['CustomColor'] = false,
		['Width'] = 100,
		['Height'] = 22,
		['Texture'] = 'Minimalist',
		['CustomColor_Border'] = { r = 0.1, g = 0.1, b = 0.1, },
		['CustomColor_Backdrop'] = { r = 0.1, g = 0.1, b = 0.1, a = 1, },
		['CustomColor_Backdrop_Transparency'] = { r = 0.06, g = 0.06, b = 0.06, a = 0.8, },
	},
	['Font'] = {
		['UseCustomFontStyle'] = false,
		['Font'] = 'ElvUI Pixel',
		['FontSize'] = 10,
		['FontOutline'] = 'OUTLINE',
	},
}


if KF.DBFunction then
	KF.DBFunction['FloatingDatatext'] = {
		['Load'] = function(DB, TableToLoad)
			if TableToLoad.Modules and TableToLoad.Modules.FloatingDatatext and type(TableToLoad.Modules.FloatingDatatext) == 'table' then
				for datatextName, IsDatatextData in pairs(TableToLoad.Modules.FloatingDatatext) do
					if type(IsDatatextData) == 'table' then
						DB.Modules.FloatingDatatext[datatextName] = E:CopyTable({}, KF_FloatingDatatext_Default)
					end
				end
			end
		end,
		['Save'] = function()
			for datatextName, IsDatatextData in pairs(KF.db.Modules.FloatingDatatext) do
				if type(IsDatatextData) == 'table' then
					KF.db.Modules.FloatingDatatext[datatextName] = KF:CompareTable(IsDatatextData, KF_FloatingDatatext_Default)
					
					if KF.db.Modules.FloatingDatatext[datatextName] == nil then
						KF.db.Modules.FloatingDatatext[datatextName] = {}
					end
				end
			end
			
			if E.db.movers then
				for datatextName, frame in pairs(KF.Datatext) do
					if datatextName ~= 0 and E.db.movers and E.db.movers[frame.mover.name] then
						E.db.movers[datatextName] = E.db.movers[frame.mover.name]
					end
					
					E.db.movers[frame.mover.name] = nil
				end
			end
		end,
	}
end