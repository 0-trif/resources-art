EYE_ACTIONS = {}
local CurrentRuntimes = {}
local CurrentFunctions = {}
local ForcedOtions = {}
local Resyncing = false


exports['zero-core']:object(function(O) 
    Zero = O
end)

exports("looped_runtime", function(id, valid, functions)
    EYE_ACTIONS[id] = {
        validate = valid,
        functions = functions,
    }
end)

Citizen.CreateThread(function()
    while true do
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)

        timer = 750

        local hit, coords, entity = RayCastGamePlayCamera(1000.0)
        for k,v in pairs(EYE_ACTIONS) do
            RunInside(k, v, entity, coords) 
        end
    
        Wait(timer)
    end
end)

RunInside = function(k, v, entity, coords)
    if not Resyncing then
    
        local bool, coord = v.validate(coords, entity)
                    
        if bool then

            timer = 0

            local pos = {x = 0, y = 0, z = 0}

            if v.functions then
                for y,z in pairs(v.functions) do
                    if coord then
                        pos = coord
                    end
                    if (y ~= 1) then
                        pos = {}
                    end
            
                    exports['zero-eye']:create("looped-r-"..k.."-"..y.."", {x = pos.x, y = pos.y, z = pos.z}, z.name, v.data, z.action)
                end
            end
        end 
    end
end

function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

-- Raycast function for "Admin Lazer"
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

CreateThread(function()
    while true do
        if (IsControlJustPressed(0, Zero.Config.Keys['X'])) then
            eyeEnabled = true

            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(
                true
            );

            SetCursorLocation(0.5, 0.5)
            SendNUIMessage({
                action = "toggle",
                data = {
                    bool = true,
                    actions = CurrentFunctions,
                }
            })
    
            while (IsControlPressed(0, Zero.Config.Keys['X'])) do
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true) 
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 263, true)  
    
                DisableControlAction(0, 264, true) 
                DisableControlAction(0, 257, true) 
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true) 
                DisableControlAction(0, 142, true) 
                DisableControlAction(0, 143, true) 
                DisableControlAction(0, 75, true) 
                DisableControlAction(27, 75, true) 
    
                Wait(0)
            end
    
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            SendNUIMessage({
                action = "toggle",
                data = {
                    bool = false,
                }
            })
            eyeEnabled = false
        end
        Wait(0)
    end
end)


--#region
AlignIdScreen = function(id, position)
    local bool, screen1, screen2 = GetScreenCoordFromWorldCoord(position.x, position.y, position.z)
    if position.x ~= 0 and position.y ~= nil then
        SendNUIMessage({
            action = "ShowScreen",
            id = id,
            x = screen1,
            y = screen2,
        }) 
    end
end

CreateRuntime = function(id, position, label, data, cb)

    CurrentFunctions[id] = {
        position = position,
        label = label,
        data = data,
        cb = cb,
    }

    CurrentRuntimes[id] =  3

    AlignIdScreen(id, position)
end

exports("create", CreateRuntime)

CreateThread(function()
    while true do
        Wait(10)
        
        for k,v in pairs(CurrentRuntimes) do
            local index = k

            CurrentRuntimes[index] = CurrentRuntimes[index] - 1
            if (CurrentRuntimes[index] <= 0) then
                CurrentRuntimes[index] = undefined
                CurrentFunctions[index] = undefined
    
                SendNUIMessage({
                    action = "RemoveScreen",
                    id = index,
                })
            end
        end
    end
end)

RegisterNUICallback('action', function(data)
    local id = data.index

    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)

    if (ForcedOtions[id]) then
        local hit, coords, entity = RayCastGamePlayCamera(1000.0)
        ForcedOtions[id].cb(entity, ForcedOtions[id].data)
        return
    end
    
    if (CurrentFunctions[id]) then
        local hit, coords, entity = RayCastGamePlayCamera(1000.0)
        CurrentFunctions[id].cb(entity, CurrentFunctions[id].data)
    end
end)

exports("ForceOptions", function(id, options)
    ForcedOtions = {}

    for k,v in pairs(options) do
        ForcedOtions[id .. "-" .. k] = {
            label = v.name,
            data = v.data,
            cb = v.action
        }
    end

    SendNUIMessage({
        action = "toggle",
        data = {
            bool = true,
            actions = ForcedOtions,
        }
    })
    SetNuiFocus(true, true)
end)

-- resync

AddEventHandler("onResourceStop", function()
    Resyncing = true
    Wait(200)
    Resyncing = false
end)
