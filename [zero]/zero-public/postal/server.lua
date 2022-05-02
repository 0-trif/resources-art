RegisterServerEvent("Zero:Server-Public:Delivery")
AddEventHandler("Zero:Server-Public:Delivery", function()
    local src = source
    local Player = Zero.Functions.Player(src)

    if Player.Job.name == "delivery" then
        Player.Functions.GiveMoney('cash', math.random(50, 100), "Geld ontvangen voor bezorging")
    else
        -- ban
    end
end)