
exports["zero-core"]:object(function(O) Zero = O end)

Citizen.CreateThread(function()
    counts = {}
    
    while true do

        for k,v in pairs(config.jobs) do
            counts[v] = {duty = 0, offduty = 0}

            local Players = Zero.Functions.GetPlayersByJob(v, false)

            for x,y in pairs(Players) do
                if y.Job.duty then
                    counts[v].duty = counts[v].duty + 1
                else
                    counts[v].offduty = counts[v].offduty + 1
                end
            end
        end


        TriggerClientEvent("Zero:Client-Scoreboard:Sync", -1, counts)

        Wait(10000)
    end
end)