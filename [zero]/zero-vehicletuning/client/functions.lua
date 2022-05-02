local cam 
local inTransition
local currentTuning

local VehicleProperties

function xDrawText(x,y,z, text, lines)
    if lines == nil then
        lines = 1
    end

	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125 * lines, 0.017+ factor, 0.03 * lines, 0, 0, 0, 75)
    ClearDrawOrigin()
end -- simple draw function

function SetupVehicleProperties(storeData)
    local ply = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ply)

    SetEntityCanBeDamaged(vehicle, false)
    SetVehicleCanBeTargetted(vehicle, false)
    SetVehicleCanBeVisiblyDamaged(vehicle, false)
    
    SetEntityVisible(vehicle, false)
    SetEntityCollision(vehicle, false, true)
    SetEntityVisible(ply, false)

    FreezeEntityPosition(vehicle, true)
    
    if storeData then
        SetEntityCoords(vehicle, storeData.x, storeData.y, storeData.z)
        SetEntityHeading(vehicle, storeData.h)
    end

    return vehicle
end -- set playerped invisible and vehicle cant be targeted

function createMainCamera(offset)

  --  local camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
 --   SetCamActive(camera, true)
--    RenderScriptCams(true, true, 5000, true, true)
 --   SetCamCoord(camera, offset.x, offset.y, offset.z + 0.5)
  --  SetCamRot(camera, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)) + 180)

--    return camera
end

function CreateNewCam(offset, x,y,z, vehicle)
    local new_camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    PointCamAtCoord(new_camera, GetOffsetFromEntityInWorldCoords(vehicle, 0, y, z))
    SetCamCoord(new_camera, offset.x, offset.y, offset.z)

    return new_camera
end

function SetupVehicleCam(vehicle, type)
    if not (cam) then
        local x, y, z = Config.Camlocations["main"].x, Config.Camlocations["main"].x, Config.Camlocations["main"].z
        local offset  = GetOffsetFromEntityInWorldCoords(vehicle, x, y, z)

       -- cam = createMainCamera(offset, vehicle)
      --  PointCamAtEntity(cam, vehicle)

        oldx = x
        oldy = y
        oldz = z
        return
    end

    local x, y, z = Config.Camlocations["main"].x, Config.Camlocations["main"].x, Config.Camlocations["main"].z
    local offset  = GetOffsetFromEntityInWorldCoords(vehicle, x, y, z)


  --  local new_cam = CreateNewCam(offset, -2.0, -2.0, 1.0, vehicle)
 --   SetCamActiveWithInterp(new_cam, cam, 3000, vector3(oldx, oldy, oldz), 0)

    cam = new_cam
    oldx = x
    oldy = y
    oldz = z
end

function OpenTuningMenu(index, value)
    local vehicle = SetupVehicleProperties(value)
--    SetupVehicleCam(vehicle, "main")
    SetupVehicleTunings(vehicle)

    TriggerEvent("Zero:Client-Hud:Toggle", true)
    SetSelectedTuning(1)

    VehicleProperties = Zero.Functions.GetVehicleProperties(vehicle)

    insideVehicle = vehicle
    insideTuning = true
end

function GetScreenCoord(coord)
    local bool, screen_x, screen_y = GetScreenCoordFromWorldCoord(coord.x, coord.y, coord.z)
    return {x = screen_x, y = screen_y}
end

