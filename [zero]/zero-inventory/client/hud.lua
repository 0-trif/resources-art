RegisterNetEvent("hud:add")
AddEventHandler("hud:add", function(title, colour, id)
    SendNUIMessage({
        action = "hud:add",
        title = title,
        colour = colour,
        index = id,
    })
end)

RegisterNetEvent("hud:show")
AddEventHandler("hud:show", function(id)
    SendNUIMessage({
        action = "hud:show",
        index = id,
    })
end)

RegisterNetEvent("hud:hide")
AddEventHandler("hud:hide", function(id)
    SendNUIMessage({
        action = "hud:hide",
        index = id,
    })
end)


RegisterNetEvent("hud:clear")
AddEventHandler("hud:clear", function()
    SendNUIMessage({
        action = "hud:clear",
    })
end)

RegisterNetEvent("hud:set")
AddEventHandler("hud:set", function(index, perc)
    perc = perc <= 100 and perc or 100
    perc = math.ceil(perc)
    
    SendNUIMessage({
        action = "hud:set",
        index = index,
        perc = perc
    })
end)