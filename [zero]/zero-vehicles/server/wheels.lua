exports["zero-core"]:object(function(O) Zero = O end)

vehicles = {}

Citizen.CreateThread(function()
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `modifications`", {}, function(result)
        _ = result

        for k,v in pairs(_) do
            vehicles[v.plate] = {
                wheeldata = json.decode(v.wheeldata) ~= nil and json.decode(v.wheeldata) or nil,
                nos = v.nos ~= 0 and true or false,
                fuel = tonumber(v.fuel),
                nos_fuel = tonumber(v.nos_fuel),
                ['2step'] = v['2step'] ~= 0 and true or false,
                ['radio'] = v['radio'] ~= 0 and true or false,
            }
        end

        TriggerClientEvent("Zero:Client-Vehicles:SyncVehicles", -1, vehicles)
    end)
end)

RegisterServerEvent("Zero:Server-Vehicles:RequestMods")
AddEventHandler("Zero:Server-Vehicles:RequestMods", function()
    TriggerClientEvent("Zero:Client-Vehicles:SyncVehicles", source, vehicles)
end)

function OwnedVehicle(plate)
    bool = false
    Zero.Functions.ExecuteSQL(true, 'SELECT * FROM `citizen_vehicles` WHERE `plate` = ?', {
        plate
    }, function(result)
        if (result[1]) then
            bool = true
        else
            bool = false
        end
    end)
    print(bool)
    return bool
end

RegisterServerEvent("Zero:Server-Vehicles:NosInstalled")
AddEventHandler("Zero:Server-Vehicles:NosInstalled", function(plate)
    if OwnedVehicle(plate) then
        if (vehicles[plate]) then
            Zero.Functions.ExecuteSQL(true, "UPDATE `modifications` SET `nos` = ? WHERE `plate` = ?", {
                true,
                plate,
            })
            vehicles[plate]['nos'] = true
            vehicles[plate]['nos_fuel'] = 0
            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        else
            Zero.Functions.ExecuteSQL(true, "INSERT INTO `modifications` (`plate`, `nos`) VALUES (?, ?)", {
                plate, 
                true,
            })

            vehicles[plate] = {}
            vehicles[plate]['nos'] = true
            vehicles[plate]['nos_fuel'] = 0
            vehicles[plate]['2step'] = false
            vehicles[plate]['wheeldata'] = nil

            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        end
    end
end)


RegisterServerEvent("Zero:Server-Vehicles:InstallCarradio")
AddEventHandler("Zero:Server-Vehicles:InstallCarradio", function(plate)
    if OwnedVehicle(plate) then
        if (vehicles[plate]) then
            Zero.Functions.ExecuteSQL(true, "UPDATE `modifications` SET `radio` = ? WHERE `plate` = ?", {
                true,
                plate,
            })
            vehicles[plate]['radio'] = true
            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        else
            Zero.Functions.ExecuteSQL(true, "INSERT INTO `modifications` (`plate`, `radio`) VALUES (?, ?)", {
                plate, 
                true,
            })

            vehicles[plate] = {}
            vehicles[plate]['2step'] = false
            vehicles[plate]['nos'] = false
            vehicles[plate]['radio'] = true
            vehicles[plate]['wheeldata'] = nil

            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        end
    end
end)

RegisterServerEvent("Zero:Server-Vehicles:Install2step")
AddEventHandler("Zero:Server-Vehicles:Install2step", function(plate)
    if OwnedVehicle(plate) then
        if (vehicles[plate]) then
            Zero.Functions.ExecuteSQL(true, "UPDATE `modifications` SET `2step` = ? WHERE `plate` = ?", {
                true,
                plate,
            })
            vehicles[plate]['2step'] = true
            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        else
            Zero.Functions.ExecuteSQL(true, "INSERT INTO `modifications` (`plate`, `2step`) VALUES (?, ?)", {
                plate, 
                true,
            })

            vehicles[plate] = {}
            vehicles[plate]['2step'] = true
            vehicles[plate]['nos'] = false
            vehicles[plate]['wheeldata'] = nil

            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        end
    end
end)


RegisterServerEvent("Zero:Server-Vehicles:ResetWheels")
AddEventHandler("Zero:Server-Vehicles:ResetWheels", function(plate)
    if (vehicles[plate]) then
        vehicles[plate]['wheeldata'] = nil

        TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        Zero.Functions.ExecuteSQL(true, "UPDATE `modifications` SET `wheeldata` = ? WHERE `plate` = ?", {
            "",
            plate,
        })
    end
end)

RegisterServerEvent("Zero:Server-Vehicles:SetWheelData")
AddEventHandler("Zero:Server-Vehicles:SetWheelData", function(plate, data)
    local src = source
    local Player = Zero.Functions.Player(src)

    if OwnedVehicle(plate) then
        if (vehicles[plate]) then
            vehicles[plate]['wheeldata'] = data

            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])

            Zero.Functions.ExecuteSQL(true, "UPDATE `modifications` SET `wheeldata` = ? WHERE `plate` = ?", {
                json.encode(data),
                plate,
            })
        else
            Zero.Functions.ExecuteSQL(true, "INSERT INTO `modifications` (`plate`, `wheeldata`) VALUES (?, ?)", {
                plate, 
                json.encode(data),
            })

            vehicles[plate] = {}
            vehicles[plate]['wheeldata'] = data

            TriggerClientEvent("Zero:Client-Vehicles:SyncOneVehicle", -1, plate, vehicles[plate])
        end
    end
end)

