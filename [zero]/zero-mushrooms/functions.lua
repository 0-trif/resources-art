function GenerateCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		CoordX = config.farm.x + modX
		CoordY = config.farm.y + modY

		local coordZ = GetCoordZ(CoordX, CoordY)
		local coord = vector3(CoordX, CoordY, coordZ)

		if ValidateCoord(coord) then
			return coord
		end
	end
end

function ValidateCoord(coord)
	if #vars.spawned > 0 then
		local validate = true

		for k, v in pairs(vars.spawned) do
			if #(coord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end

		if #(coord - vector3(config.farm.x, config.farm.y, config.farm.z)) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 30.0, 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }
    
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end

function NewObject()
	random = math.random(1, #config.model)
	RequestModel(config.model[random])

	while not HasModelLoaded(config.model[random]) do
		Wait(20)
	end

	local coord = GenerateCoords()

	local object = CreateObject(config.model[random], coord.x, coord.y, coord.z, false, false, false)
	FreezeEntityPosition(object, true)
	SetEntityCanBeDamaged(object, false)
	SetEntityInvincible(object, true)

	return object
end

function InitSpawning()
	if (#vars.spawned <= 17) then
		vars.spawned[#vars.spawned+1] =	NewObject()
	end
end