RegisterCommand("play", function(src, args)
    local url = args[1]
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped)
        local plate = GetVehicleNumberPlateText(vehicle)

        TriggerServerEvent("Zero:Server-Vehicles:SetRadio", plate, url)
    end
end)

radioCache = {}

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("music-veh", function(coords, entity)
        local player = PlayerPedId()
        if (IsPedInAnyVehicle(player)) then
            local vehicle = GetVehiclePedIsIn(player)
            local plate = GetVehicleNumberPlateText(vehicle)

            if (vehicles[plate]) then
                if (vehicles[plate].radioUrl) then
                    return true
                end
            end
        end
    end, {
        [1] = {
            name = "Muziek opties", 
            action = function()
                local options = {
                    [1] = {
                        name = "Muziek hervatten", 
                        action = function()
                            local vehicle = GetVehiclePedIsIn(PlayerPedId())
                            local plate = GetVehicleNumberPlateText(vehicle)
                
                            TriggerServerEvent("Zero:Server-Vehicles:SetRadio", plate, radioCache[plate])
                        end,
                    },
                    [2] = {
                        name = "Muziek stoppen", 
                        action = function()
                            local vehicle = GetVehiclePedIsIn(PlayerPedId())
                            local plate = GetVehicleNumberPlateText(vehicle)
                            radioCache[plate] = vehicles[plate].radioUrl
                            TriggerServerEvent("Zero:Server-Vehicles:SetRadio", plate, "")
                        end,
                    },
                }
                exports['zero-eye']:ForceOptions("music", options, GetCurrentResourceName())
            end,
        },
    }, GetCurrentResourceName(), 5)
end)