exports["zero-core"]:object(function(O) Zero = O end)


Zero.Commands.Add("si", "Spawn item (admins)", {{name="playerid", help="Playerid van target speler"}, {name="item", help="Item naam"}, {name="amount", help="Hoeveelheid van item"}}, true, function(source, args)
    local id = tonumber(args[1])
    local item = args[2]
    local amount = args[3]

    if (id and item) then
        if (shared.config.items[item]) then
            amount = amount ~= nil and tonumber(amount) or 1
            amount = amount <= shared.config.items[item].max and amount or shared.config.items[item].max
    
            if (inventory.players[id]) then
                inventory.players[id].functions.add({
                    item = item,
                    amount = amount,
                })
            end
        end
    end
end, 1)

Zero.Commands.Add("invsee", "Bekijk spelers inventory (admins)", {{name="playerid", help="Playerid van target speler"}}, true, function(source, args)
    local id = tonumber(args[1])
    local target = Zero.Functions.Player(id)

    if (inventory.players[id]) then
        inventory.players[id].functions.toggle(true)

        TriggerClientEvent("inventory:client:opensecondary", source, {
            ['slots']  = shared.config.slots,
            ['inventory'] = inventory.players[id]['inventory'],
            ['event'] = "inventory:server:search",
            ['index'] = id,
            ['label'] = target.PlayerData.firstname .. " " .. target.PlayerData.lastname
        })
    end
end, 1)


Zero.Commands.Add("clear", "Clear inventory van speler (admins)", {{name="playerid", help="Playerid van target speler"}}, true, function(source, args)
    local id = tonumber(args[1])
    local target = Zero.Functions.Player(id)

    if (inventory.players[id]) then
        inventory.players[id].inventory = {}
        inventory.players[id].functions.save()
    end
end, 1)

RegisterServerEvent("inventory:server:invsee")
AddEventHandler("inventory:server:invsee", function(targetId)
    local src = source
    local Player = Zero.Functions.Player(src)
    local target = Zero.Functions.Player(targetId)

    if ((Player.Job.name == "police" or Player.Job.name == "kmar" and Player.Job.duty) or target.MetaData.ishandcuffed or Zero.Functions.Role(src, 1)) then
        if (inventory.players[targetId]) then
            inventory.players[targetId].functions.toggle(true)
    
            TriggerClientEvent("inventory:client:opensecondary", src, {
                ['slots']  = shared.config.slots,
                ['inventory'] = inventory.players[targetId]['inventory'],
                ['event'] = "inventory:server:search",
                ['index'] = targetId,
                ['label'] = target.PlayerData.firstname .. " " .. target.PlayerData.lastname
            })
        end
    elseif (Player.Job.name == 'police' and Player.Job.duty == false and not target.MetaData.ishandcuffed) then
        Player.Functions.Notification("Fouilleren", "Je moet in dienst zijn hiervoor", "error")
    else
        Player.Functions.Notification("Fouilleren", "Persoon moet geboeid zijn voor deze actie", "error")
    end
end)
