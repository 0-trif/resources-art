local ObjectList = {}


function GetCoords()
    local ply = PlayerPedId()
    local pos = GetEntityCoords(ply)

    return {
        x = pos.x,
        y = pos.y,
        z = pos.z,
        h = GetEntityHeading(ply)
    }
end

RegisterNetEvent('police:client:spawnCone')
AddEventHandler('police:client:spawnCone', function()
    Zero.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "cone", GetCoords())
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Zero.Functions.Notification("Object plaatsen", "Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnBarier')
AddEventHandler('police:client:spawnBarier', function()
    Zero.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "barier", GetCoords())
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Zero.Functions.Notification("Object plaatsen", "Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnSchotten')
AddEventHandler('police:client:spawnSchotten', function()
    Zero.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "schotten", GetCoords())
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Zero.Functions.Notification("Object plaatsen", "Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnTent')
AddEventHandler('police:client:spawnTent', function()
    Zero.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "tent", GetCoords())
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Zero.Functions.Notification("Object plaatsen", "Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnLight')
AddEventHandler('police:client:spawnLight', function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    Zero.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "light", GetCoords())
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Zero.Functions.Notification("Object plaatsen", "Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('police:client:spawnSpike')
AddEventHandler('police:client:spawnSpike', function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    Zero.Functions.Progressbar("spawn_object", "Object plaatsen..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("police:server:spawnObject", "spike", GetCoords())
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        Zero.Functions.Notification("Object plaatsen", "Geannuleerd..", "error")
    end)
end)


RegisterNetEvent('police:client:deleteObject')
AddEventHandler('police:client:deleteObject', function()
    local objectId, dist = GetClosestPoliceObject()
    if dist then
        if dist < 5.0 then
            Zero.Functions.Progressbar("remove_object", "Object verwijderen..", 2500, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                anim = "plant_floor",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
                TriggerServerEvent("police:server:deleteObject", objectId)
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
                Zero.Functions.Notification("Object plaatsen", "Geannuleerd..", "error")
            end)
        end
    end
end)

RegisterNetEvent('police:client:removeObject')
AddEventHandler('police:client:removeObject', function(objectId)
    NetworkRequestControlOfEntity(ObjectList[objectId].object)
    DeleteObject(ObjectList[objectId].object)
    ObjectList[objectId] = nil
end)

RegisterNetEvent('police:client:spawnObject')
AddEventHandler('police:client:spawnObject', function(objectId, type, player, coords)
    local heading = coords.h
    local coords = vector3(coords.x, coords.y, coords.z)
    

    local forward = GetEntityForwardVector(GetPlayerPed(-1))
    local x, y, z = table.unpack(coords + forward * 0.5)

    ObjectList[objectId] = {
        id = objectId,
        model = Modules['police'].Objects[type].model,
        freeze = Modules['police'].Objects[type].freeze,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
            h = h,
        },
    }
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(ObjectList) do
            if v.object and not DoesEntityExist(v.object) then
                v.object = nil
            end

            if not v.object then
                local pos = GetEntityCoords(PlayerPedId())
                local distance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))

                if distance <= 20 then
                    local spawnedObj = CreateObject(v.model, v.coords.x, v.coords.y, v.coords.z, false, false, false)
                    PlaceObjectOnGroundProperly(spawnedObj)
                    SetEntityHeading(spawnedObj, heading)
                    FreezeEntityPosition(spawnedObj, v.freeze)

                    v.object = spawnedObj
                end
            end
        end
        Citizen.Wait(750)
    end
end)

SpikeModules = {}
SpikeModules['police'] = {
    MaxSpikes = 5
}

function GetClosestPoliceObject()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, data in pairs(ObjectList) do
        if current ~= nil then
     
            if (#(pos - vector3(ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z)) < dist)then
                current = id
                dist = #(pos - vector3(ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z))
            end
        else
            dist = #(pos - vector3(ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z))
            current = id
        end
    end
    return current, dist
end


local SpawnedSpikes = {}
local spikemodel = "P_ld_stinger_s"
local nearSpikes = false
local spikesSpawned = false
local ClosestSpike = nil

Citizen.CreateThread(function()
    while true do

        if Zero.Vars.Spawned then
            GetClosestSpike()
        end

        Citizen.Wait(500)
    end
end)

function GetClosestSpike()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local x,y,z = table.unpack(pos)

    ClosestSpike = GetClosestObjectOfType(x,y,z, 15.0, GetHashKey(spikemodel), 1, 1, 1)
end


Citizen.CreateThread(function()
    while true do
        if Zero.Vars.Spawned then
            if ClosestSpike ~= 0 then
                local tires = {
                    {bone = "wheel_lf", index = 0},
                    {bone = "wheel_rf", index = 1},
                    {bone = "wheel_lm", index = 2},
                    {bone = "wheel_rm", index = 3},
                    {bone = "wheel_lr", index = 4},
                    {bone = "wheel_rr", index = 5}
                }

                for a = 1, #tires do
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                    if tirePos then
                        local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 15.0, GetHashKey(spikemodel), 1, 1, 1)
                        local spikePos = GetEntityCoords(spike, false)
                        local distance = Vdist(tirePos.x, tirePos.y, tirePos.z, spikePos.x, spikePos.y, spikePos.z)

                        if distance < 1.8 then
                            if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                                SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                            end
                        end
                    end
                end
            else
                Citizen.Wait(759)
            end
        end

        Citizen.Wait(3)
    end
end)
