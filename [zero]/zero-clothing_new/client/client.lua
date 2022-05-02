-- command
RegisterCommand("clothing", function()
    Zero.Functions.TriggerCallback('Zero:Server-Admin:IsAdmin', function(result)
        if result then
            TriggerEvent("Zero:Client-ClothingV2:Open")
        end
    end)
end)

RegisterCommand("dimension", function(src, args)
    Zero.Functions.TriggerCallback('Zero:Server-Admin:IsAdmin', function(result)
        if result then
            print('setting player to dimension: '..args[1]..'')
            TriggerServerEvent("Zero:Server-Core:SetDimension", tonumber(args[1]))
        end
    end)
end)

CreateThread(function()
    for k,v in pairs(config.stores) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (blip, 366)
		SetBlipScale  (blip, 0.75)
		SetBlipDisplay(blip, 4)
		SetBlipColour (blip, 47)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Kledingwinkel")
		EndTextCommandSetBlipName(blip)
    end

    for k,v in pairs(config.tattoo) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (blip, 621)
		SetBlipScale  (blip, 0.45)
		SetBlipDisplay(blip, 4)
		SetBlipColour (blip, 1)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Tattoo winkel")
		EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent("Zero:Client-Clothing:OpenPoliceVest")
AddEventHandler("Zero:Client-Clothing:OpenPoliceVest", function()
    ped:changed()

    local job = Zero.Functions.GetPlayerData().Job.name

    if job == "police" then
        local outfits = config.jobOutfits[job] ~= nil and config.jobOutfits[job] or {}

        clothing_extra = true
        SendNUIMessage({
            action = "open",
            outfits = ped:sort(outfits, true),
        })

        SetNuiFocus(true, true)

        TriggerServerEvent("Zero:Server-ClothingV2:LoadSkins")
    end
end)

RegisterNetEvent("Zero:Client-ClothingV2:Open")
AddEventHandler("Zero:Client-ClothingV2:Open", function(outfits)
    ped:changed()

    SendNUIMessage({
        action = "open",
        outfits = outfits
    })
    SendNUIMessage({action = "disableTattoo"})

    SetNuiFocus(true, true)

    TriggerServerEvent("Zero:Server-ClothingV2:LoadSkins")

    cam:open()

    Zero.Functions.HidePlayers(true)
    OpenMenu = true
end)

RegisterNetEvent("Zero:Client-ClothingV2:Tattoo")
AddEventHandler("Zero:Client-ClothingV2:Tattoo", function(outfits)
    ped:changed()

    SendNUIMessage({
        action = "open",
        outfits = outfits
    })

    SendNUIMessage({action = "enableTattoo"})



    SetNuiFocus(true, true)

    TriggerServerEvent("Zero:Server-ClothingV2:LoadSkins")

    cam:open()

    Zero.Functions.HidePlayers(true)
    OpenMenu = true
end)

-- NUI
RegisterNUICallback("close", function(ui)
    SetNuiFocus(false, false)
    cam:close(ui.bool, ui.label)
    
    Zero.Functions.HidePlayers(false)
    --Citizen.InvokeNative(0xBA3D65906822BED5, 0.1, 0.1, 0.0, 0.0, 0.0, 300.0)
    OpenMenu = false
end)

RegisterNUICallback("SetPedModel", function(ui)
    local model = ui.model
    ped:model(model)
end)

RegisterNUICallback("model-left", function(ui, cb)
    local currentModel = GetEntityModel(PlayerPedId())
    local find = ped:findModelLeft(currentModel)

    ped:model(find)

    cb(find)
end)

RegisterNUICallback("OpenedSettings", function()
    ped:setupUIclasses()
end)

RegisterNUICallback("ApplyTattoo", function(ui)
    local tattoo = ui.index
    local dlc = ui.dlc

    ped:tattooApply(dlc, tattoo)
end)

RegisterNUICallback("model-right", function(ui, cb)
    local currentModel = GetEntityModel(PlayerPedId())
    local find = ped:findModelRight(currentModel)
    
    ped:model(find)
    
    cb(find)
end)

RegisterNUICallback("GetSkinCode", function(ui, cb)
    local _ = {}
    
    for k,v in pairs(ui.elements) do
        _[k] = config.skin[k]
    end

    cb(json.encode(_))
end)

RegisterNUICallback("SkinCodeApply", function(ui)
    local code = ui.code

    ped:code(code)
end)

RegisterNUICallback("SetVariation", function (ui)
    local variation = ui.variation
    local value     = ui.value
    local type      = ui.index
    
    local number    = tonumber(value)

    ped:ApplyVariation(variation, number, type)
end)

RegisterNUICallback("SelectOwnedOutfit", function(ui)
    local index = ui.index

    if index then
        for k,v in pairs(config.skins) do
            if v.index == index then
            
                local skin = v

                ped:model(skin.model)
                ped:LoadVariation(skin.skindata)

                if (skin.skindata.tattoo) then
                    ped:loadTats(skin.skindata.tattoo)
                end

                ExecuteCommand("e adjust")
                return
            end
        end
    end
end)


RegisterNUICallback("DeleteOutfit", function(ui)
    local index = ui.index
    TriggerServerEvent("Zero:Server-ClothingV2:DeleteSkin", index)
end)

RegisterNUICallback("SelectJobOutfit", function(ui)
    local index = ui.index

    ped:jobOutfit(index)
end)


RegisterNUICallback("rightRotate", function()
    local heading = GetEntityHeading(PlayerPedId())
    SetEntityHeading(PlayerPedId(), heading + 10.0)
end)

RegisterNUICallback("leftRotate", function()
    local heading = GetEntityHeading(PlayerPedId())
    SetEntityHeading(PlayerPedId(), heading - 10.0)
end)

RegisterNUICallback("setCam", function(ui)
    local index = tonumber(ui.index)

    
    if index == 1 then
        local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.75, 0)
        SetCamCoord(cam.camera, coords.x, coords.y, coords.z + 0.65)
    elseif index == 2 then
        local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0)
        SetCamCoord(cam.camera, coords.x, coords.y, coords.z + 0.2)
    elseif index == 3 then
        local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0)
        SetCamCoord(cam.camera, coords.x, coords.y, coords.z + -0.5)
    else
        local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0)
        SetCamCoord(cam.camera, coords.x, coords.y, coords.z + 0.5)
    end
end)

-- CAM
cam = {}

function cam:open()
    local ply    = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(ply, 0, 0.6, 0)

    cam.camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetCamActive(cam.camera, true)
    RenderScriptCams(true, true, 150, true, true)
    SetCamCoord(cam.camera, coords.x, coords.y, coords.z + 0.65)
    SetCamRot(cam.camera, 0.0, 0.0, GetEntityHeading(ply) + 180)

    SetFocusEntity(PlayerPedId())
   -- Citizen.InvokeNative(0xBA3D65906822BED5, 100.00, 2.0, 0.0, 0.0, 0.0, 5.0)
end


function cam:close(bool, title)
    RenderScriptCams(false, false, 0, false, false)
    DestroyAllCams(true)

    local model_name = ped:getModel()

    if bool then
        if title and title ~= "" then
            ped:save(title)
        else
            TriggerServerEvent("Zero:Server-ClothingV2:SetSkin", model_name, config.skin)
        end
    else
        Zero.Functions.GetPlayerData(function(PlayerData)  
            ped:model(PlayerData.Skin.model)
            ped:LoadVariation(PlayerData.Skin.skindata)
        end)
    end

  --  Citizen.InvokeNative(0xBA3D65906822BED5, 0.1, 0.1, 0.0, 0.0, 0.0, 300.0)
end