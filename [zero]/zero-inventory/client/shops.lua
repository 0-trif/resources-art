

local function open_shop_ui(index)
    Zero.Functions.GetPlayerData(function(PlayerData)
        local _data = shared.config.shops[index]
        local _items = _data['items']
    
        if _data.job then
            if (_data.job ~= PlayerData.Job.name) then
                return
            end
        end
    
        TriggerEvent("inventory:client:toggle")
    
        last_shop_index = index
    
        SendNUIMessage({
            action = "create_shop",
            items = _data.items,
            event = "Zero-inventory:shops:buy",
            slots = #_data.items,
            label = _data.name,
        })
    end)
end

CreateThread(function()
    for k,v in pairs(shared.config.shops) do
        local blip = AddBlipForCoord(v.location.x, v.location.y, v.location.z)
		SetBlipSprite (blip, 52)
		SetBlipScale  (blip, 0.75)
		SetBlipDisplay(blip, 4)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Winkel")
		EndTextCommandSetBlipName(blip)
    end
end)

CreateThread(function()
    while true do
        local sleepthread = 500
        for k,v in pairs(shared.config.shops) do
            local distance = #(v.location - GetEntityCoords(PlayerPedId()))

            if (distance <= 5) then
                sleepthread = 0
                Zero.Functions.DrawMarker(v.location.x, v.location.y, v.location.z)

                TriggerEvent("interaction:show", "E - Winkel", function()
                    open_shop_ui(k)
                end)
            end
        end
        Wait(sleepthread)
    end
end)

exports("shop", function(x)
    SendNUIMessage(x)
end)

RegisterNetEvent("Zero-inventory:client:openShop")
AddEventHandler("Zero-inventory:client:openShop", function(items)
    TriggerEvent("inventory:client:toggle")
    SendNUIMessage({
        action = "create_shop",
        items = items,
        event = "Zero-inventory:server:policeStash",
        slots = #items,
        label = "Kloesoe",
    })
end)