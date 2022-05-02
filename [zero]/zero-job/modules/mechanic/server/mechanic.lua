RegisterServerEvent("Zero:Server-Mechanic:UsedItemRemove")
AddEventHandler("Zero:Server-Mechanic:UsedItemRemove", function(slot)
    local src = source
    local invPlayer = exports['zero-inventory']:user(src)

    invPlayer.functions.remove({
        slot = slot,
        amount = 1,
    })
end)
RegisterServerEvent("mechanic:payed:repair")
AddEventHandler("mechanic:payed:repair", function()
    local src = source
    local player = Zero.Functions.Player(src)

    player.Functions.ValidRemove(800, "Vehicle repair at mechanic", function()
        
    end)
end)

