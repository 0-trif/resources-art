CREATED_PETS = {}

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

function CreateSleepingPet(index)
    if not CREATED_PETS[index].sleepingPet and CREATED_PETS[index].loc.x then
        local x,y,z = CREATED_PETS[index].loc.x, CREATED_PETS[index].loc.y, CREATED_PETS[index].loc.z
        local model = GetHashKey(CREATED_PETS[index].model)

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local pet_spawned = CreatePed(24, model, x, y, z, 0.0, false, false)
        SetEntityAsMissionEntity(pet_spawned, true, true)
        SetPedFleeAttributes(pet_spawned, false, false)
        
        SetPedComponentVariation(pet_spawned, 0, 0, CREATED_PETS[index].variation)

        SetPedCanBeTargetted(pet_spawned, false)

        SetBlockingOfNonTemporaryEvents(pet_spawned, true)
    
        SetPedCombatAttributes(pet_spawned, 17, 1)
        SetPedAlertness(pet_spawned, 0)
        SetEntityInvincible(pet_spawned, true)

        SetEntityCollision(pet_spawned, false, true)
        
        if CREATED_PETS[index].mods then
            for k,v in pairs(CREATED_PETS[index].mods) do
                local k, v = tonumber(k), tonumber(v)
                SetPedComponentVariation(pet_spawned, k, 0, v)
            end
        end

        local sleepingAnim = config.pets[CREATED_PETS[index].model].sleeping
        CREATED_PETS[index].sleepingPet = pet_spawned

        if (sleepingAnim) then
            RequestAnimDict(sleepingAnim.dict)
            while not HasAnimDictLoaded(sleepingAnim.dict) do
                Wait(0)
            end

            FreezeEntityPosition(pet_spawned, true)

            TaskPlayAnim(pet_spawned, sleepingAnim.dict, sleepingAnim.anim, 8.0, -8, -1, 1, 0, false, false, false)
        end
    end
end

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do Wait(0) end

    TriggerServerEvent("Zero:Server-Pets:ReqSync")

    while true do
        local timer = 750
        local coord = GetEntityCoords(PlayerPedId())

        for k, v in pairs(CREATED_PETS) do
            if v.sleeping and v.loc.x then
                if not DoesEntityExist(v.sleepingPet) then
                    v.sleepingPet = nil
                end
            end

            if v.pet_spawned then
                if v.owner == GetPlayerServerId(PlayerId()) then
                    local pos = GetEntityCoords(v.pet_spawned)


                    if IsEntityDead(v.pet_spawned) then
                        SetPetDead(k)
                        ::CONTINUE::
                    end

                    local distance = #(pos - coord)
                    if (#(pos - coord) <= 5) then
                        timer = 0

                        Zero.Functions.DrawText(pos.x, pos.y, pos.z + 0.5, '~g~' .. v.label)
                    elseif (distance > 150) then
                        if DoesEntityExist(v.pet_spawned) then
                            TriggerServerEvent("Zero:Server-Pets:SetSleep", k, true)
                        end
                    end
                end
            elseif (v.sleeping and not v.sleepingPet) then
                CreateSleepingPet(k)
            elseif (v.sleeping and v.sleepingPet) then
                local pos = GetEntityCoords(v.sleepingPet)
                local distance = #(pos - coord)

                SetEntityCoords(v.sleepingPet, v.loc.x, v.loc.y, v.loc.z -  config.pets[v.model].offset)
                SetEntityHeading(v.sleepingPet, v.loc.h)

                if (#(pos - coord) <= 5) then
                    timer = 0
                    
                    Zero.Functions.DrawText(pos.x, pos.y, pos.z, 'Slapen..')
                end
            end
        end
        Wait(timer)
    end
end)


Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do Wait(0) end

    TriggerServerEvent("Zero:Server-Pets:ReqSync")

    while true do
        local coord = GetEntityCoords(PlayerPedId())

        for k, v in pairs(CREATED_PETS) do
            if DoesEntityExist(v.pet_spawned) then
                if v.owner == GetPlayerServerId(PlayerId()) then
                    local coord = GetEntityCoords(v.pet_spawned)
                    TriggerServerEvent("Zero:Server-Pets:UpdatePetPosition", k, {
                        x = coord.x,
                        y = coord.y, 
                        z = coord.z,
                        h = GetEntityHeading(v.pet_spawned)
                    })
                    Wait(1500)
                end
            end
        end
        Wait(750)
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(config.petStore.x,  config.petStore.y,  config.petStore.z)
    SetBlipColour(blip, 2)
    SetBlipCategory(blip, 0)
    SetBlipSprite(blip, 463)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Dierenwinkel")
    
    EndTextCommandSetBlipName(blip)

    SetBlipScale(blip, 0.8)

    while true do
        local timer = 750

        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)
        local x,y,z =  config.petStore.x,  config.petStore.y,  config.petStore.z
        local distance = #(vector3(x, y, z) - pos)

        if distance <= 3 then
            timer = 0
            TriggerEvent("interaction:show", "Dierenwinkel", function()
                TriggerEvent("Zero:Client-Pets:AnimalShop")
			end)
        end
        Wait(timer)
    end
