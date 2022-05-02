exports["zero-core"]:object(function(O) Zero = O end)

RegisterServerEvent("Zero:Server-Garages:ParkVehicle")
AddEventHandler("Zero:Server-Garages:ParkVehicle", function(plate, index, fuel, location, bool)
    local src = source
    local Player = Zero.Functions.Player(src)

    Player.Functions.SetVehicleLocation(plate, index, fuel, location)

    if bool then
        Player.Functions.ValidRemove(Config.transferPrice, 'Voertuig ('..plate..') overgezet naar de '..index..' garage', function()
            
        end)
    end
end)

RegisterServerEvent("Zero:Server-Garages:SetSpot")
AddEventHandler("Zero:Server-Garages:SetSpot", function(plate, spot)
    local src = source
    local Player = Zero.Functions.Player(src)

    Player.Functions.SetVehicleSpot(plate, spot)
end)

RegisterServerEvent("Zero:Server-Garage:PayImpound")
AddEventHandler("Zero:Server-Garage:PayImpound", function()
    local src = source
    local Player = Zero.Functions.Player(src)
    
    Player.Functions.RemoveMoney("bank", Config.ImpoundPrice, "Impounded vehicle terug betaald.")
    Player.Functions.Notification("Impound", "Je hebt "..Config.ImpoundPrice.." betaald voor je voertuig", "success", 5000)
end)