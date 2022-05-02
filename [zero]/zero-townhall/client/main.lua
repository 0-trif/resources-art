local townhall = {x = -549.12170410156, y = -197.10963439941, z = 38.219703674316, h = 214.27188110352}

Citizen.CreateThread(function()
    local coord = townhall
    blip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(blip, 351)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 11)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Gemeentehuis")
    
    EndTextCommandSetBlipName(blip)

    while true do
        local timer = 750

        local ply = PlayerPedId()
        local coord = GetEntityCoords(ply)
        local distance = #(coord - vector3(townhall.x, townhall.y, townhall.z))


        if distance <= 5 then
            timer = 0
            Zero.Functions.DrawText(coord.x, coord.y, coord.z, "[~g~X~w~]")
        end

        Citizen.Wait(timer)
    end
end)


function openTownHall()
    Zero.Functions.GetPlayerData(function(PlayerData)
        local mug, string = reset_and_receive_img(GetPlayerPed(-1), true)
     
        last_job = PlayerData.Job.name
        SendNUIMessage({
            action = "open",
            PlayerData = PlayerData.PlayerData,
            Job = PlayerData.Job,
            MetaData = PlayerData.MetaData,
            Jobs = Zero.Config.Jobs,
            Mugshot = string,
        })
        SetNuiFocus(true, true)
    end)
end

function reset_and_receive_img(ped, transparent)
    for i = 1, 32 do
        UnregisterPedheadshot(i)
    end

    Citizen.Wait(300)

    if DoesEntityExist(ped) then
        local mugshot

        if transparent then
            mugshot = RegisterPedheadshotTransparent(ped)
        else
            mugshot = RegisterPedheadshot(ped)
        end

        while not IsPedheadshotReady(mugshot) do
            Citizen.Wait(0)
        end

        return mugshot, GetPedheadshotTxdString(mugshot)
    else
        return
    end
end

function jobChanged(job)
    local label = Zero.Config.Jobs[job]['label']
    
    if job == "unemployed" then
        local txt = "U trekt vanaf nu weer uitkering dankzij de belastingcenten van hardwerkende burgers. Gefeliciteerd!"
        TriggerEvent("phone:notification", "https://pbs.twimg.com/profile_images/449945091227287552/tdw7fdD5.jpeg", "Gemeentehuis", txt, 5000) 
    else
        TriggerEvent("phone:notification", "https://pbs.twimg.com/profile_images/449945091227287552/tdw7fdD5.jpeg", "Gemeentehuis", "U bent aangenomen voor de vacature van "..label.."!", 5000) 
    end
end

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("job-townhall", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - vector3(townhall.x, townhall.y, townhall.z))

        if (distance <= 5) then
            return true, vector3(townhall.x, townhall.y, townhall.z)
        end
    end, {
       [1] = {
           name = "Open gemeentehuis",
           action = function()
                TriggerEvent("disableEye")
                openTownHall()
           end
       }
    }, GetCurrentResourceName(), 5)
end)

-- UI
RegisterNUICallback("close", function()
    SetNuiFocus(false, false)

    if last_job then
        Zero.Functions.GetPlayerData(function(PlayerData)
            if PlayerData.Job.name ~= last_job then
                jobChanged(PlayerData.Job.name)
            end
        end)
    end
end)
RegisterNUICallback("newJob", function(ui)
    local job = ui.job

    if job and not Zero.Config.Jobs[job].whitelisted then
        TriggerServerEvent("Zero:Server-Townhall:ChooseJob", job)

        Citizen.Wait(150)

        Zero.Functions.GetPlayerData(function(PlayerData)
            SendNUIMessage({
                action = "open",
                PlayerData = PlayerData.PlayerData,
                Job = PlayerData.Job,
                MetaData = PlayerData.MetaData,
                Jobs = Zero.Config.Jobs,
            })
        end)
    else
        Zero.Functions.Notificiations("Gemeente", "Deze baan bestaat niet")
    end
end)
RegisterNUICallback("requestCard", function(ui)
    TriggerServerEvent("Zero:Server-Townhall:Card", ui.card)
end)
