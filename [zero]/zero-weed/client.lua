Cache = {}
Cache.Plants = {}
Cache.Entity = {}

exports['zero-core']:object(function(O) Zero = O end)

local CreatePlant = function()
    local model = Config.Model
    local coord = GenerateWeedCoords()
    local x,y,z = 0 , 0 , 0

    _ = CreateObject(model, coord.x, coord.y, coord.z, false, false, false)
    FreezeEntityPosition(_, true)
    PlaceObjectOnGroundProperly(_)
    SetEntityAsMissionEntity(_, true, true)
    
    return _
end

local render_some_weedjes = function()
    local area = Config.Location

    if (#Cache.Plants < Config.MaxEntitys) then
        Cache.Plants[#Cache.Plants+1] = CreatePlant() 
    end
end

function ValidateWeedCoord(plantCoord)
	if #Cache.Plants > 0 then
		local validate = true

		for k, v in pairs(Cache.Plants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end

		if #(plantCoord - Config.Location) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		weedCoordX = Config.Location.x + modX
		weedCoordY = Config.Location.y + modY

		local coordZ = GetCoordZ(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 30.0, 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }
    
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end

local function render_area(position)
    for k,v in pairs(Cache.Plants) do
        local loc = GetEntityCoords(v)
        local distance = #(loc - position)

        if (distance <= 3) then
            clostest_plant = k
            TriggerEvent("Zero:Client-Inventory:DisplayUsable", "scissors")
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local player = PlayerPedId()
        local position = GetEntityCoords(player)
        local distance = #(Config.Location - position)

        if (distance <= 100) then
            timer = 0

            render_some_weedjes()
            render_area(position)
        end

        Citizen.Wait(timer)
    end
end)

RegisterNetEvent("Zero:Client-Weed:UsedSchissor")
AddEventHandler("Zero:Client-Weed:UsedSchissor", function()
    if clostest_plant then
        local position = GetEntityCoords(PlayerPedId())
        local loc = GetEntityCoords(Cache.Plants[clostest_plant])
        local distance = #(loc - position)

        if (distance <= 3) then
            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
            
            Zero.Functions.Progressbar("repair_veh", "Blaadjes knippen..", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
    
            }, {}, {}, function() -- Done
                ClearPedTasksImmediately(PlayerPedId(), true)
                ExecuteCommand('e c')

                DeleteEntity(Cache.Plants[clostest_plant])
                table.remove(Cache.Plants, clostest_plant)
                
                TriggerServerEvent('Zero:Location', distance)
                TriggerServerEvent("Zero:Server-Weed:Farmed")
            end, function() -- Cancel
                ClearPedTasksImmediately(PlayerPedId(), true)
            end)
        end
    end
end)

function createLingLing(x,y,z,h,model)
    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(0)
    end

    local ped = CreatePed(12, model, x, y, z - 1, h, false, false)
    FreezeEntityPosition(ped, true)
    SetPedCanBeTargetted(ped, false)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    SetPedAlertness(ped, 0)
    SetEntityInvincible(ped, true)

    return ped
end

function TalkingToLingLing()
    TriggerServerEvent("Zero:Server-Weed:LingLing")
end

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        local timer = 750
        local coord  = GetEntityCoords(player)
        local ling_ling_listance = #(coord - vector3(Config.LingLing.x, Config.LingLing.y, Config.LingLing.z))

        if (ling_ling_listance <= 30) then
            timer = 0
            if DoesEntityExist(Config.LingLing.Ped) then
                if ling_ling_listance <= 3 then
                    TriggerEvent("interaction:show", "E - Praat met LingLing", function()
                        TalkingToLingLing()
                    end)
                end
            else
                Config.LingLing.Ped = createLingLing(Config.LingLing.x, Config.LingLing.y, Config.LingLing.z, Config.LingLing.h, Config.LingLing.model)
            end
            if not DoesEntityExist(Config.LingLing.Daggoe) then
                Config.LingLing.Daggoe = createLingLing(Config.Daggoe.x + 1, Config.Daggoe.y, Config.Daggoe.z, Config.Daggoe.h, Config.Daggoe.model)
            end
        end

        Citizen.Wait(timer)
    end
end)

