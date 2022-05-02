Config = {}

Config.Locations = {
    {x = -34.086982727051, y = -1054.7290039063, z = 27.396480560303,h = 68.666213989258},
    {x = 138.85203552246, y = -3019.5190429688, z = 6.5408568382263, h = 231.37847900391}
}

Config.Camlocations = {
    ['main'] = {x = 3.0, y = 0.0, z = 1.0, h = 0}
}

Config.VehicleBones = {
    [1] = {
        bone = "wheel_lf",
        label = "Banden",
        index = 1,
        price = 250,
        mod = 23,
        offset = {x = -1.4, y = 0, z = 0.3},
        submenu = {
            [1] = {
                icon = '<i class="fas fa-tire"></i>',
                label = "Muscle",
                key = 1,
                back = 1,
                action = "ToggleWheelsMenu",
            },
            [2] = {
                icon = '<i class="fas fa-tire"></i>',
                label = "Lowrider",
                key = 2,
                back = 1,
                action = "ToggleWheelsMenu",
            },
            [3] = {
                icon = '<i class="fas fa-tire"></i>',
                label = "Highend",
                key = 7,
                back = 1,
                action = "ToggleWheelsMenu",
            },
            [4] = {
                icon = '<i class="fas fa-tire"></i>',
                label = "Offroad",
                key = 4,
                back = 1,
                action = "ToggleWheelsMenu",
            },
            [5] = {
                icon = '<i class="fas fa-tire"></i>',
                label = "Tuner",
                key = 5,
                back = 1,
                action = "ToggleWheelsMenu",
            },
            [6] = {
                icon = '<i class="fas fa-tire"></i>',
                label = "SUV",
                key = 6,
                back = 1,
                action = "ToggleWheelsMenu",
            },
            [7] = {
                icon = '<i class="fas fa-tire"></i>',
                label = "Sports",
                key = 7,
                back = 1,
                price = 250,
                action = "ToggleWheelsMenu",
            },
        }
    },
    [2] = {
        bone = "engine",
        label = "Motorblok",
        index = 2,
        mod = 39,
        icon = '<i class="fas fa-cogs"></i>',
        offset = {x = 0.0, y = 1.0, z = 2.0},
        price = 250,
    },
    [3] = {
        bone = "handle_pside_f",
        label = "Deur",
        mod = 31,
        index = 3,
        icon = '<i class="fas fa-car"></i>',
        offset = {x = 1.2, y = 0.5, z = 0.4},
        price = 250,
    },
    [4] = {
        bone = "exhaust",
        label = "Exhaust",
        index = 4,
        icon = '<i class="fas fa-burn"></i>',
        mod = 4,
        offset = {x = -2.0, y = -2.0, z = 0.2},
        price = 250,
    },
    [5] = {
        bone = "bumper_f",
        index = 5,
        label = "Voorbumper",
        icon = '<i class="fas fa-car"></i>',
        mod = 1,
        offset = {x = -1.0, y = 2.0, z = 0.0},
        price = 250,
    },
    [6] = {
        bone = "bumper_r",
        label = "Achterbumper",
        index = 6,
        icon = '<i class="fas fa-car"></i>',
        mod = 2,
        offset = {x = -0.0, y = -4.0, z = 0.0},
        price = 250,
    },
    [7] = {
        bone = "door_pside_f",
        label = "Skirt",
        index = 7,
        icon = '<i class="fas fa-car"></i>',
        mod = 3,
        offset = {x = 3.0, y = -2.0, z = 0.0},
        price = 250,
    },
    [8] = {
        bone = "seat_dside_f",
        index = 8,
        label = "Cage",
        icon = '<i class="fas fa-car"></i>',
        mod = 5,
        offset = {x = -2.0, y = 2.0, z = 2.0},
        price = 250,
    },
    [9] = {
        bone = "headlight_r",
        label = "Gril",
        index = 9,
        icon = '<i class="fas fa-car"></i>',
        mod = 6,
        offset = {x = -1.0, y = 2.0, z = 0.0},
        price = 250,
    },
    [10] = {
        bone = "headlight_l",
        label = "Motorkap",
        index = 10,
        icon = '<i class="fas fa-car"></i>',
        mod = 7,
        offset = {x = 0.0, y = 1.0, z = 2.0},
        price = 250,
    },
    [11] = {
        bone = "bodyshell",
        label = "Livery",
        index = 11,
        icon = '<i class="fas fa-spray-can"></i>',
        mod = 48,
        offset = {x = -2.0, y = 2.0, z = 2.0},
        price = 250,
    },
    [12] = {
        bone = "bodyshell",
        label = "Kleuren",
        index = 12,
        icon = '<i class="fas fa-spray-can"></i>',
        mod = 23,
        offset = {x = -2.0, y = 2.0, z = 2.0},
        price = 250,
        submenu = {
            [1] = {
                icon = '<i class="fas fa-spray-can"></i>',
                label = "Voertuig kleuren",
                key = 1,
                action = "OpenMainColors",
            },
        }
    },
    [13] = {
        bone = "door_dside_f",
        label = "Dak",
        index = 13,
        icon = '<i class="fas fa-tire"></i>',
        mod = 10,
        offset = {x = 0.0, y = 2.0, z = 2.0},
        price = 250,
    },
    [14] = {
        bone = "bodyshell",
        label = "Rightfender",
        index = 14,
        icon = '<i class="fas fa-tire"></i>',
        mod = 8,
        offset = {x = -3.0, y = 0.0, z = 1.0},
        price = 250,
    },
    [15] = {
        bone = "bodyshell",
        label = "Leftfender",
        index = 15,
        icon = '<i class="fas fa-tire"></i>',
        mod = 9,
        offset = {x = -3.0, y = 0.0, z = 1.0},
        price = 250,
    },
    [16] = {
        bone = "bumper_r",
        label = "Spoiler",
        index = 16,
        icon = '<i class="fas fa-tire"></i>',
        mod = 0,
        offset = {x = 2.0, y = -3.0, z = 1.0},
        price = 250,
    },
}

Config.SpecialTunings = {
    bone = "wheel_rf",
    label = "Unlocks",
    index = 17,
    price = 0,
    mod = 23,
    offset = {x = 2.4, y = 2.0, z = 0.3},
    submenu = {
        [1] = {
            icon = '<i class="fas fa-tire"></i>',
            label = "Wheel chambers",
            key = 1,
            action = "Chambers",
        },
        [2] = {
            icon = '<i class="fas fa-tire"></i>',
            label = "NITRO",
            key = 2,
            action = "toggleNitro",
        },
        [3] = {
            icon = '<i class="fas fa-tire"></i>',
            label = "2STEP",
            key = 3,
            action = "toggle2step",
        },
        [4] = {
            icon = '<i class="fas fa-tire"></i>',
            label = "Car radio",
            key = 4,
            action = "toggleRadio",
        },
    }
}

Config.ColourTypes =  {
    {
        index = 1,
        label = "Normaal",
    },
    {
        index = 2,
        label = "Metallic",
    },
    {
        index = 3,
        label = "Mat",
    },
    {
        index = 4,
        label = "Metal",
    },
    {
        index = 5,
        label = "Chrome",
    },
}

exports['zero-core']:object(function(O) Zero = O end)