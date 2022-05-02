function GetItemsAndSlots(src, recipe)
    local inventory = Zero.Functions.Player(src).Functions.Inventory()

    if inventory then
        local _ = {}

        for k,v in pairs(recipe) do
            _[k] = {
                ['amount'] = 0,
                ['slots'] = {}
            }

            for y,z in pairs(inventory.inventory) do
                if (v.item == z.item) then
                    if (_[k]['amount'] < v.amount) then                 
                        local amount_needed = ((v.amount - _[k]['amount']) <= (z.amount) and (v.amount - _[k]['amount']) or (z.amount))

                        _[k]['amount'] = _[k]['amount'] + amount_needed
                        _[k]['slots'][#_[k]['slots'] + 1] = {
                            amount = amount_needed,
                            slot = y
                        }
                    end
                end
            end

            if (_[k]['amount'] < v.amount) then
                return false
            end 
        end

        return true, _
    else
        return false
    end
end

RegisterServerEvent("Zero:Server-Public:CraftFoodItem")
AddEventHandler("Zero:Server-Public:CraftFoodItem", function(ui)
    local src = source
    local player = Zero.Functions.Player(src)
    local fromslot = tonumber(ui.fromslot)
    local toslot = tonumber(ui.toslot)
    local inventory = player.Functions.Inventory().inventory

    if inventory[toslot] == nil then
        if fromslot then
            local valid, data = GetItemsAndSlots(src, Config.Jobs.chef.Craftables[fromslot]['recipe'])

            if valid and data then
                TriggerClientEvent("inventory:client:close", src)

                for i = 1, #data do
                    for k,v in pairs(data[i]['slots']) do
                        player.Functions.Inventory().functions.remove(v)
                    end
                end

                --TriggerClientEvent("Zero:Client-Inventory:CraftingStarted", src, crafting.items[fromslot].time)
                Citizen.Wait(Config.Jobs.chef.Craftables[fromslot].time)

                player.Functions.Inventory().functions.add({
                    item = Config.Jobs.chef.Craftables[fromslot]['item'],
                    slot = toslot,
                    amount = 1,
                })
            else
                player.Functions.Notification("Baan", "Je hebt niet alle items om dit te craften", "error")
            end
        end
    else
        player.Functions.Notification("Baan", "Craften kan alleen op een leeg slot", "error")
    end
end)

RegisterServerEvent("Zero:Server-Public:GrabItemchef")
AddEventHandler("Zero:Server-Public:GrabItemchef", function(ui)
    local src = source

    local player = Zero.Functions.Player(src)
    local inventory = player.Functions.Inventory()

    local fromslot = tonumber(ui.fromslot)
    local toslot   = tonumber(ui.toslot)
    local amount   = tonumber(ui.amount)

    local shared = exports['zero-inventory']:getConfig()
    local item = Config.Jobs.chef.Ingredients[fromslot]
    local amount = amount <= shared.config.items[item.item].max and amount or shared.config.items[item.item].max

    if (inventory.inventory[toslot]) then
        if (inventory.inventory[toslot].item == item.item) then
            if (inventory.inventory[toslot].amount + amount <= shared.config.items[item.item].max) then
                inventory.functions.add({
                    item = item.item,
                    amount = amount,
                    slot = toslot,
                })
                TriggerClientEvent("inventory:client:resyncSlot", src, toslot)
            end
        end
    else
        if (item) then
            inventory.functions.add({
                item = item.item,
                amount = amount,
                slot = toslot,
            })
            TriggerClientEvent("inventory:client:resyncSlot", src, toslot)
        end
    end
end)


RegisterServerEvent("Zero:Server-Public:FinishOrder")
AddEventHandler("Zero:Server-Public:FinishOrder", function(items)
    local src = source
    local player = Zero.Functions.Player(src)
    local inventory = player.Functions.Inventory()

    local hasAllItems = true

    local _ = {}
    for k,v in pairs(items) do
        _[#_+1] = {
            item = k,
            amount = v,
        }
    end

    local valid, data = GetItemsAndSlots(src, _)

    if valid and data then
        TriggerClientEvent("inventory:client:close", src)

        for i = 1, #data do
            for k,v in pairs(data[i]['slots']) do
                player.Functions.Inventory().functions.remove(v)
            end
        end

        player.Functions.GiveMoney("bank", math.random(80, 110), "bestelling afgeleverd (baan)")
    else
        player.Functions.Notification("Baan", "Je hebt niet alle items in de bestelling geleverd", "error")
    end
end)
