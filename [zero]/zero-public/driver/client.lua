local pickups = {
    {x = -1375.44, y = 49.60, z = 53.70, h = 125.74},
    {x = -3018.80, y = 85.26, z = 11.60, h = 313.74},
    {x = -3001.77, y = 716.46, z = 28.36, h = 74.74},
    {x = -1966.35, y = 622.98, z = 121.68, h = 216.92},
    {x = -1507.07, y = 434.04, z = 110.97, h = 109.92},
    {x = -773.83, y = 295.41, z = 85.73, h = 219.14},
    {x = 63.44, y = 5.17, z = 69.05, h = 193.14},
    {x = 428.41, y = -667.41, z = 29.17, h = 127.14},
    {x = 328.74, y = -1035.01, z = 29.19, h = 182.14},
    {x = 57.59, y = -879.57, z = 30.36, h = 202.66},
    {x = -108.34, y = -607.51, z = 36.26, h = 254.98},
    {x = -195.69, y = 607.41, z = 195.00, h = 184.90},
}
local deliverys = {
    {x = -1331.65, y = -398.53, z = 36.44, h = 25.74},
    {x = 1039.19, y = 2676.16, z = 39.51, h = 355.74},
    {x = -1285.4302978516, y = 295.35775756836, z = 64.879379272461,h = 154.1148223877},
    {x = -936.92456054688, y = 126.06628417969, z = 56.784660339355,h = 67.598487854004},
    {x = 319.24127197266, y = -227.1540222168, z = 54.024654388428,h = 313.28182983398},
    {x = 51.763633728027, y = -1317.3239746094, z = 29.290327072144,h = 316.76803588867},
    {x = 86.656997680664, y = -1670.3356933594, z = 29.161266326904,h = 82.251388549805},
    {x = -730.36151123047, y = -675.18511962891, z = 30.268341064453,h = 40.325595855713},
    {x = -1182.7019042969, y = -871.49395751953, z = 13.95067024231,h = 64.767646789551},
    {x = -1382.78515625, y = -975.37542724609, z = 8.9228935241699,h = 309.23880004883},
    {x = -1748.2426757813, y = -414.99362182617, z = 43.793506622314,h = 238.29678344727},
    {x = -144.5599822998, y = 600.05328369141, z = 203.68330383301,h = 313.19995117188},
    {x = 918.39434814453, y = 51.274772644043, z = 80.898948669434,h = 132.78059387207},
    {x = 965.240234375, y = -659.12750244141, z = 57.46989440918,h = 308.46932983398}
}

local MailText = "Hey! <br><br> Ik moet met veel haast opgegaald worden op de locatie die is verzonden bij deze mail. <br><br> Omdat het haast heeft zal je beloond worden als je wat meer tempo zou willen maken!"
local DeliveryMail = "Hey! <br><br> Dit is de lokatie waar ik graag zou willen worden afgezet!"

generatePickup = function()
    while true do
        local index = math.random(1, #pickups)

        if index ~= Config.Vars['driver']['lastpickup'] then
            Config.Vars['driver']['lastpickup'] = index

            return index
        end
        Wait(0)
    end
end


generateDelivery = function()
    while true do
        local index = math.random(1, #deliverys)

        if index ~= Config.Vars['driver']['lastdelivery'] then
            Config.Vars['driver']['lastdelivery'] = index
            
            return index
        end
        Wait(0)
    end
end

RegisterNetEvent("StartJob")
AddEventHandler("StartJob", function(playerJob)
    if (playerJob == "driver") then
        if not Config.Vars['driver']['searching'] then
            Config.Vars['driver']['searching'] = true

            TriggerEvent("phone:notification", "./images/logos/race.png", "Zoeken naar taak..", "We zijn een taak voor je aan het zoeken, dit kan even duren.", 5000) 

            Citizen.Wait(math.random(10000, 25000))

            TriggerEvent("phone:notification", "./images/logos/race.png", "Taak gevonden!", "We hebben een taak voor je gevonden.", 5000) 

            local pickup = generatePickup()

            if pickup then
                TriggerEvent("phone:notification", "./images/logos/mail.png", "Ophaal lokatie", "Je hebt een mail binnen van een klant", 5000) 
                TriggerEvent("Zero:Client-Phone:AddMail", "Racing", "Ophaal lokatie van opdrachtgever.", MailText, pickups[pickup], "./images/logos/race.png")

                StartPickup(pickups[pickup].x, pickups[pickup].y, pickups[pickup].z, pickups[pickup].h)
            end
        end
    end
end)

function randomModel()
    local models = {
        'Elise_School',
        'g_m_m_korboss_01',
        'Lana',
        'Nanami_School_V',
        'Tifa'
    }
    return GetHashKey(models[math.random(1, #models)])
end

function deliverPed(ped)
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local delivery = generateDelivery()

    if delivery then
        TriggerEvent("phone:notification", "./images/logos/mail.png", "Nieuwe lokatie", "Je hebt een mail binnen van de huidige klant", 5000) 
        TriggerEvent("Zero:Client-Phone:AddMail", "Racing", "Lokatie opgegeven door de klant", DeliveryMail, deliverys[delivery], "./images/logos/race.png")

        startDelivery(ped, vehicle, deliverys[delivery].x, deliverys[delivery].y, deliverys[delivery].z)
    end
end

function startDelivery(npc, vehicle, x, y, z)
    while true do
        local ped = PlayerPedId()
        local coord = GetEntityCoords(ped)

        local distance = #(vector3(x, y, z) - coord)

       -- if not IsPedInAnyVehicle(npc) then Config.Vars['driver']['searching'] = false return end
        if IsEntityDead(npc) then Config.Vars['driver']['searching'] = false return end

        if (distance <= 5 and GetEntitySpeed(vehicle) <= 0) then
            TaskLeaveVehicle(npc, vehicle)
            SetPedAsNoLongerNeeded(npc)
            Config.Vars['driver']['searching'] = false
            TriggerServerEvent("Zero:Server-Public:PayOutDriver")
            return
        end

        Citizen.Wait(0)
    end
end

function StartPickup(x,y,z,h)
    while true do
        local player = PlayerPedId()
        local pos = GetEntityCoords(player)
        local distance = #(vector3(x,y,z) - pos)

        if (distance <= 30) then
            if not DoesEntityExist(pickupPed) then
                local model = randomModel() 

                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(0)
                end

                pickupPed = CreatePed(12, model, x, y, z - 1, h, true, true)
                FreezeEntityPosition(pickupPed, true)
                SetPedCanBeTargetted(pickupPed, false)

                SetBlockingOfNonTemporaryEvents(pickupPed, true)
                SetPedFleeAttributes(pickupPed, 0, 0)
                SetPedCombatAttributes(pickupPed, 17, 1)
                SetPedAlertness(pickupPed, 0)
                SetEntityInvincible(pickupPed, true)
            end

            if (distance <= 5) then
                if IsPedInAnyVehicle(player) then
                    local vehicle = GetVehiclePedIsIn(player)

                    if vehicle then
                        local speed = GetEntitySpeed(vehicle)

                        if speed <= 0 then
                            FreezeEntityPosition(pickupPed, false)
                            Citizen.Wait(2000)
                            TaskWarpPedIntoVehicle(pickupPed, vehicle, 0)

                            deliverPed(pickupPed)
                            return
                        end
                    end
                end
            end
        end

        Citizen.Wait(0)
    end
end