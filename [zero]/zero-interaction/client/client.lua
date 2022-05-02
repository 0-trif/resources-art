RegisterNetEvent("interaction:show")
AddEventHandler("interaction:show", function(text, cb)
    interactionText = text
    interactionCb = cb
    interactionTimer = 2
end)

interactionTimer = 0
showingInt = false

Citizen.CreateThread(function()
    while true do
        if interactionTimer > 1 and not showingInt then
            showingInt = true

            SendNUIMessage({
                action = "interaction",
                bool = true,
                text = interactionText,
            })
        elseif interactionTimer < 1 and showingInt then
            showingInt = false
            SendNUIMessage({
                action = "interaction",
                bool = false,
            })
            interactionCb = nil
        end

        SendNUIMessage({
            action = "text",
            text = interactionText,
        })

        interactionTimer = interactionTimer - 1 > 0 and interactionTimer - 1 or 0
        Citizen.Wait(100)
    end
end)


Citizen.CreateThread(function()
    while true do
        if interactionCb then
            if IsControlJustPressed(0, Keys['E']) then
                interactionCb()
            end
        else
            Wait(100)
        end
        Citizen.Wait(0)
    end
end)
--[[
    
Citizen.CreateThread(function()
    while true do
        local sleep = 250

        if not found_objective_ then
            for k,v in pairs(interactions) do
                local distance = #(GetEntityCoords(PlayerPedId()) - vector3(v.location.x, v.location.y, v.location.z))

                if (distance <= v['distance']) then
                    sleep = 0
                    found_objective_ = k
                    
                    SendNUIMessage({
                        action = "toggle",
                        bool = true,
                        text = v.text,
                    })

                    current_function = v.cb

                    while found_objective_ do
                        local data = interactions[found_objective_]
                        if data then
                            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(data.location.x, data.location.y, data.location.z))

                            if (current_function) then

                                if (IsControlJustPressed(0, 46)) then
                                    if current_function then
                                        current_function()
                                    end
                                end
                            end

                            if (distance > data.distance) then

                                SendNUIMessage({
                                    action = "toggle",
                                    bool = false,
                                })

                                

                                current_function = nil

                                Citizen.Wait(1300)
                                found_objective_ = nil
                            end
                        else
                            found_objective_ = nil
                        end

                        Wait(0)
                    end
                else
                    interactions[k] = nil
                end
            end
        end

        Wait(sleep)
    end
end)
]]