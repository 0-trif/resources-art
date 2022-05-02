PlayerInteractions = {
    [1] = {
        name = "Persoon escorteren", 
        action = function() 
            TriggerEvent("Zero:Client-Police:DragPlayer")
        end,
    },
    [2] = {
        name = "Zet in voertuig", 
        action = function() 
            TriggerEvent("Zero:Client-Police:SetVehicle")
        end,
    },
    [3] = {
        name = "Fouileer speler", 
        action = function(entity) 
            TriggerEvent("Zero:Client-Police:Invsee")
        end,
    },
    [4] = {
        name = "Toggle walking", 
        action = function(entity) 
            TriggerEvent("Zero:Client-Police:ToggleWalking", entity)
        end,
    },
    [5] = {
        name = "Carry", 
        action = function(entity) 
            TriggerEvent("carry")
        end,
    },
}
CreateThread(function()
    exports['zero-eye']:looped_runtime("ply-int", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            if distance <= 3.5 and ped ~= PlayerPedId() then
                return true, GetEntityCoords(ped)
            end
        end

    end, {
        [1] = {
            name = "Speler interactie", 
            action = function() 
                exports['zero-godeye']:ForceOptions("persons", PlayerInteractions, GetCurrentResourceName())
            end,
        },
    }, GetCurrentResourceName(), 5)

    exports['zero-eye']:looped_runtime("veh-int", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local vehicle = Zero.Functions.closestVehicle()
        local distance = #(plyc - GetEntityCoords(vehicle))

        if vehicle and distance <= 5 and not IsPedInAnyVehicle(player) then
            return true
        end
    end, {
        [1] = {
            name = "Voertuig interactie", 
            action = function() 
                OpenVehicleInteraction()
            end,
        },
    }, GetCurrentResourceName(), 5)
end)


OpenVehicleInteraction = function()
    local vehicle = Zero.Functions.closestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)

    exports['zero-ui']:element(function(ui)
        ui.set("Voertuig ("..plate..")", {
            {
                label = "Passagiers",
                subtitle = "Haal speler uit voertuig",
                event = "Zero:Client-Police:PlayerRemove",
            },
            {
                label = "Sluiten",
                subtitle = "Sluit menu",
                event = "ui:close",
            },
        })
    end)
end

-- events
RegisterNetEvent("Zero:Client-Police:PlayerRemove")
AddEventHandler("Zero:Client-Police:PlayerRemove", function()
    local vehicle = Zero.Functions.closestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)

    TriggerServerEvent("Zero:Server-Police:TaskLeaveVehicle", plate)
end)

RegisterNetEvent("Zero:Client-Police:SetOutVehicle")
AddEventHandler("Zero:Client-Police:SetOutVehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    if vehicle then
        local offset = GetOffsetFromEntityInWorldCoords(vehicle, 0.55, 0.55, 0.0)
        SetEntityCoords(PlayerPedId(), offset.x, offset.y, offset.z)
    end
end)

RegisterNetEvent("police:carryAI")
AddEventHandler("police:carryAI", function(entity)
    TriggerEvent('carry')
end)

--[[
        exports['zero-eye']:looped_runtime(function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        if distance <= 20 and IsEntityAVehicle(entity) then
            if (entity == last_vehicle_set) then
                return true
            end
        end

    end, {
        [1] = {
            name = "Haal uit voertuig", 
            action = function() 
                TriggerEvent("Zero:Client-Police:SetOutVehicleAneefWholla")
            end,
        },
    }, GetCurrentResourceName(), 5)
]]