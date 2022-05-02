local variation = 0

RegisterNetEvent("Zero:Client-Pets:AnimalShop")
AddEventHandler("Zero:Client-Pets:AnimalShop", function()
    exports['zero-ui']:element(function(ui)

        last_ped_mods = nil

        local _ = {}

        _[#_+1] = {
            label = "Fluitje",
            subtitle = "Koop een nieuw fluitje <br> Prijs: "..config.whistle.." EUR",
            event = "Zero:Client-Pets:AnimalList",
            next = true,
        }

        _[#_+1] = {
            label = "Koop een huisdier",
            subtitle = "Koop een nieuw huisdier",
            event = "Zero:Client-Pets:Store",
            next = true,
        }

        _[#_+1] = {
            label = "Hulp",
            subtitle = "Laat je huisdier verzorgen",
            event = "Zero:Client-Pets:ChooseCare",
            next = true,
        }

        _[#_+1] = {
            label = "Sluit",
            subtitle = "Sluit de dierenwinkel",
            event = "Zero:Client-Pets:CloseStore",
        }

        ui.set("Kies huisdier", _)
    end)
end)

RegisterNetEvent("Zero:Client-Pets:ChooseCare")
AddEventHandler("Zero:Client-Pets:ChooseCare", function()
    local ui = exports['zero-ui']:element()
    local _ = {}

    _[#_+1] = {
        label = "Ga terug",
        subtitle = "",
        event = "Zero:Client-Pets:AnimalShop",
        next = false,
    }

    for k,v in pairs(CREATED_PETS) do
        if v.owner == GetPlayerServerId(PlayerId()) and (v.dead == 1) then
            _[#_+1] = {
                label = v.label,
                subtitle = "Laat "..v.label.." geholpen worden <br> Prijs: "..config.revive.." EUR",
                event = "Zero:Client-Pets:Revive",
                value = k
            }
        end
    end

    ui.set("Huisdieren helpen", _)
end)

RegisterNetEvent("Zero:Client-Pets:Revive")
AddEventHandler("Zero:Client-Pets:Revive", function(index)
    local index = tonumber(index)

    local money = Zero.Functions.GetPlayerData().Money

    if money.bank >= config.revive or money.cash >= config.revive then
        TriggerServerEvent("Zero:Server-Pets:SetDead", index, false)
        TriggerServerEvent("Zero:Server-Pets:SetSleep", index, true)
        TriggerServerEvent("Zero:Server-Pets:RevivedPet")

        CREATED_PETS[index]['pet_spawned'] = nil
        CREATED_PETS[index]['dead'] =  0

        Zero.Functions.Notification("Huisdier", "Huisdier is geholpen", "success", 8000)
        TriggerEvent("Zero:Client-Pets:ChooseCare")
    else
        Zero.Functions.Notification('Dierenwinkel', 'Je hebt niet genoeg geld', 'error', 6000)
    end
end)

RegisterNetEvent("Zero:Client-Pets:Store")
AddEventHandler("Zero:Client-Pets:Store", function()
    local x,y,z = config.cam.x, config.cam.y, config.cam.z

    local camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 2000, true, true)
    SetCamCoord(camera, x, y, z + 0.5)

    PointCamAtCoord(camera, config.petSpawn.x, config.petSpawn.y, config.petSpawn.z)


    openStoreUI()
end)

RegisterNetEvent("Zero:Client-Pets:CloseStore")
AddEventHandler("Zero:Client-Pets:CloseStore", function()
    DestroyCam(camera, true)
    RenderScriptCams(false, false, 2000, false, false)
    DeleteEntity(previewPed)
end)

RegisterNetEvent("Zero:Client-Pets:BuyPetConfirm")
AddEventHandler("Zero:Client-Pets:BuyPetConfirm", function(index)
    DestroyCam(camera, true)
    RenderScriptCams(false, false, 2000, false, false)
    DeleteEntity(previewPed)

    TriggerServerEvent("Zero:Server-Pets:BuyPet", index, variation, last_ped_mods)
end)

