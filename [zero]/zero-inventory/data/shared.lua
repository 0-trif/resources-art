shared = {}
shared.config = {}
shared.data = {}

shared.config.keybinds = 6
shared.config.slots = 32
shared.config.MaxWeight = 200

shared.config.items = {
    ['sandwich'] = {['label'] = "Sandwich", ['max'] = 5, ['weight'] = 0.05},
    ['water'] = {['label'] = "Water", ['max'] = 5, ['weight'] = 0.05},
    ['cigarette'] = {['label'] = "Cigarette", ['max'] = 3, ['weight'] = 0.05},
    ['cola'] = {['label'] = "Cola", ['max'] = 5, ['weight'] = 0.05},
    ['twix'] = {['label'] = "Twix", ['max'] = 7, ['weight'] = 0.05},
    ['chips'] = {['label'] = "Chips", ['max'] = 3, ['weight'] = 0.05},
    ['tire'] = {['label'] = "Autoband", ['max'] = 1, ['weight'] = 0.10},
    ['phone'] = {['label'] = "Telefoon", ['max'] = 1, ['weight'] = 0.10},
    ['cuffs'] = {['label'] = "Handboeien", ['max'] = 1, ['weight'] = 1.0},
    ['idcard'] = {['label'] = "Idkaart", ['max'] = 1, ['type'] = "personal", ['weight'] = 0.05},
    ['driverslicense'] = {['label'] = "Rijbewijs",['max'] = 1,['type'] = "personal",['weight'] = 0.05},
    ['medkit'] = {['label'] = "Medkit",['max'] = 3,['weight'] = 1.50},
    ['bandage'] = {['label'] = "Verband",['max'] = 5,['weight'] = 0.25},
    ['repairkit'] = {['label'] = "Repairkit",['max'] = 3,['weight'] = 2.50},
    ['sponge'] = {['label'] = "Spons",['max'] = 3,['weight'] = 0.05},
    ['radio'] = {['label'] = "Portofoon", ['max'] = 1, ['weight'] = 1.25},
    ['nosfuel'] = {['label'] = "NOS Fuel",['max'] = 1,['weight'] = 1.25},
    ['2step'] = {['label'] = "2Step Part",['max'] = 1,['weight'] = 1.25},
    ['cashroll'] = {['label'] = "Cash roll", ['max'] = 100, ['weight'] = 0.01},
    ['scissors'] = {['label'] = "Schaar", ['max'] = 1, ['weight'] = 1.50},
    ['weed'] = {['label'] = "Weed",['max'] = 15,['weight'] = 0.05},
    ['trimmed_weed'] = {['label'] = "Weed",['max'] = 10,['weight'] = 0.15},
    ['lockpick'] = { ['label'] = "Lockpick",['max'] = 3,['weight'] = 2.50},
    ['petrolcan'] = {['label'] = "Benzine",['max'] = 3,['weight'] = 5.00},
    ['ifak'] = {['label'] = "Ifak",['max'] = 3,['weight'] = 7.50},
    ['bag'] = {['label'] = "Rugtas",['max'] = 1,['weight'] = 0.00},
    ['stickynote'] = {['label'] = "Notitie",['max'] = 1,['weight'] = 0.05, ['type'] = "message"},
    ['certificate'] = {['label'] = "Document",['max'] = 1,['weight'] = 0.05, ['type'] = "message"},
    ['whistle'] = {['label'] = "Honden fluitje",['max'] = 1, ['weight'] = 0.25, ['type'] = "message"},


    ['shovel'] = {['label'] = "Schep", ['max'] = 1, ['weight'] = 3.00},

    ['mushroom'] = {['label'] = "Paddenstoel", ['max'] = 25, ['weight'] = 0.05},
    ['washed-mushroom'] = {['label'] = "Gewassen paddenstoel", ['max'] = 25, ['weight'] = 0.05},
    ['dryed-mushroom'] = {['label'] = "Gedroogde paddenstoel", ['max'] = 25, ['weight'] = 0.05},

    ['door'] = {['label'] = "Auto deur",['max'] = 1,['weight'] = 2.50},
    ['engine'] = {['label'] = "Motorblok",['max'] = 1,['weight'] = 2.50},
    ['spoiler'] = {['label'] = "Spoiler",['max'] = 1,['weight'] = 2.50},
    ['carhood'] = {['label'] = "Motorkap",['max'] = 1,['weight'] = 2.50},
    ['rims'] = {['label'] = "Velg",['max'] = 4,['weight'] = 2.50},

    ['chain_1'] = {['label'] = "Gouden ketting",['max'] = 1,['weight'] = 3.50},
    ['chain_2'] = {['label'] = "Gouden ketting",['max'] = 1,['weight'] = 3.50},
    ['chain_3'] = {['label'] = "Gouden ketting",['max'] = 1,['weight'] = 3.50},
    ['chain_4'] = {['label'] = "Gouden ketting",['max'] = 1,['weight'] = 3.50},

    ['ring_1'] = {['label'] = "Zilvere ring",['max'] = 1,['weight'] = 2.50},
    ['ring_2'] = {['label'] = "Gouden ring",['max'] = 1,['weight'] = 2.50},
    ['laptop'] = {['label'] = "Artbook", ['max'] = 1,['weight'] = 5.00},

    ['burger'] = {['label'] = "Burger broodje", ['max'] = 1,['weight'] = 2.50},
    ['patty_raw'] = {['label'] = "Burger (rauw)", ['max'] = 1,['weight'] = 2.50},
    ['patty_done'] = {['label'] = "Burger (rauw)", ['max'] = 1,['weight'] = 2.50},
    ['salade'] = {['label'] = "Salade", ['max'] = 1, ['weight'] = 2.50},
    ['tomato'] = {['label'] = "Tomaat", ['max'] = 1, ['weight'] = 2.50},
    ['burger-done'] = {['label'] = "Hamburger", ['max'] = 5, ['weight'] = 2.50},
    ['fries'] = {['label'] = "Frietjes", ['max'] = 1, ['weight'] = 2.50},
    ['potato'] = {['label'] = "Aardappelen", ['max'] = 1, ['weight'] = 2.50},

    ['burrito'] = {['label'] = "Burrito", ['max'] = 2, ['weight'] = 2.50},
    ['rings'] = {['label'] = "Uienringen", ['max'] = 3, ['weight'] = 2.50},
    ['breakfast_egg'] = {['label'] = "Ontbijt ei", ['max'] = 1, ['weight'] = 2.50},
    ['french-toast'] = {['label'] = "Toast", ['max'] = 1, ['weight'] = 2.50},
    ['ice'] = {['label'] = "Italiaans ijs", ['max'] = 3, ['weight'] = 2.50},
    ['pizza'] = {['label'] = "Pizza", ['max'] = 3, ['weight'] = 2.50},

    ['breadcrumbs'] = {['label'] = "Broodkruimels", ['max'] = 1, ['weight'] = 2.50},
    ['onion'] = {['label'] = "Uien", ['max'] = 1, ['weight'] = 2.50},
    ['wraps'] = {['label'] = "Wrap", ['max'] = 1, ['weight'] = 2.50},
    ['meat'] = {['label'] = "Gehakt", ['max'] = 1, ['weight'] = 2.50},
    ['eggs'] = {['label'] = "Eieren", ['max'] = 1, ['weight'] = 2.50},
    ['bacon'] = {['label'] = "Spek", ['max'] = 1, ['weight'] = 2.50},
    ['toast-bread'] = {['label'] = "Toast", ['max'] = 1, ['weight'] = 2.50},
    ['flour'] = {['label'] = "Bloemmeel", ['max'] = 1, ['weight'] = 2.50},
    -- weapons
    ['compactrifle'] = {
        ['label'] = "Compact rifle",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 25.00,
    },

    ['assaultrifle'] = {
        ['label'] = "Assault rifle",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 25.00,
    },
    ['pistol'] = {
        ['label'] = "Pistool",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 25.00,
    },
    ['sniper'] = {
        ['label'] = "Sniper",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 35.00,
    },
    ['heavysniper'] = {
        ['label'] = "Heavysniper",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 35.00,
    },
    ['katana'] = {
        ['label'] = "Katana",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 15.00,
    },
    ['cursed_katana'] = {
        ['label'] = "Katana",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 15.00,
    },
    ['carradio'] = {
        ['label'] = "Auto radio",
        ['max'] = 1,
        ['weight'] = 2.50,
    },
    ['carbinerifle'] = {
        ['label'] = "Carbine rifle",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 25.00,
    },
    ['akm'] = {
        ['label'] = "AKM Rifle",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 25.00,
    },

    ['flashlight'] = {
        ['label'] = "Zaklamp",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 5.00,
    },

    ['hatchet'] = {
        ['label'] = "Axe",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 15.00,
    },

    ['switchblade'] = {
        ['label'] = "Switchblade",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 6.00,
    },
    
    ['combatpistol'] = {
        ['label'] = "Combatpistol",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 10.00,
    },
    ['stungun'] = {
        ['label'] = "Taser",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 10.00,
    },
    ['nightstick'] = {
        ['label'] = "Wapenstok",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 2.50,
    },
    ['smg'] = {
        ['label'] = "SMG",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 17.50,
    },
    ['pumpshotgun'] = {
        ['label'] = "Shotgun",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 27.00,
    },
    ['m110'] = {
        ['label'] = "M110",
        ['max'] = 1,
        ['type'] = "weapon",
        ['weight'] = 50.00,
    },

    -- ammo
    ['rifle_ammo'] = {
        ['label'] = "Ammo | rifle",
        ['max'] = 5,
        ['weight'] = 0.05,
    },
    ['pistol_ammo'] = {
        ['label'] = "Ammo | pistol",
        ['max'] = 5,
        ['weight'] = 0.05,
    },
    ['sniper_ammo'] = {
        ['label'] = "Ammo | sniper",
        ['max'] = 5,
        ['weight'] = 0.05,
    },
    ['shotgun_ammo'] = {
        ['label'] = "Ammo | shotgun",
        ['max'] = 5,
        ['weight'] = 0.05,
    },
    ['smg_ammo'] = {
        ['label'] = "Ammo | SMG",
        ['max'] = 5,
        ['weight'] = 0.05,
    },

    --craft

    ['metal'] = {
        ['label'] = "Metaal",
        ['max'] = 500,
        ['weight'] = 0.01,
    },
    ['aluminium'] = {
        ['label'] = "Aluminium",
        ['max'] = 500,
        ['weight'] = 0.01,
    },
    ['iron'] = {
        ['label'] = "Ijzer",
        ['max'] = 500,
        ['weight'] = 0.01,
    },
    ['plastic'] = {
        ['label'] = "Plastic",
        ['max'] = 500,
        ['weight'] = 0.01,
    },
}