end)

-- functions
function WhistlePet(id)
    local ply = PlayerPedId()
    local pos = GetEntityCoords(ply)

    for k,v in pairs(CREATED_PETS) do
        if v.id == id then
            if v.owner == GetPlayerServerId(PlayerId()) then
                if v.dead == 0 then
                    if v.sleeping and v.loc.x then
                        local coord = GetEntityCoords(v.sleepingPet)
                        local distance = #(coord - pos)

                        if distance <= 3 then
                            openWakeupMenu(k)
                        else
                            Zero.Functions.Notification("Huisdier", "Je staat te ver van je huisdier", "error")
                        end
                    elseif not v.sleeping and v.pet_spawned then 
                        OpenAwakeMenu(k)
                    elseif v.sleeping and (not DoesEntityExist(v.sleepingPet) or v.loc.x == nil) then
                        OpenCallMenu(k)
                    end
                else
                    Zero.Functions.Notification('Huisdier', 'Huisdier heeft hulp nodig', 'error')
                end
            else
                Zero.Functions.Notification("Huisdier", "Dit huisdier luistert niet naar jou", "error")
            end
            break
        end
    end
end


-- events

RegisterNetEvent("Zero:Client-Pets:BuyWhistle")
AddEventHandler("Zero:Client-Pets:BuyWhistle", function(animalId)
    TriggerServerEvent("Zero:Server-Pets:BuyWhistle", animalId)
end)

RegisterNetEvent("Zero:Client-Pets:UsedWhistle")
AddEventHandler("Zero:Client-Pets:UsedWhistle", function(slot, slotdata)
    if slotdata.datastash.animalId then
        WhistlePet(slotdata.datastash.animalId)
    end
end)


RegisterNetEvent("Zero:Client-Pets:AnimalList")
AddEventHandler("Zero:Client-Pets:AnimalList", function()
    exports['zero-ui']:element(function(ui)
        local _ = {}

        for k,v in pairs(CREATED_PETS) do

            if v.owner == GetPlayerServerId(PlayerId()) then

                _[#_+1] = {
                    label = v.label,
                    subtitle = "Koop fluitje voor "..v.label.."",
                    event = "Zero:Client-Pets:BuyWhistle",
                    value = v.id
                }

            end
        end

        
        _[#_+1] = {
            label = "Ga terug",
            subtitle = "Terug naar hoofdmenu",
            event = "Zero:Client-Pets:AnimalShop",
            next = false,
        }


        ui.set("Koop fluitje", _)
    end)
end)

RegisterNetEvent("Zero:Client-Pets:Wakeup")
AddEventHandler("Zero:Client-Pets:Wakeup", function(animalId)
    for k,v in pairs(CREATED_PETS) do
        if v.id == animalId then

            ExecuteCommand("e whistle")

            TriggerServerEvent("Zero:Server-Pets:SetSleep", k, false)
            TriggerEvent("Zero:Client-Pets:Spawn", k)

            break
        end
    end
end)

RegisterNetEvent("Zero:Client-Pets:Call")
AddEventHandler("Zero:Client-Pets:Call", function(animalId)
    for k,v in pairs(CREATED_PETS) do
        if v.id == animalId then

            ExecuteCommand("e whistle")

            TriggerServerEvent("Zero:Server-Pets:UpdatePetPosition", k, GetEntityCoords(PlayerPedId()))
            TriggerServerEvent("Zero:Server-Pets:SetSleep", k, false)
            Wait(200)
            TriggerEvent("Zero:Client-Pets:Spawn", k)
            break
        end
    end
end)

