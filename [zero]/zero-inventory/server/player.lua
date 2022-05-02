copy_inventory_index = function(x, y)
    local _ = {}

    for k, v in pairs(x) do
        _[k] = v
    end
    for k, v in pairs(y) do
        _[k] = v
    end

    return _
end
generate_weapon_id = function() 
    return math.random(11,99) .. "-x" .. math.random(111111, 999999) .. "-y"
end
generate_item_data = function(item, src)
    if (shared.config.items[item].type == "weapon") then
        local _ = {
            weaponid = generate_weapon_id(),
            ammo = 0,
            durability = 100,
            attachments = {},
        }
        LogWeaponData(item, _, src)
        return _
    elseif (shared.config.items[item].type == "personal") then
        local _ = {['PlayerData'] = {}}
        local player = Zero.Functions.Player(src)
        
        _.PlayerData = player.PlayerData
        _.PlayerData.Citizenid = player.User.Citizenid

        return _
    elseif (shared.config.items[item].type == "attachment") then
        return {
            index = 1,
        }
    elseif (shared.config.items[item].type == "message") then
        return {
            message = "Hier staat niks..",
        }
    end
    return {}
end

exports("receiveUser", function(id)
    return inventory.players[id]
end)

receive_player = function(src, items) 
    local _ = {}
    _['inventory'] = receive_inventory(src)
    _['functions'] = {
        ['toggle'] = function(bool)
            TriggerClientEvent("Zero-inventory:client:lock", src, bool)
        end,
        ['add'] = function(data, ignore)
            local src = src

            if (data.item) then
                data.slot = data.slot ~= nil and data.slot or inventory.players[src].functions.slot(data)

                if (data.slot) then

                    TriggerClientEvent("Zero-inventory:client:note", src, data.item, data.amount, "Add")

                    if (inventory.players[src].inventory[data.slot]) then
                        inventory.players[src].inventory[data.slot].amount = inventory.players[src].inventory[data.slot].amount + data.amount <= shared.config.items[data.item].max and inventory.players[src].inventory[data.slot].amount + data.amount or shared.config.items[data.item].max
                    else
                        inventory.players[src].inventory[data.slot] = {
                            item = data.item,
                            slot = data.slot,
                            amount = data.amount,
                            datastash = data.datastash ~= nil and data.datastash or generate_item_data(data.item, src),
                        }
                    end
                    inventory.players[src].functions.save()
                    TriggerClientEvent("resyncWeaponProps", src)

                    if not ignore then
                        local ply = Zero.Functions.Player(src)
                        Zero.Functions.CreateLog("playerinv", "Item added", "**Item:** "..data.item.." \n **Amount:**"..data.amount.." \n ** Citizenid: ** "..ply.User.Citizenid.." \n ** Identifier: ** "..ply.User.Identifier.." \n **Source:** "..src.."", "green", false)
                    end
                end
            end
        end,
        ['remove'] = function(data, ignore)
            local src = src

            if (data.slot) then
                if  inventory.players[src].inventory[data.slot] then
                    TriggerClientEvent("Zero-inventory:client:note", src, inventory.players[src].inventory[data.slot].item, data.amount, "Rem")

                    local item = inventory.players[src].inventory[data.slot].item
                    
                    data.amount = data.amount ~= nil and data.amount or 1
                    inventory.players[src].inventory[data.slot].amount = inventory.players[src].inventory[data.slot].amount - data.amount
                    if (inventory.players[src].inventory[data.slot].amount <= 0) then
                        inventory.players[src].inventory[data.slot] = nil
                    end
    
                    inventory.players[src].functions.save()
                    TriggerClientEvent("resyncWeaponProps", src)
    
                    if not ignore then
                        local ply = Zero.Functions.Player(src)
                        Zero.Functions.CreateLog("playerinv", "Item removed", "**Item:** "..item.." \n **Amount:**"..data.amount.." \n ** Citizenid: ** "..ply.User.Citizenid.." \n ** Identifier: ** "..ply.User.Identifier.." \n **Source:** "..src.."", "red", false)
                    end
                end
            end
        end,    
        ['swap'] = function(data)
            local src = src

            local NEW_To = copy_inventory_index(inventory.players[src].inventory[data.from], {
                slot = data.to
            })
            local NEW_Fr = copy_inventory_index(inventory.players[src].inventory[data.to], {
                slot = data.from
            })

            inventory.players[src].inventory[data.from] = NEW_Fr
            inventory.players[src].inventory[data.to] = NEW_To

            inventory.players[src].functions.save()
        end,
        ['receiveSlot']  = function(data)
            local src = src

            data.slot = tonumber(data.slot)

            return inventory.players[src].inventory[data.slot]
        end,
        ['slot'] = function(data)
            local src = src

            
            if (data.item) then
                for k,v in pairs(inventory.players[src].inventory) do
                    if v.item == data.item and v.amount+data.amount <= shared.config.items[data.item].max then
                        return k
                    end
                end 
                for i=1, shared.config.slots do
                    if (inventory.players[src].inventory[i]) == nil then
                        return i
                    end
                end
            else
                for i=1, shared.config.slots do
                    if (inventory.players[src].inventory[i]) == nil then
                        return i
                    end
                end
            end
        end,
        ['item'] = function(data)
            local src = src

            for k,v in pairs(inventory.players[src].inventory) do
                if (data.amount) then
                    if (data.item == v.item and data.amount <= v.amount) then
                        return k,v
                    end
                else
                    if (data.item == v.item) then
                        return k, v
                    end
                end
            end
        end,
        ['save'] = function(bool) 
            local src = src
            local unique_identifier = receive_unique_id(src) 

            local _ = {}
            for k,v in pairs(inventory.players[src].inventory)  do
                if v.amount <= 0 then
                    inventory.players[src].inventory[k] = nil
                else
                    _[tonumber(k)] = v
                end
            end

            inventory.players[src].inventory = _
            
            TriggerClientEvent("inventory:client:receive", src, inventory.players[src].inventory)
            
            if bool then
                exports.ghmattimysql:execute("UPDATE `citizen_inventory` SET `items` = '"..json.encode(inventory.players[src].inventory).."' WHERE `uniqueid` = '"..unique_identifier.."'")
            end
        end,
        ['clear'] = function()
            local src = src
            inventory.players[src].inventory = {}
            inventory.players[src].functions.save()
            TriggerClientEvent("resyncWeaponProps", src)
            TriggerClientEvent("inventory:client:receive", src, inventory.players[src].inventory)
        end,
        ['set'] = function(inv)
            local src = src
            inventory.players[src].inventory = inv
            inventory.players[src].functions.save()
            TriggerClientEvent("resyncWeaponProps", src)
            TriggerClientEvent("inventory:client:receive", src, inventory.players[src].inventory)
        end,
        ['SlotData'] = function(slot)
            return inventory.players[src].inventory[slot]
        end
    }

    return _
