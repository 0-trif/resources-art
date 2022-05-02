function openDoorsMenu(vehicle)
    local doors = GetNumberOfVehicleDoors(vehicle)
    local _ = {}

    if doors == 4 then
        _[1] = {
            name = "Voordeur links", 
            action = function()
                toggleVehicleDoor(vehicle, 0)
            end,
        }
        _[2] = {
            name = "Voordeur rechts", 
            action = function()
                toggleVehicleDoor(vehicle, 1)
            end,
        }
        _[3] = {
            name = "Motorkap", 
            action = function()
                toggleVehicleDoor(vehicle, 4)
            end,
        }
        _[4] = {
            name = "Kofferbak", 
            action = function()
                toggleVehicleDoor(vehicle, 5)
            end,
        }
    else
        _[1] = {
            name = "Voordeur links", 
            action = function()
                toggleVehicleDoor(vehicle, 0)
            end,
        }
        _[2] = {
            name = "Voordeur rechts", 
            action = function()
                toggleVehicleDoor(vehicle, 1)
            end,
        }
        _[3] = {
            name = "Achterdeur links", 
            action = function()
                toggleVehicleDoor(vehicle, 2)
            end,
        }
        _[4] = {
            name = "Achterdeur right", 
            action = function()
                toggleVehicleDoor(vehicle, 3)
            end,
        }
        _[5] = {
            name = "Motorkap", 
            action = function()
                toggleVehicleDoor(vehicle, 4)
            end,
        }
        _[6] = {
            name = "Kofferbak", 
            action = function()
                toggleVehicleDoor(vehicle, 5)
            end,
        }
    end

    exports['zero-eye']:ForceOptions("DoorsNeef", _, GetCurrentResourceName())
end

function toggleVehicleDoor(vehicle, index)
    NetworkRequestControlOfDoor(index)

    if (GetVehicleDoorAngleRatio(vehicle, index) > 0.1) then
        SetVehicleDoorShut(vehicle, index, false)
    else
        SetVehicleDoorOpen(vehicle, index, false, false)
    end
end

function openExtraMenu(vehicle)
    _ = {
    }


    for i = 1, 20 do
        if DoesExtraExist(vehicle, i) then
            table.insert(_, {
                name = "Extra ("..i..")",
                action = function()
                    if IsVehicleExtraTurnedOn(vehicle, i) then
                        SetVehicleExtra(vehicle, i, true)
                    else
                        SetVehicleExtra(vehicle, i, false)
                    end
                end
            })
        end
    end
    exports['zero-eye']:ForceOptions("VehicleExtras", _, GetCurrentResourceName())
end

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("vehicle-opts", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        if (IsPedInAnyVehicle(player)) then
            if (GetPedInVehicleSeat(GetVehiclePedIsIn(player), -1) == player) then
                return true
            end
        end
    end, {
        [1] = {
            name = "Voertuig deuren", 
            action = function()
                local veh = GetVehiclePedIsIn(PlayerPedId()) 
                openDoorsMenu(veh)
            end,
        },
        [2] = {
            name = "Voertuig motor", 
            action = function() 
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                local options = {
                    [1] = {
                        name = "Engine aan", 
                        action = function() 
                            SetVehicleRadioEnabled(vehicle, false)
                            SetVehicleEngineOn(vehicle, true, false, true)
                        end,
                    },
                    [2]= {
                        name = "Engine uit", 
                        action = function() 
                            SetVehicleEngineOn(vehicle, false, false, true)
                        end,
                    },
                }
                exports['zero-eye']:ForceOptions("vehicleNiffauws", options, GetCurrentResourceName())
            end,
        },
        [3] = {
            name = "Voertuig Extra's", 
            action = function() 
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                openExtraMenu(vehicle)
            end,
        },
    }, GetCurrentResourceName(), 5)

    exports['zero-eye']:looped_runtime("vehicle-flatbed", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        if (IsEntityAVehicle(entity) and (GetEntityModel(entity) == `flatbed` or GetEntityModel(entity) == `flatbed3`)) then
            return true, GetEntityCoords(entity)
        end
    end, {
        [1] = {
            name = "Voertuig vastmaken", 
            action = function(entity)
                attachVehicle(entity, GetEntityModel(entity) == `flatbed3`)
            end,
        },
        [2] = {
            name = "Voertuig losmaken", 
            action = function(entity)
                local veh = GetVehiclePedIsIn(PlayerPedId()) 
                detachVehicle(entity, GetEntityModel(entity) == `flatbed3`)
            end,
        },
    }, GetCurrentResourceName(), 5)
end)

attachments = {}

function attachVehicle(entity, mechanic)
    local vehicle = Zero.Functions.closestVehicle()
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))

    NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(vehicle))

    if (vehicle ~= entity and distance <= 5) then
        attachments[entity] = vehicle
        if mechanic then
            AttachEntityToEntity(vehicle, entity, 20, -0.0, 3.5, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        else
            AttachEntityToEntity(vehicle, entity, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        end
    end
end

function detachVehicle(entity)
    if attachments[entity] then
        NetworkRequestControlOfNetworkId(VehToNet(attachments[entity]))
        NetworkRequestControlOfNetworkId(VehToNet(entity))

        AttachEntityToEntity(attachments[entity], entity, 20, -0.5, -4.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        DetachEntity(attachments[entity], true, true)
        attachments[entity] = nil
    end
end

-- vehicle lockpick