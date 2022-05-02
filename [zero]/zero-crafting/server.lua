exports['zero-core']:object(function(O) Zero = O end)

RegisterServerEvent("Zero:Server-Crafting:UsedC4")
AddEventHandler("Zero:Server-Crafting:UsedC4", function()
    TriggerClientEvent("Zero:Server-Crafting:Explode", -1)
end)