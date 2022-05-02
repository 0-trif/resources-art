local deadAnimDict = "dead"
local deadAnim = "dead_d"
local deadCarAnimDict = "veh@low@front_ps@idle_duck"
local deadCarAnim = "sit"
local hold = 5

function random_dead_animation()
    local animations = {
        "dead_a",
        "dead_b",
        "dead_c",
        "dead_d",
    }
    local randomIndex = math.random(1, #animations)

    deadAnim = animations[randomIndex]
end

function start_status_dead()
    local player = PlayerPedId()
    TriggerServerEvent("Zero:Server-Status:SetDeathStatus", true)

    while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
        Citizen.Wait(10)
    end

    random_dead_animation()

    isInHospitalBed = false
    isDead = true

    local pos = GetEntityCoords(player)
    local heading = GetEntityHeading(player)

    dead_timer = 5

    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
    SetEntityInvincible(player, true)
    SetEntityHealth(player, GetEntityMaxHealth(GetPlayerPed(-1)))
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        loadAnimDict("veh@low@front_ps@idle_duck")
        TaskPlayAnim(player, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    else
        loadAnimDict(deadAnimDict)
        TaskPlayAnim(player, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    end
    start_AI_call()
end

function start_AI_call()
    local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local closestPed, closestDistance = Zero.Functions.GetClosestNPC(coords, PlayerPeds)
    local gender = Zero.Functions.GetPlayerData().PlayerData['gender']
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    if closestDistance < 50.0 and closestPed ~= 0 then
        MakeCall(closestPed, gender, street1, street2)
    end
end


function MakeCall(ped, male, street1, street2)
    local callAnimDict = "cellphone@"
    local callAnim = "cellphone_call_listen_base"
    local rand = (math.random(6,9) / 100) + 0.3
    local rand2 = (math.random(6,9) / 100) + 0.3
    local coords = GetEntityCoords(GetPlayerPed(-1))

    if math.random(10) > 5 then
        rand = 0.0 - rand
    end

    if math.random(10) > 5 then
        rand2 = 0.0 - rand2
    end

    local moveto = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), rand, rand2, 0.0)

    TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
    SetPedKeepTask(ped, true) 

    local dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)

    while dist > 3.5 and isDead do
        TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
        dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)
        Citizen.Wait(100)
    end

    ClearPedTasksImmediately(ped)
    TaskLookAtEntity(ped, GetPlayerPed(-1), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, GetPlayerPed(-1), 5500)

    Citizen.Wait(3000)

    --TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_MOBILE", 0, 1)
    loadAnimDict(callAnimDict)
    TaskPlayAnim(ped, callAnimDict, callAnim, 1.0, 1.0, -1, 49, 0, 0, 0, 0)

    SetPedKeepTask(ped, true) 

    Citizen.Wait(5000)

    local location = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("Zero:Server-Phone:SendSOSMessage", {
        ['job'] = "ambulance",
        ['title'] = "Melding door getuige",
        ['message'] = "Burger aangetroffen op straat, "..street1.." "..street2..""
    }, location)

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)
end

Citizen.CreateThread(function()
    while true do
        if (isDead) then
            local ply = PlayerPedId()


            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
			EnableControlAction(0, Zero.Config.Keys['T'], true)
            EnableControlAction(0, Zero.Config.Keys['E'], true)
            EnableControlAction(0, Zero.Config.Keys['V'], true)
            EnableControlAction(0, Zero.Config.Keys['ESC'], true)
            EnableControlAction(0, Zero.Config.Keys['F1'], true)
            EnableControlAction(0, Zero.Config.Keys['HOME'], true)

            if IsPedInAnyVehicle(ply, false) then
                loadAnimDict("veh@low@front_ps@idle_duck")
                if not IsEntityPlayingAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 3) then
                    TaskPlayAnim(ply, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                end
            else
                if isInHospitalBed then 
                    if not IsEntityPlayingAnim(ply, inBedDict, inBedAnim, 3) then
                        loadAnimDict(inBedDict)
                        TaskPlayAnim(ply, inBedDict, inBedAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                    end
                else
                    local carry = exports['carry']:beingCarried()
                    if not carry then
                        if CanBeRevived() then
                            if not IsEntityPlayingAnim(ply, "random@dealgonewrong", "idle_a", 3) then
                                loadAnimDict("random@dealgonewrong")
                                TaskPlayAnim(PlayerPedId(), "random@dealgonewrong", "idle_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                            end
                        else
                            if not IsEntityPlayingAnim(ply, deadAnimDict, deadAnim, 3) then
                                loadAnimDict(deadAnimDict)
                                TaskPlayAnim(PlayerPedId(), deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                            end
                        end
                    end
                end
            end

            if (dead_timer > 0) then
                DrawTxt(0.93, 1.44, 1.0,1.0,0.6, "RESPAWN IN ~g~" .. math.ceil(dead_timer) .. "~w~ MINUTEN", 255, 255, 255, 255)
            else
                DrawTxt(0.93, 1.44, 1.0,1.0,0.6, "[~g~E~w~] INGEDRUKT HOUDEN OM TE RESPAWNEN", 255, 255, 255, 255)

                if IsControlPressed(0, Zero.Config.Keys['E']) then
                    Citizen.Wait(1000)
                    if IsControlPressed(0, Zero.Config.Keys['E']) then
                        TriggerEvent("Zero:Client-Status:RespawnAtHospital")
                        TriggerServerEvent('Zero:Server-Status:Respawned')
                    end
                end
            end

            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if isDead then
            Citizen.Wait(60000)
            dead_timer = dead_timer - 1 >= 0 and dead_timer - 1 or 0
        else
            Citizen.Wait(250)
        end
        Citizen.Wait(0)
    end
end)

function revivePlayer(bool)
    local player = PlayerPedId()

    if not bool then
        local playerPos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        isDead = false
        SetEntityInvincible(GetPlayerPed(-1), false)

        TriggerServerEvent("Zero:Server-Status:SetDeathStatus", false)
        healStatus()
        Zero.Functions.Notification("Hulp", "Je bent weer helemaal genezen")
        ResetLimbs()
    else
        Zero.Functions.Notification("Hulp", "Je wonden zijn verholpen")
        healStatus()
        ResetLimbs()
    end
end

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end