exports("items", function()
    return shared.config.items
end)

CreateThread(function()
    for k,v in pairs(shared.config.items) do
        v.type = v.type ~= nil and v.type or "item"
    end
end)

shared.config.backEngine = {
    'ninef',
    'adder',
    'vagner',
    't20',
    'infernus',
    'zentorno',
    'reaper',
    'comet2',
    'comet3',
    'jester',
    'jester2',
    'cheetah',
    'cheetah2',
    'prototipo',
    'turismor',
    'pfister811',
    'ardent',
    'nero',
    'nero2',
    'tempesta',
    'vacca',
    'bullet',
    'osiris',
    'entityxf',
    'turismo2',
    'fmj',
    're7b',
    'tyrus',
    'italigtb',
    'penetrator',
    'monroe',
    'ninef2',
    'stingergt',
    'surfer',
    'surfer2',
    'comet3',
    'xa21',
}

shared.config.trunks = {
    [0] = 9, -- compacts
	[1] = 12, -- sendans
	[2] = 20, -- suvs
	[3] = 13, -- coupes
	[4] = 14, -- muscle
	[5] = 12, -- sports classics
	[6] = 12, -- sports
	[7] = 8, -- super
	[8] = 2, -- motors
	[9] = 20, -- off-road
	[10] = 30, -- industrial
	[11] = 0, -- utilty
	[12] = 25, -- vans
	[13] = 0, -- cycles
	[14] = 10, -- boats
	[15] = 10, -- heli
	[16] = 15, -- planes
	[17] = 9, -- service
	[18] = 10, -- emergency
	[19] = 10, -- military
	[20] = 10, -- commercial
	[21] = 0, -- trains
}

