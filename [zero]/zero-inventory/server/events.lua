RegisterServerEvent("inventory:server:playerloaded")
AddEventHandler("inventory:server:playerloaded", function()
    local src = source
    local player = receive_player(src)
    local uniqueid = receive_unique_id(src)
    
    inventory.players[src] = player

    TriggerClientEvent("inventory:client:receive", src, inventory.players[src].inventory)
    TriggerClientEvent("inventory:client:syncDrops", src, inventory.drops)
end)

function validDrops()
    local _ = {}
    
    for k,v in pairs(inventory.drops) do
        _[tonumber(k)] = v
        _[tonumber(k)].slot = tonumber(v.slot)
    end

    inventory.drops = _

    return inventory.drops
end

RegisterServerEvent("inventory:server:drops")
AddEventHandler("inventory:server:drops", function(ui)
    local src = source

    local fromslot = tonumber(ui.fromslot)
    local toslot   = tonumber(ui.toslot)
    local amount   = tonumber(ui.amount)
    local dropsinv = ui.extra.drops

    local _ = {}
    for k,v in pairs(dropsinv) do
        _[tonumber(v.slot)] = v
    end
    dropsinv = _

    if (ui.frominv == "player" and ui.toinv == "other") then
        if (dropsinv[toslot]) then
            local itemid = dropsinv[toslot].itemid

            if (dropsinv[toslot].item == inventory.players[src].inventory[fromslot].item) then
                if (dropsinv[toslot].amount+amount <= shared.config.items[dropsinv[toslot].item].max) then

                    for k,v in pairs(inventory.drops) do
                        if (v.itemid == itemid) then
                            v.amount = v.amount + amount
                            inventory.players[src].functions.remove({
                                amount = amount,
                                slot = fromslot,
                            })

                            TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                            inventory.players[src].functions.save()
                            return
                        end
                    end
                else
                    for k,v in pairs(inventory.drops) do
                        if (v.itemid == itemid) then
                 
                            local NEW_To = copy_inventory_index(inventory.players[src].inventory[fromslot], {
                                slot = toslot,
                            })
                            local NEW_Fr = copy_inventory_index(v, {
                                slot = fromslot,
                            })

                            v.item = NEW_To.item
                            v.amount = NEW_To.amount
                            v.datastash = NEW_To.datastash
        
                            inventory.players[src].inventory[fromslot].item = NEW_Fr.item
                            inventory.players[src].inventory[fromslot].amount = NEW_Fr.amount
                            inventory.players[src].inventory[fromslot].datastash = NEW_Fr.datastash

                            TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                            inventory.players[src].functions.save()
                            return
                        end
                    end
                end
            else
                for k,v in pairs(inventory.drops) do
                    if (v.itemid == itemid) then
             
                        local NEW_To = copy_inventory_index(inventory.players[src].inventory[fromslot], {
                            slot = toslot,
                        })
                        local NEW_Fr = copy_inventory_index(v, {
                            slot = fromslot,
                        })

                        v.item = NEW_To.item
                        v.amount = NEW_To.amount
                        v.datastash = NEW_To.datastash
    
                        inventory.players[src].inventory[fromslot].item = NEW_Fr.item
                        inventory.players[src].inventory[fromslot].amount = NEW_Fr.amount
                        inventory.players[src].inventory[fromslot].datastash = NEW_Fr.datastash

                        TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                        inventory.players[src].functions.save()
                        return
                    end
                end
            end
        else
            table.insert(inventory.drops, {
                item = inventory.players[src].inventory[fromslot].item,
                amount = amount,
                itemid = "item:".. math.random(1111111, 9999999) .."x",
                loc = ui.extra.location,
                datastash = inventory.players[src].inventory[fromslot].datastash,
                slot = toslot,
            })
            
            inventory.players[src].functions.remove({
                amount = amount,
                slot = fromslot,
            })

            TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
        end
    elseif (ui.frominv == "other" and ui.toinv == "player") then
        local itemid = dropsinv[fromslot].itemid

        if (inventory.players[src].inventory[toslot]) then
            if (dropsinv[fromslot].item == inventory.players[src].inventory[toslot].item) then
                if (inventory.players[src].inventory[toslot].amount+amount <= shared.config.items[inventory.players[src].inventory[toslot].item].max) then
                    local itemid = dropsinv[fromslot].itemid

                    for k,v in pairs(inventory.drops) do
                        if (v.itemid == itemid) then
                            v.amount = v.amount - amount
                            
                            inventory.players[src].functions.add({
                                amount = amount,
                                item = v.item,
                                slot = toslot,
                            })

                            if v.amount <= 0 then
                                table.remove(inventory.drops, k)
                            end

                            TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                            return
                        end
                    end
                else
                    for k,v in pairs(inventory.drops) do
                        if (v.itemid == itemid) then
                
                            local NEW_To = copy_inventory_index(v, {
                                slot = toslot,
                            })
                            local NEW_Fr = copy_inventory_index(inventory.players[src].inventory[toslot], {
                                slot = fromslot,
                            })

                            v.item = NEW_Fr.item
                            v.amount = NEW_Fr.amount
                            v.datastash = NEW_Fr.datastash
        
                            inventory.players[src].inventory[toslot].item = NEW_To.item
                            inventory.players[src].inventory[toslot].amount = NEW_To.amount
                            inventory.players[src].inventory[toslot].datastash = NEW_To.datastash

                            TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                            inventory.players[src].functions.save()
                            return
                        end
                    end
                end
            else
                for k,v in pairs(inventory.drops) do
                    if (v.itemid == itemid) then
            
                        local NEW_To = copy_inventory_index(v, {
                            slot = toslot,
                        })
                        local NEW_Fr = copy_inventory_index(inventory.players[src].inventory[toslot], {
                            slot = fromslot,
                        })

                        v.item = NEW_Fr.item
                        v.amount = NEW_Fr.amount
                        v.datastash = NEW_Fr.datastash
    
                        inventory.players[src].inventory[toslot].item = NEW_To.item
                        inventory.players[src].inventory[toslot].amount = NEW_To.amount
                        inventory.players[src].inventory[toslot].datastash = NEW_To.datastash

                        TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                        inventory.players[src].functions.save()
                        return
                    end
                end
            end
        else
            for k,v in pairs(inventory.drops) do
                if (v.itemid == itemid) then
                    v.amount = v.amount - amount
                    
                    inventory.players[src].functions.add({
                        item = v.item,
                        amount = amount,
                        datastash = v.datastash,
                        slot = toslot,
                    })

                    if v.amount <= 0 then
                        table.remove(inventory.drops, k)
                    end

                    TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                    return
                end
            end
        end
    elseif (ui.frominv == "other" and ui.toinv == "other") then
        if (dropsinv[fromslot]) then
            local dropinv_drag_id = dropsinv[fromslot].itemid

            if (dropsinv[toslot]) then
                local dropinv_drop_id = dropsinv[toslot].itemid

                if (dropsinv[toslot].item == dropsinv[fromslot].item) then
                    if (dropsinv[toslot].amount+amount <= shared.config.items[dropsinv[toslot].item].max) then
                        for k,v in pairs(inventory.drops) do
                            if (v.itemid == dropinv_drag_id) then
                                v.amount = v.amount - amount

                                for k,v in pairs(inventory.drops) do
                                    if (v.itemid == dropinv_drop_id) then
                                        v.amount = v.amount + amount
                                    end
                                end

                                if (v.amount <= 0) then
                                    table.remove(inventory.drops, k)
                                end


                                TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                                return
                            end
                        end
                    else
                        for k,v in pairs(inventory.drops) do
                            if (v.itemid == dropinv_drag_id) then
                                for x,y in pairs(inventory.drops) do
                                    if (y.itemid == dropinv_drop_id) then
                                        local yslot = y.slot
                                        local vslot = v.slot
                                        
                                        inventory.drops[k].slot = yslot
                                        inventory.drops[x].slot = vslot
                                        TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                                        return
                                    end
                                end
                                return
                            end
                        end
                    end
                else
                    for k,v in pairs(inventory.drops) do
                        if (v.itemid == dropinv_drag_id) then
                            for x,y in pairs(inventory.drops) do
                                if (y.itemid == dropinv_drop_id) then
                 
                                    local yslot = y.slot
                                    local vslot = v.slot
                                    
                                    inventory.drops[k].slot = yslot
                                    inventory.drops[x].slot = vslot

                                    TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                                    return
                                end
                            end
                            return
                        end
                    end
                end
            else
                for k,v in pairs(inventory.drops) do
                    if (v.itemid == dropinv_drag_id) then
                        v.amount = v.amount - amount

                        table.insert(inventory.drops, {
                            item = v.item,
                            amount = amount,
                            itemid = "item:".. math.random(1111111, 9999999) .."x",
                            loc = ui.extra.location,
                            datastash = v.datastash,
                            slot = toslot,
                        })
                        
                        if (v.amount <= 0) then
                            table.remove(inventory.drops, k)
                        end

                        TriggerClientEvent("inventory:client:syncDrops", -1, validDrops())
                        return
                    end
                end
            end
        end
    end
end)

