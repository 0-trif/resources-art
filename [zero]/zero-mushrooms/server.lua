Citizen.CreateThread(function()
    Zero.Functions.RegisterItem({'shovel'}, function(src, slot)
        TriggerClientEvent("Zero:Client-Mushrooms:UsedShovel", src)
    end, {
        notify = true,
    })
end)


cached_players = {}
RegisterServerEvent("Zero:Location")
AddEventHandler("Zero:Location", function(dist)
    cached_players[source] = dist
end)


RegisterServerEvent("Zero:Server-Mushrooms:Wash")
AddEventHandler("Zero:Server-Mushrooms:Wash", function(slot)
    local src = source
    local Player = Zero.Functions.Player(src)
    local Inv = Player.Functions.Inventory()

    if Inv.inventory[slot] then
        if Inv.inventory[slot].item == "mushroom" then
            local maxRemove = Inv.inventory[slot].amount
            local remove = math.random(1, 5)

            remove = remove <= maxRemove and remove or maxRemove

            Inv.functions.remove({
                slot = slot,
                amount = remove,
            })
            Inv.functions.add({
                item = "washed-mushroom",
                amount = remove,
            })
        end
    end
end)

RegisterServerEvent("Zero:Server-Mushrooms:WashDryed")
AddEventHandler("Zero:Server-Mushrooms:WashDryed", function(slot)
    local src = source
    local Player = Zero.Functions.Player(src)
    local Inv = Player.Functions.Inventory()

    if Inv.inventory[slot] then
        if Inv.inventory[slot].item == "washed-mushroom" then
            local maxRemove = Inv.inventory[slot].amount
            local remove = math.random(1, 5)

            remove = remove <= maxRemove and remove or maxRemove

            Inv.functions.remove({
                slot = slot,
                amount = remove,
            })

            Inv.functions.add({
                item = "dryed-mushroom",
                amount = remove,
            })
        end
    end
end)

RegisterServerEvent("Zero:Server-Mushrooms:Sell")
AddEventHandler("Zero:Server-Mushrooms:Sell", function()
    local src = source
    local Player = Zero.Functions.Player(src)
    local Inv = Player.Functions.Inventory()
    
    for k,v in pairs(Inv.inventory) do
        if v.item == "dryed-mushroom" then
            local price = v.amount * config.sellPrice

            Inv.functions.remove({
                item = 'dryed-mushroom',
                amount = v.amount,
                slot = k,
            })

            Player.Functions.GiveMoney('black', price, 'Mushrooms verkocht bij sell point')
        end
    end
end)

RegisterServerEvent("Zero:Server-Mushrooms:Farmed")
AddEventHandler("Zero:Server-Mushrooms:Farmed", function()
    local src = source

    if not cached_players[src] then
        print('ban mush')
        return
    end

    if (cached_players[src] <= 5) then
        GiveMushroomItem(src)

        cached_players[src] = nil
    else
        print('ban mush')
    end
end)

function GiveMushroomItem(id)
    local Player = Zero.Functions.Player(id)
    local Inv = Player.Functions.Inventory()

    Inv.functions.add({
        item = 'mushroom',
        amount = math.random(1, 2),
    })
end