shared.config.weaponKeys = {}
shared.config.weapons = {
    ['switchblade'] = {
        objective = "WEAPON_SWITCHBLADE",
        objectivemodel = `WEAPON_SWITCHBLADE`,
        objectivename  = "Switchblade",
        objectammo = 0,
        objectclip = 0,
        heavy = false,
        ammotype = "=",
        ignoreObject = true,
    },
    ['hatchet'] = {
        objective = "WEAPON_HATCHET",
        objectivemodel = `WEAPON_HATCHET`,
        objectivename  = "Axe",
        objectammo = 0,
        objectclip = 0,
        heavy = true,
        ammotype = "=",
    },
    ['compactrifle'] = {
        objective = "WEAPON_COMPACTRIFLE",
        objectivemodel = 1649403952,
        objectivename  = "Compact rifle",
        objectammo = 200,
        objectclip = 25,
        heavy = true,
        ammotype = "rifle_ammo",
        attachments = {
            ['rifle_clip'] = {
                "COMPONENT_COMPACTRIFLE_CLIP_01",
                "COMPONENT_COMPACTRIFLE_CLIP_02",
                "COMPONENT_COMPACTRIFLE_CLIP_03"
            }
        }
    },
    ['assaultrifle'] = {
        objective = "WEAPON_ASSAULTRIFLE",
        objectivemodel = -1074790547,
        objectivename  = "Assault rifle",
        objectammo = 200,
        objectclip = 25,
        heavy = true,
        ammotype = "rifle_ammo",
        attachments = {
            ['rifle_clip'] = {
                "COMPONENT_ASSAULTRIFLE_CLIP_01",
                "COMPONENT_ASSAULTRIFLE_CLIP_02",
                "COMPONENT_ASSAULTRIFLE_CLIP_03",
            },
            ['weapon_flashlight'] = {
                "COMPONENT_AT_AR_FLSH",
            },
            ['rifle_scope'] = {
                "COMPONENT_AT_SCOPE_MACRO"
            },
            ['rifle_suppressor'] = {
                "COMPONENT_AT_AR_SUPP_02"
            },
            ['rifle_grip'] = {
                "COMPONENT_AT_AR_AFGRIP"
            },
            ['assault-skin'] = {
                "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
            }
        }
    },
    ['pistol'] = {
        objective = "WEAPON_PISTOL",
        objectivemodel = `WEAPON_PISTOL`,
        objectivename  = "Pistool",
        objectammo = 200,
        heavy = false,
        objectclip = 25,
        ammotype = "pistol_ammo",
        attachments = {
            ['pistol_clip'] = {
                "COMPONENT_PISTOL_CLIP_01",
                "COMPONENT_PISTOL_CLIP_02"
            },
            ['weapon_flashlight'] = {"COMPONENT_AT_PI_FLSH"},
            ['pistol_suppressor'] = {"COMPONENT_AT_PI_SUPP_02"},
        }
    },
    ['katana'] = {
        objective = "weapon_katana",
        objectivemodel = `weapon_katana`,
        objectivename  = "Katana",
        objectammo = 1,
        heavy = true,
        rotation = -120.00,
        top = 0.35,
        back = 0.15,
        objectclip = 1,
        ammotype = "", 
    },
    ['cursed_katana'] = {
        objective = "weapon_katana",
        objectivemodel = `weapon_katana`,
        objectivename  = "Katana",
        objectammo = 1,
        rotation = -120.00,
        top = 0.35,
        back = 0.15,
        heavy = true,
        objectclip = 1,
        ammotype = "", 
    },
    ['sniper'] = {
        objective = "WEAPON_SNIPERRIFLE",
        objectivemodel = `WEAPON_SNIPERRIFLE`,
        objectivename  = "Sniper",
        objectammo = 5,
        objectclip = 2,
        ammotype = "sniper_ammo", 
        heavy = true,
        attachments = {
            ['sniper_scope'] = {
                "COMPONENT_AT_SCOPE_LARGE",
                "COMPONENT_AT_SCOPE_MAX"
            },
        },
        rotation = -180.00,
        top = 0.35,
        back = 0.15,
    },
    ['heavysniper'] = {
        objective = "WEAPON_HEAVYSNIPER",
        objectivemodel = `WEAPON_HEAVYSNIPER`,
        objectivename  = "Sniper",
        objectammo = 5,
        heavy = true,
        objectclip = 2,
        ammotype = "sniper_ammo", 
        attachments = {
            ['sniper_scope'] = {
                "COMPONENT_AT_SCOPE_LARGE",
                "COMPONENT_AT_SCOPE_MAX"
            },
        },
        rotation = -180.00,
        top = 0.35,
        back = 0.15,
    },
    ['carbinerifle'] = {
        objective = "WEAPON_CARBINERIFLE",
        objectivemodel = `WEAPON_CARBINERIFLE`,
        objectivename  = "Carbinerifle",
        objectammo = 200,
        heavy = true,
        objectclip = 25,
        ammotype = "rifle_ammo", 
        attachments = {
            ['rifle_clip'] = {
                "COMPONENT_CARBINERIFLE_CLIP_01",
                "COMPONENT_CARBINERIFLE_CLIP_02",
                "COMPONENT_CARBINERIFLE_CLIP_03"
            },
            ['weapon_flashlight'] = {
                "COMPONENT_AT_AR_FLSH"
            },
            ['rifle_scope'] = {
                "COMPONENT_AT_SCOPE_MEDIUM"
            },
            ['rifle_suppressor'] = {
                "COMPONENT_AT_AR_SUPP"
            },
            ['rifle_grip'] = {
                "COMPONENT_AT_AR_AFGRIP"
            },
            ['carbine-skin'] = {
                "COMPONENT_CARBINERIFLE_VARMOD_LUXE",
            }
        }
    },
    ['m110'] = {
        objective = "weapon_m110",
        objectivemodel = `weapon_m110`,
        objectivename  = "M110",
        objectammo = 200,
        heavy = true,
        objectclip = 25,
        ammotype = "rifle_ammo", 
        attachments = {
            ['rifle_clip'] = {
                "COMPONENT_M110_CLIP_01",
                "COMPONENT_M110_CLIP_02",
                "COMPONENT_M110_CLIP_04",
                "COMPONENT_M110_CLIP_05",
                "COMPONENT_M110_CLIP_06",
                "COMPONENT_M110_CLIP_07",
                "COMPONENT_M110_CLIP_08",
                "COMPONENT_M110_CLIP_09",
                "COMPONENT_M110_CLIP_10",
            },
            ['weapon_flashlight'] = {
                "COMPONENT_M110_FLSH_01",
                "COMPONENT_M110_FLSH_02",
                "COMPONENT_M110_FLSH_03",
                "COMPONENT_M110_FLSH_04",
                "COMPONENT_M110_FLSH_05",
                "COMPONENT_M110_FLSH_06",
                "COMPONENT_M110_FLSH_07",
                "COMPONENT_M110_FLSH_08",
                "COMPONENT_M110_FLSH_09",
                "COMPONENT_M110_FLSH_10",
                "COMPONENT_M110_FLSH_11",
            },
            ['rifle_scope'] = {
                "COMPONENT_M110_SCOPE_01",
                "COMPONENT_M110_SCOPE_02",
                "COMPONENT_M110_SCOPE_03",
                "COMPONENT_M110_SCOPE_04",
                "COMPONENT_M110_SCOPE_05",
                "COMPONENT_M110_SCOPE_06",
                "COMPONENT_M110_SCOPE_07",
                "COMPONENT_M110_SCOPE_08",
                "COMPONENT_M110_SCOPE_09",
                "COMPONENT_M110_SCOPE_10",
                "COMPONENT_M110_SCOPE_11",
            },
            ['rifle_suppressor'] = {
                "COMPONENT_M110_SUPP_01",
                "COMPONENT_M110_SUPP_02",
                "COMPONENT_M110_SUPP_03",
                "COMPONENT_M110_SUPP_04",
                "COMPONENT_M110_SUPP_05",
                "COMPONENT_M110_SUPP_06",
                "COMPONENT_M110_SUPP_07",
            },
            ['rifle_grip'] = {
                "COMPONENT_M110_GRIP_01",
                "COMPONENT_M110_GRIP_02",
                "COMPONENT_M110_GRIP_03",
                "COMPONENT_M110_GRIP_04",
                "COMPONENT_M110_GRIP_05",
                "COMPONENT_M110_GRIP_06",
            },
            ['rifle_stock'] = {
                "COMPONENT_M110_STOCK_01",
                "COMPONENT_M110_STOCK_02",
                "COMPONENT_M110_STOCK_03",
                "COMPONENT_M110_STOCK_04",
                "COMPONENT_M110_STOCK_05",
                "COMPONENT_M110_STOCK_06",
                "COMPONENT_M110_STOCK_07",
                "COMPONENT_M110_STOCK_08",
                "COMPONENT_M110_STOCK_09",
            },
            ['rifle_bipod'] = {
                "COMPONENT_M110_BIPOD_01",
                "COMPONENT_M110_BIPOD_02",
            },
        } 
    },
    ['akm'] = {
        objective = "WEAPON_AKM",
        objectivemodel = `WEAPON_AKM`,
        objectivename  = "AKM Rifle",
        objectammo = 200,
        heavy = true,
        objectclip = 25,
        ammotype = "rifle_ammo",
        attachments = {
            ['rifle_scope'] = {
                "COMPONENT_AKM_SCOPE_01",
                "COMPONENT_AKM_SCOPE_02",
                "COMPONENT_AKM_SCOPE_03",
                "COMPONENT_AKM_SCOPE_04", 
                "COMPONENT_AKM_SCOPE_05",
                "COMPONENT_AKM_SCOPE_06",
                "COMPONENT_AKM_SCOPE_07",
                "COMPONENT_AKM_SCOPE_08",
                "COMPONENT_AKM_SCOPE_09"
            },
            ['rifle_grip'] = {
                "COMPONENT_AKM_PISTOLGRIP_01",
                "COMPONENT_AKM_PISTOLGRIP_02",
                "COMPONENT_AKM_PISTOLGRIP_03",
                "COMPONENT_AKM_PISTOLGRIP_04",
                "COMPONENT_AKM_PISTOLGRIP_05",
            },
            ['rifle_suppressor'] = {
                "COMPONENT_AKM_SUPP_01",
                "COMPONENT_AKM_SUPP_02",
                "COMPONENT_AKM_SUPP_03",
            },
            ['rifle_stock'] = {
                "COMPONENT_AKM_STOCK_01",
                "COMPONENT_AKM_STOCK_02",
                "COMPONENT_AKM_STOCK_03",
                "COMPONENT_AKM_STOCK_04",
                "COMPONENT_AKM_STOCK_05",
                "COMPONENT_AKM_STOCK_06",
                "COMPONENT_AKM_STOCK_07",
                "COMPONENT_AKM_STOCK_08",
                "COMPONENT_AKM_STOCK_09",
            },
            ['rifle_clip'] = {
                "COMPONENT_AKM_CLIP_01",
                "COMPONENT_AKM_CLIP_02",
                "COMPONENT_AKM_CLIP_03",
                "COMPONENT_AKM_CLIP_04",
                "COMPONENT_AKM_CLIP_05",
                "COMPONENT_AKM_CLIP_06",
                "COMPONENT_AKM_CLIP_07",
                "COMPONENT_AKM_CLIP_08",
                "COMPONENT_AKM_CLIP_09",
                "COMPONENT_AKM_CLIP_10",
                "COMPONENT_AKM_CLIP_11",
            }
        }
    },
    ['flashlight'] = {
        objective = "WEAPON_FLASHLIGHT",
        objectivemodel = `WEAPON_FLASHLIGHT`,
        objectivename  = "Flashlight",
        objectammo = 0,
        ignoreObject = true,
        heavy = false,
        objectclip = 0,
        ammotype = "",
    },
    ['combatpistol'] = {
        objective = "WEAPON_COMBATPISTOL",
        objectivemodel = `WEAPON_COMBATPISTOL`,
        objectivename  = "Combatpistol",
        objectammo = 200,
        heavy = false,
        objectclip = 25,
        ammotype = "pistol_ammo", 
        attachments = {

        },
    },
    ['stungun'] = {
        objective = "WEAPON_STUNGUN",
        objectivemodel = `WEAPON_STUNGUN`,
        objectivename  = "Taser",
        objectammo = 5,
        heavy = false,
        ignoreObject = true,
        objectclip = 0,
        ammotype = "", 
        attachments = {
            
        },
    },
    ['nightstick'] = {
        objective = "WEAPON_NIGHTSTICK",
        objectivemodel = `WEAPON_NIGHTSTICK`,
        objectivename  = "Wapenstok",
        objectammo = 0,
        ignoreObject = true,
        heavy = false,
        objectclip = 0,
        ammotype = "", 
        attachments = {
            
        },
    },
    ['smg'] = {
        objective = "WEAPON_SMG",
        objectivemodel = `WEAPON_SMG`,
        objectivename  = "SMG",
        objectammo = 150,
        heavy = true,
        objectclip = 70,
        ammotype = "smg_ammo", 
        attachments = {
            
        },
    },
    ['pumpshotgun'] = {
        objective = "WEAPON_PUMPSHOTGUN",
        objectivemodel = `WEAPON_PUMPSHOTGUN`,
        objectivename  = "Pumpshotgun",
        objectammo = 10,
        heavy = true,
        objectclip = 7,
        ammotype = "shotgun_ammo", 
        attachments = {
            
        },
    },
}

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

