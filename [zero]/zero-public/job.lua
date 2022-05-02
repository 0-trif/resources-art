RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

SearchingJob = false

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end

    Config.Vars = {}
    for k,v in pairs(Config.Locations) do Config.Vars[k] = {} end

    blips()

    GlobalJob = Zero.Functions.GetPlayerData().Job.name
end)

RegisterNetEvent("Zero:Client-Core:JobUpdate")
AddEventHandler("Zero:Client-Core:JobUpdate", function(JobData)
    blips()
    GlobalJob = JobData.name
end)


local blipsx = {}

blips = function()
    for k,v in pairs(blipsx) do
        RemoveBlip(v)
        table.remove(blipsx, k)
    end

    local PlayerData = Zero.Functions.GetPlayerData()
    for k,v in pairs(Config.Blips) do
        if k == PlayerData.Job.name then
            blip = AddBlipForCoord(Config.Locations[k].x, Config.Locations[k].y, Config.Locations[k].z)

            SetBlipSprite (blip, v.blipid)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 0.7)
            SetBlipAsShortRange(blip, true)
            SetBlipColour(blip, v.blipcolour)
    
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Mijn baan")
            EndTextCommandSetBlipName(blip)

            table.insert(blipsx, blip)
        end
    end
end

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("job-find-task", function(coords, entity)
        local ply = PlayerPedId()
        local x = GetEntityCoords(ply)

        for k,v in pairs(Config.Locations) do
            local distance = #(v - x)

            if (distance <= 5) then
                return true, v
            end
        end
    end, {
        [1] = {
            name = "Zoeken naar taak", 
            action = function(entity) 
                SearchForJob()
            end,
        },
    }, GetCurrentResourceName(), 10)
    --[[
        
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local x = GetEntityCoords(ply)
        
        for k,v in pairs(Config.Locations) do
            local distance = #(v - x)

            if (distance <= 10) then
                timer = 0

                Zero.Functions.DrawText(v.x, v.y, v.z, "[X]")
            end
        end

        Wait(timer)
    end
    ]]
end)



function SearchForJob()
    Zero.Functions.GetPlayerData(function(PlayerData)
        TriggerEvent("StartJob", PlayerData.Job.name)
    end)
end