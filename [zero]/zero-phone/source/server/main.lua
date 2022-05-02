Phone = {}
Phone.Players = {}
Phone.SOS = {}

exports["zero-core"]:object(function(O) Zero = O end)

AddEventHandler("playerDropped", function()
    local src = source
    if (Phone.Players[src]) then
        Phone.Players[src].Save()
        Wait(1000)
        Phone.Players[src] = nil
    end
end)

RegisterServerEvent("Zero:Server-Phone:Settings")
AddEventHandler("Zero:Server-Phone:Settings", function() 
    local src = source
    local Player = CreateUser(src)

    Phone.Players[src] = Player

    for k, v in pairs(Phone.Players[src].Contacts) do
        if (SQL_Phone_DB[v.number]) then
            v.pf = SQL_Phone_DB[v.number].whatsapp.pf
        end
    end

    TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
    local rp_name = Phone.Players[src].Whatsapp.firstname .. " ".. Phone.Players[src].Whatsapp.lastname
    TriggerClientEvent("Zero:Client-Phone:TwitterSettings", src, Phone.Players[src].Twitter, rp_name)

    SetupWhatsappMessages(src, function(chats)
        TriggerClientEvent("Zero:Server-Phone:Chats", src, chats)
    end)
end)

RegisterServerEvent("Zero:Server-Phone:AirplaneMode")
AddEventHandler("Zero:Server-Phone:AirplaneMode", function() 
    local src = source

    if Phone.Players[src] then
        Phone.Players[src].Settings.airplanemode = not Phone.Players[src].Settings.airplanemode
        TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
    end
end)

RegisterServerEvent("Zero:Server-Phone:BackgroundImage")
AddEventHandler("Zero:Server-Phone:BackgroundImage", function(url) 
    local src = source

    if Phone.Players[src] then
        Phone.Players[src].Settings.background = url
        TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
    end
end)

local validEmail = function(email, src)
    local Player = Zero.Functions.Player(src)


    if ((string.find(email, "@gmail.com") ~= nil) or (string.find(email, "@Zero.com") ~= nil) or (string.find(email, "@protonmail.com") ~= nil)) then
        return email
    else
        return Player.PlayerData.firstname .. '.' .. Player.PlayerData.lastname .. '@gmail.com'
    end
end

RegisterServerEvent("Zero:Server-Phone:DataPage")
AddEventHandler("Zero:Server-Phone:DataPage", function(email) 
    local src = source

    if Phone.Players[src] then
        Phone.Players[src].PhoneData.email = validEmail(email, src)
        TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
    end
end)

local isTagValid = function(tag, cb)
    if (tag:sub(1, 1) == "@") then
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone` WHERE `paypal` LIKE '%"..tag.."%'", function(result)
            if not result[1] then
                valid = true
            else
                valid = false
            end
            cb(valid)
        end)
    else
        cb(false)
    end
end

RegisterServerEvent("Zero:Server-Phone:PayPalSettings")
AddEventHandler("Zero:Server-Phone:PayPalSettings", function(data) 
    local src = source

    if data.nickname and data.pf and data.tag then
        Phone.Players[src].PayPal.pf = data.pf
        Phone.Players[src].PayPal.nickname = data.nickname

        isTagValid(data.tag, function(valid)
            if valid then
                Phone.Players[src].PayPal.tag = data.tag
            end
            TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
        end)
    end
end)


RegisterServerEvent("Zero:Server-Phone:removeContact")
AddEventHandler("Zero:Server-Phone:removeContact", function(number) 
    local src = source
    if not number then return end

    Phone.Players[src].Contacts[number] = nil

    TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
end)

RegisterServerEvent("Zero:Server-Phone:editContact")
AddEventHandler("Zero:Server-Phone:editContact", function(data) 
    local src = source

    if data.firstname == "" or data.lastname == "" then return end

    Phone.Players[src].Contacts[data.number].firstname = data.firstname
    Phone.Players[src].Contacts[data.number].lastname = data.lastname

    TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
end)

RegisterServerEvent("Zero:Server-Phone:AddContact")
AddEventHandler("Zero:Server-Phone:AddContact", function(data) 
    local src = source
    if not data.number then return end

    local number = data.number
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone` WHERE `number` = '"..number.."'", function(result)
        if (result[1]) then
            local WhatsappData = json.decode(result[1].whatsapp)

            data.firstname = data.firstname ~= "" and data.firstname or WhatsappData.firstname
            data.lastname = data.lastname ~= "" and data.lastname or WhatsappData.lastname

            if Phone.Players[src].Contacts[number] == nil then
                Phone.Players[src].Contacts[number] = {
                    ['number'] = number,
                    ['firstname'] = data.firstname,
                    ['lastname'] = data.lastname,
                    ['pf'] = SQL_Phone_DB:get(number).whatsapp.pf,
                    ['history'] = {},
                }
                TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
            end
        end
    end)