end
exports("user", receive_player)

receive_unique_id = function(src)
    local User = Zero.Functions.Player(src)
    return User.User.Citizenid
end

receive_inventory = function(src)
    local unique_identifier = receive_unique_id(src)
    local inv = nil

    exports.ghmattimysql:execute("SELECT * FROM `citizen_inventory` WHERE `uniqueid` = '"..unique_identifier.."'", function(data)
        if (data[1]) == nil then
            exports.ghmattimysql:execute("INSERT INTO `citizen_inventory` (`uniqueid`, `items`) VALUES ('"..unique_identifier.."', '"..json.encode({}).."')")
        end

        loaded_inv = data[1] ~= nil and json.decode(data[1].items) or {}

        inv = {}
        for k,v in pairs(loaded_inv) do
            inv[tonumber(k)] = v
        end
    end)

    while inv == nil do Citizen.Wait(0) end
    return inv
end

LogWeaponData = function(item, weapondata, src)
   if item and weapondata and src then
       local _ = ""

        for k,v in pairs(weapondata) do
            if type(v) == "string" or type(v) == "number" then
                _ = _ .. "**"..k..": **" .. v .. "\n"
            end
        end

        local ply = Zero.Functions.Player(src)
        Zero.Functions.CreateLog("weapons", "Weapon created",  "Weapondata: \n **weapon:** "..item.." \n ".._.." \n Created for player: \n ** Citizenid: ** "..ply.User.Citizenid.." \n ** Identifier: ** "..ply.User.Identifier.." \n **Source:** "..src.."", "red", false)
   end
end