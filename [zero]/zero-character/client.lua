exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Character:Start")
AddEventHandler("Zero:Client-Character:Start", function(characters, selection_done)
    done   = selection_done

    characters = characters ~= nil and characters or {}

    SetFocusEntity(PlayerPedId())
    -- Citizen.InvokeNative(0xBA3D65906822BED5, 100.00, 2.0, 0.0, 0.0, 0.0, 5.0)
 
    SetNuiFocus(true, true)
 
    skindataset = characters
    for i = 1, 5 do
        if characters[i] then
            skinSkin(i)
            break
        end
    end

    TriggerEvent("zero:loading:stop")

    Wait(9500)

    SendNUIMessage({
        action = "chars",
        characters = characters,
    })
end)

RegisterNetEvent("Zero:Client-Character:Update")
AddEventHandler("Zero:Client-Character:Update", function(characters)
    characters = characters ~= nil and characters or {}

    SendNUIMessage({
        action = "up-chars",
        characters = characters,
    })

    SetNuiFocus(true, true)
end)

RegisterNetEvent("Zero:Client-Character:CloseUI")
AddEventHandler("Zero:Client-Character:CloseUI", function()
    SendNUIMessage({
        action = "off",
    })
    SetNuiFocus(false, false)
    done()
    spawnselector()
   -- Citizen.InvokeNative(0xBA3D65906822BED5, 0.1, 0.1, 0.0, 0.0, 0.0, 300.0)
end)

RegisterNUICallback("create", function(data)
    TriggerServerEvent("Zero:Server-Character:Create", data)
end)

RegisterNUICallback("logout", function(data)
    TriggerServerEvent("Zero:Server-Character:Logout", data)
end)

RegisterNUICallback("play", function(e)
    local slot = e.slot
    TriggerServerEvent("Zero:Server-Character:Play", slot)
end)

RegisterNUICallback("setSkin", function(e)
    skinSkin(e.slot)
end)

-- spawn selection
function doCamera(x,y,z)
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0
	while i > 1 do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(2/i)
	end
end

local camZPlus1 = 1500
local camZPlus2 = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 500
local cam2Time = 1000

locations = {
    [1] = {x = 0.17, y = -933.77, z = 29.7},
    [2] = {x = 428.23, y = -984.28, z = 29.76},
    [3] = {x = 195.17, y = -933.77, z = 29.7},
    [4] = {x = 1840.08, y = 3673.53, z = 34.27},
    [5] = {x = 80.35, y = 6424.12, z = 31.67},
}

spawnselector = function()
    new_player = false

    Zero.Functions.GetPlayerData(function(PlayerData)
        last_spawn_location = PlayerData.MetaData.Location
        last_spawn_location = last_spawn_location ~= nil and last_spawn_location or Zero.Config.DefaultSpawn
        locations[1] = last_spawn_location

        if not (PlayerData.Skin) then
            new_player = true
        end
        if (PlayerData.MetaData.appartment) then
            no_appartment = false
        else
            no_appartment = true
        end
    end)

    SetEntityVisible(GetPlayerPed(-1), false)
    DoScreenFadeOut(250)
    Citizen.Wait(1000)
    DoScreenFadeIn(250)

    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z + camZPlus1, -85.00, 0.00, 0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)

    Citizen.Wait(500)

    if no_appartment then
        SendNUIMessage({
            action = "appartment"
        })
        SetNuiFocus(true, true)
    else
        SendNUIMessage({
            action = "spawn"
        })
        SetNuiFocus(true, true)
    end
end

function CreateNewCam(x,y,z, target)
    local new_camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    local xt,yt,zt = table.unpack(target)
    PointCamAtCoord(new_camera, xt, yt, zt)
    SetCamCoord(new_camera, x,y,z)

    return new_camera
end


RegisterNUICallback("setAppartmentCam", function(e)
    local index = e.index


    exports['zero-appartments']:locations(function(appartment_locations)
        local location = appartment_locations[index]['location']
        local transitions = appartment_locations[index]['transition']


        DoScreenFadeOut(200)
    
        if DoesCamExist(cam) then
            DestroyCam(cam, true)
        end
        if DoesCamExist(camera_target) then
            DestroyCam(camera_target, true)
        end
        if DoesCamExist(camera_transition) then
            DestroyCam(camera_transition, true)
        end

        SetEntityCoords(PlayerPedId(), location.x, location.y, location.z)
        
        camera_transition = CreateNewCam(transitions[1].x, transitions[1].y, transitions[1].z, location)
        SetCamActive(camera_transition, true)
        RenderScriptCams(true, true, 5000, true, true)

        PointCamAtCoord(camera_transition, location.x, location.y, location.z)

        Citizen.Wait(500)
        DoScreenFadeIn(200)
        
        camera_target = CreateNewCam(transitions[2].x, transitions[2].y, transitions[2].z, location)
        SetCamActiveWithInterp(camera_target, camera_transition, 4000, vector3(transitions[2].x, transitions[2].y, transitions[2].z), 0)
        PointCamAtCoord(camera_target, location.x, location.y, location.z)
    end)
end)

RegisterNUICallback("chooseAppartment", function(e)
    local index = e.index

    TriggerServerEvent('Zero:Server-Character:ChooseAppartment', index)

    Citizen.Wait(2000)

    local PlayerData = Zero.Functions.GetPlayerData()
    
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    TriggerEvent("Zero-appartments:client:enter", PlayerData.MetaData.appartment, x, y, z - 30.0)
    SetEntityVisible(PlayerPedId(), true)
    DeleteCamera()	
    TriggerEvent("Zero:Client-Core:Spawned")

    Wait(2000)

    if (new_player) then
        TriggerEvent("Zero:Client-ClothingV2:Open")
        Citizen.Wait(3000)
        TriggerServerEvent("Zero:Server-Core:NewStarter")
    end

    --[[
        SendNUIMessage({
            action = "spawn"
        })
        SetNuiFocus(true, true)
    ]]
end)

RegisterNUICallback("setCam", function(e)
    local campos = locations[tonumber(e.index)]

    DoScreenFadeOut(200)
    Citizen.Wait(500)
    DoScreenFadeIn(200)

    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end

    if DoesCamExist(cam2) then
        DestroyCam(cam2, true)
    end

    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
end)


RegisterNUICallback("chooseLoc", function(e)
    local index = tonumber(e.index)
    local campos = locations[index]
    SetEntityVisible(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), campos.x, campos.y, campos.z)
    
    if (campos.h) then
        SetEntityHeading(PlayerPedId(), campos.h)
    end

    doCamera(campos.x, campos.y, campos.z)
	DeleteCamera()	

    TriggerEvent("Zero:Client-Core:Spawned")
end)

DeleteCamera = function()
    ClearFocus()
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1, true, true)
    SetNuiFocus(false, false)
end

skinSkin = function(index)
    local index = tonumber(index)
    local ped = exports['zero-clothing_new']:ped()

    RequestModel(GetHashKey("mp_m_freemode_01"))
    RequestModel(GetHashKey("mp_f_freemode_01"))

    if (index and skindataset[index]) then
        local skin = skindataset[index].skin
        if (skin) then
            ped:model(skin.model)
            ped:LoadVariation(skin.skindata)
        else
            ped:model("mp_m_freemode_01")
        end
    else
        ped:model("mp_m_freemode_01")
    end
end