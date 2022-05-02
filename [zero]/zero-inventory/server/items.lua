register = function(array, returnal, data)
    data = data ~= nil and data or {}

    for k,v in pairs(array) do
        inventory.items[v] = nil
        inventory.items[v] = {
            use = returnal,
            remove = data.remove,
            note = data.notify,
            close = data.close,
        }
    end
end

exports('register', register)


Citizen.CreateThread(function()
    local _ = {}
    for k,v in pairs(shared.config.items) do
        if v.type == "attachment" then
            table.insert(_, k)
        end
    end
    Zero.Functions.RegisterItem(_, function(src, slot)
        TriggerClientEvent("Zero:Client-Inventory:AttachmentUsed", src, slot)
    end, {
        remove = false,
        notify = false
    })
end)


Citizen.CreateThread(function()
    local weaponsFound = {}
    for k,v in pairs(shared.config.weapons) do
        table.insert(weaponsFound, k)
    end

    Zero.Functions.RegisterItem(weaponsFound, function(src, slot)
        TriggerClientEvent("inventory:client:weapon", src, slot)
    end, {
        notify = true,
        remove = false,
    })
    
    Zero.Functions.RegisterItem({'rifle_ammo', 'pistol_ammo', 'sniper_ammo', 'shotgun_ammo', 'smg_ammo'}, function(src, slot)
        TriggerClientEvent("inventory:client:useammo", src, slot)
    end, {
        notify = true,
        remove = false,
    })
    
    Zero.Functions.RegisterItem({'cuffs'}, function(src, slot)
        TriggerClientEvent("Zero:Client-Police:UseCuffs", src, slot)
    end, {
        notify = true,
        remove = false,
    })
    
    Zero.Functions.RegisterItem({'idcard', 'driverslicense'}, function(src, slot)
        TriggerClientEvent("Zero:Client-Inventory:UsePersonalCard", src, slot)
    end, {
        notify = true,
        remove = false,
    })
    
    Zero.Functions.RegisterItem({'medkit', 'bandage'}, function(src, slot)
        local Player = Zero.Functions.Player(src)
        local item = Player.Functions.Inventory().functions.SlotData(slot)
    
        TriggerClientEvent("Zero:Client-Ambulance:UseHeals", src, slot, item)
    end, {
        notify = true,
        remove = false,
        close = true
    })
    
    Zero.Functions.RegisterItem({'phone'}, function(src, slot)
        TriggerClientEvent("Zero:Client-Phone:Toggle", src, slot)
    end, {
        notify = true,
        remove = false,
        close = true
    })

    Zero.Functions.RegisterItem({'c4'}, function(src, slot)
        TriggerClientEvent("Zero:Client-Crafting:UsedC4", src)
    end, {
        notify = true,
        remove = false,
    })

    Zero.Functions.RegisterItem({'radio'}, function(src, slot)
        TriggerClientEvent("radio", src)
    end, {
        notify = true,
        remove = false,
        close = true
    })

    Zero.Functions.RegisterItem({'ifak'}, function(src, slot)
        TriggerClientEvent("Zero:Client-Ambulance:Ifak", src, slot)
    end, {
        notify = true,
        remove = false,
    })

    
    Zero.Functions.RegisterItem({'scissors'}, function(src, slot)
        TriggerClientEvent("Zero:Client-Weed:UsedSchissor", src)
    end, {
        notify = true,
        remove = false,
    })

    Zero.Functions.RegisterItem({"nosfuel"}, function(src, item)
        TriggerClientEvent("Zero:Client-Tuner:InstallNosFuel", src)
    end, {
        notify = true,
        remove = true
    })

    Zero.Functions.RegisterItem({"laptop"}, function(src, item)
        TriggerClientEvent("Zero:Client-Laptop:Open", src)
    end, {
        notify = true,
        remove = false
    })

    Zero.Functions.RegisterItem({"stickynote"}, function(src, slot)
        local item = inventory.players[src]['inventory'][slot]

        if item.datastash.message then
            Zero.Functions.Notification(src, "Notitie", "Omschrijving: <br> "..item.datastash.message.."")
        end
    end, {
        notify = true,
        remove = false
    })

    Zero.Functions.RegisterItem({'repairkit', 'sponge', 'tire', 'petrolcan'}, function(src, slot)
        local Player = Zero.Functions.Player(src)
        local item = Player.Functions.Inventory().functions.SlotData(slot)
    
        TriggerClientEvent("Zero:Client-Mechanic:UsedItem", src, slot, item)
    end, {
        notify = true,
        remove = false,
    })
end)
