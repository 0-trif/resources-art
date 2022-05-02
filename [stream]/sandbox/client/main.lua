

RegisterCommand('testshell', function(raw, args)
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	returnPos = pos
	local shell = GetHashKey(args[1])

	RequestModel(shell)
	while not HasModelLoaded(shell) do
		Wait(9)
	end

	local x, y, z = pos.x, pos.y, pos.z - 20.0
	local height = GetWaterHeight(x,y,z)
	local spot
	if height == false then
		spot = vector3(x, y, z)
	else
		spot = GetSafeSpot()
	end
	
	local spot = vector3(x, y, z)
	local home = CreateObjectNoOffset(shell, spot, true, false, false)
	if DoesEntityExist(home) then
		FreezeEntityPosition(home, true)
		SpawnedHome = {}
		table.insert(SpawnedHome, home)
		DoScreenFadeOut(100)
		while not IsScreenFadedOut() do
			Citizen.Wait(1)
		end
		SetEntityCoords(ped, spot)
		Citizen.Wait(1000)
		FreezeEntityPosition(ped, true)
		while not HasCollisionLoadedAroundEntity(ped) do
			Citizen.Wait(1)
		end
		DoScreenFadeIn(100)
		FreezeEntityPosition(ped, false)
	else
		-- todo
	end
end, false)

RegisterCommand('clearshell', function(raw)
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	SetEntityCoords(ped, returnPos)
	for i = 1,#SpawnedHome do
		DeleteEntity(SpawnedHome[i])
	end
	SpawnedHome = {}
	returnPos = nil
end, false)

RegisterCommand('offset', function(raw)
	if SpawnedHome[1] ~= nil then
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local home = SpawnedHome[1]
		local offset = GetOffsetFromEntityGivenWorldCoords(home, pos)
		local vec = vector3(offset.x, offset.y, offset.z - 1.0)
		print(vec)
	else
		--  no shells here
	end
end)
