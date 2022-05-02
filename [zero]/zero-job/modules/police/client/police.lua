Modules['police'] = {}

Modules['police'].Config = {
    [1] = {
        ['loc'] = {x = 458.86849975586, y = -992.44262695313, z = 25.699998855591, heading = 359.14437866211},
        ['text'] = "Garage",
        ['functie'] = "OpenGarage",
    },
    [2] = {
        ['loc'] = {x = 449.28, y = -981.02, z = 43.69, h = 356.90},
        ['text'] = "Heliplatform",
        ['functie'] = "OpenHeli",
    },
    [3] = {
        ['loc'] = {x = 481.77676391602, y = -995.61059570313, z = 30.689804077148, heading = 354.75604248047},
        ['text'] = "Kloesoe",
        ['functie'] = "OpenKloesoe",
    },
    [4] = {
        ['loc'] = {x = 472.85, y = -996.90, z = 26.27, heading = 354.75604248047},
        ['text'] = "Bewijs",
        ['functie'] = "EvidenceRoom",
    },
    
}

Modules['police'].Objects = {
    ["cone"] = {model = `prop_roadcone02a`, freeze = false},
    ["barier"] = {model = `prop_barrier_work06a`, freeze = true},
    ["schotten"] = {model = `prop_snow_sign_road_06g`, freeze = true},
    ["tent"] = {model = `prop_gazebo_03`, freeze = true},
    ["light"] = {model = `prop_worklight_03b`, freeze = true},
    ["spike"] = {model = `P_ld_stinger_s`, freeze = true},
}

Modules['police'].options = {
    [1] = {
        name = "Object plaatsen", 
        action = function() 
            PlaceObject()
        end,
    },
    [2] = {
        name = "Gebied markeren", 
        action = function() 
            MarkAreaOption()
        end,
    },
    [3] = {
        name = "Speed limit", 
        action = function() 
            LimitArea()
        end,
    },
}

Citizen.CreateThread(function()
    local coord = {x = 431.9098815918, y = -981.34729003906, z = 30.711887359619, h = 269.33978271484}
    blip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(blip, 526)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 38)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Politie")
    
    EndTextCommandSetBlipName(blip)
end)

Modules['police'].Functions = {}

Modules['police'].Run = function()

    local player = PlayerPedId()
    local coord = GetEntityCoords(player)

    for k,v in ipairs(Modules['police'].Config) do
        local distance = #(coord - vector3(v.loc.x, v.loc.y, v.loc.z))

        if (distance <= 5 and distance > 1) then
            timer = 0
            
            Zero.Functions.DrawMarker(v.loc.x, v.loc.y, v.loc.z)
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, v.text)
        elseif (distance < 1) then
            timer = 0
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, "~g~E~w~ - "..v.text.."")

            if IsControlJustPressed(0, 38) then
                Modules['police'].Functions[v.functie]()
            end
        end
    end
end


Modules['police'].Functions['OpenGarage'] = function()
    if JobModule == "police" and JobDuty then
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            DeleteEntity(GetVehiclePedIsIn(ped))
        else
            exports['zero-garages']:openMenu(Shared.Config.police.Vehicles)
        end
    end
end
Modules['police'].Functions['OpenHeli'] = function()
    if JobModule == "police" and JobDuty then
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            DeleteEntity(GetVehiclePedIsIn(ped))
        else
            exports['zero-garages']:openMenu({
                [1] = {
                    model = "Zulu",
                    reason = "Zulu politie",
                    spawnmodel = "zulu1",
                },
            })
        end
    end
end
Modules['police'].Functions['OpenKloesoe'] = function()
    TriggerServerEvent("Zero:Server-Police:OpenKloesoe")
end
Modules['police'].Functions['EvidenceRoom'] = function()
    TriggerServerEvent("Zero:Server-Police:EvidenceRoom")
end

