local doorInfo = {}

RegisterServerEvent('doorlock:server:setupDoors')
AddEventHandler('doorlock:server:setupDoors', function()
	local src = source
	TriggerClientEvent("doorlock:client:setDoors", src, Shared.Config.Doors)
end)

RegisterServerEvent('doorlock:server:updateState')
AddEventHandler('doorlock:server:updateState', function(doorID, state)
	local src = source
	Shared.Config.Doors[doorID].locked = state
	TriggerClientEvent('doorlock:client:setState', -1, doorID, state)
end)