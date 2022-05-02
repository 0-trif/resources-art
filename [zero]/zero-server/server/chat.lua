Zero.Commands.Add("staff", "Staff chat (Admin Only)", {}, true, function(source, args)
    local _ = ""
    for k,v in pairs(args) do
        _ = _ .. " " .. v
    end

    local name = GetPlayerName(source)

    local players = Zero.Functions.Players()

    for k,v in pairs(players) do
        if Zero.Functions.Role(v.User.Source, 1) then
            TriggerClientEvent('chatMessage', v.User.Source, "STAFF - ("..name..")", "error", _)
        end
    end
end, 1)

Zero.Commands.Add("report", "Staff reports", {}, true, function(source, args)
    local _ = ""
    for k,v in pairs(args) do
        _ = _ .. " " .. v
    end

    local name = GetPlayerName(source)
    local players = Zero.Functions.Players()
    for k,v in pairs(players) do
        if Zero.Functions.Role(v.User.Source, 1) then
            TriggerClientEvent('chatMessage', v.User.Source, "REPORT - ("..name..": "..source..")", "success", _)
        end
    end
end, 0)

Zero.Commands.Add("reply", "Staff reply (admin)", {{name="id",help="Speler id"}}, true, function(source, args)
    local _ = ""

    local id = tonumber(args[1])
    table.remove(args, 1)
    for k,v in pairs(args) do
        _ = _ .. " " .. v
    end

    local name = GetPlayerName(source)
    TriggerClientEvent('chatMessage', id, "REPLY - ("..name..")", "error", _)

    local players = Zero.Functions.Players()
    for k,v in pairs(players) do
        if Zero.Functions.Role(v.User.Source, 1) then
            TriggerClientEvent('chatMessage', v.User.Source, "REPLY", "success", ""..name.." heeft een reply gestuurd naar ("..id..")")
        end
    end
end, 1)