local benches = {
    {x = 3.15, y = -1309.80, z = 30.16, h = 264.00, cam = {x = 3.25, y = -1308.94, z = 31.16}},
}

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("cr-open", function(coords, entity)
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)
        local distance = #(pos - coords)

        for k,v in pairs(benches) do
            if DoesEntityExist(v.object) then
                if v.object == entity and distance <= 3 then
                    return true, GetEntityCoords(entity)
                end
            end
        end
    end, {
        [1] = {
            name = "Open crafting", 
            action = function(entity) 
               openWeaponCrafting(entity)
            end,
        },
    }, GetCurrentResourceName(), 10)
end)

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        local location = GetEntityCoords(player)
        local timer = 750

        for k,v in pairs(benches) do
            local distance = #(vector3(v.x, v.y, v.z) - location)

            if distance <= 30 then
                timer = 0

                if not DoesEntityExist(v.object) then
                    v.object = CreateObject(GetHashKey("prop_tool_bench02"), v.x, v.y, v.z - 1, false, false, false)
                    FreezeEntityPosition(v.object, true)
                    SetEntityHeading(v.object, v.h)
                    SetEntityAsMissionEntity(v.object, true, true)
                    SetEntityCanBeDamaged(v.object, false)
                    SetEntityInvincible(v.object, true)
                end
            end
        end
        Citizen.Wait(timer)
    end
end)

function openWeaponCrafting(entity)
    local _ = {}

    local itemsConfig = exports['zero-inventory']:config()
    local inventory = exports['zero-inventory']:getInventory()

    for k,v in pairs(inventory) do
        if (itemsConfig.items[v.item]['type'] == "weapon") then
            table.insert(_, {
                name = "Edit "..itemsConfig.items[v.item]['label'].." ("..k..")", 
                action = function() 
                    EditWeapon(entity, k)
                end,
            })
        end
    end

    if #_ > 0 then
        exports['zero-eye']:ForceOptions("workbenchweapon", _)
    else
        Zero.Functions.Notification("Crafting", "Je hebt geen items om te bewerken", "error")
    end
end

function EditWeapon(entity, slot)
    local slot = tonumber(slot)
    local itemsConfig = exports['zero-inventory']:config()
    local inventory = exports['zero-inventory']:getInventory()

    if weaponObject  then
        DeleteObject(weaponObject)
    end

    if inventory[slot] then
        local x,y,z = table.unpack(GetEntityCoords(entity))
        local model = itemsConfig.weapons[inventory[slot]['item']].objectivemodel

        RequestWeaponAsset(model, 31, 26)
		while not HasWeaponAssetLoaded(model) do
			Citizen.Wait(1)
		end

        weaponObject = CreateWeaponObject(model, 0, x, y, z + 1, true, true, false)
        FreezeEntityPosition(weaponObject, true)
        SetEntityRotation(weaponObject, 90.0, 0.0, 0.0, 2, false)
        RequestWeaponHighDetailModel(weaponObject)

        attachmentsFound = {}
        currentAttachment = 1
        for k,v in pairs(inventory[slot].datastash.attachments) do
            table.insert(attachmentsFound, {
                name = k,
                item = inventory[slot]['item'],
                slot = slot,
                index = v.index,
                hash = model,
                label = itemsConfig.items[k]['label'],
                maxindex = #itemsConfig.weapons[inventory[slot]['item']].attachments[k]
            })
        end

        loadAllAttachments(inventory[slot]['item'])


        setupCam()
        SetupAttachments()

        Citizen.Wait(2500)
        editWeapon = true
    end
end

function SetupAttachments()
    local config = exports['zero-inventory']:config()


    for k,v in pairs(attachmentsFound) do
        local name = v.name
        local item = v.item
        local attachment = GetHashKey(config.weapons[item].attachments[name][v.index])
        
        GiveWeaponComponentToPed(PlayerPedId(), v.hash, attachment)
        GiveWeaponComponentToWeaponObject(weaponObject, attachment)
    end

end

-- loop

