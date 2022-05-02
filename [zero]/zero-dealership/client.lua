CreateThread(function()
    for k,v in pairs(config.locations) do
        if v.label then
            local x,y,z = v.coord.x, v.coord.y, v.coord.z
            local blip = AddBlipForCoord(x, y, z)
        
            SetBlipSprite (blip, 595)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 0.65)
            SetBlipAsShortRange(blip, true)
            SetBlipColour(blip, 4)
        
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)


CreateThread(function()
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)

        if not insideStore then
            for k,v in pairs(config.locations) do
                if v.show then
                    local distance = #(v.coord - position)
                    if distance <= 10 then
                        timer = 0

                        Zero.Functions.DrawMarker(v.coord.x, v.coord.y, v.coord.z)

                        if distance <= 5 then
                            TriggerEvent("interaction:show", "E - Dealership openen", function()
                                OpenDealership(k)
                            end)
                        end
                    end
                end
            end
        end
        
        Wait(timer)
    end
end)

RegisterNetEvent("dealer:open")
AddEventHandler("dealer:open", function(index)
    OpenDealership(index)
end)

function OpenDealership(index)
    last_index = index

    local vehicles = config.locations[index]['classes']

    local _ = {}
    for k,v in pairs(vehicles[1].vehicles) do
        config.vehicles[v] = config.vehicles[v] ~= nil and config.vehicles[v] or {label = "unknown", price = 0, speed = 0}

        _[v] = {
            model = v,
            price = config.vehicles[v]['price'],
            label = config.vehicles[v]['label'],
            speed = config.vehicles[v]['speed']
        }
    end
    
    TriggerEvent("Zero:Client-Hud:Toggle", true)

    insideStore = true

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "showmenu", 
        vehicles = _,
    })
    SendNUIMessage({
        action = "setupclasses", 
        classes = vehicles,
    })
    SendNUIMessage({
        action = "currentClass", 
        label = vehicles[1].label,
    })
    Zero.Functions.HidePlayers(true)
    

    SetupCam(index)
end

function SetupCam(index)
    local coord = config.locations[index].cam
    local display = config.locations[index].display

    SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z)
    SetEntityVisible(PlayerPedId(), false)

    camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 0, true, true)
    SetCamCoord(camera, coord.x, coord.y, coord.z)
    PointCamAtCoord(camera, display.x, display.y, display.z)

  --  Citizen.InvokeNative(0xBA3D65906822BED5, 100.00, 2.0, 0.0, 0.0, 0.0, 8.0)
end

-- NUI

RegisterNUICallback("close", function()
    if last_index then
        SetNuiFocus(false, false)
        RenderScriptCams(false, false, 0, false, false)
        DestroyAllCams()

        local x,y,z = config.locations[last_index].coord.x, config.locations[last_index].coord.y, config.locations[last_index].coord.z

        SetEntityVisible(PlayerPedId(), true)
        SetEntityCoords(PlayerPedId(), x, y, z)

        insideStore = false
        vehicle_store_model = nil

        if DoesEntityExist(dealervehicle) then
            DeleteVehicle(dealervehicle)
        end

        Zero.Functions.HidePlayers(false)
    --    Citizen.InvokeNative(0xBA3D65906822BED5, 0.1, 0.1, 0.0, 0.0, 0.0, 300.0)

        Citizen.Wait(2500)
        TriggerEvent("Zero:Client-Hud:Toggle", false)

    end
end)

RegisterNUICallback("class", function(ui, cb)
    local index = tonumber(ui.class) + 1

    if last_index then
        SendNUIMessage({
            action = "currentClass", 
            label = config.locations[last_index].classes[index].label,
        })

        local _ = {}
        local vehicles = config.locations[last_index].classes[index].vehicles

        for k,v in pairs(vehicles) do
            config.vehicles[v] = config.vehicles[v] ~= nil and config.vehicles[v] or {label = "unknown", price = 0, speed = 0}
            _[v] = {
                model = v,
                price = config.vehicles[v]['price'],
                label = config.vehicles[v]['label'],
                speed = config.vehicles[v]['speed']
            }
        end

        cb(_)
    end
end)

RegisterNUICallback("vehicle", function(ui)
    local model = ui.model

    
    if IsModelValid(model) then
        if DoesEntityExist(dealervehicle) then
            local model = GetEntityModel(dealervehicle)
            SetModelAsNoLongerNeeded(model)
            
            DeleteVehicle(dealervehicle)
        end

        PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)

        vehicle_store_model = model
    end
end)

RegisterNUICallback("buyScreen", function(ui, cb)
    local model = ui.model

    cb(config.vehicles[model])
end)

