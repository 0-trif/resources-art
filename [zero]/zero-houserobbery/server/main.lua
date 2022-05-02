CreateThread(function()
    Wait(1000)

    UnlockLocations()

    while true do
        Wait(config.unlockTimer)
        UnlockLocations()
    end
end)



RegisterNetEvent("Zero:Server-Houserobbery:Sync")
AddEventHandler("Zero:Server-Houserobbery:Sync", function()
    local src = source
    TriggerClientEvent("Zero:Client-Houserobbery:Sync", src, config.locations)
end)

RegisterNetEvent("Zero:Server-Houserobbery:Unlock")
AddEventHandler("Zero:Server-Houserobbery:Unlock", function(index)
    local src = source
    config.locations[index]['locked'] = false
    TriggerClientEvent("Zero:Client-Houserobbery:SetData", -1, index, config.locations[index])
end)

RegisterNetEvent("Zero:Server-Houserobbery:SearchedSpot")
AddEventHandler("Zero:Server-Houserobbery:SearchedSpot", function(houseId, index)
    local src = source

    if config.locations[houseId].spots[index] then
        Zero.Functions.Notification(src, 'Zoeken', 'Je hebt niks gevonden', 'error')
        return
    end

    config.locations[houseId].spots[index] = true

    ReciveeRandomItems(src)

    TriggerClientEvent("Zero:Client-Houserobbery:SetData", -1, houseId, config.locations[houseId])
end)

RegisterNetEvent("Zero:Server-Houserobbery:SearchVault")
AddEventHandler("Zero:Server-Houserobbery:SearchVault", function(houseId)
    local src = source
    if config.locations[houseId]['safe'].opened then
        Zero.Functions.Notification(src, 'Kluis', 'Kluis is leeg', 'error')
        return
    end
    config.locations[houseId]['safe'].opened = true
    TriggerClientEvent("Zero:Client-Houserobbery:SetData", -1, houseId, config.locations[houseId])

    local randomId = math.random(1, #config.safe)

    if config.safe[randomId] then
        local player = Zero.Functions.Player(src)
        local inventory = player.Functions.Inventory()

        local data = config.safe[randomId]

        if data.weapon then
            inventory.functions.add({
                item = data.item,
                amount = 1,
                datastash = CreateDatastash(),
            })
        else
            inventory.functions.add({
                item = data.item,
                amount = 1,
            })
        end
    end
end)

RegisterNetEvent("Zero:Server-Houserobbery:NoteCode")
AddEventHandler("Zero:Server-Houserobbery:NoteCode", function(houseId)
    local src = source
    local player = Zero.Functions.Player(src)

    if config.locations[houseId]['safe'] then
        if not config.locations[houseId]['safe'].opened then
            local code = config.locations[houseId]['safe']['code']
            local inventory = player.Functions.Inventory()
        
            inventory.functions.add({
                item = 'stickynote',
                amount = 1,
                datastash = {
                    message = 'Kluis code: '..code..''
                }
            })
        end
    end
end)
