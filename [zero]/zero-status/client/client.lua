exports['zero-core']:object(function(O) Zero = O end)

isDead = false

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do 
        Wait(0)
    end

    exports.spawnmanager:setAutoSpawn(false)
end)

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

Citizen.CreateThread(function()
    while true do
        local ply = PlayerPedId()
        local _dead = (IsEntityDead(ply))


        if NetworkIsPlayerActive(PlayerId()) then
            if _dead and not isDead then
                start_status_dead()
                TriggerEvent("hud:set", "health", 0)
            end
        end
        Wait(1000)
    end
end)

RegisterNetEvent("Zero:Client-Status:Revive")
AddEventHandler("Zero:Client-Status:Revive", function(bool)
    revivePlayer(bool)
end)

RegisterNetEvent("Zero:Client-Status:Kill")
AddEventHandler("Zero:Client-Status:Kill", function()
    _dead = true
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent("Zero:Client-Status:RespawnAtHospital")
AddEventHandler("Zero:Client-Status:RespawnAtHospital", function()
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player, true)

    DoScreenFadeOut(150)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    NetworkResurrectLocalPlayer(playerPos, true, true, false)
    SetEntityInvincible(GetPlayerPed(-1), false)

    SetEntityCoords(PlayerPedId(), 298.26, -584.17, 43.26)
    isDead = false
    _dead = false

    healStatus()
    ResetLimbs()

    Wait(2000)

    DoScreenFadeIn(150)
    TriggerServerEvent("Zero:Server-Status:SetDeathStatus", false)
end)