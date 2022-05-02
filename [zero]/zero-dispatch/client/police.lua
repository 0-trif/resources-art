exports['zero-core']:object(function(O) Zero = O end)

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Zero.Config.Keys['F10']) then
            OpenDispatch()
        end
        Wait(0)
    end
end)

function OpenDispatch()
    local job = Zero.Functions.GetPlayerData().Job.name

    if (config.jobs[job]) then
        SendNUIMessage({
            action = "OpenDispatch",
        })

        TriggerServerEvent("Zero:Server-Dispatch:Request")

        SetNuiFocus(true, true)
    end
end

-- EVENTS

RegisterNetEvent("Zero:Client-Dispatch:Sync")
AddEventHandler("Zero:Client-Dispatch:Sync", function(vehicles, players)
    SendNUIMessage({
        action = "DispatchPlayers",
        vehicles = vehicles,
        players = players
    })
end)

RegisterNetEvent("Zero:Client-BaseEvents:LeftVehicle")
AddEventHandler("Zero:Client-BaseEvents:LeftVehicle", function(vehicle, last_plate)
    local job = Zero.Functions.GetPlayerData().Job

    if (config.jobs[job.name] and job.duty) then
        local plate = GetVehicleNumberPlateText(vehicle)
        if not plate then
            plate = last_plate
        end

        TriggerServerEvent("Zero:Server-Dispatch:LeftVehicle", plate)
    end
end)

RegisterNetEvent("Zero:Client-BaseEvents:EnteredVehicle")
AddEventHandler("Zero:Client-BaseEvents:EnteredVehicle", function(vehicle)
    local job = Zero.Functions.GetPlayerData().Job

    if (config.jobs[job.name] and job.duty) then
        local plate = GetVehicleNumberPlateText(vehicle)
        local type = GetVehicleClass(vehicle)
        TriggerServerEvent("Zero:Server-Dispatch:InVehicle", plate, type)
    end
end)

-- NUI

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("loc", function(ui)
    local x,y = tonumber(ui.x), tonumber(ui.y)
    TriggerEvent("InteractSound_CL:PlayOnOne", "notif", 0.1)
    SetNewWaypoint(x, y)
end)

RegisterNetEvent("Zero:Client-Dispatch:Alert")
AddEventHandler("Zero:Client-Dispatch:Alert", function(job, data)
    local plyjob = Zero.Functions.GetPlayerData().Job

    if plyjob.name == job and plyjob.duty then
        TriggerEvent("InteractSound_CL:PlayOnOne", "dispatch", 0.1)

        SendNUIMessage({
            action = "createAlert",
            data = data,
        })
    end
end)