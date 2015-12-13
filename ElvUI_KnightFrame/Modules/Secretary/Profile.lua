local E, L, V, P, G = unpack(ElvUI)
local KF, Info, Timer = unpack(select(2, ...))

KF.db.Modules.Secretary = {
	Enable = true,
	
	Alarm = {
		Enable = true,
		
		AlarmMethod = {
			Blink = true,
			Sound = true
		},
		
		Event = {
			ContentsQueue = true,
			ReadyCheck = true,
			Summon = true
		}
	},
	
	ToggleObjectiveFrame = {
		Enable = true
	}
}