RegisterServerEvent("inventory:server:checkWeapon")
AddEventHandler("inventory:server:checkWeapon", function(itemname)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local ply = inventory.players[src]

    local weapon_index = shared.config.weaponKeys[itemname]

    if (weapon_index) then
        local has_weapon, data = ply.functions.item({['item'] = weapon_index})

        if not (has_weapon) then
            --ESX.BanPlayer(src, 'Heeft geprobeerd een ' .. itemname .. ' in te spawnen')
        end
    else
       -- ESX.BanPlayer(src, 'Heeft geprobeerd een ' .. itemname .. ' in te spawnen')
    end
end)

RegisterServerEvent("inventory:server:drag")
AddEventHandler("inventory:server:drag", function(ui)
    local src = source

    local fromslot = tonumber(ui.fromslot)
    local toslot   = tonumber(ui.toslot)
    local amount   = tonumber(ui.amount)

    if (inventory.players[src].inventory[fromslot]) then
        
        if not (inventory.players[src].inventory[toslot]) then
            inventory.players[src].functions.add({
                item = inventory.players[src].inventory[fromslot].item,
                amount = amount,
                slot = toslot,
                datastash = inventory.players[src].inventory[fromslot].datastash,
            }, true)
            inventory.players[src].functions.remove({
                amount = amount,
                slot = fromslot,
            }, true)
        else
            if (inventory.players[src].inventory[fromslot].item == inventory.players[src].inventory[toslot].item) then
                if (inventory.players[src].inventory[toslot].amount + amount) <= shared.config.items[inventory.players[src].inventory[toslot].item].max then

                    inventory.players[src].functions.add({
                        item = inventory.players[src].inventory[fromslot].item,
                        amount = amount,
                        slot = toslot,
                        datastash = inventory.players[src].inventory[fromslot].datastash,
                    }, true)
                    inventory.players[src].functions.remove({
                        amount = amount,
                        slot = fromslot,
                    }, true)
                else
                    inventory.players[src].functions.swap({
                        from = fromslot,
                        to   = toslot,
                    })
                end
            else
                inventory.players[src].functions.swap({
                    from = fromslot,
                    to   = toslot,
                }, true)
            end
        end
    end
end)