function PlaceObject()
    local objects = {
        [1] = {
            name = "Pion", 
            action = function() 
                TriggerEvent("police:client:spawnCone")
            end,
        },
        [2] = {
            name = "Barrier", 
            action = function() 
                TriggerEvent("police:client:spawnBarier")
            end,
        },
        [3] = {
            name = "Schotten", 
            action = function() 
                TriggerEvent("police:client:spawnSchotten")
            end,
        },
        [4] = {
            name = "Tent", 
            action = function() 
                TriggerEvent("police:client:spawnTent")
            end,
        },
        [5] = {
            name = "Schijnwerper", 
            action = function() 
                TriggerEvent("police:client:spawnLight")
            end,
        },
        [6] = {
            name = "Spijkermat", 
            action = function() 
                TriggerEvent("police:client:spawnSpike")
            end,
        },
        [7] = {
            name = "Verwijder object", 
            action = function() 
                TriggerEvent("police:client:deleteObject")
            end,
        },
    }
    exports['zero-eye']:ForceOptions("object", objects, GetCurrentResourceName())
end

isHandcuffed = false
isSoftcuff = false
isEscorted = false

RegisterNetEvent("Zero:Client-Police:GetFines")
AddEventHandler("Zero:Client-Police:GetFines", function(string, cb)
    if (string == "") then
        cb(Shared.Police.Fines)
    else
        local _ = {}

        for k,v in pairs(Shared.Police.Fines) do
            local find = string.find(v.label, string)
            if (find ~= nil) then
                table.insert(_, v)
            end
        end

        cb(_)
    end
end)

RegisterNetEvent("Zero:Client-Police:DragPlayer")
AddEventHandler("Zero:Client-Police:DragPlayer", function()
    local player, distance = Zero.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then

            if Last_DragId then
                TriggerServerEvent("Zero:Server-Police:EscortPlayer", playerId)
                Last_DragId = nil
                return
            end

            Last_DragId = playerId
            TriggerServerEvent("Zero:Server-Police:EscortPlayer", playerId)
        end
    else
        Zero.Functions.Notification("Handboeien", "Geen speler gevonden", "error")
    end
end)

RegisterNetEvent('Zero:Client-Police:ToggleWalking')
AddEventHandler('Zero:Client-Police:ToggleWalking', function()
    local player, distance = Zero.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            Last_DragId = playerId
            TriggerServerEvent("Zero:Server-Police:ToggleWalking", playerId)
        end
    else
        Zero.Functions.Notification("Handboeien", "Geen speler gevonden", "error")
    end
end)

RegisterNetEvent('Zero:Client-Police:Drag')
AddEventHandler('Zero:Client-Police:Drag', function(playerId)
    Zero.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.MetaData["isdead"] or isHandcuffed then
            if not isEscorted then
                draggerId = playerId

                dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                heading = GetEntityHeading(dragger)
                SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
                AttachEntityToEntity(PlayerPedId(), dragger, 11816, 0.54, 0.84, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)
    
                isEscorted = true
            else
                Last_DragId = nil
                isEscorted = false
                DetachEntity(GetPlayerPed(-1), true, false)
            end
        end
    end)
end)

RegisterNetEvent("Zero:Client-Police:UseCuffs")
AddEventHandler("Zero:Client-Police:UseCuffs", function(slot)
    local slot = slot

    if not IsPedRagdoll(GetPlayerPed(-1)) then
        local player, distance = Zero.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)

            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(GetPlayerPed(-1))) then
                TriggerServerEvent("Zero:Server-Police:UseCuffs", playerId, true)
            else
                Zero.Functions.Notification("Handboeien", "Speler zit in een voertuig", "error")
            end
        else
            Zero.Functions.Notification("Handboeien", "Geen speler gevonden", "error")
        end
    else
        Citizen.Wait(2000)
    end
end)


RegisterNetEvent("Zero:Client-Police:HandCuffAnimation")
AddEventHandler("Zero:Client-Police:HandCuffAnimation", function()
    HandCuffAnimation()
end)

RegisterNetEvent("Zero:Client-Police:unCuffAnimation")
AddEventHandler("Zero:Client-Police:unCuffAnimation", function()
    ExecuteCommand("e uncuff")

    Wait(3000)

    ExecuteCommand("e c")
end)

function HandCuffAnimation()
    loadAnimDict("mp_arrest_paired")
	Citizen.Wait(100)
    TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
	Citizen.Wait(3500)
    TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

