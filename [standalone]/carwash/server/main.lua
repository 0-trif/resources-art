exports['zero-core']:object(function(O) Zero = O end)

RegisterServerEvent('Zero-carwash:server:washCar')
AddEventHandler('Zero-carwash:server:washCar', function()
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Money.cash >= Config.DefaultPrice) then
        Player.Functions.RemoveMoney("cash", Config.DefaultPrice, "Auto gewassen.", {
            title = "Carwash",
            subtitle = "Voertuig gewassen",
            icon = "https://www.seekpng.com/png/detail/431-4311579_car-cleaning-product-list-mobile-car-wash-icon.png"
        })
        TriggerClientEvent('Zero-carwash:client:washCar', src)
    elseif (Player.Money.bank >= Config.DefaultPrice) then
        Player.Functions.RemoveMoney("bank", Config.DefaultPrice, "Auto gewassen.", {
            title = "Carwash",
            subtitle = "Voertuig gewassen",
            icon = "https://www.seekpng.com/png/detail/431-4311579_car-cleaning-product-list-mobile-car-wash-icon.png"
        })
        TriggerClientEvent('Zero-carwash:client:washCar', src)
    else
        Player.Functions.Notification("Carwash", "Je hebt niet genoeg geld", "error")
    end
end)