local ui = {}

ui.set = function(title, menu)
    SendNUIMessage({
        action = "SetupMenu",
        title = title,
        menu = menu,
    })
    SetNuiFocus(true, true)
end

ui.input = function(title)
    input = nil
    
    SendNUIMessage({
        action = "ShowInput",
        title = title,
    })

    SetNuiFocus(true, true)
    
    while input == nil do
        Wait(0)
    end

    return input
end

ui.timer = function(title, perc)
    SendNUIMessage({
        action = "timer",
        title = title,
        perc = perc,
    })
end


local delayTime = 0
ui.delay = function(time, title)
    local ui = exports['zero-ui']:element()

    if delayTime > 0 then return end

    delayTime = time

    ui.timer(title, 100)
    
    while delayTime > 0 do
        Wait(1)

        delayTime = delayTime - 10
        
        ui.timer(title, (100 / time * delayTime))
    end

    ui.timer("", 0)

    delayTime = 0

    return
end

exports("element", function(cb)
    if cb then
        cb(ui)
    else
        return ui
    end
end)


RegisterNUICallback("event_", function(ui)
    TriggerEvent("ui:close")
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    TriggerEvent(ui.event, ui.value, ui.extra)
end)

RegisterNUICallback("input", function(ui)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    input = ui.code
    SetNuiFocus(false, false)
end)


RegisterNUICallback("close", function(ui)
    TriggerEvent("ui:close")
    input = ""
end)

RegisterNetEvent("ui:close")
AddEventHandler("ui:close", function()
    ui.set("", {})
    SetNuiFocus(false, false)
end)