RegisterCommand("jail", function(src, args)
	local playerid = args[1]
	local time = args[2]

	TriggerServerEvent("Zero:Server-Prison:SetJailTime", playerid, time)
end)

exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
	Zero.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.MetaData.jailtime then
			if (PlayerData.MetaData.jailtime > 0) then
				TriggerEvent("Zero:Client-Prison:SetJail")
			end
		end
	end)
end)

Config = {
	['spawnLocation'] = {x = 1761.3122558594, y = 2497.6733398438, z = 45.740783691406, h = 202.77833557129},
	['timeCheck'] = {x = 1789.32, y = 2595.51, z = 45.79, h = 356.00},
	['spawnExit'] = {x = 1847.34, y = 2585.90, z = 45.67, h = 356.00},
	['Electricity'] = {x = 1718.50, y = 2527.81, z = 45.56, h = 113.00},
	['ElectricityPosts'] = {
		{x = 1664.82, y = 2501.67, z = 45.56, h = 113.00, fixed = false},
		{x = 1627.91, y = 2538.41, z = 45.56, h = 113.00, fixed = false},
		{x = 1761.48, y = 2540.35, z = 45.56, h = 113.00, fixed = false},
		{x = 1662.96, y = 2535.50, z = 45.56, h = 113.00, fixed = false},
		{x = 1726.44, y = 2664.67, z = 45.56, h = 113.00, fixed = false},
	}
}

Vars = {
	['injail'] = false,
	['ElectricityJob'] = false
}

local function TeleportPrison()
	local player = PlayerPedId()
	local x,y,z,h = Config.spawnLocation.x, Config.spawnLocation.y, Config.spawnLocation.z, Config.spawnLocation.h

	DoScreenFadeOut(150)
	while not IsScreenFadedOut() do 
		Wait(0)
	end

	-- uncuff in case cops being stupid af
	TriggerEvent("Zero:Client-job:GetCuffs", 0, true, false)


	SetEntityCoords(player, x, y, z)
	SetEntityHeading(player, h)

	Citizen.Wait(1000)
	
	DoScreenFadeIn(150)
end

