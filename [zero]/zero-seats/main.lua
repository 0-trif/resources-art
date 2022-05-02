exports["zero-core"]:object(function(O) Zero = O end)

Citizen.CreateThread(function()
    while true do
        local timer = 750

        local ply = PlayerPedId()
        local plyc = GetEntityCoords(ply)

        if not onBed and not inChair then
            for k,v in pairs(config.beds) do
                local obj = GetClosestObjectOfType(plyc.x, plyc.y, plyc.z, 1.0, v.model)
                if DoesEntityExist(obj) then
                    timer = 0
                
                    TriggerEvent("interaction:show", "Liggen", function()
                        LayOnBed(obj, v)
                    end)
                end
            end
        elseif (onBed) then
            timer = 0
            DisplayOptionsBed()
        elseif (inChair) then
        end
        Wait(timer)
    end
end)

function LayOnBed(obj, data)
    local ply = PlayerPedId()

    last_obj = obj

    local heading = GetEntityHeading(obj) - 180.00
    SetEntityHeading(ply, heading)

    local x,y,z = table.unpack(GetEntityCoords(obj))
    SetEntityCoords(ply, x, y, z)

    TriggerEvent("bed:animation", "sit2")

    onBed = true
end

function DisplayOptionsBed() 
    DisableControlAction(0, Zero.Config.Keys['X'], true)
    TriggerEvent("interaction:show", "Opties", function()
        exports['zero-ui']:element(function(ui)
            ui.set("Bed", {
                {
                    label = "Zitten",
                    subtitle = "Ga rechtop zitten op bed",
                    event = "bed:animation",
                    value = "sit2",
                },
                {
                    label = "Passout 1",
                    subtitle = "Verrander animatie naar passout 1",
                    event = "bed:animation",
                    value = "passout",
                },
                {
                    label = "Passout 2",
                    subtitle = "Verrander animatie naar passout 2",
                    event = "bed:animation",
                    value = "passout2",
                },
                {
                    label = "Passout 3",
                    subtitle = "Verrander animatie naar passout 3",
                    event = "bed:animation",
                    value = "passout3",
                },
                {
                    label = "Passout 4",
                    subtitle = "Verrander animatie naar passout 4",
                    event = "bed:animation",
                    value = "passout4",
                },
                {
                    label = "Passout 5",
                    subtitle = "Verrander animatie naar passout 5",
                    event = "bed:animation",
                    value = "passout5",
                },
                {
                    label = "Sluit",
                    subtitle = "Sluiten en opstaan van bed",
                    event = "bed:cancel",
                },
            })
        end)
    end)
end

RegisterNetEvent("bed:animation")
AddEventHandler("bed:animation", function(anim)
    ply = PlayerPedId()
    local anim = anim

    local heading = GetEntityHeading(last_obj) - 180.00
    SetEntityHeading(ply, heading)

    local x,y,z = table.unpack(GetEntityCoords(last_obj))
    SetEntityCoords(ply, x, y, z)

    SetEntityHeading(ply, GetEntityHeading(ply) - config.bedAnimations[anim])
    ExecuteCommand("e "..anim.."")
end)

RegisterNetEvent("bed:cancel")
AddEventHandler("bed:cancel", function()
    ply = PlayerPedId()

    onBed = false
    

    ExecuteCommand("e c")
end)
