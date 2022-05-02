exports['zero-core']:object(function(O) Zero = O end)

local objects = {
  -870868698,
  -1126237515,
  -1364697528,
  506770882,
}

local banks = {
  [1] = {name="Bank", Closed = false, id=108, x = 314.187,   y = -278.621,  z = 54.170},
  [2] = {name="Bank", Closed = false, id=108, x = 150.266,   y = -1040.203, z = 29.374},
  [3] = {name="Bank", Closed = false,  id=108, x = -351.534,  y = -49.529,   z = 49.042},
  [4] = {name="Bank", Closed = false, id=108, x = -1212.980, y = -330.841,  z = 37.787},
  [5] = {name="Bank", Closed = false, id=108, x = -2962.582, y = 482.627,   z = 15.703},
  [6] = {name="Bank", Closed = false, id=108, x = -112.202,  y = 6469.295,  z = 31.626},
  [7] = {name="Bank", Closed = false, id=108, x = 241.727,   y = 220.706,   z = 106.286},
}

-- Display Map Blips
Citizen.CreateThread(function()
    for _, item in pairs(banks) do
       item.blip = AddBlipForCoord(item.x, item.y, item.z)
       SetBlipSprite(item.blip, item.id)
       SetBlipColour(item.blip, 0)
       SetBlipScale(item.blip, 0.6)
       SetBlipAsShortRange(item.blip, true)
       BeginTextCommandSetBlipName("STRING")
       AddTextComponentString(item.name)
       EndTextCommandSetBlipName(item.blip)
    end 
end)

Citizen.CreateThread(function ()
	while true do
		local timer = 1000
		local ply = PlayerPedId()
		local pos = GetEntityCoords(ply)
		
		for k,v in pairs(banks) do
			local distance = #(vector3(v.x, v.y, v.z) - pos)

			if (distance <= 5) then
				timer = 0
			end
		end

		for key,model in ipairs(objects) do
			local closestObjectOfType = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, model)
			if closestObjectOfType ~= 0 then
				timer = 0
			end
		end

		if timer == 0 then
			TriggerEvent("interaction:show", "E - Bank", function()
				OpenBankingUI()
			end)
		end


		Wait(timer)
	end
end)



-- functions

function OpenBankingUI()
	TriggerScreenblurFadeIn(150)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "OpenBank",
	})

	local money = Zero.Functions.GetPlayerData().Money

	SendNUIMessage({
		action = "UpdateMoney",
		money = money,
	})
end

-- ui

RegisterNUICallback('close', function()
	SetNuiFocus(false, false)
	TriggerScreenblurFadeOut(150)
end)


RegisterNUICallback('event', function(ui)
	local type = ui.type

	TriggerServerEvent("Zero:Server-Banking:PostEvent", type, ui)
end)

function GetReason(bool)
	if bool then
		return 'Geld gestort (Geen specifieke reden voor storting)'
	else
		return 'Geld opname (Geen specifieke reden voor opname)'
	end
end

RegisterNetEvent("Zero:Client-Core:MoneyAltered")
AddEventHandler("Zero:Client-Core:MoneyAltered", function(type, bool, amount, reason, extra)
	if (type == "bank") then
		extra = extra ~= nil and extra or {}

		local hours = GetClockHours()
		local minutes = GetClockMinutes()
		if minutes <= 9 then
			minutes = '0' .. minutes
		end
		if hours <= 9 then
			hours = '0' .. hours
		end

		local time = hours .. ":" .. minutes

		SendNUIMessage({
			action = "history",
			title = extra.title ~= nil and extra.title or GetReason(bool),
			subtitle = extra.subtitle ~= nil and extra.subtitle or reason,
			amount = amount,
			time = time,
			bool = bool
		})
	end

	local money = Zero.Functions.GetPlayerData().Money
	SendNUIMessage({
		action = "UpdateMoney",
		money = money,
	})
end)

exports("safe", function(id, type)
	Zero.Functions.TriggerCallback("Zero:Server-Banking:GetSafe", function(data)
		if data then
			local amount = data.amount
			local id = data.id
			local type = data.type

			SendNUIMessage({
				action = "UpdateSafe",
				data = {
					id = id,
					type = type,
					amount = amount,
				},
				money = Zero.Functions.GetPlayerData().Money
			})
			SetNuiFocus(true, true)
		end
	end, id, type)
end)

RegisterNUICallback("SafeEvent", function(ui)
	local amount = tonumber(ui.amount)
	local id = ui.id
	local type = ui.type

	local ui = exports['zero-ui']:element()
	
	if Transfering then return end

	Transfering = true
	ui.delay(1000, "Overmaken")
	Transfering = false

	Zero.Functions.TriggerCallback("Zero:Server-Banking:SafeEvent", function(data)
		local amount = data.amount
		local id = data.id
		local type = data.type

		SendNUIMessage({
			action = "UpdateSafe",
			data = {
				id = id,
				type = type,
				amount = amount,
			},
			money = Zero.Functions.GetPlayerData().Money
		})
	end, id, type, amount)
end)