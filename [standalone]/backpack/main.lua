Citizen.CreateThread(function()
    while true do
        local timer = config.weaponTimer

        TriggerEvent("weapons")
  
        Wait(timer)
    end
end)

