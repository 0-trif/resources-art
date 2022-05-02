Zero.Functions = Zero.Functions ~= nil and Zero.Functions or {}

Zero.Functions.GetPlayerData = function(cb)
	if cb then
    	cb(Zero.Player)
	else
		return Zero.Player 
	end
end

Zero.Functions.DrawMarker = function(x, y, z, r, g, b)
    local r = r ~= nil and r or 39
	local g = g ~= nil and g or 37
	local b = b ~= nil and b or 46

	DrawMarker(20, x, y, z, 0, 0, 0, 0, 0, 0, 0.3, 0.2, 0.1, r, g, b, 100, 0, 0, 0, true)
end

Zero.Functions.Command = function(name, cb)
	RegisterCommand(name, function(source, args)
		cb(source, args)
	end)
end

Zero.Functions.Notification = function(title, message, type, time)
	exports['zero-notify']:notification(title, message, type, time)
end

Zero.Functions.SpawnVehicle = function(data, cb)
	local model = GetHashKey(data.model)

	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end

	local x,y,z,h = data.location.x, data.location.y, data.location.z, data.location.h
	local vehicle = CreateVehicle(model, x, y, z, h, data.network)

    SetVehicleWeaponsDisabled(vehicle, true)

	if data.teleport then
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end

	SetModelAsNoLongerNeeded(model)


	if cb then
		cb(vehicle)
	end
end

Zero.Functions.DrawText = function(x,y,z, text, lines)
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
end

Zero.Functions.GetPlayerVehicles = function()
	return Zero.Player.Vehicles
end

Zero.Functions.Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish ~= nil then
                onFinish()
            end
        else
            if onCancel ~= nil then
                onCancel()
            end
        end
    end)
end

Zero.Functions.GetPeds = function(ignoreList)
	local ignoreList = ignoreList or {}
	local peds       = {}
	for ped in EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) do
		local found = false

        for j=1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

Zero.Functions.GetPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

Zero.Functions.GetClosestNPC = function(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local peds            = Zero.Functions.GetPeds(ignoreList)
	local closestDistance = -1
    local closestPed      = -1
    
    if coords == nil then
        coords = GetEntityCoords(GetPlayerPed(-1))
    end

	for i=1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i])
		local distance  = GetDistanceBetweenCoords(pedCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPed      = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

Zero.Functions.GetClosestPlayer = function(coords)
	if coords == nil then
        coords = GetEntityCoords(GetPlayerPed(-1))
	end
	
	local closestPlayers = Zero.Functions.GetPlayersFromCoords(coords)
    local closestDistance = -1
    local closestPlayer = -1

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() and closestPlayers[i] ~= -1 then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

Zero.Functions.GetPlayersFromCoords = function(coords, distance)
    local players = Zero.Functions.GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player)
		end
    end
    
    return closePlayers
end

Zero.Functions.TriggerCallback = function(name, cb, ...)
	Zero.ServerCallbacks[name] = cb
    TriggerServerEvent("Zero:Server:TriggerCallback", name, ...)
end


function EnumerateEntities(initFunc, moveFunc, disposeFunc)
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


Zero.Functions.closestVehicle = function()
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

Zero.Functions.HidePlayers = function(bool)
	if bool then
		TriggerServerEvent("Zero:Server-Core:SetDimension")
	else
		TriggerServerEvent("Zero:Server-Core:SetDimension", 0)
	end
end


Zero.Functions.GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then		
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		local rp,gp,bp = GetVehicleCustomPrimaryColour(vehicle)
		local rs, gs,bs = GetVehicleCustomSecondaryColour(vehicle)

		return {
			model             = GetEntityModel(vehicle),

			plate             = Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),
			
			bodyHealth        = Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = Round(GetVehicleEngineHealth(vehicle), 1),
			tankHealth        = Round(GetVehiclePetrolTankHealth(vehicle), 1),

			fuelLevel         = Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = Round(GetVehicleDirtLevel(vehicle), 1),
			
			modColour1        = GetVehicleModColor_1(vehicle),
			modColour2        = GetVehicleModColor_2(vehicle),

			color             = {r = rp, g = gp, b = bp},
			color2             = {r = rs, g = gs, b = bs},
			

			pearlescentColor  = pearlescentColor,
            interiorColor     = GetVehicleInteriorColor(vehicle),
            dashboardColor    = GetVehicleDashboardColour(vehicle),
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = true,

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),
            		modCustomTiresF   = GetVehicleModVariation(vehicle, 23),
            		modCustomTiresR   = GetVehicleModVariation(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleLivery(vehicle),
		}
	else
		return
	end
