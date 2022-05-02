exports["zero-core"]:object(function(O) Zero = O end)

local createID = function()
    while true do
        local foundid = nil
        local id = "ART-" .. math.random(11111100, 99999999)

        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `characters` WHERE `citizenid` = ?", {
            id,
        }, function(results)
            if (results[1] == nil) then
                foundid = id
            end
        end)

        if (foundid) then 
            return foundid
        end

        Citizen.Wait(0)
    end
end

local fingerPrint = function()
    while true do
        local foundid = nil
        local id = '#.'..math.random(1111111,9999999)..''

        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `characters` WHERE `genetics` LIKE ?", {
            '%'..id..'%',
        }, function(results)
            if (results[1] == nil) then
                foundid = id
            end
        end)

        if (foundid) then 
            return foundid
        end

        Citizen.Wait(0)
    end
end

RegisterServerEvent("Zero:Server-Character:Logout")
AddEventHandler("Zero:Server-Character:Logout", function()
    DropPlayer(source, "Je bent uigelogd van Zero Roleplay!")
end)

RegisterServerEvent("Zero:Server-Character:Play")
AddEventHandler("Zero:Server-Character:Play", function(slot)
    local _src = source

    if (slot) then
        local steam = Zero.Functions.Identifiers(_src).steam
        local characters = Zero.Functions.Characters(steam)
        local account_chosen = characters[slot]

        if (account_chosen) then
            Zero.Functions.LoadPlayer(_src, account_chosen)
        end
    end
end)

RegisterServerEvent("Zero:Server-Character:ChooseAppartment")
AddEventHandler("Zero:Server-Character:ChooseAppartment", function(index)
    local _src = source
    local Player = Zero.Functions.Player(_src)
    Player.Functions.SetMetaData("appartment", index)
end)


RegisterServerEvent("Zero:Server-Character:Create")
AddEventHandler("Zero:Server-Character:Create", function(data)
    local _src = source
    local data = data

    if (data.firstname and data.lastname and data.slot) then
        local steam = Zero.Functions.Identifiers(_src).steam
        local citizenid = createID()
        local fingerPrint = fingerPrint()
        
        local index, bloodtype = Zero.Functions.Random(Zero.Config.BloodTypes)
        
        Zero.Functions.ExecuteSQL(true, "INSERT INTO `characters` (`citizenid`, `steam`, `slot`, `playerdata`, `metadata`, `money`, `job`, `identifiers`, `genetics`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", {
            citizenid,
            steam,
            data.slot,
            json.encode(data),
            json.encode({}),
            json.encode({
                ['cash'] = Zero.Config.DefaultMoney.cash,
                ['bank'] = Zero.Config.DefaultMoney.bank,
                ['black'] = 0,
            }),
            json.encode(Zero.Config.DefaultJob),
            json.encode(Zero.Functions.Identifiers(_src)),
            json.encode({
                bloodtype = bloodtype,
                fingerprint = fingerPrint,

            })
        }, function()
            TriggerClientEvent("Zero:Client-Character:Update", _src, Zero.Functions.Characters(steam))
        end)
    end
end)