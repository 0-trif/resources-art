RegisterServerEvent("Zero:Server-Public:PayOutDriver")
AddEventHandler("Zero:Server-Public:PayOutDriver", function()
    local src = source
    local Player = Zero.Functions.Player(src)

    if Player.Job.name == "driver" then
        Player.Functions.GiveMoney('cash', math.random(70, 100), "Geld ontvangen van een klant (baan)")
    else
        -- ban
    end
end)