RegisterServerEvent("inventory:server:opendashboard")
AddEventHandler("inventory:server:opendashboard", function(plate)
    local src = source
    local vehicle_owned = false

    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `plate` = ?", {
        plate,
    }, function(result)
        if (result[1]) then
            vehicle_owned = true
        end
    end)

    if (vehicle_owned) then
        exports['zero-inventory']:openstash({
            index = plate .. "-dashboard",
            database = "dashboards",
            slots = 8,
            src = src,
            label = "Dashboard",
            event = "inventory:server:stash",
        })
    else
        exports['zero-inventory']:openstash({
            index = plate .. "-dashboard",
            database = nil,
            slots = 8,
            src = src,
            label = "Dashboard",
            event = "inventory:server:stash",
        })
    end
end)

RegisterServerEvent("inventory:Server:trunk")
AddEventHandler("inventory:Server:trunk", function(plate, class)
    local src = source
    local vehicle_owned = false
    local slots = shared.config.trunks[class]
    
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `plate` = ?", {
        plate,
    }, function(result)
        if (result[1]) then
            vehicle_owned = true
        end
    end)

    if slots then
        if (vehicle_owned) then
        exports['zero-inventory']:openstash({
                index = plate .. "-trunk",
                database = "trunks",
                slots = slots,
                src = src,
                label = "Kofferbak",
                event = "inventory:server:stash",
            })
        else
            exports['zero-inventory']:openstash({
                index = plate .. "-trunk",
                database = nil,
                slots = slots,
                src = src,
                label = "Kofferbak",
                event = "inventory:server:stash",
            })
        end
    end
