local IN_VEHICLE = {}

RegisterServerEvent("Zero:Server-BaseEvents:EnteredVehicle")
AddEventHandler("Zero:Server-BaseEvents:EnteredVehicle", function(plate, seating)
    local src = source
    
    IN_VEHICLE[plate] = IN_VEHICLE[plate] ~= nil and IN_VEHICLE[plate] or {}
    
    IN_VEHICLE[plate][src] = {
        seat = seating,
    }
end)

RegisterServerEvent("Zero:Server-BaseEvents:LeftVehicle")
AddEventHandler("Zero:Server-BaseEvents:LeftVehicle", function(plate)
    local src = source
    if IN_VEHICLE[plate] then IN_VEHICLE[plate][src] = nil end
end)


RegisterServerEvent("Zero:Server-BaseEvents:PlayersInVehicle")
AddEventHandler("Zero:Server-BaseEvents:PlayersInVehicle", function(plate, cb)
    if IN_VEHICLE[plate] then
        cb(IN_VEHICLE[plate])
    else
        cb({})
    end
end)
