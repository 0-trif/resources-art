local syncedSpeed = false

Citizen.CreateThread(function()
    while true do
        local timer = 1000

        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then

            local entity = GetVehiclePedIsIn(ped)
            local entitymodel = GetEntityModel(entity)

            CheckVehicleSpeed(entity, entitymodel)
        end

        Wait(timer)
    end
end)

function CheckVehicleSpeed(entity, model)
    if vehicles[model] then
        local kmU = vehicles[model]
        local mS = vehicles[model] / 3.6
        SetVehicleMaxSpeed(entity, mS)
    end
end