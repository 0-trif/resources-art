exports("object", function(cb) cb(Zero) end)

RegisterServerEvent("Zero:Server-Core:Object")
AddEventHandler("Zero:Server-Core:Object", function(cb)
    cb(Zero)
end)