RegisterServerEvent("Zero:Server-Dealership:BuyVehicle")
AddEventHandler("Zero:Server-Dealership:BuyVehicle", function(model)
    local src = source
    local Player = Zero.Functions.Player(src)

    config.vehicles[model] = config.vehicles[model] ~= nil and config.vehicles[model] or {
        label = "",
        price = 0,
        speed = 1,
    }

    local price = config.vehicles[model].price

    Player.Functions.ValidRemove(price, "Voertuig ("..model..") gekocht bij cardealer PDM", function(bool)
        if bool then
            Zero.Functions.Notification("PDM", "Voertuig gekocht")

            local plate = GeneratePlate()

            Zero.Functions.ExecuteSQL(false, "INSERT INTO `citizen_vehicles` (`citizenid`, `model`, `mods`, `location`, `plate`) VALUES (?, ?, ?, ?, ?)", {
                Player.User.Citizenid,
                model, 
                json.encode({}),
                "*",
                plate,
            }, function()
                Player.Functions.AddVehicle(plate)
                TriggerClientEvent("Zero:Client-Dealership:Plate", src, plate)
            end)
        end
    end, {
        title = "Voertuig gekocht bij PDM",
        subtitle = "Voertuig ("..model..") gekocht bij cardealer PDM",
    })
end)

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