
local packets = 0
local packets_delivered = 0
local packets_loaded = 0
local has_location = false

local MailTextPickup = "Hey! <br><br> Je moet eerst langs deze lokatie gaan om de pakketjes op te halen. <br><br> Wanneer je de pakketjes hebt opgehaald zullen wij lokatie's door sturen naar je om de pakketjes af te leveren."
local MailTextDelivery = "Hey! <br><br> Het volgende pakketje moet afgeleverd worden op de volgende lokatie. <br><br> Wanneer je dit pakketje hebt afgeleverd zullen wij meer lokatie's doorsturen om langs te gaan."

local pickupCoord = {x = 718.23699951172, y = -767.60266113281, z = 24.859252929688,h = 87.490211486816}

local delivery_locations = {
    {x = 89.764007568359, y = -1745.0534667969, z = 30.087080001831,h = 314.23709106445},
    {x = -199.99067687988, y = -1379.5400390625, z = 31.258234024048,h = 0.0},
    {x = -762.97131347656, y = -618.02783203125, z = 30.471206665039,h = 268.68264770508},
    {x = 325.04544067383, y = -229.5072479248, z = 54.221172332764,h = 119.45624542236},
    {x = 394.10894775391, y = -700.78564453125, z = 29.28182220459,h = 269.42407226563},
    {x = 488.73400878906, y = -1499.7818603516, z = 29.238525390625,h = 189.60124206543},
    {x = 464.22622680664, y = -1851.5263671875, z = 27.808546066284,h = 3.9817500114441},
    {x = 140.72631835938, y = -1983.0941162109, z = 18.3212890625,h = 230.49252319336},
    {x = 131.19802856445, y = -1771.8325195313, z = 29.696418762207,h = 319.59460449219},
    {x = -295.89794921875, y = -1295.8198242188, z = 31.260927200317,h = 274.13830566406},
    {x = -144.41767883301, y = 593.45092773438, z = 203.87445068359,h = 173.39970397949},
    {x = -721.69201660156, y = 490.38696289063, z = 109.62218475342,h = 230.1456451416},
    {x = -1026.0982666016, y = 360.46090698242, z = 71.361427307129,h = 249.37455749512},
    {x = -1515.4235839844, y = 24.89984703064, z = 56.820667266846,h = 343.11569213867},
    {x = -1279.1544189453, y = -876.74877929688, z = 11.93030166626,h = 121.75595855713},
    {x = -822.66510009766, y = -1223.3475341797, z = 7.3602561950684,h = 223.01287841797},
    {x = -99.491813659668, y = -1782.66796875, z = 29.181749343872,h = 138.88598632813},
    {x = 278.78359985352, y = -1117.9544677734, z = 29.419664382935,h = 357.18954467773},
    {x = 871.68011474609, y = -1016.4755859375, z = 31.863794326782,h = 0.72016876935959},
    {x = -698.90222167969, y = 47.420402526855, z = 44.033588409424,h = 34.144454956055}
}

function initLoadPackets()
    TriggerEvent("phone:notification", "./images/logos/post.png", "Ophaal lokatie", "Lokatie om pakketjes op te halen staat in je inbox (mail).", 5000) 
    TriggerEvent("Zero:Client-Phone:AddMail", "A-Post", "Ophaal lokatie pakketjes.", MailTextPickup, pickupCoord, "./images/logos/post.png")
end

function initPostal()
    if (packets_loaded == 0) then
        initLoadPackets()
    end
end

RegisterNetEvent("StartJob")
AddEventHandler("StartJob", function(playerJob)
    if (playerJob == "delivery") then
        initPostal()
    end
end)

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("grab-packet-postnl", function(coords, entity)
        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)

        if GlobalJob and GlobalJob == "delivery" then
            local distance = #(position - vector3(pickupCoord.x, pickupCoord.y, pickupCoord.z))

            if (distance <= 1.3) then
                return true, vector3(pickupCoord.x, pickupCoord.y, pickupCoord.z)
            end
        end
    end, {
        [1] = {
            name = "Pakketje pakken", 
            action = function(entity) 
                GrabPacket()
            end,
        },
    }, GetCurrentResourceName(), 10)
end)


Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("postnl-load", function(coords, entity)
        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)

        if (entity and IsEntityAVehicle(entity) and HoldingObject) then
            if (GetEntityModel(entity) == GetHashKey('postnlsprinter')) then
                return true, GetEntityCoords(entity)
            end
        end
    end, {
        [1] = {
            name = "Pakketje inladen", 
            action = function(entity) 
                LoadPacket()
            end,
        },
        [2] = {
            name = "Pakketje pakken (bus)", 
            action = function(entity) 
                GrabPacketVan()
            end,
        },
    }, GetCurrentResourceName(), 10)

    exports['zero-eye']:looped_runtime("postnl-grab", function(coords, entity)
        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)

        if (entity and IsEntityAVehicle(entity) and not HoldingObject) then
            if (GetEntityModel(entity) == GetHashKey('postnlsprinter')) then
                return true, GetEntityCoords(entity)
            end
        end
    end, {
        [1] = {
            name = "Pakketje pakken (bus)", 
            action = function(entity) 
                GrabPacketVan()
            end,
        },
    }, GetCurrentResourceName(), 10)
end)

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("postnl-delivery", function(coords, entity)
        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)

        if new_delivery_coord then
            local distance = #(vector3(new_delivery_coord.x, new_delivery_coord.y, new_delivery_coord.z) - position)

            if distance <= 5 then
                return true, vector3(new_delivery_coord.x, new_delivery_coord.y, new_delivery_coord.z)
            end
        end
    end, {
        [1] = {
            name = "Pakketje afleveren", 
            action = function(entity) 
                DeliverPacket()
            end,
        },
    }, GetCurrentResourceName(), 10)
