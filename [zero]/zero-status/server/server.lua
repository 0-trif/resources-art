exports["zero-core"]:object(function(O) Zero = O end)

RegisterServerEvent("Zero:Server-Status:SetStatus")
AddEventHandler("Zero:Server-Status:SetStatus", function(food, water)
    local Player = Zero.Functions.Player(source)

    Player.Functions.SetMetaData("Food", food)
    Player.Functions.SetMetaData("Water", water)
end)

RegisterServerEvent("Zero:Server-Status:RevivedPay")
AddEventHandler("Zero:Server-Status:RevivedPay", function()
    local Player = Zero.Functions.Player(source)

    Player.Functions.RemoveMoney("bank", 5000, "Revive bij hospital")
    Player.Functions.Notification("Status", "Je bent geholpen bij het ziekenhuis", "success", 5000)
end)

RegisterServerEvent("Zero:Server-Status:SetDeathStatus")
AddEventHandler("Zero:Server-Status:SetDeathStatus", function(bool)
    local Player = Zero.Functions.Player(source)
    Player.Functions.SetMetaData("dead", bool)
end)


RegisterServerEvent("Zero:Server-Status:Respawned")
AddEventHandler("Zero:Server-Status:Respawned", function(bool)
    local Player = Zero.Functions.Player(source)
    Player.Functions.Inventory().functions.clear()
    local cash = Player.Functions.GetMoney('cash')
    Player.Functions.RemoveMoney('cash', cash, "Speler is dood gegaan")
end)


Zero.Commands.Add("res", "Revive speler", {{name="playerid", help="Playerid van target speler"}}, false, function(source, args)
    local target = tonumber(args[1]) or source
    TriggerClientEvent("Zero:Client-Status:Revive", target)    
end, 1)

Zero.Commands.Add("kill", "Revive speler", {{name="playerid", help="Playerid van target speler"}}, false, function(source, args)
    local target = tonumber(args[1]) or source
    TriggerClientEvent("Zero:Client-Status:Kill", target)    
end, 1)

