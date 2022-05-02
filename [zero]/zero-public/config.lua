exports['zero-core']:object(function(O) Zero = O end)

Config = {}
Config.Locations = {
    ['scrapyard'] = vector3(-540.17700195313, -1638.0732421875, 19.892700195313),
    ['driver'] = vector3(-1430.21, -453.52, 35.90),
    ['delivery'] = vector3(53.604858398438, 114.75178527832, 79.197120666504),
    ['chef'] = vector3(810.25500488281, -752.96429443359, 26.780849456787)
}

Config.Blips = {
    ['driver'] = {blipid = 523, blipcolour = 3},
    ['scrapyard'] = {blipid = 318, blipcolour = 70},
    ['delivery'] = {blipid = 479, blipcolour = 47},
    ['chef'] = {blipid = 628, blipcolour = 38},
}

Config.Jobs = {}
Config.Jobs.chef = {}
Config.Jobs.chef.Ingredients = {
    {
        item = "burger",
        price = 0,
    },
    {
        item = "patty_raw",
        price = 0,
    },
    {
        item = "salade",
        price = 0,
    },
    {
        item = "tomato",
        price = 0,
    },
    {
        item = "potato",
        price = 0,
    },
    {
        item = "ice",
        price = 0,
    },
    {
        item = "breadcrumbs",
        price = 0,
    },
    {
        item = "onion",
        price = 0,
    },
    {
        item = "wraps",
        price = 0,
    },
    {
        item = "meat",
        price = 0,
    },
    {
        item = "eggs",
        price = 0,
    },
    {
        item = "bacon",
        price = 0,
    },
    {
        item = "toast-bread",
        price = 0,
    },
    {
        item = "flour",
        price = 0,
    },
}
Config.Jobs.chef.Craftables = {
    [1] = {
        ['item'] = "patty_done",
        ['level'] = 0,
        ['time'] = 3000,
        ['unlocked'] = true,
        ['recipe'] = {
            {
                ['item'] = "patty_raw",
                ['amount'] = 1,
            },
        },
    },
    [2] = {
        ['item'] = "burger-done",
        ['level'] = 0,
        ['time'] = 3000,
        ['unlocked'] = true,
        ['recipe'] = {
            {
                ['item'] = "patty_done",
                ['amount'] = 1,
            },
            {
                ['item'] = "burger",
                ['amount'] = 1,
            },
            {
                ['item'] = "tomato",
                ['amount'] = 1,
            },
            {
                ['item'] = "salade",
                ['amount'] = 1,
            },
        },
    },
    [3] = {
        ['item'] = "fries",
        ['level'] = 0,
        ['time'] = 3000,
        ['unlocked'] = true,
        ['recipe'] = {
            {
                ['item'] = "potato",
                ['amount'] = 2,
            },
        },
    },
    [4] = {
        ['item'] = "burrito",
        ['level'] = 0,
        ['time'] = 3000,
        ['unlocked'] = true,
        ['recipe'] = {
            {
                ['item'] = "wraps",
                ['amount'] = 2,
            },
            {
                ['item'] = "meat",
                ['amount'] = 2,
            },
        },
    },
    [5] = {
        ['item'] = "rings",
        ['level'] = 0,
        ['time'] = 3000,
        ['unlocked'] = true,
        ['recipe'] = {
            {
                ['item'] = "onion",
                ['amount'] = 2,
            },
            {
                ['item'] = "breadcrumbs",
                ['amount'] = 1,
            },
        },
    },
    [6] = {
        ['item'] = "breakfast_egg",
        ['level'] = 0,
        ['time'] = 3000,
        ['unlocked'] = true,
        ['recipe'] = {
            {
                ['item'] = "toast-bread",
                ['amount'] = 2,
            },
            {
                ['item'] = "flour",
                ['amount'] = 1,
            },
            {
                ['item'] = "eggs",
                ['amount'] = 2,
            },
            {
                ['item'] = "bacon",
                ['amount'] = 3,
            },
        },
    },
    [7] = {
        ['item'] = "french-toast",
        ['level'] = 0,
        ['time'] = 3000,
        ['unlocked'] = true,
        ['recipe'] = {
            {
                ['item'] = "toast-bread",
                ['amount'] = 2,
            },
            {
                ['item'] = "flour",
                ['amount'] = 2,
            },
        },
    },
    [8] = {
        ['item'] = "pizza",
        ['level'] = 0,
        ['time'] = 3000,
        ['unlocked'] = true,
        ['recipe'] = {
            {
                ['item'] = "flour",
                ['amount'] = 2,
            },
            {
                ['item'] = "meat",
                ['amount'] = 2,
            },
            {
                ['item'] = "eggs",
                ['amount'] = 1,
            },
        },
    },
}

Config.Jobs.chef.Requests = {
    "pizza",
    "french-toast",
    "breakfast_egg",
    "rings",
    "burrito",
    "fries",
    "burger-done"
}