RegisterNetEvent("Zero:Server-Weed:CreatePickup")
AddEventHandler("Zero:Server-Weed:CreatePickup", function(x,y,z,h)
    createPickupLocation(x,y,z,h)
end)

createPickupLocation = function(x,y,z,h)
    Zero.Functions.SpawnVehicle({
        model = "rumpo",
        location = {x = x, y = y, z = z-1, h = h},
        teleport = false,
        network = false,
    }, function(vehicle)

        FreezeEntityPosition(vehicle, true)
        SetVehicleDoorsLocked(vehicle, -1)
        SetVehicleCanBeTargetted(vehicle, false)
        SetVehicleCanBeVisiblyDamaged(vehicle, false)
        SetVehicleDoorOpen(vehicle, 3, false, true)

        vehicle_created = vehicle
    end)

    local y = y + 3
    ped_created = createLingLing(x,y,z,h, 'ig_ortega')

    created_pickup = true
end

Citizen.CreateThread(function()
    while true do
        if created_pickup then
            local ped = PlayerPedId()
            local position = GetEntityCoords(ped)
            local coord = GetEntityCoords(ped_created)

            local distance = #(position - coord)

            if (distance <= 2) then
                TriggerEvent("interaction:show", "E - Praten", function()
                    created_pickup = false
                    TriggerServerEvent("Zero:Server-Weed:Gathered")
                    TriggerEvent("interaction:remove", "gather-weed-"..coord.x.."")

                    SetPedAsNoLongerNeeded(ped_created)
                    FreezeEntityPosition(ped_created, false)

                    Citizen.Wait(15000)

                    DeleteEntity(ped_created)
                    DeleteEntity(vehicle_created)
                end)
            end
        else
            Citizen.Wait(250)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    
    exports['zero-eye']:looped_runtime("weed-sell-npc", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        found = false
        
        if IsEntityAPed(entity) then
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                if ped == entity then
                    found = true
                end
            end

        
            if distance <= 4 and not found and Zero.Functions.HasItem('trimmed_weed') and not Cache.Entity[entity] then
                return true, GetEntityCoords(entity)
            end
        end

    end, {
        [1] = {
            name = "Verkoop weed", 
            action = function(entity) 
                sellWeedjesToNPC(entity)
            end,
        },
    }, GetCurrentResourceName(), 5)
end)


function sellWeedjesToNPC(entity)
    if Cache.Entity[entity] then return end

    Cache.Entity[entity] = true

    NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(entity))
    faceEntity(entity, PlayerPedId())
    RequestAnim("mp_common")
    ClearPedTasks(entity)
    SetEntityAsMissionEntity(entity, true, true)
    PlayAmbientSpeech1(entity, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
    SetBlockingOfNonTemporaryEvents(entity, true)
    

    Citizen.Wait(5000)

    if not IsEntityDead(entity) then
        local index = math.random(1, 100)

        if index <= 60 then
            TriggerServerEvent("Zero:Server-Weed:Sold")
            TriggerEvent("randPickupAnim")
        elseif (index > 60 and index <= 90) then
            Zero.Functions.Notification('Verkoop', "Burger heeft geen interresse")
        elseif (index > 90) then -- alert police
            Zero.Functions.Notification("Verkoop", "De politie is zojuist ingelicht")
            
            local location = GetEntityCoords(PlayerPedId())
            local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, location.x, location.y, location.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)

            TriggerServerEvent("Zero:Server-Phone:SendSOSMessage", {
                ['job'] = "police",
                ['title'] = "Melding door burger",
                ['message'] = "Drugs verkoop op, "..street1.." "..street2..""
            }, location, true)
        end
        SetEntityAsNoLongerNeeded(entity)
    end
end

function doAnim(entity, dict, anim, speed, speed, time, flag)
    TaskPlayAnim(entity, dict, anim, speed, speed, time, flag, 1, false, false, false)
end

function RequestAnim(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(0) end
end

function faceEntity(entity1, entity2)
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end