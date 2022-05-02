weapons = {}
weapons.data = {
    ['slot'] = nil
}

weapons.config = {}
weapons.config.weapons = shared.config.weapons

function checkWeapons()
    local ply  = PlayerPedId()

    if weapons.data.slot then
        if (inventory.data.items[weapons.data.slot]) then
            if weapons.data.item ~= inventory.data.items[weapons.data.slot].item then
                RemoveAllPedWeapons(ply)
                TriggerEvent("resyncWeaponProps")
                weapons.data.slot = nil
            end
        else
            RemoveAllPedWeapons(ply)
            TriggerEvent("resyncWeaponProps")
            weapons.data.slot = nil
        end
    end
end

exports("weapon", function()
    return weapons.data.slot
end)

weapons.apply = function(slot)
    local slot = tonumber(slot)
    local ply  = PlayerPedId()


    if GetCurrentPedWeapon(ply) then
        RemoveAllPedWeapons(ply)
        weapons.data.slot = nil
        TriggerEvent("resyncWeaponProps")
    else
        if (slot) then
            if (inventory.data.items) then
                if (inventory.data.items[slot]) then
                    if (weapons.config['weapons'][inventory.data.items[slot].item]) then
                        
                        if inventory.data.items[slot].datastash.durability > 0 then
                            local model = weapons.config['weapons'][inventory.data.items[slot].item].objectivemodel

                            RemoveAllPedWeapons(ply)
                            weapons.data.slot = nil
                            GiveWeaponToPed(ply, model, tonumber(inventory.data.items[slot].datastash.ammo), false, true)

                            weapons.data.slot = slot
                            weapons.data.item = inventory.data.items[slot].item
                            weapons.data.model = model
                            weapons.data.ammotype = weapons.config['weapons'][inventory.data.items[slot].item].ammotype

                            weapons.LoadWeaponComponents()
                            TriggerEvent("resyncWeaponProps")
                        end
                    end
                end
            end
        end
    end
end

weapons.LoadWeaponComponents = function()
    local slot = weapons.data.slot
    if inventory.data.items[slot].datastash.attachments then
        for k,v in pairs(inventory.data.items[slot].datastash.attachments) do
            if (shared.config.weapons[weapons.data.item].attachments[k]) then
                local model_a = shared.config.weapons[weapons.data.item].attachments[k][tonumber(v.index)]
       
                GiveWeaponComponentToPed(PlayerPedId(), weapons.data.model, GetHashKey(model_a))
            end
        end
    end
end

weapons.ammo = function(slot)
    local slot = tonumber(slot)
    local ply  = PlayerPedId()

    if (slot) then
        if (inventory.data.items) then
            if (inventory.data.items[slot]) then
                if (weapons.data.ammotype == inventory.data.items[slot].item) then
                    if (weapons.data.slot) then
                        local max_ammo = weapons.config['weapons'][inventory.data.items[weapons.data.slot].item].objectammo
                        local current_ammo = GetAmmoInPedWeapon(ply, weapons.config['weapons'][inventory.data.items[weapons.data.slot].item].objectivemodel)

                        if (current_ammo < max_ammo) then
                            Zero.Functions.Progressbar("repair_veh", "kogels laden..", 3000, false, true, {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                    
                            }, {}, {}, function() -- Done
                                local new_ammo = current_ammo + weapons.config['weapons'][inventory.data.items[weapons.data.slot].item].objectclip
                                local new_ammo = new_ammo <= max_ammo and new_ammo or max_ammo
    
                                SetPedAmmo(ply, weapons.config['weapons'][inventory.data.items[weapons.data.slot].item].objectivemodel, new_ammo)
    
                                TriggerServerEvent("Zero-inventory:server:saveammo", weapons.data.slot, new_ammo)
                                TriggerServerEvent("Zero-inventory:server:removeAmmo", slot)
                            end, function() -- Cancel
                                ClearPedTasksImmediately(PlayerPedId(), true)
                            end)             
                        end
                    end
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()

        if IsPedShooting(ped) then
  
            Wait(100)

            if weapons.data.slot and inventory.data.items[weapons.data.slot] then

                if (inventory.data.items[weapons.data.slot].datastash.durability <= 0) then
                    RemoveAllPedWeapons(ped)
                    weapons.data.slot = nil
                    TriggerEvent("resyncWeaponProps")
                end

                if (weapons.data.slot) then
                    TriggerServerEvent("Zero-inventory:server:saveammo", weapons.data.slot, GetAmmoInPedWeapon(ped, weapons.config['weapons'][inventory.data.items[weapons.data.slot].item].objectivemodel))
                    TriggerServerEvent("Zero-inventory:server:saveDurability", weapons.data.slot)
                end
            end
        end

        Wait(0)
    end
end)