local enabled_2step = false

enable2step = function()
    if IsControlJustPressed(0, Zero.Config.Keys[']']) then
        enabled_2step = not enabled_2step

        local value = enabled_2step and "aan" or "uit"
        notify = "2Step modification staat nu "..value..""
        Zero.Functions.Notification("Tuner", notify)
    end
end

Citizen.CreateThread(function()
    while true do
        if (enabled_2step) then
            local player = PlayerPedId()
            
            if IsPedInAnyVehicle(player) then
                local pedVehicle = GetVehiclePedIsIn(player)
                local vehiclePos = GetEntityCoords(pedVehicle)
                local delay = (math.random(25, 200))
                local RPM = GetVehicleCurrentRpm(pedVehicle)
            
                if not IsControlPressed(0, Zero.Config.Keys['W']) and (RPM > 0.75) then
                    TriggerServerEvent("eff_flames", VehToNet(pedVehicle))
                  --  AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 61, 0.0, true, true, 0.0, true)
                    SetVehicleTurboPressure(pedVehicle, 25)
                end

                Citizen.Wait(delay)
            else
                enabled_2step = false
            end
        end
        Citizen.Wait(0)
    end
end)


local vehicle_bones = {
    "exhaust",    "exhaust_2",  "exhaust_3",  "exhaust_4",
    "exhaust_5",  "exhaust_6",  "exhaust_7",  "exhaust_8",
    "exhaust_9",  "exhaust_10", "exhaust_11", "exhaust_12",
    "exhaust_13", "exhaust_14", "exhaust_15", "exhaust_16"
}
flames = {}
RegisterNetEvent("c_eff_flames")
AddEventHandler("c_eff_flames", function(c_veh)
    local vehicle = NetToVeh(c_veh)

    RequestNamedPtfxAsset("veh_xs_vehicle_mods")

    while not HasNamedPtfxAssetLoaded("veh_xs_vehicle_mods") do
        Citizen.Wait(0)
    end

    local pitch = GetEntityPitch(vehicle)

	for k,v in pairs(vehicle_bones) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, v)

        local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
        local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)

        SetPtfxAssetNextCall('veh_xs_vehicle_mods')
        local flame = StartNetworkedParticleFxLoopedOnEntityBone("veh_nitrous", vehicle, 0.0,0.0,0.0 , 0.0, pitch, 0.0, boneIndex, 0.7, false, false, false)
        Citizen.Wait(100)
        RemoveParticleFx(flame)
	end
end)