function GetCuffedAnimation(playerId)
    local cuffer = GetPlayerPed(GetPlayerFromServerId(playerId))
    local heading = GetEntityHeading(cuffer)
    loadAnimDict("mp_arrest_paired")
    SetEntityCoords(GetPlayerPed(-1), GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
	Citizen.Wait(100)
	SetEntityHeading(GetPlayerPed(-1), heading)
	TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
	Citizen.Wait(2500)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end 

local walkEnabled = true
RegisterNetEvent("Zero:Client-Police:Walking")
AddEventHandler("Zero:Client-Police:Walking", function()
    walkEnabled = not walkEnabled
    if not walkEnabled then
        Zero.Functions.Notification('Handboeien', 'Je kan nu niet meer lopen', 'error')
        FreezeEntityPosition(PlayerPedId(), true)
        
        while not walkEnabled do
            SetEntityCollision(PlayerPedId(), true, true)
            Wait(0)
        end
        return
    end
    FreezeEntityPosition(PlayerPedId(), false)
    Zero.Functions.Notification('Handboeien', 'Je kan nu weer lopen', 'success')
end)

RegisterNetEvent("Zero:Client-job:GetCuffs")
AddEventHandler("Zero:Client-job:GetCuffs", function(playerId, bool, isSoftcuff)
    if not bool then
        ClearPedTasksImmediately(GetPlayerPed(-1))
        if not isSoftcuff then
            cuffType = 16
            GetCuffedAnimation(playerId)
            Zero.Functions.Notification("Handboeien", "Je bent nu gehandboeid", "error")
        else
            cuffType = 49
            GetCuffedAnimation(playerId)
            Zero.Functions.Notification("Handboeien", "Je bent nu gehandboeid, maar je kan lopen", "error")
        end

        isHandcuffed = true
    else
        isEscorted = false

        Wait(3000)
      
        DetachEntity(GetPlayerPed(-1), true, false)
        ClearPedTasksImmediately(GetPlayerPed(-1))

        local ped = exports['zero-clothing_new']:ped()
        ped:ApplyVariation("accessory", -1, "main")

        Zero.Functions.Notification("Handboeien", "Je bent nu niet meer gehandboeid", "error")
        isHandcuffed = false
    end
end)

RegisterNetEvent("Zero:Client-Police:SetVehicle")
AddEventHandler("Zero:Client-Police:SetVehicle", function()
    local closestVehicle = Zero.Functions.closestVehicle()

    if (closestVehicle) then
        local ply = Zero.Functions.GetClosestPlayer()

        if not Last_DragId then
            TriggerServerEvent('Zero:Server-Police:SetVehicle', GetPlayerServerId(ply))
        else
            Zero.Functions.Notification('Systeem', 'Je moet de speler eerst loslaten', 'error')
        end
    end
end)

RegisterNetEvent("Zero:Client-Police:SetInVehicleAneefWholla")
AddEventHandler("Zero:Client-Police:SetInVehicleAneefWholla", function()
    local closestVehicle = Zero.Functions.closestVehicle()
    if (closestVehicle) then
        DetachEntity(GetPlayerPed(-1), true, false)

        local seats = GetNumberOfVehicleDoors(closestVehicle)

        for i = 0, seats do
            if (IsVehicleSeatFree(closestVehicle, i)) then
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), closestVehicle, i)
                return
            end
        end
    end
end)

RegisterNetEvent("Zero:Client-Police:Invsee")
AddEventHandler("Zero:Client-Police:Invsee", function()
    local player, distance = Zero.Functions.GetClosestPlayer()
    local serverid = GetPlayerServerId(player)

    TriggerServerEvent("inventory:server:invsee", serverid)
end)

RegisterNetEvent("Zero:Client-Police:OpenKloesoe")
AddEventHandler("Zero:Client-Police:OpenKloesoe", function(items)
    TriggerEvent("Zero-inventory:client:openShop", items)
end)


