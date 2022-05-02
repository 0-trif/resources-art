pet = {
    ['health'] = 100,
    ['food'] = 100,
    ['location'] = nil,
    ['owner'] = nil,
}

function pet:new(x)
    x = x or {}
    setmetatable(x, self)
    self.__index = self
    return x
end

function pet:update(index)
    Zero.Functions.ExecuteSQL(false, "UPDATE `pets` SET `loc` = '"..json.encode(CREATED_PETS[index].loc).."', `sleeping` = '"..CREATED_PETS[index].sleeping.."', `dead` = '"..CREATED_PETS[index].dead.."', `label` = '"..CREATED_PETS[index].label.."' WHERE `id` = '"..CREATED_PETS[index].id.."'")
end

-- events
RegisterServerEvent("Zero:Server-Pets:ReqSync")
AddEventHandler("Zero:Server-Pets:ReqSync", function()
    local src = source
    local Player = Zero.Functions.Player(src)
    local cid = Player.User.Citizenid

    for k,v in pairs(CREATED_PETS) do
        if v.ownerId == cid then
            v.owner = src
        end
    end

    TriggerClientEvent("Zero:Client-Pets:SyncPets", source, CREATED_PETS)
end)

RegisterServerEvent("Zero:Server-Pets:SetSleep")
AddEventHandler("Zero:Server-Pets:SetSleep", function(index, bool)
    if bool then
        bool = 1
    else
        bool = 0
    end
    
    CREATED_PETS[index]['sleeping'] = bool

    TriggerClientEvent("Zero:Client-Pets:SleepStatus", -1, index, bool)
end)

RegisterServerEvent("Zero:Server-Pets:SetName")
AddEventHandler("Zero:Server-Pets:SetName", function(index, value)
    CREATED_PETS[index]['label'] = value
end)

RegisterServerEvent("Zero:Server-Pets:UpdatePetPosition")
AddEventHandler("Zero:Server-Pets:UpdatePetPosition", function(index, loc)
    CREATED_PETS[index]['loc'] = {
        x = loc.x,
        y = loc.y, 
        z = loc.z
    }

    TriggerClientEvent("Zero:Client-Pets:UpdateLocation", -1, index, loc)
end)

RegisterServerEvent("Zero:Server-Pets:SetDead")
AddEventHandler("Zero:Server-Pets:SetDead", function(index, bool)
    if bool then
        bool = 1
    else
        bool = 0
    end
    
    CREATED_PETS[index]['dead'] = bool
end)