end

Zero.Functions.SetVehicleProperties = function(vehicle, props)
    if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if props.plate ~= nil then
			SetVehicleNumberPlateText(vehicle, props.plate)
		end

		if props.plateIndex ~= nil then
			SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
		end

		if props.bodyHealth ~= nil then
			SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
		end

		if props.engineHealth ~= nil then
			SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
		end

		if props.fuelLevel ~= nil then
			SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
		end

		if props.dirtLevel ~= nil then
			SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
		end

		if props.modColour1 then
			SetVehicleModColor_1(vehicle, props.modColour1)
		end
		if props.modColour2 then
			SetVehicleModColor_2(vehicle, props.modColour2)
		end

		if props.color then
			SetVehicleCustomPrimaryColour(vehicle, props.color.r, props.color.g,  props.color.b)
		end

		if props.color2 then
			SetVehicleCustomSecondaryColour(vehicle, props.color2.r, props.color2.g,  props.color2.b)
		end

		if props.pearlescentColor ~= nil then
            		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
		end

        	if props.interiorColor ~= nil then
            		SetVehicleInteriorColor(vehicle, props.interiorColor)
		end

		if props.dashboardColor ~= nil then
            		SetVehicleDashboardColour(vehicle, props.dashboardColor)
		end

		if props.wheelColor ~= nil then
            		SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
		end

		if props.wheels ~= nil then
			SetVehicleWheelType(vehicle, props.wheels)
		end

		if props.windowTint ~= nil then
			SetVehicleWindowTint(vehicle, props.windowTint)
		end

		--[[
				if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end
		]]

		if props.extras ~= nil then
			for id,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(id), 0)
				else
					SetVehicleExtra(vehicle, tonumber(id), 1)
				end
			end
		end

		if props.neonColor ~= nil then
			SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
		end

		if props.modSmokeEnabled ~= nil then
			ToggleVehicleMod(vehicle, 20, true)
		end

		if props.tyreSmokeColor ~= nil then
			SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
		end

		if props.modSpoilers ~= nil then
			SetVehicleMod(vehicle, 0, props.modSpoilers, false)
		end

		if props.modFrontBumper ~= nil then
			SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
		end

		if props.modRearBumper ~= nil then
			SetVehicleMod(vehicle, 2, props.modRearBumper, false)
		end

		if props.modSideSkirt ~= nil then
			SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
		end

		if props.modExhaust ~= nil then
			SetVehicleMod(vehicle, 4, props.modExhaust, false)
		end

		if props.modFrame ~= nil then
			SetVehicleMod(vehicle, 5, props.modFrame, false)
		end

		if props.modGrille ~= nil then
			SetVehicleMod(vehicle, 6, props.modGrille, false)
		end

		if props.modHood ~= nil then
			SetVehicleMod(vehicle, 7, props.modHood, false)
		end

		if props.modFender ~= nil then
			SetVehicleMod(vehicle, 8, props.modFender, false)
		end

		if props.modRightFender ~= nil then
			SetVehicleMod(vehicle, 9, props.modRightFender, false)
		end

		if props.modRoof ~= nil then
			SetVehicleMod(vehicle, 10, props.modRoof, false)
		end

		if props.modEngine ~= nil then
			SetVehicleMod(vehicle, 11, props.modEngine, false)
		end

		if props.modBrakes ~= nil then
			SetVehicleMod(vehicle, 12, props.modBrakes, false)
		end

		if props.modTransmission ~= nil then
			SetVehicleMod(vehicle, 13, props.modTransmission, false)
		end

		if props.modHorns ~= nil then
			SetVehicleMod(vehicle, 14, props.modHorns, false)
		end

		if props.modSuspension ~= nil then
			SetVehicleMod(vehicle, 15, props.modSuspension, false)
		end

		if props.modArmor ~= nil then
			SetVehicleMod(vehicle, 16, props.modArmor, false)
		end

		if props.modTurbo ~= nil then
			ToggleVehicleMod(vehicle,  18, props.modTurbo)
		end

		if props.modXenon ~= nil then
			ToggleVehicleMod(vehicle,  22, props.modXenon)
		end

		if props.xenonColor ~= nil then
			SetVehicleXenonLightsColor(vehicle, props.xenonColor)
		end

		if props.modFrontWheels ~= nil then
			SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
		end

		if props.modBackWheels ~= nil then
			SetVehicleMod(vehicle, 24, props.modBackWheels, false)
		end

        	if props.modCustomTiresF ~= nil then
			SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
		end

		if props.modCustomTiresR ~= nil then
			SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
		end
        
		if props.modPlateHolder ~= nil then
			SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
		end

		if props.modVanityPlate ~= nil then
			SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
		end

		if props.modTrimA ~= nil then
			SetVehicleMod(vehicle, 27, props.modTrimA, false)
		end

		if props.modOrnaments ~= nil then
			SetVehicleMod(vehicle, 28, props.modOrnaments, false)
		end

		if props.modDashboard ~= nil then
			SetVehicleMod(vehicle, 29, props.modDashboard, false)
		end

		if props.modDial ~= nil then
			SetVehicleMod(vehicle, 30, props.modDial, false)
		end

		if props.modDoorSpeaker ~= nil then
			SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
		end

		if props.modSeats ~= nil then
			SetVehicleMod(vehicle, 32, props.modSeats, false)
		end

		if props.modSteeringWheel ~= nil then
			SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
		end

		if props.modShifterLeavers ~= nil then
			SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
		end

		if props.modAPlate ~= nil then
			SetVehicleMod(vehicle, 35, props.modAPlate, false)
		end

		if props.modSpeakers ~= nil then
			SetVehicleMod(vehicle, 36, props.modSpeakers, false)
		end

		if props.modTrunk ~= nil then
			SetVehicleMod(vehicle, 37, props.modTrunk, false)
		end

		if props.modHydrolic ~= nil then
			SetVehicleMod(vehicle, 38, props.modHydrolic, false)
		end

		if props.modEngineBlock ~= nil then
			SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
		end

		if props.modAirFilter ~= nil then
			SetVehicleMod(vehicle, 40, props.modAirFilter, false)
		end

		if props.modStruts ~= nil then
			SetVehicleMod(vehicle, 41, props.modStruts, false)
		end

		if props.modArchCover ~= nil then
			SetVehicleMod(vehicle, 42, props.modArchCover, false)
		end

		if props.modAerials ~= nil then
			SetVehicleMod(vehicle, 43, props.modAerials, false)
		end

		if props.modTrimB ~= nil then
			SetVehicleMod(vehicle, 44, props.modTrimB, false)
		end

		if props.modTank ~= nil then
			SetVehicleMod(vehicle, 45, props.modTank, false)
		end

		if props.modWindows ~= nil then
			SetVehicleMod(vehicle, 46, props.modWindows, false)
		end

		if props.modLivery ~= nil then
			SetVehicleLivery(vehicle, props.modLivery)
			SetVehicleMod(vehicle, 48, props.modLivery)
		end
	end
