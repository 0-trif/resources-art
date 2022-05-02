Zero.Commands = {}
Zero.Commands.List = {}

Zero.Commands.Add = function(name, help, arguments, argsrequired, callback, permission)
	Zero.Commands.List[string.lower(name)] = {
		name = string.lower(name),
		permission = permission ~= nil and tonumber(permission) or 0,
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

Zero.Commands.Refresh = function(source)
	local Player = Zero.Functions.Player(source)
	if Player ~= nil then
		for command, info in pairs(Zero.Commands.List) do
			if Zero.Functions.Role(source, 10) or Zero.Functions.Role(source, Zero.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = Zero.Functions.SplitStr(message, " ")
		local command = string.gsub(string.lower(args[1]), "/", "")
		CancelEvent()
		if Zero.Commands.List[command] ~= nil then
			local Player = Zero.Functions.Player(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (Zero.Functions.Role(source, 10) or Zero.Functions.Role(source, Zero.Commands.List[command].permission)) then
					if (Zero.Commands.List[command].argsrequired and #Zero.Commands.List[command].arguments ~= 0 and args[#Zero.Commands.List[command].arguments] == nil) then
                        Player.Functions.Notification('Command', 'Je moet alle argumenten invullen', 'error')
					    local agus = ""
					    for name, help in pairs(Zero.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
					else
						Zero.Commands.List[command].callback(source, args)
						local Player = Zero.Functions.Player(source)


						Zero.Functions.CreateLog("command", "Command executed", "Command ("..command..") gebruikt: \n **Message:** "..message.." \n **Citizenid:** "..Player.User.Citizenid.." \n **Identifier:** "..Player.User.Identifier.."", "green", false)
					end
				else
					Player.Functions.Notification('Command', 'Je hebt geen access tot deze command', 'error')
				end
			end
		end
	end
end)

RegisterServerEvent('Zero:CallCommand')
AddEventHandler('Zero:CallCommand', function(command, args)
	if Zero.Commands.List[command] ~= nil then
		local Player = Zero.Functions.Player(tonumber(source))
		if Player ~= nil then
			if (Zero.Functions.Role(source, 10)) or (Zero.Functions.Role(source, Zero.Commands.List[command].permission)) or (Zero.Commands.List[command].permission == Player.Job.name) then
				if (Zero.Commands.List[command].argsrequired and #Zero.Commands.List[command].arguments ~= 0 and args[#Zero.Commands.List[command].arguments] == nil) then
                    Player.Functions.Notification('Command', 'Je moet alle argumenten invullen', 'error')
					local agus = ""
					for name, help in pairs(Zero.Commands.List[command].arguments) do
						agus = agus .. " ["..help.name.."]"
					end
					TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
				else
					Zero.Commands.List[command].callback(source, args)
				end
			else
                Player.Functions.Notification('Command', 'Je hebt geen access tot deze command', 'error')
			end
		end
	end
end)

RegisterServerEvent("Zero:AddCommand")
AddEventHandler('Zero:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	Zero.Commands.Add(name, help, arguments, argsrequired, callback, persmission)
end)

Zero.Commands.Add("dv", "Verwijder voertuig (Admin Only)", {}, false, function(source, args)
    TriggerClientEvent('Zero:Client-Core:DeleteVehicle', source)
end, 1)

Zero.Commands.Add("setjob", "Stel speler baan in (Admin Only)", {{name="playerid", help="Speler id van target"}, {name="job", help="Nieuwe baan voor speler"}, {name="level", help="job grade voor speler"}}, true, function(source, args)
    local targetId = tonumber(args[1])
    local job = args[2]
    local grade = tonumber(args[3])
	local player = Zero.Players[source]

    if (Zero.Players[targetId]) then
        local target = Zero.Players[targetId]

        if (targetId and job) then
            if (Zero.Config.Jobs[job]) then
                local grade = grade ~= nil and grade or 0
                grade = grade <= #Zero.Config.Jobs[job].grades and grade or #Zero.Config.Jobs[job].grades
                target.Functions.SetJob(job, grade)

                player.Functions.Notification("Command", "Baan ("..Zero.Config.Jobs[job].label..") ingesteld voor "..GetPlayerName(targetId).."", "success", 5000)
                target.Functions.Notification("Baan", "Uw nieuwe baan is nu ("..Zero.Config.Jobs[job].label..") Level: "..Zero.Config.Jobs[job].grades[grade].label.."", "success", 5000)
            else
                player.Functions.Notification("Command", "Baan ("..job..") staat niet in de core configuration", "error", 5000)
            end
        end
    end
end, 1)

Zero.Commands.Add("setcrew", "Stel speler family/crew in (Admin Only)", {{name="playerid", help="Speler id van target"}, {name="crew", help="Nieuwe crew voor speler"}, {name="level", help="crew grade voor speler"}}, true, function(source, args)
    local targetId = tonumber(args[1])
    local crew = args[2]
    local grade = tonumber(args[3])
	local player = Zero.Players[source]

    if (Zero.Players[targetId]) then
        local target = Zero.Players[targetId]

        if (targetId and crew) then
            if (Zero.Config.Crews[crew]) then
                local grade = grade ~= nil and grade or 0
                target.Functions.SetCrew(crew, grade)

                player.Functions.Notification("Command", "Groep ("..Zero.Config.Crews[crew].label..") ingesteld voor "..GetPlayerName(targetId).."", "success", 5000)
            else
                player.Functions.Notification("Command", "Baan ("..job..") staat niet in de core configuration", "error", 5000)
            end
        end
    end
end, 1)

Zero.Commands.Add("givemoney", "Geef geld aan een speler (Admin Only)", {{name="spelerid", help="playerid van target"}, {name="type", help="bank || cash"}, {name="amount", help="hoeveelheid voor speler"}}, true, function(source, args)
    local targetId = tonumber(args[1])
    local type = args[2]
    local amount = tonumber(args[3])

    if (targetId and type and amount) then
        local target = Zero.Players[targetId]
    	target.Functions.GiveMoney(type, amount, "Ingspawned geld met een admin command")
    end
end, 1)

Zero.Commands.Add("sv", "Spawn een voertuig in (Admin Only)", {{name="model", help="Model van voertuig (no hash)"}}, true, function(source, args)
    local model = args[1]
    TriggerClientEvent('Zero:Client-Core:SpawnVehicle', source, model)
end, 1)

Zero.Commands.Add("id", "Zie je eigen speler ID", {}, false, function(source, args)
	local Player = Zero.Functions.Player(source)

    Player.Functions.Notification("Command", "Je huidige ID is ("..source..")", "success", 5000)
end, 0)

Zero.Commands.Add("bsn", "Zie je eigen speler BSN", {}, false, function(source, args)
	local Player = Zero.Functions.Player(source)

	TriggerClientEvent('chatMessage', source, "BSN:", "sucess", ""..Player.User.Citizenid.."")
end, 0)

Zero.Commands.Add("bloodtype", "Zie je eigen speler bloodtype", {}, false, function(source, args)
	local Player = Zero.Functions.Player(source)
	TriggerClientEvent('chatMessage', source, "Bloodtype:", "sucess", ""..Player.Genetics.bloodtype.."")
end, 0)

Zero.Commands.Add("setlevel", "(server rule command)", {{name="spelerid", help='playerid van target player'}, {name="level", help="group level (>= 0 || <= 10)"}}, true, function(source, args)
    local playerId = tonumber(args[1])
    local level    = tonumber(args[2])

    if (playerId and level) then
        if (Zero.Players[playerId]) then
            local target = Zero.Players[playerId]

            if Zero.Admins[target.User.Identifier] then
				Zero.Functions.ExecuteSQL(false, "UPDATE `roles` SET `group` = ? WHERE `index` = ?", {
                    level,
                    target.User.Identifier
                })
            else
				Zero.Functions.ExecuteSQL(false, "INSERT INTO `roles` (`index`, `group`) VALUES (?, ?)", {
                    target.User.Identifier,
                    level
                })
            end

            Zero.Admins[target.User.Identifier] = level
        end
    end
end, 10)

Zero.Commands.Add("oban", "Offline ban player (admins)", {{name="bsn (stateid)", help='Citizenid van player'}, {name="time", help="1d, 1w, 1m, 1y"}}, true, function(source, args)
    local playerId = args[1]
    local time    = args[2]

	local reason = args
	table.remove(reason, 1)
	table.remove(reason, 1)
	local reason = reason

    if (playerId and time) then
		Zero.Functions.oBan(playerId, time, reason, source)
    end
end, 1)
