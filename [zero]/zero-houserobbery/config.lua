exports["zero-core"]:object(function(O) Zero = O end)

config = {}
config.vars = {}

 -- dont touch vars section.
config.vars.inside = false

config.debug = true
config.unlockTimer = 60000 * 15 -- second number is amount of minutes.

config.locations = {
    {x = 1200.7423095703, y = -575.314453125, z = 69.139099121094, h = 343.05422973633, enabled = false, level = 0, locked = true},
    {x = 1051.2847900391, y = -470.46292114258, z = 64.096237182617, h = 83.257362365723, enabled = false, level = 0, locked = true},
    {x = 861.84234619141, y = -583.36578369141, z = 58.15648651123, h = 6.5902991294861, enabled = false, level = 0, locked = true},
    {x = 1386.0147705078, y = -593.27764892578, z = 74.485458374023, h = 43.763076782227, enabled = false, level = 0, locked = true},
    {x = -409.37976074219, y = 341.62457275391, z = 108.90744018555, h = 263.73388671875, enabled = false, level = 0, locked = true},
    {x = -1025.9044189453, y = 360.36645507813, z = 71.361473083496, h = 246.84268188477, enabled = false, level = 0, locked = true},
    {x = -1219.2462158203, y = -1233.4157714844, z = 7.0293140411377, h = 290.44393920898, enabled = false, level = 0, locked = true},
    {x = 1214.4467773438, y = -1644.1729736328, z = 48.645977020264, h = 30.476472854614, enabled = false, level = 0, locked = true},
    {x = 1348.3858642578, y = -547.05065917969, z = 73.891639709473, h = 161.00770568848, enabled = false, level = 0, locked = true},
    {x = 1328.4272460938, y = -535.96014404297, z = 72.440818786621, h = 70.390228271484, enabled = false, level = 0, locked = true}
}

config.reward = 2

config.data = {
    [1] = {
        interior = "playerhouse_appartment_motel",
        exit = {x = -1.55, y = -3.62, z = -1.34753, h = 2.50},
        search = {
            {x = -2.88, y = -1.20, z = -1.344},
            {x = -2.46, y = 0.66, z = -1.344},
            {x = 2.50, y = -1.80, z = -1.344},
            {x = 2.50, y = 0.79, z = -1.344},
            {x = -1.30, y = 3.15, z = -1.344},
        },
    },
    [2] = {
        interior = "highendmotel_shell",
        exit = {x = 3.11, y = 3.13, z = -1.52, h = 175.06},
        search = {
            {x = 4.14, y = -1.18, z = -1.52124},
            {x = -4.15, y = -4.84, z = -1.52124},
            {x = -4.15, y = -1.61, z = -1.52124},
            {x = -3.61, y = 5.00, z = -1.52124},
        }
    },
    [3] = {
        interior = "furnitured_midapart",
        exit = {x = 1.455, y = -10.01, z = -1.52, h = 0.30},
        search = {
            {x = -1.77, y = 0.08, z = -1.52},
            {x = -4.24, y = -0.644, z = -1.52},
            {x = -6.89, y = 5.61, z = -1.52},
            {x = 0.18, y = 5.95, z = -1.52},
            {x = 5.96, y = 3.63, z = -1.52},
            {x = 4.17, y = 7.87, z = -1.52},
            {x = 2.20, y = 8.69, z = -1.52},
        },
        safe = {x = 5.38, y = -5.58, z = -1.52, h = 180.00},
    },
    [4] = {
        interior = "furnished_shell",
        exit = {x = -2.51, y = 6.65, z = 2.16, h = 0.30},
        search = {
            {x = 4.16, y = 1.44, z = 2.16},
            {x = -1.18, y = -6.45, z = 1.95},
            {x = 4.71, y = -8.58, z = 1.95},
            {x = -1.44, y = -11.80, z = 1.75},
            {x = 6.19, y = -10.53, z = -1.61},
            {x = 6.17, y = -13.36, z = -1.61},
            {x = 5.65, y = 0.25, z = -1.61},
            {x = 0.20, y = -3.60, z = -5.45},
            {x = -5.19, y = -0.99, z = -5.42},
            {x = -1.33, y = -12.52, z = -1.64},
            {x = 6.24, y = -12.71, z = 1.79},
        },
        safe = {x = 2.11, y = 6.43, z = -5.45, h = 90.00},
    },
}


config.items = {
    {
        item = "phone",
        max = 1,
    },
    {
        item = "pistol_ammo",
        max = 1,
    },
    {
        item = "cola",
        max = 1,
    },
    {
        item = "metal",
        max = 9
    },
    {
        item = "aluminium",
        max = 9
    },
    {
        item = "iron",
        max = 9
    },
    {
        item = "ifak",
        max = 1
    },

    {
        item = "chain_1",
        max = 1
    },
    {
        item = "chain_2",
        max = 1
    },
    {
        item = "chain_3",
        max = 1
    },
    {
        item = "chain_4",
        max = 1
    },

    {
        item = "ring_1",
        max = 1
    },
    {
        item = "ring_2",
        max = 1
    },    
}

config.safe = {
    {
        item = 'combatpistol',
        weapon = true,
    },
    {
        item = 'hatchet',
        weapon = true,
    },
    {
        item = 'switchblade',
        weapon = true,
    },
    {
        item = 'cuffs',
        weapon = false,
    },
}