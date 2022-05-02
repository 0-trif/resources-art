runMainloop = function(playerped, position, map_distance)
        
    SyncVehicleDisplays()

    if Zero.Player.Job.name == "tuner" then
        if not VehiclePlacement then
            local claim_distance = #(position - Config.ClaimVehicle)
            if (claim_distance <= 10) then
                Zero.Functions.DrawMarker(Config.ClaimVehicle.x, Config.ClaimVehicle.y, Config.ClaimVehicle.z)

                if IsPedInAnyVehicle(playerped) then
                    if (claim_distance <= 2) then
                        TriggerEvent("interaction:show", "E - Claim", function()
                            local vehicle = GetVehiclePedIsIn(playerped)
                            local properties = Zero.Functions.GetVehicleProperties(vehicle)

                            TriggerServerEvent("Zero:Server-Tuner:ClaimVehicle", properties)
                        end)
                    end
                end
            end

            local control_distance = #(position - Config.ControleTower)
            if (control_distance <= 10) then
                Zero.Functions.DrawMarker(Config.ControleTower.x, Config.ControleTower.y, Config.ControleTower.z)

                if (control_distance <= 2) then
                    TriggerEvent("interaction:show", "E - Garage", function()
                        TriggerEvent("Zero:Client-Tuner:OpenGarageMenu")
                    end)
                end
            end

            local stash_distance = #(position - Config.Stash)
            if (stash_distance <= 10) then
                Zero.Functions.DrawMarker(Config.Stash.x, Config.Stash.y, Config.Stash.z)

                if (stash_distance <= 2) then
                    TriggerEvent("interaction:show", "E - Stash", function()
                        OpenStash()
                    end)
                end
            end

            local store_distance = #(position - Config.Store)
            if (store_distance <= 10) then
                Zero.Functions.DrawMarker(Config.Store.x, Config.Store.y, Config.Store.z)

                if (store_distance <= 2) then
                    TriggerEvent("interaction:show", "E - Dealer", function()
                        OpenVehicleDealer()
                    end)
                end
            end

            for k,v in pairs(Config.SpotLocations) do
                local distance = #(position - vector3(v.x, v.y, v.z))

                if v.lift and not v.transition then

                    if (distance <= 5) then
                        Zero.Functions.DrawText(v.x+3.2, v.y + 1.4, v.z + 1.5, '~b~UP~w~ - Lift omhoog')
                        Zero.Functions.DrawText(v.x+3.2, v.y + 1.4, v.z + 1.4, '~b~DOWN~w~ - Lift omlaag')

                        if IsControlPressed(0, Zero.Config.Keys['TOP']) then
                            TriggerServerEvent("Zero:Server-Tuner:LiftUp", k)
                            v.transition = true
                        end
                        if IsControlPressed(0, Zero.Config.Keys['DOWN']) then
                            TriggerServerEvent("Zero:Server-Tuner:LiftDown", k)
                            v.transition = true
                        end
                    end
                elseif (v.lift and v.transition) then
                    if (distance <= 5) then
                        Zero.Functions.DrawText(v.x+3.2, v.y + 1.4, v.z + 1.5, 'Busy..')
                    end
                end
            end
        else
            ControleVehiclePlacement()
        end
    end
end



Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do 
        Wait(0)
    end

    while true do
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local map_distance = #(coords - vector3(Config.Location.x, Config.Location.y, Config.Location.z))

        if (map_distance) <= 40 then
            CheckLifts()
            runMainloop(player, coords, map_distance)
        else
            removeObjects()
            Citizen.Wait(750)
        end
        
        Citizen.Wait(0)
    end
end)