local function CreateBlips()
	TimeBlip = AddBlipForCoord(Config.spawnLocation.x, Config.spawnLocation.y, Config.spawnLocation.z)
	SetBlipSprite(TimeBlip, 430)
	SetBlipDisplay(TimeBlip, 4)
	SetBlipScale(TimeBlip, 0.65)
	SetBlipAsShortRange(TimeBlip, true)
	SetBlipColour(TimeBlip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Balie")
	EndTextCommandSetBlipName(TimeBlip)

	ElectricityBlip = AddBlipForCoord(Config.Electricity.x, Config.Electricity.y, Config.Electricity.z)
	SetBlipSprite(ElectricityBlip, 544)
	SetBlipDisplay(ElectricityBlip, 4)
	SetBlipScale(ElectricityBlip, 0.65)
	SetBlipAsShortRange(ElectricityBlip, true)
	SetBlipColour(ElectricityBlip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Electriciteit")
	EndTextCommandSetBlipName(ElectricityBlip)
end

local function RemoveBlips()
	RemoveBlip(TimeBlip)
	RemoveBlip(ElectricityBlip)

	for k,v in pairs(Config.ElectricityPosts) do v.fixed = false end
end

local function DoneElectricity()
	TriggerServerEvent("Zero:Server-Prison:RemoveTime")
	Zero.Functions.Notification("Gevangenis", "Er is een minuut van je gevangenis tijd afgehaald")
end

local function CheckPrisonTime()
	Zero.Functions.GetPlayerData(function(PlayerData)
		local text = "Je zit nog "..PlayerData.MetaData.jailtime.." minuten in de gevangenis"
		Zero.Functions.Notification("Gevangenis", text, "success", 5000)

		if (PlayerData.MetaData.jailtime <= 0) then
			TriggerServerEvent("Zero:Server-Prison:ReleasePrison")
		end
	end)
end

RegisterNetEvent("Zero:Client-Prison:Release")
AddEventHandler("Zero:Client-Prison:Release", function()
	local player = PlayerPedId()
	local x,y,z,h = Config.spawnExit.x, Config.spawnExit.y, Config.spawnExit.z, Config.spawnExit.h

	DoScreenFadeOut(150)
	while not IsScreenFadedOut() do 
		Wait(0)
	end

	SetEntityCoords(player, x, y, z)
	SetEntityHeading(player, h)

	Citizen.Wait(1000)
	
	DoScreenFadeIn(150)

	Zero.Functions.Notification("Gevangenis", "Je straf zit erop! je bent nu vrij om te gaan.", "success", 5000)

	Vars.injail = false

	RemoveBlips()
end)

RegisterNetEvent("Zero:Client-Prison:SetJail")
AddEventHandler("Zero:Client-Prison:SetJail", function()
	Zero.Functions.GetPlayerData(function(PlayerData)
		TeleportPrison()
		CreateBlips()

		Zero.Functions.GetPlayerData(function(PlayerData)
			local text = "Je zit nog "..PlayerData.MetaData.jailtime.." minuten in de gevangenis"
			Zero.Functions.Notification("Gevangenis", text, "success", 5000)
		end)

		Vars.injail = true
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)

	prisonBlip = AddBlipForCoord(Config.spawnLocation.x, Config.spawnLocation.y, Config.spawnLocation.z)
	SetBlipSprite(prisonBlip, 189)
	SetBlipDisplay(prisonBlip, 4)
	SetBlipScale(prisonBlip, 0.65)
	SetBlipAsShortRange(prisonBlip, true)
	SetBlipColour(prisonBlip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Gevangenis")
	EndTextCommandSetBlipName(prisonBlip)


	while true do
		if (Vars.injail) then
			local player = PlayerPedId()
			local coords = GetEntityCoords(player)

			local TimeDistance = #(coords - vector3(Config.timeCheck.x, Config.timeCheck.y, Config.timeCheck.z))

			if (TimeDistance <= 5) then
				Zero.Functions.DrawMarker(Config.timeCheck.x, Config.timeCheck.y, Config.timeCheck.z)
				if (TimeDistance <= 1) then
					Zero.Functions.DrawText(Config.timeCheck.x, Config.timeCheck.y, Config.timeCheck.z, "~g~E~w~ - Straf")

					if IsControlJustPressed(0, 38) then
						CheckPrisonTime()
					end
				end
			end

			if not Vars.ElectricityJob then
				local ElectricityDistance = #(coords - vector3(Config.Electricity.x, Config.Electricity.y, Config.Electricity.z))

				if (ElectricityDistance <= 5 and ElectricityDistance > 1) then
					Zero.Functions.DrawText(Config.Electricity.x, Config.Electricity.y, Config.Electricity.z + 0.5, "Werk starten")
				elseif (ElectricityDistance <= 1) then
					Zero.Functions.DrawText(Config.Electricity.x, Config.Electricity.y, Config.Electricity.z + 0.5, "~g~E~w~ - Werk starten")

					if IsControlJustPressed(0, 38) then
						Vars.ElectricityJob = true
						Zero.Functions.Notification("Gevangenis", "Ga langs alle electriciteits torrens om deze te repareren")
					end
				end
			end

			if not isWorking then
				if Vars.ElectricityJob then
					for k,v in pairs(Config.ElectricityPosts) do
						if not v.fixed then
							local distance = #(coords - vector3(v.x, v.y, v.z))

							if (distance <= 5 and distance > 1) then
								Zero.Functions.DrawText(v.x, v.y, v.z + 0.5, "Repareren")
							elseif (distance <= 1) then
								Zero.Functions.DrawText(v.x, v.y, v.z + 0.5, "~g~E~w~ - Repareren")

								if IsControlJustPressed(0, 38) then
									isWorking = true
									Zero.Functions.Progressbar("work_electric", "Werken aan electriciteit..", math.random(5000, 10000), false, true, {
										disableMovement = true,
										disableCarMovement = true,
										disableMouse = false,
										disableCombat = true,
									}, {
										animDict = "anim@gangops@facility@servers@",
										anim = "hotwire",
										flags = 16,
									}, {}, {}, function() -- Done
										v.fixed = true
										isWorking = false
										StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
										DoneElectricity()
									end, function() -- Cancel
										v.fixed = false
										isWorking = false
										StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
									end)
								end
							end
						end
					end
				end
			end
		else
			Citizen.Wait(750)
		end

		Wait(1)
	end
end)


Citizen.CreateThread(function()
	while true do
		if (Vars.injail) then
			Zero.Functions.GetPlayerData(function(PlayerData)
				if PlayerData.MetaData.jailtime == 1 then
					Zero.Functions.Notification("Gevangenis", "Over 1 minuut kan je bij de balie uitchecken", "success", 5000)
				end
			end)

			TriggerServerEvent("Zero:Server-Prison:RemoveTime")


			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local distance_from_render = #(vector3(Config.spawnLocation.x, Config.spawnLocation.y, Config.spawnLocation.z) - pos)

			if distance_from_render > 350 then
				TriggerServerEvent("Zero:Server-Prison:Escaped")
			end

			Citizen.Wait(1000*60)
		else
			Citizen.Wait(750)
		end

		Citizen.Wait(0)
	end
end)
