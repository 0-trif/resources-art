RegisterServerEvent("Zero:Server-Ambulance:UseHeals")
AddEventHandler("Zero:Server-Ambulance:UseHeals", function(item, playerid)
    local src = source
    
    
    if (item.item == "medkit") then
        TriggerClientEvent("Zero:Client-Status:Revive", playerid, false)    
    elseif (item.item == "bandage") then
        TriggerClientEvent("Zero:Client-Status:Revive", playerid, true)    
    end
end)

RegisterServerEvent("Zero:Server-Ambulance:CheckIn")
AddEventHandler("Zero:Server-Ambulance:CheckIn", function()
    local src = source
    local ambulance = Zero.Functions.GetPlayersByJob("ambulance", true)
    
    if (#ambulance >= 2) then
        for k,v in pairs(ambulance) do
            TriggerClientEvent("phone:notification", v.User.Source, "https://th.bing.com/th/id/R.4b73703c261725dc1de562d22e2a3aee?rik=rEs4l8z287hD%2fg&riu=http%3a%2f%2fclipart-library.com%2fdata_images%2f212230.jpg&ehk=fGR0vpj4A%2fbLP%2b9sjnuHKJh6Ab0g%2fcQQz0905sCSRh0%3d&risl=&pid=ImgRaw&r=0", "Meldingen", "Er staat iemand te wachten bij de balie van het ziekenhuis!", 8000, "x")
        end
    else
        TriggerClientEvent("Zero:Client-Status:Revive", src, false)    
        Wait(0)
        TriggerClientEvent("Zero:Client-Ambulance:ReviveInBed", src, false)  
    end
end)