RegisterNUICallback("buy", function(ui, cb)
    if vehicle_store_model then
        if config.vehicles[vehicle_store_model] then
            local Money = Zero.Functions.GetPlayerData().Money

            if Money['bank'] >= config.vehicles[vehicle_store_model]['price'] or Money['cash'] >= config.vehicles[vehicle_store_model]['price'] then

                local model = vehicle_store_model

                SpawnVehicleBuy(last_index, model)
                
            else
                Zero.Functions.Notification('PDM', 'Je hebt niet genoeg geld', 'error')
            end
        end
    end
end)

RegisterNUICallback("testdrive", function(ui)
    local model = ui.model
    local index = last_index

    if model then
        if (config.vehicles[model]) then
            DoScreenFadeOut(150)

            while not IsScreenFadedOut() do
                Wait(0)
            end
        
            SetNuiFocus(false, false)
            RenderScriptCams(false, false, 0, false, false)
            DestroyAllCams()
            SetEntityVisible(PlayerPedId(), true)
        
            insideStore = false
            vehicle_store_model = nil
        
            if DoesEntityExist(dealervehicle) then
                DeleteVehicle(dealervehicle)
            end
            
            local coord = config.locations[index].spawn
        
            Zero.Functions.SpawnVehicle({
                model = model,
                location = {x = coord.x, y = coord.y, z = coord.z, h = coord.h},
                teleport = true,
                network = true,
            }, function(vehicle)
                test_vehicle = vehicle
            end)
        
            TriggerEvent("InteractSound_CL:PlayOnOne", "impactdrill", 1)

            Citizen.Wait(2000)
        
            DoScreenFadeIn(150)
            Zero.Functions.HidePlayers(false)
        
            TriggerEvent("Zero:Client-Hud:Toggle", false)

            time = 120
            
            local ui = exports['zero-ui']:element()
            while true do
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    ui.timer("", 0)
                    DeleteVehicle(test_vehicle)
                    return
                end

                if time <= 0 then
                    ui.timer("", 0)
                    DeleteVehicle(test_vehicle)
                    return
                end

                time = time - 1

                ui.timer("Voertuig testrit", (100 / 120 * time))
                Wait(1000)
            end
        end
    end
end)

RegisterNetEvent("Zero:Client-Dealership:Plate")
AddEventHandler("Zero:Client-Dealership:Plate", function(plate)
    local vehicle = boughtVehicle

    SetVehicleNumberPlateText(vehicle, plate)
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750

        if insideStore then
            timer = 0

            if not DoesEntityExist(dealervehicle) then
                SendNUIMessage({
                    action = "displayText", 
                    text = "Kies een voertuig model..",
                })

                if vehicle_store_model then
                    SendNUIMessage({
                        action = "displayText", 
                        text = vehicle_store_model .. " laden..",
                    })

                    local x,y,z,h = config.locations[last_index].display.x, config.locations[last_index].display.y, config.locations[last_index].display.z, config.locations[last_index].display.h

                    Zero.Functions.SpawnVehicle({
                        model = vehicle_store_model,
                        location = {x = x, y = y, z = z - 1, h = h},
                        teleport = false,
                        network = false,
                    }, function(vehicle)
                        dealervehicle = vehicle

                        SendNUIMessage({
                            action = "displayText", 
                            text = "",
                        })
                    end)
                end
            else
                SendNUIMessage({
                    action = "displayText", 
                    text = "",
                })
            end
        end
        
        Wait(timer)
    end
end)

function SpawnVehicleBuy(index, model)
    DoScreenFadeOut(150)

    while not IsScreenFadedOut() do
        Wait(0)
    end

    SetNuiFocus(false, false)
    RenderScriptCams(false, false, 0, false, false)
    DestroyAllCams()
    SetEntityVisible(PlayerPedId(), true)

    insideStore = false
    vehicle_store_model = nil

    if DoesEntityExist(dealervehicle) then
        DeleteVehicle(dealervehicle)
    end
    
    local coord = config.locations[index].spawn

    Zero.Functions.SpawnVehicle({
        model = model,
        location = {x = coord.x, y = coord.y, z = coord.z, h = coord.h},
        teleport = false,
        network = true,
    }, function(vehicle)
        boughtVehicle = vehicle
        TriggerServerEvent("Zero:Server-Dealership:BuyVehicle", model)
    end)

    TriggerEvent("InteractSound_CL:PlayOnOne", "impactdrill", 1)
   -- Citizen.InvokeNative(0xBA3D65906822BED5, 0.1, 0.1, 0.0, 0.0, 0.0, 300.0)
    Citizen.Wait(2000)

    DoScreenFadeIn(150)
    Zero.Functions.HidePlayers(false)

    TriggerEvent("Zero:Client-Hud:Toggle", false)
end