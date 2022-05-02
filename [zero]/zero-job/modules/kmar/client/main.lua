Modules['kmar'] = {}

Modules['kmar'].Config = {
    [1] = {
        ['loc'] = {x = -460.0373840332, y = 6021.4116210938, z = 31.34037399292, h = 307.89416503906},
        ['text'] = "Garage",
        ['functie'] = "OpenGarage",
    },
    [2] = {
        ['loc'] = {x = -475.35165405273, y = 5988.8022460938, z = 31.336469650269, h = 309.6985168457},
        ['text'] = "Heliplatform",
        ['functie'] = "OpenHeli",
    },
    [3] = {
        ['loc'] = {x = -449.35348510742, y = 6015.1884765625, z = 36.995685577393, h = 45.204090118408},
        ['text'] = "Kloesoe",
        ['functie'] = "OpenKloesoe",
    },
    [4] = {
        ['loc'] = {x = -453.12518310547, y = 5999.2690429688, z = 37.008327484131, h = 37.508499145508},
        ['text'] = "Bewijs",
        ['functie'] = "EvidenceRoom",
    },
    
}

Modules['kmar'].options = {
    [1] = {
        name = "Object plaatsen", 
        action = function() 
            PlaceObject()
        end,
    },
    [2] = {
        name = "Gebied markeren", 
        action = function() 
            MarkAreaOption()
        end,
    },
    [3] = {
        name = "Speed limit", 
        action = function() 
            LimitArea()
        end,
    },
}

Citizen.CreateThread(function()
    local coord = {x = -444.8122253418, y = 6011.12890625, z = 32.288688659668, h = 359.99700927734}
    blip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(blip, 526)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 38)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Kmar")
    
    EndTextCommandSetBlipName(blip)
end)

Modules['kmar'].Functions = {}

Modules['kmar'].Run = function()

    local player = PlayerPedId()
    local coord = GetEntityCoords(player)

    for k,v in ipairs(Modules['kmar'].Config) do
        local distance = #(coord - vector3(v.loc.x, v.loc.y, v.loc.z))

        if (distance <= 5 and distance > 1) then
            timer = 0
            
            Zero.Functions.DrawMarker(v.loc.x, v.loc.y, v.loc.z)
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, v.text)
        elseif (distance < 1) then
            timer = 0
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, "~g~E~w~ - "..v.text.."")

            if IsControlJustPressed(0, 38) then
                Modules['kmar'].Functions[v.functie]()
            end
        end
    end
end


Modules['kmar'].Functions['OpenGarage'] = function()
    if JobModule == "kmar" and JobDuty then
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            DeleteEntity(GetVehiclePedIsIn(ped))
        else
            exports['zero-garages']:openMenu(Shared.Config.kmar.Vehicles)
        end
    end
end
Modules['kmar'].Functions['OpenHeli'] = function()
    if JobModule == "kmar" and JobDuty then
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            DeleteEntity(GetVehiclePedIsIn(ped))
        else
            exports['zero-garages']:openMenu({
                [1] = {
                    model = "Zulu",
                    reason = "Zulu politie",
                    spawnmodel = "zulu1",
                },
            })
        end
    end
end

Modules['kmar'].Functions['OpenKloesoe'] = function()
    TriggerServerEvent("Zero:Server-Police:OpenKloesoe")
end

Modules['kmar'].Functions['EvidenceRoom'] = function()
    TriggerServerEvent("Zero:Server-Police:EvidenceRoom")
end
