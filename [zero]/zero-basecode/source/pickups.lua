local objects = {}
local valid_items = {
    [`prop_wheel_01`] = true,
}
local valid_functions = {
}

RegisterNetEvent("prop:run")
AddEventHandler("prop:run", function(model, cb)
    valid_functions[model] = cb
end)

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("obj-grap", function(coords, entity)
        local ply = PlayerPedId()
        local x = GetEntityCoords(ply)
        local distance = #(x - coords)

        if (distance  <= 5 and entity and (IsEntityAnObject(entity) and valid_items[GetEntityModel(entity)] or GetVehicleClass(entity) == 13) and not IsEntityAttachedToAnyObject(entity)) then
            return true, GetEntityCoords(entity)
        end

    end, {
        [1] = {
            name = "Object oprapen", 
            action = function(entity) 
                pickUpObject(entity)
            end,
        },
    })

    exports['zero-eye']:looped_runtime("obj-letgo", function(coords, entity)
        local ply = PlayerPedId()
    

        if (#objects > 0) then
            return true
        end

    end, {
        [1] = {
            name = "Object loslaten", 
            action = function(entity) 
                removeObjects(entity)
            end,
        },
    }, GetCurrentResourceName(), 10)
end)

pickUpObject = function(entity)
    local netid = NetworkGetNetworkIdFromEntity(entity)
    NetworkRequestControlOfNetworkId(netid)

    while not NetworkHasControlOfNetworkId(netid) do
        Wait(0)
    end

    
    AttachEntityToEntity(entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.11, 0.255, -100.0, 30.0, 60.0, true, true, false, true, 1, true)
    table.insert(objects, entity)
end

removeObjects = function(bool)
    for k,v in pairs(objects) do
        DetachEntity(v, true, true)
        if bool then
            DeleteEntity(v)
            DeleteObject(v)
        end
    end
    ClearPedTasks(PlayerPedId(), true)
    objects = {}
end

Citizen.CreateThread(function()
    while not HasAnimDictLoaded('anim@heists@box_carry@') do
        Citizen.Wait(5)
        RequestAnimDict('anim@heists@box_carry@')
    end

    while true do
        Citizen.Wait(0)
        if (#objects > 0) then
            if IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) ~= 1 then
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                Citizen.Wait(100)
            end
            for k,v in pairs(objects) do
                

                if (valid_functions[GetEntityModel(v)]) then
                    valid_functions[GetEntityModel(v)](function()

                        local netid = NetworkGetNetworkIdFromEntity(v)
                        NetworkRequestControlOfNetworkId(netid)
                    
                        while not NetworkHasControlOfNetworkId(netid) do
                            Wait(0)
                            NetworkRequestControlOfNetworkId(netid)
                        end

                        removeObjects(true)
                        ClearPedTasks(PlayerPedId())
                    end)
                end
            end
        else
            if IsControlJustPressed(0, Zero.Config.Keys['X']) then
                ClearPedTasks(PlayerPedId())
            end
        end
    end
end)