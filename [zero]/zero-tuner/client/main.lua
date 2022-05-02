VehiclePlacement = false
DisplaySpot = false
SpawnedObjects = {}

exports['zero-core']:object(function(O) Zero = O end)

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do 
        Wait(0)
    end

    CreateBlip()
end)

RegisterNetEvent("Zero:Client-Core:JobUpdate")
AddEventHandler("Zero:Client-Core:JobUpdate", function(JobData)
    Zero.Player.Job = JobData
end)

RegisterNetEvent("Zero:Client-Tuner:ChangedLocations")
AddEventHandler("Zero:Client-Tuner:ChangedLocations", function(x)
    for k,v in pairs(Config.SpotLocations) do
        DeleteEntity(v.created)
        v.created = nil
    end

    tunerVehicles = x
end)

RegisterNetEvent("Zero:Client-Tuner:UpdateMods")
AddEventHandler("Zero:Client-Tuner:UpdateMods", function(mods)
    if tunerVehicles then
        for k,v in pairs(tunerVehicles) do
            local props = json.decode(v.mods)
            if props.plate == mods.plate then
                v.mods = json.encode(mods)

                if (Config.SpotLocations[v.location]) then
                    if Config.SpotLocations[v.location].created then
                        Zero.Functions.SetVehicleProperties(Config.SpotLocations[v.location].created, mods)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Functions.GetPlayerData(function(PlayerData)
        Zero.Player = PlayerData
    end)

    Zero.Vars.Spawned = true
end)

RegisterNetEvent("Zero:Client-Tuner:ClaimedVehicle")
AddEventHandler("Zero:Client-Tuner:ClaimedVehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    DeleteEntity(vehicle)
end)

RegisterNetEvent("Zero:Client-Tuner:TransitionLift")
AddEventHandler("Zero:Client-Tuner:TransitionLift", function(index, height)
    LiftTransition(index, height)
end)

RegisterNetEvent("Zero:Client-Tuner:SyncLifts")
AddEventHandler("Zero:Client-Tuner:SyncLifts", function(lifts)
    
    for k,v in pairs(lifts) do
        Config.SpotLocations[k].liftHeight = v

        Config.SpotLocations[k].liftObj = GetClosestObjectOfType(Config.SpotLocations[k].x, Config.SpotLocations[k].y, Config.SpotLocations[k].z, 10.0, 399968753)

        SetEntityCoords(Config.SpotLocations[k].liftObj, Config.SpotLocations[k].x, Config.SpotLocations[k].y, Config.SpotLocations[k].liftHeight)
        if (Config.SpotLocations[k].created) then
            SetEntityCoords(Config.SpotLocations[k].created, Config.SpotLocations[k].x, Config.SpotLocations[k].y, Config.SpotLocations[k].liftHeight)
            SetEntityHeading(Config.SpotLocations[k].created, Config.SpotLocations[k].h)
        end
    end
end)


RegisterNetEvent("Zero:Client-Tuner:InstallNosFuel")
AddEventHandler("Zero:Client-Tuner:InstallNosFuel", function()
    local playerPed = PlayerPedId()
    local vehicle = Zero.Functions.closestVehicle()

    if vehicle then
        TriggerEvent("inventory:client:close")
        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
        Zero.Functions.Progressbar("repair_veh", "NOS Bijvullen..", 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {

        }, {}, {}, function() -- Done
            ClearPedTasksImmediately(PlayerPedId(), true)
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            ClearPedTasksImmediately(playerPed)

            local plate = Zero.Functions.GetVehicleProperties(vehicle).plate
            TriggerServerEvent("Zero:Server-Vehicles:RefuelNos", plate)
        end, function() -- Cancel
            ClearPedTasksImmediately(PlayerPedId(), true)
        end)
    end
end)


