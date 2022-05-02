exports['zero-core']:object(function(O)
    Zero = O
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)

        for k,v in pairs(config.lifts) do
            local distance = #(pos - vector3(v.loc.x, v.loc.y, v.loc.z))

            if distance <= 1.5 then
                timer = 0
                
                TriggerEvent("interaction:show", "Lift", function()
                    OpenLift(v.destinations)
                end)
            end
        end

        Wait(timer)
    end
end)

function OpenLift(destinations)
    local ui = exports['zero-ui']:element()
    local menu = {}

    last_destinations = destinations

    for k,v in pairs(destinations) do
        menu[#menu+1] = {
            label = v.label,
            value = k,
            event = "lifts:goto",
            subtitle = "Ga naar "..v.label.." met de lift"
        }
    end

    menu[#menu+1] = {
        label = 'Sluit',
        value = 'Sluit lift menu'
    }

    ui.set("Lift", menu)
end

RegisterNetEvent("lifts:goto")
AddEventHandler("lifts:goto", function(index)
    local index = tonumber(index)
    if last_destinations[index] then
        local x,y,z,h = last_destinations[index].coord.x, last_destinations[index].coord.y, last_destinations[index].coord.z, last_destinations[index].coord.h


        Zero.Functions.Progressbar("lift", "Lift gebruiken..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {

        }, {}, {}, function() -- Done
            DoScreenFadeOut(150)

            while not IsScreenFadedOut() do
                Wait(9)
            end
    
            SetEntityCoords(PlayerPedId(), x, y, z)
            SetEntityHeading(PlayerPedId(), h)
    
            Wait(1500)
    
            DoScreenFadeIn(150)
        end, function() -- Cancel
            Zero.Functions.Notification("Lift", "Lift geanuleerd", "error")
        end)          
    end
end)