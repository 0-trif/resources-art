CREATED_PETS = {}
RegisterServerEvent("Zero:Server-Pets:BuyPet")
AddEventHandler("Zero:Server-Pets:BuyPet", function(index, variation, mods)
    local src = source
    local Player = Zero.Functions.Player(src)
    local price = config.pets[index]['price']

    Player.Functions.ValidRemove(price, 'Huisdier gekocht bij dierenwinkel ('..index..')', function(bool)
        if bool then
            -- creating pet
            local id =  Player.User.Citizenid .. '-' .. math.random(1111, 9999) .. '-' .. index
            local pet_ = pet:new({
                ['model'] = index,
                ['label'] = config.pets[index]['label'],
                ['owner'] = Player.User.Source,
                ['ownerId'] = Player.User.Citizenid,
                ['loc'] = {},
                ['dead'] = 0,
                ['sleeping'] = 0,
                ['variation'] = variation,
                ['mods'] = mods,
                ['id'] = id,
            })

            local mods = mods ~= nil and mods or {}
    
            Zero.Functions.ExecuteSQL(false, "INSERT INTO `pets` (`citizenid`, `model`, `loc`, `dead`, `sleeping`, `id`, `variation`, `mods`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", {
                Player.User.Citizenid,
                index,
                json.encode({}),
                false,
                false,
                id,
                variation,
                json.encode(mods),
            })
    
            CREATED_PETS[#CREATED_PETS+1] = pet_ 

            local inv = Player.Functions.Inventory()

            inv.functions.add({
                item = 'whistle',
                amount = 1,
                datastash = {
                    message = 'Fluitje voor '..config.pets[index]['label']..'',
                    animalId = id,
                }
            })
    
            Player.Functions.Notification("Dierenwinkel", "Huisdier gekocht", "success", 8000)
            TriggerClientEvent("Zero:Client-Pets:AddPet", -1, pet_)
        end
    end)
end)


Citizen.CreateThread(function()
    Zero.Functions.ExecuteSQL(false, 'SELECT * FROM `pets`', function(pets)
        for k,v in pairs(pets) do
            local Owner = Zero.Functions.PlayerByCitizenid(v.citizenid)

            ownerId = nil

            if Owner then
                ownerId = Owner.User.Source
            end

            CREATED_PETS[#CREATED_PETS+1] = pet:new({
                ['model'] = v.model,
                ['label'] = v.label ~= "" and v.label or config.pets[v.model]['label'],
                ['owner'] = ownerId,
                ['ownerId'] = v.citizenid,
                ['loc'] = json.decode(v.loc),
                ['sleeping'] = v.sleeping,
                ['id'] = v.id,
                ['dead'] = v.dead,
                ['variation'] = v.variation,
                ['mods'] = json.decode(v.mods)
            })
        end
    end)
end)

dropped = function(ownerId)
    for k,v in pairs(CREATED_PETS) do
        if v.ownerId == ownerId then
            v.sleeping = 1
            TriggerClientEvent("Zero:Client-Pets:SleepStatus", -1, k, true)

            pet:update(k)
        end
    end
end

RegisterServerEvent("Zero:Server-Core:PlayerLeft")
AddEventHandler("Zero:Server-Core:PlayerLeft", function(UserData)
    dropped(UserData.Citizenid)
end)

RegisterServerEvent("Zero:Server-Pets:BuyWhistle")
AddEventHandler("Zero:Server-Pets:BuyWhistle", function(animalId)
    local src = source
    local whistlePrice = config.whistle
    local Player = Zero.Functions.Player(src)

    for k,v in pairs(CREATED_PETS) do
        if v.id == animalId then
            data = v
        end
    end

    Player.Functions.ValidRemove(whistlePrice, 'Fluitje gekocht', function(bool)
        if bool then
            local inv = Player.Functions.Inventory()
            inv.functions.add({
                item = 'whistle',
                amount = 1,
                datastash = {
                    message = 'Fluitje voor '..data.label..'',
                    animalId = animalId,
                }
            })
        else
            Zero.Functions.Notification(src, "Dierenwinkel", "Je hebt niet genoeg geld", "error")
        end
    end)
end)

RegisterServerEvent("Zero:Server-Pets:RevivedPet")
AddEventHandler("Zero:Server-Pets:RevivedPet", function()
    local Player = Zero.Functions.Player(source)
    Player.Functions.ValidRemove(config.revive, 'Huisdier geholpen bij dierenwinkel', function(bool)

    end)
end)


Citizen.CreateThread(function()
    Zero.Functions.RegisterItem({'whistle'}, function(src, slot)
        local player = Zero.Functions.Player(src)
        local inv = player.Functions.Inventory()
        local data = inv.inventory[slot]

        TriggerClientEvent("Zero:Client-Pets:UsedWhistle", src, slot, data)
    end, {
        notify = true,
        remove = false,
        close = true
    })
end)