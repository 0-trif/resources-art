
Citizen.CreateThread(function()
    while true do
        local timer = 750

        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)

        for k,v in pairs(Config.Impounds) do
            local distance = #(vector3(v.loc.x, v.loc.y, v.loc.z) - pos)
            if distance <= 5 then
                timer = 0

                TriggerEvent("interaction:show", "E - Impound", function()
                    openImpoundMenu(v.spawn)
                end)
            end
        end

        Wait(timer)
    end
end)

openImpoundMenu = function(spawn)
    local PlayerVehicles = Zero.Functions.GetPlayerVehicles()
    local valid = {}

    for k,v in pairs(PlayerVehicles) do
        if (v.location == "*" or v.location == nil) then
            valid[v.plate] = v
        end
    end

    Config.Vars.Spawn = spawn

    exports['zero-ui']:element(function(ui)
        local _ = {}

        for k,v in pairs(valid) do
            _[#_+1] = {
                label = v.model,
                subtitle = "Pak "..v.model.." met kenteken: "..v.plate.."",
                event = "Zero:Client-Garages:ImpoundVehicle",
                value = v.plate,
            }
        end


        _[#_+1] = {
            label = "Sluiten",
            subtitle = "Sluit menu",
            event = "ui:close",
        }
        
        ui.set("Impound", _)
    end)
end

exports('openMenu', function(vehicles)
    local ui = exports['zero-ui']:element()
    local menu = {}

    DeleteVehicle(PrevieuwVehicle)

    last_vehicles = vehicles
    for k,v in pairs(vehicles) do
        menu[#menu+1] = {
            label = v.model,
            subtitle = "Spawn voertuig | " .. v.reason,
            next = true,
            value = v.spawnmodel,
            event = "Zero:Client-Garages:SubPreview"
        }
    end

    menu[#menu+1] = {
        label = "Sluiten",
    }

    ui.set("Pak voertuig", menu)
end)

RegisterNetEvent("ui:close")
AddEventHandler("ui:close", function()
    if PrevieuwVehicle then
        DeleteVehicle(PrevieuwVehicle)
    end
end)

RegisterNetEvent("Zero:Client-Garages:BackPre")
AddEventHandler("Zero:Client-Garages:BackPre", function()
    if last_vehicles then
        exports['zero-garages']:openMenu(last_vehicles)
    end
end)
RegisterNetEvent("Zero:Client-Garages:SubPreview")
AddEventHandler("Zero:Client-Garages:SubPreview", function(value)
    local ui = exports['zero-ui']:element()
    local menu = {}

    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    local h = GetEntityHeading(ped)

    Zero.Functions.SpawnVehicle({
        model = value,
        location = {x = x + 2.0, y = y, z = z, h = h},
        teleport = false,
        network = false,
    }, function(vehicle)
        PrevieuwVehicle = vehicle
        SetVehicleDoorsLocked(PrevieuwVehicle, true)
    end)

    -- spawn
    menu[#menu+1] = {
        label = "Pak dit voertuig",
        value = value,
        event = "Zero:Client-Garages:SpawnJob"
    }

    menu[#menu+1] = {
        label = "Ga terug",
        event = "Zero:Client-Garages:BackPre",
        next = false,
    }

    ui.set("Pak voertuig", menu)
end)



RegisterNetEvent("Zero:Client-Garages:SpawnJob")
AddEventHandler("Zero:Client-Garages:SpawnJob", function(value)
    local spawnmodel = value
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    local h = GetEntityHeading(ped)

    DeleteVehicle(PrevieuwVehicle)

    Zero.Functions.SpawnVehicle({
        model = spawnmodel,
        location = {x = x+ 2.0, y = y, z = z, h = h},
        teleport = false,
        network = true,
    }, function(vehicle)
        exports['LegacyFuel']:SetFuel(vehicle, 100)
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
    end)
end)

RegisterNetEvent("Zero:Client-Garages:ImpoundVehicle")
AddEventHandler("Zero:Client-Garages:ImpoundVehicle", function(plate)
    local vehicles = Zero.Functions.GetPlayerVehicles()
    
    Zero.Functions.GetPlayerData(function(PlayerData)
        if (PlayerData.Money.bank >= Config.ImpoundPrice) then
            if (vehicles[plate]) then
                if vehicles[plate]['location'] == "*" then
                    clearVehicles(vehicles[plate]['plate'])
                    Zero.Functions.SpawnVehicle({
                        model = vehicles[plate]['model'],
                        location = {x = Config.Vars.Spawn.x, y = Config.Vars.Spawn.y, z = Config.Vars.Spawn.z, h = Config.Vars.Spawn.h},
                        teleport = true,
                        network = true,
                    }, function(vehicle)

                        Zero.Functions.SetVehicleProperties(vehicle, vehicles[plate].mods)
                        SetVehicleNumberPlateText(vehicle, vehicles[plate]['plate'])
                        TriggerEvent("vehiclekeys:client:SetOwner", vehicles[plate]['plate'])
                        exports['LegacyFuel']:SetFuel(vehicle, vehicles[plate].fuel)
                        TriggerServerEvent('Zero:Server-Garage:PayImpound')
                    end)
                end
            end
        else
            Zero.Functions.Notification("Impound", "Je hebt niet genoeg geld op je bank staan", "error", 5000)
        end
    end)
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Impounds) do
        Depot = AddBlipForCoord(v.loc.x, v.loc.y, v.loc.z)

        SetBlipSprite (Depot, 68)
        SetBlipDisplay(Depot, 4)
        SetBlipScale  (Depot, 0.7)
        SetBlipAsShortRange(Depot, true)
        SetBlipColour(Depot, 5)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Impound")
        EndTextCommandSetBlipName(Depot)
    end
end)
