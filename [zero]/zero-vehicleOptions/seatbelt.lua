local vehicle
local seatbelt
local last_vehicle
local vehicleFrameChanged

exports['zero-core']:object(function(O) Zero = O end)

function EjectFromVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped,false)
    local coords = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 1.0)
    SetEntityCoords(ped,coords)
    Citizen.Wait(1)
    SetPedToRagdoll(ped, 5511, 5511, 0, 0, 0, 0)
    SetEntityVelocity(ped, veloc.x*4,veloc.y*4,veloc.z*4)
    local ejectspeed = math.ceil(GetEntitySpeed(ped) * 8)
    Citizen.Wait(5511)
    if(GetEntityHealth(ped) - ejectspeed) > 0 then
        SetEntityHealth(ped, (GetEntityHealth(ped) - ejectspeed) )
    elseif GetEntityHealth(ped) ~= 0 then
        SetEntityHealth(ped, 0)
    end
end

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        local vehicle = IsPedInAnyVehicle(player)

        
        if vehicle then
            local in_vehicle = GetVehiclePedIsIn(player)
            local vehicle_speed = GetEntitySpeed(in_vehicle) * 3.6
            
            if (in_vehicle ~= last_vehicle) then
                seatbelt = false
                last_vehicle = in_vehicle

                vehicleHealth = GetEntityMaxHealth(in_vehicle)
                SetVehicleRadioEnabled(in_vehicle, false)
            end

            if vehicleHealth ~= GetEntityHealth(in_vehicle) then
                local changed = vehicleHealth - GetEntityHealth(in_vehicle)
                vehicleHealth = GetEntityHealth(in_vehicle)
                
            
                if changed > 18.0 then
                    vehicleFrameChanged = true
                    

                    if (vehicle_speed > 28 and vehicleFrameChanged and not seatbelt) then
                        veloc = GetEntityVelocity(in_vehicle)
                        vehicleFrameChanged = false
                        EjectFromVehicle()
                    else
                        vehicleFrameChanged = false
                    end
                end
            end

            if IsControlJustPressed(0, Zero.Config.Keys['G']) then
                seatbelt = not seatbelt
                TriggerEvent("seatbelt", seatbelt)
            end
         
            if seatbelt then
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
    
            end
        else
            if seatbelt then
                seatbelt = false
                TriggerEvent("seatbelt", seatbelt)
            end
     
            Citizen.Wait(250)
        end

        Citizen.Wait(0)
    end
end)