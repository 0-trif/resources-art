player = {
    ['Functions'] = {},
    ['PlayerData'] = {},
    ['MetaData'] = {},
    ['Money'] = {},
    ['Job'] = {},
    ['Crew'] = {},
    ['User'] = {},
    ['Skin'] = nil,
    ['Vehicles'] = {},
    ['Genetics'] = {},
}

function player:new(x)
    x = x or {}
    setmetatable(x, self)
    self.__index = self
    return x
end

function player:functions(playerid)
    local _ = {}

    
    _.Kick = function()
        print('kick: ' .. playerid)
    end

    _.Update = function()
        TriggerClientEvent("Zero:Client-Core:UpdateStats", playerid, {
            MetaData = Zero.Players[playerid].MetaData,
            PlayerData = Zero.Players[playerid].PlayerData,
            Money = Zero.Players[playerid].Money,
            Job = Zero.Players[playerid].Job,
            Crew = Zero.Players[playerid].Crew,
            Vehicles = Zero.Players[playerid].Vehicles,
            Skin = Zero.Players[playerid].Skin,
        })
    end

    _.SetMetaData = function(x,y)
        Zero.Players[playerid].MetaData[x] = y
        Zero.Players[playerid].Functions.Update()
    end

    _.GetPlayerVehicles = function()
        return Zero.Players[playerid].Vehicles
    end

    _.SetVehicleLocation = function(plate, location, fuel, coord)
        Zero.Players[playerid].Vehicles[plate]['location'] = location
        Zero.Players[playerid].Vehicles[plate]['coord'] = coord ~= nil and coord or {}
        Zero.Players[playerid].Vehicles[plate]['fuel'] = fuel ~= nil and fuel or 100

        Zero.Functions.ExecuteSQL(false, "UPDATE `citizen_vehicles` SET `location` = @location, `fuel` = @fuel, `coord` = @coord WHERE `plate` = @plate", {
            ['@location'] = location,
            ['@fuel'] = fuel,
            ['@plate'] = plate,
            ['@coord'] = coord ~= nil and json.encode(coord) or json.encode({})
        })

        Zero.Players[playerid].Functions.Update()
    end

    _.SetVehicleMods = function(plate, mods)
        if Zero.Players[playerid].Vehicles[plate] then
            Zero.Players[playerid].Vehicles[plate]['mods'] = mods

            Zero.Functions.ExecuteSQL(false, "UPDATE `citizen_vehicles` SET `mods` = ? WHERE `plate` = ?", {
                json.encode(mods),
                plate,
            })

            Zero.Players[playerid].Functions.Update()
        end
    end


    _.AddVehicle = function(plate)
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `plate` = ?", {
            plate,
        }, function(result)
            if result[1] then
                result[1]['location'] = result[1]['location'] ~= nil and result[1]['location'] or "*"
                result[1]['mods'] = result[1]['mods'] ~= nil and json.decode(result[1]['mods']) or {}
                Zero.Players[playerid].Vehicles[plate] = result[1]

                Zero.Players[playerid].Functions.Update()
            end
        end)
    end

    _.RemoveVehicle = function(plate)
        Zero.Functions.ExecuteSQL(true, "DELETE FROM `citizen_vehicles` WHERE `plate` = ?", {
            plate,
        })
        Zero.Players[playerid].Vehicles[plate] = nil
        Zero.Players[playerid].Functions.Update()
    end

    _.SetDuty = function(bool)
        Zero.Players[playerid].Job.duty = bool
        Zero.Players[playerid].Functions.Update()
        TriggerClientEvent("Zero:Client-Core:JobUpdate", playerid, Zero.Players[playerid].Job)
    end

    _.SetJob = function(job, grade)
        Zero.Players[playerid].Job.name = job
        Zero.Players[playerid].Job.grade = grade ~= nil and tonumber(grade) or 0
        Zero.Players[playerid].Job.specialized = {}

        Zero.Players[playerid].Functions.Update()
        
        TriggerClientEvent("Zero:Client-Core:JobUpdate", playerid, Zero.Players[playerid].Job)
    end

    _.SetSkin = function(skindata)
        Zero.Players[playerid].Skin = skindata
        Zero.Players[playerid].Functions.Update()
    end

    _.GiveMoney = function(type, amount, reason, extra)
        local amount = tonumber(amount)
        if not amount then return end

        local amount = Zero.Functions.Round(amount)

        if Zero.Players[playerid].Money[type] then
            Zero.Players[playerid].Money[type] = tonumber(Zero.Players[playerid].Money[type])

            Zero.Players[playerid].Money[type] = Zero.Players[playerid].Money[type] + amount
        end
        Zero.Players[playerid].Functions.Update()

        TriggerClientEvent("Zero:Client-Core:MoneyAltered", playerid, type, true, amount, reason, extra)

        if Zero.Players[playerid] and Zero.Players[playerid].User then
            if type and amount and reason then
                Zero.Functions.CreateLog("money", "Geld aanpassing", "Geld aan speler gegeven: \n **Type:** "..type.." \n **Hoeveelheid:** "..amount.." **Reden:** "..reason.." \n \n **Citizenid:** ".. Zero.Players[playerid].User.Citizenid .." \n **Identifier:** "..Zero.Players[playerid].User.Identifier.." \n **Source:** "..playerid.." \n **PlayerName:** "..Zero.Players[playerid].User.Name.." \n **Discord:** ".. Zero.Players[playerid].User.Discord .."", "green", false)
            end
        end
    end

    _.GetMoney = function(type)
        return Zero.Players[playerid].Money[type]
    end

    _.RemoveMoney = function(type, amount, reason, extra)
        local amount = tonumber(amount)
        if not amount then return end
        
        local amount = Zero.Functions.Round(amount)

        if Zero.Players[playerid].Money[type] then
            Zero.Players[playerid].Money[type] = tonumber(Zero.Players[playerid].Money[type])

            Zero.Players[playerid].Money[type] = Zero.Players[playerid].Money[type] - amount >= 0 and Zero.Players[playerid].Money[type] - amount or 0
        end

        Zero.Players[playerid].Functions.Update()

        TriggerClientEvent("Zero:Client-Core:MoneyAltered", playerid, type, false, amount, reason, extra)
        Zero.Functions.CreateLog("money", "Geld aanpassing", "Geld van speler afgehaald: \n **Type:** "..type.." \n **Hoeveelheid:** "..amount.." \n **Reden:** "..reason.."  \n \n **Citizenid:** ".. Zero.Players[playerid].User.Citizenid .." \n **Identifier:** "..Zero.Players[playerid].User.Identifier.." \n **Source:** "..playerid.." \n **PlayerName:** "..GetPlayerName(playerid).." **Discord:** ".. Zero.Players[playerid].User.Discord .."", "red", false)
    end

    _.ValidRemove = function(amount, reason, cb, extra)
        if Zero.Players[playerid].Money.bank >= amount then
            Zero.Players[playerid].Functions.RemoveMoney('bank', amount, reason, extra)
            cb(true)
            return
        elseif (Zero.Players[playerid].Money.cash >= amount) then
            Zero.Players[playerid].Functions.RemoveMoney('cash', amount, reason, extra)
            cb(true)
            return
        end
        cb(false)
    end

    _.Notification = function(title, message, type, time)
        TriggerClientEvent("Zero-notifications:client:alert", playerid, title, message, type, time)
    end

    _.Save = function(bool)
        if bool then
            Zero.Functions.CreateLog("server", "Player left", "Speler is uitgelogd en opgeslagen: \n **Citizenid:** ".. Zero.Players[playerid].User.Citizenid .." \n **Identifier:** "..Zero.Players[playerid].User.Identifier.." \n **Source:** "..playerid.." \n **PlayerName:** "..GetPlayerName(playerid).." **Discord:** ".. Zero.Players[playerid].User.Discord .."", "red", false)
        end
        
        Zero.Functions.ExecuteSQL(true, "UPDATE `characters` SET `playerdata` = ?, `metadata` = ?, `money` = ?, `job` = ?, `skin` = ?, `crew` = ? WHERE `citizenid` = ?", {
            json.encode(Zero.Players[playerid].PlayerData),
            json.encode(Zero.Players[playerid].MetaData),
            json.encode(Zero.Players[playerid].Money),
            json.encode(Zero.Players[playerid].Job),
            json.encode(Zero.Players[playerid].Skin),
            json.encode(Zero.Players[playerid].Crew),
            Zero.Players[playerid].User.Citizenid,
        })
    end

    _.SetCrew = function(name, level)
        local name = tostring(name)
        local level = tonumber(level)

        if Zero.Config.Crews[name] then
            level = level <= #Zero.Config.Crews[name].grades and level or #Zero.Config.Crews[name].grades
            Zero.Players[playerid].Crew = {
                name = name,
                level = level
            }
            Zero.Players[playerid].Functions.Update()
            Zero.Players[playerid].Functions.Notification("Groep", "Uw nieuwe groep is nu ("..Zero.Config.Crews[name].label..") Level: "..Zero.Config.Crews[name].grades[level].label.."", "success", 5000)
        end
    end

    _.Crew = function()
        return Zero.Players[playerid].Crew
    end

    _.Inventory = function()
        local x = exports['zero-inventory']:receiveUser(playerid)
        return x
    end

    return _
end