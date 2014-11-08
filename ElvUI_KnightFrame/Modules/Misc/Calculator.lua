local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

if L['Command_Calculator'] then
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