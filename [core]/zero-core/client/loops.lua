

Citizen.CreateThread(function()
    while true do
        if (Zero.Vars.Spawned) then
            local ped = PlayerPedId()
        
            local x,y,z = table.unpack(GetEntityCoords(ped))
            local h = GetEntityHeading(ped)
    
            TriggerServerEvent("Zero:Server-Core:UpdateLocation", x,y,z,h)
        end

        Citizen.Wait(5000)
    end
end)

--[[
    Citizen.CreateThread(function()
    while true do
        if Zero.Vars.HidePlayers then
            hidePlayers()
        else
            ShowEnsurePlayers()
            Wait(3000)
        end
        
        Citizen.Wait(0)
    end
end)
]]