end)

RegisterServerEvent("inventory:server:closestInventory")
AddEventHandler("inventory:server:closestInventory", function(index)
    if (stashes.created[index]) then
        stashes.created[index].opened = false
        stashes.created[index].functions.save(true)
    end

    if (inventory.players[tonumber(index)]) then
        inventory.players[tonumber(index)].functions.toggle(false)
    end
end)

--[[
    RegisterServerEvent("inventory:server:requestSettings")
AddEventHandler("inventory:server:saveSettings", function(settings)
    local src = source
    local uniqueid = receive_unique_id(src)

    TriggerClientEvent("inventory:client:receiveSettings", src, inventory_settings[uniqueid])
end)
]]

RegisterServerEvent("inventory:server:saveSettings")
AddEventHandler("inventory:server:saveSettings", function(settings)
--local src = source
  --  local uniqueid = receive_unique_id(src)

   --- inventory_settings[uniqueid] = settings

   -- SaveResourceFile(resource_name, "./server/data/settings.json", json.encode(inventory_settings, { indent = true }), -1)
end)

RegisterServerEvent("inventory:server:pressed")
AddEventHandler('inventory:server:pressed', function(slot)
    local src = source
    local player = inventory.players[src]
    local inv = player.inventory

    if not Zero.Functions.Player(src).MetaData.ishandcuffed and not Zero.Functions.Player(src).MetaData.dead then

        if (inv) then
            if inv[slot] then
                local item = inv[slot]['item']
                
                if (inventory.items[item]) then
                    inventory.items[item].use(src, slot)
                    if (inventory.items[item].note) then
                        TriggerClientEvent("Zero-inventory:client:note", src, item, 1, "Use")
                    end 
                    if (inventory.items[item].remove) then
                        player.functions.remove({
                            slot = slot,
                            amount = 1,
                        })
                    end

                    if (inventory.items[item].close) then
                        TriggerClientEvent("inventory:client:close", src)
                    end
                end
            end
        end

    end
end)

RegisterServerEvent("Zero-inventory:server:saveammo")
AddEventHandler("Zero-inventory:server:saveammo", function(slot, ammo)
    local src = source
    local player = inventory.players[src]
    local inv = player.inventory

    local slot = tonumber(slot)

    if (player.inventory) then
        if player.inventory[slot] then
            if (shared.config.items[player.inventory[slot].item].type == "weapon") then
                if (player.inventory[slot].datastash) then
                    player.inventory[slot].datastash.ammo = tonumber(ammo)
                    player.functions.save()
                end
            end
        end
    end
end)

RegisterServerEvent("Zero-inventory:server:saveDurability")
AddEventHandler("Zero-inventory:server:saveDurability", function(slot)
    local src = source
    local player = inventory.players[src]
    local inv = player.inventory

    local slot = tonumber(slot)


    if (player.inventory) then
        if player.inventory[slot] then
            if (shared.config.items[player.inventory[slot].item].type == "weapon") then
                if (player.inventory[slot].datastash) then
                    player.inventory[slot].datastash.durability = player.inventory[slot].datastash.durability - 0.2 >= 0 and player.inventory[slot].datastash.durability - 0.2 or 0
                    player.functions.save()
                end
            end
        end
    end
end)

