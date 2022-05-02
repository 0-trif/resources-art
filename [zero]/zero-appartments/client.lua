exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Functions.GetPlayerData(function(PlayerData)
		PlayerData = PlayerData
    end)
    Zero.Vars.Spawned = true

	blips()
end)

Citizen.CreateThread(function()
    if (Zero.Vars.Spawned) then
        Zero.Functions.GetPlayerData(function(PlayerData)
            PlayerData = PlayerData
        end)
		blips()
    end
end)

outside = function()
	repeat 
		local sleep = 250
		local ply = PlayerPedId()
		local position = GetEntityCoords(ply)

		
		for k,v in pairs(config.appartments) do
			local distance = #(vector3(v.location.x, v.location.y, v.location.z) - position)

			if (distance <= 70) then
				sleep = 0

				for index, data in pairs(v.entry) do
					local x,y,z,h = data.x, data.y, data.z, data.h
					Zero.Functions.DrawMarker(x, y, z)

					local entry_distance = #(vector3(x,y,z) - position)

					if entry_distance < 2.5 then
						TriggerEvent("interaction:show", "E - Appartement in gaan", function()
							Zero.Functions.GetPlayerData(function(PlayerData)
								if (PlayerData.MetaData.appartment == k) then
									TriggerEvent("Zero-appartments:client:enter", k, x, y, z - 30.0)
								else
									Zero.Functions.Notification("Appartement", "Je hebt hier geen appartement", "error", 5000)
								end
							end)
							Wait(2000)
						end)
					end
				end
			end
		end

		Wait(sleep)
	until (config.vars.inside)

	inside()
end

inside = function()
	repeat
		local ply = PlayerPedId()
		local position = GetEntityCoords(ply)

		local exit_x,exit_y,exit_z = config.vars.exit.x, config.vars.exit.y, config.vars.exit.z+1
		local exit_distance = #(vector3(exit_x,exit_y,exit_z) - position)

		if (exit_distance <= 2.3) then
			Zero.Functions.DrawMarker(exit_x,exit_y,exit_z)

			TriggerEvent("interaction:show", "E - Verlaten", function()
				leaveBuilding(config.vars.index)
			end)
		end

		local stash_x,stash_y,stash_z = config.vars.stash.x, config.vars.stash.y, config.vars.stash.z+1
		local stash_distance = #(vector3(stash_x,stash_y,stash_z) - position)

		if (stash_distance <= 2) then
			Zero.Functions.DrawMarker(stash_x,stash_y,stash_z)

			TriggerEvent("interaction:show", "E - Open stash", function()
				TriggerServerEvent("Zero-appartments:server:stash", config.vars.index)
			end)
		end

		local clothing_x,clothing_y,clothing_z = config.vars.clothing.x, config.vars.clothing.y, config.vars.clothing.z+1
		local clothing_distance = #(vector3(clothing_x,clothing_y,clothing_z) - position)

		if (clothing_distance <= 2) then
			Zero.Functions.DrawMarker(clothing_x,clothing_y,clothing_z)

			TriggerEvent("interaction:show", "E - Kledingkast", function()
				TriggerEvent("Zero:Client-ClothingV2:Open")
			end)
		end

		DisableControlAction(0, Zero.Config.Keys['N'], true)
		
		Wait(0)
	until not (config.vars.inside)

	outside()
end

CreateThread(function()
	while not Zero.Vars.Spawned do
		Citizen.Wait(0)
	end

	CheckGarages()
	outside()
end)

leaveBuilding = function(index)
	local ped = PlayerPedId()

	DoScreenFadeOut(150)
	while not IsScreenFadedOut() do Wait(0) end

	TriggerEvent("Zero-weathersync:client:EnableSync")

	SetEntityCoords(ped, config.appartments[index].location.x, config.appartments[index].location.y, config.appartments[index].location.z)
	SetEntityHeading(ped, config.appartments[index].location.h)

	DeleteEntity(config.vars.object)

	Zero.Functions.HidePlayers(false)

	config.vars.object = nil
	config.vars.exit = nil
	config.vars.inside = false

	DoScreenFadeIn(150)

	config.vars.index = nil
end

