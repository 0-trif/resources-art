
local craftingx, craftingy, craftingz = 435.27923583984, -1738.5953369141, 29.246934890747

exports['zero-core']:object(function(O) Zero = O end)

function mineBlip()
    local x,y,z = craftingx, craftingy, craftingz

    blip = AddBlipForCoord(x, y, z)

	SetBlipSprite(blip, 465)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 78)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Onbekend")
    EndTextCommandSetBlipName(blip)
end


Citizen.CreateThread(function()
    mineBlip()
    exports['zero-eye']:looped_runtime("cra-open", function(coords, entity)
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)
        local distance = #(pos - vector3(craftingx, craftingy, craftingz))

        if entity and entity == craftingbench and distance <= 3 then
            return true, GetEntityCoords(entity)
        end
    end, {
        [1] = {
            name = "Open crafting", 
            action = function() 
                TriggerServerEvent("Zero:Server-Inventory:Crafting")
            end,
        },
    }, GetCurrentResourceName(), 10)
end)

Citizen.CreateThread(function()
    while true do
        local ply = PlayerPedId()
        local timer = 750
        local pos = GetEntityCoords(ply)
        local mine_distance = #(pos - vector3(craftingx, craftingy, craftingz))
        
        if mine_distance <= 25 then
            timer = 0
            if not DoesEntityExist(craftingbench) then
                craftingbench = CreateObject(GetHashKey("prop_tool_bench02"), craftingx, craftingy, craftingz - 1, false, false, false)
                FreezeEntityPosition(craftingbench, true)
                SetEntityHeading(craftingbench, 98.0)
                SetEntityAsMissionEntity(craftingbench, true, true)
                SetEntityCanBeDamaged(craftingbench, false)
                SetEntityInvincible(borcraftingbenchder, true)
            end
        end
        Wait(timer)
    end
end)
