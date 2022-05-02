
exports["zero-core"]:object(function(O) Zero = O end)


RegisterServerEvent("Zero-appartments:server:stash")
AddEventHandler("Zero-appartments:server:stash", function(index)
    local src = source
    local player = Zero.Functions.Player(src)
    local personalString = index .. "-appartment" .. "-"..player.User.Citizenid..""
    
    exports['zero-inventory']:openstash({
        index = personalString,
        database = "appartments-stashes",
        slots = 50,
        src = src,
        label = "Stash",
        event = "inventory:server:stash",
    })
end)
