local monkey = "s_m_m_autoshop_02"
local points = {}

exports['zero-core']:object(function(O) Zero = O end)

exports('createHirePoint', function(x, y, z, h, vehicles, npc)
    points[#points + 1] = {
        x = x,
        y = y,
        z = z,
        h = h,
        models = vehicles,
        price = price,
        npc = npc,
    }
end)

createNPConLoc = function(x,y,z,h,npc)
    local model = npc ~= nil and npc or monkey
    local hash = GetHashKey(model)
    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(0)
    end

    local ped = CreatePed(12, hash, x, y, z - 1, h, false, false)
    FreezeEntityPosition(ped, true)
    SetPedCanBeTargetted(ped, false)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    SetPedAlertness(ped, 0)
    SetEntityInvincible(ped, true)
    SetPedComponentVariation(ped, 0, 0, 0, 2)

    return ped
end

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("vehicle-hire", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)

        if entity and IsEntityAPed(entity) then
            for k,v in pairs(points) do
                if v.ped and v.ped == entity then
                    closestPedIndex = k
                    return true, GetEntityCoords(entity)
                end
            end
        end
    end, {
       [1] = {
           name = "Voertuig huren",
           action = function()
                OpenVehicleHire()
           end
       },
       [2] = {
        name = "Voertuig inleveren",
        action = function()
             CollectVehicle()
        end
    }
    }, GetCurrentResourceName(), 5)
end)

function OpenVehicleHire()
    if closestPedIndex then
        local ui = exports['zero-ui']:element()
        local _ = {}

        last_point = closestPedIndex

        for k,v in pairs(points[closestPedIndex]['models']) do
            _[#_+1] = {
                label = v.label,
                subtitle = "Huur "..v.label.." voor "..v.price.."",
                value = k,
                event = "vehicleHire:submit",
            }
        end

        _[#_+1] = {
            label = "Sluiten",
        }

        ui.set("Voertuig huren", _)
    end
end

RegisterNetEvent("vehicleHire:submit")
AddEventHandler("vehicleHire:submit", function(value)
    local vehicleIndex = tonumber(value)
    local index = last_point


    local model = points[index]['models'][vehicleIndex]['model']
    local price = points[index]['models'][vehicleIndex]['price']
    local loc = points[index]['models'][vehicleIndex]['loc']
    local x,y,z,h = loc.x, loc.y, loc.z, loc.h

    if model then
        Zero.Functions.SpawnVehicle({
            model = model,
            location = {x = x, y = y, z = z, h = h},
            teleport = true,
            network = true,
        }, function(vehicle)
            exports['LegacyFuel']:SetFuel(vehicle, 100.00)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            TriggerServerEvent("vehicleHirePlate", plate, price)
            TriggerEvent("vehiclekeys:client:SetOwner", plate)
        end)
    end
end)


function CollectVehicle()
    local vehicle = Zero.Functions.closestVehicle()

    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("vehicleHireCollect", plate)
        DeleteVehicle(vehicle)
    end
end

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)

        for k,v in pairs(points) do
            local distance = #(vector3(v.x, v.y, v.z) - pos)

            if distance <= 30 then
                if not DoesEntityExist(v.ped) then
                    v.ped = createNPConLoc(v.x, v.y, v.z, v.h, v.npc)
                end
            end
        end

        Citizen.Wait(timer)
    end
end)

