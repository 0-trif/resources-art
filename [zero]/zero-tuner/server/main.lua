exports['zero-core']:object(function(O) Zero = O end)

Zero.Functions.CreateCallback("Zero:Server-Tuner:GetGarage", function(source, cb, bool)
    if bool then
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `tuner`", {
        }, function(result)
            cb(result)
        end)
    else
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `tuner` WHERE `location` = ?", {
            "NONE",
        }, function(result)
            cb(result)
        end)
    end
end)

local ChangedLocations = function()
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `tuner`", {
    }, function(result)
        TriggerClientEvent('Zero:Client-Tuner:ChangedLocations', -1, result)
    end)
end

RegisterServerEvent("Zero:Server-Tuner:CheckVehicle")
AddEventHandler("Zero:Server-Tuner:CheckVehicle", function(mods, src)
    local player = Zero.Functions.Player(src)

    if (player.Job.name == "tuner") then
        Zero.Functions.ExecuteSQL(true, "UPDATE `tuner` SET `mods` = ? WHERE `plate` = ?", {
            json.encode(mods), 
            mods.plate
        })
        
        TriggerClientEvent('Zero:Client-Tuner:UpdateMods', -1, mods)
    end
end)

RegisterServerEvent("Zero:Server-Tuner:ClearLocation")
AddEventHandler("Zero:Server-Tuner:ClearLocation", function(plate)
    Zero.Functions.ExecuteSQL(true, "UPDATE `tuner` SET `location` = ? WHERE `plate` = ?", {
        "NONE", 
        plate
    }, function()
        ChangedLocations()
    end)
end)

RegisterServerEvent("Zero:Server-Tuner:SetVehicleLocation")
AddEventHandler("Zero:Server-Tuner:SetVehicleLocation", function(plate, index)
    Zero.Functions.ExecuteSQL(true, "UPDATE `tuner` SET `location` = ? WHERE `plate` = ?", {
        index, 
        plate
    }, function(RowsChanged)
        if (RowsChanged.affectedRows) then
            Zero.Functions.ExecuteSQL(true, "SELECT * FROM `tuner` WHERE `location` = ?", {
                "NONE",
            }, function(result)
                ChangedLocations()
            end)
        end
    end)
end)

RegisterServerEvent("Zero:Server-Tuner:GiveVehicle")
AddEventHandler("Zero:Server-Tuner:GiveVehicle", function(data, plate, playerid)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "tuner") then
        if data and plate and playerid then
            local Target = Zero.Functions.Player(playerid)

            if Target then
                Zero.Functions.ExecuteSQL(false, "INSERT INTO `citizen_vehicles` (`citizenid`, `model`, `mods`, `location`, `plate`) VALUES (?, ?, ?, ?, ?)", {
                    Target.User.Citizenid,
                    data.model, 
                    json.encode(data.mods),
                    "*",
                    plate,
                }, function()
                    Target.Functions.AddVehicle(plate)
                    Target.Functions.Notification("Tuner", "Er is een voertuig aan je account toegevoegd", "success", 8000)
                    Player.Functions.Notification("Tuner", "Voertuig weg gegeven", "success", 8000)

                    TriggerClientEvent("vehiclekeys:client:SetOwner", playerid, plate)

                    Zero.Functions.ExecuteSQL(false, "DELETE FROM `tuner` WHERE `plate` = ?", {
                        plate,
                    })
                end)
            end
        end
    end
end)


