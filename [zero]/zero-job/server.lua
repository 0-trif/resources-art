exports["zero-core"]:object(function(O) Zero = O end)

RegisterServerEvent("Zero:Server-job:Duty")
AddEventHandler("Zero:Server-job:Duty", function(bool)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (bool == nil) then
        local old = Player.Job.duty
        bool = not bool
        Player.Functions.SetDuty(bool)
    else
        Player.Functions.SetDuty(bool)
    end

    if bool then
        Player.Functions.Notification("Duty", "Je bent nu in dienst", "success", 5000)
    else    
        Player.Functions.Notification("Duty", "Je bent nu uit dienst", "error", 5000)
        TriggerEvent("dispatch:remove", src)
    end
end)

local Objects = {}
function CreateObjectId()
    if Objects ~= nil then
		local objectId = math.random(10000, 99999)
		while Objects[caseId] ~= nil do
			objectId = math.random(10000, 99999)
		end
		return objectId
	else
		local objectId = math.random(10000, 99999)
		return objectId
	end
end

RegisterServerEvent('police:server:spawnObject')
AddEventHandler('police:server:spawnObject', function(type, coords)
    local src = source
    local objectId = CreateObjectId()
    Objects[objectId] = type
    TriggerClientEvent("police:client:spawnObject", -1, objectId, type, src, coords)
end)

RegisterServerEvent('police:server:deleteObject')
AddEventHandler('police:server:deleteObject', function(objectId)
    local src = source
    TriggerClientEvent('police:client:removeObject', -1, objectId)
end)

RegisterServerEvent('police:server:SyncSpikes')
AddEventHandler('police:server:SyncSpikes', function(table)
    TriggerClientEvent('police:client:SyncSpikes', -1, table)
end)

whitelisted_billing = {
    ["ambulance"] = true,
    ["police"] = true,
    ["mechanic"] = true,
    ["taxi"] = true,
}

getReason = function(x) 
    local _ = ""

    table.remove(x, 1)
    table.remove(x, 1)

    for k,v in pairs(x) do
        _ = _ .. " " .. v
    end

    return _
end

RegisterCommand("bill", function(src, args)
    local id = tonumber(args[1])
    local amount = tonumber(args[2])

    if args[3] then
        local reason = getReason(args)


        if (id and amount and reason) then
            local Player = Zero.Functions.Player(src)
            local Target = Zero.Functions.Player(id)

            if Target then
                if (whitelisted_billing[Player.Job.name]) then
                    Zero.Functions.ExecuteSQL(true, "INSERT INTO `meos-fines` (`citizenid`, `price`, `artikel`, `creator`, `job`) VALUES (?, ?, ?, ?, ?)", {
                        Target.User.Citizenid, 
                        amount,
                        reason,
                        Player.PlayerData.firstname .. " " ..  Player.PlayerData.lastname,
                        Player.Job.name,
                    },function(result)
                        Player.Functions.Notification("Factuur", "Je hebt een factuur gestuurd")
                        Target.Functions.Notification("Factuur", "Je hebt een factuur ontvangen")
                    end)
                else
                    Player.Functions.Notification("Factuur", "Je kan geen facturen sturen")
                end
            end
        end
    end
end)

RegisterServerEvent("Zero:Server-Job:MoneySafe")
AddEventHandler("Zero:Server-Job:MoneySafe", function()
    local src = source
    local player = Zero.Functions.Player(src)
    local job = player.Job.name 

    if job == "mechanic" or job == "police" or job == "ambulance" or job == "taxi" then
        local job_grade = player.Job.grade
        if (job_grade == #Zero.Config.Jobs[job].grades) then
            exports['zero-inventory']:openstash({
                index = job .. "-safe",
                database = "job-inv",
                slots = 24,
                src = src,
                label = "Kluis",
                event = "inventory:server:stash",
            })
            
        end
    end
end)
