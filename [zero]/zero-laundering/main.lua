local location = {x = 1976.6749267578, y = 3819.3840332031, z = 32.45011138916, h = 116.56735992432}
local model = `cs_lestercrest`

exports['zero-core']:object(function(O)
    Zero = O
end)

Citizen.CreateThread(function()
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local ped = CreatePed(24, model, location.x, location.y, location.z, location.h, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanBeTargetted(ped, false)
    SetEntityCanBeDamaged(ped, false)
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750

        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)

        local distance = #(pos - vector3(location.x, location.y, location.z))

        if distance <= 2 then
            timer = 0

            Zero.Functions.DrawText(location.x, location.y, location.z + 1.90, "Ya boi Lester")

            TriggerEvent("interaction:show", "E - Witwassen", function()
                TriggerEvent("Zero:Client-Laundering:Open")
            end)
        end
        
        Wait(timer)
    end
end)