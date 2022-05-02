RegisterServerEvent("Zero:Server-Townhall:ChooseJob")
AddEventHandler("Zero:Server-Townhall:ChooseJob", function(job)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Zero.Config.Jobs[job] and not Zero.Config.Jobs[job]['whitelisted']) then
        Player.Functions.SetJob(job, 0)
    else
        -- ban player
    end
end)

RegisterNetEvent("Zero:Server-Townhall:Card")
AddEventHandler("Zero:Server-Townhall:Card", function(card)
    local src = source
    local Player = Zero.Functions.Player(src)
    local prices = {idcard = 5000, driverslicense = 2500}

    if (card == "idcard" or card == "driverslicense") then
        Player.Functions.ValidRemove(prices[card], "Nieuwe kaart gekocht bij gemeentehuis", function(bool)
            if bool then
                Player.Functions.Inventory().functions.add({
                    item = card,
                    amount = 1,
                })
            else
                Player.Functions.Notification("Gemeente", "Niet genoeg geld", "error")
            end
        end)
    else
        -- ban player
    end
end)