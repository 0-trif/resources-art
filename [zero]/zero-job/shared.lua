Shared = {}
Shared.Police = {}
Shared.Police.Fines = {
    {
        ['label'] = "Artikel 1",
        ['message'] = "Test subtitle voor een artikel",
        ['price'] = 100,
        ['index'] = 1,
    },
    {
        ['label'] = "Artikel 2",
        ['message'] = "Test subtitle voor een artikel",
        ['price'] = 22,
        ['index'] = 2,
    },
    {
        ['label'] = "Artikel 3",
        ['message'] = "Test subtitle voor een artikel",
        ['price'] = 33,
        ['index'] = 3,
    },
    {
        ['label'] = "Artikel 4",
        ['message'] = "Test subtitle voor een artikel",
        ['price'] = 55,
        ['index'] = 4,
    },
}

Shared.Config = {}
Shared.Config.police = {}
Shared.Config.ambulance = {}
Shared.Config.mechanic = {}
Shared.Config.kmar = {}
Shared.Config.taxi = {}

Shared.Config.Duty = {
    {x = 441.28930664063, y = -981.74530029297, z = 30.689561843872, heading = 274.82049560547},
    {x = 309.7262878418, y = -594.13128662109, z = 43.283809661865, heading = 227.40661621094},
    {x = -337.39303588867, y = -161.69432067871, z = 44.587665557861, heading = 82.750579833984},
    {x = 905.7529296875, y = -150.34477233887, z = 74.168266296387, heading = 264.16754150391},
    {x = -446.79370117188, y = 6012.7963867188, z = 32.288711547852, heading = 44.032760620117},
}

Shared.Config.Safes = {
    {x = -340.19876098633, y = -157.22514343262, z = 44.585075378418, heading = 324.01071166992},
    {x = 312.07879638672, y = -597.59002685547, z = 43.284057617188, heading = 203.2735748291},
    {x = 463.19445800781, y = -988.77746582031, z = 30.689876556396, heading = 267.57376098633},
    {x = -446.16738891602, y = 5991.0185546875, z = 36.995681762695, heading = 142.6324005127},
    {x = 909.36004638672, y = -154.31187438965, z = 74.168251037598, heading = 225.01547241211}
}


Shared.Config.police.Kloesoe = {
    [0] = {
        {
            item = "stungun",
            price = 0,
        },
        {
            item = "nightstick",
            price = 0,
        },
        {
            item = "cuffs",
            price = 0,
        },
        {
            item = "flashlight",
            price = 0,
        },
        {
            item = "radio",
            price = 0,
        },
        {
            item = "ifak",
            price = 0,
        },
    },
    [1] = {
        {
            item = "pistol",
            price = 0,
        },
        {
            item = "pistol_ammo",
            price = 0,
        },
    },
    [3] = {
        {
            item = "smg",
            price = 0,
        },
        {
            item = "carbinerifle",
            price = 0,
        },
        {
            item = "pumpshotgun",
            price = 0,
        },
        {
            item = "shotgun_ammo",
            price = 0,
        },
        {
            item = "rifle_ammo",
            price = 0,
        },
        {
            item = "smg_ammo",
            price = 0,
        },
    },
    [5] = {
        {
            item = "heavysniper",
            price = 0,
        },
        {
            item = "sniper_ammo",
            price = 0,
        },
    },
}


Shared.Config.kmar.Kloesoe = {
    [0] = {
        {
            item = "stungun",
            price = 0,
        },
        {
            item = "nightstick",
            price = 0,
        },
        {
            item = "cuffs",
            price = 0,
        },
        {
            item = "flashlight",
            price = 0,
        },
        {
            item = "radio",
            price = 0,
        },
        {
            item = "ifak",
            price = 0,
        },
    },
    [1] = {
        {
            item = "pistol",
            price = 0,
        },
        {
            item = "pistol_ammo",
            price = 0,
        },
    },
    [3] = {
        {
            item = "smg",
            price = 0,
        },
        {
            item = "carbinerifle",
            price = 0,
        },
        {
            item = "pumpshotgun",
            price = 0,
        },
        {
            item = "shotgun_ammo",
            price = 0,
        },
        {
            item = "rifle_ammo",
            price = 0,
        },
        {
            item = "smg_ammo",
            price = 0,
        },
    },
    [5] = {
        {
            item = "heavysniper",
            price = 0,
        },
        {
            item = "sniper_ammo",
            price = 0,
        },
    },
}

Shared.Config.ambulance.Kloesoe = {
    [0] = {
        {
            item = "medkit",
            price = 0,
        },
        {
            item = "bandage",
            price = 0,
        },
        {
            item = "radio",
            price = 0,
        },
        {
            item = "ifak",
            price = 0,
        },
    },
}
Shared.Config.ambulance.Revive = {x = 308.8430480957, y = -592.36492919922, z = 43.284061431885, h = 200.02508544922}

