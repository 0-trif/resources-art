Modules['mechanic'] = {}
Modules['mechanic'].Functions = {} 
Modules['mechanic'].Config = {
    [1] = {
        ['loc'] = {x = -356.16, y = -160.32, z = 38.72, h = 28.38},
        ['text'] = "Garage",
        ['functie'] = "OpenGarage",
    },
    [2] = {
        ['loc'] = {x = -350.38, y = -171.122, z = 39.01, h = 294.63},
        ['text'] = "Kloesoe",
        ['functie'] = "OpenKloesoe",
    },
}
Modules['mechanic'].options = {}

Citizen.CreateThread(function()
    local coord = {x = -368.12939453125, y = -129.17286682129, z = 38.702438354492, h = 298.89657592773}
    blip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(blip, 380)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 5)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("ANWB")
    
    EndTextCommandSetBlipName(blip)
end)


Modules['mechanic'].Run = function()
    local player = PlayerPedId()
    local coord = GetEntityCoords(player)

    for k,v in ipairs(Modules['mechanic'].Config) do
        local distance = #(coord - vector3(v.loc.x, v.loc.y, v.loc.z))

        if (distance <= 5 and distance > 1) then
            timer = 0
            
            Zero.Functions.DrawMarker(v.loc.x, v.loc.y, v.loc.z)
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, v.text)
        elseif (distance < 1) then
            timer = 0
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, "~g~E~w~ - "..v.text.."")

            if IsControlJustPressed(0, 38) then
                Modules['mechanic'].Functions[v.functie]()
            end
        end
    end
end


Modules['mechanic'].Functions['OpenGarage'] = function()
    if JobModule == "mechanic" and JobDuty then
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            DeleteEntity(GetVehiclePedIsIn(ped))
        else
            exports['zero-garages']:openMenu(Shared.Config.mechanic.Vehicles)
        end
    end
end

Modules['mechanic'].Functions['OpenKloesoe'] = function()
    TriggerServerEvent("Zero:Server-Police:OpenKloesoe")
end


local RemoveVehicle = function(entity)
    Zero.Functions.Progressbar("rem_veh", "Voertuig verwijderen..", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {

    }, {}, {}, function() -- Done
        ClearPedTasksImmediately(PlayerPedId(), true)
        NetworkRequestControlOfEntity(entity)
        DeleteEntity(entity)
    end, function() -- Cancel
        ClearPedTasksImmediately(PlayerPedId(), true)
    end)
end

RegisterNetEvent("Zero:Client-Mechanic:UsedItem")
AddEventHandler("Zero:Client-Mechanic:UsedItem", function(slot, item)
    if (item.item == "sponge") then
        TriggerEvent("Zero:Client-Mechanic:WashVehicle", slot)
    elseif (item.item == "repairkit") then
        TriggerEvent("Zero:Client-Mechanic:Repairkit", slot)
    elseif (item.item == "tire") then
        useTire()
        TriggerServerEvent("Zero:Server-Inventory:RemoveSlot", slot)
    elseif (item.item == "petrolcan") then
        TriggerEvent("Zero:Client-Mechanic:UsedPetrolcan", slot)
    end
end)

RegisterNetEvent("Zero:Client-Mechanic:UsedPetrolcan")
AddEventHandler("Zero:Client-Mechanic:UsedPetrolcan", function(slot)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        if IsPedInAnyVehicle(playerPed) then
            currentVeh = GetVehiclePedIsIn(GetPlayerPed(-1))
        else
            currentVeh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end
    end


    if DoesEntityExist(currentVeh) then
        LoadAnimDict("timetable@gardener@filling_can")
        TaskPlayAnim(PlayerPedId(), "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

        Zero.Functions.Progressbar("repair_veh", "Aan het tanken..", 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {

        }, {}, {}, function() -- Done
            ClearPedTasksImmediately(PlayerPedId(), true)
            exports['LegacyFuel']:SetFuel(currentVeh, 100.00)
            TriggerServerEvent("Zero:Server-Inventory:RemoveSlot", slot)
        end, function() -- Cancel
            ClearPedTasksImmediately(PlayerPedId(), true)
        end)
    end
end)

RegisterNetEvent("mechanic:payed:repair")
AddEventHandler("mechanic:payed:repair", function()
    local ply = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ply)

    local money = Zero.Functions.GetPlayerData().Money.cash
    local money2 = Zero.Functions.GetPlayerData().Money.bank
    
    Zero.Functions.Progressbar("repair_veh", "Voertuig repareren..", 7500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {

    }, {}, {}, function() -- Done
        if money >= 800 or money2 >= 800 then
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            ClearPedTasksImmediately(vehicle)

            TriggerServerEvent("mechanic:payed:repair")
        else
            Zero.Functions.Notification("Reparatie", "Niet genoeg geld", "error")
        end
    end, function() -- Cancel
        
    end)
end)