function SetupVehicleTunings(vehicle)
    local TuningArray = {}

    SetVehicleModKit(GetVehiclePedIsIn(PlayerPedId()), 0)

    Zero.Functions.GetPlayerData(function(Data)
        if Data.Job.name == "tuner" then
            table.insert(Config.VehicleBones, Config.SpecialTunings)
            Config.VehicleBones[#Config.VehicleBones]['index'] = #Config.VehicleBones
        end
    end)

    for key, value in ipairs(Config.VehicleBones) do
        local bone = value['bone']
        local boneIndex = GetEntityBoneIndexByName(vehicle, bone)
        local boneCoord = GetWorldPositionOfEntityBone(vehicle, boneIndex)
        value.screen = GetScreenCoord(boneCoord)

        local mods = GetNumVehicleMods(vehicle, value.mod)

        if value['mod'] == 48 and mods == 0 then
            mods = GetVehicleLiveryCount(vehicle)
        end

        if mods > 0 then
            TuningArray[#TuningArray + 1] = value

            if boneCoord.x == 0 then
                local boneIndex = GetEntityBoneIndexByName(vehicle, "bodyshell")
                local boneCoord = GetWorldPositionOfEntityBone(vehicle, boneIndex)

                TuningArray[#TuningArray].bone = "bodyshell"
                TuningArray[#TuningArray].screen = GetScreenCoord(boneCoord)
            end
        end
    end

    SyncAbleParts = TuningArray
    SendNUIMessage({
        action = "SetupPars",
        tunings = TuningArray,
    })
end

function SyncPartPositions(parts, vehicle)
    for k,v in pairs(parts) do
        local bone = v['bone']
        local boneIndex = GetEntityBoneIndexByName(vehicle, bone)
        local boneCoord = GetWorldPositionOfEntityBone(vehicle, boneIndex)

        v.screen = GetScreenCoord(boneCoord)

        SendNUIMessage({
            action = "SyncPartPosition",
            part = v.index,
            screen = v.screen,
        })
    end
end

function SetSelectedTuning(tuningPart)

    if SyncAbleParts[tuningPart] then
        local bone = SyncAbleParts[tuningPart]['bone']

        SendNUIMessage({
            action = "SetSelectedPart",
            bone =  SyncAbleParts[tuningPart]['index'],
        })
    end
end

function f(n)
	return (n + 0.00001)
end

function GetCamLocation(vehicle, bone,ox,oy,oz)
	SetCamActive(cam, true)
	local b = GetEntityBoneIndexByName(vehicle, bone)
	if b and b > -1 then
		local bx,by,bz = table.unpack(GetWorldPositionOfEntityBone(vehicle, b))
		local ox2,oy2,oz2 = table.unpack(GetOffsetFromEntityGivenWorldCoords(vehicle, bx, by, bz))
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle, ox2 + f(ox), oy2 + f(oy), oz2 +f(oz)))

        return {x = x, y = y, z = z, ox = 0, oy = oy2, oz = oz2}
	end
end

function StartTuningSelectedTuning(tuningPart, vehicle)
    local bone = SyncAbleParts[tuningPart]['bone']
    local offset =  SyncAbleParts[tuningPart]['offset']
    local coord = GetCamLocation(vehicle, bone, offset.x , offset.y, offset.z )


 --   local new_cam = CreateNewCam({x = coord.x, y = coord.y, z = coord.z}, coord.ox, coord.oy, coord.oz, vehicle)
  --  SetCamActiveWithInterp(new_cam, cam, 3000, vector3(oldx, oldy, oldz), 0)

    cam = new_cam
    oldx = coord.x
    oldy = coord.y
    oldz = coord.z

    lockedInTuning = tuningPart

    SendNUIMessage({
        action = "LockInTuning",
        bone = bone,
    })

    SetupTuningParts(tuningPart, vehicle)
end

function TuningPartPresses(vehicle)
    currentTuning = currentTuning ~= nil and currentTuning or 1

    if IsControlJustPressed(0, Zero.Config.Keys['RIGHT']) then
        if not lockedInTuning then
            if SyncAbleParts[currentTuning + 1] then
                currentTuning = currentTuning + 1

                SetSelectedTuning(currentTuning)
            end
        else
            RightPressedMenu(vehicle)
        end
    end

    if IsControlJustPressed(0, Zero.Config.Keys['LEFT']) then
        if not lockedInTuning then
            if SyncAbleParts[currentTuning - 1] then
                currentTuning = currentTuning - 1

                SetSelectedTuning(currentTuning)
            end
        else
            LeftPressedMenu(vehicle)
        end
    end

    if IsControlJustPressed(0, Zero.Config.Keys['ENTER']) then
        if not inTransition then
            if not lockedInTuning then
                StartTuningSelectedTuning(currentTuning, vehicle)
            else
                PressedEnterMenu(vehicle)
            end
        end
    end

    if IsControlJustPressed(0, Zero.Config.Keys['BACKSPACE']) then
        if not lockedInTuning then
            currentTuning = 1

            SetupVehicleCam(vehicle)
            SetSelectedTuning(currentTuning)
            SendNUIMessage({
                action = "close",
                menu = {}
            })

            Zero.Functions.GetPlayerData(function(Data)
                if Data.Job.name == "tuner" then
                    Config.VehicleBones[#Config.VehicleBones] = nil
                end
            end)
            
            closeVehicleTuning()
        else
            Zero.Functions.SetVehicleProperties(vehicle, VehicleProperties)

            if currentMenu then
                if MenuBack == nil then
                    currentMenu = nil
                    isSubMenu = false
                    menuCurrentIndex = 1
                    SendNUIMessage({
                        action = "close",
                        menu = {}
                    })
                    lockedInTuning = false
                    SetupVehicleCam(vehicle)
                    return
                else
                    MenuBack()
                    return
                end
            end



            lockedInTuning = nil
            SendNUIMessage({
                action = "LockInTuning",
                bone = "x",
            })
            SendNUIMessage({
                action = "close",
                menu = {}
            })

            currentTuning = 1
            SetupVehicleCam(vehicle)
            SetSelectedTuning(currentTuning)
        end
    end
end

function SetupTuningParts(index, vehicle)
    SetVehicleModKit(vehicle, 0)

    local data = SyncAbleParts[index]

    if data then
        local mod  = data['mod']
        local mods = GetNumVehicleMods(vehicle, mod)

        if data['mod'] == 48 and mods == 0 then
            mods = GetVehicleLiveryCount(vehicle)
        end

        if (data.submenu) then
            SendNUIMessage({
                action = "openSubMenu",
                submenu = true,
                menu = data.submenu
            })

            menuCurrentIndex = 1
            maxMenuCurrent = #data.submenu
            currentMenu = data.submenu
            isSubMenu = true

            SetSelectedMenuOption(menuCurrentIndex)
        else
            SetupMenu(vehicle, mod, mods, data.icon, data.index)
        end
    end
end

function SetupMenu(vehicle, mod, mods, icon, index)
    local _ = {}

    currentMenuIndex = index
    currentMenuMod = mod

    count = -1
    local current = GetVehicleMod(vehicle, mod)

    for i = 0, mods do 
        local label = GetLabelText(GetModTextLabel(vehicle, mod, i)) ~= "NULL" and GetLabelText(GetModTextLabel(vehicle, mod, i)) or GetModTextLabel(vehicle, mod, i)

        label = label ~= nil and label or "MOD" .. i

        _[tostring(i)] = {
            label = label,
            i = i,
            icon  = icon,
            key = i,
        }
        if (i == current) then
            _[tostring(i)]['owned'] = true
        end

        count = count + 1
    end


    SendNUIMessage({
        action = "openSubMenu",
        menu = _
    })


    local CurrentMod = CurrentModIndex(vehicle, mod)

    menuCurrentIndex = CurrentMod ~= -1 and CurrentMod or count
    maxMenuCurrent = count
    currentMenu = _
    isSubMenu = false

    SetSelectedMenuOption(menuCurrentIndex)
end

function LeftPressedMenu(vehicle)
    local min = 1
    if currentMenu[0] or currentMenu[tostring(0)] then
        min = 0
    end
    
    if menuCurrentIndex - 1 >= min then
        menuCurrentIndex = menuCurrentIndex - 1
        SetSelectedMenuOption(menuCurrentIndex, vehicle)
    else
        menuCurrentIndex = maxMenuCurrent
        SetSelectedMenuOption(menuCurrentIndex, vehicle)
    end
end

function RightPressedMenu(vehicle)
    if menuCurrentIndex + 1 <= maxMenuCurrent then
        menuCurrentIndex = menuCurrentIndex + 1
        SetSelectedMenuOption(menuCurrentIndex, vehicle)
    else
        menuCurrentIndex = 1
        SetSelectedMenuOption(menuCurrentIndex, vehicle)
    end
end


function PressedEnterMenu(vehicle)
    if isSubMenu then
        if menuCurrentIndex then
            local data = currentMenu[menuCurrentIndex]
            if data then
                if data.action then
        
                    menu[data.action](data.key, vehicle, currentMenu)

                    if data.back then
                        MenuBack = function()
                            SetupTuningParts(data.back, vehicle)
                            MenuBack = nil
                        end
                    else
                        MenuBack = nil
                    end
                end
            end
        end
    else
        ConfirmedBuyMod(menuCurrentIndex)
    end
end

function CurrentModIndex(vehicle, mod)
    if mod == 48 then
        local liverys = GetVehicleLiveryCount(vehicle)
        if liverys > 0 then
            return GetVehicleLivery(vehicle)
        end
    end

    local mod = GetVehicleMod(vehicle, mod)
    return mod
end

function ConfirmedBuyMod(index)
    if currentMenuMod and currentMenuIndex then
        local PlayerData = Zero.Functions.GetPlayerData()
        local money      = PlayerData.Money.cash
        local price      = 10

        local veh = GetVehiclePedIsIn(PlayerPedId())

        for k, v in pairs(Config.VehicleBones) do
            if v.index == currentMenuIndex then
                local price = v.price

                if money >= price then
                    TriggerEvent("InteractSound_CL:PlayOnOne", "bennys", 0.1)
                    VehicleProperties = Zero.Functions.GetVehicleProperties(veh)
                    TriggerServerEvent("Zero:Server-Tuner:BoughtItem", price)
                    SetupMenu(veh, currentMenuMod, GetNumVehicleMods(veh, currentMenuMod), v.icon, currentMenuIndex)
                    boughtItem = true
                else
                    Zero.Functions.Notification("Tuner", "Niet genoeg geld", "error")
                end

                return
            end
        end
    end
end

function closeVehicleTuning()
    local ply = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    if boughtItem then
        local mods = Zero.Functions.GetVehicleProperties(vehicle)
        TriggerServerEvent("Zero:Server-Tuning:SavedVehicle", mods)
        TriggerEvent("InteractSound_CL:PlayOnOne", "impactdrill", 1)

        SetCamActive(cam, false)
        RenderScriptCams(false, true, 5000, false, false)
        DestroyCam(cam, true)
        cam = nil

        SendNUIMessage({
            action = "SetupPars",
            tunings = {},
        })

        boughtItem = false
        insideTuning = false
    else
        SetCamActive(cam, false)
        RenderScriptCams(false, true, 5000, false, false)
        DestroyCam(cam, true)
        cam = nil

        SendNUIMessage({
            action = "SetupPars",
            tunings = {},
        })
        
        insideTuning = false
    end

    FreezeEntityPosition(vehicle, false)

    SetEntityCanBeDamaged(vehicle, true)
    SetVehicleCanBeTargetted(vehicle, true)
    SetVehicleCanBeVisiblyDamaged(vehicle, true)
    SetEntityCollision(vehicle, true, true)
    SetVehicleEngineOn(vehicle, true, true, true)
    SetEntityVisible(vehicle, true)
    SetEntityVisible(ply, true)
    TriggerEvent("Zero:Client-Hud:Toggle", false)

    DestroyCam(cam)
    DestroyAllCams(false)
    RenderScriptCams(false, false, 5000, false, false)
end


function SetSelectedMenuOption(index, vehicle)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    SetVehicleModKit(vehicle, 0)

    if not (isSubMenu) then
        if currentMenuMod then
            local currentMenuMod = tonumber(currentMenuMod)
            local index = tonumber(index)
        

            SetVehicleMod(vehicle, currentMenuMod, index)

            if (currentMenuMod == 48) then
                SetVehicleLivery(vehicle, index)
            end

            PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
        end
    end

    SendNUIMessage({
        action = "SetMenuIndexSelected",
        index = index,
    })

    SendNUIMessage({
        action = "SetAmountString",
        amount = ""..index.."/"..maxMenuCurrent..""
    })
end

-- menu options

menu = {}

menu['ToggleWheelsMenu'] = function(index, vehicle, currentMenu)
    SetVehicleWheelType(vehicle, index)
    local mods = GetNumVehicleMods(vehicle, 23)
    SetupMenu(vehicle, 23, mods, '<i class="fas fa-tire"></i>', 1)
end

menu['toggleNitro'] = function(index, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerEvent("InteractSound_CL:PlayOnOne", "impactdrill", 1)
    TriggerServerEvent("Zero:Server-Vehicles:NosInstalled", plate)
end

menu['toggle2step'] = function(index, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerEvent("InteractSound_CL:PlayOnOne", "impactdrill", 1)
    TriggerServerEvent("Zero:Server-Vehicles:Install2step", plate)
end

menu['toggleRadio'] = function(index, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerEvent("InteractSound_CL:PlayOnOne", "impactdrill", 1)
    TriggerServerEvent("Zero:Server-Vehicles:InstallCarradio", plate)
end

menu['Chambers'] = function()
    SendNUIMessage({
        action = "WheelMenu",
    })
    SetNuiFocus(true, true)
    TriggerEvent("Zero:Client-Vehicles:ToggleTunings", true)
end

menu['OpenMainColors'] = function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local r,g,b = GetVehicleCustomPrimaryColour(vehicle)
    local rs,gs,bs = GetVehicleCustomSecondaryColour(vehicle)

    SendNUIMessage({
        action = "OpenColours",
        primary = {
            r = r,
            g = g, 
            b = b,
        },
        secondary = {
            r = rs,
            g = gs,
            b = bs,
        }
    })
    SetNuiFocus(true, true)
end

menu['OpenTireColors'] = function()

end

-- UI

RegisterNUICallback("wheelChambers", function(ui)
    local id = ui.id
    local val = tonumber(ui.value)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
  

    if (id == "width-f") then
        SetVehicleWheelXOffset(vehicle, 1, -val)
        SetVehicleWheelXOffset(vehicle, 0, val)
    elseif (id == "width-r") then
        SetVehicleWheelXOffset(vehicle, 3, -val)
        SetVehicleWheelXOffset(vehicle, 2, val)
    elseif (id == "rotation-f") then
        SetVehicleWheelYRotation(vehicle, 1, -val)
        SetVehicleWheelYRotation(vehicle, 0, val)
    elseif (id == "rotation-r") then
        SetVehicleWheelYRotation(vehicle, 3, -val)
        SetVehicleWheelYRotation(vehicle, 2, val)
    end
end)

RegisterNUICallback("SaveWheelSettings", function()
    SaveVehicleWheelSettings()
    SetNuiFocus(false, false)
    TriggerEvent("Zero:Client-Vehicles:ToggleTunings", false)
end)

RegisterNUICallback("ResetWheels", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local plate = GetVehicleNumberPlateText(vehicle)
   SetNuiFocus(false, false)
   TriggerServerEvent("Zero:Server-Vehicles:ResetWheels", plate)
   TriggerEvent("Zero:Client-Vehicles:ToggleTunings", false)
end)

RegisterNUICallback("changeSecondaryColor", function(ui)
    local r,g,b = tonumber(ui.r), tonumber(ui.g), tonumber(ui.b)

    SetVehicleCustomSecondaryColour(GetVehiclePedIsIn(PlayerPedId()), r, g, b)
end)

RegisterNUICallback("changePrimaryColor", function(ui)
    local r,g,b = tonumber(ui.r), tonumber(ui.g), tonumber(ui.b)

    SetVehicleCustomPrimaryColour(GetVehiclePedIsIn(PlayerPedId()), r, g, b)
end)

RegisterNUICallback("ResetVehicleColours", function(ui)
    SetNuiFocus(false, false)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    Zero.Functions.SetVehicleProperties(vehicle, VehicleProperties)
end)

RegisterNUICallback("SaveColourChanges", function(ui)
    SetNuiFocus(false, false)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    TriggerEvent("InteractSound_CL:PlayOnOne", "impactdrill", 1)

    VehicleProperties = Zero.Functions.GetVehicleProperties(vehicle)
    boughtItem = true
end)

RegisterNUICallback("nextPrimaryColourType", function(i, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local current = GetVehicleModColor_1(vehicle)

    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local current = GetVehicleModColor_1(vehicle)
    current = current ~= 6 and current or 1

    for k,v in pairs(Config.ColourTypes) do
        if v.index == current then
            if (Config.ColourTypes[current+1]) then
                current = current+1
            else 
                current = 1
            end

            SetVehicleModColor_1(vehicle, Config.ColourTypes[current].index)
            cb(Config.ColourTypes[current].label)

            return
        end
    end
end)

RegisterNUICallback("nextSecondaryColourType", function(i, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local current = GetVehicleModColor_2(vehicle)
    current = current ~= 6 and current or 1

    for k,v in pairs(Config.ColourTypes) do
        if v.index == current then
            if (Config.ColourTypes[current+1]) then
                current = current+1
            else 
                current = 1
            end

            SetVehicleModColor_2(vehicle, Config.ColourTypes[current].index)
            cb(Config.ColourTypes[current].label)

            return
        end
    end
end)

function SaveVehicleWheelSettings()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local data = {
        ['front_left_rot'] = GetVehicleWheelYRotation(vehicle, 0),
        ['front_right_rot'] = GetVehicleWheelYRotation(vehicle, 1),
        ['front_left_width'] = GetVehicleWheelXOffset(vehicle, 0),
        ['front_right_width'] = GetVehicleWheelXOffset(vehicle, 1),

        ['back_left_rot'] = GetVehicleWheelYRotation(vehicle, 3),
        ['back_right_rot'] = GetVehicleWheelYRotation(vehicle, 2),
        ['back_left_width'] = GetVehicleWheelXOffset(vehicle, 3),
        ['back_right_width'] =  GetVehicleWheelXOffset(vehicle, 2)
    }

    local plate = Zero.Functions.GetVehicleProperties(vehicle).plate
    exports['zero-vehicles']:setWheelData(plate, data)

    TriggerEvent("InteractSound_CL:PlayOnOne", "impactdrill", 1)
end