Shared.Config.mechanic.Kloesoe = {
    [0] = {
        {
            item = "repairkit",
            price = 0,
        },
        {
            item = "sponge",
            price = 0,
        },
        {
            item = "radio",
            price = 0,
        },
        {
            item = "tire",
            price = 0,
        },
        {
            item = "petrolcan",
            price = 0,
        },
    },
}


-- vehicles
Shared.Config.ambulance.Vehicles = {
    [1] = {
        model = "Volkswagen Amarok",
        reason = "Ambulance Auto",
        spawnmodel = "ambuamarok",
    },
    [2] = {
        model = "Mercedes E-Klasse",
        reason = "Ambulance Auto",
        spawnmodel = "ambueklasse",
    },
    [3] = {
        model = "BMW Zware Motor",
        reason = "Ambulance Motor",
        spawnmodel = "ambumotor2",
    },
    [4] = {
        model = "Mercedes Sprinter",
        reason = "Ambulance Auto",
        spawnmodel = "ambusprinter",
    },
    [5] = {
        model = "Mercedes Sprinter Otaris",
        reason = "Ambulance Auto",
        spawnmodel = "ambusprinter2",
    },
    [6] = {
        model = "Volkswagen Crafter",
        reason = "Ambulance Auto",
        spawnmodel = "ambucrafter",
    },
    [7] = {
        model = "Volvo XC60",
        reason = "Ambulance Auto",
        spawnmodel = "ambuvolvo",
    },
    [8] = {
        model = "Volvo XC40",
        reason = "Ambulance Auto",
        spawnmodel = "ambuxc40",
    },
}

Shared.Config.mechanic.Vehicles = {
    [1] = {
        model = "Ford Connect",
        reason = "ANWB Verkeer",
        spawnmodel = "anwbconnect",
    },
    [2] = {
        model = "Ford Ranger",
        reason = "ANWB Verkeer",
        spawnmodel = "anwbranger",
    },
    [3] = {
        model = "Volkswagen Touran 2019",
        reason = "ANWB Verkeer",
        spawnmodel = "anwbtourannew",
    },
    [4] = {
        model = "Volkswagen T6",
        reason = "ANWB Verkeer",
        spawnmodel = "anwbt6",
    },
    [5] = {
        model = "Volkswagen Touran",
        reason = "ANWB Verkeer",
        spawnmodel = "anwbtouran",
    },
    [6] = {
        model = "Mercedes Vito",
        reason = "ANWB Verkeer",
        spawnmodel = "anwbvito2",
    },
    [7] = {
        model = "Flatbed",
        reason = "ANWB Flatbed",
        spawnmodel = "flatbed3",
    },
    [8] = {
        model = "Toyota Hilux",
        reason = "ANWB Aanduiding",
        spawnmodel = "anwbhilux",
    },
}

