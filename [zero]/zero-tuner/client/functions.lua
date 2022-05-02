CurrentVehicleSpot = 1

function CreateBlip()
    local x,y,z = Config.Location.x, Config.Location.y, Config.Location.z

    blip = AddBlipForCoord(x, y, z)

    SetBlipSprite (blip, 595)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 25)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Tuner")
    EndTextCommandSetBlipName(blip)
end

function ControleVehiclePlacement()
    if not DisplaySpot then

        RenderScriptCams(false, false, 0, false, false)
        DestroyAllCams(true)

        local data = Config.SpotLocations[CurrentVehicleSpot]
        local cam  = data['cam']

        camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(camera, true)
        RenderScriptCams(true, true, 5000, true, true)
        SetCamCoord(camera, cam.x, cam.y, cam.z + 0.5)
        SetCamRot(camera, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)) + 180)

        PointCamAtCoord(camera, data.x, data.y, data.z)

        Zero.Functions.SetUIButtons({
            {GetControlInstructionalButton(1, Zero.Config.Keys['Q'], 0),"Vorige voertuig"},
            {GetControlInstructionalButton(1, Zero.Config.Keys['E'], 0),"Volgend voertuig"},
            {GetControlInstructionalButton(1, Zero.Config.Keys['X'], 0),"Verwijder voertuig"},
            {GetControlInstructionalButton(1, Zero.Config.Keys['G'], 0),"Pak voertuig"},
            {GetControlInstructionalButton(1, Zero.Config.Keys['ENTER'], 0),"Plaats voertuig"},
            {GetControlInstructionalButton(1, Zero.Config.Keys['BACKSPACE'], 0),"Sluit menu"},
        },0)

        if not Config.SpotLocations[currentVehicle]['created'] then
            CreateVehicleDisplays(data.x, data.y, data.z, data.h)
        end
        DisplaySpot = true
    else
        Zero.Functions.RenderUIButtons()
        DisableButtons()
        ControlButtonActions()
    end
end

function DisableButtons()
    DisableAllControlActions(0)
end

function CreateNewCam(data, cam)
    local new_camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    data.z = data.liftHeight == nil and data.z or data.liftHeight

    PointCamAtCoord(new_camera, data.x, data.y, data.z)
    SetCamCoord(new_camera, cam.x, cam.y, cam.z)

    return new_camera
end

function CloseVehicleInteraction()
    SetCamActive(camera, false)
    RenderScriptCams(false, true, 5000, false, false)
    DestroyCam(camera, true)

    DisplaySpot = false
    CurrentVehicleSpot = 1
    
    DeleteEntity(created_vehicle)
    created_vehicle = nil

    VehiclePlacement = false
end