local removeMoney = function(cb, src, price, reason)
    local player = Zero.Functions.Player(src)
    local money = player.Functions.GetMoney("bank")

    if (money >= price) then
        player.Functions.RemoveMoney("bank", price, reason)
        cb(true)
    else
        cb(false)
    end
end

RegisterServerEvent("Zero-inventory:server:removeAmmo")
AddEventHandler("Zero-inventory:server:removeAmmo", function(slot)
    local src = source
    local player = inventory.players[src]

    player.functions.remove({
        slot = slot,
        amount = 1,
    })
    TriggerClientEvent("inventory:client:resyncSlot", src, slot)
end)

RegisterServerEvent("Zero-inventory:shops:buy")
AddEventHandler("Zero-inventory:shops:buy", function(ui, index)
    local src = source

    local fromslot = tonumber(ui.fromslot)
    local toslot   = tonumber(ui.toslot)
    local amount   = tonumber(ui.amount)

    
    local shop_data = shared['config']['shops'][index]
    if (shop_data) then
        local item = shop_data['items'][fromslot]
        local amount = amount <= shared.config.items[item.item].max and amount or shared.config.items[item.item].max
        local price = item.price * amount

        if (inventory.players[src].inventory[toslot]) then
            if (inventory.players[src].inventory[toslot].item == item.item) then
                if (inventory.players[src].inventory[toslot].amount + amount <= shared.config.items[item.item].max) then
                    removeMoney(function(bool)
                        if bool then
                            inventory.players[src].functions.add({
                                item = item.item,
                                amount = amount,
                                slot = toslot,
                            })
                            TriggerClientEvent("inventory:client:resyncSlot", src, toslot)
                        end
                    end, src, price, "Speler kocht "..amount.."x "..item.item.." in een winkel.")
                end
            end
        else
            if (item) then
                removeMoney(function(bool)
                    if (bool) then
                        inventory.players[src].functions.add({
                            item = item.item,
                            amount = amount,
                            slot = toslot,
                        })
                        TriggerClientEvent("inventory:client:resyncSlot", src, toslot)
                    end
                end, src, price, "Speler kocht "..amount.."x "..item.item.." in een winkel.")
            end
        end
    end
end)

