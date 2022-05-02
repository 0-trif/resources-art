Zero.Functions.CreateCallback('Zero:Server-Police:CanCarry', function(source, cb, id)
    local id = id
    local player = Zero.Functions.Player(id)
    if player.MetaData["ishandcuffed"] or player.MetaData["dead"] then
        cb(true)
    else
        cb(false)
    end
end)



RegisterServerEvent("Zero:Server-job:PoliceFines")
AddEventHandler("Zero:Server-job:PoliceFines", function(cb)
    cb(Shared.Police.Fines)
end)

RegisterCommand("roepnummer", function(src, args)
    local roepnummer = args[1]

    local Player = Zero.Functions.Player(src)
    Player.Functions.SetMetaData("callid", roepnummer)
end)

RegisterServerEvent("Zero:Server-Police:UseCuffs")
AddEventHandler("Zero:Server-Police:UseCuffs", function(id, bool)
    local src = source
    local Player = Zero.Functions.Player(src)
    local CuffedPlayer = Zero.Functions.Player(id)

    if CuffedPlayer ~= nil then
        if (CuffedPlayer.MetaData["ishandcuffed"]) then
            TriggerClientEvent("Zero:Client-job:GetCuffs", id, src, CuffedPlayer.MetaData["ishandcuffed"])
            CuffedPlayer.Functions.SetMetaData("ishandcuffed", false)
            TriggerClientEvent("Zero:Client-Police:unCuffAnimation", src) 
        else
            TriggerClientEvent("Zero:Client-job:GetCuffs", id, src, CuffedPlayer.MetaData["ishandcuffed"]) 
            CuffedPlayer.Functions.SetMetaData("ishandcuffed", true)
            TriggerClientEvent("Zero:Client-Police:HandCuffAnimation", src) 
        end  
    end
end)

local toggle_walk = {}
RegisterServerEvent("Zero:Server-Police:ToggleWalking")
AddEventHandler("Zero:Server-Police:ToggleWalking", function(id)
    local CuffedPlayer = Zero.Functions.Player(id)

    if (CuffedPlayer.MetaData["ishandcuffed"]) then
        toggle_walk[id] = toggle_walk[id] ~= nil and toggle_walk[id] or false
        toggle_walk[id] = not toggle_walk[id]

        TriggerClientEvent("Zero:Client-Police:Walking", id, toggle_walk[id])
    else
        Zero.Functions.Notification(source, "Handboeien", "Speler is niet gehandboeid", "error")
    end
end)

RegisterServerEvent("Zero:Server-Police:EscortPlayer")
AddEventHandler("Zero:Server-Police:EscortPlayer", function(id)
    local src = source
    local Player = Zero.Functions.Player(source)
    local Target = Zero.Functions.Player(id)

    if not Target then return end

    if (Player.Job.name == "police" or Player.Job.name == "kmar" or Player.Job.name == "ambulance") or (Target.MetaData["ishandcuffed"] or Target.MetaData["dead"]) then
        TriggerClientEvent("Zero:Client-Police:Drag", Target.User.Source, Player.User.Source)
    else
        TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Persoon is niet dood of geboeid")
    end
end)

RegisterServerEvent("Zero:Server-Police:SetVehicle")
AddEventHandler("Zero:Server-Police:SetVehicle", function(id)
    local src = source
    local Target = Zero.Functions.Player(id)

    if not Target then return end

    if Target.MetaData["ishandcuffed"] then
        TriggerClientEvent("Zero:Client-Police:SetInVehicleAneefWholla", id)
    else
        Zero.Functions.Notification(src, 'Systeem', 'Je moet de speler eerst handboeien', 'error')
    end
end)

RegisterServerEvent("Zero:Server-Police:TaskLeaveVehicle")
AddEventHandler("Zero:Server-Police:TaskLeaveVehicle", function(plate)
    local src = source

    TriggerEvent("Zero:Server-BaseEvents:PlayersInVehicle", plate, function(players)
        for k,v in pairs(players) do
            local ply = Zero.Functions.Player(k)
            if ply.MetaData.ishandcuffed then
                TriggerClientEvent("Zero:Client-Police:SetOutVehicle", k)
                break
            end
        end
    end)
end)

local function SortKloesoe(job, grade)
    local _ = {}

    for k,v in pairs(Shared.Config[job].Kloesoe) do
        if k <= grade then
            for k,v in pairs(v) do
                table.insert(_, v)
            end
        end
    end

    slot = 0
    for k,v in pairs(_) do
        v.slot = slot + 1
        slot = slot + 1
    end

    return _
end


RegisterNetEvent("Zero:Server-Police:OpenKloesoe")
AddEventHandler("Zero:Server-Police:OpenKloesoe", function()
    local src = source
    local Player = Zero.Functions.Player(src)
    
    local grade = Player.Job.grade
    local items = SortKloesoe(Player.Job.name, grade)

    TriggerClientEvent("Zero:Client-Police:OpenKloesoe", src, items)
end)

