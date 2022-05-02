local registered = {}

exports['zero-core']:object(function(O) Zero = O end)

RegisterServerEvent("vehicleHirePlate")
AddEventHandler("vehicleHirePlate", function(plate, price)
    local src = source
    local Player = Zero.Functions.Player(src)
    Player.Functions.RemoveMoney("bank", price, "Voertuig gehuurd")

    local name = Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname

    Player.Functions.Inventory().functions.add({
        item = "certificate",
        amount = 1,
        datastash = {
            plate = plate,
            message = "Document type: verhuur document <br> <br> Verhuurd aan: "..name.." <br> Huurprijs: "..price.." <br> Kenteken: "..plate.." <br> ",
        }
    })

    registered[plate] = price
end)

RegisterServerEvent("vehicleHireCollect")
AddEventHandler("vehicleHireCollect", function(plate)
    local src = source
    local Player = Zero.Functions.Player(src)

    if registered[plate] then
        Player.Functions.GiveMoney("bank", registered[plate], "Voertuig ingeleverd bij monkey ofzo")    

        registered[plate] = nil

        local inv = Player.Functions.Inventory().inventory
        for k,v in pairs(inv) do
            if v.datastash then
                if v.datastash.plate and (v.datastash.plate == plate) then
                    Player.Functions.Inventory().functions.remove({slot = k, amount = 1})
                    break
                end
            end
        end
    end
end)

