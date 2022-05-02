exports['zero-core']:object(function(O)
    Zero = O
end)

local inMenu = false
local signIn = {x = 1208.8297119141, y = -3114.9709472656, z = 5.5403208732605, h = 267.623046875}

local targetEntry = {x = 1562.5866699219, y = -3011.8283691406, z = 5.8822736740112, h = 150.8285369873}
local targetExit = {x = 1551.5484619141, y = -3032.5634765625, z = 5.8851723670959, h = 150.58145141602}
local targetSafe = {x = 1534.0300292969, y = -3065.3681640625, z = 8.3805288314819, h = 331.89074707031}

local vars = {}
local stashes = {}

-- Main enter code 
Citizen.CreateThread(function()
    while true do
        local timer = 750

        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)
        local distance = #(pos - vector3(signIn.x, signIn.y, signIn.z))

        if distance <= 5 then
            timer = 0

            if not inMenu then

                TriggerEvent("interaction:show", "Openen", function()
                    TriggerEvent("Zero:Client-Yacht:Open")
                    inMenu = true
                end)

            end
        end
        
        Wait(timer)
    end
end)

-- code for entry in boat 
Citizen.CreateThread(function()
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)
    
        local distance = #(pos - vector3(targetEntry.x, targetEntry.y, targetEntry.z))

        if distance <= 150 then
            timer = 0
            if (vars.insideBoat) then
                local distance = #(pos - vector3(targetExit.x, targetExit.y, targetExit.z))
                if distance <= 10 and distance > 1.5 then
                    Zero.Functions.DrawText(targetExit.x, targetExit.y, targetExit.z, "~g~Uitgang")
                elseif distance < 1.5 then
                    TriggerEvent("interaction:show", "Verlaten", function()
                        SetEntityCoords(PlayerPedId(), targetEntry.x, targetEntry.y, targetEntry.z)
                        vars.insideBoat = false
                    end)
                end

                if (vars.inMission) then
                    for k,v in pairs(stashes) do
                        local distance = #(pos - vector3(v.x, v.y, v.z))

                        if not v.searched then
                            if distance <= 10 and distance > 1 then
                                Zero.Functions.DrawText(v.x, v.y, v.z, "~w~Zoeken")
                            elseif distance < 1 then
                                Zero.Functions.DrawText(v.x, v.y, v.z, "~g~E ~w~ - Zoeken")

                                if IsControlJustPressed(0, Zero.Config.Keys['E']) then
                                    TriggerEvent("Zero:Client-Yacht:Search", k)
                                end
                            end
                        else
                            if distance < 3 then
                                Zero.Functions.DrawText(v.x, v.y, v.z, "Leeg..")
                            end
                        end
                    end

                    if not DoesEntityExist(safe) then
                        safe = CreateSafe(targetSafe.x, targetSafe.y, targetSafe.z, targetSafe.h)
                    else
                        SetEntityCoords(safe, targetSafe.x, targetSafe.y, targetSafe.z)
                    end
                    
                    local distance = #(pos - vector3(targetSafe.x, targetSafe.y, targetSafe.z))

                    if distance <= 5 then
                        TriggerEvent("interaction:show", "Code invullen", function()
                            local ui = exports['zero-ui']:element()
                            local code = ui.input()

                            TriggerEvent("Zero:Client-Yacht:SearchSafe", code)
                        end)
                    end
                end
            else
                local distance = #(pos - vector3(targetEntry.x, targetEntry.y, targetEntry.z))
                if distance <= 10 and distance > 1.5 then
                    Zero.Functions.DrawText(targetEntry.x, targetEntry.y, targetEntry.z, "~g~Ingang")
                elseif distance < 1.5 then
                    TriggerEvent("interaction:show", "Binnengaan", function()
                        SetEntityCoords(PlayerPedId(), targetExit.x, targetExit.y, targetExit.z)
                        vars.insideBoat = true
                    end)
                end
            end
        elseif (distance > 1000 and vars.inMission) then
            vars.inMission = false
            TriggerServerEvent("Zero:Server-Yacht:LeaveMission")
        end
        
        Wait(timer)
    end
end)

function CreateSafe(x, y, z, h)
    givenNote = false

    local model = GetHashKey('prop_ld_int_safe_01')

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local object = CreateObject(model, x, y, z, false, false, false)
    FreezeEntityPosition(object, true)
    SetEntityHeading(object, h)

    return object
end

RegisterNetEvent("Zero:Client-Yacht:Alert")
AddEventHandler("Zero:Client-Yacht:Alert", function()
    local location = GetEntityCoords(PlayerPedId())
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, location.x, location.y, location.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    streetname = street1 .. ", " .. street2

    TriggerServerEvent("dispatch:public", {"police", "kmar"}, {
        taggs = {
            [1] = {
                name = "10-65",
                color = "#373636",
            },
        },
        title = "Yacht heist",
        info = {
            [1] = {
                icon = '<i class="fa-solid fa-map-location"></i>',
                text = "Straat: " .. streetname,
            },
            [2] = {
                icon = '<i class="fa-solid fa-clock"></i>',
                text = "Tijd: paar seconden geleden",
            },
            [3] = {
                icon = '<i class="fa-solid fa-bell"></i>',
                text = "Melding: Yacht overval begonnen.",
            },
        },
        type = "error",
        location = GetEntityCoords(PlayerPedId())
    })
end)


RegisterNetEvent("Zero:Client-Yacht:Menu")
AddEventHandler("Zero:Client-Yacht:Menu", function(bool)
    inMenu = bool
end)

RegisterNetEvent("Zero:Client-Yacht:Mission")
AddEventHandler("Zero:Client-Yacht:Mission", function(bool)
    safe = nil
    vars.inMission = bool
end)

RegisterNetEvent("Zero:Client-Yacht:Stashes")
AddEventHandler("Zero:Client-Yacht:Stashes", function(data)
    stashes = data
end)