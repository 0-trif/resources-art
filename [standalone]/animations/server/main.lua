exports["zero-core"]:object(function(O) Zero = O end)


Zero.Commands.Add("am", "Open animatie menu", {}, false, function(source, args)
    TriggerClientEvent('animations:client:ToggleMenu', source)
end, 0)

Zero.Commands.Add("e", "Doe een emote", {}, false, function(source, args)
    TriggerClientEvent('animations:client:EmoteCommandStart', source, args)
end, 0)

Zero.Commands.Add("walkstick", "Krijg een wandelstok", {}, false, function(source, args)
    TriggerClientEvent("animations:UseWandelStok", source)
end, 0)
