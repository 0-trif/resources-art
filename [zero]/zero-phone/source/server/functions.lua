
CreateNumber = function()
    local found_number = nil
    while true do
        local number = tostring('06'..math.random(11111111, 99999999)..'')

        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone` WHERE `number` = ?", {
            number,
        }, function(result)
            if not (result[1]) then
                found_number = number
            end
        end)

        if found_number then
            return found_number
        end

        Wait(0)
    end
end

CreatePayPal = function(src) 
    local _ = {}

    local Player = Zero.Functions.Player(src)

    _.tag = "@"..Player.User.Citizenid..""
    _.nickname = Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname
    _.pf = "https://raceyaya.com/public/images/paypal.png"

    return _
end

CreateWhatsapp = function(src) 
    local _ = {}

    local Player = Zero.Functions.Player(src)

    _.firstname = Player.PlayerData.firstname
    _.lastname = Player.PlayerData.lastname


    return _
end

CreateUser = function(src)
    local _ = {}

    local Player = Zero.Functions.Player(src)
    local Citizenid = Player.User.Citizenid

    _.Save = function()
        Zero.Functions.ExecuteSQL(true, "UPDATE `phone` SET `settings` = ?, `phonedata` = ?, `paypal` = ?, `contacts` = ?, `whatsapp` = ?, `twitter` = ? WHERE `citizenid` = ?", {
            json.encode(Phone.Players[src].Settings),
            json.encode(Phone.Players[src].PhoneData),
            json.encode(Phone.Players[src].PayPal),
            json.encode(Phone.Players[src].Contacts),
            json.encode(Phone.Players[src].Whatsapp),
            json.encode(Phone.Players[src].Twitter),
            Citizenid,
        })
    end

    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone` WHERE `citizenid` = ?", {
        Citizenid,
    }, function(result)
        if (result[1]) then
            _.Settings = json.decode(result[1].settings) ~= nil and json.decode(result[1].settings) or {}
            _.PhoneData = json.decode(result[1].phonedata) ~= nil and json.decode(result[1].phonedata) or {}
            _.Contacts = json.decode(result[1].contacts) ~= nil and json.decode(result[1].contacts) or {}
            _.PayPal = json.decode(result[1].paypal) ~= nil and json.decode(result[1].paypal) or {}
            _.Whatsapp = json.decode(result[1].whatsapp) ~= nil and json.decode(result[1].whatsapp) or {}
            _.Twitter = json.decode(result[1].twitter) ~= nil and json.decode(result[1].twitter) or {}
            _.Number = result[1].number
        else
            _.Settings = {}
            _.PhoneData = {
                email = Player.PlayerData.firstname .. '.' .. Player.PlayerData.lastname .. '@gmail.com',
            }
            _.PayPal = CreatePayPal(src)
            _.Number = CreateNumber()
            _.Whatsapp = CreateWhatsapp(src)
            _.Contacts = {}
            _.Twitter = {
                name = Player.PlayerData.firstname .. '.' .. Player.PlayerData.lastname,
                avatar = "",
            }


            Zero.Functions.ExecuteSQL(true, "INSERT INTO `phone` (`citizenid`, `settings`, `phonedata`, `number`, `paypal`, `whatsapp`, `twitter`) VALUES (?, ?, ?, ?, ?, ?, ?)", {
                Citizenid,
                json.encode({}),
                json.encode(_.PhoneData),
                _.Number,
                json.encode(_.PayPal),
                json.encode(_.Whatsapp),
                json.encode(_.Twitter)
            })

            SQL_Phone_DB[_.Number] = {
                whatsapp = _.Whatsapp,
                Citizenid = Citizenid,
            }
        end
    end)

    _.Settings['airplanemode'] = _.Settings['airplanemode'] ~= nil and _.Settings['airplanemode'] or false
    _.Settings['background'] = _.Settings['background'] ~= nil and _.Settings['background'] or Config.DefaultBackground
    
    _.Twitter.avatar = _.Twitter.avatar ~= "" and _.Twitter.avatar or "https://th.bing.com/th/id/OIP.6ooIyw-4R8iLvmcZo7EIsgHaHa?pid=ImgDet&rs=1"
    _.Twitter.name = _.Twitter.name ~= "" and _.Twitter.name or Player.PlayerData.firstname

    _.PhoneData['email'] = _.PhoneData['email'] ~= nil and _.PhoneData['email'] or Player.PlayerData.firstname .. '.' .. Player.PlayerData.lastname .. '@gmail.com'

    return _
end

GetWhatsappData = function(other_number, cb)
    for k,v in pairs(Phone.Players) do
        if (v.Number == other_number) then
            cb(v.Whatsapp)
            return
        end
    end
  
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone` WHERE `number` = ?", {
        other_number,
    },function(result)
        cb(json.decode(result[1].whatsapp))
    end)
end

returned_player = true

SetupWhatsappMessages = function(playerid, cb)
    local src = playerid
    local number = Phone.Players[src].Number

    local chats = {}

    found = nil
    Zero.Functions.ExecuteSQL(true, "SELECT * FROM `phone-messages` WHERE `index` LIKE ?", {
        '%'..number..'%',
    }, function(result)
        found = result
        for k,v in pairs(found) do
            local other_number = v.number_one ~= number and v.number_one or v.number_two
    
            local history = json.decode(v.history)
    
            GetWhatsappData(other_number, function(W)
                
                if W then
                    table.insert(chats, {
                        index = v.index,
                        number = other_number,
                        date = v.date,
                        whatsapp = W,
                        last_message = history[#history] ~= nil and history[#history].message or "Geen berichten"
                    })
                end
            end)
        end
        cb(chats)
    end)
end
