exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

RegisterNUICallback("close", function()
    shown_settings = not shown_settings
    SendNUIMessage({
        action = "show",
        settings = last_settings,
        bool = shown_settings
    })
    SetNuiFocus(shown_settings, shown_settings)

    if (shown_settings) then
        TriggerScreenblurFadeIn(250)
    else
        TriggerScreenblurFadeOut(250)
    end
end)

RegisterNUICallback("setBackground", function(ui)
    TriggerServerEvent("Zero:Server-Settings:SetBackground", ui.type, ui.value)
end)

RegisterNUICallback("AddKeybind", function(ui)
    if Zero.Config.Keys[string.upper(ui.key)] then
        TriggerServerEvent("Zero:Server-Settings:AddKeybind", ui.key, ui.command)
    else
        Zero.Functions.Notification("Keybinds", "Deze keybind is niet geldig", "error")
    end
end)

shown_settings = false
RegisterCommand("settings", function()
    shown_settings = not shown_settings
    SendNUIMessage({
        action = "show",
        settings = last_settings,
        bool = shown_settings
    })
    SetNuiFocus(shown_settings, shown_settings)

    if (shown_settings) then
        TriggerScreenblurFadeIn(250)
    else
        TriggerScreenblurFadeOut(250)
    end
end)

RegisterNetEvent("Zero:Client-Settings:Resync")
AddEventHandler("Zero:Client-Settings:Resync", function(settings)
    last_settings = settings

    SendNUIMessage({
        action = "show",
        settings = last_settings,
        bool = shown_settings
    })

    if (settings.background) then
        exports['zero-inventory']:setBackground('player', settings.background['player'])
        exports['zero-inventory']:setBackground('other', settings.background['other'])
    end
end)


Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end

    TriggerServerEvent("Zero:Server-Settings:Request")
end)

Citizen.CreateThread(function()
    while true do
        if last_settings then
            for k,v in pairs(last_settings.keybinds) do
                if IsControlJustPressed(0, Zero.Config.Keys[string.upper(k)]) then
                    ExecuteCommand(v)
                    Citizen.Wait(2000)
                end
            end
        end

        Citizen.Wait(0)
    end
end)