exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Functions.GetPlayerData(function(PlayerData)
        PlayerData = PlayerData
    end)
    Zero.Vars.Spawned = true
    TriggerEvent("resyncWeaponProps")
end)

Citizen.CreateThread(function()
    Wait(1000)
    
    if (Zero.Vars.Spawned) then
        Zero.Functions.GetPlayerData(function(PlayerData)
            PlayerData = PlayerData
        end)
    end

    while not Zero.Vars.Spawned do Wait(0) end


    SendNUIMessage({
        action = "items",
        data   = {
            items = shared.config.items,
            slots = shared.config.slots,
            maxweight = shared.config.MaxWeight
        }
    })
    TriggerServerEvent("inventory:server:playerloaded")
end)


RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
    while not HasAnimDictLoaded("pickup_object") do RequestAnimDict("pickup_object") Wait(100) end
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(800)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("inventory:client:toggle")
AddEventHandler("inventory:client:toggle", function()
    if not inventory.vars.loadedItems then return end
    if inventory.vars.locked then return end
    if IsCrafting then return end

    inventory.vars.open = not inventory.vars.open

    Zero.Functions.GetPlayerData(function(PlayerData)
        if not PlayerData.MetaData.dead and not PlayerData.MetaData.ishandcuffed then  
            TriggerEvent("randPickupAnim")
            TriggerEvent("Inventory:Client:Open", inventory.vars.open)
            if (inventory.vars.open) then
                TriggerScreenblurFadeIn(250)
            else
                TriggerScreenblurFadeOut(250)
            end
            
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "toggle",
                data   = {bool = inventory.vars.open, items = inventory.data.items},
            })

            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if get_vehicle_seat() == -1 then
                    local numberplate = string.upper(GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1))))
                    if numberplate then
                        TriggerServerEvent("inventory:server:opendashboard", numberplate)
                        return
                    end
                end
            end
            open_drops_inventory()
        end
    end)
end)

RegisterNetEvent("inventory:client:close")
AddEventHandler("inventory:client:close", function()
    inventory.vars.open = false
    TriggerEvent("Inventory:Client:Open", inventory.vars.open)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "toggle",
        data   = {bool = inventory.vars.open, items = inventory.data.items},
    })
    last_stash_index = ""
end)

RegisterNetEvent("inventory:client:receive")
AddEventHandler("inventory:client:receive", function(items)
    inventory.data.items = items
    inventory.vars.loadedItems = true

    checkWeapons()

    SendNUIMessage({
        action = "sync_items",
        data = {items = inventory.data.items}
    })
end)

RegisterNetEvent("inventory:client:resyncSlot")
AddEventHandler("inventory:client:resyncSlot", function(slot)
    SendNUIMessage({
        action = "resync_slot",
        data = {slot = slot}
    })
    TriggerEvent("resyncWeaponProps")
end)

RegisterNetEvent("inventory:client:opensecondary")
AddEventHandler("inventory:client:opensecondary", function(data)
    if (data) then
        opened_ground = false

        SendNUIMessage({
            action = "set_other",
            data   = {
                event = data.event,
                slots = data.slots,
                items = data.inventory,
                extra = {stash = data.index},
                label = data.label
            }
        })

        SendNUIMessage({
            action = "toggle",
            data   = {bool = true, items = inventory.data.items},
        })
        inventory.vars.open = true

        TriggerScreenblurFadeIn(250)

        last_stash_index = data.index

        Wait(200)
        SetNuiFocus(true, true)
    end
end)


RegisterNetEvent("inventory:client:syncstash")
AddEventHandler("inventory:client:syncstash", function(index, items)
    if not opened_ground then
        if (last_stash_index == index) then
            SendNUIMessage({
                action = "sync_other",
                data = {items = items},
            })
        end
    end
end)

RegisterNetEvent("inventory:client:receiveSettings")
AddEventHandler("inventory:client:receiveSettings", function(settings)
    --[[
            SendNUIMessage({
        action = "setup_settings",
        data = {
            settings = settings,
        }
    })
    ]]
end)

--[[
    RegisterNetEvent("inventory:client:settings")
AddEventHandler("inventory:client:settings", function(settings)
    settings = settings ~= nil and settings or {}

    SendNUIMessage({
        action = "open_settings",
        data = {
            settings = settings,
        }
    })
    SetNuiFocus(true, true)
end)
]]

RegisterNetEvent("inventory:client:weapon")
AddEventHandler("inventory:client:weapon", function(slot)
    weapons.apply(slot)
end)
RegisterNetEvent("inventory:client:useammo")
AddEventHandler("inventory:client:useammo", function(slot)
    weapons.ammo(slot)
end)

