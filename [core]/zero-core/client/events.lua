AddEventHandler("playerSpawned", function()
    Wait(2000)
    playerSpawned = true
end)

RegisterNetEvent("Zero:Client-Core:NetworkStarted")
AddEventHandler("Zero:Client-Core:NetworkStarted", function(characters)
    local x,y,z,h = Zero.Config.Spawn.selection.x, Zero.Config.Spawn.selection.y, Zero.Config.Spawn.selection.z, Zero.Config.Spawn.selection.h

    DoScreenFadeOut(0)

    while not playerSpawned do Wait(0) end

    local _ply = PlayerPedId()

    SetEntityCoords(_ply, x,y,z-1)
    SetEntityHeading(_ply, h)

    DisplayRadar(false)
    FreezeEntityPosition(_ply, true)

    local camCoords = Zero.Config.Spawn.camcoord
    creation_cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords.x - 0.2, camCoords.y - 1.2, camCoords.z + 0.45, 0.00, 0.00, 179.3, 70.00, false, 0)
    SetCamActiveWithInterp(creation_cam, second_cam, 500, true, true)
    RenderScriptCams(true, false, 1, true, true)
    --PointCamAtEntity(creation_cam, _ply)
    
    local Pointing = Zero.Config.Spawn.pointCoord
    PointCamAtCoord(creation_cam, Pointing.x, Pointing.y, Pointing.z)

    SetNuiFocus(true, true)
    DoScreenFadeIn(150)

    Zero.Functions.HidePlayers(true) -- dood

    TriggerEvent("Zero:Client-Character:Start", characters, function()
        DoScreenFadeOut(150)
        while not IsScreenFadedOut() do Wait(0) end
        DestroyAllCams(true)
        RenderScriptCams(false, false, 1, false, false)
        SetEntityCoords(PlayerPedId(), 0, 0, 0)
        DoScreenFadeIn(150)
        
        FreezeEntityPosition(PlayerPedId(), false)

        Zero.Functions.HidePlayers(false)
    end)
end)

RegisterNetEvent("Zero:Client-Core:PlayerLoaded")
AddEventHandler("Zero:Client-Core:PlayerLoaded", function(data)
    Zero.Player.MetaData = data.MetaData
    Zero.Player.PlayerData = data.PlayerData
    Zero.Player.Money = data.Money
    Zero.Player.Job = data.Job
    Zero.Player.Skin = data.Skin
    Zero.Player.Vehicles = data.Vehicles
    Zero.Player.User = data.User
    Zero.Player.Crew = data.Crew
    

    Zero.Vars.Loaded = true
    Zero.Vars.Spawned = false

    SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)

	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)

	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_HILLBILLY`, GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
	SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))
end)

RegisterNetEvent("Zero:Client-Core:UpdateStats")
AddEventHandler("Zero:Client-Core:UpdateStats", function(data)
    Zero.Player.MetaData = data.MetaData
    Zero.Player.PlayerData = data.PlayerData
    Zero.Player.Money = data.Money
    Zero.Player.Job = data.Job
    Zero.Player.Skin = data.Skin
    Zero.Player.Vehicles = data.Vehicles
    Zero.Player.Crew = data.Crew
end)

RegisterNetEvent("Zero:Client-Core:SpawnVehicle")
AddEventHandler("Zero:Client-Core:SpawnVehicle", function(model)
    local ply = PlayerPedId()
    local model = model

    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    local h = GetEntityHeading(PlayerPedId())

    if IsModelValid(model) then
        Zero.Functions.SpawnVehicle({
            model = model,
            location = {x = x, y = y, z = z, h},
            teleport = true,
            network = true,
        }, function(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerEvent("vehiclekeys:client:SetOwner", plate)
        end)
    end
end)

RegisterNetEvent("Zero:Client-Core:DeleteVehicle")
AddEventHandler("Zero:Client-Core:DeleteVehicle", function()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped) then
        DeleteEntity(GetVehiclePedIsIn(ped))
    end
end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

RegisterNetEvent('Zero:Client:TriggerCallback')
AddEventHandler('Zero:Client:TriggerCallback', function(name, ...)
	if Zero.ServerCallbacks[name] ~= nil then
		Zero.ServerCallbacks[name](...)
		Zero.ServerCallbacks[name] = nil
	end
end)
