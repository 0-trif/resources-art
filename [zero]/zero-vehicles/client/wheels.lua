exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

syncing = false
vehicles = {}

exports("setWheelData", function(plate, data)
    if plate and data then
        TriggerServerEvent('Zero:Server-Vehicles:SetWheelData', plate, data)
    end
end)

RegisterNetEvent("Zero:Client-Vehicles:SyncVehicles")
AddEventHandler("Zero:Client-Vehicles:SyncVehicles", function(x)
    vehicles = x
end)
RegisterNetEvent("Zero:Client-Vehicles:SyncOneVehicle")
AddEventHandler("Zero:Client-Vehicles:SyncOneVehicle", function(x, y)
    vehicles[x] = y

    if vehicles[x].radioUrl ~= playing[x] then
        playing[x] = nil
    end
end)
RegisterNetEvent("Zero:Client-Vehicles:ToggleTunings")
AddEventHandler("Zero:Client-Vehicles:ToggleTunings", function(bool)
    toggled = bool
end)

toggled = false

Citizen.CreateThread(function()
    while true do
        area_vehicles = Zero.Functions.GetVehicles()
        Citizen.Wait(2000)

        for k,v in pairs(vehicles) do
            if v.entity and not DoesEntityExist(v.entity) then
                exports['xsound']:Destroy(k .. "-radio")
                
                if vehicles[plate] then
                    vehicles[plate].playing = false
                end
            end
        end
    end
end)

playing = {}

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do Wait(0) end
    TriggerServerEvent("Zero:Server-Vehicles:RequestMods")

    while true do
        local player = PlayerPedId()
        local pos = GetEntityCoords(player)

        if not toggled then
            for k,v in pairs(area_vehicles) do
                local coord = GetEntityCoords(v)
                local distance = #(coord - pos)
                if (distance < 30) then

                    local plate = GetVehicleNumberPlateText(v)
                 
                    if (vehicles[plate]) then
                        applyVehicleWheelData(v, vehicles[plate])

 
                        if vehicles[plate].radioUrl then
                              
                            if vehicles[plate].radioUrl and not playing[plate] then
                                playing[plate] = vehicles[plate].radioUrl

                                exports['xsound']:PlayUrlPos(plate .. "-radio", vehicles[plate].radioUrl, 0.2, coord)

                                vehicles[plate].entity = v
                            else
                                exports['xsound']:Position(plate .. "-radio", coord)
                            end
                        else
                            playing[plate] = nil
                            exports['xsound']:Destroy(plate .. "-radio")
                        end
                    end
                end      
            end
        end

        Citizen.Wait(0)
    end
end)

function applyVehicleWheelData(vehicle, data)
    if data.wheeldata then
        SetVehicleWheelXOffset(vehicle, 1, data.wheeldata.front_right_width)
        SetVehicleWheelXOffset(vehicle, 0, data.wheeldata.front_left_width)

        SetVehicleWheelXOffset(vehicle, 2, data.wheeldata.back_right_width)
        SetVehicleWheelXOffset(vehicle, 3, data.wheeldata.back_left_width)

        SetVehicleWheelYRotation(vehicle, 1, data.wheeldata.front_right_rot)
        SetVehicleWheelYRotation(vehicle, 0, data.wheeldata.front_left_rot)

        SetVehicleWheelYRotation(vehicle, 2, data.wheeldata.back_right_rot)
        SetVehicleWheelYRotation(vehicle, 3, data.wheeldata.back_left_rot)
    end
end