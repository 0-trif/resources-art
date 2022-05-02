exports["zero-core"]:object(function(O) Zero = O end)

RegisterServerEvent("Zero:Server-Banking:PostEvent")
AddEventHandler("Zero:Server-Banking:PostEvent", function(type, uidata)
    local src = source
    local amount = tonumber(uidata.amount)
    local Player = Zero.Functions.Player(src)

    if amount <= 0 then
        return
    end

    if (type and uidata) then
        if (type == "add") then
            if (Player.Money.cash >= amount) then
                Player.Functions.RemoveMoney("cash", amount, "Geld gestort bij de bank", {
                    title = "Geld storting",
                    subtitle = "Geld gestort bij de bank"
                })
                Player.Functions.GiveMoney("bank", amount, "Geld gestort bij de bank", {
                    title = "Geld storting",
                    subtitle = "Geld gestort bij de bank"
                })
            end
        elseif (type == "remove") then
            if (Player.Money.bank >= amount) then
                Player.Functions.RemoveMoney("bank", amount, "Geld gestort bij de bank", {
                    title = "Geld opnamen",
                    subtitle = "Geld opgenomen bij de bank"
                })
                Player.Functions.GiveMoney("cash", amount, "Geld gestort bij de bank", {
                    title = "Geld opnamen",
                    subtitle = "Geld opgenomen bij de bank"
                })
            end
        elseif (type == "transfer") then
            if (Player.Money.bank >= amount) then
                local PlayerFound = Zero.Functions.PlayerByCitizenid(uidata.bsn)

                if (PlayerFound) then
                    Player.Functions.RemoveMoney("bank", amount, "Geld overgemaakt naar burger met BSN ("..uidata.bsn..")", {
                        title = "Transactie",
                        subtitle = "Geld overgemaakt naar burger met BSN ("..uidata.bsn..")",
                    })

                    PlayerFound.Functions.GiveMoney("bank", amount, "Geld ontvangen van burger met BSN ("..Player.User.Citizenid..")", {
                        title = "Transactie",
                        subtitle = "Geld ontvangen van burger met BSN ("..Player.User.Citizenid..")",
                    })
                else 
                    Player.Functions.Notification("System", "Geen burger met deze BSN gevonden", "error", 7000)
                end
            end
        end
    end
end)

Zero.Commands.Add("givecash", "Geef geld aan een speler", {{name="spelerid", help="playerid van target"}, {name="amount", help="hoeveelheid voor speler"}}, true, function(source, args)
    local targetId = tonumber(args[1])
    local amount = tonumber(args[2])

    local src = source

    if (targetId and type and amount) then
        if amount > 0 then
            local Player = Zero.Functions.Player(src)
            if (Player.Money.cash >= amount) then
                local target = Zero.Functions.Player(targetId)

                if target then
                    Player.Functions.RemoveMoney("cash", amount, "Contant geld gegeven aan burger ("..targetId..")")
                    target.Functions.GiveMoney("cash", amount, "Contant geld ontvangen van burger ("..src..")")


                    Player.Functions.Notification('Cash', 'Geld gegeven aan burger', 'success')
                    target.Functions.Notification('Cash', 'Geld ontvangen van burger', 'success')
                else
                    Player.Functions.Notification('Cash', 'Burger met dit id bestaat niet', 'error')
                end
            else
                Player.Functions.Notification('Cash', 'Ongeldige hoeveelheid', 'error')
            end
        else
            Player.Functions.Notification('Cash', 'Ongeldige hoeveelheid', 'error')
        end
    end
end, 0)

Zero.Functions.CreateCallback("Zero:Server-Banking:GetSafe", function(src, cb, id, safetp)
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `banking-safes` WHERE  `id` = ?", {
        id,
    }, function(result)
        if (result[1]) then
            local amount = tonumber(result[1].amount)
            cb({
                id = id,
                amount = amount >= 0 and amount or 0,
                type = safetp
            })
        else
            Zero.Functions.ExecuteSQL(false, "INSERT INTO `banking-safes` (`id`, `amount`, `type`) VALUES (?, ?, ?)", {
                id,
                0,
                safetp,
            }, function()
                cb({
                    id = id,
                    amount = 0,
                    type = safetp
                })
            end)
        end
    end)
end)

Zero.Functions.CreateCallback("Zero:Server-Banking:SafeEvent", function(src, cb, id, transfer, amount)
    local Player = Zero.Functions.Player(src)

    if amount <= 0 then return end

    if id and type and amount then
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `banking-safes` WHERE  `id` = ?", {
            id,
        }, function(result)
            if (result[1]) then
                local amountSafe = tonumber(result[1].amount)
                local type = result[1].type

                if Player.Money[type] then
                    if transfer == 'add' then
                        if Player.Money[type] >= amount then
                            Player.Functions.RemoveMoney(type, amount, "Geld in safe "..id.." gedaan")
                            amountSafe = amountSafe + amount
                            Zero.Functions.ExecuteSQL(false, "UPDATE `banking-safes` SET `amount` = ? WHERE `id` = ?", {
                                amountSafe,
                                id
                            })
                            cb({
                                id = id,
                                amount = amountSafe,
                                type = type
                            })
                        end
                    elseif transfer == 'remove' then
                        if amountSafe >= amount then
                            amountSafe = amountSafe - amount
                            Player.Functions.GiveMoney(type, amount, "Geld uit safe "..id.." gepakt")
                            Zero.Functions.ExecuteSQL(false, "UPDATE `banking-safes` SET `amount` = ? WHERE `id` = ?", {
                                amountSafe,
                                id
                            })
                            cb({
                                id = id,
                                amount = amountSafe,
                                type = type
                            })
                        end 
                    end
                end
            end
        end)
    end
end)