RegisterNetEvent("Zero:Server-Police:EvidenceRoom")
AddEventHandler("Zero:Server-Police:EvidenceRoom", function()
    local src = source
    local Player = Zero.Functions.Player(src)
    local job = Player.Job.name

    if job == "police" or job == "kmar" then
        local evidenceId = string.upper(job) .. "-"..Player.User.Citizenid.."-EVIDENCE"

        exports['zero-inventory']:openstash({
            index = evidenceId,
            database = "job-inv",
            slots = 50,
            src = src,
            label = "Bewijs kluis - "..Player.User.Citizenid.."",
            event = "inventory:server:stash",
        })
    end
end)


RegisterNetEvent("Zero-inventory:server:policeStash")
AddEventHandler("Zero-inventory:server:policeStash", function(ui)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "police" or Player.Job.name == "ambulance" or Player.Job.name == "mechanic" or Player.Job.name == "kmar") then
        local grade = Player.Job.grade
        local items = SortKloesoe(Player.Job.name, grade)

        if (ui.frominv == "other") then
            local slot = tonumber(ui.fromslot)

            if (items[slot]) then
                local itemConfig = exports['zero-inventory']:items()
                local amount = tonumber(ui.amount) <= itemConfig[items[slot].item].max and tonumber(ui.amount) or itemConfig[items[slot].item].max
                local toslot = tonumber(ui.toslot)
                local player = exports['zero-inventory']:receiveUser(src)
                local slotfound = player.inventory[toslot]


                if (slotfound) then
                    if (slotfound.item == items[slot]['item']) then
                        player.functions.add({
                            slot = toslot,
                            item = items[slot]['item'],
                            amount = amount,
                            datastash = generateDataStash(items[slot]['item']),
                        })
                        TriggerClientEvent("inventory:client:resyncSlot", src, toslot)
                    end
                else
                    player.functions.add({
                        slot = toslot,
                        item = items[slot]['item'],
                        amount = amount,
                        datastash = generateDataStash(items[slot]['item']),
                    })
                    TriggerClientEvent("inventory:client:resyncSlot", src, toslot)
                end

                Zero.Functions.CreateLog("safes", "Item grabbed ("..Player.Job.name..")", "**Item:** "..items[slot]['item'].." \n **Amount:**"..amount.." \n ** Citizenid: ** "..Player.User.Citizenid.." \n ** Identifier: ** "..Player.User.Identifier.." \n **Source:** "..src.."", "green", false)
            end
        end
    end
end)

RegisterNetEvent("Zero:Server-Police:AddMarker")
AddEventHandler("Zero:Server-Police:AddMarker", function(markerIndex, markerId, markerColour, time, location, name, icon)
    local src = source
    local Player = Zero.Functions.Player(src)

    icon = icon or "https://th.bing.com/th/id/OIP._6xSSfLT8u40qFKNorSYswHaHa?pid=ImgDet&rs=1"

    if (Player.Job.name == "police" or Player.Job.name == "kmar") then
        if (name == "Noodknop") then time = 13000 end
        
        if Player.MetaData.callid then
            local players = Zero.Functions.GetPlayersByJob(Player.Job.name, true)

            for k,v in pairs(players) do
                TriggerClientEvent("Zero:Client-Police:AddMarker", v.User.Source, markerIndex, markerId, markerColour, time, location, name)
            end
        else
            Player.Functions.Notification("Meldingen", "Je moet een roepnummer instellen voor dit (/roepnummer)", "error")
        end
    end
end)

RegisterNetEvent("Zero:Server-Police:LimitArea")
AddEventHandler("Zero:Server-Police:LimitArea", function(text)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "police" or Player.Job.name == "kmar") then
        if Player.MetaData.callid then
            local label = Zero.Config.Jobs[Player.Job.name]['label']
            TriggerClientEvent("phone:notification", -1, './images/logos/'..Player.Job.name..'.png', ""..label..": " .. Player.MetaData.callid, text, 5000) 
        else
            Player.Functions.Notification("Meldingen", "Je moet een roepnummer instellen voor dit (/roepnummer)", "error")
        end
    end
end)

local weaponsGenerations = {
    ['carbinerifle'] = {
        ['ammo'] = 100,
        ['durability'] = 100,
        ['attachments'] = {
            ['rifle_clip'] = {index = 1},
            ['weapon_flashlight'] = {index = 1},
            ['rifle_scope'] = {index = 1},
            ['rifle_suppressor'] = {index = 1},
            ['rifle_grip'] = {index = 1},
        },
    },
    ['stungun'] = {
        ['ammo'] = 0,
        ['durability'] = 100,
        ['attachments'] = {
        },
    },
    ['pistol'] = {
        ['ammo'] = 50,
        ['durability'] = 100,
        ['attachments'] = {
        },
    },
    ['heavysniper'] = {
        ['ammo'] = 5,
        ['durability'] = 100,
        ['attachments'] = {
        },
    },
    ['smg'] = {
        ['ammo'] = 100,
        ['durability'] = 100,
        ['attachments'] = {
        },
    },
    ['shotgun'] = {
        ['ammo'] = 20,
        ['durability'] = 100,
        ['attachments'] = {
        },
    },
    ['flashlight'] = {
        ['ammo'] = 0,
        ['durability'] = 100,
        ['attachments'] = {
        },
    },
}

function generateDataStash(item)
    if weaponsGenerations[item] then
        local data = weaponsGenerations[item]
        data.weaponid = math.random(111, 999) .. "-POL-" .. math.random(11111, 99999) .. "x"

        return data
    end

    return nil
end