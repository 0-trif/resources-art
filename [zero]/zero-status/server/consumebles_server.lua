local status = {
    ['food']   = 100,
    ['water']  = 100,
    ['stress'] = 100,
    ['health'] = 1000,
}

function status:new(x)
    x = x or {}
    setmetatable(x, self)
    self.__index = self
    return x
end

RegisterServerEvent("consumebles:sync")
AddEventHandler("consumebles:sync", function()
    local src = source
    local player = Zero.Functions.Player(src)
    local metadata = player.MetaData

    local playerAccount = status:new({
        food = metadata.food ~= nil and metadata.food or status.food,
        water = metadata.water ~= nil and metadata.water or status.water,
        stress = metadata.stress ~= nil and metadata.stress or status.stress,
        health = metadata.health ~= nil and metadata.health or status.health
    })

    TriggerClientEvent("consumebles:cl:sync", src, playerAccount)
end)

RegisterServerEvent("consumebles:set")
AddEventHandler("consumebles:set", function(x)
    local src = source
    local player = Zero.Functions.Player(src)

    player.Functions.SetMetaData("food", x.food)
    player.Functions.SetMetaData("water", x.water)
    player.Functions.SetMetaData("health", x.health)
end)

