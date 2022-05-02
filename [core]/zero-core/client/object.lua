exports("object", function(cb) cb(Zero) end)

RegisterNetEvent("Zero:Client-Core:Object")
AddEventHandler("Zero:Client-Core:Object", function(cb)
    cb(Zero)
end)

Citizen.CreateThread(function() -- loop for starting core registration.
    while true do
        
        repeat 
            Citizen.Wait(0)
        until (NetworkIsSessionStarted())

        TriggerServerEvent("Zero:Server-Core:NetworkStarted")
        break

        Citizen.Wait(0)
    end
end)
