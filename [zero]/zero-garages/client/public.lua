function valid(entity)
    if entity then
        if IsEntityAVehicle(entity) then
            local plate = GetVehicleNumberPlateText(entity)
            local PlayerVehicles = Zero.Functions.GetPlayerVehicles()

            if PlayerVehicles[plate] then
                return true
            end
        end
    end
end

function FoundVehicles(index)
    local PlayerVehicles = Zero.Functions.GetPlayerVehicles()
        
    found = false
    for y,z in pairs(PlayerVehicles) do
        if z.location == index then
            found = true
        end
    end

    return found
end


RegisterNetEvent("Zero:Client-Garages:TransferVehicle")
AddEventHandler("Zero:Client-Garages:TransferVehicle", function(index)
    local _ = {}

    currentGarage = index
    local PlayerVehicles = Zero.Functions.GetPlayerVehicles()

    exports['zero-ui']:element(function(ui)
        local _ = {}

        for k,v in pairs(Config.PublicAreas) do
            if FoundVehicles(k) and k ~= index then
                _[#_+1] = {
                    label = k,
                    subtitle = "Overplaatsen vanuit "..k.." garage",
                    event = "Zero:Client-Garages:GatherTransferVehs",
                    value = k,
                }
            end
        end

        _[#_+1] = {
                label = "Terug",
                subtitle = "Terug naar voertuig lijst",
                event = "Zero:Client-Garages:OpenVehiclesList",
                next = false,
                value = currentGarage
        }

        ui.set("Kies garage", _)
    end)

end)

RegisterNetEvent("Zero:Client-Garages:GatherTransferVehs")
AddEventHandler("Zero:Client-Garages:GatherTransferVehs", function(index)
    local _ = {}
    local PlayerVehicles = Zero.Functions.GetPlayerVehicles()

    local garageindex = currentGarage

    local ui =  exports['zero-ui']:element()

    for k,v in pairs(PlayerVehicles) do
        if v.location == index then
            _[#_+1] = {
                label = v.plate .. " - "..exports['zero-dealership']:GetVehicleData(v.model)['label'].."",
                subtitle = "Plaats "..v.plate.." over naar deze garage",
                event = "Zero:Client-Garages:CompleteTransfer",
                value = v.plate,
            }
        end
    end

    _[#_+1] = {
        label = "Terug",
        subtitle = "Terug naar garage lijst",
        event = "Zero:Client-Garages:TransferVehicle",
        next = false,
        value = currentGarage
    }

    ui.set("Kies voertuig", _)
end)

RegisterNetEvent("Zero:Client-Garages:CompleteTransfer")
AddEventHandler("Zero:Client-Garages:CompleteTransfer", function(plate)
    if (currentGarage) then
        local PlayerVehicles = Zero.Functions.GetPlayerVehicles()

        local money = Zero.Functions.GetPlayerData().Money
        if money.bank >= Config.transferPrice or money.bank >= Config.transferPrice then
            TriggerServerEvent("Zero:Server-Garages:ParkVehicle", plate, currentGarage, PlayerVehicles[plate]['fuel'], Config.PublicAreas[currentGarage]['default'], true)
            Zero.Functions.Notification("Garage", "Voertuig overgeplaatst", "success")
        else
            Zero.Functions.Notification("Garage", "Je hebt niet genoeg geld", "error")
        end
    end
end)



function findAnyVehicles(index)
    local PlayerVehicles = Zero.Functions.GetPlayerVehicles()

    for k,v in pairs(PlayerVehicles) do
        if index == v.location then
            return true
        end
    end
end


RegisterNetEvent("Zero:Client-Garages:OpenVehiclesList")
AddEventHandler("Zero:Client-Garages:OpenVehiclesList", function(index)
    exports['zero-ui']:element(function(ui)
        local _ = {}

        _[1] = {
            label = 'Overplaatsen',
            subtitle = "Plaats een voertuig over voor €"..Config.transferPrice.."",
            event = "Zero:Client-Garages:TransferVehicle",
            value = index,
        }

        local PlayerVehicles = Zero.Functions.GetPlayerVehicles()

        for k,v in pairs(PlayerVehicles) do
            if (v.location == index) then
                _[#_+1] = {
                    label = v.plate .. " - " .. exports['zero-dealership']:GetVehicleData(v.model)['label'],
                    subtitle = "Pak "..exports['zero-dealership']:GetVehicleData(v.model)['label'].." uit garage",
                    event = "Zero:Client-Garages:GrabVehiclePublic",
                    value = v.plate,
                }
            end
        end

        _[#_+1] = {
                label = "Sluiten",
                subtitle = "Sluit menu",
                event = "ui:close",
        }

        ui.set("Garage", _)
    end)
end)

