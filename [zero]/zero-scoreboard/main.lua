exports["zero-core"]:object(function(O) Zero = O end)

playersOnline = 1

RegisterNetEvent("Zero:Client-Core:UpdatePlayers")
AddEventHandler("Zero:Client-Core:UpdatePlayers", function(x)
    playersOnline = x ~= nil and x or 0
    playersOnline = playersOnline ~= 0 and playersOnline or 1
end)

RegisterNetEvent("Zero:Client-Scoreboard:Sync")
AddEventHandler("Zero:Client-Scoreboard:Sync", function(counts, players)
    SendNUIMessage({
        action = "sync",
        counts = counts,
        players = playersOnline,
    })
end)

Citizen.CreateThread(function()
    while true do
        if IsControlPressed(0, Zero.Config.Keys['HOME']) then

            SendNUIMessage({
                action = "show"
            })

            while IsControlPressed(0, Zero.Config.Keys['HOME']) do
                Wait(0)
            end
            
            SendNUIMessage({
                action = "hide"
            })
        end
        Wait(3)
    end
end)