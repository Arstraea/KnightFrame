local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

local SkadaLoaded = IsAddOnLoaded('Skada') and 'Skada' or IsAddOnLoaded('SkadaU') and 'SkadaU'

if SkadaLoaded and KF.db.Skins.Skada ~= false and not IsAddOnLoaded('ElvUI_AddOnSkins') then
	--------------------------------------------------------------------------------
	--<< KnightFrame : Skada Skin												>>--
	--------------------------------------------------------------------------------
	local S = E:GetModule('Skins')
	
	-- Used to strip unecessary options from the in-game config
	local function StripOptions(options)
		options.baroptions.args.barspacing = nil
		options.titleoptions.args.texture = nil
		options.titleoptions.args.bordertexture = nil
		options.titleoptions.args.thickness = nil
		options.titleoptions.args.margin = nil
		options.titleoptions.args.color = nil
		options.windowoptions = nil
	end

	local function LoadSkin()
		local Skada = Skada
		local barSpacing = 1
		local borderWidth = 1
		local barmod = Skada.displays.bar

		for k, options in pairs(Skada.options.args.windows.args) do
			if options.type == "group" then
				StripOptions(options.args)
			end
		end

		local titleBG = {
			bgFile = E["media"].normTex,
			tile = false,
			tileSize = 0
		}
		
		hooksecurefunc(barmod, 'AddDisplayOptions', function(self, win, options)
			StripOptions(options)
		end)
		
		hooksecurefunc(barmod, 'ApplySettings', function(self, win)
			local skada = win.bargroup

			if win.db.enabletitle then
				skada.button:SetBackdrop(titleBG)
			end

			skada:SetSpacing(barSpacing)
			skada:SetFrameLevel(5)
			
			local titlefont = CreateFont('TitleFont'..win.db.name)
			win.bargroup.button:SetNormalFontObject(titlefont)

			win.bargroup.button:SetBackdropColor(unpack(E.media.backdropcolor))

			skada:SetBackdrop(nil)
			if not skada.backdrop then
				skada:CreateBackdrop('Default')
			end
			skada.backdrop:ClearAllPoints()
			if win.db.enabletitle then
				skada.backdrop:Point('TOPLEFT', win.bargroup.button, 'TOPLEFT', -2, 2)
			else
				skada.backdrop:Point('TOPLEFT', win.bargroup, 'TOPLEFT', -2, 2)
			end
			skada.backdrop:Point('BOTTOMRIGHT', win.bargroup, 'BOTTOMRIGHT', 2, -2)
			skada:SetFrameStrata('LOW')
		end)
		
		-- Update pre-existing displays
		for _, window in ipairs(Skada:GetWindows()) do
			window:UpdateDisplay()
		end	
	end
	
	S:RegisterSkin(SkadaLoaded, LoadSkin, true)
end