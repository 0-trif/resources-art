
Citizen.CreateThread(function()
    Citizen.Wait(3000)

    local foundItems = {}
    for k,v in pairs(Config.Items) do
        table.insert(foundItems, k)
    end

    Zero.Functions.RegisterItem(foundItems, function(src, slot)
        local Player = Zero.Functions.Player(src)
        local item = Player.Functions.Inventory().functions.SlotData(slot)
    
        TriggerClientEvent("consumebles:client:usedFood", src, item, slot)
    end, {
        notify = false,
        remove = false,
    })
end)