-- keymap
RegisterKeyMapping('inventory', 'Open Inventaris', 'keyboard', 'TAB')
RegisterCommand("inventory", function()
    TriggerEvent("inventory:client:toggle")
end)

RegisterNetEvent("Zero-inventory:client:note")
AddEventHandler("Zero-inventory:client:note", function(item, amount, reason)
    if inventory.vars.open then return end
    
    SendNUIMessage({
        action = "item_notification",
        data = {
            item = item,
            amount = amount,
            reason = reason,
        }
    })
end)

RegisterNetEvent("Zero-inventory:client:lock")
AddEventHandler("Zero-inventory:client:lock", function(bool)
    inventory.vars.locked = bool

    if bool == true then 
        TriggerEvent("inventory:client:close")
    end
end)

RegisterNetEvent("Zero:Client-Inventory:UsePersonalCard")
AddEventHandler("Zero:Client-Inventory:UsePersonalCard", function(slot)
    local item = inventory.data.items[slot]
    local coord = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("Zero:Server-Inventory:UsePersonalCard", item, coord)
end)

RegisterNetEvent("Zero:Client-Inventory:DisplayCard")
AddEventHandler("Zero:Client-Inventory:DisplayCard", function(item, loc)
    local ped = PlayerPedId()
    local coord = GetEntityCoords(ped)
    local distance = #(coord - loc)

    if (distance <= 5) then
        if (item.item == "idcard") then
            Zero.Functions.Notification("ID-Kaart", "Voornaam: "..item.datastash.PlayerData.firstname.." <br><br> Achternaam: "..item.datastash.PlayerData.lastname.." <br><br> Gender: "..item.datastash.PlayerData.gender.." <br><br> Geboortedatum: "..item.datastash.PlayerData.birthdate.." <br><br> Nationaliteit: "..item.datastash.PlayerData.nationality.."")
        elseif (item.item == "driverslicense") then
            Zero.Functions.Notification("Rijbewijs", "Voornaam: "..item.datastash.PlayerData.firstname.." <br><br> Achternaam: "..item.datastash.PlayerData.lastname.." <br><br> Gender: "..item.datastash.PlayerData.gender.." <br><br> Geboortedatum: "..item.datastash.PlayerData.birthdate.." <br><br> Nationaliteit: "..item.datastash.PlayerData.nationality.."")
        end
    end
end)

RegisterNetEvent("Zero:Client-Inventory:AttachmentUsed")
AddEventHandler("Zero:Client-Inventory:AttachmentUsed", function(slot)
    if (inventory.data.items[slot]) then
        local itemname = inventory.data.items[slot].item
        if (shared.config.items[itemname]['type'] == "attachment") then
            if (weapons.data.slot and inventory.data.items[weapons.data.slot]) then
                local weaponData = weapons.config['weapons'][inventory.data.items[weapons.data.slot].item]
                
                if (weaponData) then
                    if (weaponData.attachments and weaponData.attachments[itemname]) then
                        Zero.Functions.Progressbar("attachment", "Attachment opzetten..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                            if (inventory.data.items[slot] and inventory.data.items[slot]['item'] == itemname) then
                                TriggerServerEvent("Zero:Server-Inventory:LoadAttachment", weapons.data.slot, slot)
                            end
                        end, function() -- Cancel
                            ClearPedTasksImmediately(PlayerPedId())
                        end)
                    end
                end
            end
        end
    end
end)


RegisterNetEvent("Zero:Client-Inventory:ReloadAttachments")
AddEventHandler("Zero:Client-Inventory:ReloadAttachments", function()
    if GetCurrentPedWeapon(PlayerPedId()) then
        weapons.LoadWeaponComponents()
    end
end)

-- ITEM NOTIFICATIONS
local showingItemNotification = false
local counterItemDisplay = 0

RegisterNetEvent("Zero:Client-Inventory:DisplayUsable")
AddEventHandler("Zero:Client-Inventory:DisplayUsable", function(item)
    usabelItem = item
    counterItemDisplay = 2
end)

Citizen.CreateThread(function()
    while true do
        if counterItemDisplay > 1 and not showingItemNotification then
            showingItemNotification = true

            SendNUIMessage({
                action = "usableItem",
                bool = true,
                item = usabelItem,
            })
        elseif counterItemDisplay < 1 and showingItemNotification then
            showingItemNotification = false
            SendNUIMessage({
                action = "usableItem",
                bool = false,
            })
        end
        counterItemDisplay = counterItemDisplay - 1 > 0 and counterItemDisplay - 1 or 0
        Citizen.Wait(100)
    end
end)