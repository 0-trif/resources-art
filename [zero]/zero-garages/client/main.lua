exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent("Zero:Client-Garages:AddGarage")
AddEventHandler("Zero:Client-Garages:AddGarage", function(index, data)
    Config.PublicAreas[index] = data

    blip = AddBlipForCoord(Config.PublicAreas[index].x, Config.PublicAreas[index].y, Config.PublicAreas[index].z)

    SetBlipSprite (blip, 357)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.5)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Appartement garage")
    EndTextCommandSetBlipName(blip)
end)

