Citizen.CreateThread(function()
	while true do
		SetVehicleDensityMultiplierThisFrame(0.2)
	    SetPedDensityMultiplierThisFrame(0.2)
	    SetParkedVehicleDensityMultiplierThisFrame(0.2)
		SetScenarioPedDensityMultiplierThisFrame(0.5, 0.5)

		SetRandomVehicleDensityMultiplierThisFrame(0.2)

		Citizen.Wait(0)
	end
end)