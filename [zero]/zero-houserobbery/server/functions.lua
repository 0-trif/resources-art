function UnlockLocations()
    local unlocked = 0

    for k,v in pairs(config.locations) do
        if v.enabled then
            canRemove = true
            for y,z in pairs(v.spots) do
                if not z then
                    canRemove = false
                end
            end

            if canRemove then
                v.enabled = false
                v.locked = true
            end

            TriggerClientEvent("Zero:Client-Houserobbery:SetData", -1, k, config.locations[k])
        end
    end

    for k,v in pairs(config.locations) do
        if (v.enabled) then
            unlocked = unlocked + 1
        end
    end

    while unlocked <= 1 do
        local id = math.random(1, #config.locations)

        if not config.locations[id]['enabled'] then
            
            local level = math.random(1, #config.data)

            config.locations[id]['enabled'] = true
            config.locations[id]['level'] = level
            config.locations[id]['locked'] = true
            config.locations[id]['spots'] = {}
            config.locations[id]['safe'] = nil

            for k,v in pairs(config.data[level]['search']) do
                config.locations[id]['spots'][k] = false
            end

            if config.data[level]['safe'] then
                config.locations[id]['safe'] = {}

                config.locations[id]['safe'].opened = false
                config.locations[id]['safe'].code = math.random(1111, 9999)
                config.locations[id]['safe'].offset = config.data[level]['safe']
            end

            debug('new location unlocked :: houserobbery')
            unlocked = unlocked + 1

            TriggerClientEvent("Zero:Client-Houserobbery:SetData", -1, id, config.locations[id])
        end

        Wait(0)
    end
end

function ReciveeRandomItems(id)
    local player = Zero.Functions.Player(id)

    for i = 1, config.reward do
        local index = math.random(1, #config.items)
        local data  = config.items[index]

        local amount = math.random(1, data.max)
        local inventory = player.Functions.Inventory()
        
        inventory.functions.add({
            item = data['item'],
            amount = amount
        })
    end

    local random = math.random(1, 2)
    if random == 2 then
        player.Functions.GiveMoney('cash', math.random(30, 35), 'House robbery cash reward')
    end
end

function debug(...)
    if config.debug then
        print(...)
    end
end

function CreateDatastash()
    local _ = {
        ['ammo'] = 0,
        ['durability'] = math.random(8, 15),
        ['weaponid'] = math.random(111, 999) .. "-ar-" .. math.random(11111, 99999) .. "x"
    }

    return _
end