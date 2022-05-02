RegisterNetEvent("Zero:Client-Core:UpdatePlayers")
AddEventHandler("Zero:Client-Core:UpdatePlayers", function(x)
    playersOnline = x ~= nil and x or 0
    playersOnline = playersOnline ~= 0 and playersOnline or 1
end)

Citizen.CreateThread(function()
    playersOnline = 1
    
	while true do
        local PlayerName = GetPlayerName(PlayerId())
        local id = GetPlayerServerId(PlayerId())
		
        -- This is the Application ID (Replace this with you own)
		SetDiscordAppId("941351223456587806")
		
        SetRichPresence(playersOnline .. "/128 online") -- This will take the player name and the Id
		
		SetDiscordRichPresenceAsset('logoa')
        
        -- Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('Zero Roleplay')
       
		Citizen.Wait(60000)
	end
end)