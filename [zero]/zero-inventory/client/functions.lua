

get_vehicle_seat = function()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped)
    local maxs = GetNumberOfVehicleDoors(vehicle)

    for i = -1, maxs do
        local foundped = GetPedInVehicleSeat(vehicle, i)
        if foundped == ped  then
            return i
        end
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(shared.config.backEngine) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end


function closestVehiclex()
    local vehicles        = {}
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end
	
	for vehicle in EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle) do
		table.insert(vehicles, vehicle)
	end
	
	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])

		local distance      = #(vehicleCoords - vector3(coords.x, coords.y, coords.z))

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end
	
	return closestVehicle
end

--[[
       exports['zero-eye']:looped_runtime(function(coords, entity)
            if NPC(k) == entity then
                return true
            end
        end, {
            [1] = {
                name = "Praat met "..v.name.."", 
                action = function(entity) 
                    TriggerEvent("disableEye")
                    TriggerEvent("InteractSound_CL:PlayOnOne", randomSound(v.voices), 0.2)
                    TriggerServerEvent("Zero:Server-Salesmen:Open", v.name, v.index)
                end,
            },
        }, GetCurrentResourceName(), 10)
]]
--[[
    
function display_trunks()
    if not inventory.vars.open then
        local player = PlayerPedId()
        local x,y,z  = table.unpack(GetEntityCoords(player))

        local vehicle = closestVehiclex()

        if not IsPedInAnyVehicle(player, false) then
            if (vehicle) then
                local drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                if (IsBackEngine(GetEntityModel(vehicle))) then
                    drawpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                end

                if (GetVehicleClass(vehicle) == 8) then
                    drawpos = nil
                end

            
                if shared.config.trunks[GetVehicleClass(vehicle)] then
                    if (drawpos) then
                        local distance = #(vector3(x,y,z) - vector3(drawpos.x, drawpos.y, drawpos.z))

                        if (distance < 2.0 and distance >= 1.5) then
                            Zero.Functions.DrawText(drawpos.x, drawpos.y, drawpos.z, "Kofferbak")
                        elseif (distance < 1.5) then
                            Zero.Functions.DrawText(drawpos.x, drawpos.y, drawpos.z, "~g~E~w~ - Kofferbak")

                            locked = GetVehicleDoorLockStatus(vehicle) == 1 and false or GetVehicleDoorLockStatus(vehicle) ~= 1 and true

                            if not (locked) then
                                if IsControlJustReleased(0, Keys['E']) then

                                    local vehicle = vehicle
                                    local numberplate = string.upper(GetVehicleNumberPlateText(vehicle))

                                    OpenTrunk(vehicle)
                                    TriggerServerEvent("inventory:Server:trunk", numberplate, GetVehicleClass(vehicle))
                                end
                            end
                        else
                            Wait(1500)
                        end
                    end
                end
            else
                Wait(1500)
            end
        end
    end

    Citizen.Wait(0)

    display_trunks()
end
]]

-- TRUNK FUNCTIONS

function OpenTrunk(vehicle)
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
    last_trunk = vehicle
end

function CloseTrunk()
    if (last_trunk) then
        local vehicle = last_trunk
        while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
            RequestAnimDict("amb@prop_human_bum_bin@idle_b")
            Citizen.Wait(100)
        end
        TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
        if (IsBackEngine(GetEntityModel(vehicle))) then
            SetVehicleDoorShut(vehicle, 4, false)
        else
            SetVehicleDoorShut(vehicle, 5, false)
        end
    else
        while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
            RequestAnimDict("amb@prop_human_bum_bin@idle_b")
            Citizen.Wait(100)
        end
        TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    end
end

exports('HasItem', function(item)
    for k,v in pairs(inventory.data.items) do
        if v.item == item  then
            return true, v.slot, v.amount
        end
    end
    return false
end)

exports('getInventory', function()
    return inventory.data.items
end)
exports('config', function()
    return shared.config
end)