

RegisterServerEvent("Zero:Server-Vehicles:SetRadio")
AddEventHandler("Zero:Server-Vehicles:SetRadio", function(plate, url)
    local player = Zero.Functions.Player(source)

    if vehicles[plate] then
        if vehicles[plate].radio then
            vehicles[plate].radioUrl = url

            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        else
            player.Functions.Notification("Tuner", "Je hebt geen radio in je voertuig", "error")
        end
    else
        player.Functions.Notification("Tuner", "Je hebt geen radio in je voertuig", "error")
    end
end)