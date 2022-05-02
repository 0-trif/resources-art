RegisterNetEvent("Zero:Client-Inventory:Crafting")
AddEventHandler("Zero:Client-Inventory:Crafting", function(items, skill)
    if not IsCrafting then
        SendNUIMessage({
            action = "crafting",
            data = {
                items = items,
                skill = skill,
                nextxp = nextUnlock(skill),
                event = "Zero:Server-Inventory:CraftItem",
                maxskill = crafting.maxlevel
            },
        })
        SetNuiFocus(true, true)
            
        TriggerEvent("randPickupAnim")
        TriggerScreenblurFadeIn(250)

        inventory.vars.open = true
        SendNUIMessage({
            action = "toggle",
            data   = {bool = inventory.vars.open, items = inventory.data.items},
        })
    end
end)

RegisterNetEvent("Zero:Client-Inventory:CustomCrafting")
AddEventHandler("Zero:Client-Inventory:CustomCrafting", function(items, event)
    if not IsCrafting then
        SendNUIMessage({
            action = "crafting",
            data = {
                items = items,
                skill = 100,
                event = event,
                maxskill = 100,
            },
        })
        SetNuiFocus(true, true)
            
        TriggerEvent("randPickupAnim")
        TriggerScreenblurFadeIn(250)

        inventory.vars.open = true
        SendNUIMessage({
            action = "toggle",
            data   = {bool = inventory.vars.open, items = inventory.data.items},
        })
    end
end)

RegisterNetEvent("Zero:Client-Inventory:CraftingStarted")
AddEventHandler("Zero:Client-Inventory:CraftingStarted", function(time)
    if IsCrafting then return end

    posx,posy,posz = table.unpack(GetEntityCoords(PlayerPedId()))
    local player = PlayerPedId()

    RequestAnimDict("amb@world_human_hammering@male@base")
    while not HasAnimDictLoaded("amb@world_human_hammering@male@base") do
      Citizen.Wait(0)
    end

    FreezeEntityPosition(player, true)

    CraftingTime = time

    IsCrafting = true

    Citizen.Wait(time)

    IsCrafting = false
    FreezeEntityPosition(player, false)
    ClearPedTasks(player)
end)

Citizen.CreateThread(function()
    while true do
        if IsCrafting then
            DisableAllControlActions(0, true)
            Zero.Functions.DrawText(posx,posy,posz, "Craften..")  

            if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_hammering@male@base", "base", 3) then
                TaskPlayAnim(PlayerPedId(), "amb@world_human_hammering@male@base", "base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
            end 
        end
        Citizen.Wait(1) 
    end
end)

function nextUnlock(xp)
    local new = nil
    for k,v in pairs(crafting.items) do
        if (v.level > xp) then
            if new == nil then
                new = v.level
            else
                if v.level <= new then
                    new = v.level
                end
            end
        end
    end

    new = new ~= nil and new or xp
    
    return new
end