local DefaultStoreItems = {
    [1] = {
        item = "sandwich",
        price = 2.50,
    },
    [2] = {
        item = "water",
        price = 1.19,
    },
    [3] = {
        item = "cola",
        price = 2.95,
    },
    [4] = {
        item = "twix",
        price = 1.95,
    },
    [5] = {
        item = "chips",
        price = 0.99,
    },
    [6] = {
        item = "phone",
        price = 300,
    },
    [7] = {
        item = "radio",
        price = 150,
    },
    [8] = {
        item = "scissors",
        price = 15,
    },
    [9] = {
        item = "repairkit",
        price = 100,
    },
    [10] = {
        item = "bag",
        price = 500,
    },
    [11] = {
        item = "shovel",
        price = 250,
    },
}

shared.config.shops = {
    [1] = {
        name = "24/7 Store", 
        location = vector3(25.67, -1347.37, 29.49),
        items = DefaultStoreItems,
        job = false,
    },
    [2] = {
        name = "24/7 Store", 
        location = vector3(-2968.1912, 391.0237, 15.0433),
        items = DefaultStoreItems,
        job = false,
    },
    [3] = {
        name = "24/7 Store", 
        location = vector3(1729.3811, 6414.3706, 35.0372),
        items = DefaultStoreItems,
        job = false,
    },
    [4] = {
        name = "24/7 Store", 
        location = vector3(1698.8964, 4924.0552, 42.0637),
        items = DefaultStoreItems,
        job = false,
    },
    [5] = {
        name = "24/7 Store", 
        location = vector3(1961.3979, 3740.7568, 32.3437),
        items = DefaultStoreItems,
        job = false,
    },
    [6] = {
        name = "24/7 Store", 
        location = vector3(1393.4747, 3604.8367, 34.9809),
        items = DefaultStoreItems,
        job = false,
    },
    [7] = {
        name = "24/7 Store", 
        location = vector3(2678.8247, 3280.6702, 55.2411),
        items = DefaultStoreItems,
        job = false,
    },
    [8] = {
        name = "24/7 Store", 
        location = vector3(2557.3538, 382.4048, 108.6229),
        items = DefaultStoreItems,
        job = false,
    },
    [9] = {
        name = "24/7 Store", 
        location = vector3(-47.8774, -1756.9122, 29.4210),
        items = DefaultStoreItems,
        job = false,
    },
    [10] = {
        name = "24/7 Store", 
        location = vector3(-1487.5098, -379.2334, 40.1634),
        items = DefaultStoreItems,
        job = false,
    },
    [11] = {
        name = "24/7 Store", 
        location = vector3(1163.2869, -322.7954, 69.2051),
        items = DefaultStoreItems,
        job = false,
    },
    [12] = {
        name = "24/7 Store", 
        location = vector3(374.1598, 325.9836, 103.5664),
        items = DefaultStoreItems,
        job = false,
    },
    [13] = {
        name = "24/7 Store", 
        location = vector3(-707.6602, -913.4459, 19.2156),
        items = DefaultStoreItems,
        job = false,
    },
    [14] = {
        name = "24/7 Store", 
        location = vector3(-1821.2855, 793.1991, 138.1187),
        items = DefaultStoreItems,
        job = false,
    },
    [15] = {
        name = "24/7 Store", 
        location = vector3(-3039.3469, 586.0978, 7.9089),
        items = DefaultStoreItems,
        job = false,
    },
    [16] = {
        name = "24/7 Store", 
        location = vector3(-3242.1597, 1001.5418, 12.8307),
        items = DefaultStoreItems,
        job = false,
    },
    [17] = {
        name = "24/7 Store", 
        location = vector3(-159.8575, 6322.6162, 31.5869),
        items = DefaultStoreItems,
        job = false,
    },
    [18] = {
        name = "24/7 Store", 
        location = vector3(1165.9639, 2709.0376, 38.1577),
        items = DefaultStoreItems,
        job = false,
    },
    [19] = {
        name = "24/7 Store", 
        location = vector3(547.6791, 2671.2063, 42.1565),
        items = DefaultStoreItems,
        job = false,
    },
    [20] = {
        name = "24/7 Store", 
        location = vector3(-1345.5994, -1066.8107, 7.3898),
        items = DefaultStoreItems,
        job = false,
    },
    [21] = {
        name = "24/7 Store", 
        location = vector3(-2540.8652, 2313.9072, 33.4108),
        items = DefaultStoreItems,
        job = false,
    },
    [22] = {
        name = "24/7 Store", 
        location = vector3(1135.8975, -982.2342, 46.4158),
        items = DefaultStoreItems,
        job = false,
    },
    [23] = {
        name = "24/7 Store", 
        location = vector3(161.4781, 6640.3521, 31.6084),
        items = DefaultStoreItems,
        job = false,
    },
    [24] = {
        name = "24/7 Store", 
        location = vector3(-1422.9803, -269.0891, 46.3007),
        items = DefaultStoreItems,
        job = false,
    },
    [25] = {
        name = "Bean Machine Cafe", 
        location = vector3(120.64551544189, -1038.5854492188, 29.277952194214),
        items = DefaultStoreItems,
        job = false,
    },
    [26] = {
        name = "uWu Cafe", 
        location = vector3(-583.31805419922, -1060.2553710938, 22.344203948975),
        items = DefaultStoreItems,
        job = false,
    }
}


-- config render

Citizen.CreateThread(function()
    for k,v in pairs(shared.config.weapons) do
        shared.config.weaponKeys[v.objective] = k
    end
end)


exports("getConfig", function()
    return shared
end)