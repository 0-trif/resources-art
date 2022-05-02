RegisterNetEvent("zero:loading:stop")
AddEventHandler("zero:loading:stop", function()
    ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()


    SendNUIMessage({action = "hide"})
end)