--Cache global variables
--Lua functions
local _G = _G
local unpack, select, type, print, pairs = unpack, select, type, print, pairs

local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

--WoW API / Variables
local geterrorhandler = geterrorhandler
local seterrorhandler = seterrorhandler
local RunScript = RunScript

if type(L['Command_Calculator']) == 'table' then
	function KF:Calculator(formula)
		local origHandler = geterrorhandler()
		
		seterrorhandler(function() print(L['KF']..' : '..L['Input formula is incorrect.']) end)
		
		formula = 'local answer='..formula..';if answer then SendChatMessage(\''..L['Formula']..' : '..formula..'\',\'SAY\');SendChatMessage(\''..L['Anshwer']..' : \'..answer,\'SAY\') end'
		
		RunScript(formula)
		seterrorhandler(origHandler)
	end
	
	for _, Command in pairs(L['Command_Calculator']) do
		KF:RegisterChatCommand(Command, 'Calculator')
	end
end