RegisterServerEvent("Zero:Server-Tuner:BoughtItem")
AddEventHandler("Zero:Server-Tuner:BoughtItem", function(price)
    local src = source
    local Player = Zero.Functions.Player(src)

    Player.Functions.RemoveMoney("cash", price, "Tuning gekocht bij LScustoms")
end)

RegisterServerEvent("Zero:Server-Tuning:SavedVehicle")
AddEventHandler("Zero:Server-Tuning:SavedVehicle", function(mods)
    local src = source
    local Player = Zero.Functions.Player(src)

    Player.Functions.SetVehicleMods(mods.plate, mods)
    TriggerEvent("Zero:Server-Tuner:CheckVehicle", mods, src)
end)