RegisterNetEvent("Zero:Client-Garages:GrabVehiclePublic")
AddEventHandler("Zero:Client-Garages:GrabVehiclePublic", function(plate)
    local PlayerVehicles = Zero.Functions.GetPlayerVehicles()

    if (PlayerVehicles[plate]) then
        local x,y,z,h = PlayerVehicles[plate].coord.x, PlayerVehicles[plate].coord.y, PlayerVehicles[plate].coord.z, PlayerVehicles[plate].coord.h
        
        clearVehicles(plate)
        
        Zero.Functions.SpawnVehicle({
            model = PlayerVehicles[plate]['model'],
            location = {x = x, y = y, z = z, h = h},
            teleport = false,
            network = true,
        }, function(vehicle)
            Zero.Functions.SetVehicleProperties(vehicle, PlayerVehicles[plate]['mods'])
            SetVehicleNumberPlateText(vehicle, plate)
            exports['LegacyFuel']:SetFuel(vehicle, PlayerVehicles[plate]['fuel'])

            TriggerServerEvent("vehiclekeys:server:SetVehicleOwner", plate)
            TriggerServerEvent("Zero:Server-Garages:ParkVehicle", plate, '*', PlayerVehicles[plate]['fuel'])
        end)
    end
end)


createdBlips = {}
Citizen.CreateThread(function()
    for k,v in pairs(Config.PublicAreas) do
        blip = AddBlipForCoord(v.x, v.y, v.z)

        SetBlipSprite (blip, 357)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.5)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 69)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Openbare garage")
        EndTextCommandSetBlipName(blip)
        table.insert(createdBlips, blip)
    end
end) -- creating blips

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("park-vehicle", function(coords, entity)
        local ply = PlayerPedId()
        local x = GetEntityCoords(ply)

        for k,v in pairs(Config.PublicAreas) do
            local distance = #(x - vector3(v.x, v.y, v.z))

            if (distance <= v.size and valid(entity)) then
                public_index = k
                return true, GetEntityCoords(entity)
            end
        end
    end, {
        [1] = {
            name = "Voertuig parkeren", 
            action = function(entity) 
                local plate = GetVehicleNumberPlateText(entity)
                local fuel = exports['LegacyFuel']:GetFuel(entity)
                local coord = GetEntityCoords(entity)
                local location = {
                    x = coord.x,
                    y = coord.y, 
                    z = coord.z,
                    h = GetEntityHeading(entity)
                }

                if public_index then
                    TriggerEvent("disableEye")
                    TriggerServerEvent("Zero:Server-Garages:ParkVehicle", plate, public_index, fuel, location)
                    DeleteVehicle(entity)
                end
            end,
        },
    }, GetCurrentResourceName(), 10)

    exports['zero-eye']:looped_runtime("grab-vehicle", function(coords, entity)
        local ply = PlayerPedId()
        local x = GetEntityCoords(ply)

        for k,v in pairs(Config.PublicAreas) do
            local distance = #(x - vector3(v.x, v.y, v.z))

            if (distance <= v.size) then
                public_index = k
                return true
            end
        end
    end, {
        [1] = {
            name = "Voertuig pakken", 
            action = function() 
                TriggerEvent("Zero:Client-Garages:OpenVehiclesList", public_index)
            end,
        },
    }, GetCurrentResourceName(), 10)
end)

function clearVehicles(plateRemove)
	local vehicles = Zero.Functions.GetVehicles()

	for k,v in pairs(vehicles) do
		local plate = GetVehicleNumberPlateText(v)
		if plate == plateRemove then
			DeleteVehicle(v)
		end
	end
end