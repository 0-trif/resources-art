stashes = {}
stashes.created = {}


exports("stashData", function(data)
    if (stashes.created[data.index]) then
        return stashes.created[data.index]['functions']
    else
        stashes.created[data.index]        = receive_stash(data.index)
        stashes.created[data.index].db     = data.database
        stashes.created[data.index].slots  = data.slots
        stashes.created[data.index].index = data.index
        stashes.created[data.index].label  = data.label
        stashes.created[data.index].event = data.event

        if (data.database) then
            stashes.created[data.index].inventory = receive_stash_items(data.index, data.database)
        else
            stashes.created[data.index].inventory = {}
        end

        return stashes.created[data.index]['functions']
    end
end)

exports("openstash", function(data)
    if (data.index) then
        if not stashes.created[data.index] then
            stashes.created[data.index]        = receive_stash(data.index)
            stashes.created[data.index].db     = data.database
            stashes.created[data.index].slots  = data.slots
            stashes.created[data.index].src = data.src
            stashes.created[data.index].index = data.index
            stashes.created[data.index].label  = data.label
            stashes.created[data.index].event = data.event

            stashes.created[data.index].opened = data.src
            
            if (data.database) then
                stashes.created[data.index].inventory = receive_stash_items(data.index, data.database)
                TriggerClientEvent("inventory:client:opensecondary", data.src, stashes.created[data.index])
            else
                stashes.created[data.index].inventory = {}
                TriggerClientEvent("inventory:client:opensecondary", data.src, stashes.created[data.index])
            end
        else
            if stashes.created[data.index].opened and stashes.created[data.index].opened == data.src then
                stashes.created[data.index].opened = nil
            end

            if not stashes.created[data.index].opened then
                stashes.created[data.index].opened = data.src
                stashes.created[data.index].src = data.src
                TriggerClientEvent("inventory:client:opensecondary", data.src, stashes.created[data.index])
            else
                TriggerClientEvent("inventory:client:close", data.src)
            end
        end
    end
end)

receive_stash_items = function(index, db)
    local inv = nil
    
    if (index and db) then
        exports.ghmattimysql:execute("SELECT * FROM `"..db.."` WHERE `index` = '"..index.."'", function(result)
            if (result[1]) then
                local found = json.decode(result[1].items)
                for k,v in pairs(found) do
                    found[tonumber(k)] = v
                end
                inv = found
            else
                inv = {}
                exports.ghmattimysql:execute("INSERT INTO `"..db.."` (`index`, `items`) VALUES ('"..index.."', '"..json.encode({}).."')")
            end
        end)
    end

    while inv == nil do Citizen.Wait(0) end
    return inv
end

