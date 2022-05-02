local PlayerWeapons = {}

RegisterServerEvent("Zero:Server-Weapons:RequestWeapons")
AddEventHandler("Zero:Server-Weapons:RequestWeapons", function()
    local src = source
    TriggerClientEvent("Zero:Client-Weapons:SyncPlayerWeapons", src,  PlayerWeapons)
end)

RegisterServerEvent("Zero:Server-Weapons:ClearPedWeapon")
AddEventHandler("Zero:Server-Weapons:ClearPedWeapon", function()
    local src = source
    PlayerWeapons[src] = nil

    TriggerClientEvent("Zero:Client-Weapons:SyncPlayerWeaponsOne", -1,  PlayerWeapons[src], src)
end)

RegisterServerEvent("Zero:Server-Weapons:AddPedWeapon")
AddEventHandler("Zero:Server-Weapons:AddPedWeapon", function(item, datastash)
    local src = source

    PlayerWeapons[src] = PlayerWeapons[src] ~= nil and PlayerWeapons[src] or {}
    table.insert(PlayerWeapons[src], {
        item = item,
        datastash = datastash,
    })

    TriggerClientEvent("Zero:Client-Weapons:SyncPlayerWeaponsOne", -1,  PlayerWeapons[src], src)
end)