Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Citizen.Wait(0)
    end

    TriggerServerEvent("consumebles:sync")
end)

RegisterNetEvent("consumebles:cl:sync")
AddEventHandler("consumebles:cl:sync", function(account)
    statusAccount = account
    SetEntityHealth(PlayerPedId(), statusAccount.health)
    startConsumeLoop()
end)

function startConsumeLoop()
    statusAccount['food'] =  statusAccount['food'] - 5 >= 0 and statusAccount['food'] - 5 or 0
    statusAccount['water'] =  statusAccount['water'] - 5 >= 0 and statusAccount['water'] - 5 or 0
    statusAccount['health'] = GetEntityHealth(PlayerPedId())

    TriggerEvent("hud:set", "food", statusAccount['food'])
    TriggerEvent("hud:set", "water", statusAccount['water'])
    TriggerEvent("hud:set", "health", (100/GetEntityMaxHealth(PlayerPedId())*statusAccount['health']))

    TriggerServerEvent('consumebles:set', statusAccount)

    SetTimeout(60000 * 5, startConsumeLoop)
end

function healStatus()
    statusAccount['food'] = 100
    statusAccount['water'] = 100

    TriggerEvent("hud:set", "food", statusAccount['food'])
    TriggerEvent("hud:set", "water", statusAccount['water'])
    TriggerEvent("hud:set", "health", (100/GetEntityMaxHealth(PlayerPedId())*statusAccount['health']))

    TriggerServerEvent('consumebles:set', statusAccount)
end

function doEntityDamage()
    local player = PlayerPedId()
    local health = GetEntityHealth(player)
    local health = health - 10 >= 0 and health - 10 or 0

    SetEntityHealth(player, health)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
end

Citizen.CreateThread(function()
    DoScreenFadeIn(0)
    while true do
        if statusAccount then
            if (statusAccount.food <= 0 or statusAccount.water <= 0) then
                doEntityDamage()
                Citizen.Wait(10000)
            else
                
                Citizen.Wait(250)
            end
        end

        Citizen.Wait(0)
    end
end)

RegisterNetEvent("consumebles:client:usedFood")
AddEventHandler("consumebles:client:usedFood", function(itemdata, slot)
    local ped = PlayerPedId()

    if (Zero.Functions.HasItem(itemdata.item)) then
        if (Config.Items[itemdata.item]) then
            if Config.Items[itemdata.item].type == 1 then
                if statusAccount.food ~= 100 then
                    TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
                    Zero.Functions.Progressbar("food", "Eten..", 2500, false, true, {}, {}, {}, {}, function() -- Done
    
                        statusAccount.food = statusAccount.food + Config.Items[itemdata.item].amount <= 100 and statusAccount.food + Config.Items[itemdata.item].amount or 100
                        TriggerEvent("hud:set", "food", statusAccount['food'])
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        TriggerServerEvent("Zero:Server-Mechanic:UsedItemRemove", slot)
                    end, function() -- Cancel
                        ClearPedTasksImmediately(ped)
                    end)
                end
            elseif Config.Items[itemdata.item].type == 2 then
                if statusAccount.water ~= 100 then
                    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
                    Zero.Functions.Progressbar("water", "Drinken..", 2500, false, true, {}, {}, {}, {}, function() -- Done
     

                        statusAccount.water = statusAccount.water + Config.Items[itemdata.item].amount <= 100 and statusAccount.water + Config.Items[itemdata.item].amount or 100
                        TriggerEvent("hud:set", "water", statusAccount['water'])
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        TriggerServerEvent("Zero:Server-Mechanic:UsedItemRemove", slot)

                    end, function() -- Cancel
                        ClearPedTasksImmediately(ped)
                    end)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Citizen.Wait(0)
    end

    TriggerEvent("hud:clear")
    
    
    for k,v in pairs(Config.StatusTypes) do
        TriggerEvent("hud:add", v.label, v.colour, v.id)
        TriggerEvent("hud:hide", v.id)
    end

    while true do
        TriggerEvent("hud:set", "health", (100/GetEntityMaxHealth(PlayerPedId())*GetEntityHealth(PlayerPedId())))
        Citizen.Wait(3000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if (IsControlPressed(0, Zero.Config.Keys['Z'])) then
            TriggerEvent("hud:show", "food")
            TriggerEvent("hud:show", "water")
            TriggerEvent("hud:show", "health")

            while IsControlPressed(0, Zero.Config.Keys['Z']) do
                Wait(0)
            end

            TriggerEvent("hud:hide", "food")
            TriggerEvent("hud:hide", "water")
            TriggerEvent("hud:hide", "health")
        end
        
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
    while not statusAccount do Wait(0) end
    
    while true do
        local found = false
        local before = {}

        statusAccount['health'] = GetEntityHealth(PlayerPedId())
        for k,v in pairs(statusAccount) do
            before[k] = v
        end

        Citizen.Wait(3000)

        statusAccount['health'] = GetEntityHealth(PlayerPedId())
        for k,v in pairs(statusAccount) do
            if v ~= before[k] then
                TriggerEvent("hud:show", k)
                found = true
            end
        end

        if found then
            Citizen.Wait(3500)
            for k,v in pairs(statusAccount) do
                if v ~= before[k] then
                    TriggerEvent("hud:hide", k)
                end
            end
        end
    end
end)