RegisterServerEvent("inventory:server:search")
AddEventHandler("inventory:server:search", function(ui)
    local src = source
    
    local index = tonumber(ui.extra.stash)
    local fromslot = tonumber(ui.fromslot)
    local toslot   = tonumber(ui.toslot)
    local amount   = tonumber(ui.amount)

    local player = Zero.Functions.Player(src)
    local target = Zero.Functions.Player(index)

    if player.Job.name == "police" or target.MetaData.ishandcuffed or Zero.Functions.Role(src, 1) then
        if (ui.frominv == "other" and ui.toinv == "player") then
            local amount = amount <= inventory.players[index].inventory[fromslot].amount and amount or inventory.players[index].inventory[fromslot].amount
            if (inventory.players[src].inventory[toslot]) then
                if (inventory.players[src].inventory[toslot].item == inventory.players[index].inventory[fromslot].item) then
                    if (inventory.players[src].inventory[toslot].amount+amount <= shared.config.items[inventory.players[index].inventory[fromslot].item].max) then
                        inventory.players[src].functions.add({
                            slot = toslot,
                            amount = amount,
                            item = inventory.players[index].inventory[fromslot].item,
                            datastash = inventory.players[index].inventory[fromslot].datastash,
                        })
                        inventory.players[index].functions.remove({
                            slot = fromslot,
                            amount = amount,
                        })
                    else
                        local NEW_Fr = copy_inventory_index(inventory.players[src].inventory[toslot], {
                            slot = fromslot,
                        })
                        local NEW_To = copy_inventory_index(inventory.players[index].inventory[fromslot], {
                            slot = toslot,
                        })

                        inventory.players[index].inventory[fromslot] = NEW_Fr
                        inventory.players[src].inventory[toslot] = NEW_To
                        

                        inventory.players[src].functions.save()
                        inventory.players[index].functions.save()
                    end
                else
                    local NEW_Fr = copy_inventory_index(inventory.players[src].inventory[toslot], {
                        slot = fromslot,
                    })
                    local NEW_To = copy_inventory_index(inventory.players[index].inventory[fromslot], {
                        slot = toslot,
                    })

                    inventory.players[index].inventory[fromslot] = NEW_Fr
                    inventory.players[src].inventory[toslot] = NEW_To
                    

                    inventory.players[src].functions.save()
                    inventory.players[index].functions.save()
                end
            else
                inventory.players[src].functions.add({
                    slot = toslot,
                    amount = amount,
                    item = inventory.players[index].inventory[fromslot].item,
                    datastash = inventory.players[index].inventory[fromslot].datastash,
                })
                inventory.players[index].functions.remove({
                    slot = fromslot,
                    amount = amount,
                })
            end
        elseif (ui.toinv == "other" and ui.frominv == 'player') then
            local amount = amount <= inventory.players[src].inventory[fromslot].amount and amount or inventory.players[src].inventory[fromslot].amount
            if (inventory.players[index].inventory[toslot]) then
                if (inventory.players[index].inventory[toslot].item == inventory.players[src].inventory[fromslot].item) then
                    if (inventory.players[index].inventory[toslot].amount+amount <= shared.config.items[inventory.players[src].inventory[fromslot].item].max) then
                        inventory.players[index].functions.add({
                            slot = toslot,
                            amount = amount,
                            item = inventory.players[src].inventory[fromslot].item,
                            datastash = inventory.players[src].inventory[fromslot].datastash,
                        })
                        inventory.players[src].functions.remove({
                            slot = fromslot,
                            amount = amount,
                        })
                    else
                        local NEW_Fr = copy_inventory_index(inventory.players[index].inventory[toslot], {
                            slot = fromslot,
                        })
                        local NEW_To = copy_inventory_index(inventory.players[src].inventory[fromslot], {
                            slot = toslot,
                        })

                        inventory.players[src].inventory[fromslot] = NEW_Fr
                        inventory.players[index].inventory[toslot] = NEW_To
                        

                        inventory.players[src].functions.save()
                        inventory.players[index].functions.save()
                    end
                else
                    local NEW_Fr = copy_inventory_index(inventory.players[index].inventory[toslot], {
                        slot = fromslot,
                    })
                    local NEW_To = copy_inventory_index(inventory.players[src].inventory[fromslot], {
                        slot = toslot,
                    })

                    inventory.players[src].inventory[fromslot] = NEW_Fr
                    inventory.players[index].inventory[toslot] = NEW_To
                    

                    inventory.players[src].functions.save()
                    inventory.players[index].functions.save()
                end
            else
                inventory.players[index].functions.add({
                    slot = toslot,
                    amount = amount,
                    item = inventory.players[src].inventory[fromslot].item,
                    datastash = inventory.players[src].inventory[fromslot].datastash,
                })
                inventory.players[src].functions.remove({
                    slot = fromslot,
                    amount = amount,
                })
            end
        elseif (ui.toinv == 'other' and ui.frominv == 'other') then
            local amount = amount <= inventory.players[index].inventory[fromslot].amount and amount or inventory.players[index].inventory[fromslot].amount

            if (inventory.players[index].inventory[fromslot]) then
            
                if not (inventory.players[index].inventory[toslot]) then
                    inventory.players[index].functions.add({
                        item = inventory.players[index].inventory[fromslot].item,
                        amount = amount,
                        slot = toslot,
                    })
                    inventory.players[index].functions.remove({
                        amount = amount,
                        slot = fromslot,
                    })
                else
                    if (inventory.players[index].inventory[fromslot].item == inventory.players[index].inventory[toslot].item) then
                        if (inventory.players[index].inventory[toslot].amount + amount) <= shared.config.items[inventory.players[index].inventory[toslot].item].max then
        
                            inventory.players[index].functions.add({
                                item = inventory.players[index].inventory[fromslot].item,
                                amount = amount,
                                slot = toslot,
                            })
                            inventory.players[index].functions.remove({
                                amount = amount,
                                slot = fromslot,
                            })
                        else
                            inventory.players[index].functions.swap({
                                from = fromslot,
                                to   = toslot,
                            })
                        end
                    else
                        inventory.players[index].functions.swap({
                            from = fromslot,
                            to   = toslot,
                        })
                    end
                end
            end
        end
    end
end)

