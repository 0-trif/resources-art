exports["zero-core"]:object(function(O) Zero = O end)


function round(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local src = source
	local Player = Zero.Functions.Player(src)

	Player.Functions.ValidRemove(price, "Betalen fuel", function(bool)
		if not bool then return end
		
		local amount = round(price)
		Player.Functions.RemoveMoney('cash', amount, "Benzine gekocht")
	end)
end)
