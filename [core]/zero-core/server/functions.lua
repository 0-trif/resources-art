Zero.Functions = Zero.Functions ~= nil and Zero.Functions or {}

Zero.Functions.Identifiers = function(id)
    local identifiers = GetPlayerIdentifiers(id)
    local _ = {}

    for k,v in pairs(identifiers) do
        if (string.find(v, "steam")) then
            _['steam'] = v
        end
--[[
            if (string.find(v, "ip")) then
            _['ip'] = v
        end
]]
        if (string.find(v, "license")) then
            _['license'] = v
        end
        if (string.find(v, "discord")) then
            _['discord'] = v
        end
        _['hwid'] = GetPlayerToken(id, 0)
    end

    _['discord'] = _['discord'] ~= nil and _['discord'] or "Geen discord gevonden"
    
    return _
end

Zero.Functions.SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end

Zero.Functions.Role = function(id, level)
    if level == 0 then
        return true
    end
    
    if (Zero.Admins[Zero.Players[id].User.Identifier]) then
        if (Zero.Admins[Zero.Players[id].User.Identifier] >= level) then
            return true
        end
    else
        return false
    end
end

Zero.Functions.ExecuteSQL = function(wait, query, params, cb)
	local rtndata = {}
	local waiting = true
	exports.ghmattimysql:execute(query, params, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

Zero.Functions.Characters = function(steam)
    characters = {}

    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `characters` WHERE `steam` = ?", {
        steam,
    }, function(chars)
        characters = chars
    end)

    local _ = {}
    for k,v in pairs(characters) do
        v.slot = tonumber(v.slot)

        _[v.slot] = v
        _[v.slot].playerdata = json.decode(_[v.slot].playerdata) ~= nil and json.decode(_[v.slot].playerdata) or {}
        _[v.slot].metadata = json.decode(_[v.slot].metadata) ~= nil and json.decode(_[v.slot].metadata) or {}
        _[v.slot].genetics = json.decode(_[v.slot].genetics) ~= nil and json.decode(_[v.slot].genetics) or {}
        _[v.slot].money = json.decode(_[v.slot].money)
        _[v.slot].skin = json.decode(_[v.slot].skin)
        _[v.slot].job = json.decode(_[v.slot].job)
    end
    
    return _
end

Zero.Functions.LoadPlayer = function(_src, accountData)
    accountData.job = accountData.job ~= nil and accountData.job or Zero.Config.DefaultJob
    accountData.crew = accountData.crew ~= nil and accountData.crew or Zero.Config.DefaultCrew

    for k,v in pairs(Zero.Config.Coins) do
        accountData.money[k] = accountData.money[k] ~= nil and tonumber(accountData.money[k]) or 0
        accountData.money[k] = accountData.money[k] >= 0 and accountData.money[k] or 0
    end
    
    Zero.Players[_src] = player:new({
        User = {
            ['Slot'] = accountData.slot,
            ['Identifier'] = Zero.Functions.Identifiers(_src).steam,
            ['Citizenid'] = accountData.citizenid,
            ['Discord'] = Zero.Functions.Identifiers(_src).discord,
            ['Name'] = GetPlayerName(_src),
            ['Source'] = _src,
        },
        Job = {
            ['name'] = accountData.job.name ~= nil and accountData.job.name or "unemployed",
            ['grade'] = accountData.job.grade ~= nil and accountData.job.grade or 0,
            ['specialized'] = accountData.job.specialized ~= nil and accountData.job.specialized or {},
            ['duty'] = false,
        },

        Vehicles = Zero.Functions.PlayerVehicles(accountData.citizenid),
    
        PlayerData = accountData.playerdata,
        Genetics = accountData.genetics,

        MetaData = accountData.metadata,
        Money = accountData.money,
        Skin = accountData.skin,
        Functions = player:functions(_src)
    })
    
    Zero.Commands.Refresh(_src)
    Zero.Functions.PlayerLoaded(_src)
    
    updatePlayers()

    Zero.Functions.Debug("Player with CID - ^2"..Zero.Players[_src].User.Citizenid.."^0 Loaded")
end

