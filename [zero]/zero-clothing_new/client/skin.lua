Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end

    local skin = Zero.Functions.GetPlayerData().Skin

    if skin then
        ped:model(skin.model)
        ped:LoadVariation(skin.skindata)

        if (skin.skindata.tattoo) then
            ped:loadTats()
        end
    end

    Wait(4000)

    Zero.Functions.GetPlayerData(function(x)
        x.MetaData.dead = x.MetaData.dead ~= nil and x.MetaData.dead or false

        if x.MetaData.dead then
            TriggerEvent('Zero:Client-Status:Kill')
        end
    end)
end)

RegisterNetEvent("Zero:Client-ClothingV2:LoadSkins")
AddEventHandler("Zero:Client-ClothingV2:LoadSkins", function(skins)
    config.skins = skins

    SendNUIMessage({
        action = "outfits",
        outfits = config.skins,
    })
end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local player = PlayerPedId()
        local pos = GetEntityCoords(player)

        if not OpenMenu then
            for k,v in pairs(config.stores) do
                local distance = #(pos - v)

                if distance <= 4 then
                    timer = 0

                    TriggerEvent("interaction:show", "E - Kleding menu", function()
                        TriggerEvent("Zero:Client-ClothingV2:Open")
                    end)
                end
            end

            for k,v in pairs(config.jobs) do
                local distance = #(pos - vector3(v.x, v.y, v.z))

                if distance <= 5 then
                    timer = 0

                    TriggerEvent("interaction:show", "E - Kleding menu", function()
                        local job = Zero.Functions.GetPlayerData().Job.name
                        local outfits = config.jobOutfits[job] ~= nil and config.jobOutfits[job] or {}

                        clothing_extra = false
                        TriggerEvent("Zero:Client-ClothingV2:Open", ped:sort(outfits))
                    end)
                end
            end
        end

        Citizen.Wait(timer)
    end
end)

RegisterCommand("clothes", function()
    TriggerEvent("OpenClothes")
end)

RegisterNetEvent("OpenClothes")
AddEventHandler("OpenClothes", function()
    local ui = exports['zero-ui']:element()

    local menu = {}

    for k,v in pairs(config.variations) do
        if (v.type == 'variation' or v.type == 'prop') and v.label then
            menu[#menu+1] = {
                label = v.label,
                value = k,
                event = "Zero:Client-ClothingV2:OpenClothesOpt",
                next = true,
            }
        end
    end

    menu[#menu+1] = {
        label = "Sluit",
        event = "",
        subtitle = "Sluit kleding menu",
    }

    ui.set("Kleding", menu)
end)

RegisterNetEvent("Zero:Client-ClothingV2:OpenClothesOpt")
AddEventHandler("Zero:Client-ClothingV2:OpenClothesOpt", function(value)
    local ui = exports['zero-ui']:element()

    local menu = {}

    menu[#menu+1] = {
        label = "Aandoen",
        event = "Zero:Client-ClothingV2:ResetVariation",
        value = value,
    }

    menu[#menu+1] = {
        label = "Uitdoen",
        event = "Zero:Client-ClothingV2:RemoveVariation",
        value = value,
    }


    menu[#menu+1] = {
        label = "Ga terug",
        event = "OpenClothes",
        subtitle = "Sluit kleding menu",
        next = false,
    }

    ui.set("Kleding > "..config.variations[value].label.."", menu)
end)

RegisterNetEvent("Zero:Client-ClothingV2:ResetVariation")
AddEventHandler("Zero:Client-ClothingV2:ResetVariation", function(value)
    local id = config.variations[value]['id']

    local skin = Zero.Functions.GetPlayerData().Skin
    local variation = skin.skindata[value]

    if variation then
        ped:ApplyVariation(value, variation.main, "main")
        ped:ApplyVariation(value, variation.other, "other")

        TriggerEvent("Zero:Client-ClothingV2:OpenClothesOpt", value)
    end
end)

RegisterNetEvent("Zero:Client-ClothingV2:RemoveVariation")
AddEventHandler("Zero:Client-ClothingV2:RemoveVariation", function(value)
    local data = config.variations[value]

    if data.type == "prop" then
        ClearPedProp(PlayerPedId(), data.id)
    elseif data.type == "variation" then
        SetPedComponentVariation(PlayerPedId(), data.id, -1, 0)
    end

    TriggerEvent("Zero:Client-ClothingV2:OpenClothesOpt", value)
end)