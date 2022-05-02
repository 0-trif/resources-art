local enableNOS = function(vehicle, plate)
    if vehicles[plate]['nos_fuel'] > 0 then
        if IsControlJustPressed(0, Zero.Config.Keys['LEFTSHIFT']) then
            StopScreenEffect('RaceTurbo')
            StartScreenEffect('RaceTurbo', 0, false)
          --  SetTimecycleModifier('rply_motionblur')
            ShakeGameplayCam('SKY_DIVING_SHAKE', 0.25)

            local vehicleModel = GetEntityModel(vehicle)
            local currentSpeed = GetEntitySpeed(vehicle)
            local maximumSpeed = GetVehicleModelMaxSpeed(vehicleModel)
            local multiplier = 3.0 * maximumSpeed / currentSpeed

            TriggerEvent("hud:show", "nos")
            TriggerServerEvent("Zero:Server-Vehicles:StartNOSparticles", NetworkGetNetworkIdFromEntity(vehicle))

            while IsControlPressed(0, Zero.Config.Keys['LEFTSHIFT']) and IsControlPressed(0, Zero.Config.Keys['W']) and vehicles[plate]['nos_fuel'] > 0 do
                Citizen.Wait(1)
                local currentSpeed = GetEntitySpeed(vehicle)
                local multiplier = 3.0 * maximumSpeed / currentSpeed
                SetVehicleEngineTorqueMultiplier(vehicle, multiplier)

                vehicles[plate]['nos_fuel'] = vehicles[plate]['nos_fuel'] - 0.03 >= 0 and vehicles[plate]['nos_fuel'] - 0.03 or 0
                TriggerEvent("hud:set", "nos", vehicles[plate]['nos_fuel']) 
            end

            SetVehicleEngineTorqueMultiplier(vehicle, 0)
            StopGameplayCamShaking(true)
            SetTransitionTimecycleModifier('default', 0.35)
            TriggerServerEvent("Zero:Server-Vehicles:StopNOSparticles", NetworkGetNetworkIdFromEntity(vehicle))

            TriggerServerEvent("Zero:Server-Vehicles:SaveNosFuel", plate, vehicles[plate]['nos_fuel'])
            Citizen.Wait(2000)
            TriggerEvent("hud:hide", "nos")
        end
    end
end

local enablePurge = function(vehicle)
    if IsControlJustPressed(0, Zero.Config.Keys['B']) then

        TriggerServerEvent("Zero:Server-Vehicles:StartPurgeparticles", NetworkGetNetworkIdFromEntity(vehicle))

        while IsControlPressed(0, Zero.Config.Keys['B']) do
            Citizen.Wait(0)
        end

        TriggerServerEvent("Zero:Server-Vehicles:StopPurgeparticles", NetworkGetNetworkIdFromEntity(vehicle))
    end
end

local DisplayNOSparticles = function(vehicle, scale)
    local exhaustNames = {
        "exhaust",    "exhaust_2",  "exhaust_3",  "exhaust_4",
        "exhaust_5",  "exhaust_6",  "exhaust_7",  "exhaust_8",
        "exhaust_9",  "exhaust_10", "exhaust_11", "exhaust_12",
        "exhaust_13", "exhaust_14", "exhaust_15", "exhaust_16"
      }
    
    RequestNamedPtfxAsset("veh_xs_vehicle_mods")
    while not HasNamedPtfxAssetLoaded("veh_xs_vehicle_mods") do
        Citizen.Wait(0)
    end
    shown_particles[NetworkGetNetworkIdFromEntity(vehicle)] = {}
    local pitch = GetEntityPitch(vehicle)
    for k, v in ipairs(exhaustNames) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, v)
  
        if boneIndex ~= -1 then
            local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
            local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
  
            SetPtfxAssetNextCall('veh_xs_vehicle_mods')
            table.insert(shown_particles[NetworkGetNetworkIdFromEntity(vehicle)], StartNetworkedParticleFxLoopedOnEntityBone("veh_nitrous", vehicle, 0.0,0.0,0.0 , 0.0, pitch, 0.0, boneIndex, 1.0, false, false, false))
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local ply = PlayerPedId()
        
        if IsPedInAnyVehicle(ply, false) then
            local vehicle = GetVehiclePedIsIn(ply)
            local plate = GetVehicleNumberPlateText(vehicle)

            if (vehicles[plate]) then
                if GetPedInVehicleSeat(vehicle, -1) == ply then
                    if (vehicles[plate]['nos']) then
                        enableNOS(vehicle, plate)
                        enablePurge(vehicle)
                    end

                    if vehicles[plate]['2step'] then
                        enable2step()
                    end
                end
            else
                Citizen.Wait(250)
            end
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    nos_particles = {}
    shown_particles = {}
    while true do
        Wait(0)

        for k,v in pairs(nos_particles) do
           if (NetworkDoesNetworkIdExist(k)) then
                local vehicle = NetworkGetEntityFromNetworkId(k)
                if (vehicle) then
                    if not shown_particles[k] then
                        DisplayNOSparticles(vehicle, 0.9)
                        Citizen.Wait(10)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("Zero:Client-Vehicles:StartNOSparticles")