RegisterNetEvent("Zero:Client-Pets:Follow")
AddEventHandler("Zero:Client-Pets:Follow", function(animalId)
    for k,v in pairs(CREATED_PETS) do
        if v.id == animalId then

            if v.pet_spawned then
                local group = math.random(1111, 9999)
                local ped = PlayerPedId()

                ClearPedTasksImmediately(v.pet_spawned)

                SetPedAsGroupLeader(ped, group)
                SetPedAsGroupMember(v.pet_spawned, group)
                TaskFollowToOffsetOfEntity(v.pet_spawned, ped, 0.5, 0.0, 0.0, 5.0, -1, 0.0, 1)
                SetPedNeverLeavesGroup(v.pet_spawned, true)
                SetEntityAsMissionEntity(v.pet_spawned, true)
                SetGroupSeparationRange(group, 1.9)

            end
            break
        end
    end
end)

RegisterNetEvent("Zero:Client-Pets:SetSleep")
AddEventHandler("Zero:Client-Pets:SetSleep", function(animalId)
    for k,v in pairs(CREATED_PETS) do
        if v.id == animalId then
            ExecuteCommand("e whistle")
            TriggerServerEvent("Zero:Server-Pets:SetSleep", k, true)
            break
        end
    end
end)

RegisterNetEvent("Zero:Client-Pets:SendAway")
AddEventHandler("Zero:Client-Pets:SendAway", function(animalId)
    for k,v in pairs(CREATED_PETS) do
        if v.id == animalId then
            ExecuteCommand("e whistle2")

            TriggerServerEvent("Zero:Server-Pets:UpdatePetPosition", k, {})
            TriggerServerEvent("Zero:Server-Pets:SetSleep", k, true)
            break
        end
    end
end)


RegisterNetEvent("Zero:Client-Pets:Task")
AddEventHandler("Zero:Client-Pets:Task", function(taskIndex)
    local taskIndex = tonumber(taskIndex)

    for k,v in pairs(CREATED_PETS) do
        if v.id == last_animal_id then

            local ped = v.pet_spawned
            local anim = config.pets[v.model].animations[taskIndex]

            RequestAnimDict(anim.dict)
            while not HasAnimDictLoaded(anim.dict) do
                Wait(0)
            end
    
            TaskPlayAnim(v.pet_spawned, anim.dict, anim.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)

            TriggerEvent("Zero:Client-Pets:TasksMenu", v.id)
            break
        end
    end
end)

RegisterNetEvent("Zero:Client-Pets:ResetAnimations")
AddEventHandler("Zero:Client-Pets:ResetAnimations", function(animalId)
    for k,v in pairs(CREATED_PETS) do
        if v.id == animalId then
            ClearPedTasks(v.pet_spawned)
            ClearPedTasksImmediately(v.pet_spawned)
            TriggerEvent("Zero:Client-Pets:TasksMenu", animalId)
            break
        end
    end
end)

RegisterNetEvent("Zero:Client-Pets:TasksMenu")
AddEventHandler("Zero:Client-Pets:TasksMenu", function(animalId)
    for k,v in pairs(CREATED_PETS) do
        if v.id == animalId then
            local ui = exports['zero-ui']:element()
            
            menu = {}

            menu[#menu+1] = {
                label = "Stop",
                subtitle = "Stop alle animaties",
                event = "Zero:Client-Pets:ResetAnimations",
                value = animalId,
            }

            last_animal_id = animalId

            for y,z in pairs(config.pets[v.model].animations) do
                menu[#menu+1] = {
                    label = z.label,
                    subtitle = "Speel animatie: "..z.label.." af",
                    event = "Zero:Client-Pets:Task",
                    value = y,
                }
            end
    
    
            menu[#menu+1] = {
                label = "Terug",
                subtitle = "Ga terug naar hoofdmenu",
                event = "Zero:Client-Pets:OpenAwakeMenu",
                value = k,
                next = false,
            }
    
            ui.set(v.label, menu)

            break
        end
    end
end)


-- menus

function openWakeupMenu(index)
    local data = CREATED_PETS[index]
    local ui = exports['zero-ui']:element()

    if data then

        menu = {}

        menu[#menu+1] = {
            label = "Wakker maken",
            subtitle = "Maak "..data.label.." wakker",
            event = "Zero:Client-Pets:Wakeup",
            value = data.id,
        }

        menu[#menu+1] = {
            label = "Weg sturen",
            subtitle = "Stuur "..data.label.." weg",
            event = "Zero:Client-Pets:SendAway",
            value = data.id,
        }

        menu[#menu+1] = {
            label = "Sluit",
            subtitle = "Sluit menu",
            event = "",
        }

        ui.set(data.label, menu)
    end