Zero.Functions.PlayerLoaded = function(playerid)
    TriggerClientEvent("Zero:Client-Character:CloseUI", playerid)
    TriggerClientEvent("Zero:Client-Core:PlayerLoaded", playerid, {
        MetaData = Zero.Players[playerid].MetaData,
        PlayerData = Zero.Players[playerid].PlayerData,
        Money = Zero.Players[playerid].Money,
        Job = Zero.Players[playerid].Job,
        Skin = Zero.Players[playerid].Skin,
        Crew = Zero.Players[playerid].Crew,
        Vehicles = Zero.Players[playerid].Vehicles,
        User = Zero.Players[playerid].User
    })
    Zero.Functions.CreateLog("server", "Player loaded", "Speler is ingeladen: \n **Citizenid:** ".. Zero.Players[playerid].User.Citizenid .." \n **Identifier:** "..Zero.Players[playerid].User.Identifier.." \n **Source:** "..playerid.." \n **PlayerName:** "..GetPlayerName(playerid).." \n **Discord:** ".. Zero.Players[playerid].User.Discord .."", "green", false)
end

Zero.Functions.Player = function(src)
    return Zero.Players[src]
end

Zero.Functions.PlayerByCitizenid = function(cid)
    for k,v in pairs(Zero.Players) do
        if (v.User.Citizenid == cid) then 
            return v
        end
    end
end

Zero.Functions.Notification = function(src, title, message, type, time)
    TriggerClientEvent("Zero-notifications:client:alert", src, title, message, type, time)
end

Zero.Functions.Round = function(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10^numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    else
        return math.floor(value + 0.5)
    end
end

Zero.Functions.CreateLog = function(type, title, message, color, tag)
    if (Zero.Config.Logs[type]) then
        local webhook = Zero.Config.Logs[type]

        local embedData = {
            {
                ["title"] = title,
                ["color"] = Zero.Config.Colors[color] ~= nil and Zero.Config.Colors[color] or Zero.Config.Colors["default"],
                ["footer"] = {
                    ["text"] = os.date("%c"),
                },
                ["description"] = message,
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({avatar_url = "https://i.pinimg.com/736x/33/28/4c/33284c57c53f11f898ace1dd7075c878.jpg", username = "Zero Logs", embeds = embedData}), { ['Content-Type'] = 'application/json' })
        Citizen.Wait(100)

        if tag then
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({avatar_url = "https://i.pinimg.com/736x/33/28/4c/33284c57c53f11f898ace1dd7075c878.jpg", username = "Zero Logs", content = "@everyone"}), { ['Content-Type'] = 'application/json' })
        end
    end
end

Zero.Functions.PlayerVehicles = function(citizenid)
    local _ = {}
    local playerVehicles = {}

    _done = false

    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `citizenid` = ?", {
        citizenid,
    }, function(result)
        playerVehicles = result

        for k,v in pairs(playerVehicles) do
            v['location'] = v['location'] ~= nil and v['location'] or "*"
            v['mods'] = v['mods'] ~= nil and json.decode(v['mods']) or {}
            v['fuel'] = v['fuel'] ~= nil and v['fuel'] or 100
            v['coord'] = v['coord'] ~= nil and json.decode(v['coord']) or {}
    
            _[v.plate] = v
        end

        _done = true
    end)

    while _done == false do Wait(0) end

    return _
end

Zero.Functions.CreateCallback = function(name, cb)
	Zero.ServerCallbacks[name] = cb
end

Zero.Functions.TriggerCallback = function(name, source, cb, ...)
	if Zero.ServerCallbacks[name] ~= nil then
		Zero.ServerCallbacks[name](source, cb, ...)
	end
end

Zero.Functions.Players = function(job, bool)
    return Zero.Players
end

Zero.Functions.GetPlayersByJob = function(job, bool)
    local _ = {}

    for k,v in pairs(Zero.Players) do
        if (v.Job.name == job) then
            if (bool) then
                if v.Job.duty then
                    table.insert(_, v)
                end
            else
                table.insert(_, v)
            end
        end
    end

    return _
end

Zero.Functions.RegisterItem = function(...)
    exports['zero-inventory']:register(...)
end

Zero.Functions.Kick = function(id, reason)
    DropPlayer(id, reason)
end

