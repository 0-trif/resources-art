
exports['zero-core']:object(function(O)
    Zero = O
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750

        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)

        for k,v in pairs(config.locations) do
            local distance = #(pos - vector3(v.x, v.y, v.z))

            if (distance <= 5) then
                timer = 0

                TriggerEvent("interaction:show", "Werknemers", function()
                    local job = Zero.Functions.GetPlayerData().Job.name
                    if (config.Jobs[job]) then
                        TriggerEvent("Zero:Client-Bossmenu:Open")
                    end
                end)     
            end
        end
        
        Wait(timer)
    end
end)