end

Zero.Functions.GetVehicles = function()
    local vehiclePool = GetGamePool('CVehicle') 
    local vehicles = {}

    for i = 1, #vehiclePool, 1 do
        table.insert(vehicles, vehiclePool[i])
    end

	return vehicles
end

Zero.Functions.RenderUIButtons = function()
	if Ibuttons then
		if HasScaleformMovieLoaded(Ibuttons) then
			DrawScaleformMovie(Ibuttons, 0.5, 0.5, 1.0, 1.0, 255, 255, 255, 255)
		end
	end
end

Zero.Functions.SetUIButtons = function(buttons, layout)
	Citizen.CreateThread(function()
		if not HasScaleformMovieLoaded(Ibuttons) then
			Ibuttons = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
			while not HasScaleformMovieLoaded(Ibuttons) do
				Citizen.Wait(0)
			end
		else
			Ibuttons = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
			while not HasScaleformMovieLoaded(Ibuttons) do
				Citizen.Wait(0)
			end
		end
		local sf = Ibuttons
		local w,h = GetScreenResolution()
		PushScaleformMovieFunction(sf,"CLEAR_ALL")
		PopScaleformMovieFunction()
		PushScaleformMovieFunction(sf,"SET_DISPLAY_CONFIG")
		PushScaleformMovieFunctionParameterInt(w)
		PushScaleformMovieFunctionParameterInt(h)
		PushScaleformMovieFunctionParameterFloat(0.03)
		PushScaleformMovieFunctionParameterFloat(0.98)
		PushScaleformMovieFunctionParameterFloat(0.01)
		PushScaleformMovieFunctionParameterFloat(0.95)
		PushScaleformMovieFunctionParameterBool(true)
		PushScaleformMovieFunctionParameterBool(false)
		PushScaleformMovieFunctionParameterBool(false)
		PushScaleformMovieFunctionParameterInt(w)
		PushScaleformMovieFunctionParameterInt(h)
		PopScaleformMovieFunction()
		PushScaleformMovieFunction(sf,"SET_MAX_WIDTH")
		PushScaleformMovieFunctionParameterInt(1)
		PopScaleformMovieFunction()
		
		for i,btn in pairs(buttons) do
			PushScaleformMovieFunction(sf,"SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(i-1)
			PushScaleformMovieFunctionParameterString(btn[1])
			PushScaleformMovieFunctionParameterString(btn[2])
			PopScaleformMovieFunction()
			
		end
		if layout ~= 1 then
			PushScaleformMovieFunction(sf,"SET_PADDING")
			PushScaleformMovieFunctionParameterInt(10)
			PopScaleformMovieFunction()
		end
		PushScaleformMovieFunction(sf,"DRAW_INSTRUCTIONAL_BUTTONS")
		PushScaleformMovieFunctionParameterInt(layout)
		PopScaleformMovieFunction()
	end)
end

Zero.Functions.HasItem = function(item)
	local item, slot, amount = exports['zero-inventory']:HasItem(item)
	return item, slot, amount
end

-- NOT FRAMEWORKED FUNCTIONS

HidenEntitys = {}

hidePlayers = function()
   --[[
	    local player = PlayerPedId()
    local players = Zero.Functions.GetPlayers()

    for k,v in pairs(players) do
        local playerped = GetPlayerPed(v)
        if player ~= playerped then
            SetEntityVisible(playerped, false)
			SetEntityCollision(playerped, false, false)
			SetPedCanBeTargetted(playerped, false)
			HidenEntitys[playerped] = true

            local vehicle = GetVehiclePedIsIn(playerped)
            if vehicle then
                SetEntityVisible(vehicle, false)
				SetEntityCollision(vehicle, false, false)

				HidenEntitys[vehicle] = true
            end
        end
    end
   ]]
end

ShowEnsurePlayers = function()
  --[[
	    local player = PlayerPedId()
    local players = Zero.Functions.GetPlayers()

    for k,v in pairs(players) do
        local playerped = GetPlayerPed(v)
		if not IsEntityInAir(playerped) then
			if player ~= playerped then
				SetEntityVisible(playerped, true)
				SetEntityCollision(playerped, true, true)
				SetPedCanBeTargetted(playerped, true)


				local vehicle = GetVehiclePedIsIn(playerped)
				if vehicle then
					SetEntityVisible(vehicle, true)
					SetEntityCollision(vehicle, true, true)
				end
			end
		end
    end
  ]]
end

showPlayers = function()
	--[[
		  local player = PlayerPedId()
    local coords = GetEntityCoords(player)
	for entity, bool in pairs(HidenEntitys) do
		SetEntityVisible(entity, true)
		SetEntityCollision(entity, true, true)
		SetPedCanBeTargetted(entity, true)

		SetEntityVisible(entity, true)
		SetEntityCollision(entity, true, true)
	end
	HidenEntitys = {}
	]]
end


function Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end
