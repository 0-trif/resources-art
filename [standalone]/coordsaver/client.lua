
RegisterCommand('coords', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = "{x = "..coords.x..", y = "..coords.y..", z = "..coords.z..", h = "..GetEntityHeading(PlayerPedId()).."}"
	})
end)
