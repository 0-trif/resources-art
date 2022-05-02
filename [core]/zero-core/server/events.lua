RegisterServerEvent('Zero:Server-Core:NetworkStarted')
AddEventHandler("Zero:Server-Core:NetworkStarted", function()
    local _src = source
    local identifiers = Zero.Functions.Identifiers(_src)

    if (identifiers.steam) then
        TriggerClientEvent("Zero:Client-Core:NetworkStarted", _src, Zero.Functions.Characters(identifiers.steam))
    else
        DropPlayer(_src, "Je moet steam aan hebben staan om op deze server te spelen.")
    end
end)

RegisterServerEvent("Zero:Server-Core:UpdateLocation")
AddEventHandler("Zero:Server-Core:UpdateLocation", function(x,y,z,h)
	local _src = source

	if (Zero.Players[_src]) then
		Zero.Players[_src].MetaData.Location = {
			x = x,
			y = y, 
			z = z, 
			h = h,
		}
	end
end)

RegisterServerEvent("Zero:Server:TriggerCallback")
AddEventHandler('Zero:Server:TriggerCallback', function(name, ...)
	local src = source
	Zero.Functions.TriggerCallback(name, src, function(...)
		TriggerClientEvent("Zero:Client:TriggerCallback", src, name, ...)
	end, ...)
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	deferrals.update(string.format("Welkom %s op Zero.", name))
	local playerId, identifier = source

	Citizen.Wait(1000)

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			identifier = v
			break
		end
	end

	if not identifier then
		deferrals.done("steam niet open")
		return
	end


	if Zero.Config.DevMode then
		if not Zero.Config.Developers[identifier] then
			deferrals.done("Server staat in development mode! gr trif")
		end
	end

	deferrals.update(string.format("Welkom %s, we controleren nu de banstatus!", name))

	local isBanned, Reason = Zero.Functions.Banned(playerId)

	Citizen.Wait(2000)

	if isBanned then
		deferrals.done(Reason)
	end
	deferrals.done()

	--exports['zero-diswl']:playerConnecting(playerId, deferrals)
	
	--[[
			
		if (Zero.Config.DevMode) then
			if (Zero.Config.Developers[identifier]) then
				deferrals.done()
			else
				Zero.Functions.CreateLog("server", "DEV MODE", "Speler staat nog niet op de dev whitelist: \n **SteamId:** ".. identifier .."", "red", false)
				deferrals.done("Server is in dev mode neef")
			end
		end

	]]
end)

local drop = function(source)
	if Zero.Players[source] then
		local cid = Zero.Players[source].User.Citizenid

		TriggerEvent("Zero:Server-Core:PlayerLeft", Zero.Players[source].User)
		
		Zero.Players[source].Functions.Save(true)
		local inventory = Zero.Players[source].Functions.Inventory()
		if inventory then
			inventory.functions.save(true)
		end

		Zero.Players[source] = nil

		Zero.Functions.Debug("Player with CID - ^2"..cid.."^1 Unloaded")
	end

	updatePlayers()
end

AddEventHandler("playerDropped", function(reason)
	local _src = source
	drop(_src)
end)


RegisterServerEvent("Zero:Server-Core:NewStarter")
AddEventHandler("Zero:Server-Core:NewStarter", function()
	local src = source
	local inventory = Zero.Players[src].Functions.Inventory()

	inventory.functions.add({
		item = "idcard",
		amount = 1,
	})
	inventory.functions.add({
		item = "driverslicense",
		amount = 1,
	})
	inventory.functions.add({
		item = "phone",
		amount = 1,
	})
	inventory.functions.add({
		item = "water",
		amount = 1,
	})
	inventory.functions.add({
		item = "sandwich",
		amount = 1,
	})
end)

RegisterServerEvent("Zero:Server-Core:SetDimension")
AddEventHandler("Zero:Server-Core:SetDimension", function(dimension)
	local src = source
	dimension = dimension ~= nil and dimension or math.random(1111, 9999)
	
	SetPlayerRoutingBucket(src, dimension)
end)

