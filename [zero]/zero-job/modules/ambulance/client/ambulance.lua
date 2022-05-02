isHealingPerson = false
isStatusChecking = false

healAnimDict = "mini@cpr@char_a@cpr_str"
healAnim = "cpr_pumpchest"

Modules['ambulance'] = {}
Modules['ambulance'].Functions = {} 
Modules['ambulance'].Config = {
    [1] = {
        ['loc'] = {x = 291.97, y = -586.88, z = 43.19, h = 160.90},
        ['text'] = "Garage",
        ['functie'] = "OpenGarage",
    },
    [2] = {
        ['loc'] = {x = 351.88, y = -588.13, z = 74.16, h = 251.90},
        ['text'] = "Heliplatform",
        ['functie'] = "OpenHeli",
    },
    [3] = {
        ['loc'] = {x = 306.59, y = -601.81, z = 43.29, h = 356.90},
        ['text'] = "Kloesoe",
        ['functie'] = "OpenKloesoe",
    },
    [4] = {
        ['loc'] = {x = 333.92, y = -573.87, z = 28.79, h = 356.90},
        ['text'] = "Garage",
        ['functie'] = "OpenGarage",
    },
}
Modules['ambulance'].options = {
    [1] = {
        name = "Object plaatsen", 
        action = function() 
            PlaceObject()
        end,
    },
    [2] = {
        name = "Spawn brandcard", 
        action = function() 
            TriggerEvent("stretcher:client:spawn")
        end,
    },
}

Citizen.CreateThread(function()
    local coord = {x = 303.9508972168, y = -586.47943115234, z = 43.28409576416, h = 251.71759033203}
    blip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(blip, 305)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 25)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Ambulance")
    
    EndTextCommandSetBlipName(blip)
end)



Modules['ambulance'].Run = function()
    local player = PlayerPedId()
    local coord = GetEntityCoords(player)

    for k,v in ipairs(Modules['ambulance'].Config) do
        local distance = #(coord - vector3(v.loc.x, v.loc.y, v.loc.z))

        if (distance <= 5 and distance > 1) then
            timer = 0
            
            Zero.Functions.DrawMarker(v.loc.x, v.loc.y, v.loc.z)
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, v.text)
        elseif (distance < 1) then
            timer = 0
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, "~g~E~w~ - "..v.text.."")

            if IsControlJustPressed(0, 38) then
                Modules['ambulance'].Functions[v.functie]()
            end
        end
    end
end

RegisterNetEvent("Zero:Client-Ambulance:UseHeals")
AddEventHandler("Zero:Client-Ambulance:UseHeals", function(slot, item)
    local player, distance = Zero.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        ExecuteCommand("e cpr")

        isHealingPerson = true
        Zero.Functions.Progressbar("hospital_revive", "Reviven..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {

        }, {}, {}, function() -- Done
            isHealingPerson = false
            ClearPedTasks(PlayerPedId())
            Zero.Functions.Notification("Heals", "Persoon genezen!", "success")
            TriggerServerEvent("Zero:Server-Ambulance:UseHeals", item, playerId)
        end, function() -- Cancel
            isHealingPerson = false
            ClearPedTasks(PlayerPedId())
            Zero.Functions.Notification("Heals", "Gefaald!", "error")
        end)
    else
        Zero.Functions.Notification("Heals", "Geen speler gevonden", "error")
    end
end)

--[[isHealingPersonCitizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if isHealingPerson then
            if not IsEntityPlayingAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3) then
                loadAnimDict(healAnimDict)	
                TaskPlayAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end
    end
end)]]

Modules['ambulance'].Functions['OpenGarage'] = function()
    if JobModule == "ambulance" and JobDuty then
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            DeleteEntity(GetVehiclePedIsIn(ped))
        else
            exports['zero-garages']:openMenu(Shared.Config.ambulance.Vehicles)
        end
    end
end
Modules['ambulance'].Functions['OpenHeli'] = function()
    if JobModule == "ambulance" and JobDuty then
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            DeleteEntity(GetVehiclePedIsIn(ped))
        else
            exports['zero-garages']:openMenu({
                [1] = {
                    model = "LifeLiner",
                    reason = "Ambulance Helicopter",
                    spawnmodel = "ambuheli",
                },
            }, function(models, index)
                local spawnmodel = models[index]['spawnmodel']
                local x,y,z = table.unpack(GetEntityCoords(ped))
                local h = GetEntityHeading(ped)
    
                Zero.Functions.SpawnVehicle({
                    model = spawnmodel,
                    location = {x = x, y = y, z = z, h = h},
                    teleport = true,
                    network = true,
                }, function(vehicle)
                    exports['LegacyFuel']:SetFuel(vehicle, 100)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    TriggerEvent("vehiclekeys:client:SetOwner", plate)
                end)
            end)
        end
    end
