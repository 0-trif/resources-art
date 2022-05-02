RegisterCommand("menu", function()
    Zero.Functions.TriggerCallback('Zero:Server-Admin:IsAdmin', function(result)
        if result then
            SendNUIMessage({
                action = "open"
            })
            SetNuiFocus(true, true)
        end
    end)
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("option", function(ui)
    local class = ui.class
    local option = ui.option
    local extra1 = ui.extra1
    local extra2 = ui.extra2

    if menu[class] then
        menu[class][option](extra1, extra2)

        TriggerServerEvent("Zero:Server-Admin:Log", class, option, extra1, extra2)
    end
end)

RegisterNUICallback("playersList", function()
    Zero.Functions.TriggerCallback("Zero:Server-Admin:PlayerList", function(x)
        SendNUIMessage({
            action = "players",
            players = x,
        })
    end)
end)


RegisterNUICallback("kickPlayer", function(ui)
    local id = ui.id
    local reason = ui.reason

    TriggerServerEvent("Zero:Server-Admin:Kick", id, reason)
end)

RegisterNUICallback("banPlayer", function(ui)
    local id = ui.id
    local reason = ui.reason
    local time = ui.time

    TriggerServerEvent("Zero:Server-Admin:Ban", id, reason, time)
end)

vars = {}
vars.visible = true

menu = {}
menu.vehicle = {}

menu.vehicle.fix = function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    SetVehicleFixed(vehicle)
    SetVehicleEngineHealth(vehicle, 2000.00)
end

menu.vehicle.fuel = function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    exports['LegacyFuel']:SetFuel(vehicle, 100)
end

menu.vehicle.keys = function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then
        vehicle = GetVehiclePedIsIn(ped)
    else
        vehicle = Zero.Functions.closestVehicle()
    end
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
end

menu.vehicle.areaclear = function()
    local vehicle = Zero.Functions.closestVehicle()

    if vehicle then
        NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(vehicle))
        DeleteVehicle(vehicle)
    end
end
menu.vehicle.clear = function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(vehicle))
    DeleteVehicle(vehicle)
end

menu.vehicle.spawn = function(model)
    if IsModelValid(model) then
        local ply = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ply))
        local h = GetEntityHeading(ply)

        Zero.Functions.SpawnVehicle({
            model = model,
            location = {x = x, y = y, z = z, h = h},
            teleport = true,
            network = true,
        }, function(vehicle)
            exports['LegacyFuel']:SetFuel(vehicle, 100)
            TriggerEvent("vehiclekeys:client:SetOwner", plate)
        end)
    end
end

menu.me = {}
menu.me.kill = function()
    SetEntityHealth(PlayerPedId(), 0.00)
end

menu.me.res = function()
    TriggerServerEvent("Zero:Server-Admin:Revive")
end

menu.me.invisible = function()
    local ply = PlayerPedId()

    vars.visible = not vars.visible
    SetEntityVisible(ply, vars.visible)

    if vars.visible then
        ResetEntityAlpha(PlayerPedId())
    end
end

RegisterNetEvent("menu.me.invisible")
AddEventHandler("menu.me.invisible", function(bool)
    vars.visible = not bool
    menu.me.invisible()
end)

menu.me.spawnitem = function(item, amount)
    TriggerServerEvent("Zero:Server-Admin:Spawn", item, amount)
end

menu.me.clearinv = function()
    TriggerServerEvent("Zero:Server-Admin:Clear")
end

vars.tagg = false

menu.me.staff = function()
    vars.tagg = not vars.tagg 

    TriggerServerEvent("Zero:Server-Admin:StaffTagg", vars.tagg)
end

vars.playerids = false
menu.me.playerids = function()
    vars.playerids = not vars.playerids
end

menu.server = {}
menu.server.announce = function(extra)
    TriggerServerEvent("Zero:Server-Admin:Announce", extra)
end

menu.chosenplayer = {}
menu.chosenplayer.kill = function(extra)
    TriggerServerEvent("Zero:Server-Admin:KillPlayer", extra)
end
menu.chosenplayer.res = function(extra)
    TriggerServerEvent("Zero:Server-Admin:Revive", extra)
end
menu.chosenplayer.freeze = function(extra)
    TriggerServerEvent("Zero:Server-Admin:Freeze", extra, true)
