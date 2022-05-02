
exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

RegisterNetEvent("Zero:Client-Laptop:Bought")
AddEventHandler("Zero:Client-Laptop:Bought", function()
    local ArtCoins = Zero.Functions.GetPlayerData().Money.artcoin

    SendNUIMessage({
        action = "Coins",
        amount = ArtCoins
    })
end)

RegisterNetEvent("Zero:Client-Laptop:Open")
AddEventHandler("Zero:Client-Laptop:Open", function()
    SendNUIMessage({
        action = "open",
    })

    local ArtCoins = Zero.Functions.GetPlayerData().Money.artcoin

    SendNUIMessage({
        action = "Coins",
        amount = ArtCoins
    })

    SetNuiFocus(true, true)
end)

RegisterNUICallback("ui-closed", function()
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end

    Wait(2000)

    SendNUIMessage({
        action = "SetupApps",
        apps = laptop.apps,
    })
end)