end)

RegisterServerEvent("Zero:Server-Phone:TransferMoney")
AddEventHandler("Zero:Server-Phone:TransferMoney", function(tag, amount, reason) 
    local src = source
    local Target = nil

    if amount <= 0 then return end

    if tonumber(tag) == nil then
        for k,v in pairs(Phone.Players) do
            if (v.PayPal) then
                if (v.PayPal.tag == tag) then       
                    Target = k
                end
            end
        end
    else
        tag = tonumber(tag)
        Target = tag
    end

    if Target then
        local TargetPlayer = Zero.Functions.Player(Target)
        local SourcePlayer = Zero.Functions.Player(src)
        local reason = reason ~= "" and reason or "Geen reden voor transactie"

        if (SourcePlayer.Money.bank >= amount) then
            SourcePlayer.Functions.RemoveMoney('bank', amount, "Geld overgemaakt via paypal", {
                title = "PayPal transactie ("..TargetPlayer.PlayerData.firstname..")",
                subtitle = reason,
            })
            TargetPlayer.Functions.GiveMoney('bank', amount, "Geld ontvangen via paypal", {
                title = "PayPal transactie ("..SourcePlayer.PlayerData.firstname..")",
                subtitle = reason,
            })

            TriggerClientEvent("Zero:Client-Phone:PayPalContact", src, Phone.Players[Target].PayPal)
        end
    end
end)