end
menu.chosenplayer.unfreeze = function(extra)
    TriggerServerEvent("Zero:Server-Admin:Freeze", extra, false)
end
menu.chosenplayer.ban = function()
end
menu.chosenplayer.kick = function()
end
menu.chosenplayer.inventory = function(extra)
    SendNUIMessage({
        action = "close"
    })
    SetNuiFocus(false, false)

    local extra = tonumber(extra)
    TriggerServerEvent("inventory:server:invsee", extra)
end

menu.chosenplayer.gotoplayer = function(extra)
    TriggerServerEvent("Zero:Server-Admin:RequestTp", extra)
end

menu.chosenplayer.bring = function(extra)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("Zero:Server-Admin:SetCoord", extra, coords)
end

-- events

RegisterNetEvent("Zero:Client-Admin:KillPlayer")
AddEventHandler("Zero:Client-Admin:KillPlayer", function()
    SetEntityHealth(PlayerPedId(), 0.00)
end)

RegisterNetEvent("Zero:Client-Admin:Freeze")
AddEventHandler("Zero:Client-Admin:Freeze", function(bool)
    local ply = PlayerPedId()
    if IsPedInAnyVehicle(ply) then
        TaskLeaveAnyVehicle(ply)
    end
    FreezeEntityPosition(PlayerPedId(), bool)
end)


RegisterNetEvent('Zero:Client-Admin:SetCoord')
AddEventHandler('Zero:Client-Admin:SetCoord', function(coord)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coord.x, coord.y, coord.z)
end)

RegisterNetEvent("Zero:Client-Admin:RequestTp")
AddEventHandler("Zero:Client-Admin:RequestTp", function(id)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("Zero:Server-Admin:SetCoord", id, coords)
end)

serverTaggs = {}
RegisterNetEvent('Zero:Client-Admin:Taggs')
AddEventHandler('Zero:Client-Admin:Taggs', function(x)
    serverTaggs = x
end)


Citizen.CreateThread(function()
    while true do
        local ply = PlayerPedId()

        timeout = 750
        if (not vars.visible) then
            SetEntityLocallyVisible(ply)
            SetEntityAlpha(PlayerPedId(), 51, false)
            timeout = 0
        end
        

        if IsControlPressed(0, Zero.Config.Keys['Z']) or vars.playerids then
            DisplayPlayerIds()
            timeout = 0
        end

        if next(serverTaggs) then
            DisplayTaggs()
            timeout = 0
        end
        
        Wait(timeout)
    end
end)

function DisplayTaggs()
    for k,v in pairs(serverTaggs) do
        local player = GetPlayerFromServerId(k)
        local ped = GetPlayerPed(player)
        local coord = GetEntityCoords(ped)

        if vars.tagg then
            local pos = GetEntityCoords(PlayerPedId())
            Zero.Functions.DrawText(pos.x, pos.y, pos.z + 1, "[~g~ART~w~] - ".. GetPlayerName(PlayerId()) .."")
        end

        if ped and IsEntityVisible(ped) then
            local distance = #(coord - GetEntityCoords(PlayerPedId()))

            if distance <= 5 and distance > 0 then
                Zero.Functions.DrawText(coord.x, coord.y, coord.z + 1, "[~g~ART~w~] - ".. v .."")
            end
        end
    end
end

function DisplayPlayerIds()
    local players = Zero.Functions.GetPlayers()

    for k,v in pairs(players) do
        local ped = GetPlayerPed(v)
        local coord = GetEntityCoords(ped)

        if ped and IsEntityVisible(ped) then
            local serverid = GetPlayerServerId(v)
            
            local distance = #(coord - GetEntityCoords(PlayerPedId()))

            if vars.playerids then
                if serverTaggs[serverid] then
                    Zero.Functions.DrawText(coord.x, coord.y, coord.z + 1.2, "["..serverid.."] - " .. GetPlayerName(v)) 
                else
                    Zero.Functions.DrawText(coord.x, coord.y, coord.z + 1, "["..serverid.."] - " .. GetPlayerName(v))
                end
            else
                if distance <= 5 then
                    if serverTaggs[serverid] then
                        Zero.Functions.DrawText(coord.x, coord.y, coord.z + 1.2, "["..serverid.."]") 
                    else
                        Zero.Functions.DrawText(coord.x, coord.y, coord.z + 1, "["..serverid.."]")
                    end
                end
            end
        end
    end
end

