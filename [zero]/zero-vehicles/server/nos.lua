RegisterServerEvent("Zero:Server-Vehicles:StartNOSparticles")
AddEventHandler("Zero:Server-Vehicles:StartNOSparticles", function(networkId)
    TriggerClientEvent("Zero:Client-Vehicles:StartNOSparticles", -1, networkId)
end)

RegisterServerEvent("Zero:Server-Vehicles:StopNOSparticles")
AddEventHandler("Zero:Server-Vehicles:StopNOSparticles", function(networkId)
    TriggerClientEvent("Zero:Client-Vehicles:StopNOSparticles", -1, networkId)
end)

RegisterServerEvent("Zero:Server-Vehicles:StartPurgeparticles")
AddEventHandler("Zero:Server-Vehicles:StartPurgeparticles", function(networkId)
    TriggerClientEvent("Zero:Client-Vehicles:StartPurgeparticles", -1, networkId)
end)

RegisterServerEvent("Zero:Server-Vehicles:StopPurgeparticles")
AddEventHandler("Zero:Server-Vehicles:StopPurgeparticles", function(networkId)
    TriggerClientEvent("Zero:Client-Vehicles:StopPurgeparticles", -1, networkId)
end)

RegisterServerEvent("Zero:Server-Vehicles:SaveNosFuel")
AddEventHandler("Zero:Server-Vehicles:SaveNosFuel", function(plate, fuel)
    if vehicles[plate] then
        Zero.Functions.ExecuteSQL(false, "UPDATE `modifications` SET `nos_fuel` = ? WHERE `plate` = ?", {
            fuel,
            plate
        })
        vehicles[plate]['nos_fuel'] = fuel

        TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
    end
end)

RegisterServerEvent("Zero:Server-Vehicles:RefuelNos")
AddEventHandler("Zero:Server-Vehicles:RefuelNos", function(plate)
    if vehicles[plate] then
        Zero.Functions.ExecuteSQL(false, "UPDATE `modifications` SET `nos_fuel` = ? WHERE `plate` = ?", {
            100,
            plate
        })
        vehicles[plate]['nos_fuel'] = 100

        TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
    end
end)

