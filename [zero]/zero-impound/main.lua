exports['zero-core']:object(
    function(O)
        Zero = O
    end
)

Citizen.CreateThread(function()
    blip = AddBlipForCoord(config.render.x, config.render.y, config.render.z)
    SetBlipSprite(blip, 487)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 3)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Politie impound")
    EndTextCommandSetBlipName(blip)
end)

-- Job setting

RegisterNetEvent("Zero:Client-Core:JobUpdate")
AddEventHandler("Zero:Client-Core:JobUpdate", function(JobData)
    Zero.Player.Job = JobData
end)

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(1000)
    end
    Zero.Player.Job = Zero.Functions.GetPlayerData().Job
end)

-- interaction

CreateThread(function()
    exports['zero-eye']:looped_runtime("police-imp", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - vector3(config.render.x, config.render.y, config.render.z))
    
        if not Zero.Player.Job then
            Zero.Player.Job = Zero.Functions.GetPlayerData().Job
        end
        if (distance <= 50 and (Zero.Player.Job.name == "police" or Zero.Player.Job.name == "kmar")) then
            if entity and IsEntityAVehicle(entity) then
                return true, GetEntityCoords(entity)
            end
        end
    end, {
        [1] = {
            name = "In beslagnemen", 
            action = function(entity) 
                TriggerEvent("Zero:Client-Impound:OpenChargeMenu", entity)
            end,
        },
    }, GetCurrentResourceName(), 5)
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)

        local distance = #(vector3(config.menu.x, config.menu.y, config.menu.z) - pos)

        if (distance <= 4) then
            timer = 0

            TriggerEvent("interaction:show", "Impound", function()
                TriggerEvent("Zero:Client-Impound:OpenMenu")
            end)
        end
        Wait(timer)
    end
end)