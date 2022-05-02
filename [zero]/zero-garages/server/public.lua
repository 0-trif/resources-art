RegisterServerEvent("Zero:Server-Garages:ParkVehicle")
AddEventHandler("Zero:Server-Garages:ParkVehicle", function(plate, index, fuel)
    local src = source
    local Player = Zero.Functions.Player(src)

    Player.Functions.SetVehicleLocation(plate, index, fuel)
end)