Shared.Config.police.Vehicles = {
    [1] = {
        model = "Audi A6 2016",
        reason = "Verkeers Politie",
        spawnmodel = "pol43",
    },
    [2] = {
        model = "Audi A6 2020",
        reason = "Verkeers Politie",
        spawnmodel = "polaudi",
    },
    [3] = {
        model = "Mercedes B-klasse",
        reason = "Verkeers Politie",
        spawnmodel = "pol11",
    },
    [4] = {
        model = "Volkswagen Touran 2016",
        reason = "Verkeers Politie",
        spawnmodel = "pol3",
    },
    [5] = {
        model = "Volkswagen Touan 2019",
        reason = "Verkeers Politie",
        spawnmodel = "pol36",
    },
    [6] = {
        model = "Volkswagen Touan 2019 Honden",
        reason = "Verkeers Politie",
        spawnmodel = "pol37",
    },
    [7] = {
        model = "Volkswagen Touran 2016 Rijopleiding",
        reason = "Verkeers Politie",
        spawnmodel = "opl1",
    },
    [8] = {
        model = "Volkswagen Passat 2016",
        reason = "Verkeers Politie",
        spawnmodel = "pol32",
    },
    [9] = {
        model = "Volkswagen Amarok",
        reason = "Verkeers Politie",
        spawnmodel = "pol24",
    },
    [10] = {
        model = "Volkswagen Transporter",
        reason = "Verkeers Politie",
        spawnmodel = "pol13",
    },
    [11] = {
        model = "Mercedes Sprinter",
        reason = "Verkeers Politie",
        spawnmodel = "pol12",
    },
    [12] = {
        model = "BMW Dirtbike",
        reason = "Motor Politie",
        spawnmodel = "pol10",
    },
    [13] = {
        model = "Mercedes Arrestantenvervoer",
        reason = "Arrestanten Vervoer",
        spawnmodel = "pol41",
    },
    [14] = {
        model = "Mercedes Actros",
        reason = "Verkeers Politie",
        spawnmodel = "pol34",
    },
    [15] = {
        model = "Ford Takelwagen",
        reason = "Takeldienst",
        spawnmodel = "pol19",
    },
    [16] = {
        model = "Fiets",
        reason = "Verkeers Politie",
        spawnmodel = "pol22",
    },
    [17] = {
        model = "Yamaha Aerox",
        reason = "Motor Politie",
        spawnmodel = "pol35",
    },
    [18] = {
        model = "Yamaha Dirtbike",
        reason = "Motor Politie",
        spawnmodel = "pol27",
    },
    [19] = {
        model = "BMW Zware Motor",
        reason = "Motor Politie",
        spawnmodel = "pol46",
    },
    [20] = {
        model = "Mercedes ME",
        reason = "Verkeers Politie",
        spawnmodel = "pol8",
    },
    [21] = {
        model = "Boot Zwaar",
        reason = "Water Politie",
        spawnmodel = "polboat",
    },
    [22] = {
        model = "Boot Openzee",
        reason = "Water Politie",
        spawnmodel = "polboet",
    },
    [23] = {
        model = "BMW 330i",
        reason = "Unmarked Politie",
        spawnmodel = "dsi1",
    },
    [24] = {
        model = "BMW 5 Serie",
        reason = "Unmarked Politie",
        spawnmodel = "dsi2",
    },
    [25] = {
        model = "BMW X5",
        reason = "Unmarked Politie",
        spawnmodel = "dsi3",
    },
    [26] = {
        model = "Volkswagen Passat",
        reason = "Unmarked Politie",
        spawnmodel = "dsi4",
    },
    [27] = {
        model = "Skoda Superb",
        reason = "Unmarked Politie",
        spawnmodel = "dsi5",
    },
    [28] = {
        model = "Volvo V60",
        reason = "Unmarked Politie",
        spawnmodel = "dsi6",
    },
    [29] = {
        model = "Volvo S60",
        reason = "Unmarked Politie",
        spawnmodel = "dsi7",
    },
    [30] = {
        model = "Audi A6",
        reason = "Unmarked Politie",
        spawnmodel = "dsia6",
    },
    [31] = {
        model = "Audi RS3",
        reason = "Unmarked Politie",
        spawnmodel = "unmarkedrs3",
    },
    [32] = {
        model = "Audi RS6 2020",
        reason = "Unmarked Politie",
        spawnmodel = "unmarkedrs62020",
    },
    [33] = {
        model = "Audi A6 Station",
        reason = "Unmarked Politie",
        spawnmodel = "a6un",
    },
    [34] = {
        model = "BMW 3 Serie",
        reason = "Unmarked Politie",
        spawnmodel = "bmwg20",
    },
    [35] = {
        model = "RangeRover Sport",
        reason = "Unmarked Politie",
        spawnmodel = "botlr",
    },
    [36] = {
        model = "Mercedes C300",
        reason = "Unmarked Politie",
        spawnmodel = "c300",
    },
    [37] = {
        model = "Audi Q7",
        reason = "Unmarked Politie",
        spawnmodel = "ov3",
    },
    [38] = {
        model = "Toyota Hilux",
        reason = "Unmarked Politie",
        spawnmodel = "pland",
    },
    [39] = {
        model = "Audi A8",
        reason = "Unmarked Politie",
        spawnmodel = "polaudia8",
    },
    [40] = {
        model = "BMW Zwaar",
        reason = "Unmarked Politie",
        spawnmodel = "polmotorun",
    },
    [41] = {
        model = "BMW X5 Nieuw",
        reason = "Unmarked Politie",
        spawnmodel = "polx5",
    },
    [42] = {
        model = "Brabus 800 Unmarked",
        reason = "Unmarked Politie",
        spawnmodel = "b800funmarked",
    },
    [42] = {
        model = "Porsche Panamera Unmarked",
        reason = "Unmarked Politie",
        spawnmodel = "panemeraunmarked",
    },
}

Shared.Config.taxi.Vehicles = {
    [1] = {
        model = "Maybach 500",
        reason = "Taxi Luxe",
        spawnmodel = "taxi500",
    },
    [2] = {
        model = "Honda Civic R",
        reason = "Taxi Prioriteit",
        spawnmodel = "taxihonda",
    },
    [3] = {
        model = "Volkswagen Polo",
        reason = "Taxi Casual",
        spawnmodel = "taxipolo",
    },
    [4] = {
        model = "Audi SQ7",
        reason = "Taxi Casual",
        spawnmodel = "taxiq7",
    },
}

Shared.Config.kmar.Vehicles = {
    
}