ChatHistoryCache =  {}
local GetHistory = function(src, number)
    history = {}

    if Phone.Players[src] then
        local src_number = Phone.Players[src].Number

        if ChatHistoryCache[src_number .. "-" .. number] then
            return ChatHistoryCache[src_number .. "-" .. number]
        end
        if ChatHistoryCache[number .. "-" .. src_number] then
            return ChatHistoryCache[number .. "-" .. src_number]
        end

        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone-messages` WHERE `index` =  ? OR `index` = ?", {
            number .. "-" .. src_number,
            src_number .. "-" .. number,
        }, function(result)
            if result[1] == nil then    
                Zero.Functions.ExecuteSQL(true, "INSERT INTO `phone-messages` (`index`, `history`, `date`, `number_one`, `number_two`) VALUES (?, ?, ?, ?, ?)", {
                    number .. "-" .. src_number,
                    json.encode({}),
                    os.time(),
                    number,
                    src_number,
                })

                history = {
                    history = {},
                    index = number .. "-" .. src_number,
                    date = os.time(),
                }
                ChatHistoryCache[number .. "-" .. src_number] = history
            else
                history = {
                    history = json.decode(result[1].history),
                    index = result[1].index,
                    date = result[1].date,
                }
                ChatHistoryCache[result[1].index] = history
            end
        end)
    end

    return history
end

local UpdateChatHistory = function(index, history)
    ChatHistoryCache[index] = history

    Zero.Functions.ExecuteSQL(true, "UPDATE `phone-messages` SET `history` =  ?, `date` = ? WHERE `index` = ?", {
        json.encode(ChatHistoryCache[index].history),
        os.time(),
        index,
    })
end

local GetPlayerByNumber = function(number)
    for k,v in pairs(Phone.Players) do
        if v.Number == number then return k end
    end
end

RegisterServerEvent("Zero:Server-Phone:SetWhatsappSettings")
AddEventHandler("Zero:Server-Phone:SetWhatsappSettings", function(pf, background)
    local src = source

    if (Phone.Players[src]) then
        Phone.Players[src].Whatsapp.pf = pf
        Phone.Players[src].Whatsapp.background = background

        SQL_Phone_DB:get(Phone.Players[src].Number)
        SQL_Phone_DB[Phone.Players[src].Number].whatsapp = Phone.Players[src].Whatsapp

        TriggerClientEvent("Zero:Server-Phone:Settings", src, Phone.Players[src])
    end
end)

RegisterServerEvent("Zero:Server-Phone:SendMessage")
AddEventHandler("Zero:Server-Phone:SendMessage", function(number, message, img)
    local src = source 
    local src_number = Phone.Players[src].Number
    local player = Zero.Functions.Player(src)

    local history = GetHistory(src, number)

    if (history) then
        table.insert(history.history, {
            message = message,
            sender = src_number,
            senderName = player.PlayerData.firstname,
            time = "Vandaag",
            type = "message",
            img = img,
        })
        UpdateChatHistory(history.index, history)

        TriggerClientEvent("Zero:Client-Phone:AddMessage", src, number, history.history[#history.history])
        SetupWhatsappMessages(src, function(chats)
            TriggerClientEvent("Zero:Server-Phone:Chats", src, chats)

            local target = GetPlayerByNumber(number)
            if target then
                TriggerClientEvent("phone:notification", target, "https://i2.wp.com/iaccessibility.net/wp-content/uploads/2016/09/2013-08-26_09-38-25__Phone_iOS7_App_Icon_Rounded.png?fit=1024%2C1024&ssl=1", player.PlayerData.firstname .. " " .. player.PlayerData.lastname, message, 3000, "whatsapp")
                TriggerClientEvent("Zero:Client-Phone:AddMessage", target, src_number, history.history[#history.history])
                
                SetupWhatsappMessages(target, function(chats)
                    TriggerClientEvent("Zero:Server-Phone:Chats", target, chats)
                end)
            end
        end)
    end
end)

Zero.Functions.CreateCallback('Zero:Server-Phone:GetContact', function(source, cb, number)
    local _ = {}
    local whatsapp = SQL_Phone_DB:get(number)['whatsapp']

    _.name = whatsapp.firstname .. " " .. whatsapp.lastname
    _.number = number
    _.pf = whatsapp.pf
    _.history = GetHistory(source, number)

    cb(_)
end)

Zero.Functions.CreateCallback('Zero:Server-Phone:GetPayPalAccount', function(source, cb, tag)
    if tonumber(tag) == nil then
        for k,v in pairs(Phone.Players) do
            if (v.PayPal) then
                if (v.PayPal.tag == tag) then
                    cb(v.PayPal)
                    return
                end
            end
        end
    else
        tag = tonumber(tag)
        if (Phone.Players[tag]) then
            cb(Phone.Players[tag].PayPal)
            return
        end
    end


    cb(nil)
end)


SQL_Phone_DB = {}
function SQL_Phone_DB:get(number)
    if (SQL_Phone_DB[number]) then
        return SQL_Phone_DB[number]
    else
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone` WHERE `number` = ?", {
            number,
        }, function(result)
            local data = result[1]
            if data then
                SQL_Phone_DB[number] = {
                    whatsapp = json.decode(data.whatsapp),
                    citizenid = data.citizenid,
                }
            end
        end)
    end

    return SQL_Phone_DB[number]
end

