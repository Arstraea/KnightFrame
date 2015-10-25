
local SavedWhisper = {}
SC.Alarm_BlinkEnd = function(_, Message, Author, ...)
	print(Author, Message)
	if Author == E.myname..'-'..Info.MyRealm and Message == SC.Alarm_BlinkMessage then
		print('여기로 들어왔나')
		for ChatFrame in pairs(SC.WhisperChatFrameList) do
			ChatFrame_AddMessageGroup(ChatFrame, 'WHISPER')
			
			for i = 1, #SavedWhisper do
				ChatFrame_MessageEventHandler(ChatFrame, 'CHAT_MSG_WHISPER', unpack(SavedWhisper[i]))
			end
		end
		
		wipe(SavedWhisper)
		KF:UnregisterEventList('CHAT_MSG_WHISPER', 'Secretary_Alarm_Blink')
	else
		tinsert(SavedWhisper, { Message, Author, ... })
	end
end


local ChatFrame
			local ContainedWhisperChannel
			
			wipe(SC.WhisperChatFrameList)
			for i = 1, NUM_CHAT_WINDOWS do
				ChatFrame = _G[format("ChatFrame%d", i)]
				
				if ChatFrame then
					print(i, '번 채팅프레임 존재')
					ContainedWhisperChannel = nil
					
					for Index, Value in pairs(ChatFrame.messageTypeList) do
						if strupper(Value) == 'WHISPER' then
							print(i, '번 채팅프레임 귓말채널 보유')
							ContainedWhisperChannel = true
							break
						end
					end
					
					if ContainedWhisperChannel then
						print('채팅창에서 위스퍼채널 잠시 해제')
						SC.WhisperChatFrameList[ChatFrame] = true
						ChatFrame_RemoveMessageGroup(ChatFrame, 'WHISPER')
					end
				end
			end
			
			if next(SC.WhisperChatFrameList) then
				print('있다')
				KF:RegisterEventList('CHAT_MSG_WHISPER', SC.Alarm_BlinkEnd, 'Secretary_Alarm_Blink')
				
				SendChatMessage(SC.Alarm_BlinkMessage, 'WHISPER', nil, E.myname)
			end