receive_stash = function(index) 
    local _ = {}
    _['functions'] = {
        ['get'] = function()
            return stashes.created[index].inventory
        end,
        ['add'] = function(data, ignore)
            local index = index

            if (data.item) then
                data.slot = data.slot ~= nil and data.slot or stashes.created[index].functions.slot(data)

                if (data.slot) then
                    if (stashes.created[index].inventory[data.slot]) then
                        stashes.created[index].inventory[data.slot].amount = stashes.created[index].inventory[data.slot].amount + data.amount
                    else

                        stashes.created[index].inventory[data.slot] = {
                            item = data.item,
                            slot = data.slot,
                            amount = data.amount,
                            datastash = data.datastash ~= nil and data.datastash or generate_item_data(data.item),
                        }
                    end
                    stashes.created[index].functions.save()

                    if not ignore then
                        Zero.Functions.CreateLog("stashes", "Item added", "**Item:** "..data.item.." \n **Amount:**"..data.amount.." \n ** Stashid: ** "..index.."", "green", false)
                    end
                end
            end
        end,
        ['remove'] = function(data, ignore)
            local index = index

            if (data.slot) then
                if not stashes.created[index].inventory[data.slot] then return end
                
                data.amount = data.amount ~= nil and data.amount or 1
                local item  = stashes.created[index].inventory[data.slot].item

                stashes.created[index].inventory[data.slot].amount = stashes.created[index].inventory[data.slot].amount - data.amount

        
                if (stashes.created[index].inventory[data.slot].amount <= 0) then
                    stashes.created[index].inventory[data.slot] = nil
                end
                stashes.created[index].functions.save()
                if not ignore then
                    Zero.Functions.CreateLog("stashes", "Item removed", "**Item:** "..item.." \n **Amount:**"..data.amount.." \n ** Stashid: ** "..index.."", "red", false)
                end
            end
        end,    
        ['swap'] = function(data)
            local index = index

            local NEW_To = copy_inventory_index(stashes.created[index].inventory[data.from], {
                slot = data.to
            })
            local NEW_Fr = copy_inventory_index(stashes.created[index].inventory[data.to], {
                slot = data.from
            })

            stashes.created[index].inventory[data.from] = NEW_Fr
            stashes.created[index].inventory[data.to] = NEW_To

            stashes.created[index].functions.save()
        end,
        ['slot'] = function(data)
            local index = index

            
            if (data.item) then
                for k,v in pairs(stashes.created[index].inventory) do
                    if v.item == data.item and v.amount+data.amount <= shared.config.items[data.item].max then
                        return k
                    end
                end 
                for i=1, shared.config.slots do
                    if (stashes.created[index].inventory[i]) == nil then
                        return i
                    end
                end
            else
                for i=1, shared.config.slots do
                    if (stashes.created[index].inventory[i]) == nil then
                        return i
                    end
                end
            end
        end,
        ['item'] = function(data)
            local index = index

        end,
        ['save'] = function(bool) 
            local index = index

            local _ = {}
            for k,v in pairs(stashes.created[index].inventory)  do
                if v.amount <= 0 then
                    stashes.created[index].inventory[k] = nil
                else
                    _[tonumber(k)] = v
                end
            end

            stashes.created[index].inventory = _

            if stashes.created[index].db and bool then
                exports.ghmattimysql:execute("UPDATE `"..stashes.created[index].db.."` SET `items` = '"..json.encode(_).."' WHERE `index` = '"..index.."'")
            end

            if stashes.created[index].src then
               --TriggerClientEvent("inventory:client:syncstash", stashes.created[index].src, index, stashes.created[index].inventory)
            end
        end,
    }

    return _
end

