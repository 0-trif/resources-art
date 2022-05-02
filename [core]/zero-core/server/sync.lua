Zero.Players = Zero.Players ~= nil and Zero.Players or {}
Zero.Admins = {}

Citizen.CreateThread(function()
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `roles`", function(roles)
        for k,v in pairs(roles) do
            Zero.Admins[v.index] = tonumber(v.group)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(Zero.Config.SalaryTimer)

        for k,v in pairs(Zero.Players) do
            if v.Job.duty then
                amount = Zero.Config.Jobs[v.Job.name].grades[v.Job.grade].salary
            else
                amount = Zero.Config.Jobs[v.Job.name].offduty
            end
            
            v.Functions.GiveMoney("bank", amount, "Uitbetaling van het salaris.")
            v.Functions.Notification("Salaris", "U heeft €"..amount.." salaris ontvangen", "success", 8000, {
                title = "Salaris",
                subtitle = "U heeft €"..amount.." salaris ontvangen voor uw baan als "..Zero.Config.Jobs[v.Job.name]['label'].." | "..Zero.Config.Jobs[v.Job.name].grades[v.Job.grade].label..""
            })
        end
    end
end)

Citizen.CreateThread(function()
    while true do

        for k,v in pairs(Zero.Players) do
            v.Functions.Save()
            
            local inventory = v.Functions.Inventory()
            if inventory then
                inventory.functions.save(true)
            end
        end

        Wait(60000*5)
    end
end)