exports["zero-core"]:object(function(O) Zero = O end)

local items = {
    ['phone'] = 30,

    ['chain_1'] = 50,
    ['chain_2'] = 52,
    ['chain_3'] = 54,
    ['chain_4'] = 56,

    ['ring_1'] = 90,
    ['ring_2'] = 122,
}

RegisterServerEvent("Zero:Server-Pawnshop:GiveItems")
AddEventHandler("Zero:Server-Pawnshop:GiveItems", function()
    local src = source
    local player = Zero.Functions.Player(src)
    local personalString = player.User.Citizenid .. "-pawn"
    
    exports['zero-inventory']:openstash({
        index = personalString,
        slots = 25,
        src = src,
        label = "Pandjes winkel",
        event = "inventory:server:stash",
    })
end)

RegisterServerEvent("Zero:Server-Pawnshop:SellItems")
AddEventHandler("Zero:Server-Pawnshop:SellItems", function()
    local src = source
    local player = Zero.Functions.Player(src)
    local personalString = player.User.Citizenid .. "-pawn"

    local stash = exports['zero-inventory']:stashData({
        index = personalString,
        slots = 25,
        label = "Pandjes winkel",
        event = "inventory:server:stash",
    })

    local inventory = stash.get()
    local price = 0
    local notSold = 0

    for slot, v in pairs(inventory) do
        local slot = tonumber(slot)

        if (items[v.item]) then
            stash.remove({
                slot = slot,
                amount = v.amount,
            })
            
            price = price + (items[v.item] * v.amount)
        else
            notSold = notSold + 1
        end
    end

    if notSold > 0 then
        player.Functions.Notification("Pandjeswinkel", "Je kon "..notSold.." spullen niet hier verkopen", "error")
    end

    if price > 0 then
        player.Functions.GiveMoney('cash', price, 'Items verkocht bij pandjeswinkel')
    else
        player.Functions.Notification("Pandjeswinkel", "Je moet eerst spullen geven aan de verkoper", "error")
    end
end)