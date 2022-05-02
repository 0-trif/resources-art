local DefaultParts = {
    ['engine'] = "engine",
    ['door_dside_f'] = "door",
    ['door_dside_r'] = "door",
    ['door_pside_f'] = "door",
    ['door_pside_r'] = "door",
    ['door_pside_r'] = "door",
    ["wheel_lf"] = "rims",
    ["wheel_rf"] = "rims",
    ["wheel_lr"] = "rims",
    ["wheel_rr"] = "rims",
}


RegisterServerEvent("Zero:Server-Public:ScrapYard")
AddEventHandler("Zero:Server-Public:ScrapYard", function(items)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (items) then
        for k,v in pairs(items) do
            if DefaultParts[k] then
                local amount = v
                Player.Functions.Inventory().functions.add({item = DefaultParts[k], amount = amount})
            else
                -- ban
            end
        end
   
        local random = math.random(1, 2)
        if random == 1 then
            Player.Functions.Inventory().functions.add({item = "spoiler", amount = 1})
        else
            Player.Functions.Inventory().functions.add({item = "carhood", amount = 1})
        end
    end
end)

RegisterServerEvent("Zero:Server-Public:TradeParts")
AddEventHandler("Zero:Server-Public:TradeParts", function(bool)
    local src = source
    local Player = Zero.Functions.Player(src)

    local items = {
        ['spoiler'] = {
            ['part'] = {
                ['metal'] = math.random(1, 2),
                ['iron'] = math.random(1, 2),
                ['aluminium'] = math.random(1, 2),
            },
            ['money'] = math.random(50, 80),
        },
        ['carhood'] = {
            ['part'] = {
                ['metal'] = math.random(1, 2),
                ['iron'] = math.random(1, 2),
                ['aluminium'] = math.random(1, 2),
            },
            ['money'] = math.random(50, 80),
        },
        ['engine'] = {
            ['part'] = {
                ['metal'] = math.random(1, 2),
                ['iron'] = math.random(1, 2),
                ['aluminium'] = math.random(1, 2),
            },
            ['money'] = math.random(5, 10),
        },
        ['door'] = {
            ['part'] = {
                ['metal'] = math.random(1, 2),
                ['iron'] = math.random(1, 2),
                ['aluminium'] = math.random(1, 2),
            },
            ['money'] = math.random(5, 10),
        },
        ['rims'] = {
            ['part'] = {
                ['metal'] = math.random(1, 2),
                ['iron'] = math.random(1, 2),
                ['aluminium'] = math.random(1, 2),
            },
            ['money'] = math.random(2, 8),
        },
    }

    if (bool == "money") then
        local inventory = Player.Functions.Inventory()

        for k,v in pairs(inventory['inventory'])do
            if (items[v['item']]) then
                local money = items[v['item']]['money'] * v['amount']

                Player.Functions.GiveMoney("cash", money, "Onderdelen ingeleverd bij de mechanic (parts voor geld)")

                inventory['functions'].remove({
                    slot = k,
                    amount = v.amount,
                })
            end
        end
    elseif (bool == "parts") then
        local inventory = Player.Functions.Inventory()

        for k,v in pairs(inventory['inventory']) do
            if (items[v['item']]) then
                inventory.functions.remove({
                    slot = k,
                    amount = v.amount
                })

                for key, value in pairs(items[v['item']]['part']) do
                    inventory.functions.add({
                        item = key,
                        amount = value,
                    })
                end
            end
        end
    end
end)