RegisterServerEvent("inventory:server:stash")
AddEventHandler("inventory:server:stash", function(ui)
    local src = source

    local fromslot = tonumber(ui.fromslot)
    local toslot   = tonumber(ui.toslot)
    local amount   = tonumber(ui.amount)
    local stashid  = ui.extra.stash

    if (ui.frominv == "other" and ui.toinv == "other") then
        if (stashes.created[stashid].inventory[fromslot]) then
            if not (stashes.created[stashid].inventory[toslot]) then
                stashes.created[stashid].functions.add({
                    item = stashes.created[stashid].inventory[fromslot].item,
                    amount = amount,
                    slot = toslot,
                    datastash = stashes.created[stashid].inventory[fromslot].datastash
                }, true)
                stashes.created[stashid].functions.remove({
                    amount = amount,
                    slot = fromslot,
                }, true)
            else
                if (stashes.created[stashid].inventory[fromslot].item == stashes.created[stashid].inventory[toslot].item) then
                    if (stashes.created[stashid].inventory[toslot].amount + amount) <= shared.config.items[stashes.created[stashid].inventory[toslot].item].max then
                        stashes.created[stashid].functions.add({
                            item = stashes.created[stashid].inventory[fromslot].item,
                            amount = amount,
                            slot = toslot,
                            datastash = stashes.created[stashid].inventory[fromslot].datastash
                        }, true)
                        stashes.created[stashid].functions.remove({
                            amount = amount,
                            slot = fromslot,
                        }, true)
                    else
                        stashes.created[stashid].functions.swap({
                            from = fromslot,
                            to   = toslot,
                        })
                    end
                else
                    stashes.created[stashid].functions.swap({
                        from = fromslot,
                        to   = toslot,
                    })
                end
            end
        end
    elseif (ui.frominv == "other" and ui.toinv == "player") then
        if (inventory.players[src].inventory[toslot]) then
            if not stashes.created[stashid].inventory[fromslot] then return end

            if (inventory.players[src].inventory[toslot].item == stashes.created[stashid].inventory[fromslot].item) then
                if (inventory.players[src].inventory[toslot].amount + amount <= shared.config.items[inventory.players[src].inventory[toslot].item].max) then
                    inventory.players[src].functions.add({
                        slot = toslot,
                        amount = amount,
                        item = stashes.created[stashid].inventory[fromslot].item,
                        datastash = stashes.created[stashid].inventory[fromslot].datastash,
                    })
                    stashes.created[stashid].functions.remove({
                        slot = fromslot,
                        amount = amount,
                    })
                else
                    local NEW_PLY = copy_inventory_index(stashes.created[stashid].inventory[fromslot], {
                        slot = toslot
                    })
                    local NEW_STASH = copy_inventory_index(inventory.players[src].inventory[toslot], {
                        slot = fromslot
                    })
        
                    stashes.created[stashid].inventory[fromslot] = NEW_STASH
                    inventory.players[src].inventory[toslot] = NEW_PLY

                    stashes.created[stashid].functions.save()
                    inventory.players[src].functions.save()   
                end
            else
                local NEW_PLY = copy_inventory_index(stashes.created[stashid].inventory[fromslot], {
                    slot = toslot
                })
                local NEW_STASH = copy_inventory_index(inventory.players[src].inventory[toslot], {
                    slot = fromslot
                })
    
                stashes.created[stashid].inventory[fromslot] = NEW_STASH
                inventory.players[src].inventory[toslot] = NEW_PLY

                stashes.created[stashid].functions.save()
                inventory.players[src].functions.save()  
            end
        else
            inventory.players[src].functions.add({
                slot = toslot,
                amount = amount,
                item = stashes.created[stashid].inventory[fromslot].item,
                datastash = stashes.created[stashid].inventory[fromslot].datastash,
            })
            stashes.created[stashid].functions.remove({
                slot = fromslot,
                amount = amount,
            })
        end
    elseif (ui.frominv == "player" and ui.toinv == "other") then

        if inventory.players[src].inventory[fromslot] then
            if (stashes.created[stashid].inventory[toslot]) then
                if (stashes.created[stashid].inventory[toslot].item == inventory.players[src].inventory[fromslot].item) then
                    if (stashes.created[stashid].inventory[toslot].amount + amount <= shared.config.items[stashes.created[stashid].inventory[toslot].item].max) then
                        stashes.created[stashid].functions.add({
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
                        local NEW_PLY = copy_inventory_index(stashes.created[stashid].inventory[toslot], {
                            slot = fromslot
                        })
                        local NEW_STASH = copy_inventory_index(inventory.players[src].inventory[fromslot], {
                            slot = toslot
                        })
            
                        stashes.created[stashid].inventory[toslot] = NEW_STASH
                        inventory.players[src].inventory[fromslot] = NEW_PLY
        
                        stashes.created[stashid].functions.save()
                        inventory.players[src].functions.save()
                    end
                else 
                    local NEW_PLY = copy_inventory_index(stashes.created[stashid].inventory[toslot], {
                        slot = fromslot
                    })
                    local NEW_STASH = copy_inventory_index(inventory.players[src].inventory[fromslot], {
                        slot = toslot
                    })
        
                    stashes.created[stashid].inventory[toslot] = NEW_STASH
                    inventory.players[src].inventory[fromslot] = NEW_PLY

                    stashes.created[stashid].functions.save()
                    inventory.players[src].functions.save()
                end
            else
                stashes.created[stashid].functions.add({
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
        end
    end
end)