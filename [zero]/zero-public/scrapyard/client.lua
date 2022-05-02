local MailText = "Hey! <br><br> Er staat een voertuig op de lokatie onderaan in deze mail. <br><br> Haal dit voertuig op en breng hem terug naar de vuilnisbelt. "

local sellPoint = {x = 539.68688964844, y = -174.53854370117, z = 54.481349945068, h = 97.692832946777}

Citizen.CreateThread(function()
    local coord = {x = 539.68688964844, y = -174.53854370117, z = 54.481349945068, h = 97.692832946777}
    blip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(blip, 642)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 6)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Scrap verkoop")
    
    EndTextCommandSetBlipName(blip)
end)


local DefaultParts = {
    ['Engine'] = "engine",
    ['Deur-1'] = "door_dside_f",
    ['Deur-2'] = "door_dside_r",
    ['Deur-3'] = "door_pside_f",
    ['Deur-4'] = "door_pside_r",
    ['Band-1'] = "wheel_lf",
    ['Band-2'] = "wheel_rf",
    ['Band-3'] = "wheel_lr",
    ['Band-4'] = "wheel_rr",
}

local pickups = {
    {x = -812.83709716797, y = -1101.7387695313, z = 10.854070663452, h = 311.33535766602},
    {x = -498.85098266602, y = -63.659698486328, z = 39.908863067627, h = 150.99415588379},
    {x = -380.37371826172, y = 347.62814331055, z = 109.17828369141, h = 2.6383056640625},
    {x = 320.09957885742, y = 344.55294799805, z = 105.20137786865, h = 184.40103149414},
    {x = 694.59973144531, y = 220.41958618164, z = 92.398796081543, h = 57.061626434326},
    {x = 872.60583496094, y = -589.38134765625, z = 57.914783477783, h = 310.61810302734},
    {x = 864.46136474609, y = -2432.3449707031, z = 28.165103912354, h = 168.91482543945},
    {x = -544.19689941406, y = -1771.6007080078, z = 21.55230140686, h = 331.97402954102},
    {x = -805.30194091797, y = -1314.48046875, z = 5.0003600120544, h = 343.40515136719},
    {x = -1334.40234375, y = 254.96478271484, z = 61.788799285889, h = 286.19839477539},
    {x = -1183.912109375, y = -365.61349487305, z = 36.449462890625, h = 89.458335876465},
    {x = -225.2253112793, y = -271.06103515625, z = 49.027122497559, h = 67.542633056641},
    {x = 293.61752319336, y = -274.56958007813, z = 53.97993850708, h = 160.91603088379},
    {x = -947.31695556641, y = -2442.7478027344, z = 13.830763816833, h = 223.91404724121},
    {x = 553.60986328125, y = -1736.2510986328, z = 29.141815185547, h = 332.92346191406},
    {x = 502.30758666992, y = -1499.1389160156, z = 29.288650512695, h = 194.44674682617},
    {x = 3332.7963867188, y = 5158.4838867188, z = 18.299695968628, h = 149.2159576416},
    {x = 2891.6647949219, y = 4428.7026367188, z = 48.406547546387, h = 290.24896240234},
    {x = -2528.6616210938, y = 2345.1496582031, z = 33.059875488281, h = 37.821826934814},
}

