local objectModel = 303280717
local foundObjects = {}
local loaded = false

exports['zero-core']:object(function(O) Zero = O end)

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end
    
    TriggerServerEvent("Zero:Server-Robbery:Request")
end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

RegisterNetEvent("Zero:Client-Robbery:UpdateSafes")
AddEventHandler("Zero:Client-Robbery:UpdateSafes", function(safes)
    foundObjects = safes
    loaded = true
end)

Citizen.CreateThread(function()
    while not loaded do Wait(0) end

    while true do
        local timer = 750
        local ply = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ply))

        currentSafe = nil
        
        local object = GetClosestObjectOfType(x, y, z, 5.0, objectModel)

        if object then    
            local distance = #(GetEntityCoords(object) - vector3(x, y, z))
            if distance <= 1 then
                timer = 0
                local x,y,z = table.unpack(GetEntityCoords(object))

                foundObjects[tostring(x .. y .. z)] = foundObjects[tostring(x .. y .. z)] ~= nil and foundObjects[tostring(x .. y .. z)] or {
                    locked = true
                }

                if foundObjects[tostring(x .. y .. z)].locked then
                    currentSafe = tostring(x .. y .. z)
                    TriggerEvent("Zero:Client-Inventory:DisplayUsable", "lockpick")
                else
                    draw(x,y,z, "Geopend..")
                end
            end
        end


        Wait(timer)
    end
end)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(target)
    local item, slot, amount = Zero.Functions.HasItem("lockpick")

    if item and currentSafe then
        if foundObjects[currentSafe].locked then
            lockpicking = true

            for i = 1, 10 do

                local finished = exports['zero-skill']:skill("Kassa lockpicken ("..i.."/10)", math.random(5000, 9000))

                if (i == 5) then
                    PoliceCall()
                end
                
                if finished and i == 10 then
                    lockpicking = false
                    StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                    Zero.Functions.Notification("Lockpick", "Lockpick geslaagd", "success")

                    if currentSafe then
                        TriggerServerEvent("Zero:Server-Robbery:CheckSafe", currentSafe)
                    end
                elseif not finished then
                    lockpicking = false
                    Zero.Functions.Notification("Lockpick", "Lockpick poging mislukt", "error")

                    local random = math.random(0, 100)
                    if random > 40 then
                        PoliceCall()
                    end
                    if random < 20 then
                        TriggerServerEvent("Zero:Server-Inventory:RemoveSlot", slot)
                    end

                    break
                end
            end
        else
            Zero.Functions.Notification("Lockpick", "Kassa is leeg", "error")
        end
    end
end)

function draw(x,y,z, text, lines)
    if lines == nil then
        lines = 1
    end

	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125 * lines, 0.017+ factor, 0.03 * lines, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        timer = 750

        if lockpicking then
            timer = 2000

            loadAnimDict("veh@break_in@0h@p_m_one@")

            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
        end

        Wait(timer)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

function PoliceCall()
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
        title = "Winkel overval bezig",
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
                text = "Melding: iemand probeerd de kassa open te breken",
            },
        },
        type = "error",
        location = GetEntityCoords(PlayerPedId())
    })

    -- Zero.Functions.Notification("Alarm", "Politie is gebeld", "error")
end