RegisterServerEvent("Zero:Server-Tuner:ClaimVehicle")
AddEventHandler("Zero:Server-Tuner:ClaimVehicle", function(props)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "tuner") then
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `plate` = ?", {
            props['plate']
        }, function(result)
            if (result[1]) then
                local TargetPlayer = Zero.Functions.PlayerByCitizenid(result[1].citizenid)

                if TargetPlayer then
                    TriggerClientEvent("Zero:Client-Tuner:ClaimedVehicle", src)
                    Zero.Functions.ExecuteSQL(true, "INSERT INTO `tuner` (`citizenid`, `plate`, `mods`, `model`) VALUES (?, ?, ?, ?)", {
                        result[1]['citizenid'],
                        props.plate,
                        json.encode(props),
                        result[1].model,
                    })

                    TargetPlayer.Functions.RemoveVehicle(props['plate'])
                    TargetPlayer.Functions.Notification("Tuner", "Uw voertuig is geclaimed door de tuner")
                end
            else
                TriggerClientEvent("Zero:Client-Tuner:ClaimedVehicle", src)
                Player.Functions.Notification("Tuner", "Dit voertuig heeft geen eigenaar", "error")
            end
        end)
    end
end)

RegisterServerEvent("Zero:Server-Tuner:Grab")
AddEventHandler("Zero:Server-Tuner:Grab", function(ui)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "tuner") then
        if (ui.frominv == "other") then
            local slot = tonumber(ui.fromslot)

            if (Config.StashItems[slot]) then
                local itemConfig = exports['zero-inventory']:items()
                local amount = tonumber(ui.amount) <= itemConfig[Config.StashItems[slot].item].max and tonumber(ui.amount) or itemConfig[Config.StashItems[slot].item].max
                local toslot = tonumber(ui.toslot)
                local player = exports['zero-inventory']:receiveUser(src)
                local slotfound = player.inventory[toslot]


                if (slotfound) then
                    if (slotfound.item == Config.StashItems[slot]['item']) then
                        player.functions.add({
                            slot = toslot,
                            item = Config.StashItems[slot]['item'],
                            amount = amount,
                        })
                        TriggerClientEvent("inventory:client:resyncSlot", src, toslot)
                    end
                else
                    player.functions.add({
                        slot = toslot,
                        item = Config.StashItems[slot]['item'],
                        amount = amount,
                    })
                    TriggerClientEvent("inventory:client:resyncSlot", src, toslot)
                end
            end
        end
    end
end)

-- read json
Citizen.CreateThread(function()
    resource_name = GetCurrentResourceName()
    lifts = LoadResourceFile(resource_name, "/json/lifts.json")
    lifts = json.decode(lifts or '{}')

    for k,v in pairs(Config.SpotLocations) do
        if v.lift then
            lifts[k] = lifts[k] ~= nil and lifts[k] or v.z
        end
    end

    assert(lifts, "Lift config is loaded incompletely! fix needed")
    
    TriggerClientEvent("Zero:Client-Tuner:SyncLifts", -1, lifts)
    SaveResourceFile(resource_name, "/json/lifts.json", json.encode(lifts, { indent = true }), -1)
end)

RegisterNetEvent("Zero:Server-Tuner:RequestLifts")
AddEventHandler("Zero:Server-Tuner:RequestLifts", function()
    local src = source
    TriggerClientEvent("Zero:Client-Tuner:SyncLifts", src, lifts)
end)

RegisterNetEvent("Zero:Server-Tuner:LiftUp")
AddEventHandler("Zero:Server-Tuner:LiftUp", function(index)
    local src = source

    lifts[index] = lifts[index] + 0.5

    if lifts[index] > 8.0 then
        lifts[index] = 8.0
    end
    
    SaveResourceFile(resource_name, "/json/lifts.json", json.encode(lifts, { indent = true }), -1)

    TriggerClientEvent("Zero:Client-Tuner:TransitionLift", -1, index, lifts[index])
end)

RegisterNetEvent("Zero:Server-Tuner:LiftDown")
AddEventHandler("Zero:Server-Tuner:LiftDown", function(index)
    local src = source

    lifts[index] = lifts[index] - 0.5
    if lifts[index] < 6.0 then
        lifts[index] = 6.0
    end

    SaveResourceFile(resource_name, "/json/lifts.json", json.encode(lifts, { indent = true }), -1)

    TriggerClientEvent("Zero:Client-Tuner:TransitionLift", -1, index, lifts[index])
end)