function ControlButtonActions()
    if IsDisabledControlJustPressed(0, Zero.Config.Keys['BACKSPACE']) then
        CloseVehicleInteraction()
    end

    if IsDisabledControlJustPressed(0, Zero.Config.Keys['RIGHT']) then
        if Config.SpotLocations[CurrentVehicleSpot + 1] then
            CurrentVehicleSpot = CurrentVehicleSpot + 1

            local data = Config.SpotLocations[CurrentVehicleSpot]
            local cam  = data['cam']
            local new_cam = CreateNewCam(data, cam)
            local x,y,z = Config.SpotLocations[CurrentVehicleSpot - 1]['cam'].x, Config.SpotLocations[CurrentVehicleSpot - 1]['cam'].y, Config.SpotLocations[CurrentVehicleSpot - 1]['cam'].z
            
            SetCamActiveWithInterp(new_cam, camera, 3000, vector3(x,y,z), 0)

            DeleteEntity(created_vehicle)
            created_vehicle = nil

            if not Config.SpotLocations[CurrentVehicleSpot]['created'] then
                CreateVehicleDisplays(data.x, data.y, data.z, data.h)
            end

            Citizen.Wait(3000)

            DestroyCam(camera, true)
            camera = new_cam
        end
    end

    if IsDisabledControlJustPressed(0, Zero.Config.Keys['LEFT']) then
        if Config.SpotLocations[CurrentVehicleSpot - 1] then
            CurrentVehicleSpot = CurrentVehicleSpot - 1

            local data = Config.SpotLocations[CurrentVehicleSpot]
            local cam  = data['cam']
            local new_cam = CreateNewCam(data, cam)
            local x,y,z = Config.SpotLocations[CurrentVehicleSpot + 1]['cam'].x, Config.SpotLocations[CurrentVehicleSpot + 1]['cam'].y, Config.SpotLocations[CurrentVehicleSpot + 1]['cam'].z
            
            SetCamActiveWithInterp(new_cam, camera, 3000, vector3(x,y,z), 0)

            DeleteEntity(created_vehicle)
            created_vehicle = nil

            if not Config.SpotLocations[CurrentVehicleSpot]['created'] then
                CreateVehicleDisplays(data.x, data.y, data.z, data.h)
            end
            
            Citizen.Wait(3000)

            camera = new_cam 
        end
    end

    if not Config.SpotLocations[CurrentVehicleSpot]['created'] then
        if IsDisabledControlJustPressed(0, Zero.Config.Keys['E']) then
            if (vehicleGarage[currentVehicle + 1]) then
                currentVehicle = currentVehicle + 1

                DeleteEntity(created_vehicle)
                created_vehicle = nil

                local data = Config.SpotLocations[CurrentVehicleSpot]
                CreateVehicleDisplays(data.x, data.y, data.z, data.h)
            end
        end

        if IsDisabledControlJustPressed(0, Zero.Config.Keys['Q']) then
            if (vehicleGarage[currentVehicle - 1]) then
                currentVehicle = currentVehicle - 1

                DeleteEntity(created_vehicle)
                created_vehicle = nil

                local data = Config.SpotLocations[CurrentVehicleSpot]
                CreateVehicleDisplays(data.x, data.y, data.z, data.h)
            end
        end


        if IsDisabledControlJustPressed(0, Zero.Config.Keys['ENTER']) then
            if (vehicleGarage[currentVehicle] and Config.SpotLocations[CurrentVehicleSpot]) then
                PlaceVehicleOnLocation(currentVehicle, CurrentVehicleSpot)
            end
        end
    else
        if IsDisabledControlJustPressed(0, Zero.Config.Keys['X']) then
            removeVehicleFromLocation()
        end
        if IsDisabledControlJustPressed(0, Zero.Config.Keys['G']) then
            grabVehicleFromLocation(CurrentVehicleSpot)
            CloseVehicleInteraction()
        end
    end
end

function CreateVehicleDisplays(x, y, z, h)
    if (vehicleGarage[currentVehicle]) then
        local mods = json.decode(vehicleGarage[currentVehicle]['mods'])
        local model = vehicleGarage[currentVehicle]['model']

        if (created_vehicle) then
          
        else
            Zero.Functions.SpawnVehicle({
                model = model,
                location = {x = x, y = y, z = z, h = h},
                teleport = false,
                network = false,
            }, function(vehicle)
                created_vehicle = vehicle

                FreezeEntityPosition(created_vehicle, true)
                SetVehicleDoorsLocked(created_vehicle, -1)
                SetVehicleCanBeTargetted(created_vehicle, false)
                SetVehicleCanBeVisiblyDamaged(created_vehicle, false)
                SetEntityAlpha(created_vehicle, 100)

                Zero.Functions.SetVehicleProperties(created_vehicle, mods)
            end)
        end
    end
end

LoadedLifts = false
function CheckLifts()
    if not LoadedLifts then

        TriggerServerEvent("Zero:Server-Tuner:RequestLifts")
        Zero.Functions.TriggerCallback("Zero:Server-Tuner:GetGarage", function(x)
            tunerVehicles = x
        end, true)


        SetupLifts()
        LoadedLifts = true
    end
end

function removeObjects()
    for k,v in pairs(SpawnedObjects) do
        DeleteEntity(v)
        DeleteObject(v)
    end
    LoadedLifts = false
    SpawnedObjects = {}
