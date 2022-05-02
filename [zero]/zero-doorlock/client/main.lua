local closestDoorKey, closestDoorValue = nil, nil
local maxDistance = 1.25
local displays = {}

exports['zero-core']:object(function(O) Zero = O end)

local display = function(x, y, z, text, index, locked)
	local x,y,z = x,y,z
	local text  = text
	displays[index] = true
	local index = index .. "-lock"
	local bool, screen_x, screen_y = GetScreenCoordFromWorldCoord(x, y, z)

	SendNUIMessage({
		action = "show",
		x  = screen_x,
		y  = screen_y,
		status = locked,
		text = text,
		index = index,
	})
end


Citizen.CreateThread(function()
	while true do
		local position = GetEntityCoords(PlayerPedId())

		sleeper = 500
		for k,v in pairs(Shared.Config.Doors) do
			if v.doors then
				distance = #(position - v.doors[1].objCoords)
			else
				distance = #(position - v.objCoords)
			end

			if (distance < 10) then
				if v.doors then
					for k,v in ipairs(v.doors) do
						model = IsModelValid(GetHashKey(v.objName)) and GetHashKey(v.objName) or v.objName
						if not v.object or not DoesEntityExist(v.object) then
							v.object = GetClosestObjectOfType(v.objCoords, 1.0, model, false, false, false)
						end
					end
				else
					model = IsModelValid(GetHashKey(v.objName)) and GetHashKey(v.objName) or v.objName
					if not v.object or not DoesEntityExist(v.object) then
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, model, false, false, false)
					end
				end
			end

			if (distance < 10.0) then

				sleeper = 7

				local doorID = v
				if v.doors then
					for _,v in ipairs(doorID.doors) do
						if DoesEntityExist(v.object) then
							Shared.Config.Doors[k]['doors'][_].reset = Shared.Config.Doors[k]['doors'][_].reset ~= nil and Shared.Config.Doors[k]['doors'][_].reset or GetEntityCoords(v.object)
						end

						FreezeEntityPosition(v.object, doorID.locked)
						if doorID.locked and v.objYaw and not v.gate and GetEntityRotation(v.object).z ~= v.objYaw then
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						end
					end
				else
					Shared.Config.Doors[k].reset = Shared.Config.Doors[k].reset ~= nil and Shared.Config.Doors[k].reset or GetEntityCoords(doorID.object)
					FreezeEntityPosition(doorID.object, doorID.locked)

					if doorID.locked and doorID.objYaw and not v.gate and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
					end
				end

			end

			if (distance < v.distance) then

				sleeper = 7

				local isAuthorized = IsAuthorized(v)

				if isAuthorized then
					if v.locked then
						displayText = "E - Gesloten"
					elseif not v.locked then
						displayText = "E - Geopend"
					end
				elseif not isAuthorized then
					if v.locked then
						displayText = "Gesloten"
					elseif not v.locked then
						displayText = "Geopend"
					end
				end
				if v.locking then
					if v.locked then
						displayText = "Openen.."
					else
						displayText = "Sluiten.."
					end
				end
				if v.objCoords == nil then
					v.objCoords = v.textCoords
				end

				TriggerEvent("interaction:show", displayText, function()
				end)

				if IsControlJustReleased(0, 38) then
					if isAuthorized then
						setDoorLocking(v, k)
					end
				end
			end

		end

		if (sleeper) then
			Citizen.Wait(sleeper)
		end
	end
end)

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function setDoorLocking(doorId, key)
	doorId.locking = true
	openDoorAnim()
	doorId.locked = not doorId.locked
	doorId.locking = false
	TriggerServerEvent('doorlock:server:updateState', key, doorId.locked)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function IsAuthorized(v)
	local job = Zero.Functions.GetPlayerData().Job.name

	for k,v in pairs(v.authorizedJobs) do
		if job == v then
			return true
		end
	end

	return false
end

function openDoorAnim()
	local ped = PlayerPedId()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
	SetTimeout(400, function()
		ClearPedTasks(ped)
	end)
end

RegisterNetEvent('doorlock:client:setState')
AddEventHandler('doorlock:client:setState', function(doorID, state)
	Shared.Config.Doors[doorID].locked = state

	if state then
		if Shared.Config.Doors[doorID].doors then
			for k,v in pairs(Shared.Config.Doors[doorID].doors) do
				if v.reset then
					SetEntityCoords(v.object, v.reset.x, v.reset.y, v.reset.z)
				end
			end
		else
			if Shared.Config.Doors[doorID].reset then
				SetEntityCoords(Shared.Config.Doors[doorID].object, Shared.Config.Doors[doorID].reset.x, Shared.Config.Doors[doorID].reset.y, Shared.Config.Doors[doorID].reset.z)
			end
		end
	end
end)

RegisterNetEvent('doorlock:client:setDoors')
AddEventHandler('doorlock:client:setDoors', function(doorList)
	Shared.Config.Doors = doorList
end)
