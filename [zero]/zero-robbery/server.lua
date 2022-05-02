local safes = {}

exports['zero-core']:object(function(O) Zero = O end)

RegisterServerEvent("Zero:Server-Robbery:Request")
AddEventHandler("Zero:Server-Robbery:Request", function()
    TriggerClientEvent("Zero:Client-Robbery:UpdateSafes", source, safes)
end)

RegisterServerEvent("Zero:Server-Robbery:CheckSafe")
AddEventHandler("Zero:Server-Robbery:CheckSafe", function(safeId)
    local src = source
    local Player = Zero.Functions.Player(src)

    safes[safeId] = safes[safeId] ~= nil and safes[safeId] or {
        locked = true,
    }

    if (safes[safeId]['locked']) then
        safes[safeId]['locked'] = false
    else
        print('ban')
    end
    
    if not safes[safeId]['locked'] then

        local cash = math.random(30, 60)
        Player.Functions.GiveMoney("cash", cash, "Speler heeft winkel overval gedaan")

        if cash > 50 then
            local metadata = Player.MetaData
            local level = metadata.CraftingLevel ~= nil and tonumber(metadata.CraftingLevel) or 0
            level = level + 15

            Player.Functions.Notification('Skill', '+15 Crafting skill', 'success')
            Player.Functions.SetMetaData('CraftingLevel', level)
        end
        
        TriggerClientEvent("Zero:Client-Robbery:UpdateSafes", -1, safes)
    end
end)

Citizen.CreateThread(function()
    while true do
        print("^4[^0Zero-robbery^4]: ^2 Store robbery's has been reset (reset in 45 min)^0")

        for k,v in pairs(safes) do
            v.locked = true
        end

        Wait(60000 * 45)
    end
end)