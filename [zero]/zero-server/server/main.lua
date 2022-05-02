Zero.Functions.CreateCallback("Zero:Server-Admin:PlayerList", function(source, cb)
    local _ = {}
    local players = Zero.Functions.Players()

    for k,v in pairs(players) do
        if v.User.Source then
            _[v.User.Source] = {
                name = GetPlayerName(v.User.Source),
                id = v.User.Source,
            }
        end
    end


    cb(_)
end)


Zero.Functions.CreateCallback('Zero:Server-Admin:IsAdmin', function(source, cb)
    if Zero.Functions.Role(source, 1) then
        cb(true)
    else
        cb(false)
    end
end)



RegisterServerEvent("Zero:Server-Admin:Log")
AddEventHandler("Zero:Server-Admin:Log", function(class, option, extra1, extra2)
    local src = source

    if (Zero.Functions.Role(src, 1)) then
        local extra1 = extra1 ~= nil and extra1 or "- Geen input"
        local extra2 = extra2 ~= nil and extra2 or "- Geen input"

        Zero.Functions.CreateLog("admins", "Admin function executed", "Admin: "..GetPlayerName(src).." \n \n **Function:** "..option.." \n **Input-1: **"..extra1.." \n ** Input-2: ** "..extra2.."", "green", false)
    end
end)

RegisterServerEvent("Zero:Server-Admin:Revive")
AddEventHandler("Zero:Server-Admin:Revive", function(id)
    local src = source

    local id = id ~= nil and tonumber(id) or src

    if (Zero.Functions.Role(src, 1) and id) then
        TriggerClientEvent("Zero:Client-Status:Revive", id)   
        Zero.Functions.Notification(src, "System", "Player revived", "warning") 
    end
end)

RegisterServerEvent("Zero:Server-Admin:Clear")
AddEventHandler("Zero:Server-Admin:Clear", function()
    local src = source
    local Player = Zero.Functions.Player(src)
    local inventory = Player.Functions.Inventory()
    
    if Zero.Functions.Role(src, 1) then
        inventory.functions.clear()
        Player.Functions.Notification("System", "Inventory wiped", "warning")
    end
end)

RegisterServerEvent("Zero:Server-Admin:Spawn")
AddEventHandler("Zero:Server-Admin:Spawn", function(item, amount)
    local src = source
    local Player = Zero.Functions.Player(src)
    local inventory = Player.Functions.Inventory()
    local config = exports['zero-inventory']:getConfig().config
    
    local amount = tonumber(amount)

    if config.items[item] then
        if Zero.Functions.Role(src, 1) and item and amount then
            local amount = amount > 0 and amount or 1

            if config.items[item].max then
                amount = amount <= config.items[item].max and amount or config.items[item].max
            else
                amount = 1
            end

            inventory.functions.add({
                item = item,
                amount = amount
            })
            
            Player.Functions.Notification("System", "Item spawned", "warning")
        end
    else
        Player.Functions.Notification("System", "Invalid item", "error")
    end
end)

RegisterServerEvent("Zero:Server-Admin:Announce")
AddEventHandler("Zero:Server-Admin:Announce", function(msg)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Zero.Functions.Role(src, 1)) then
        TriggerClientEvent('chatMessage', -1, "SYSTEM - MEDEDELING ("..Player.User.Name..")", "error", msg)
    end
end)


RegisterServerEvent("Zero:Server-Admin:KillPlayer")
AddEventHandler("Zero:Server-Admin:KillPlayer", function(id)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Zero.Functions.Role(src, 1)) then
        TriggerClientEvent("Zero:Client-Admin:KillPlayer", id)
    end
end)

RegisterServerEvent("Zero:Server-Admin:Freeze")
AddEventHandler("Zero:Server-Admin:Freeze", function(id, bool)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Zero.Functions.Role(src, 1)) then
        TriggerClientEvent("Zero:Client-Admin:Freeze", id, bool)
    end
end)

RegisterServerEvent("Zero:Server-Admin:SetCoord")
AddEventHandler("Zero:Server-Admin:SetCoord", function(id, coord)
    local src = source
    local Player = Zero.Functions.Player(src)

    TriggerClientEvent("Zero:Client-Admin:SetCoord", id, coord)
end)