Citizen.CreateThread(function()
    while true do
        if editWeapon then
            -- arrow up/down is type
            -- arrow right/left is index

            if #attachmentsFound > 0 and currentAttachment then
                local data = attachmentsFound[currentAttachment]


                local attachment_offset = GetEntityCoords(weaponObject)


                Zero.Functions.DrawText(attachment_offset.x + 0.5, attachment_offset.y - 0.2, attachment_offset.z + 0.3, "[Niet opslaan] Backspace")
                Zero.Functions.DrawText(attachment_offset.x + 0.5, attachment_offset.y - 0.1, attachment_offset.z + 0.3, "[Opslaan] Enter")

                Zero.Functions.DrawText(attachment_offset.x - 0.5, attachment_offset.y - 0.2, attachment_offset.z + 0.3, "UP")
                Zero.Functions.DrawText(attachment_offset.x - 0.5, attachment_offset.y - 0.2, attachment_offset.z + 0.1, "[Attachment] ~g~ "..data.label.." ~w~ [Type] "..data.index.."")
                Zero.Functions.DrawText(attachment_offset.x - 0.5, attachment_offset.y - 0.2, attachment_offset.z + -0.1, "DOWN")

                Zero.Functions.DrawText(attachment_offset.x - 0.7, attachment_offset.y - 0.2, attachment_offset.z + 0.3, "RIGHT")
                Zero.Functions.DrawText(attachment_offset.x - 0.3, attachment_offset.y - 0.2, attachment_offset.z + 0.3, "LEFT")

                if IsControlJustPressed(0, Zero.Config.Keys['TOP']) then
                    if attachmentsFound[currentAttachment + 1] then
                        currentAttachment = currentAttachment + 1
                        SetupAttachments()
                    end
                end
                if IsControlJustPressed(0, Zero.Config.Keys['DOWN']) then
                    if attachmentsFound[currentAttachment - 1] then
                        currentAttachment = currentAttachment - 1
                        SetupAttachments()
                    end
                end

                if IsControlJustPressed(0, Zero.Config.Keys['RIGHT']) then
                    if data.index + 1 <= data.maxindex then
                        data.index = data.index + 1
                        attachmentsFound[currentAttachment] = data
                        SetupAttachments()
                    end
                end
                if IsControlJustPressed(0, Zero.Config.Keys['LEFT']) then
                    if data.index - 1 >= 1 then
                        data.index = data.index - 1
                        attachmentsFound[currentAttachment] = data
                        SetupAttachments()
                    end
                end

        
            end

            if (IsControlJustPressed(0, Zero.Config.Keys['BACKSPACE'])) then
                DeleteObject(weaponObject)
     
                SetCamActive(camera, false)
                RenderScriptCams(false, true, 2500, false, false)
                DestroyCam(camera, true)

                SetEntityVisible(PlayerPedId(), true)
                SetEntityCanBeDamaged(PlayerPedId(), true)
                editWeapon = false
            end

            if (IsControlJustPressed(0, Zero.Config.Keys['ENTER'])) then
                DeleteObject(weaponObject)
     
                SetCamActive(camera, false)
                RenderScriptCams(false, true, 2500, false, false)
                DestroyCam(camera, true)

                SetEntityVisible(PlayerPedId(), true)
                SetEntityCanBeDamaged(PlayerPedId(), true)

                saveObjectSettings()
                editWeapon = false
            end
        end

        Citizen.Wait(0)
    end
end)

function loadAllAttachments(item)
    local player = PlayerPedId()
    local config = exports['zero-inventory']:config()
    local weapon = config.weapons[item]

    DoScreenFadeOut(150)

    local model = weapon.objectivemodel
    GiveWeaponToPed(player, model, 0, false, true)

    for k,v in pairs(weapon.attachments) do
        for y,z in pairs(v) do
            Citizen.Wait(10)
            GiveWeaponComponentToPed(player, model, GetHashKey(z))
        end
    end

    RemoveAllPedWeapons(player)

    DoScreenFadeIn(150)
end

function setupCam()
    local ply = PlayerPedId()
    local coord = GetEntityCoords(ply)

    for k,v in pairs(benches) do
        local distance = #(coord - vector3(v.x, v.y, v.z))
        if (distance <= 10) then

            setupCamCoord(v.cam)
            
            return
        end
    end
end

function setupCamCoord(camCoord)
    local ply = PlayerPedId()
    SetEntityVisible(ply, false)
    SetEntityCanBeDamaged(ply, false)

    camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 2500, true, true)
    SetCamCoord(camera, camCoord.x, camCoord.y, camCoord.z + 0.5)
    SetCamRot(camera, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)) + 180)

    PointCamAtEntity(camera, weaponObject)
end

function saveObjectSettings()
    local saveData = attachmentsFound

    if saveData then
        for k,v in pairs(saveData) do
            TriggerServerEvent("Zero:Server-Inventory:SetWeaponCompType", v.slot, v.name, v.index)
        end
    end

    saveData = nil
    RemoveAllPedWeapons(PlayerPedId())
end