--[[
    Citizen.CreateThread(function()
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone`", function(result)
        for k,v in pairs(result) do
            SQL_Phone_DB[v.number] = {
                whatsapp = json.decode(v.whatsapp),
                citizenid = v.citizenid,
            }
        end
    end)
end)

]]
--twt

isStaff = function(src)
    if Zero.Functions.Role(src, 1) then
        return true
    end
    return false
end

twitter_messages = {}


RegisterServerEvent("Zero:Server:SendTwitterMessage")
AddEventHandler("Zero:Server:SendTwitterMessage", function(message, type)
    local src = source
    local playerid = Zero.Functions.Player(src).User.Citizenid


    if (message ~= "" and message ~= nil) then

        table.insert(twitter_messages, {
            playerid = playerid,
            message = message,
            verified = isStaff(src),
            type = type,
            date = os.time(),
            avatar = Phone.Players[src].Twitter.avatar,
            name = Phone.Players[src].Whatsapp.firstname .. " ".. Phone.Players[src].Whatsapp.lastname,
            nickname = Phone.Players[src].Twitter.name
        })


        TriggerClientEvent("phone:notification", -1, Phone.Players[src].Twitter.avatar, Phone.Players[src].Whatsapp.firstname .. " ".. Phone.Players[src].Whatsapp.lastname, message, 3000, "twitter")
        TriggerClientEvent("Zero:Client-Phone:TwitterMessages", -1, twitter_messages)
    end
end)

RegisterServerEvent("Zero:Server:Settings")
AddEventHandler("Zero:Server:Settings", function(e)
    local src = source
    local playerid = Zero.Functions.Player(src).User.Citizenid

    if (e.nick and e.pic) then

        Phone.Players[src].Twitter.name = e.nick
        Phone.Players[src].Twitter.avatar = e.pic

        local rp_name = Phone.Players[src].Whatsapp.firstname .. " ".. Phone.Players[src].Whatsapp.lastname
        TriggerClientEvent("Zero:Client-Phone:TwitterSettings", src, Phone.Players[src].Twitter, rp_name)

    end
end)

-- POLICE EVENTS

RegisterServerEvent('Zero:Server-Phone:EditReport')
AddEventHandler('Zero:Server-Phone:EditReport', function(e)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "police") then
        if (e.title == "") then
            Zero.Functions.ExecuteSQL(true, "DELETE FROM `meos-reports` WHERE `index` = ?", {
                e.index,
            })
        else
            Zero.Functions.ExecuteSQL(true, "UPDATE `meos-reports` SET `title` = ?, `text` = ? WHERE `index` = ?", {
                e.title,
                e.text,
                e.index,
            })
        end
    end
end)

RegisterServerEvent('Zero:Server-Phone:EditDec')
AddEventHandler('Zero:Server-Phone:EditDec', function(e)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "police") then
        if (e.title == "") then
            Zero.Functions.ExecuteSQL(true, "DELETE FROM `meos-decs` WHERE `index` = ?", {
                e.index,
            })
        else
            Zero.Functions.ExecuteSQL(true, "UPDATE `meos-decs` SET `title` = ?, `text` = ? WHERE `index` = ?", {
                e.title,
                e.text,
                e.index,
            })
        end
    end
end)

RegisterServerEvent('Zero:Server-Phone:CreateReport')
AddEventHandler('Zero:Server-Phone:CreateReport', function(e)
    local src = source
    local Player = Zero.Functions.Player(src)
    local title = e.title ~= nil and e.title or "Geen title"
    local text = e.text ~= nil and e.text or ""


    if (Player.Job.name == "police") then
        local label = Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname .. " (".. Zero.Config.Jobs["police"]['grades'][Player.Job.grade]['label'] ..")"
    
        if (e.citizenid) then
            Zero.Functions.ExecuteSQL(true, "INSERT INTO `meos-reports` (`citizenid`, `title`, `text`, `creator`) VALUES (?, ?, ?, ?)", {
                e.citizenid, 
                title,
                text,
                label
            },function(result)

            end)
        end
    end
end)

RegisterServerEvent("Zero:Server-Phone:GiveFineToPlayer")
AddEventHandler("Zero:Server-Phone:GiveFineToPlayer", function(citizenid, index)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "police") then
        if (index) then
            local index = tonumber(index)

            TriggerEvent("Zero:Server-job:PoliceFines", function(fines)
                for k,v in pairs(fines) do 
                    if v.index == index then     
                        Zero.Functions.ExecuteSQL(true, "INSERT INTO `meos-fines` (`citizenid`, `price`, `artikel`, `creator`, `job`) VALUES (?, ?, ?, ?, ?)", {
                            citizenid, 
                            v.price,
                            v.label,
                            Player.PlayerData.firstname .. " " ..  Player.PlayerData.lastname,
                            Player.Job.name
                        },function(result)
                
                        end)

                        return
                    end
                end
            end)
        end
    end
end)

RegisterServerEvent('Zero:Server-Phone:CreateDec')
AddEventHandler('Zero:Server-Phone:CreateDec', function(e)
    local src = source
    local Player = Zero.Functions.Player(src)
    local title = e.title ~= nil and e.title or "Geen title"
    local text = e.text ~= nil and e.text or ""
    
    local label = Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname .. " (".. Zero.Config.Jobs["police"]['grades'][Player.Job.grade]['label'] ..")"
 
    if (Player.Job.name == "police") then
        if (e.citizenid) then
            Zero.Functions.ExecuteSQL(true, "INSERT INTO `meos-decs` (`citizenid`, `title`, `text`, `creator`) VALUES (?, ?, ?, ?)", {
                e.citizenid, 
                title,
                text,
                label
            },function(result)

            end)
        end
    end
end)

RegisterServerEvent("Zero:Server-Phone:RemoveFineFromPlayer")
AddEventHandler("Zero:Server-Phone:RemoveFineFromPlayer", function(cid, index)
    local src = source
    local index = tonumber(index)
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "police") then
        Zero.Functions.ExecuteSQL(true, "DELETE FROM `meos-fines` WHERE `index` = ? AND `citizenid` = ?", {
            index,
            cid
        })
    end
end)

RegisterServerEvent("Zero:Server-Phone:PayBill")
AddEventHandler("Zero:Server-Phone:PayBill", function(index)
    local src = source
    local index = tonumber(index)
    local Player = Zero.Functions.Player(src)

    
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `meos-fines` WHERE `citizenid` = ?", {
        Player.User.Citizenid,
    }, function(result)   
        for k,v in pairs(result) do
            if (v.index == index) then

                local price = tonumber(v.price)
                local money = Player.Money.bank
                if (price <= money) then
                    Player.Functions.RemoveMoney('bank', price, "Factuur betaald via app ("..v.artikel..")")

                    Zero.Functions.ExecuteSQL(true, "DELETE FROM `meos-fines` WHERE `index` = ? AND `citizenid` = ?", {
                        v.index,
                        Player.User.Citizenid
                    })

                    Player.Functions.Notification("Factuur", "Je hebt een factuur van ("..v.price..") betaald")

                    local stash = exports['zero-inventory']:stashData({
                        index = v.job .. "-safe",
                        database = "job-inv",
                        slots = 24,
                        label = "Kluis",
                        event = "inventory:server:stash",
                    })
                
                    local amount = math.ceil(v.price/100)
         
                    stash.add({item = "cashroll", amount = amount})
                    stash.save(true)
                end

                return
            end
        end
    end)
end)

Zero.Functions.CreateCallback('Zero:Server-Phone:GetActiveServices', function(source, cb)
    local _ = {}
    local src = source
    local Player = Zero.Functions.Player(src)
    for k,v in pairs(Config.ServiceJobs) do
        _[v] = Zero.Functions.GetPlayersByJob(k, true)

        for k,v in pairs(_[v]) do
            v.PlayerData.number = Phone.Players[v.User.Source].Number
        end
    end

    cb(_)
end)

Zero.Functions.CreateCallback('Zero:Server-Phone:SearchPlayersMeos', function(source, cb, input)
    local _ = {}
    local Player = Zero.Functions.Player(source)

    if (Player.Job.name == "police") then
        if not (input == "") then
            if (tonumber(input)) then
                local number = tonumber(input)
                local Player = Zero.Functions.Player(number)

                if Player then
                    table.insert(_, {
                        Citizenid = Player.User.Citizenid,
                        ArchivedData = {
                            appartment = Player.MetaData.appartment,
                            job = Zero.Config.Jobs[Player.Job.name].label,
                            jobgrade = Zero.Config.Jobs[Player.Job.name].grades[Player.Job.grade].label,
                            phone = Phone.Players[Player.User.Source].Number,
                            nationality = Player.PlayerData.nationality,
                            birthdate = Player.PlayerData.birthdate,
                            firstname = Player.PlayerData.firstname,
                            lastname = Player.PlayerData.lastname
                        }
                    })
                    cb(_)
                end
            else
                local string_find = input

                Zero.Functions.ExecuteSQL(true, "SELECT * FROM `characters` WHERE `playerdata` LIKE ? OR `citizenid` = ?", {
                    '%'..string_find..'%',
                    string_find,
                }, function(result)
                    for k,v in pairs(result) do
                        local PlayerData = json.decode(v.playerdata)
                        local Money = json.decode(v.money)
                        local Job = json.decode(v.job)
                        local citizenid = v.citizenid
                        local metadata = json.decode(v.metadata)

                        table.insert(_, {
                            Citizenid = citizenid,
                            ArchivedData = {
                                appartment = metadata.appartment,
                                job = Zero.Config.Jobs[Job.name].label,
                                jobgrade = Zero.Config.Jobs[Job.name].grades[Job.grade].label,
                                phone = "---",
                                nationality = PlayerData.nationality,
                                birthdate = PlayerData.birthdate,
                                firstname = PlayerData.firstname,
                                lastname = PlayerData.lastname
                            }
                        })
                    end
                    cb(_)
                end)
            end
        else
            cb(_)
        end
    end
end)

Zero.Functions.CreateCallback('Zero:Server-Phone:GetPlayerDecs', function(source, cb, citizenid)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "police") then
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `meos-decs` WHERE `citizenid` = ?", {
            citizenid,
        }, function(result)   
            cb(result)
        end)
    end
end)


Zero.Functions.CreateCallback('Zero:Server-Phone:GetPlayerReports', function(source, cb, citizenid)
    local Player = Zero.Functions.Player(source)

    if (Player.Job.name == "police") then
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `meos-reports` WHERE `citizenid` = ?", {
            citizenid,
        }, function(result)   
            cb(result)
        end)
    end
end)

Zero.Functions.CreateCallback('Zero:Server-Phone:GetEmployeesMeos', function(source, cb)
    local src = source
    local Players = Zero.Functions.GetPlayersByJob("police", true)

    for k,v in pairs(Players) do
        v.Job.FunctieLabel = Zero.Config.Jobs[v.Job.name].grades[v.Job.grade].label
        v.MetaData.callid = v.MetaData.callid ~= nil and v.MetaData.callid or "Geen"
    end

    cb(Players)
end)


Zero.Functions.CreateCallback('Zero:Server-Phone:SearchVehicleMeos', function(source, cb, plate)
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `citizen_vehicles` WHERE `plate` = ?", {
        plate,
    }, function(result)   
        if (result[1]) then
            local citizenid = result[1]['citizenid']
            local Player = Zero.Functions.PlayerByCitizenid(citizenid)

            if (Player) then
                cb({
                    plate = plate,
                    model = result[1].model,
                    mods  = json.decode(result[1].mods),
                    player = Player.PlayerData,
                    citizenid = result[1].citizenid,
                })
            else
                Zero.Functions.ExecuteSQL(true, "SELECT * FROM `characters` WHERE `citizenid` = ?", {
                    result[1].citizenid,
                }, function(data)
                    cb({
                        plate = plate,
                        citizenid = result[1].citizenid,
                        model = result[1].model,
                        mods  = json.decode(result[1].mods),
                        player = json.decode(data[1].playerdata),
                    })
                end)
            end
        end
    end)
end)

Zero.Functions.CreateCallback('Zero:Server-Phone:GetPlayerFines', function(source, cb, citizenid)
    citizenid = citizenid ~= "" and citizenid or Zero.Functions.Player(source).User.Citizenid

    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `meos-fines` WHERE `citizenid` = ?", {
        citizenid,
    }, function(result)   
        cb(result)
    end)
end)


Zero.Functions.CreateCallback('Zero:Server-Phone:GetSOSNotifications', function(source, cb)
    local src = source
    local Player = Zero.Functions.Player(src)

    if (Player.Job.name == "police" or Player.Job.name == "mechanic" or Player.Job.name == "ambulance") then
        Phone.SOS[Player.Job.name] = Phone.SOS[Player.Job.name] ~= nil and Phone.SOS[Player.Job.name] or {}

        cb(Phone.SOS[Player.Job.name])
    end
end)



RegisterServerEvent("Zero:Server-Phone:SendSOSMessage")
AddEventHandler("Zero:Server-Phone:SendSOSMessage", function(data, location, hideSource)
    local src = source
    local Player = Zero.Functions.Player(src)
    local playername = Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname

    if hideSource then
        playername = "Onbekend"
    end

    if (data.title and data.message) then
        Phone.SOS[data.job] = Phone.SOS[data.job] ~= nil and Phone.SOS[data.job] or {}

        table.insert(Phone.SOS[data.job], {
            title = data.title .. " (".. playername ..")",
            message = data.message,
            location = {x = location.x, y = location.y, z = location.z}
        })


        local players = Zero.Functions.GetPlayersByJob(data.job, true)

        for k,v in pairs(players) do
            if data.job == "police" then
                TriggerClientEvent("phone:notification", v.User.Source, "https://th.bing.com/th/id/OIP._6xSSfLT8u40qFKNorSYswHaHa?pid=ImgDet&rs=1", "Meldingen", "Er is een nieuwe melding binnen gekomen", 3000, "x")
            elseif data.job == "ambulance" then
                TriggerClientEvent("phone:notification", v.User.Source, "https://th.bing.com/th/id/R.4b73703c261725dc1de562d22e2a3aee?rik=rEs4l8z287hD%2fg&riu=http%3a%2f%2fclipart-library.com%2fdata_images%2f212230.jpg&ehk=fGR0vpj4A%2fbLP%2b9sjnuHKJh6Ab0g%2fcQQz0905sCSRh0%3d&risl=&pid=ImgRaw&r=0", "Meldingen", "Er is een nieuwe melding binnen gekomen", 3000, "x")
            elseif data.job == "mechanic" then
                TriggerClientEvent("phone:notification", v.User.Source, "https://th.bing.com/th/id/OIP.mLCC_lZviNZQvlERKx4aaAHaG8?pid=ImgDet&rs=1", "Meldingen", "Er is een nieuwe melding binnen gekomen", 3000, "x")
            end
            TriggerClientEvent("InteractSound_CL:PlayOnOne", v.User.Source, "polalert", 0.005)
        end
    end
end)


--[[
    <- sv naar cl set calling source
    <- sv naar cl set being called to target

    >- cl sv accept call

    <- sv cl accepted (in call status + time)

    >- cancel call > disconnect
]]

calling = {}
callid = 1000

RegisterServerEvent("Zero:Server-Phone:CallUser")
AddEventHandler("Zero:Server-Phone:CallUser", function(number)
    local src = source
    if (SQL_Phone_DB:get(number)) then
        local Citizenid = SQL_Phone_DB:get(number)['citizenid']
        local srcPlayer = Zero.Functions.Player(src)
        local Player = Zero.Functions.PlayerByCitizenid(Citizenid)

        if Player then
            calling[src] = Citizenid
            calling[Player.User.Source] = srcPlayer.User.Citizenid

            TriggerClientEvent("Zero:Client-Phone:SetCalling", src, Player)
            TriggerClientEvent("Zero:Client-Phone:BeingCalled", Player.User.Source, srcPlayer)
        else
            TriggerClientEvent("phone:notification", src, "https://i2.wp.com/iaccessibility.net/wp-content/uploads/2016/09/2013-08-26_09-38-25__Phone_iOS7_App_Icon_Rounded.png?fit=1024%2C1024&ssl=1", "Bellen", "Speler niet bereikbaar", 3000, "")
        end
    end
end)

RegisterServerEvent("Zero:Server-Phone:cancelCalling")
AddEventHandler("Zero:Server-Phone:cancelCalling", function()
    local src = source
    local Player = Zero.Functions.PlayerByCitizenid(calling[src])

    TriggerClientEvent("Zero:Client-Phone:cancelCalling", src)
    TriggerClientEvent("Zero:Client-Phone:cancelCalling", Player.User.Source)
end)

RegisterServerEvent("Zero:Server-Phone:denyCall")
AddEventHandler("Zero:Server-Phone:denyCall", function()
    local src = source
    local Player = Zero.Functions.PlayerByCitizenid(calling[src])

    TriggerClientEvent("Zero:Client-Phone:cancelCalling", src)
    TriggerClientEvent("Zero:Client-Phone:cancelCalling", Player.User.Source)
end)


RegisterServerEvent("Zero:Server-Phone:acceptCall")
AddEventHandler("Zero:Server-Phone:acceptCall", function()
    local src = source
    local srcPlayer = Zero.Functions.Player(src)
    local Player = Zero.Functions.PlayerByCitizenid(calling[src])

    callid = callid + 1

    TriggerClientEvent("Zero:Client-Phone:AcceptedCall", src, Player, callid)
    TriggerClientEvent("Zero:Client-Phone:AcceptedCall", Player.User.Source, srcPlayer, callid)
end)    

RegisterServerEvent("Zero:Server-Phone:CancelCurrentCall")
AddEventHandler("Zero:Server-Phone:CancelCurrentCall", function()
    local src = source
    local srcPlayer = Zero.Functions.Player(src)
    local Player = Zero.Functions.PlayerByCitizenid(calling[src])


    TriggerClientEvent("Zero:Client-Phone:CancelCurrentCall", src)
    TriggerClientEvent("Zero:Client-Phone:CancelCurrentCall", Player.User.Source)
end)  



-- NEW CALLING SYSTEM
local calls = {}
calls.players = {}
calls.Callid = 1000

RegisterServerEvent("Zero:Server-Phone:DenyCaller")
AddEventHandler("Zero:Server-Phone:DenyCaller", function(number)
    local src = source
    local number = number

    local Citizenid = SQL_Phone_DB:get(number)['citizenid']
    local Player = Zero.Functions.PlayerByCitizenid(Citizenid)

    calls.players[src] = nil


    if Player then
        calls.players[Player.User.Source] = nil
        TriggerClientEvent("Zero:Client-Phone:CallDenied", Player.User.Source)
    end
end)

RegisterServerEvent("Zero:Server-Phone:CancelOngoingCall")
AddEventHandler("Zero:Server-Phone:CancelOngoingCall", function(number)
    local src = source
    local number = number
    local src_number = Phone.Players[src].Number

    local Citizenid = SQL_Phone_DB:get(number)['citizenid']
    local Player = Zero.Functions.PlayerByCitizenid(Citizenid)

    TriggerClientEvent("Zero:Client-Phone:CurrentCallCanceled", src, number)
    TriggerClientEvent("Zero:Client-Phone:CurrentCallCanceled", Player.User.Source, src_number)
end)

RegisterServerEvent("Zero:Server-Phone:CancelAllCall")
AddEventHandler("Zero:Server-Phone:CancelAllCall", function()
    local src = source
    calls.players[src] = nil
end)

RegisterServerEvent("Zero:Server-Phone:CancelCallingPerson")
AddEventHandler("Zero:Server-Phone:CancelCallingPerson", function(number)
    local src = source
    local number = number
    local src_number = Phone.Players[src].Number

    local Citizenid = SQL_Phone_DB:get(number)['citizenid']
    local Player = Zero.Functions.PlayerByCitizenid(Citizenid)

    TriggerClientEvent("Zero:Client-Phone:CallCancelledByCaller", src)
    TriggerClientEvent("Zero:Client-Phone:CallCancelledByCaller", Player.User.Source)
end)

RegisterServerEvent("Zero:Server-Phone:AcceptCaller")
AddEventHandler("Zero:Server-Phone:AcceptCaller", function(number)
    local src = source
    local number = number
    local src_number = Phone.Players[src].Number

    local Citizenid = SQL_Phone_DB:get(number)['citizenid']
    local Player = Zero.Functions.PlayerByCitizenid(Citizenid)

    calls.Callid = calls.Callid + 1

    TriggerClientEvent("Zero:Client-Phone:AcceptedCallEvent", src, number, calls.Callid)
    TriggerClientEvent("Zero:Client-Phone:AcceptedCallEvent", Player.User.Source, src_number, calls.Callid)
end)

Zero.Functions.CreateCallback('Zero:Server-Phone:StartCall', function(source, cb, number)
    local src = source
    local number = number
    local src_number = Phone.Players[src].Number

    if number then
        local Citizenid = SQL_Phone_DB:get(number)['citizenid']
        local Player = Zero.Functions.PlayerByCitizenid(Citizenid)

        if (Player) then
            if not (calls.players[Player.User.Source]) then
                TriggerClientEvent("Zero:Client-Phone:BeingCalled", Player.User.Source, src_number)

                calls.players[src] = true -- player is calling someone
                calls.players[Player.User.Source] = true -- player is being called
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

RegisterServerEvent("Zero:Server-Phone:DutyToggle")
AddEventHandler("Zero:Server-Phone:DutyToggle", function()
    local src = source
    local Player = Zero.Functions.Player(src)

    local duty = Player.Job.duty
    duty = not duty

    Player.Functions.SetDuty(duty)

    if duty then
        Player.Functions.Notification("Baan", "Je bent nu in dienst")
    else
        Player.Functions.Notification("Baan", "Je bent nu uit dienst", "error")
        TriggerEvent("dispatch:remove", src)
    end
end)