RegisterServerEvent("Zero:Server-Admin:RequestTp")
AddEventHandler("Zero:Server-Admin:RequestTp", function(id)
    local src = source
    local Player = Zero.Functions.Player(src)

    TriggerClientEvent("Zero:Client-Admin:RequestTp", id, src)
end)

Zero.Commands.Add("goto", "Teleport to player (Admin Only)", {{name = "playerid", help="ID van target speler"}}, true, function(source, args)
    TriggerClientEvent("Zero:Client-Admin:RequestTp", tonumber(args[1]), source)
    Zero.Functions.Notification(source,"Admin", "Teleported to player")
end, 1)
Zero.Commands.Add("bring", "Teleport player to yourself (Admin Only)", {{name = "playerid", help="ID van target speler"}}, true, function(source, args)
    TriggerClientEvent("Zero:Client-Admin:RequestTp", source, tonumber(args[1]))
    Zero.Functions.Notification(source,"Admin", "Teleported player to yourself")
end, 1)

Zero.Commands.Add("freeze", "Freeze Player (Admin Only)", {{name = "playerid", help="ID van target speler"}}, true, function(source, args)
    local id = tonumber(args[1])
    TriggerClientEvent("Zero:Client-Admin:Freeze", id, true)
    Zero.Functions.Notification(source,"Admin", "Player frozen")
end, 1)
Zero.Commands.Add("unfreeze", "Unfreeze Player (Admin Only)", {{name = "playerid", help="ID van target speler"}}, true, function(source, args)
    local id = tonumber(args[1])
    TriggerClientEvent("Zero:Client-Admin:Freeze", id, false)
    Zero.Functions.Notification(source,"Admin", "Player unfrozen")
end, 1)

Zero.Commands.Add("unban", "Unban Player (Admin Only)", {{name = "steam", help="Steam id van player"}}, true, function(source, args)
    local id = args[1]

    Zero.Functions.ExecuteSQL(true, "DELETE FROM `bans` WHERE `steam` = ?", {
        id,
    }, function(changedRows)
        local info = "<br>"
        for k,v in pairs(changedRows) do
            info = info .. "<br>"..tostring(k).." > "..tostring(v)..""
        end

        Zero.Functions.Notification(source, "System", "Unban poging steam: "..id.." <br> SQL DATA: "..info.."", "error", 20000)
    end)
end, 1)

-- server console command
RegisterCommand("c:unban", function(source, args)
    if source == 0 then
        local id = args[1]

        Zero.Functions.ExecuteSQL(true, "DELETE FROM `bans` WHERE `steam` = ?", {
            id,
        }, function(changedRows)
            local info = "<br>"
            for k,v in pairs(changedRows) do
                info = info .. "<br>"..tostring(k).." > "..tostring(v)..""
            end
        end)
    end
end)


RegisterServerEvent("Zero:Server-Admin:Kick")
AddEventHandler("Zero:Server-Admin:Kick", function(id, reason)
    local src = source
    local Player = Zero.Functions.Player(src)
    local id = tonumber(id)

    if (Zero.Functions.Role(src, 1)) then
        Zero.Functions.Kick(id, "Je bent gekicked door een staff lid. \n reden: "..reason.."")
    end
end)

RegisterServerEvent("Zero:Server-Admin:Ban")
AddEventHandler("Zero:Server-Admin:Ban", function(id, reason, time)
    local src = source
    local Player = Zero.Functions.Player(src)
    local id = tonumber(id)

    if (Zero.Functions.Role(src, 1)) then
        Zero.Functions.Ban(id, time, reason, src)
    end
end)


serverTaggs = {}

RegisterServerEvent("Zero:Server-Admin:StaffTagg")
AddEventHandler("Zero:Server-Admin:StaffTagg", function(bool)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Zero.Functions.Role(src, 1)) then

        if bool then
            serverTaggs[src] = GetPlayerName(src)
        else
            serverTaggs[src] = nil
        end

        TriggerClientEvent("Zero:Client-Admin:Taggs", -1, serverTaggs)
    end
end)

-- commands