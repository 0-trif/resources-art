CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false

local disable = false

exports['zero-core']:object(function(O) Zero = O end)

--- CODE

Citizen.CreateThread(function()
	TriggerServerEvent('Zero-weathersync:server:RequestStateSync')
	if (Zero.Vars.Spawned) then
		disable = false
		TriggerServerEvent('Zero-weathersync:server:RequestStateSync')
	end
end)

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
	disable = false
    TriggerServerEvent('Zero-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('Zero-weathersync:client:EnableSync')
AddEventHandler('Zero-weathersync:client:EnableSync', function()
	disable = false
    TriggerServerEvent('Zero-weathersync:server:RequestStateSync')
	SetRainFxIntensity(-1.0)
end)

RegisterNetEvent('Zero-weathersync:client:DisableSync')
AddEventHandler('Zero-weathersync:client:DisableSync', function()
	if disable then return end

	disable = true
	
	Citizen.CreateThread(function() 
		while disable do
			SetRainFxIntensity(0.0)
			SetWeatherTypePersist('LIGHTNING')
			SetWeatherTypeNow('LIGHTNING')
			SetWeatherTypeNowPersist('LIGHTNING')
			NetworkOverrideClockTime(23, 1, 0)
			SetWeatherTypeOverTime('LIGHTNING', 3.0)
			Citizen.Wait(5000)
		end
	end)
end)

RegisterNetEvent('Zero-weathersync:client:SyncTime')
AddEventHandler('Zero-weathersync:client:SyncTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

RegisterNetEvent('Zero-weathersync:client:SyncWeather')
AddEventHandler('Zero-weathersync:client:SyncWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
		if not disable then
			local newBaseTime = baseTime
			if GetGameTimer() - 500  > timer then
				newBaseTime = newBaseTime + 0.25
				timer = GetGameTimer()
			end
			if freezeTime then
				timeOffset = timeOffset + baseTime - newBaseTime			
			end
			baseTime = newBaseTime
			hour = math.floor(((baseTime+timeOffset)/60)%24)
			minute = math.floor((baseTime+timeOffset)%60)
			NetworkOverrideClockTime(hour, minute, 0)

			Citizen.Wait(2000)
		else
			Citizen.Wait(1000)
		end
    end
end)

Citizen.CreateThread(function()
    while true do
		if not disable then
			if lastWeather ~= CurrentWeather then
				lastWeather = CurrentWeather
				SetWeatherTypeOverTime(CurrentWeather, 15.0)
				Citizen.Wait(15000)
			end
			Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
			SetBlackout(blackout)
			ClearOverrideWeather()
			ClearWeatherTypePersist()
			SetWeatherTypePersist(lastWeather)
			SetWeatherTypeNow(lastWeather)
			SetWeatherTypeNowPersist(lastWeather)
			if lastWeather == 'XMAS' then
				SetForceVehicleTrails(true)
				SetForcePedFootstepsTracks(true)
			else
				SetForceVehicleTrails(false)
				SetForcePedFootstepsTracks(false)
			end
		else
			Citizen.Wait(1000)
		end
    end
end)