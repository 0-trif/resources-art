exports['zero-core']:object(function(O) Zero = O end)
local cached_players = {}
missions = {}

function GiveWeedItem(playerid)
    local player = Zero.Functions.Player(playerid)
    local inventory = player.Functions.Inventory()
    
    inventory.functions.add({
        item = "weed",
        amount = math.random(1, 3),
    })
end

RegisterServerEvent("Zero:Location")
AddEventHandler("Zero:Location", function(dist)
    cached_players[source] = dist
end)

RegisterServerEvent("Zero:Server-Weed:Farmed")
AddEventHandler("Zero:Server-Weed:Farmed", function()
    if not cached_players[source] then
        print('ban')
        return
    end

    if (cached_players[source] <= 5) then
        GiveWeedItem(source)
    else
        print('ban')
    end
end)


random_pickup = function()
    local random = math.random(1, #Config.PickUpLocations)
    return Config.PickUpLocations[random]
end

local missions = {}

RegisterServerEvent("Zero:Server-Weed:LingLing")
AddEventHandler("Zero:Server-Weed:LingLing", function()
    local src = source
    local player = Zero.Functions.Player(source)
    local inventory = player.Functions.Inventory()
    

    local amount = 0

    if missions[src] then
        player.Functions.Notification("Ling Ling", "Je hebt nog een locatie open staan! doe deze eerst")
        return
    end

    missions[src] = 0

    for k,v in pairs(inventory.inventory) do
        if v.item == 'weed' then
            local slot = v.slot
            local item_amount = v.amount

            inventory.functions.remove({
                slot = slot,
                amount = item_amount
            })

            amount = amount + item_amount
        end
    end

    local amount = math.floor(amount / Config.Split)

    if amount > 0 then
        missions[src] = amount

        local name = player.PlayerData.firstname .. " " .. player.PlayerData.lastname

        local location = random_pickup()

        TriggerClientEvent("phone:notification", src, "./images/logos/mail.png", "Ling Ling", "Gegevens voor de nieuwe bestelling bij lingling.com!", 5000) 
        TriggerClientEvent("Zero:Server-Weed:CreatePickup", src, location.x, location.y, location.z, location.h)
        TriggerClientEvent("Zero:Client-Phone:AddMail", src, "Ling Ling", "Locatie van bestelling bij LingLing bv.", Config.MailText(amount, name), location, "https://cdn.discordapp.com/attachments/921801495786164286/939501686286856272/lingling.jpg")
    else
        missions[src] = nil
    end
end)


RegisterServerEvent("Zero:Server-Weed:Gathered")
AddEventHandler("Zero:Server-Weed:Gathered", function()
    local src = source
    local player = Zero.Functions.Player(src)
    local inventory = player.Functions.Inventory()

    if missions[src] then
        inventory.functions.add({
            item = 'trimmed_weed',
            amount = missions[src]
        })
        missions[src] = nil
    else
        print('ban')
    end
end)



RegisterServerEvent("Zero:Server-Weed:Sold")
AddEventHandler("Zero:Server-Weed:Sold", function()
    local player = Zero.Functions.Player(source)
    local inventory = player.Functions.Inventory()

    local slot, data = inventory.functions.item({item = "trimmed_weed"})
    
    if slot then
        local max_amount = (data.amount <= 3 and data.amount) or 3
        local random_amount = math.random(1, max_amount)

        inventory.functions.remove({
            slot = slot,
            amount = random_amount
        })

        local price = Config.WeedPrice * random_amount

        player.Functions.GiveMoney("black", price, "Weed verkocht op straat")
    end
end)