AddEventHandler("Zero:Client-Vehicles:StartNOSparticles", function(networkId)
    nos_particles[networkId] = true
end)

RegisterNetEvent("Zero:Client-Vehicles:StopNOSparticles")
AddEventHandler("Zero:Client-Vehicles:StopNOSparticles", function(networkId)
    nos_particles[networkId] = nil

    if shown_particles[networkId] then
        for k,v in pairs(shown_particles[networkId]) do
            RemoveParticleFx(v)
        end
    end

    shown_particles[networkId] = nil
end)


RegisterNetEvent("Zero:Client-Vehicles:StartPurgeparticles")
AddEventHandler("Zero:Client-Vehicles:StartPurgeparticles", function(networkId)
    purge(NetworkGetEntityFromNetworkId(networkId), true)
end)

RegisterNetEvent("Zero:Client-Vehicles:StopPurgeparticles")
AddEventHandler("Zero:Client-Vehicles:StopPurgeparticles", function(networkId)
    purge(NetworkGetEntityFromNetworkId(networkId), false)
end)

local particles_fx = {}

function purge(vehicle, enabled, r, g, b)
    
    if (enabled) then
        local bone = GetEntityBoneIndexByName(vehicle, 'bonnet')
        local pos = GetWorldPositionOfEntityBone(vehicle, bone)
        local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
        local ptfxs = {}

        for i = 0, 3 do
            local leftPurge = CreateVehiclePurgeSpray(vehicle, off.x - 0.5, off.y + 0.05, off.z, 40.0, -20.0, 0.0, 0.5, r,g,b)
            local rightPurge = CreateVehiclePurgeSpray(vehicle, off.x + 0.5, off.y + 0.05, off.z, 40.0, 20.0, 0.0, 0.5, r,g,b)

            table.insert(ptfxs, leftPurge)
            table.insert(ptfxs, rightPurge)
        end

        particles_fx[vehicle] = ptfxs
    else
        
        if particles_fx[vehicle] then
            
            for k, v in pairs(particles_fx[vehicle]) do
                for k, v in pairs(v) do
                    StopParticleFxLooped(v)
                end
            end
            particles_fx[vehicle] = nil
        end
    end
end

function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, density, r, g, b)
    local boneIndex = GetEntityBoneIndexByName(vehicle, 'bonnet')
    local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
    local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)

    local xOffset = (xOffset or 0) + off.x
    local yOffset = (yOffset or 0) + off.y
    local zOffset = (zOffset or 0) + off.z

    local xRot = xRot or 0
    local yRot = yRot or 0
    local zRot = zRot or 0

    local scale = scale or 0.5
    local density = density or 3

    local r = (r or 255) / 255
    local g = (g or 255) / 255
    local b = (b or 255) / 255

    local xxz = {}

    for i = 0, density do
        UseParticleFxAssetNextCall('core')
        local fx1 = StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, off.x - 0.5, off.y + 0.05, off.z, 40.0, -20.0, 0.0, 0.5, false, false, false)
        SetParticleFxLoopedColour(fx1, r, g, b)

        UseParticleFxAssetNextCall('core')
        local fx2 = StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, off.x + 0.5, off.y + 0.05, off.z, 40.0, 20.0, 0.0, 0.5, false, false, false)
        SetParticleFxLoopedColour(fx2, r, g, b)

        table.insert(xxz, fx1)
        table.insert(xxz, fx2)
    end
    return xxz
end