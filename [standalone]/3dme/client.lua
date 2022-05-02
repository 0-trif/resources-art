local nbrDisplaying = 0

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    --local offset = 1 + (nbrDisplaying*0.14)
    Display(source, GetPlayerFromServerId(source), text)
end)

function Display(id, mePlayer, text)
    local displaying = true

    Citizen.CreateThread(function()
        Wait(5000)
        displaying = false
    end)

    Citizen.CreateThread(function()
        local offset = 0 + (nbrDisplaying*0.14)
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)


            if GetPlayerPed(mePlayer) then
                local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
                local coords = GetEntityCoords(PlayerPedId(), false)
                local dist = GetDistanceBetweenCoords(coordsMe.x, coordsMe.y, coordsMe.z, coords.x, coords.y, coords.z, true)

    
                if id == GetPlayerServerId(mePlayer) then
                    DrawText3Ds(coordsMe['x'], coordsMe['y'], coordsMe['z'] + offset, text, 1)
                else
                    if dist < 20 and GetPlayerPed(mePlayer) ~= PlayerPedId() then
                        DrawText3Ds(coordsMe['x'], coordsMe['y'], coordsMe['z'] + offset, text, 1)
                    end
                end
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3Ds(x, y, z, text)
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
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end