RegisterNetEvent("Zero:Client-Mechanic:Repairkit")
AddEventHandler("Zero:Client-Mechanic:Repairkit", function(slot)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        currentVeh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if IsPedInAnyVehicle(playerPed) then
        return
    end

    if DoesEntityExist(currentVeh) then
        ExecuteCommand("e mechanic")

        for i = 1, 3 do
            local random = math.random(5000.00, 60000.00)

            local finished = exports["zero-skill"]:skill("Repairkit ("..i.."/3)", math.random(4000, 6000))
            if finished then
                if i == 3 then
                    ExecuteCommand("e c")

                    SetVehicleFixed(currentVeh)
                    SetVehicleDeformationFixed(currentVeh)
                    SetVehicleUndriveable(currentVeh, false)
                    ClearPedTasksImmediately(playerPed)
                    TriggerServerEvent("Zero:Server-Inventory:RemoveSlot", slot)
                end
            else
                ExecuteCommand("e c")
                break
            end
        end
    end
end)

RegisterNetEvent("Zero:Client-Mechanic:WashVehicle")
AddEventHandler("Zero:Client-Mechanic:WashVehicle", function(slot)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        if IsPedInAnyVehicle(playerPed) then
            currentVeh = GetVehiclePedIsIn(GetPlayerPed(-1))
        else
            currentVeh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end
    end

    if DoesEntityExist(currentVeh) then
        ExecuteCommand('e clean2')

        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
        Zero.Functions.Progressbar("repair_veh", "Voertuig wassen..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {

        }, {}, {}, function() -- Done
            ClearPedTasksImmediately(PlayerPedId(), true)
            ExecuteCommand('e c')
            SetVehicleDirtLevel(currentVeh)
            WashDecalsFromVehicle(currentVeh, 1.0)
            TriggerServerEvent("Zero:Server-Inventory:RemoveSlot", slot)
        end, function() -- Cancel
            ClearPedTasksImmediately(PlayerPedId(), true)
        end)
    end
end)

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("del-veh-m", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        if IsEntityAVehicle(entity) then
            if distance <= 20 and Modules[JobModule] and JobDuty and JobModule == "mechanic" then
                return true
            end
        end
    end, {
        [1] = {
            name = "Verwijder voertuig", 
            action = function(entity) 
                RemoveVehicle(entity)
            end,
        },
    }, GetCurrentResourceName())

end)

function useTire()
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    obj = CreateObject(GetHashKey('prop_wheel_01'), x, y, z, true, true, true)
end

Citizen.CreateThread(function()
    TriggerEvent("prop:run", GetHashKey('prop_wheel_01'),function(remove)

        local vehicle = Zero.Functions.closestVehicle()

        if vehicle then
            local wheels = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
            local tireIndex = {
                ["wheel_lf"] = 0,
                ["wheel_rf"] = 1,
                ["wheel_lm1"] = 2,
                ["wheel_rm1"] = 3,
                ["wheel_lm2"] = 45,
                ["wheel_rm2"] = 47,
                ["wheel_lm3"] = 46,
                ["wheel_rm3"] = 48,
                ["wheel_lr"] = 4,
                ["wheel_rr"] = 5,
            }

            for k,v in ipairs(wheels) do
                local boneIndex = GetEntityBoneIndexByName(vehicle, v)
                local wheel_loc = GetWorldPositionOfEntityBone(vehicle, boneIndex)
                local wheel_dist = #(wheel_loc - GetEntityCoords(PlayerPedId()))

                local i = tireIndex[v]
                
                if wheel_dist <= 2.2 and wheel_dist > 1.5 then
                    Zero.Functions.DrawText(wheel_loc.x, wheel_loc.y, wheel_loc.z, "band ("..GetVehicleWheelHealth(vehicle, i)..")", 1)
                elseif (wheel_dist < 1.5) then
                    Zero.Functions.DrawText(wheel_loc.x, wheel_loc.y, wheel_loc.z, "~g~E~w~ - Band repareren", 1)

                    if IsControlJustPressed(0, Zero.Config.Keys['E']) then
                        SetVehicleWheelHealth(vehicle, i, 1000)
                        SetVehicleTyreFixed(vehicle, i)

                        remove()
                    end
                end
            end
        end
    end)
end)

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end