config = {}

exports['zero-core']:object(function(O) Zero = O end)

config.whistle = 250
config.revive = 75

config.pets = {
    ['a_c_shepherd'] = {
        type = 'dog',
        attack = true,
        jobs = {
            kmar = true,
            police = true,
        },
        offset = 0.43,
        label  = 'Shepherd',
        mods = {
            {label = 'Vest kleur', mod = 3},
            {label = 'Vest text', mod = 8}
        },
        price = 100,
        sleeping = {
            dict = 'creatures@rottweiler@amb@sleep_in_kennel@',
            anim = 'sleep_in_kennel',
        },
        animations = {
            {
                label = "Zitten",
                dict = 'creatures@rottweiler@amb@world_dog_sitting@base',
                anim = 'base',
            },
            {
                label = "Blaffen",
                dict = 'creatures@rottweiler@melee@streamed_taunts@',
                anim = 'taunt_02',
            },
            {
                label = "Poot",
                dict = 'creatures@rottweiler@tricks@',
                anim = 'paw_right_loop',
            },
        }
    },

    ['a_c_husky'] = {
        type = 'dog',
        label  = 'Husky',
        price = 25000,
        offset = 0.35,
        sleeping = {
            dict = 'creatures@rottweiler@amb@sleep_in_kennel@',
            anim = 'sleep_in_kennel',
        },
        animations = {
            {
                label = "Zitten",
                dict = 'creatures@rottweiler@amb@world_dog_sitting@base',
                anim = 'base',
            },
            {
                label = "Blaffen",
                dict = 'creatures@rottweiler@melee@streamed_taunts@',
                anim = 'taunt_02',
            },
            {
                label = "Poot",
                dict = 'creatures@rottweiler@tricks@',
                anim = 'paw_right_loop',
            },
        }
    },

    ['a_c_cat_01'] = {
        type = 'cat',
        label  = 'Kat',
        price = 17000,
        offset = 0.18,
        sleeping = {
            dict = 'creatures@cat@amb@world_cat_sleeping_ground@base',
            anim = 'base',
        },
        animations = {
            {
                label = "Zitten",
                dict = 'creatures@cat@amb@world_cat_sleeping_ground@base',
                anim = 'base',
            },
        }
    },
}

config.petStore = {x = 562.45770263672, y = 2741.5925292969, z = 42.868854522705, h = 5.5198678970337}
config.petSpawn = {x = 567.14227294922, y = 2740.0954589844, z = 42.202877044678, h = 225.51254272461}
config.cam = {x = 567.21142578125, y = 2737.2141113281, z = 42.179973602295, h = 344.7819519043}