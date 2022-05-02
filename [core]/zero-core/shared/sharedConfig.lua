Zero.Config = Zero.Config ~= nil and Zero.Config or {}


Zero.Config.Spawn = {
    ['selection'] = {x = 511.37185668945, y = 223.91622924805, z = 104.74432373047, h = 299.70166015625},
    ['camcoord'] = {x = 512.37, y = 225.50, z = 104.74, h = 158.09},
    ['pointCoord'] =  {x = 509.91970825195, y = 222.13269042969, z = 104.74407958984, h = 301.32775878906},
}

Zero.Config.DefaultMoney = {
    ['cash'] = 250,
    ['bank'] = 25000,
}

Zero.Config.BloodTypes = {
    "O+",
    "O-",
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
}

Zero.Config.DefaultSpawn = {
    x = 283.96, 
    y = -938.76, 
    z = 29.33,
    h = 130.00
}

Zero.Config.DefaultJob = {
    ['name'] = "unemployed",
    ['grade'] = 0,
    ['specialized'] = {},
}

Zero.Config.DefaultCrew = {
    ['name'] = "",
    ['level'] = 0,
}

Zero.Config.Jobs = {
    ['police'] = {
        ['label'] = "Politie",
        ['whitelisted'] = true,
        ['offduty'] = 50,
        ['grades'] = {
            [0] = {
                ['label'] = "Aspirant",
                ['salary'] = 250,
            },
            [1] = {
                ['label'] = "Surveillant",
                ['salary'] = 300,
            },
            [2] = {
                ['label'] = "Agent",
                ['salary'] = 320,
            },
            [3] = {
                ['label'] = "Hoofd Agent",
                ['salary'] = 350,
            },
            [4] = {
                ['label'] = "Brigadier",
                ['salary'] = 370,
            },
            [5] = {
                ['label'] = "Inspecteur",
                ['salary'] = 390,
            },
            [6] = {
                ['label'] = "Hoofd Inspecteur",
                ['salary'] = 420,
            },
            [7] = {
                ['label'] = "Commissaris",
                ['salary'] = 450,
            },
            [8] = {
                ['label'] = "Hoofdcommissaris",
                ['salary'] = 450,
            },
            [9] = {
                ['label'] = "Eerste Hoofdcommissaris",
                ['salary'] = 480,
            },
        }
    },
    ['kmar'] = {
        ['label'] = "Koninklijke Marechaussee",
        ['whitelisted'] = true,
        ['offduty'] = 50,
        ['grades'] = {
            [0] = {
                ['label'] = "4E Klasse",
                ['salary'] = 200,
            },
            [1] = {
                ['label'] = "3E Klasse",
                ['salary'] = 200,
            },
            [2] = {
                ['label'] = "2E Klasse",
                ['salary'] = 200,
            },
            [3] = {
                ['label'] = "1E Klasse",
                ['salary'] = 200,
            },
            [4] = {
                ['label'] = "Wachmeester",
                ['salary'] = 200,
            },
            [5] = {
                ['label'] = "Wachtmeester der 1e klasse",
                ['salary'] = 200,
            },
            [6] = {
                ['label'] = "Opperwacht meester",
                ['salary'] = 200,
            },
            [7] = {
                ['label'] = "Adjudant onderofficier",
                ['salary'] = 200,
            },
            [8] = {
                ['label'] = "Eerste luitenant",
                ['salary'] = 200,
            },
            [9] = {
                ['label'] = "Tweede luitenant",
                ['salary'] = 200,
            },
            [10] = {
                ['label'] = "Kapitein",
                ['salary'] = 200,
            },
            [11] = {
                ['label'] = "Majoor",
                ['salary'] = 200,
            },
            [12] = {
                ['label'] = "Majoor",
                ['salary'] = 200,
            },
            [13] = {
                ['label'] = "Luitenant kolonel",
                ['salary'] = 200,
            },
            [14] = {
                ['label'] = "Kolonel",
                ['salary'] = 200,
            },
            [15] = {
                ['label'] = "Brigadegeneraal",
                ['salary'] = 200,
            },
            [16] = {
                ['label'] = "Generaal majoor",
                ['salary'] = 200,
            },
            [17] = {
                ['label'] = "Luitenant majoor",
                ['salary'] = 200,
            },
        }
    },

    ['ambulance'] = {
        ['label'] = "Ambulance",
        ['whitelisted'] = true,
        ['offduty'] = 50,
        ['grades'] = {
            [0] = {
                ['label'] = "Opleiding",
                ['salary'] = 200,
            },
            [1] = {
                ['label'] = "Ondersteunend",
                ['salary'] = 230,
            },
            [2] = {
                ['label'] = "Ambulancebroeder",
                ['salary'] = 280,
            },
            [3] = {
                ['label'] = "Verpleegkundige",
                ['salary'] = 300,
            },
            [4] = {
                ['label'] = "EMT",
                ['salary'] = 350,
            },
            [5] = {
                ['label'] = "SRT",
                ['salary'] = 400,
            },
            [6] = {
                ['label'] = "Leiding",
                ['salary'] = 420,
            },
        }
    },
    ['mechanic'] = {
        ['label'] = "Wegenwacht",
        ['whitelisted'] = true,
        ['offduty'] = 50,
        ['grades'] = {
            [0] = {
                ['label'] = "Monteur in opleiding",
                ['salary'] = 200,
            },
            [1] = {
                ['label'] = "Monteur",
                ['salary'] = 230,
            },
            [2] = {
                ['label'] = "Rijkswaterstaat",
                ['salary'] = 280,
            },
            [3] = {
                ['label'] = "Hoofd Monteur",
                ['salary'] = 300,
            },
            [4] = {
                ['label'] = "ANWB Manager",
                ['salary'] = 351,
            },
            [5] = {
                ['label'] = "ANWB Leiding",
                ['salary'] = 400,
            },
            [6] = {
                ['label'] = "ANWB Baas",
                ['salary'] = 500,
            },
        }
    },
    ['taxi'] = {
        ['label'] = "Taxi",
        ['offduty'] = 50,
        ['whitelisted'] = true,
        ['grades'] = {
            [0] = {
                ['label'] = "Uber",
                ['salary'] = 130,
            },
            [1] = {
                ['label'] = "Junior Chauffeur",
                ['salary'] = 135,
            },
            [2] = {
                ['label'] = "Chauffeur",
                ['salary'] = 140,
            },
            [3] = {
                ['label'] = "Ervaren Chauffeur",
                ['salary'] = 150,
            },
            [4] = {
                ['label'] = "Manager",
                ['salary'] = 160,
            },
            [5] = {
                ['label'] = "Manager",
                ['salary'] = 165,
            },
        }
    },
    ['lawyer'] = {
        ['label'] = "Advocaat",
        ['whitelisted'] = true,
        ['offduty'] = 50,
        ['grades'] = {
            [0] = {
                ['label'] = "*",
                ['salary'] = 50,
            },
        }
    },
    ['tuner'] = {
        ['label'] = "Tuner",
        ['offduty'] = 50,
        ['whitelisted'] = true,
        ['grades'] = {
            [0] = {
                ['label'] = "Monteur",
                ['salary'] = 300,
            },
            [1] = {
                ['label'] = "Eigenaar",
                ['salary'] = 400,
            },
        }
    },
    -- player jobs
    ['driver'] = {
        ['label'] = "Freelance - chauffeur",
        ['offduty'] = 50,
        ['whitelisted'] = false,
        ['grades'] = {
            [0] = {
                ['label'] = "Bestuurder",
                ['salary'] = 50,
            },
        }
    },
    ['delivery'] = {
        ['label'] = "A-Post",
        ['offduty'] = 50,
        ['whitelisted'] = false,
        ['grades'] = {
            [0] = {
                ['label'] = "Bezorger",
                ['salary'] = 50,
            },
        }
    },
    ['scrapyard'] = {
        ['label'] = "Vuilnisbelt",
        ['offduty'] = 50,
        ['whitelisted'] = false,
        ['grades'] = {
            [0] = {
                ['label'] = "Medewerker",
                ['salary'] = 50,
            },
        }
    },
    ['chef'] = {
        ['label'] = "Kok",
        ['offduty'] = 50,
        ['whitelisted'] = false,
        ['grades'] = {
            [0] = {
                ['label'] = "Kok - Restaurant",
                ['salary'] = 50,
            },
        }
    },
    ['unemployed'] = {
        ['label'] = "Werkloos",
        ['offduty'] = 50,
        ['whitelisted'] = false,
        ['grades'] = {
            [0] = {
                ['label'] = "*",
                ['salary'] = 50,
            },
        }
    }
}

Zero.Config.Crews = {
    ['x'] = {
        ['label'] = "gang label",
        ['boost'] = 10,
        ['grades'] = {
            [0] = {
                ['label'] = "Kleine bitch",
            },
        }
    },
}

Zero.Config.SalaryTimer = (10*6000)*10

Zero.Config.Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
