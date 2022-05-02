
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isEscorted then
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
            EnableControlAction(0, Keys['T'], true)
            EnableControlAction(0, Keys['E'], true)
            EnableControlAction(0, Keys['ESC'], true)
        end

        if isHandcuffed then
            DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['SPACE'], true) -- Jump
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F'], true) -- Also 'enter'?

			DisableControlAction(0, Keys['F1'], true) -- Disable phone
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

            Zero.Functions.GetPlayerData(function(x)
                isdead = x.MetaData.dead ~= nil and x.MetaData.dead or false
            end)
            

            RequestAnimDict("mp_arresting")
            
            if ( not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) and not isdead then
                if not exports['carry']:beingCarried() then
                    local ped = exports['zero-clothing_new']:ped()

                    if ped then
                        if ped:male() then
                            ped:ApplyVariation("accessory", 41, "main")
                            ped:ApplyVariation("accessory", 0, "other")
                        else
                            ped:ApplyVariation("accessory", 25, "main")
                            ped:ApplyVariation("accessory", 0, "other")
                        end
                    end

                
                    if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3) then 
                        TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0) 
                    end
                end
            end
        end

        if not isHandcuffed and not isEscorted then
            Citizen.Wait(2000)
        end
    end
end)


Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("police-vest", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        if (entity and IsEntityAVehicle(entity)) then
            if (GetVehicleClass(entity) == 18) then
                return true, GetEntityCoords(entity)
            end
        end
    end, {
        [1] = {
            name = "Vesten", 
            action = function() 
                TriggerEvent("Zero:Client-Clothing:OpenPoliceVest")
            end,
        },
    })

    --[[
        
    exports['zero-eye']:looped_runtime("open-job-vault", function(coords, entity)
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply)
        local pos = {x = 456.29901123047, y = -994.76043701172, z = 30.723760604858,h = 235.0064239502}
        local distance = #(coords - vector3(pos.x, pos.y, pos.z))

        if (distance  <= 5) then
            return true, vector3(pos.x, pos.y, pos.z)
        end

    end, {
        [1] = {
            name = "Open bedrijfskluis", 
            action = function() 
                TriggerEvent("disableEye")

                TriggerServerEvent("Zero:Server-Job:MoneySafe")
            end,
        },
    }, GetCurrentResourceName(), 10)
    ]]
end)


Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 344) then
            Zero.Functions.GetPlayerData(function(x)
                if x.Job.name == "police" or x.Job.name == "kmar" then
                    TriggerServerEvent("Zero:Server-Police:AddMarker", GetPlayerServerId(PlayerId()) .. "-noodknop", 526, 59, 20000, GetEntityCoords(PlayerPedId()), "Noodknop")

                    local streetname = streetName()
                    local Player = Zero.Functions.GetPlayerData()
            
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
                    Citizen.Wait(20000)
                end
            end)
        end
        Citizen.Wait(0)
    end
end)
