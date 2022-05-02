
exports['zero-core']:object(function(O) Zero = O end)


RegisterServerEvent("Zero:Server-Laptop:BuyPacket")
AddEventHandler("Zero:Server-Laptop:BuyPacket", function(index)
    local index = tonumber(index)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (laptop.packets[index]) then
        local Coins = Player.Functions.GetMoney('artcoin')

        if (Coins >= laptop.packets[index].price) then
            Player.Functions.Notification("Dealer", "Pakket voor "..laptop.packets[index].price.." munten gekocht!", "success")
            Player.Functions.RemoveMoney("artcoin", laptop.packets[index].price, "Pakket gekocht in de laptop dealer")

            for k,v in pairs(laptop.packets[index].vehicles) do
                local vehicleModel = v

                local plate = GeneratePlate()

                Zero.Functions.ExecuteSQL(false, "INSERT INTO `citizen_vehicles` (`citizenid`, `model`, `mods`, `location`, `plate`) VALUES (?, ?, ?, ?, ?)", {
                    Player.User.Citizenid,
                    vehicleModel, 
                    json.encode({}),
                    ""..Player.MetaData.appartment.."-garage",
                    plate,
                }, function()
                    Player.Functions.AddVehicle(plate)

                    TriggerClientEvent("Zero:Client-Laptop:Bought", src)                    
                end)
            end
            Player.Functions.Notification("Dealer", "Er zijn "..#laptop.packets[index].vehicles.." voertuigen in je appartement garage gezet.", "success", 8000)
        else
            Player.Functions.Notification("Dealer", "Je hebt niet genoeg munten hiervoor", "error")
        end
    end
end)

-- [plate]


-- plate

NumberCharset = {}
Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
    local found_plate = false
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)

    while not found_plate do
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `plate` = ?", {
            plate,
        }, function(result)
            if (result[1] == nil) then
                found_plate = plate
            else
                plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
            end
        end)

        Wait(0)
    end
    return found_plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end