function MarkAreaOption()
    local streetname = streetName()
    local Player = Zero.Functions.GetPlayerData()

    local options = {
        [1] = {
            name = "Noodknop", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:AddMarker", GetPlayerServerId(PlayerId()) .. "-noodknop", 526, 59, 20000, GetEntityCoords(PlayerPedId()), "Noodknop")

                TriggerServerEvent("dispatch:public", {"police", "kmar"}, {
                    taggs = {
                        [1] = {
                            name = "Noodknop",
                            color = "rgb(15, 107, 160)",
                        },
                        [2] = {
                            name = Player.MetaData.callid,
                            color = "rgb(55, 119, 95)",
                        },
                        [3] = {
                            name = Zero.Config.Jobs[Player.Job.name]['label'],
                            color = "rgb(58, 156, 91)",
                        },
                    },
                    title = "Noodknop ingedrukt door collega",
                    info = {
                        [1] = {
                            icon = '<i class="fa-solid fa-map-location"></i>',
                            text = "Straat: " .. streetname,
                        },
                        [2] = {
                            icon = '<i class="fa-solid fa-file-signature"></i>',
                            text = "Naam: " .. Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname,
                        },
                        [3] = {
                            icon = '<i class="fa-solid fa-id-card-clip"></i>',
                            text = Player.MetaData.callid ~= nil and "Roepnummer: " ..  Player.MetaData.callid or "Geen roepnummer",
                        },
                    },
                    type = "warning",
                    location = GetEntityCoords(PlayerPedId())
                })
            end,
        },
        [2] = {
            name = "Mogelijk verdachte situatie", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:AddMarker", GetPlayerServerId(PlayerId()) .. "-s", 526, 38, 10000, GetEntityCoords(PlayerPedId()), "Verdachte situatie")

                TriggerServerEvent("dispatch:public", {"police", "kmar"}, {
                    taggs = {
                        [1] = {
                            name = "Status update",
                            color = "rgb(15, 107, 160)",
                        },
                        [2] = {
                            name = Player.MetaData.callid,
                            color = "rgb(55, 119, 95)",
                        },
                        [3] = {
                            name = Zero.Config.Jobs[Player.Job.name]['label'],
                            color = "rgb(58, 156, 91)",
                        },
                    },
                    title = "Mogelijk verdachte situatie",
                    info = {
                        [1] = {
                            icon = '<i class="fa-solid fa-map-location"></i>',
                            text = "Straat: " .. streetname,
                        },
                        [2] = {
                            icon = '<i class="fa-solid fa-file-signature"></i>',
                            text = "Naam: " .. Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname,
                        },
                        [3] = {
                            icon = '<i class="fa-solid fa-id-card-clip"></i>',
                            text = Player.MetaData.callid ~= nil and "Roepnummer: " ..  Player.MetaData.callid or "Geen roepnummer",
                        },
                    },
                    type = "police",
                    location = GetEntityCoords(PlayerPedId())
                })
            end,
        },
        [3] = {
            name = "Assistentie nodig", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:AddMarker", GetPlayerServerId(PlayerId()) .. "-assist", 526, 38, 10000, GetEntityCoords(PlayerPedId()), "Assistentie nodig")

                TriggerServerEvent("dispatch:public", {"police", "kmar"}, {
                    taggs = {
                        [1] = {
                            name = "Status update",
                            color = "rgb(15, 107, 160)",
                        },
                        [2] = {
                            name = Player.MetaData.callid,
                            color = "rgb(55, 119, 95)",
                        },
                        [3] = {
                            name = Zero.Config.Jobs[Player.Job.name]['label'],
                            color = "rgb(58, 156, 91)",
                        },
                    },
                    title = "Assistentie nodig",
                    info = {
                        [1] = {
                            icon = '<i class="fa-solid fa-map-location"></i>',
                            text = "Straat: " .. streetname,
                        },
                        [2] = {
                            icon = '<i class="fa-solid fa-file-signature"></i>',
                            text = "Naam: " .. Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname,
                        },
                        [3] = {
                            icon = '<i class="fa-solid fa-id-card-clip"></i>',
                            text = Player.MetaData.callid ~= nil and "Roepnummer: " ..  Player.MetaData.callid or "Geen roepnummer",
                        },
                    },
                    type = "police",
                    location = GetEntityCoords(PlayerPedId())
                })
            end,
        },
        [4] = {
            name = "Assistentie nodig (Hoge prioriteit)", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:AddMarker", GetPlayerServerId(PlayerId()) .. "-assist", 526, 38, 10000, GetEntityCoords(PlayerPedId()), "Assistentie nodig (Hoge prioriteit)")

                TriggerServerEvent("dispatch:public", {"police", "kmar"}, {
                    taggs = {
                        [1] = {
                            name = "Status update",
                            color = "rgb(15, 107, 160)",
                        },
                        [2] = {
                            name = Player.MetaData.callid,
                            color = "rgb(55, 119, 95)",
                        },
                        [3] = {
                            name = Zero.Config.Jobs[Player.Job.name]['label'],
                            color = "rgb(58, 156, 91)",
                        },
                    },
                    title = "Assistentie nodig (Hoge prioriteit)",
                    info = {
                        [1] = {
                            icon = '<i class="fa-solid fa-map-location"></i>',
                            text = "Straat: " .. streetname,
                        },
                        [2] = {
                            icon = '<i class="fa-solid fa-file-signature"></i>',
                            text = "Naam: " .. Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname,
                        },
                        [3] = {
                            icon = '<i class="fa-solid fa-id-card-clip"></i>',
                            text = Player.MetaData.callid ~= nil and "Roepnummer: " ..  Player.MetaData.callid or "Geen roepnummer",
                        },
                    },
                    type = "police",
                    location = GetEntityCoords(PlayerPedId())
                })
            end,
        },
        [5] = {
            name = "Geef locatie door", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:AddMarker", GetPlayerServerId(PlayerId()) .. "-loc", 526, 38, 10000, GetEntityCoords(PlayerPedId()), "Locatie collega")

                TriggerServerEvent("dispatch:public", {"police", "kmar"}, {
                    taggs = {
                        [1] = {
                            name = "Informatie",
                            color = "rgb(15, 107, 160)",
                        },
                        [2] = {
                            name = Player.MetaData.callid,
                            color = "rgb(55, 119, 95)",
                        },
                        [3] = {
                            name = Zero.Config.Jobs[Player.Job.name]['label'],
                            color = "rgb(58, 156, 91)",
                        },
                    },
                    title = "Locatie van collega",
                    info = {
                        [1] = {
                            icon = '<i class="fa-solid fa-map-location"></i>',
                            text = "Straat: " .. streetname,
                        },
                        [2] = {
                            icon = '<i class="fa-solid fa-file-signature"></i>',
                            text = "Naam: " .. Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname,
                        },
                        [3] = {
                            icon = '<i class="fa-solid fa-id-card-clip"></i>',
                            text = Player.MetaData.callid ~= nil and "Roepnummer: " ..  Player.MetaData.callid or "Geen roepnummer",
                        },
                    },
                    type = "police",
                    location = GetEntityCoords(PlayerPedId())
                })
            end,
        },
    }

    if (Zero.Functions.HasItem("phone")) then
        if (Zero.Functions.GetPlayerData().MetaData.callid) then
            exports['zero-eye']:ForceOptions("markers", options, GetCurrentResourceName())
        else
            Zero.Functions.Notification("Meldingen", "Je moet een roepnummer instellen voor deze acties", "error")
        end
    else
        Zero.Functions.Notification("Meldingen", "Je moet een telefoon hebben voor deze opties", "error")
    end
