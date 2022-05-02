exports["zero-core"]:object(function(O) Zero = O end)

RegisterServerEvent("Zero:Server-Prison:SetJailTime")
AddEventHandler("Zero:Server-Prison:SetJailTime", function(playerid, time)
    local src = source
    local playerid = tonumber(playerid)
    local time = tonumber(time)

    if not time then return end
    local player = Zero.Functions.Player(src)
    local target = Zero.Functions.Player(playerid)

    if (time <= 0) then return end

    if (player.Job.name == "police") then
        if (target) then
            target.Functions.SetMetaData("jailtime", time)
            TriggerClientEvent("Zero:Client-Prison:SetJail", playerid)

            local InventoryPlayer = exports['zero-inventory']:user(playerid)
            target.Functions.SetMetaData("prison_inv", InventoryPlayer.inventory)
            InventoryPlayer.functions.clear()
        end 
    end
end)


RegisterServerEvent("Zero:Server-Prison:Escaped")
AddEventHandler("Zero:Server-Prison:Escaped", function()
    local src = source
    local player = Zero.Functions.Player(src)

    local time = player.MetaData.jailtime

    player.Functions.SetMetaData("jailtime", nil)

    local prison_inv = player.MetaData.prison_inv
    local InventoryPlayer = exports['zero-inventory']:user(src)

    prison_inv = prison_inv ~= nil and prison_inv or {}

    InventoryPlayer.functions.set(prison_inv)

    player.Functions.SetMetaData("prison_inv", nil)
    
    local lastLatestI = string.sub(player.PlayerData.lastname, 1, 1)
    local text = player.PlayerData.firstname .. " " .. string.upper(lastLatestI) .. " is ontsnapt uit de gevangenis"

    TriggerClientEvent('chatMessage', -1, "Gevangenis", "error", text)
end)


RegisterServerEvent("Zero:Server-Prison:RemoveTime")
AddEventHandler("Zero:Server-Prison:RemoveTime", function()
    local src = source
    local player = Zero.Functions.Player(src)

    local time = player.MetaData.jailtime

    if (time and time > 0) then
        time = time - 1
        player.Functions.SetMetaData("jailtime", time)
    end
end)

RegisterNetEvent("Zero:Server-Prison:ReleasePrison")
AddEventHandler("Zero:Server-Prison:ReleasePrison", function()
    local src = source
    local player = Zero.Functions.Player(src)

    if (player.MetaData.jailtime <= 0) then
        TriggerClientEvent("Zero:Client-Prison:Release", src)

        local prison_inv = player.MetaData.prison_inv
        local InventoryPlayer = exports['zero-inventory']:user(src)

        prison_inv = prison_inv ~= nil and prison_inv or {}

        InventoryPlayer.functions.set(prison_inv)
        player.Functions.SetMetaData("prison_inv", nil)
    end
end)