end

function SetupLifts()
    for k,v in pairs(Config.SpotLocations) do
        if v.lift then
            v.liftObj = GetClosestObjectOfType(v.x, v.y , v.liftHeight, 5.0, 399968753)
        end
    end
end

function PlaceVehicleOnLocation(vehicleIndex, location)
    if (vehicleGarage[vehicleIndex]) then
        local plate = vehicleGarage[vehicleIndex]['plate']

        CloseVehicleInteraction()
        TriggerServerEvent("Zero:Server-Tuner:SetVehicleLocation", plate, location)
    end
end

function SyncVehicleDisplays()
    if (tunerVehicles) then
        for k,v in pairs(tunerVehicles) do
            v.location = tonumber(v.location)
            if (Config.SpotLocations[v.location]) then
                RenderVehicleOnLocation(v)
            end
        end
    end
end

function RenderVehicleOnLocation(v)
    if (Config.SpotLocations[v.location]) then
        local mods = json.decode(v['mods'])
        local model = v['model']
        local x,y,z,h = Config.SpotLocations[v.location].x, Config.SpotLocations[v.location].y, Config.SpotLocations[v.location].z, Config.SpotLocations[v.location].h

        if not (Config.SpotLocations[v.location]['created']) then
            local oldVehicle = GetClosestVehicle(x,y,z, 3.0, 0, 70)
            if oldVehicle ~= 0 then
                DeleteEntity(oldVehicle)
            end 

            Zero.Functions.SpawnVehicle({
                model = model,
                location = {x = x, y = y, z = z, h = h},
                teleport = false,
                network = false,
            }, function(vehicle)

                FreezeEntityPosition(vehicle, true)
                SetVehicleDoorsLocked(vehicle, -1)
                SetVehicleCanBeTargetted(vehicle, false)
                SetVehicleCanBeVisiblyDamaged(vehicle, false)
                Zero.Functions.SetVehicleProperties(vehicle, mods)

                SetVehicleDirtLevel(vehicle, 0.0)

                Config.SpotLocations[v.location]['created'] = vehicle
            end)
        end
    end
end


--[[
       if IsPedInAnyVehicle(PlayerPedId()) then
                if Zero.Player.Job.name == "tuner" then
                    local player = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(player)

                    if (vehicle == Config.SpotLocations[v.location]['created']) then
                        DisplayTuningsMenu()
                    end
                end
            end
]]

function LiftTransition(index, height)
    if (Config.SpotLocations[index]) then
        Config.SpotLocations[index].transition = true
       


        if Config.SpotLocations[index].liftHeight < height then
            while Config.SpotLocations[index].liftHeight < height do
                Config.SpotLocations[index].liftHeight = Config.SpotLocations[index].liftHeight + 0.01

                Config.SpotLocations[index].liftObj = GetClosestObjectOfType(Config.SpotLocations[index].x, Config.SpotLocations[index].y, Config.SpotLocations[index].z, 10.0, 399968753)
                SetEntityCoords(Config.SpotLocations[index].liftObj, Config.SpotLocations[index].x, Config.SpotLocations[index].y, Config.SpotLocations[index].liftHeight)

                if (Config.SpotLocations[index].created) then
                    SetEntityCoords(Config.SpotLocations[index].created, Config.SpotLocations[index].x, Config.SpotLocations[index].y, Config.SpotLocations[index].liftHeight)
                    SetEntityHeading(Config.SpotLocations[index].created, Config.SpotLocations[index].h)
                    FreezeEntityPosition(Config.SpotLocations[index].created, true)
                end

                Citizen.Wait(1)
            end
            Config.SpotLocations[index].transition = false
        else
            while Config.SpotLocations[index].liftHeight > height do
                Config.SpotLocations[index].liftHeight = Config.SpotLocations[index].liftHeight - 0.01
                SetEntityCoords(Config.SpotLocations[index].liftObj, Config.SpotLocations[index].x, Config.SpotLocations[index].y, Config.SpotLocations[index].liftHeight)

                if (Config.SpotLocations[index].created) then
                    SetEntityCoords(Config.SpotLocations[index].created, Config.SpotLocations[index].x, Config.SpotLocations[index].y, Config.SpotLocations[index].liftHeight)
                    SetEntityHeading(Config.SpotLocations[index].created, Config.SpotLocations[index].h)
                    FreezeEntityPosition(Config.SpotLocations[index].created, true)
                end

                Citizen.Wait(1)
            end
            Config.SpotLocations[index].transition = false
        end
    end
