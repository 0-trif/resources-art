Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end

    Wait(2000)

    SendNUIMessage({
        action = "SetupPackets",
        packets = laptop.packets,
    })
end)

RegisterNUICallback("ui-buyVehiclePack", function(ui)
    local index = tonumber(ui.id) + 1

    if laptop.packets[index] then
        TriggerServerEvent("Zero:Server-Laptop:BuyPacket", index)
    end
end)