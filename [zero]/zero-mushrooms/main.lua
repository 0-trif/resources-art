-- creating blip (farm)
Citizen.CreateThread(function()
	blip = AddBlipForCoord(config.farm.x, config.farm.y, config.farm.z)
	SetBlipSprite(blip, 465)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 78)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Onbekend")
    EndTextCommandSetBlipName(blip)


    RequestModel(`cs_jimmydisanto`)
    while not HasModelLoaded(`cs_jimmydisanto`) do
        Wait(0)
    end
    ped = CreatePed(24, `cs_jimmydisanto`, config.sell.x, config.sell.y, config.sell.z - 1, config.sell.h, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityAsMissionEntity(ped, true, true)

    SetEntityCanBeDamaged(ped, false)
    SetPedCanBeTargetted(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

-- main loop + init spawning

Citizen.CreateThread(function()
    while true do
        local timer = 750

        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)

        local farm_distance = #(pos - vector3(config.farm.x, config.farm.y, config.farm.z))


        if (farm_distance <= config.render) then
            timer = 0

            InitSpawning()
            InitFarming(pos)
        end
        
        local wash_distance = #(pos - vector3(config.wash.x, config.wash.y, config.wash.z))

        if (wash_distance <= config.render and IsEntityInWater(PlayerPedId())) then
            timer = 0

            InitWashing()
        end
              
        local dry_distance = #(pos - vector3(config.dry.x, config.dry.y, config.dry.z))

        if (dry_distance <= 1.5) then
            timer = 0

            InitDrying()
        end


        local sell_distance = #(pos - vector3(config.sell.x, config.sell.y, config.sell.z))

        if (sell_distance <= 1.5) then
            timer = 0
            
            InitSelling()
        end


        Wait(timer)
    end
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750
        if drying then
            timer = 0

            TriggerEvent("interaction:show", "X - Annuleren", function()
            end)

            if IsControlJustPressed(0, Zero.Config.Keys['X']) then
                drying = false
                ExecuteCommand("e c")
                FreezeEntityPosition(PlayerPedId(), false)
            end
        end
        Wait(timer)
    end
end)

function InitFarming(pos)
    currentIndex = nil
    for k,v in pairs(vars.spawned) do
        if not DoesEntityExist(v) then
            table.remove(vars.spawned, k)
        end

        local coord = GetEntityCoords(v)
        local distance = #(pos - coord)

        if distance <= 5 then
            currentIndex = k
            TriggerEvent("Zero:Client-Inventory:DisplayUsable", "shovel")
        end
    end
end

function InitWashing()
    local ply = PlayerPedId()

    if not Washing then
        TriggerEvent("interaction:show", "Wassen", function()
            Washing = true
        end)
    else
        local item, slot, amount = Zero.Functions.HasItem('mushroom')
        if item then
            ExecuteCommand("e kneel2")
            ExecuteCommand("e mechanic3")

            Wait(3000)
        
            TriggerServerEvent("Zero:Server-Mushrooms:Wash", slot)
            ExecuteCommand("e c")
        else
            Washing = false
            Zero.Functions.Notification("Wassen", "Je hebt geen paddenstoelen", "error")
        end
    end
end

function InitDrying()
    local ply = PlayerPedId()

    if not drying then
        TriggerEvent("interaction:show", "Drogen", function()
            drying = true
            FreezeEntityPosition(ply, true)
        end)
    else
        local item, slot, amount = Zero.Functions.HasItem('washed-mushroom')

        if item then
            ExecuteCommand("e mechanic4")

            Wait(5000)

            if drying then       
                local finished = exports['zero-skill']:skill("Paddenstoelen drogen", math.random(3000, 5000))

                if finished then
                    TriggerServerEvent("Zero:Server-Mushrooms:WashDryed", slot)
                else
                    drying = false
                    FreezeEntityPosition(ply, false)
                    ExecuteCommand("e c")
                end
            end
        else
            drying = false
            FreezeEntityPosition(ply, false)
            ExecuteCommand("e c")
            Zero.Functions.Notification("Drogen", "Je hebt geen paddenstoelen", "error")
        end
    end
end

function InitSelling()
    TriggerEvent("interaction:show", "Verkopen", function()
        local item, slot, amount = Zero.Functions.HasItem('dryed-mushroom')
        if item then
            TriggerServerEvent("Zero:Server-Mushrooms:Sell")
        else
            Zero.Functions.Notification('Verkopen', 'Je hebt geen gedroogde paddenstoelen', 'error')
        end
    end)
end

RegisterNetEvent("Zero:Client-Mushrooms:UsedShovel")
AddEventHandler("Zero:Client-Mushrooms:UsedShovel", function()
    local pos = GetEntityCoords(PlayerPedId())
    local coord = GetEntityCoords(vars.spawned[currentIndex])
    local distance = #(pos - coord)

    if not currentIndex then return end
    
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    Zero.Functions.Progressbar("shovel", "Paddenstoel uitgraven..", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {

    }, {}, {}, function() -- Done

        ExecuteCommand('e c')

        DeleteEntity(vars.spawned[currentIndex])
        table.remove(vars.spawned, currentIndex)

        TriggerServerEvent('Zero:Location', distance)
        TriggerServerEvent("Zero:Server-Mushrooms:Farmed")
    end, function() -- Cancel
        ExecuteCommand('e c')
    end)
end)