end

function DisplayTuningsMenu()
    if Zero.Player.Job.name == "tuner" then
        HideHudComponentThisFrame(16)
        DisableControlAction(0, Zero.Config.Keys['Q'], true)

        Zero.Functions.SetUIButtons({
            {GetControlInstructionalButton(1, Zero.Config.Keys['ENTER'], 0),"Pak voertuig"},
        },0)

        Zero.Functions.RenderUIButtons()

        if IsControlJustPressed(0, Zero.Config.Keys['ENTER']) then
            grabVehicleFromLocation()
        end
    else
        TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId()), 1)
    end
end


function removeVehicleFromLocation()
    if (CurrentVehicleSpot) then
        
        for k,v in pairs(tunerVehicles) do
            v.location = tonumber(v.location)
    
            if v.location == CurrentVehicleSpot then
                TriggerServerEvent("Zero:Server-Tuner:ClearLocation", v.plate)
                CloseVehicleInteraction()
                return
            end
        end
    end
end

function grabVehicleFromLocation(current)
    local player = PlayerPedId()

    for k,v in pairs(tunerVehicles) do
        if tonumber(v.location) == current then
            model = v.model

            TriggerServerEvent("Zero:Server-Tuner:ClearLocation", v.plate)

            Citizen.Wait(1000)
            
            Zero.Functions.SpawnVehicle({
                model = model,
                location = {x = Config.SpotLocations[v.location].x, y = Config.SpotLocations[v.location].y, z = Config.SpotLocations[v.location].z, h = Config.SpotLocations[v.location].h},
                teleport = false,
                network = true,
            }, function(vehicle)
                Zero.Functions.SetVehicleProperties(vehicle, v.mods)
                SetVehicleNumberPlateText(vehicle, v.plate)
                TriggerEvent("vehiclekeys:client:SetOwner", v.plate)
            end)
            return
        end
    end

end

ChangeVehicleWheels = function()
    changingwheels = true
    TriggerEvent("Zero:Client-Vehicles:ToggleTunings", true)
    fontWheels = true
    wheelrotation = false
end


function OpenStash()
    TriggerEvent("inventory:client:toggle")
    exports['zero-inventory']:shop({
        action = "create_shop",
        items = Config.StashItems,
        extra = {index = 'tuner'},
        event = "Zero:Server-Tuner:Grab",
        slots = #Config.StashItems,
        label = "Tuner stash",
    })
end

function OpenVehicleDealer()
    TriggerEvent("dealer:open", "tuner")
end


RegisterNetEvent("Zero:Client-Tuner:OpenGarageMenu")
AddEventHandler("Zero:Client-Tuner:OpenGarageMenu", function()
    local ui = exports['zero-ui']:element()
    local menu = {}


    menu[#menu+1] = {
        ['label'] = "Uit garage",
        ['subtitle'] = "Haal een voertuig uit de tuner garage",
        ['next'] = true,
        ['event'] = "Zero:Client-Tuner:Reclaim",
    }   
    menu[#menu+1] = {
        ['label'] = "Plaatsen",
        ['subtitle'] = "Plaats voertuig op een display",
        ['next'] = true,
        ['event'] = "Zero:Client-Tuner:OpenGarage",
    }   

    menu[#menu+1] = {
        ['label'] = "Sluiten",
        ['event'] = "",
    }   

    ui.set("Tuner garage", menu)
end)


