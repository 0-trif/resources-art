local VehicleList = {}
exports['zero-core']:object(function(O) Zero = O end)

Zero.Functions.CreateCallback('vehiclekeys:CheckHasKey', function(source, cb, plate)
    local Player = Zero.Functions.Player(source)
    cb(CheckOwner(plate, Player.User.Citizenid))
end)

WhiteListed = {}

RegisterServerEvent('vehiclekeys:server:WhiteListVehicle')
AddEventHandler('vehiclekeys:server:WhiteListVehicle', function(plate)
    local src = source
    local Player = Zero.Functions.Player(src)
    
    WhiteListed[plate] = true
end)

RegisterServerEvent('vehiclekeys:server:SetVehicleOwner')
AddEventHandler('vehiclekeys:server:SetVehicleOwner', function(plate)
    local src = source
    local Player = Zero.Functions.Player(src)
    if VehicleList ~= nil then
        if DoesPlateExist(plate) then
            for k, val in pairs(VehicleList) do
                if val.plate == plate then
                    table.insert(VehicleList[k].owners, Player.User.Citizenid)
                end
            end
        else
            local vehicleId = #VehicleList+1
            VehicleList[vehicleId] = {
                plate = plate, 
                owners = {},
            }
            VehicleList[vehicleId].owners[1] = Player.User.Citizenid
        end
    else
        local vehicleId = #VehicleList+1
        VehicleList[vehicleId] = {
            plate = plate, 
            owners = {},
        }
        VehicleList[vehicleId].owners[1] = Player.User.Citizenid
    end
end)

RegisterServerEvent('vehiclekeys:server:GiveVehicleKeys')
AddEventHandler('vehiclekeys:server:GiveVehicleKeys', function(plate, target)
    local src = source
    local Player = Zero.Functions.Player(src)
    if CheckOwner(plate, Player.User.Citizenid) then
        if Zero.Functions.Player(target) ~= nil then
            TriggerClientEvent('vehiclekeys:client:SetOwner', target, plate)

            Zero.Functions.Notification(src, 'Sleutels', 'Je hebt de sleutels gegeven')
            Zero.Functions.Notification(target, 'Sleutels', 'Je hebt sleutels ontvangen')
        else
            Zero.Functions.Notification(src, 'Sleutels', 'Speler niet online')
        end
    else
        Zero.Functions.Notification(src, 'Sleutels', 'Dit voertuig is niet van jou')
    end
end)

Zero.Commands.Add("givekeys", "Give Car Keys", {{name = "id", help = "Player id"}}, true, function(source, args)
	local src = source
    local target = tonumber(args[1])
    TriggerClientEvent('vehiclekeys:client:GiveKeys', src, target)
end)

function DoesPlateExist(plate)
    if VehicleList ~= nil then
        for k, val in pairs(VehicleList) do
            if val.plate == plate then
                return true
            end
        end
    end
    return false
end

function CheckOwner(plate, identifier)
    if (WhiteListed[plate]) then
        return true
    end
    
    local retval = false
    if VehicleList ~= nil then
        for k, val in pairs(VehicleList) do
            if val.plate == plate then
                for key, owner in pairs(VehicleList[k].owners) do
                    if owner == identifier then
                        retval = true
                    end
                end
            end
        end
    end
    return retval
end

Zero.Functions.RegisterItem({'lockpick'}, function(src, slot)
    TriggerClientEvent("lockpicks:UseLockpick", src, false)
end, {
    notify = true,
    remove = false,
})