end)

function randomObject()
    local objects = {
        "prop_cs_cardbox_01",
        "prop_cs_box_clothes",
        "prop_cardbordbox_03a",
        "v_ret_ml_beerpat1"
    }

    local randomId = math.random(1, #objects)

    return objects[randomId]
end

function GrabPacket()
    if HoldingObject then
        Zero.Functions.Notification("Baan", "Je hebt al een pakketje vast", "error")
        return
    end
    if packets_loaded < 5 then
        TaskPlayAnim((GetPlayerPed(-1)), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
        prop = CreateObject(GetHashKey(randomObject()),  true,  true, true)
        AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309), 0.025, 0.11, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
        HoldingObject = true
        TriggerEvent("disableEye")
    else
        Zero.Functions.Notification("Baan", "Je hebt al het maximum pakketjes in de bus", "error")
    end
end

function LoadPacket()
    DeleteObject(prop)
    HoldingObject = false
    ClearPedTasks(PlayerPedId())
    TriggerEvent("disableEye")
    packets_loaded = packets_loaded + 1
end

function GenerateRandomLocation()
    while true do
        local random = math.random(1, #delivery_locations)

        if (random ~= last_delivery) then
            last_delivery = random
            return delivery_locations[random]
        end

        Wait(0)
    end
end

function GrabPacketVan()
    if not new_delivery_coord then
        Zero.Functions.Notification("Baan", "Je hebt nog geen pakketjes ingeladen", "error")
        return
    end
    if not HoldingObject  then
        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)
        local distance = #(vector3(new_delivery_coord.x, new_delivery_coord.y, new_delivery_coord.z) - position)

        if distance <= 10 then
            TaskPlayAnim((GetPlayerPed(-1)), "anim@gangops@facility@servers@", "hotwire", 8.0, 1.0, 3000, 16, 0, 0, 0, 0)
            Zero.Functions.Progressbar("use_bank", "Pakketje pakken..", 3000, false, true, {}, {}, {}, {}, function() -- Done
                ClearPedTasksImmediately(ped)
                TaskPlayAnim((GetPlayerPed(-1)), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                prop = CreateObject(GetHashKey(randomObject()),  true,  true, true)
                AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309), 0.025, 0.11, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
                HoldingObject = true
                packets_loaded = packets_loaded - 1
            end, function() -- Cancel
                ClearPedTasksImmediately(ped)
            end)
        end
    else
        Zero.Functions.Notification("Baan", "Je hebt al een pakketje vast", "error")
    end
end

function DeliverPacket()
    if (HoldingObject) then    
        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)

        if new_delivery_coord then
            local distance = #(vector3(new_delivery_coord.x, new_delivery_coord.y, new_delivery_coord.z) - position)

            if distance <= 1.5 then
                DeleteObject(prop)
                ClearPedTasks(PlayerPedId())
        
                new_delivery_coord = nil
                HoldingObject = false
                TriggerEvent("disableEye")
                TriggerServerEvent("Zero:Server-Public:Delivery")

                Zero.Functions.Notification("Baan", "Je hebt nog "..packets_loaded.." pakketjes om te bezorgen", "success")
                Citizen.Wait(10000)
                has_location = false
            else
                Zero.Functions.Notification("Baan", "Je moet dichterbij het aflever punt gaan staan", "error")
            end
        end
    else
        Zero.Functions.Notification("Baan", "Je moet eerst een pakketje uit de bus pakken", "error")
    end
end

function setupNewDelivery()
    new_delivery_coord = GenerateRandomLocation()
    TriggerEvent("phone:notification", "./images/logos/post.png", "Aflever lokatie", "Lokatie om pakketje af te leveren staat in je inbox!", 5000) 
    TriggerEvent("Zero:Client-Phone:AddMail", "A-Post", "Aflever lokatie pakketje.", MailTextDelivery, new_delivery_coord, "./images/logos/post.png")
end



Citizen.CreateThread(function()
    while true do
        if HoldingObject then
            while not HasAnimDictLoaded('anim@heists@box_carry@') do
                Citizen.Wait(30)
                RequestAnimDict("anim@heists@box_carry@")
            end
            while not HasAnimDictLoaded('anim@gangops@facility@servers@') do
                Citizen.Wait(30)
                RequestAnimDict("anim@gangops@facility@servers@")
            end

            if IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) ~= 1 then
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
            end
        else
            if GlobalJob and GlobalJob == "delivery" then
                if packets_loaded > 0 and not has_location and IsPedInAnyVehicle(PlayerPedId()) then
                    setupNewDelivery()
                    has_location = true
                end

                if (new_delivery_coord) then
                    Zero.Functions.DrawMarker(new_delivery_coord.x, new_delivery_coord.y, new_delivery_coord.z)
                end
            else
                Citizen.Wait(750)
            end
        end

        Citizen.Wait(0)
    end
end)

-- creating this bitch of a monkey

Citizen.CreateThread(function()
    exports['vehicleHire']:createHirePoint(67.966384887695, 103.51192474365, 79.050170898438, 144.99468994141, {
        [1] = {
            label = "Postbus (nodig)",
            model = 'postnlsprinter',
            price = 150,
            loc = {x = 83.483062744141, y = 95.457946777344, z = 78.687553405762,h = 70.119003295898},
        },
    })
end)