RegisterServerEvent("Zero:Server-Inventory:UsePersonalCard")
AddEventHandler("Zero:Server-Inventory:UsePersonalCard", function(item, coord)
    TriggerClientEvent("Zero:Client-Inventory:DisplayCard", -1, item, coord)
end)

RegisterServerEvent("Zero:Server-Inventory:RemoveSlot")
AddEventHandler("Zero:Server-Inventory:RemoveSlot", function(slot)
    inventory.players[source].functions.remove({
        slot = slot,
        amount = 1,
    })
end)

RegisterServerEvent("Zero:Server-Inventory:GiveItemEvent")
AddEventHandler("Zero:Server-Inventory:GiveItemEvent", function(ui, targetid)
    local src = source
    local fromslot = tonumber(ui.slot)
    local amount = tonumber(ui.amount)

    if (fromslot and amount and inventory.players[targetid]) then
        if inventory.players[src].inventory[fromslot] then
            local amount = amount <= inventory.players[src].inventory[fromslot].amount and amount or inventory.players[src].inventory[fromslot].amount

            inventory.players[targetid].functions.add({
                item = inventory.players[src].inventory[fromslot].item,
                amount = amount,
                datastash = inventory.players[src].inventory[fromslot].datastash
            })
            inventory.players[src].functions.remove({
                amount = amount,
                slot = fromslot,
            })
            TriggerClientEvent("inventory:client:resyncSlot", src, fromslot)
        end
    end
end)


RegisterServerEvent("Zero:Server-Inventory:LoadAttachment")
AddEventHandler("Zero:Server-Inventory:LoadAttachment", function(weaponSlot, attachmentSlot)
    local src = source
    local player = Zero.Functions.Player(src)

    if (inventory.players[src]['inventory'][weaponSlot]) then
        local we_item = inventory.players[src]['inventory'][weaponSlot]['item']

        if (shared.config.items[we_item]['type'] == "weapon") then
            local weaponData = shared.config.weapons[we_item]
            
            if (inventory.players[src]['inventory'][attachmentSlot]) then
                local at_item = inventory.players[src]['inventory'][attachmentSlot]['item']

                if (shared.config.items[at_item]['type'] == "attachment") then
                    if (weaponData['attachments'][at_item]) then
                        
                        local datastash = inventory.players[src]['inventory'][weaponSlot]['datastash']
                        datastash.attachments = datastash.attachments ~= nil and datastash.attachments or {}

                        if not (datastash.attachments[at_item]) then
                            datastash.attachments[at_item] = {['index'] = 1}
                            inventory.players[src]['inventory'][weaponSlot]['datastash'] = datastash

                            inventory.players[src].functions.remove({
                                slot = attachmentSlot,
                                amount = 1,
                            })

                            inventory.players[src].functions.save()
                            TriggerClientEvent("Zero:Client-Inventory:ReloadAttachments", src)
                        else
                            player.Functions.Notification("Attachment", "Attachment zit al op wapen", "error")
                        end
                    end
                end
            end
        end
    end
end)

RegisterServerEvent("Zero:Server-Inventory:SetWeaponCompType")
AddEventHandler("Zero:Server-Inventory:SetWeaponCompType", function(slot, type, comp)
    local src = source
    local player = Zero.Functions.Player(src)

    if slot and type and comp then
        if inventory.players[src]['inventory'][slot] then
            if (inventory.players[src]['inventory'][slot]['datastash']['attachments'][type]) then
                inventory.players[src]['inventory'][slot]['datastash']['attachments'][type].index = comp
                inventory.players[src].functions.save()
                TriggerClientEvent("Zero:Client-Inventory:ReloadAttachments", src)
            end
        end
    end
end)


AddEventHandler("playerDropped", function()
    local src = source
    Citizen.Wait(5000)
    inventory.players[src] = nil
end)