Zero.Functions.Ban = function(id, time, reason, source)
    local time = getBanTime(time)

    if (source == "ac" or Zero.Functions.Role(source, 1)) then
        local time = tonumber(time)

        local srcName = source ~= "ac" and GetPlayerName(source) or "ac"
        
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end

        local timeTable = os.date("*t", banTime)
        local identifiers = Zero.Functions.Identifiers(id)

        exports.ghmattimysql:execute('INSERT INTO bans (name, license, discord, steam, hwid, reason, expire, bannedby) VALUES (@name, @license, @discord, @steam, @hwid, @reason, @expire, @bannedby)', {
            ['@name'] = GetPlayerName(id),
            ['@license'] = identifiers.license,
            ['@discord'] = identifiers.discord,
            ['@steam'] = identifiers.steam,
            ['@hwid'] = identifiers.hwid,
            ['@reason'] = reason,
            ['@expire'] = banTime,
            ['@bannedby'] = srcName
        })

        TriggerClientEvent('chatMessage', -1, "SYSTEM - (BAN)", "error", "Speler "..GetPlayerName(id).." is gebanned")

        if banTime >= 2147483647 then
            DropPlayer(id, "Je bent gebanned:\n" .. reason .. "\n\nJe ban is permanent.\n | Kijk op de discord voor meer informatie: "..Zero.Config.Discord.."")
        else
            DropPlayer(id, "Je bent gebanned:\n" .. reason .. "\n\nBan loopt af: " .. timeTable["day"] .. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"] .. ":" .. timeTable["min"] .. "\n| Kijk op de discord voor meer informatie: "..Zero.Config.Discord.."")
        end

        Zero.Functions.CreateLog("admins", "Player banned", "**Player Steam:** "..identifiers.steam.." \n **Reason:**"..reason.." **Banned by:** "..srcName.."", "error", false)
    end
end


Zero.Functions.oBan = function(stateid, time, reason, source)
    local time = getBanTime(time)

    if (Zero.Functions.Role(source, 1)) then
        local time = tonumber(time)
        
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end

        local timeTable = os.date("*t", banTime)

        local stateid = stateid
        
        exports.ghmattimysql:execute('SELECT * FROM `characters` WHERE `citizenid` = "'..stateid..'"', function(result)
            if (result[1]) then
                local steam = result[1].steam
                local identifiers = json.decode(result[1].identifiers)

                exports.ghmattimysql:execute('INSERT INTO bans (name, license, discord, steam, hwid, reason, expire, bannedby) VALUES (@name, @license, @discord, @steam, @hwid, @reason, @expire, @bannedby)', {
                    ['@name'] = "Unknown",
                    ['@license'] = identifiers.license,
                    ['@discord'] = identifiers.discord,
                    ['@steam'] = steam,
                    ['@hwid'] = identifiers.hwid,
                    ['@reason'] = reason,
                    ['@expire'] = banTime,
                    ['@bannedby'] = GetPlayerName(source)
                })
        
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-message server"><strong>SYSTEM | {0} Is gebanned voor:</strong> {1}</div>',
                    args = {GetPlayerName(id), reason}
                })
            end
        end)
    end
end

Zero.Functions.Banned = function (source)
	local retval = false
	local message = ""
    local result = exports.ghmattimysql:executeSync('SELECT * FROM bans WHERE hwid=@hwid OR license=@license OR steam=@steam', {['@hwid'] = Zero.Functions.Identifiers(source).hwid, ['@license'] =  Zero.Functions.Identifiers(source).license, ['@steam'] = Zero.Functions.Identifiers(source).steam})

    if result[1] ~= nil then
        if os.time() < result[1].expire then
            retval = true
            local timeTable = os.date("*t", tonumber(result[1].expire))
            message = "Je bent gebanned van de server:\n"..result[1].reason.."\nBan loopt af in "..timeTable.day.. "/" .. timeTable.month .. "/" .. timeTable.year .. " " .. timeTable.hour.. ":" .. timeTable.min .. "\n Kijk op de discord voor meer informatie: "..Zero.Config.Discord..""
        else
            exports['ghmattimysql']:execute('DELETE FROM bans WHERE id=@id', {['@id'] = result[1].id})
        end
    end
	return retval, message
end

Zero.Functions.Random = function(data)
    local id = math.random(1, #data)
    return id, data[id]
end

Zero.Functions.Debug = function(txt, resourceName)
    local resourceName = resourceName ~= nil and resourceName or GetCurrentResourceName()
    print('^0[^3SCRIPT:'..resourceName..'^0]^1: ' .. txt)
end

-- core functions

updatePlayers = function()
    local _ = 0
    
    for k,v in pairs(Zero.Players) do
        _ = _ + 1
    end

    TriggerClientEvent("Zero:Client-Core:UpdatePlayers", -1, _)
end

getBanTime = function(time)
    if string.find(time, "h") then
        time = string.gsub(time, "h", "")
        time = time * 60
        time = time * 60
    elseif string.find(time, "d") then
        time = string.gsub(time, "d", "")
        time = time * 60
        time = time * 60
        time = time * 24
    elseif string.find(time, "m") and not time == 'perm' then
        time = string.gsub(time, "m", "")
        time = time * 60
        time = time * 60
        time = time * 24
        time = time * 30
    end
	
	if time == 'perm' then
        time = 2147483647
    end
    return time
end