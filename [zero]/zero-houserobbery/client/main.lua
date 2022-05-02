RegisterNetEvent("Zero:Client-Houserobbery:SetData")
AddEventHandler("Zero:Client-Houserobbery:SetData", function(id, data)
    config.locations[id] = data
    RefreshBlips()
end)

RegisterNetEvent("Zero:Client-Houserobbery:Sync")
AddEventHandler("Zero:Client-Houserobbery:Sync", function(data)
    config.locations = data
    RefreshBlips()
end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

-- startup
Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end

    TriggerServerEvent("Zero:Server-Houserobbery:Sync")
end)

-- main run
RegisterNetEvent("lockpicks:UseLockpick")
AddEventHandler("lockpicks:UseLockpick", function()
    if closest_door ~= nil then
        if config.locations[closest_door].locked then
            UseDoorlock(closest_door)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750

        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)


        if not config.vars.inside then
            for k,v in pairs(config.locations) do
                if v.enabled then
                    local distance = #(position - vector3(v.x, v.y, v.z))

                    if distance <= 1.3 then
                        timer = 0

                        if v.locked then
                            closest_door = k
                            TriggerEvent("Zero:Client-Inventory:DisplayUsable", "lockpick")
                        else
                            closest_door = k
                            TriggerEvent("interaction:show", "Binnengaan", function()
                                EnterHouse(closest_door)
                            end)
                        end
                    else
                        if k == closest_door then
                            closest_door = nil
                        end
                    end
                end
            end
        else
            timer = 0 
            local index = config.vars.insideIndex
            local level = config.locations[index]['level']
            local exit_distance  = #(config.vars.exit - position)

            if exit_distance <= 1.5 then
                TriggerEvent("interaction:show", "Verlaten", function()
                    LeaveBuilding()
                end)
            end  
            
            for k,searched in pairs(config.locations[index].spots) do
                local coord = GetOffsetFromEntityInWorldCoords(config.vars.house, config.data[level].search[k].x, config.data[level].search[k].y, config.data[level].search[k].z)
                local distance = #(position - vector3(coord.x,coord.y,coord.z + 1))

                if distance <= 7 then
                    if not searched then
                        if distance <= 1 then
                            Zero.Functions.DrawText(coord.x,coord.y,coord.z + 1, '~g~E~w~ - Zoeken')
                            if IsControlJustPressed(0, Zero.Config.Keys['E']) then
                                SearchIndex(k)
                            end
                        else
                            Zero.Functions.DrawText(coord.x,coord.y,coord.z + 1, 'Zoeken')
                        end
                    else
                        Zero.Functions.DrawText(coord.x,coord.y,coord.z + 1, 'Leeg..')
                    end
                end
            end

            local safe = config.locations[index]['safe']

            if safe then
                local offset = GetOffsetFromEntityInWorldCoords(config.vars.house, safe.offset.x, safe.offset.y, safe.offset.z)
                local distance = #(position - offset)

                if not DoesEntityExist(safeObject) then
                    safeObject = CreateSafe(offset.x, offset.y, offset.z, safe.offset.h)
                    PlaceObjectOnGroundProperly(safeObject)
                end

                if distance <= 1.5 then
                    if safe.opened then
                        Zero.Functions.DrawText(offset.x, offset.y, offset.z + 1, 'Geopend..')
                    else
                        Zero.Functions.DrawText(offset.x, offset.y, offset.z + 1, 'Gesloten')

                        if IsControlJustPressed(0, Zero.Config.Keys['E']) then
                            SendNUIMessage({
                                action = "open"
                            })
                            SetNuiFocus(true, true)
                        end
                    end
                end
            end
        end

        Wait(timer)
    end
end)

-- UI
RegisterNUICallback("closed", function()
    SetNuiFocus(false, false)
end)
RegisterNUICallback("applyCode", function(ui)
    local code = ui.code
    local code = tonumber(ui.code)

    if code then
        if (config.locations[config.vars.insideIndex]['safe']['code'] == code) then
            ExecuteCommand("e mechanic3")
            Zero.Functions.Progressbar("search_vault", "Kluis openen..", 15000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
            }, {}, {}, function() -- Done
                ExecuteCommand('e c')
                TriggerServerEvent("Zero:Server-Houserobbery:SearchVault", config.vars.insideIndex)
            end, function() -- Cancel
                ExecuteCommand('e c')
            end)
        else
            Zero.Functions.Notification('Kluis', 'Code klopt niet', 'error')
        end
    end
end)