local locations = {
    {['model'] = "u_m_y_babyd", ['x'] = 474.70, ['y'] = -1456.32, ['z'] = 29.29, ['h'] = 1.29, ['name'] = "KOSSO", ['index'] = "kosso", ['voices'] = {
        "kwaliteitKosso",
        "kossoRS6"
    }}
}

function createNPCsalesmen(data)
    local x,y,z,h = data.x, data.y, data.z, data.h

    local model = data.model
    local hash = GetHashKey(data.model)

    RequestModel(hash)
    while not HasModelLoaded(model) do Wait(0) end

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
    while true do
        local timer = 2000
        local player = PlayerPedId()
        local coord = GetEntityCoords(player)

        for k,v in pairs(locations) do
            local distance = #(vector3(v.x, v.y, v.z) - coord)

            if (distance <= 30) then
                timer = 0
                if (not DoesEntityExist(v.npc)) then
                    v.npc = createNPCsalesmen(v)
                end
            else
                if v.npc and DoesEntityExist(v.npc) then
                    DeleteEntity(v.npc)
                end
            end
        end
        
        Citizen.Wait(timer)
    end
end)

function NPC(v)
    return locations[v]['npc']
end

Citizen.CreateThread(function()
    for k,v in pairs(locations) do
        exports['zero-eye']:looped_runtime("salesmen-npc", function(coords, entity)
            if NPC(k) == entity then
                return true, GetEntityCoords(entity)
            end
        end, {
            [1] = {
                name = "Praat met "..v.name.."", 
                action = function(entity) 
                    TriggerEvent("disableEye")
                    TriggerEvent("InteractSound_CL:PlayOnOne", randomSound(v.voices), 0.2)
                    TriggerServerEvent("Zero:Server-Salesmen:Open", v.name, v.index)
                end,
            },
        }, GetCurrentResourceName(), 10)
    end
end)

function randomSound(v)
    local v = v
    local amount = #v
    local i = math.random(1, amount)

    return v[i]
end

RegisterNetEvent("Zero:Client-Salesmen:Open")
AddEventHandler("Zero:Client-Salesmen:Open", function(name, items, index)
    TriggerEvent("inventory:client:toggle")
    exports['zero-inventory']:shop({
        action = "create_shop",
        items = items,
        extra = {index = index},
        event = "Zero:Server-Salesmen:Grab",
        slots = #items,
        label = name,
    })
end)