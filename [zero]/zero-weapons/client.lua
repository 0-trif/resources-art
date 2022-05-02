local weaponObjects = {}
local back = 0.0
local hip  = 0.0
local cachedRotation = {}
local createdHeavy = 0
local createdNormal = 0
local createdCache = {}
local createdPedWeapons = {}
local PlayerWeapons = {}

exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

Citizen.CreateThread(function()
    while not Zero.Vars.Spawned do
        Wait(0)
    end
    TriggerServerEvent("Zero:Server-Weapons:RequestWeapons")
end)

function ApplyAttachments(object, attachments, item)
    local config = exports['zero-inventory']:config()

    if attachments then
        for k,v in pairs(attachments) do
            local hash = config.weapons[item].attachments[k][v['index']]
            GiveWeaponComponentToWeaponObject(object, hash)
        end
    end
end

function createObjectWeapon(playerped, model,boneNumberSent,x,y,z,xR,yR,zR, attachments, item)
    local hash = GetHashKey(model)
    local bone = GetPedBoneIndex(playerped, boneNumberSent)

    RequestWeaponAsset(hash, 31, 26)
    while not HasWeaponAssetLoaded(hash) do
        Citizen.Wait(1)
    end

	attachedProp1 = CreateWeaponObject(hash, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp1, playerped, bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
    ApplyAttachments(attachedProp1, attachments, item)

    createdPedWeapons[playerped] = createdPedWeapons[playerped] ~= nil and createdPedWeapons[playerped] or {}

    table.insert(createdPedWeapons[playerped], attachedProp1)
end

function create(item, datastash, playerped)
    local config = exports['zero-inventory']:config()

    cachedRotation[playerped] = cachedRotation[playerped] ~= nil and cachedRotation[playerped] or {
        back = 0.0,
        hip  = 0.0,
        createdHeavy = 0,
        createdNormal = 0,
    }

    if (config.weapons[item]['heavy'] and cachedRotation[playerped].createdHeavy < 1) then     
        config.weapons[item]['back']  = config.weapons[item]['back'] ~= nil and config.weapons[item]['back'] or cachedRotation[playerped].back
        config.weapons[item]['rotation'] = config.weapons[item]['rotation'] ~= nil and config.weapons[item]['rotation'] or 50.0
        config.weapons[item]['top'] = config.weapons[item]['top'] ~= nil and config.weapons[item]['top'] or 0.12
  
        createObjectWeapon(playerped, config.weapons[item]['objective'], 24816, config.weapons[item]['top'] + 0.0, -0.17, 0.0 + config.weapons[item]['back'], 0.0, config.weapons[item]['rotation'], 0.0, datastash.attachments, item)
        cachedRotation[playerped].back = cachedRotation[playerped].back - 0.1
        cachedRotation[playerped].createdHeavy = cachedRotation[playerped].createdHeavy + 1
    end

    if (not config.weapons[item]['heavy']) then
        if cachedRotation[playerped].createdNormal < 1 then
            hip = hip - 0.1

            datastash.attachments = datastash.attachments ~= nil and datastash.attachments or {}
            createObjectWeapon(playerped, config.weapons[item]['objective'], 51826, 0.12, 0.05, 0.1, -90.0, -105.0, -100.0, datastash.attachments, item)
            cachedRotation[playerped].createdNormal = cachedRotation[playerped].createdNormal + 1
        end
    end
end

function nonAllowed()
    local bags = {
        0,
    }

    for k,v in pairs(bags) do
        if v == index then
            return true
        end
    end
end

function validDecal(index)
    local decals = {
        6,
        20,
        25
    }

    for k,v in pairs(decals) do
        if v == index then
            return true
        end
    end
    return false
end

function validAcce(index)
    local acce = {
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        20,
        43,
        151,
        152,
        153,
        154,
        155,
        156,
        157,
    }

    for k,v in pairs(acce) do
        if v == index then
            return true
        end
    end
    return false
end

function CheckWeaponsInventory()
    local config = exports['zero-inventory']:config()
    local inventory = exports['zero-inventory']:getInventory()

    local bagIndex = GetPedDrawableVariation(PlayerPedId(), 5)

    local one_ = GetPedDrawableVariation(PlayerPedId(), 10)
    local two_ = GetPedDrawableVariation(PlayerPedId(), 7)

    if bagIndex <= 0 or nonAllowed(bagIndex) then

        for k,v in pairs(inventory) do
            local item = v['item']
            local type = config.items[item]['type']
            local heavy = config.weapons[item] ~= nil and config.weapons[item]['heavy']
            local weaponslot = exports['zero-inventory']:weapon()

            if not heavy and not validDecal(one_) and not validAcce(two_) then
                if (type and type == "weapon" and not config.weapons[item]['ignoreObject']) then
                    if k ~= weaponslot then
                        TriggerServerEvent("Zero:Server-Weapons:AddPedWeapon", item, v.datastash)
                    end
                end
            else
                if heavy then
                    if (type and type == "weapon" and not config.weapons[item]['ignoreObject']) then
                        if k ~= weaponslot then
                            TriggerServerEvent("Zero:Server-Weapons:AddPedWeapon", item, v.datastash)
                        end
                    end
                end
            end
        end
    end
end

RegisterNetEvent("resyncWeaponProps")
AddEventHandler("resyncWeaponProps", function()
    TriggerServerEvent("Zero:Server-Weapons:ClearPedWeapon")
    CheckWeaponsInventory()
end)

function clearGroundWeapons()
    for key,val in pairs(createdPedWeapons) do
        for k,v in pairs(val) do
            if not IsEntityAttachedToAnyPed(v) then
                NetworkRequestControlOfNetworkId(NetworkGetNetworkIdFromEntity(v))
                DeleteObject(v)
                table.remove(createdPedWeapons[key], k)
            end
        end
    end
end

function removeAllWeapons(playerped)
    if createdPedWeapons[playerped] then
        for k,v in pairs(createdPedWeapons[playerped]) do
            DeleteObject(v)
        end

        createdPedWeapons[playerped] = nil

        cachedRotation[playerped] = {
            back = 0.0,
            hip  = 0.0,
            createdHeavy = 0,
            createdNormal = 0,
        }
    end
end

RegisterNetEvent("Zero:Client-Weapons:SyncPlayerWeapons")
AddEventHandler("Zero:Client-Weapons:SyncPlayerWeapons", function(x)
    PlayerWeapons = x
end)

RegisterNetEvent("Zero:Client-Weapons:SyncPlayerWeaponsOne")
AddEventHandler("Zero:Client-Weapons:SyncPlayerWeaponsOne", function(x, serverid)
    local serverid = serverid
    local player = GetPlayerFromServerId(serverid)
    local ped = GetPlayerPed(player)

    removeAllWeapons(ped)

    cachedRotation[ped]= {
        back = 0.0,
        hip  = 0.0,
        createdHeavy = 0,
        createdNormal = 0,
    }
    PlayerWeapons[serverid] = x
    createdCache[ped] = nil
end)

Citizen.CreateThread(function()
    while true do
        local players = Zero.Functions.GetPlayers()
        local ply = PlayerPedId()
        local coord = GetEntityCoords(ply)

        for k,v in pairs(players) do
            local playerped = GetPlayerPed(players[k])
            local serverid = GetPlayerServerId(players[k])
            local position = GetEntityCoords(playerped)

            if PlayerWeapons[serverid] then
                local distance = #(position - coord)

                if distance <= 10 then
                    if createdCache[playerped] == nil then
                        removeAllWeapons(playerped)
                        for k,v in pairs(PlayerWeapons[serverid]) do
                            create(v.item, v.datastash, playerped)
                        end
                        createdCache[playerped] = true
                        clearGroundWeapons()
                    end
                end
            end
        end

        Citizen.Wait(100)
    end
end)