createAppartment = function(shell, x,y,z, index)
	local ped = PlayerPedId()
	local model = GetHashKey(shell)

	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end

	local house = CreateObject(model, x, y, z, false, false, false)
	FreezeEntityPosition(house, true)
	RequestCollisionForModel(model)

	Zero.Functions.HidePlayers(true)

	local exit = config.interiors[shell]['exit']
	local stash = config.interiors[shell]['stash']
	local clothing = config.interiors[shell]['clothing']
	local exit_off = GetOffsetFromEntityInWorldCoords(house, exit.x, exit.y, exit.z)
	local stash_off = GetOffsetFromEntityInWorldCoords(house, stash.x, stash.y, stash.z)
	local cl_off = GetOffsetFromEntityInWorldCoords(house, clothing.x, clothing.y, clothing.z)

	DoScreenFadeOut(150)
	while not IsScreenFadedOut() do Wait(0) end

	TriggerEvent("Zero-weathersync:client:DisableSync")

	SetEntityCoords(ped, exit_off.x, exit_off.y, exit_off.z)
	SetEntityHeading(ped, exit.h)

	config.vars.object = house
	config.vars.index = index
	config.vars.exit = {x = exit_off.x, y = exit_off.y, z = exit_off.z}
	config.vars.stash = {x = stash_off.x, y = stash_off.y, z = stash_off.z}
	config.vars.clothing = {x = cl_off.x, y = cl_off.y, z = cl_off.z}

	Wait(500) 

	config.vars.inside = true

	DoScreenFadeIn(150)
end

RegisterNetEvent("Zero-appartments:client:enter")
AddEventHandler("Zero-appartments:client:enter", function(index, x, y, z)
	createAppartment(config.appartments[index].interior, x, y, z, index)
end)

blips = function()	
	Zero.Functions.GetPlayerData(function(Data)
		local owned_appartment = Data.MetaData.appartment

		for k,v in pairs(config.appartments) do
			config.appartments[k].blip = AddBlipForCoord(v.location.x, v.location.y, v.location.z)
			if (k == owned_appartment) then
				SetBlipSprite(config.appartments[k].blip, 475)
			else
				SetBlipSprite(config.appartments[k].blip, 476)
			end
			SetBlipDisplay(config.appartments[k].blip, 4)
			SetBlipScale(config.appartments[k].blip, 0.65)
			SetBlipAsShortRange(config.appartments[k].blip, true)
			SetBlipColour(config.appartments[k].blip, 3)
	
			BeginTextCommandSetBlipName("STRING")

			if (k == owned_appartment) then
				AddTextComponentSubstringPlayerName("Mijn appartement")
			else
				AddTextComponentSubstringPlayerName(v.label)
			end
			
			EndTextCommandSetBlipName(config.appartments[k].blip)
		end
	end)
end


openClothing = function()
	TriggerEvent("skin:openSkinMenu")
end

function CheckGarages()
	Zero.Functions.GetPlayerData(function(PlayerData)
		local owned_appartment = PlayerData.MetaData.appartment

		for k,v in pairs(config.appartments) do
			
			if (k == owned_appartment) then
				
				TriggerEvent("Zero:Client-Garages:AddGarage", k .. "-garage", {
					x = v.garage.x, y = v.garage.y, z = v.garage.z, size = v.garage.size, default = {
						x = v.garage.x, y = v.garage.y, z = v.garage.z, h = v.garage.h
					}
				})
				return
			end
		end
	end)
end

--[[
	if v.garage then
					local entrance = v.garage.entrance
					local park = v.garage.vehicle

					local distance = #(vector3(entrance.x, entrance.y, entrance.z) - position)


					Zero.Functions.DrawMarker(entrance.x, entrance.y, entrance.z)


					if distance < 40 then
				
						TriggerEvent("interaction:add", "app-"..entrance.x.."-entrance", entrance.x, entrance.y, entrance.z, 1.0, "E - Garage binnengaan", function()
							Zero.Functions.GetPlayerData(function(PlayerData)
								exports['zero-garages']:EnterGarage(k .. "-garage", "shell_garagem", entrance, park)
							end)
						end)

						if IsPedInAnyVehicle(PlayerPedId()) then
				
							TriggerEvent("interaction:add", "app-"..entrance.x.."-vehicle", park.x, park.y, park.z, 2.0, "E - Voertuig parkeren", function()
								Zero.Functions.GetPlayerData(function(PlayerData)
									exports['zero-garages']:ParkVehicle(k .. "-garage", "shell_garagem")
								end)
							end)
						else
							TriggerEvent("interaction:remove", "app-"..entrance.x.."-vehicle")
						end
					end
				end
]]