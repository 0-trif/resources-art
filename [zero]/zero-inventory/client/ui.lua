RegisterNUICallback("ui-closed-inv", function()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(250)

    CloseTrunk()
    
    TriggerServerEvent("inventory:server:closestInventory", last_stash_index)
    inventory.vars.open = false
    TriggerEvent("Inventory:Client:Open", inventory.vars.open)
end)

RegisterNUICallback("ui-drag-inv", function(ui)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)

    if (ui.frominv == "player" and ui.toinv == "player") then
        TriggerServerEvent("inventory:server:drag", ui)
    else
        if (ui.event) then
            if (ui.event == "Zero-inventory:shops:buy") then
                TriggerServerEvent(ui.event, ui, last_shop_index)
            else
                TriggerServerEvent(ui.event, ui)
            end
        end
    end
end)

RegisterNUICallback("ui-drag-use", function(e)
    local slot = tonumber(e.slot)
    TriggerServerEvent("inventory:server:pressed", slot)
end)

RegisterNUICallback("saveSettings", function(ui)
    local settings = ui.settings
    TriggerServerEvent("inventory:server:saveSettings", settings)
end)

RegisterNUICallback("GiveItemEvent", function(ui)
    local player, distance = Zero.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("Zero:Server-Inventory:GiveItemEvent", ui, playerId)
    else
        Zero.Functions.Notification("Inventory", "Geen speler gevonden", "error")
    end
end)


RegisterNUICallback("ReceiveAttachments", function(ui, cb)
    cb(shared.config.weapons[ui.item].attachments[ui.attachment])
end)
RegisterNUICallback("selectedAttachment", function(ui)
    local slot = tonumber(ui.slot)
    local comp = tonumber(ui.comp) + 1
    local data = ui.data
    local type = ui.type

    if type and data and comp and slot then
        TriggerServerEvent("Zero:Server-Inventory:SetWeaponCompType", slot, type, comp)
   
    end
end)

-- command

exports("setBackground", function(type, url)
    SendNUIMessage({
        action = "background",
        type = type,
        url = url,
    })
end)