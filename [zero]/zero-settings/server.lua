settings = {}
exports['zero-core']:object(function(O) Zero = O end)

RegisterServerEvent("Zero:Server-Settings:Request")
AddEventHandler("Zero:Server-Settings:Request", function()
    local src = source
    local player = Zero.Functions.Player(src)
    
    create(player, function(x)
        settings[src] = x

        settings[src].rpname = player.PlayerData.firstname .. " ".. player.PlayerData.lastname
        settings[src].name = GetPlayerName(src)
        settings[src].id = src

        TriggerClientEvent("Zero:Client-Settings:Resync", src, settings[src])
    end)
end)

AddEventHandler("playerDropped", function()
    local src = source
    local player = Zero.Functions.Player(src)

    if (settings[src]) then
        Zero.Functions.ExecuteSQL(false, "UPDATE `settings` SET `background` = ?, `keybinds` = ? WHERE `citizenid` = ?", {
            json.encode(settings[src].background),
            json.encode(settings[src].keybinds),
            player.User.Citizenid
        })
    end
end)

create = function(player, cb)
    local src = player.User.Source
    local citizenid = player.User.Citizenid

    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `settings` WHERE `citizenid` = ?", {
        citizenid
    }, function(result)
        if result[1] then
            settings[src] = {
                ['background'] = json.decode(result[1].background) ~= nil and json.decode(result[1].background) or {},
                ['keybinds'] = json.decode(result[1].keybinds) ~= nil and json.decode(result[1].keybinds) or {}
            }
            cb(settings[src])
        else
            Zero.Functions.ExecuteSQL(false, "INSERT INTO `settings` (`citizenid`, `background`, `keybinds`) VALUES (?, ?, ?)", {
                citizenid,
                json.encode({}),
                json.encode({})
            })

            settings[src] = {background = {}, keybinds = {}}
            cb(settings[src])
        end
    end)
end

RegisterServerEvent("Zero:Server-Settings:SetBackground")
AddEventHandler("Zero:Server-Settings:SetBackground", function(type, value)
    local src = source
    local player = Zero.Functions.Player(src)

    settings[src]['background'][type] = value

    TriggerClientEvent("Zero:Client-Settings:Resync", source, settings[src])
end)

RegisterServerEvent("Zero:Server-Settings:AddKeybind")
AddEventHandler("Zero:Server-Settings:AddKeybind", function(key, command)
    local src = source
    local player = Zero.Functions.Player(src)

    if key then
        settings[src].keybinds[key] = command
        TriggerClientEvent("Zero:Client-Settings:Resync", src, settings[src])
    end
end)