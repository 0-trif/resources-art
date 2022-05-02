RegisterNetEvent("Zero:Client-Pets:SyncPets")
AddEventHandler("Zero:Client-Pets:SyncPets", function(pets)
    CREATED_PETS = pets


    Wait(200)

    SyncBlips()
end)

RegisterNetEvent("Zero:Client-Pets:Spawn")
AddEventHandler("Zero:Client-Pets:Spawn", function(index)
    local index = tonumber(index)
    local data = CREATED_PETS[index]

    if data then
        local x,y,z = CREATED_PETS[index].loc.x, CREATED_PETS[index].loc.y, CREATED_PETS[index].loc.z
        local model = GetHashKey(data.model)

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local pet_spawned = CreatePed(24, model, x, y, z, 0.0, true, false)
        SetEntityAsMissionEntity(pet_spawned, true, true)
        SetPedFleeAttributes(pet_spawned, false, false)     

        SetPedComponentVariation(pet_spawned, 0, 0, CREATED_PETS[index].variation)
        
        SetBlockingOfNonTemporaryEvents(pet_spawned, true)
    
       -- SetPedCombatAttributes(pet_spawned, 17, 1)
        SetPedAlertness(pet_spawned, 0)

        if CREATED_PETS[index].mods then
            for k,v in pairs(CREATED_PETS[index].mods) do
                local k, v = tonumber(k), tonumber(v)
                SetPedComponentVariation(pet_spawned, k, 0, v)
            end
        end

        CREATED_PETS[index]['pet_spawned'] = pet_spawned
    end
end)

RegisterNetEvent("Zero:Client-Pets:AddPet")
AddEventHandler("Zero:Client-Pets:AddPet", function(pet)
    CREATED_PETS[#CREATED_PETS+1] = pet

     Wait(200)
    
    SyncBlips()
end)

RegisterNetEvent("Zero:Client-Pets:SleepStatus")
AddEventHandler("Zero:Client-Pets:SleepStatus", function(index, bool)
    if bool == 0 then
        bool = false
    else
        bool = true
    end

    CREATED_PETS[index]['sleeping'] = bool

    if CREATED_PETS[index].sleepingPet then
        DeleteEntity(CREATED_PETS[index].sleepingPet)
        CREATED_PETS[index].sleepingPet = nil
    end

    if bool then
        if CREATED_PETS[index].pet_spawned then    
            DeleteEntity(CREATED_PETS[index].pet_spawned)
            CREATED_PETS[index].pet_spawned = nil
        end
    end

    Wait(200)
    
    SyncBlips()
end)

RegisterNetEvent("Zero:Client-Pets:UpdateLocation")
AddEventHandler("Zero:Client-Pets:UpdateLocation", function(index, loc)
    CREATED_PETS[index]['sleeping'] = false
    CREATED_PETS[index]['loc'] = {
        x = loc.x,
        y = loc.y, 
        z = loc.z
    }
end)


blips = {}
function SyncBlips()
    for k,v in pairs(blips) do
        RemoveBlip(v)
    end
    blips = {}

    for k,v in pairs(CREATED_PETS) do
        if v.owner == GetPlayerServerId(PlayerId()) then
            if (v.sleeping and v.sleepingPet) then
                local blip = AddBlipForEntity(v.sleepingPet)
                SetBlipColour(blip, 2)
                SetBlipCategory(blip, 0)
                SetBlipSprite(blip, 463)

                BeginTextCommandSetBlipName("STRING")

                AddTextComponentSubstringPlayerName(v.label)
                
                EndTextCommandSetBlipName(blip)

                SetBlipScale(blip, 0.8)
                table.insert(blips, blip)
            end
        end
    end
end