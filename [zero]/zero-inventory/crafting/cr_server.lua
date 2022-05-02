function SetupCraftingIndex(level)
    for k,v in pairs(crafting.items) do
        if (level >= v.level) then
            v.unlocked = true
        else
            v.unlocked = false
        end
    end
    return crafting.items
end


--[[
      local slot, item = inventory.functions.item({
                item = v.item,
                amount = v.amount,
            })

            if (slot and item) then
                table.insert(_, {slot = slot, amount = v.amount})
            else
                return false, nil
            end
]]
function GetItemsAndSlots(src, recipe)
    local inventory = inventory.players[src]

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

function canCraftItem(index, src)
    local src = src
    local player = Zero.Functions.Player(src)
    local metadata = player.MetaData
    local level = metadata.CraftingLevel ~= nil and metadata.CraftingLevel or 0
    local inventory = inventory.players[src]

    if inventory then
        if (crafting.items[index]) then
            if (crafting.items[index].level <= level) then
                local valid, data = GetItemsAndSlots(src, crafting.items[index].recipe)

                if (valid) then
                    return true, data
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

RegisterServerEvent("Zero:Server-Inventory:Crafting")
AddEventHandler("Zero:Server-Inventory:Crafting", function()
    local src = source
    local player = Zero.Functions.Player(src)
    local metadata = player.MetaData
    local level = metadata.CraftingLevel ~= nil and tonumber(metadata.CraftingLevel) or 0
    player.Functions.SetMetaData('CraftingLevel', level)

    local craftingItems = SetupCraftingIndex(level)

    TriggerClientEvent("Zero:Client-Inventory:Crafting", src, craftingItems, level)
end)

RegisterServerEvent("Zero:Server-Inventory:CraftItem")
AddEventHandler("Zero:Server-Inventory:CraftItem", function(ui)
    local src = source
    local player = Zero.Functions.Player(src)
    local fromslot = tonumber(ui.fromslot)
    local toslot = tonumber(ui.toslot)
    local inventory = inventory.players[src].inventory

    local metadata = player.MetaData
    local level = metadata.CraftingLevel ~= nil and tonumber(metadata.CraftingLevel) or 0

    if inventory[toslot] == nil then
        if fromslot then
            local valid, data = canCraftItem(ui.fromslot, src)

            if valid and data then
                TriggerClientEvent("inventory:client:close", src)

                for i = 1, #data do
                    for k,v in pairs(data[i]['slots']) do
                        player.Functions.Inventory().functions.remove(v)
                    end
                end

                TriggerClientEvent("Zero:Client-Inventory:CraftingStarted", src, crafting.items[fromslot].time)
                Citizen.Wait(crafting.items[fromslot].time)

                player.Functions.Inventory().functions.add({
                    item = crafting.items[fromslot]['item'],
                    slot = toslot,
                    amount = 1,
                })

                level = level +  crafting.items[fromslot]['exp']
                player.Functions.SetMetaData('CraftingLevel', level)
                player.Functions.Notification("Crafting", "Je crafting experience is omhoog gegaan met ("..crafting.items[fromslot]['exp'].."xp)")
            else
                player.Functions.Notification("Crafting", "Je hebt niet alle items om dit te craften", "error")
            end
        end
    else
        player.Functions.Notification("Crafting", "Craften kan alleen op een leeg slot", "error")
    end
end)
