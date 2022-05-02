local DISPATCH_VEHICLES = {}
local DISPATCH_PLAYERS = {}

exports['zero-core']:object(function(O) Zero = O end)

Citizen.CreateThread(function()
    for k,v in pairs(config.jobs) do
        DISPATCH_VEHICLES[k] = {}
        DISPATCH_PLAYERS[k] = {}
    end
end)

function count(x)
    local c = 0

    for k,v in pairs(x) do
        c = c + 1
    end

    return c
end

function getIcon(class) 
    local icon = '<i class="fa-solid fa-car-rear"></i> '
    if class == 8 then
        icon = '<i class="fa-solid fa-motorcycle"></i>'
    elseif class == 15 then
        icon = '<i class="fa-solid fa-helicopter"></i>'
    end
    return icon
end

--[[
         title = Player.PlayerData.firstname,
        taggs = {{name="Politie", color="blue"}, {name= Player.MetaData.callid, color="red"}},
        info = {
            {
                icon = '<i class="fa-solid fa-info"></i>',
                text = name,
            }
        },
        type = "police",
        location = location,
]]

RegisterServerEvent("dispatch:public")
AddEventHandler("dispatch:public", function(jobs, data)
    for k,v in pairs(jobs) do
        TriggerClientEvent("Zero:Client-Dispatch:Alert", -1, v, data)  
    end
end)

RegisterServerEvent("Zero:Server-Dispatch:Request")
AddEventHandler("Zero:Server-Dispatch:Request", function()
    TriggerClientEvent("Zero:Client-Dispatch:Sync", source, DISPATCH_VEHICLES, DISPATCH_PLAYERS)
end)

RegisterServerEvent("Zero:Server-Dispatch:InVehicle")
AddEventHandler("Zero:Server-Dispatch:InVehicle", function(plate, vehicleclass)
    local src = source
    local Player = Zero.Functions.Player(source)
    local job = Player.Job.name

    local callid = Player.MetaData.callid ~= nil and '['..Player.MetaData.callid..']' or "[---]"

    clearPlayer(src)

    DISPATCH_VEHICLES[job][plate] = DISPATCH_VEHICLES[job][plate] ~= nil and DISPATCH_VEHICLES[job][plate] or {}
    DISPATCH_VEHICLES[job][plate][Player.User.Source] = {
        name = callid .. " " .. Player.PlayerData.firstname,
        icon = getIcon(vehicleclass),
    }
end)

RegisterServerEvent("Zero:Server-Dispatch:LeftVehicle")
AddEventHandler("Zero:Server-Dispatch:LeftVehicle", function(plate)
    local src = source
    local Player = Zero.Functions.Player(source)
    local job = Player.Job.name

    local callid = Player.MetaData.callid ~= nil and '['..Player.MetaData.callid..']' or "[---]"
    
    if DISPATCH_VEHICLES[job][plate] then
        DISPATCH_VEHICLES[job][plate][source] = nil
    end

    clearPlayer(src)

    DISPATCH_PLAYERS[job][src] = {
        name = callid .. " " .. Player.PlayerData.firstname,
    }
    
    if DISPATCH_VEHICLES[job][plate] then
        if count(DISPATCH_VEHICLES[job][plate]) == 0 then
            DISPATCH_VEHICLES[job][plate] = nil
        end
    end
end)


function clearPlayer(id)
    for k,v in pairs(config.jobs) do
        DISPATCH_PLAYERS[k][id] = nil

        for y,z in pairs(DISPATCH_VEHICLES[k]) do
            if z[id] then
                z[id] = nil
            end
            if count(z) == 0 then
                DISPATCH_VEHICLES[k][y] = nil
            end
        end
    end
end

RegisterNetEvent("dispatch:remove")
AddEventHandler("dispatch:remove", function(id)
    clearPlayer(id)
end)

AddEventHandler("playerDropped", function()
    local src = source
    clearPlayer(src)
end)