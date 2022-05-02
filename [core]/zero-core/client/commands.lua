Zero.Functions.Command("job", function(source, args)
    local duty = Zero.Player.Job.duty == true and "In dienst" or "Uit dienst"
    Zero.Functions.Notification("Baan", "Baan: "..Zero.Config.Jobs[Zero.Player.Job.name].label.." ("..duty..") Rang: "..Zero.Config.Jobs[Zero.Player.Job.name].grades[Zero.Player.Job.grade].label.."", "success", 5000)
end)

Zero.Functions.Command("salaris", function(source, args)
    Zero.Functions.Notification("Salaris", "Uw salaris als "..Zero.Config.Jobs[Zero.Player.Job.name].label.." Rang "..Zero.Config.Jobs[Zero.Player.Job.name].grades[Zero.Player.Job.grade].label.." is in dienst (€"..Zero.Config.Jobs[Zero.Player.Job.name].grades[Zero.Player.Job.grade].salary..") | Uit dienst (€"..Zero.Config.Jobs[Zero.Player.Job.name].offduty..") <br> Salaris timer: "..(Zero.Config.SalaryTimer/60000).." min", "success", 5000)
end)

Zero.Functions.Command("money", function(source, args)
    Zero.Functions.Notification("Geld", "Cash €"..Zero.Player.Money.cash.." <br> Bank €"..Zero.Player.Money.bank.." <br> Zwartgeld €"..Zero.Player.Money.black.."", "success", 5000)
end)
