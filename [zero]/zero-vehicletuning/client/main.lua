-- CODE FOR TUNING STORES ON Zero ROLEPLAY (value.01).
RegisterNetEvent("tuner:open")
AddEventHandler("tuner:open", function()
    OpenTuningMenu()
end)

Citizen.CreateThread(function()
    for key, value in pairs(Config.Locations) do
        blip = AddBlipForCoord(value.x, value.y, value.z)
        SetBlipSprite(blip, 446)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.65)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 2)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Benny's Tuner")
        
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)

        if not (insideTuning) then
            for key, value in pairs(Config.Locations) do
                local distance = #(position - vector3(value.x, value.y, value.z))

                if (distance <= 25) then
                    timer = 0
                    local inVehicle = IsPedInAnyVehicle(ply)
                    
                    if (inVehicle) then
                        if (distance <= 25 and distance > 2) then
                            DrawMarker(21, value.x, value.y, value.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 255, 255, 255, true, false, 2, true, nil, nil, false)
                        elseif (distance <= 2) then
                            xDrawText(value.x, value.y, value.z + 0.5, "~g~ENTER~w~ - Start tuning")

                            if IsControlJustPressed(0, 18) then
                                last_id, last_val = key, value

                                exports['zero-ui']:element(function(ui)
                                    ui.set("Benny's", {
                                        {
                                            label = "Repair",
                                            subtitle = "Repareer je voertuig voor 800$",
                                            event = "mechanic:payed:repair",
                                        },
                                        {
                                            label = "Benny's",
                                            subtitle = "Open voertuig tuning",
                                            event = "bennys:open:normal",
                                        },
                                        {
                                            label = "Sluiten",
                                            subtitle = "Sluit menu",
                                            event = "ui:close",
                                        },
                                    })
                                end)
                            end
                        end
                    end
                end
            end
        else
            local vehicle = insideVehicle
            if ( vehicle ) then 
                SetEntityLocallyVisible(vehicle) 
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
            end

            if ( SyncAbleParts ) then
                SyncPartPositions(SyncAbleParts, vehicle)
            end

            timer = 0
        end

        Citizen.Wait(timer)
    end
end)

RegisterNetEvent("bennys:open:normal")
AddEventHandler("bennys:open:normal", function()
    TriggerEvent("ui:close")
    if last_id and last_val then
        OpenTuningMenu(last_id, last_val)
    end
end)

Citizen.CreateThread(function()
    while true do
        if insideTuning then
            TuningPartPresses(insideVehicle)
        else
            Citizen.Wait(1000)
        end
        Wait(0)
    end
end)
-- loop for displaying stores on the map



RegisterCommand("turbo", function()
    ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()),  18, true)
end)