function createPickupLocation()
    while true do
        local index = math.random(1, #pickups)

        if index ~= Config.Vars['scrapyard']['lastpickup'] then
            Config.Vars['scrapyard']['lastpickup'] = index

            return index
        end
        Wait(0)
    end
end


RegisterNetEvent("StartJob")
AddEventHandler("StartJob", function(playerJob)
    if (playerJob == "scrapyard") then
        if not Config.Vars['scrapyard']['searching'] then
            Config.Vars['scrapyard']['searching'] = true

            TriggerEvent("phone:notification", "./images/logos/mail.png", "Zoeken naar taak..", "We zijn een taak voor je aan het zoeken, dit kan even duren.", 5000) 

            Citizen.Wait(math.random(10000, 25000))

            TriggerEvent("phone:notification", "./images/logos/mail.png", "Taak gevonden!", "We hebben een taak voor je gevonden.", 5000) 

            local pickup = createPickupLocation()

            if pickup then
                TriggerEvent("phone:notification", "./images/logos/mail.png", "Ophaal lokatie", "Je hebt een mail binnen van een klant", 5000) 
                TriggerEvent("Zero:Client-Phone:AddMail", "Vuilnisbelt", "Ophaal lokatie van opdrachtgever.", MailText, pickups[pickup], "./images/logos/mail.png")

                startPickUpVehicle(pickups[pickup].x, pickups[pickup].y, pickups[pickup].z, pickups[pickup].h)
            end
        end
    end
end)

function RandomModelVehicle()
    local _ = {
        [1] = "sultan",
        [2] = "bati",
        [3] = "sultanrs",
        [4] = "xa21",
        [5] = "comet2",
        [6] = "comet3",
    }

    return _[math.random(1, #_)]
end

function startPickUpVehicle(x,y,z,h)
    local player = PlayerPedId()

    while true do
        local coord = GetEntityCoords(player)
        local distance = #(coord - vector3(x,y,z))

        if (distance <= 25) then

            Zero.Functions.SpawnVehicle({
                model = RandomModelVehicle(),
                location = {x = x, y = y, z = z, h = h},
                teleport = false,
                network = true,
            }, function(vehicle)
                Config.Vars['scrapyard']['searching'] = false
                Config.Vars['scrapyard']['vehicle'] = vehicle
                
                SetVehicleEngineHealth(vehicle, 0.0)
                SetVehicleBodyHealth(vehicle, 0.0)
            end)

            return
        end

        Citizen.Wait(0)
    end
end


Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("mech-wheels", function(coords, entity)
        local ply = PlayerPedId()
        local x = GetEntityCoords(ply)

        if Config.Vars then
            if (IsEntityAVehicle(entity) and Config.Vars['scrapyard']['vehicle'] == entity) then
                if (#(GetEntityCoords(PlayerPedId()) - Config.Locations['scrapyard']) <= 20) then
                    return true, GetEntityCoords(entity)
                end
            end
        end
    end, {
        [1] = {
            name = "Voertuig afbreken", 
            action = function(entity) 
                GatheredParts = {}
                DestroyableParts = {
                    ['Engine'] = "engine",
                    ['Deur-1'] = "door_dside_f",
                    ['Deur-2'] = "door_dside_r",
                    ['Deur-3'] = "door_pside_f",
                    ['Deur-4'] = "door_pside_r",
                    ['Band-1'] = "wheel_lf",
                    ['Band-2'] = "wheel_rf",
                    ['Band-3'] = "wheel_lr",
                    ['Band-4'] = "wheel_rr",
                }
                
                DeleteEntityVehicle = Config.Vars['scrapyard']['vehicle']
            end,
        },
    }, GetCurrentResourceName(), 10)
end)

Citizen.CreateThread(function()
    while true do

        if DeleteEntityVehicle then

            local vehicle = DeleteEntityVehicle

            for k,v in pairs(DestroyableParts) do
                local index = GetEntityBoneIndexByName(vehicle, v)

                if index then
                    local indexPosition = GetWorldPositionOfEntityBone(vehicle, index)
                    local distance = #(GetEntityCoords(PlayerPedId()) - indexPosition)

                    if distance > 20 then
                        rawset(DestroyableParts, k, nil)
                    end

                    if (distance <= 3 and distance > 1.5) then
                        Zero.Functions.DrawText(indexPosition.x, indexPosition.y, indexPosition.z, k)
                    elseif (distance <= 1.5) then
                        if not gathering then
                            Zero.Functions.DrawText(indexPosition.x, indexPosition.y, indexPosition.z, "~g~E~w~ - Slopen")
                            if IsControlJustPressed(0, Zero.Config.Keys['E']) then
                                GatherPart(k,v, function(bool)
                                    if (bool) then
                                        GatheredParts = GatheredParts or {}
                                        GatheredParts[v] = GatheredParts[v] or 0
                                        GatheredParts[v] = GatheredParts[v] + 1

                                        rawset(DestroyableParts, k, nil)
                                        if count(DestroyableParts) == 0 then
                                            DeleteVehicle(DeleteEntityVehicle)
                                            DeleteEntityVehicle = nil
                                            DestroyableParts = nil

                                            if GatheredParts then
                                                GiveItemsGathered(GatheredParts)
                                                GatheredParts = nil
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end         
                end
            end
        else
            Citizen.Wait(750)
        end
        Citizen.Wait(0)
    end
end)

function GatherPart(k, v, cb)
    gathering = true

    Zero.Functions.Progressbar("spawn_object", "Onderdeel slopen..", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {

    }, {}, {}, function() -- Done
        gathering = false
        cb(true)
    end, function() -- Cancel
        gathering = false
        cb(false)
    end)
end

function count(x)
    local count = 0
    for k,v in pairs(x) do
        count = count + 1
    end
    return count
end

function GiveItemsGathered(items)
    TriggerServerEvent("Zero:Server-Public:ScrapYard", items)
end

CreateSellNpc = function(data)
    local x,y,z,h = data.x, data.y, data.z, data.h

    local model = data.model
    local hash = GetHashKey(data.model)

    RequestModel(hash)
    while not HasModelLoaded(model) do Wait(0) end

    local ped = CreatePed(12, hash, x, y, z - 1, h, false, false)
    FreezeEntityPosition(ped, true)
    SetPedCanBeTargetted(ped, false)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    SetPedAlertness(ped, 0)
    SetEntityInvincible(ped, true)
    SetPedComponentVariation(ped, 0, 0, 0, 2)

    while not HasAnimDictLoaded('amb@code_human_wander_clipboard@male@base') do
        Citizen.Wait(5)
        RequestAnimDict('amb@code_human_wander_clipboard@male@base')
    end

    clip = CreateObject(GetHashKey('p_amb_clipboard_01'), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(ped, 18905)
    AttachEntityToEntity(clip, ped, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

    TaskPlayAnim(ped, 'amb@code_human_wander_clipboard@male@base', "static", 3.0, -8, -1, 63, 0, 0, 0, 0 )

    
    return ped
end

Citizen.CreateThread(function()
    sellNpcTrash = nil

    exports['zero-eye']:looped_runtime("scrap-trade", function(coords, entity)
        if IsEntityAPed(entity) and sellNpcTrash then
            if entity == sellNpcTrash then
                return true, GetEntityCoords(entity)
            end
        end
    end, {
        [1] = {
            name = "Onderdelen inruilen (Geld)", 
            action = function(entity) 
                TriggerEvent("disableEye")
                TriggerServerEvent("Zero:Server-Public:TradeParts", "money")
            end,
        },
        [2] = {
            name = "Onderdelen omsmelten", 
            action = function(entity) 
                TriggerEvent("disableEye")
                TriggerServerEvent("Zero:Server-Public:TradeParts", "parts")
            end,
        },
    }, GetCurrentResourceName(), 10)

    while true do
        local timer = 750
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local distance = #(vector3(sellPoint.x, sellPoint.y, sellPoint.z) - pos)

        if (distance <= 30) then
            timer = 0

            if not DoesEntityExist(sellNpcTrash) then
                sellNpcTrash = CreateSellNpc({
                    x = sellPoint.x,
                    y = sellPoint.y, 
                    z = sellPoint.z,
                    h = sellPoint.h,
                    model = "s_m_m_autoshop_02"
                })
            end
        end
        
        Wait(timer)
    end
end)

Citizen.CreateThread(function()
    exports['vehicleHire']:createHirePoint(-543.53, -1643.83, 19.08, 62.41, {
        [1] = {
            label = "Flatbed (nodig)",
            model = 'flatbed',
            price = 50,
            loc = {x = -552.14, y = -1646.70, z = 19.04,h = 163.119003295898},
        },
    })
end)