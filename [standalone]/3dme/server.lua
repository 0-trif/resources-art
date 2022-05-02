
exports["zero-core"]:object(function(O) Zero = O end)

Zero.Commands.Add("me", "Me command", {}, false, function(source, args)
	local text = table.concat(args, ' ')
	local Player = Zero.Functions.Player(source)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
end, 0)
