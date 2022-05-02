-- VEHICLE ENTERING // LEAVING
exports["zero-core"]:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

local IN_VEHICLE  

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end

    while true do
        local timer = 30

        local ply = PlayerPedId()
        local position = GetEntityCoords(ply)

        local vehicle = GetVehiclePedIsIn(ply)

        if IN_VEHICLE ~= vehicle then

            LAST_VEHICLE = IN_VEHICLE
            IN_VEHICLE = vehicle

            if (IN_VEHICLE == 0) then
                TriggerEvent("Zero:Client-BaseEvents:LeftVehicle", LAST_VEHICLE, last_plate) 
            else
                TriggerEvent("Zero:Client-BaseEvents:EnteredVehicle", IN_VEHICLE) 
            end

            Wait(50)
        end
        
        Wait(timer)
    end
end)

RegisterNetEvent("Zero:Client-BaseEvents:EnteredVehicle")
AddEventHandler("Zero:Client-BaseEvents:EnteredVehicle", function(vehicle)
    local ply = PlayerPedId()
    local plate = GetVehicleNumberPlateText(vehicle)

    for i = -1, GetNumberOfVehicleDoors(vehicle) do
        if GetPedInVehicleSeat(vehicle, i) == ply then
            seat = i
        end
    end
    
    last_plate = plate
    TriggerServerEvent("Zero:Server-BaseEvents:EnteredVehicle", plate, seat)
end)

RegisterNetEvent("Zero:Client-BaseEvents:LeftVehicle")
AddEventHandler("Zero:Client-BaseEvents:LeftVehicle", function()
    TriggerServerEvent("Zero:Server-BaseEvents:LeftVehicle", last_plate)
end)

-- CODE | VEHICLE ENTERING LEAVING END


-- VEHICLE CRASHING

Citizen.CreateThread(function()
    while true do
        local ply = PlayerPedId()
        local timer = 750

        if IsPedInAnyVehicle(ply) then
            timer = 100

            local vehicle = GetVehiclePedIsIn(ply)

            last_damage = last_damage or GetVehicleBodyHealth(vehicle)
            prev_speed = GetEntitySpeed(vehicle)
            prev_health = GetVehicleBodyHealth(vehicle)
            prev_engineHealth = GetVehicleEngineHealth(vehicle)

            Wait(100)

            local speed = GetEntitySpeed(vehicle)
            local health = GetVehicleBodyHealth(vehicle)
            local engineHealth = GetVehicleEngineHealth(vehicle)

            if prev_speed >= speed and (prev_health > health or prev_engineHealth > engineHealth) then
                TriggerEvent("Zero:Client-BaseEvents:VehicleCrashed", vehicle, prev_speed, speed, prev_health, health, prev_engineHealth, engineHealth)

                Wait(100)
            end
        end

        Wait(timer)
    end
end)