RegisterNetEvent("Zero:Client-Tuner:Reclaim")
AddEventHandler("Zero:Client-Tuner:Reclaim", function()
    local job = Zero.Functions.GetPlayerData().Job.name

    if job == "tuner" then
        Zero.Functions.TriggerCallback("Zero:Server-Tuner:GetGarage", function(vehicles)
            local ui = exports['zero-ui']:element()
            local menu = {}



            last_vehicles = vehicles
            for k,v in pairs(vehicles) do
                menu[#menu+1] = {
                    label = v.plate .. " - " .. v.model,
                    subtitle = "Originele eigenaar: "..v.citizenid.."",
                    next = true,
                    event = "Zero:Client-Tuner:OpenVehicleStats",
                    value = k,
                }
            end
            menu[#menu+1] = {
                label = "Ga terug",
                next = false,
                event = "Zero:Client-Tuner:OpenGarageMenu",
            }

            ui.set('Voertuigen', menu)
        end, true)
    end
end)

RegisterNetEvent("Zero:Client-Tuner:OpenVehicleStats")
AddEventHandler("Zero:Client-Tuner:OpenVehicleStats", function(index)
    local index = tonumber(index)
    if (last_vehicles) then
        local data = last_vehicles[index]

        local ui = exports['zero-ui']:element()
        local menu = {}

        if data then
            menu[#menu+1] = {
                label = "Voertuig: "..data.model.."",
                subtitle = "Kenteken: "..data.plate.." <br> Originele eigenaar: "..data.citizenid.." <br>",
                value = index,
            }

            menu[#menu+1] = {
                label = "Spawn voertuig",
                subtitle = "Spawn voertuig in garage",
                event = "Zero:Client-Tuner:SpawnVehicle",
                value = index,
            }

            
            menu[#menu+1] = {
                label = "Geef voertuig",
                subtitle = "Geef voertuig aan een speler",
                input = true,
                event = "Zero:Client-Tuner:GiveVehicle",
                value = index,
            }
                        
            menu[#menu+1] = {
                label = "Ga terug",
                next = false,
                event = "Zero:Client-Tuner:Reclaim"
            }

            ui.set('Voertuig', menu)
        end
    end
end)

RegisterNetEvent("Zero:Client-Tuner:GiveVehicle")
AddEventHandler("Zero:Client-Tuner:GiveVehicle", function(index, value)
    local index, value = tonumber(index), tonumber(value)

    if index and value then
        if last_vehicles then
            local data = last_vehicles[index]
            if data then
                TriggerServerEvent("Zero:Server-Tuner:ClearLocation", data.plate)
                TriggerServerEvent("Zero:Server-Tuner:GiveVehicle", data, data.plate, value)
            end
        end
    end
end)

RegisterNetEvent("Zero:Client-Tuner:SpawnVehicle")
AddEventHandler("Zero:Client-Tuner:SpawnVehicle", function(value)
    local value = tonumber(value)

    if value and last_vehicles then
        local data = last_vehicles[value]

        local x,y,z,h = Config.TestSpawn.x, Config.TestSpawn.y, Config.TestSpawn.z, Config.TestSpawn.h
        local model = data.model
        local mods = json.decode(data.mods)

        Zero.Functions.SpawnVehicle({
            model = model,
            location = {x = x, y = y, z = z, h = h},
            teleport = false,
            network = true,
        }, function(vehicle)
            SetVehicleDoorsLocked(vehicle, -1)
            Zero.Functions.SetVehicleProperties(vehicle, mods)
            TriggerEvent("vehiclekeys:client:SetOwner", data.plate)
        end)
    end
end)

RegisterNetEvent("Zero:Client-Tuner:OpenGarage")
AddEventHandler("Zero:Client-Tuner:OpenGarage", function()
    local job = Zero.Functions.GetPlayerData().Job.name

    if job == "tuner" then
        Zero.Functions.TriggerCallback("Zero:Server-Tuner:GetGarage", function(x)
            currentVehicle = 1
            vehicleGarage = x
    
            VehiclePlacement = true
        end)
    end
end)