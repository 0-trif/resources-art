exports["zero-core"]:object(function(O) Zero = O end)

local inventorys = {
    ['kosso'] = {
        {
            item = "lockpick",
            price = 100,
            max = 3,
        },
    }
}

RegisterServerEvent("Zero:Server-Salesmen:Open")
AddEventHandler("Zero:Server-Salesmen:Open", function(name, index)
    local src = source
    TriggerClientEvent("Zero:Client-Salesmen:Open", src, name, inventorys[index], index)
end)


RegisterServerEvent("Zero:Server-Salesmen:Grab")
AddEventHandler("Zero:Server-Salesmen:Grab", function(ui)
    local src = source
    local player = Zero.Functions.Player(src)

    local fromslot = tonumber(ui.fromslot)
    local amount = tonumber(ui.amount)

    if (ui.frominv == "other") then
        local index = ui.extra.index
        
        if (inventorys[index]) then
            if (inventorys[index][fromslot]) then
                local amount = amount <= inventorys[index][fromslot]['max'] and amount or inventorys[index][fromslot]['max']
                local price = inventorys[index][fromslot]['price'] * amount
                local cash = player.Money.cash

                if (cash >= price) then
                    player.Functions.RemoveMoney("cash", price, "Item gekocht bij (salesmen) npc : "..index.."", {
                        title = "Item gekocht bij "..index.."",
                        subtitle = "Item "..inventorys[index][fromslot]['item'].." gekocht."
                    })

                    local inventory = player.Functions.Inventory()
                    inventory.functions.add({
                        slot = tonumber(ui.toslot),
                        item = inventorys[index][fromslot]['item'],
                        amount = amount,
                    })
                    TriggerClientEvent("inventory:client:resyncSlot", src, tonumber(ui.toslot))
                end
            end
        end
    end
end)
