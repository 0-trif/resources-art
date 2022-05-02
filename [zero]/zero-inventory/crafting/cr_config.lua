crafting = {
}
crafting.items = {
    [1] = {
        ['item'] = "lockpick",
        ['level'] = 0,
        ['time'] = 10000,
        ['exp'] = 10,
        ['recipe'] = {
            {
                ['item'] = "metal",
                ['amount'] = 10,
            },
            {
                ['item'] = "iron",
                ['amount'] = 10,
            },
            {
                ['item'] = "aluminium",
                ['amount'] = 10,
            },
        },
    },
    [2] = {
        ['item'] = "cuffs",
        ['level'] = 100,
        ['exp'] = 20,
        ['recipe'] = {
            {
                ['item'] = "metal",
                ['amount'] = 100,
            },
            {
                ['item'] = "iron",
                ['amount'] = 75,
            },
            {
                ['item'] = "aluminium",
                ['amount'] = 75,
            },
        },
    },
    [3] = {
        ['item'] = "pistol",
        ['level'] = 1000,
        ['exp'] = 50,
        ['recipe'] = {
            {
                ['item'] = "metal",
                ['amount'] = 5000,
            },
            {
                ['item'] = "iron",
                ['amount'] = 4900,
            },
            {
                ['item'] = "aluminium",
                ['amount'] = 5000,
            },
        },
    },
    [4] = {
        ['item'] = "combatpistol",
        ['level'] = 1200,
        ['exp'] = 55,
        ['recipe'] = {
            {
                ['item'] = "metal",
                ['amount'] = 5500,
            },
            {
                ['item'] = "iron",
                ['amount'] = 5200,
            },
            {
                ['item'] = "aluminium",
                ['amount'] = 5500,
            },
        },
    },
    [5] = {
        ['item'] = "akm",
        ['level'] = 1550,
        ['exp'] = 50,
        ['recipe'] = {
            {
                ['item'] = "metal",
                ['amount'] = 15000,
            },
            {
                ['item'] = "iron",
                ['amount'] = 15500,
            },
            {
                ['item'] = "aluminium",
                ['amount'] = 15000,
            },
        },
    },
    [6] = {
        ['item'] = "assaultrifle",
        ['level'] = 1500,
        ['exp'] = 50,
        ['recipe'] = {
            {
                ['item'] = "metal",
                ['amount'] = 12500,
            },
            {
                ['item'] = "iron",
                ['amount'] = 13000,
            },
            {
                ['item'] = "aluminium",
                ['amount'] = 12500,
            },
        },
    },
    [7] = {
        ['item'] = "compactrifle",
        ['level'] = 1200,
        ['exp'] = 50,
        ['recipe'] = {
            {
                ['item'] = "metal",
                ['amount'] = 12000,
            },
            {
                ['item'] = "iron",
                ['amount'] = 13000,
            },
            {
                ['item'] = "aluminium",
                ['amount'] = 12000,
            },
        },
    },
    [8] = {
        ['item'] = "m110",
        ['level'] = 1750,
        ['exp'] = 50,
        ['recipe'] = {
            {
                ['item'] = "metal",
                ['amount'] = 17000,
            },
            {
                ['item'] = "iron",
                ['amount'] = 15500,
            },
            {
                ['item'] = "aluminium",
                ['amount'] = 17000,
            },
        },
    },
}

Citizen.CreateThread(function()  
    crafting.maxlevel = 0
    for k,v in pairs(crafting.items) do
        if v.level > crafting.maxlevel then
            crafting.maxlevel = v.level
        end
    end
end)