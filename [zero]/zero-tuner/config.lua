Config = {}
Config.Location = {
    x = 141.47, 
    y = -3036.72,
    z = 7.05,
}

Config.ClaimVehicle  = vector3(124.21, -3022.80, 7.04)
Config.ControleTower = vector3(146.42, -3013.30, 7.04)
Config.Stash = vector3(126.24907684326, -3007.9145507813, 7.040885925293)
Config.Store = vector3(124.76669311523, -3014.1735839844, 7.040885925293)

Config.LiftModel = `denis3d_carlift_02`
Config.LiftObject = `denis3d_carlift_01`

Config.TestSpawn = {x = 147.64295959473, y = -3024.0148925781, z = 7.0570831298828, h = 252.60061645508}

Config.SpotLocations = {
    [1] = {
        x = 144.93, 
        y = -3030.699, 
        z = 6.340, 
        h = 181.27,
        cam = {
            x = 147.23, y = -3035.69, z = 6.9935, h = 25.43,
        }, 
    },
    [2] = {
        x = 135.83, 
        y = -3030.37, 
        z = 6.340, 
        h = 181.27,
        cam = {
            x = 138.46, y = -3034.67, z = 6.9935, h = 27.95,
        }, 
    },

    [3] = {
        lift = true,
        liftHeight = 6.04,
        x = 124.75, 
        y = -3035.08, 
        z = 6.04, 
        h = 270.00,
        cam = {
            x = 130.23, y = -3035.87, z = 6.9935, h = 25.43,
        }, 
    },
    [4] = {
        lift = true,
        liftHeight = 6.04,
        x = 124.60, 
        y = -3041.23, 
        z = 6.04, 
        h = 270.00,
        cam = {
            x = 129.78, y = -3040.69, z = 7.04, h = 25.43,
        }, 
    },
    [5] = {
        lift = true,
        liftHeight = 6.04,
        x = 124.92, 
        y = -3047.23, 
        z = 6.04, 
        h = 270.00,
        cam = {
            x = 130.12, y = -3045.89, z = 6.9935, h = 25.43,
        }, 
    },
}

Config.StashItems = {
    {
        item = "nosfuel",
        price = 0,
        max = 3,
    },
    {
        item = "repairkit",
        price = 0,
        max = 3,
    },
    {
        item = "tire",
        price = 0,
        max = 3,
    },
}