end

RegisterNetEvent("Zero:Client-Pets:OpenAwakeMenu")
AddEventHandler("Zero:Client-Pets:OpenAwakeMenu", function(index)
    local index = tonumber(index)
    OpenAwakeMenu(index)
end)

RegisterNetEvent("Zero:Client-Pets:SetName")
AddEventHandler("Zero:Client-Pets:SetName", function(animalId, value)
    if value ~= "" and value then
        for k,v in pairs(CREATED_PETS) do
            if v.id == animalId then
                v.label = value
                TriggerServerEvent("Zero:Server-Pets:SetName", k, value)
                break
            end
        end
    end
end)


function OpenAwakeMenu(index)
    local data = CREATED_PETS[index]
    local ui = exports['zero-ui']:element()
    
    if data then
        menu = {}

        menu[#menu+1] = {
            label = "Volgen",
            subtitle = "Laat "..data.label.." je volgen",
            event = "Zero:Client-Pets:Follow",
            value = data.id,
        }

        menu[#menu+1] = {
            event = "Zero:Client-Pets:SetSleep",
            value = data.id,
            label = "Slapen",
            subtitle = "Laat "..data.label.." slapen",
        }

        menu[#menu+1] = {
            event = "Zero:Client-Pets:TasksMenu",
            value = data.id,
            label = "Opdrachten",
            subtitle = "Laat huisdier iets doen",
        }

    
        menu[#menu+1] = {
            label = "Weg sturen",
            event = "Zero:Client-Pets:SendAway",
            value = data.id,
            subtitle = "Stuur "..data.label.." weg",
        }

        menu[#menu+1] = {
            label = "Sluit",
            event = "",
            subtitle = "Menu sluiten",
        }
        ui.set(data.label, menu)
    end
end

function OpenCallMenu(index)
    local data = CREATED_PETS[index]
    local ui = exports['zero-ui']:element()
    
    if data then
        menu = {}

        menu[#menu+1] = {
            label = "Roepen",
            subtitle = "Roep "..data.label.." op",
            event = "Zero:Client-Pets:Call",
            value = data.id,
        }

        menu[#menu+1] = {
            label = "Geef naam",
            input = true,
            event = "Zero:Client-Pets:SetName",
            value = data.id,
        }

        menu[#menu+1] = {
            label = "Sluit",
            event = "",
            subtitle = "Menu sluiten",
        }

        ui.set(data.label, menu)
    end
end

function SetPetDead(index)
    TriggerServerEvent("Zero:Server-Pets:UpdatePetPosition", index, {})
    TriggerServerEvent("Zero:Server-Pets:SetDead", index, true)
    
    CREATED_PETS[index]['pet_spawned'] = nil
    CREATED_PETS[index]['dead'] =  1
end


function AttackEntity(entity)
    local player = PlayerPedId()
    local plyc = GetEntityCoords(player)

    for k, v in pairs(CREATED_PETS) do  
        if v.pet_spawned then
            if v.owner == GetPlayerServerId(PlayerId()) then
                local distance = #(GetEntityCoords(v.pet_spawned) - plyc)
                if distance <= 8 then
                    
                    local canAttack = config.pets[v.model].attack
                    if canAttack then
                        Zero.Functions.Notification('Huisdieren', 'Huisdier gaat aanvallen')

                        TaskCombatPed(v.pet_spawned, entity, 0, 16)
                    end
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("attack-pet", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)


        if entity and IsEntityAPed(entity) then
            local distance = #(plyc - GetEntityCoords(entity))

            if distance <= 25 then
                for k, v in pairs(CREATED_PETS) do  
                    if v.pet_spawned then
                        if v.owner == GetPlayerServerId(PlayerId()) then
                            local distance = #(GetEntityCoords(v.pet_spawned) - plyc)
                            if distance <= 8 then
                                return true
                            end
                        end
                    end
                end
            end
        end

    end, {
        [1] = {
            name = "Aanvallen", 
            action = function(entity) 
               AttackEntity(entity)
            end,
        },
    }, GetCurrentResourceName(), 5)
end)