RegisterNetEvent("Zero:Client-Pets:BuyPet")
AddEventHandler("Zero:Client-Pets:BuyPet", function(index)
    local model = index

    if previewPed then
        DeleteEntity(previewPed)
    end

    RequestModel(model)
 
    while not HasModelLoaded(model) do
        Wait(0)
    end

    last_buy_id = index
    
    local x,y,z = config.petSpawn.x, config.petSpawn.y, config.petSpawn.z

    previewPed = CreatePed(24, model, x, y, z, 0.0, false, false)
    SetEntityAsMissionEntity(previewPed, true, true)
    SetPedFleeAttributes(previewPed, false, false)
    SetEntityHeading(previewPed, config.petSpawn.h)
    SetPedComponentVariation(previewPed, 0, 0, variation)

    if last_ped_mods then
        for k,v in pairs(last_ped_mods) do
            SetPedComponentVariation(previewPed, k, 0, v)
        end
    end

    SetPedCanBeTargetted(previewPed, false)

    SetBlockingOfNonTemporaryEvents(previewPed, true)

    local ui =  exports['zero-ui']:element()

    local _ = {}

    _[#_+1] = {
        label = "Ga terug",
        subtitle = "",
        event = "openStoreUI",
        next = false,
        value = k,
    }


    _[#_+1] = {
        label = "Kopen",
        subtitle = "Koop dit huisdier <br> Prijs: "..config.pets[index]['price'].." EUR",
        event = "Zero:Client-Pets:BuyPetConfirm",
        value = index,
    }

    _[#_+1] = {
        label = "Variatie",
        subtitle = "Verrander huisdier uiterlijk",
        event = "ChangeVariation",
        next = true,
        value = k,
    }

    if (config.pets[index]['mods']) then
        _[#_+1] = {
            label = "Extra opties",
            subtitle = "Verrander huisdier uiterlijk",
            event = "DisplayMods",
            next = true,
            value = index,
        }
    end

    ui.set("Kies huisdier", _)
end)

RegisterNetEvent("openStoreUI")
AddEventHandler("openStoreUI", function()
    openStoreUI()
end)

RegisterNetEvent("ChooseVariation")
AddEventHandler("ChooseVariation", function(i)
    local i = tonumber(i)
    SetPedComponentVariation(previewPed, 0, 0, i)
    TriggerEvent("ChangeVariation")

    variation = i
end)

RegisterNetEvent("DisplayMods")
AddEventHandler("DisplayMods", function(index)
    local ui = exports['zero-ui']:element()
    local menu = {}

    if index and index ~= "undefined" then
        last_index = index
    end

    index = last_index
 
    for k,v in pairs(config.pets[index]['mods']) do
        menu[#menu+1] = {
            label = v.label,
            event = "pets:ChangeModMenu",
            next = true,
            value = v.mod,
        }
    end

    menu[#menu+1] = {
        label = "Ga terug",
        event = "Zero:Client-Pets:BuyPet",
        next = false,
        value = index,
    }

    ui.set("Kies extra", menu)
end)

RegisterNetEvent("pets:ChangeModMenu")
AddEventHandler("pets:ChangeModMenu", function(index)
    if last_index then
        local ui = exports['zero-ui']:element()

        local _ = {}
        local data = config.pets[last_index]
        local index = tonumber(index)

        local mod = index
        local max = GetNumberOfPedTextureVariations(previewPed, mod, 0)

        last_mod = mod

        for i = -1, max - 1 do
            _[#_+1] = {
                label = "Extra" .. "  ("..i..")",
                event = "SetPedVariationMod",
                value = i,
            }
        end

        _[#_+1] = {
            label = "Ga terug",
            event = "DisplayMods",
            next = false,
        }

        ui.set("Kies optie", _)
    end
end)

function GenerateLastMods()
    if (last_index) then
        local _ = {}


        for k,v in pairs(config.pets[last_index].mods) do
            _[v.mod] = GetPedTextureVariation(previewPed, v.mod)
        end

        return _
    end
end

RegisterNetEvent("SetPedVariationMod")
AddEventHandler("SetPedVariationMod", function(index)
    local index = tonumber(index)
    SetPedComponentVariation(previewPed, last_mod, 0, index)
    TriggerEvent("pets:ChangeModMenu", last_mod)

    last_ped_mods = GenerateLastMods()
end)

RegisterNetEvent("ChangeVariation")
AddEventHandler("ChangeVariation", function()
    local ui =  exports['zero-ui']:element()
    local _ = {}

    local max = GetNumberOfPedTextureVariations(previewPed, 0, 0) - 1

    _[#_+1] = {
        label = "Ga terug",
        subtitle = "",
        event = "Zero:Client-Pets:BuyPet",
        next = false,
        value = last_buy_id,
    }


    for i = 0, max do
        _[#_+1] = {
            label = "Variatie ("..i..")",
            subtitle = "Kies variatie",
            event = "ChooseVariation",
            value = i,
        }
    end
    ui.set("Kies variatie", _)
end)


function openStoreUI()
    local ui =  exports['zero-ui']:element()

    local _ = {}

    for k,v in pairs(config.pets) do
        if not v.jobs or v.jobs[Zero.Functions.GetPlayerData().Job.name] then
            _[#_+1] = {
                label = v.label,
                subtitle = "Koop "..v.label.."",
                event = "Zero:Client-Pets:BuyPet",
                next = true,
                value = k,
            }
        end
    end

    variation = 0

    _[#_+1] = {
        label = "Ga terug",
        subtitle = "Terug naar hoofdmenu",
        event = "Zero:Client-Pets:AnimalShop",
        next = false,
    }

    ui.set("Kies huisdier", _)
end