end

markers = {}
RegisterNetEvent("Zero:Client-Police:AddMarker")
AddEventHandler("Zero:Client-Police:AddMarker", function(markerIndex, markerId, markerColour, time, location, name)
    if markers[markerIndex] then
        RemoveBlip(markers[markerIndex])
    end

    blip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite (blip, markerId)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, markerColour)
    SetBlipFlashes(blip, true)
    SetBlipFlashInterval(blip, 500)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)

    markers[markerIndex] = blip

    if time then
        Citizen.Wait(time)

        RemoveBlip(markers[markerIndex])
        markers[markerIndex] = nil
    end
end)

function streetName()
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    return street1 .. ", " .. street2
end

function LimitArea()
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    local options = {
        [1] = {
            name = "20 KM/H", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:LimitArea", "De maximum snelheid op "..street1.." "..street2.." is nu 20 KM/H")
            end,
        },
        [2] = {
            name = "30 KM/H", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:LimitArea", "De maximum snelheid op "..street1.." "..street2.." is nu 30 KM/H")
            end,
        },
        [3] = {
            name = "50 KM/H", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:LimitArea", "De maximum snelheid op "..street1.." "..street2.." is nu 50 KM/H")
            end,
        },
        [4] = {
            name = "Geen toegang voertuigen", 
            action = function() 
                TriggerServerEvent("Zero:Server-Police:LimitArea", "Het verkeer op "..street1.." "..street2.." is nu afgesloten, gebied betreden met een voertuig is strafbaar")
            end,
        },
    }
    exports['zero-eye']:ForceOptions("limits", options, GetCurrentResourceName())
end