end
Modules['ambulance'].Functions['OpenKloesoe'] = function()
    TriggerServerEvent("Zero:Server-Police:OpenKloesoe")
end

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("ems-br", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        if IsEntityAnObject(entity) then
            if GetEntityModel(entity) == -935625561 then
                if distance <= 20 and Modules[JobModule] and JobDuty and JobModule == "ambulance" then
                    return true, GetEntityCoords(entity)
                end
            end
        end
    end, {
        [1] = {
            name = "Duw brancard", 
            action = function() 
                TriggerEvent("ARPF-EMS:pushstreacherss")
            end,
        },
        [2] = {
            name = "Lig op brancard", 
            action = function() 
                TriggerEvent("ARPF-EMS:getintostretcher")
            end,
        },
        [3] = {
            name = "Verwijder brancard", 
            action = function() 
                TriggerEvent("stretcher:client:delete")
            end,
        },
    }, GetCurrentResourceName())

    exports['zero-eye']:looped_runtime("br-opt", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        if IsEntityAnObject(entity) then
            if GetEntityModel(entity) == -935625561 then
                if distance <= 20 and not JobDuty or JobModule ~= "ambulance" then
                    return true, GetEntityCoords(entity)
                end
            end
        end
    end, {
        [1] = {
            name = "Lig op brancard", 
            action = function() 
                TriggerEvent("ARPF-EMS:getintostretcher")
            end,
        },
    }, GetCurrentResourceName())
end)

local ifakUsable = true
RegisterNetEvent("Zero:Client-Ambulance:Ifak")
AddEventHandler("Zero:Client-Ambulance:Ifak", function(slot)
    local player = PlayerPedId()
    local health = GetEntityHealth(player)
    
    if ifakUsable then
        if health < 180 then
            local new_health = health + 50 <= 180 and health + 50 or 180
            SetEntityHealth(player, new_health)

            ifakUsable = false

            RequestAnimDict('missfbi1')
            while not HasAnimDictLoaded('missfbi1') do
                Wait(50)
            end

            ExecuteCommand("e healthkit")
            Zero.Functions.Notification("Ifak", "Ifak gebruikt (+"..(new_health - health).." Health)", "success")

            Wait(15000)

            ifakUsable = true
        else
            Zero.Functions.Notification("Ifak", "Is niet te gebruiken onder 90% health", "error")
        end
    else
        Zero.Functions.Notification("Ifak", "Je kan deze nog niet gebruiken", "error")
    end
end)

-- loop

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)
        local distance = #(pos - vector3(Shared.Config.ambulance.Revive.x, Shared.Config.ambulance.Revive.y, Shared.Config.ambulance.Revive.z))

        if distance <= 2 then
            timer = 0

            TriggerEvent("interaction:show", "Ziekenhuis balie", function()
                local ui = exports['zero-ui']:element()
                ui.set("Ziekenhuis", {
                    {
                        label = "Inchecken",
                        subtitle = "Laat je geholpen worden door het personeel",
                        event = "Zero:Client-Ambulance:CheckIn"
                    },
                    {
                        label = "Sluiten",
                    },
                })
            end)
        end
        
        Wait(timer)
    end
end)

RegisterNetEvent("Zero:Client-Ambulance:CheckIn")
AddEventHandler("Zero:Client-Ambulance:CheckIn", function()
    TriggerServerEvent("Zero:Server-Ambulance:CheckIn")
end)

RegisterNetEvent("Zero:Client-Ambulance:ReviveInBed")
AddEventHandler("Zero:Client-Ambulance:ReviveInBed", function()
    local ply = PlayerPedId()
    local bed = {x = 323.31146240234, y = -582.41174316406, z = 43.284042358398, h = 274.8583984375}

    DoScreenFadeOut(150)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    
    SetEntityCoords(ply, bed.x, bed.y, bed.z)
    local obj = GetClosestObjectOfType(bed.x, bed.y, bed.z, 5.0, `v_med_bed1`)

    local heading = GetEntityHeading(obj) - 180.00
    SetEntityHeading(ply, heading)

    local x,y,z = table.unpack(GetEntityCoords(obj))
    SetEntityCoords(ply, x, y, z)

    SetEntityHeading(ply, GetEntityHeading(ply) - 0)
    ExecuteCommand("e sit2")

    Wait(5000)

    DoScreenFadeIn(150)

    Zero.Functions.Notification("Status", "Je bent volledig genezen van al je verwondingen")
end)
