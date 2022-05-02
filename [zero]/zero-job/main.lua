exports['zero-core']:object(function(O) Zero = O end)

Modules = {}

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true

    Zero.Functions.GetPlayerData(function(PlayerData)
        if (PlayerData.MetaData.ishandcuffed) then
            isHandcuffed = PlayerData.MetaData.ishandcuffed ~= nil and PlayerData.MetaData.ishandcuffed or false
        end
    end)
end)

RegisterNetEvent("Zero:Client-Core:JobUpdate")
AddEventHandler("Zero:Client-Core:JobUpdate", function(JobData)
    Zero.Player.Job = JobData

    JobModule = Zero.Player.Job.name
    JobDuty = Zero.Player.Job.duty
end)

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do 
        Wait(0)
    end

    Zero.Functions.GetPlayerData(function(PlayerData)
        Zero.Player = PlayerData
        JobModule = Zero.Player.Job.name
        JobDuty = Zero.Player.Job.duty

        if (PlayerData.MetaData.ishandcuffed) then
            isHandcuffed = PlayerData.MetaData.ishandcuffed ~= nil and PlayerData.MetaData.ishandcuffed or false
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        timer = 750

        if (JobModule) then
            if Modules[JobModule] then
                if JobDuty then
                    Modules[JobModule].Run()
                else
                    timer = 2000
                end
            end
        end

        Citizen.Wait(timer)
    end
end)

Citizen.CreateThread(function()
    -- DUTY
    Citizen.CreateThread(function()
        exports['zero-eye']:looped_runtime("duty-t", function(coords, entity)
            local ply = PlayerPedId()
            local coords = GetEntityCoords(ply)

            for k,v in pairs(Shared.Config.Duty) do
                local distance = #(vector3(v.x, v.y, v.z) - coords)
                if (distance  <= 5) then
                    return true, vector3(v.x, v.y, v.z)
                end
            end
        end, {
            [1] = {
                name = "Inklokken", 
                action = function() 
                    TriggerServerEvent("Zero:Server-job:Duty", true)
                end,
            },
            [2] = {
                name = "Uitklokken", 
                action = function() 
                    TriggerServerEvent("Zero:Server-job:Duty", false)
                end,
            },
        }, GetCurrentResourceName(), 10)
    end)

    Citizen.CreateThread(function()
        exports['zero-eye']:looped_runtime("job-safe",function(coords, entity)
            local ply = PlayerPedId()
            local coords = GetEntityCoords(ply)

            for k,v in pairs(Shared.Config.Safes) do

                local distance = #(vector3(v.x, v.y, v.z) - coords)
                if (distance  <= 5) then
            
                    return true, vector3(v.x, v.y, v.z)
                end
            end
        end, {
           [1] = {
            name = "Open bedrijfskluis", 
            action = function() 
                TriggerEvent("disableEye")

                TriggerServerEvent("Zero:Server-Job:MoneySafe")
            end,
           }
        })
    end)
    -- job options

    exports['zero-eye']:looped_runtime("job-options",function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)
        local distance = #(plyc - coords)

        if distance <= 20 and Modules[JobModule] and JobDuty then
            return true
        end
    end, {
        [1] = {
            name = "Baan opties", 
            action = function() 
                exports['zero-eye']:ForceOptions(JobModule, Modules[JobModule]['options'], GetCurrentResourceName())
            end,
        },
    }, GetCurrentResourceName(), 9)

end)

