exports['zero-core']:object(function(O) Zero = O end)

toggleAllControls = 0

RegisterNetEvent("Zero:Client-Core:Spawned")
AddEventHandler("Zero:Client-Core:Spawned", function()
    Zero.Vars.Spawned = true
end)

RegisterNetEvent("Zero:Client-Core:UpdateStats")
AddEventHandler("Zero:Client-Core:UpdateStats", function(PlayerData)
    Zero.Player = PlayerData
    SetupPhoneApps()
    SetupPhoneSettings()
end)

RegisterNetEvent("Zero:Server-Phone:Chats")
AddEventHandler("Zero:Server-Phone:Chats", function(Chats)
    SetupPhoneChats(Chats)
end)

RegisterKeyMapping('phone', 'Open phone', 'keyboard', 'M')
RegisterCommand("phone", function()
    if Zero.Functions.HasItem('phone') and toggleAllControls <= 0 then
        togglePhone()
    end
end)


RegisterNetEvent("Zero:Client-Core:MoneyAltered")
AddEventHandler("Zero:Client-Core:MoneyAltered", function(type, bool, amount, reason, extraData)
    if (type == "bank") then
        
        extraData = extraData ~= nil and extraData or {}
        extraData.title = extraData.title ~= nil and extraData.title or "Onbekend"
        extraData.subtitle = extraData.subtitle ~= nil and extraData.subtitle or reason
        extraData.icon = extraData.icon ~= nil and extraData.icon or 'https://raceyaya.com/public/images/paypal.png'

        AddBankActivity(bool, amount, extraData)
    end
end)

RegisterNetEvent("Zero:Client-Phone:AddMail")
AddEventHandler("Zero:Client-Phone:AddMail", function(name, title, text, location, icon)
    SendNUIMessage({
        action = "mail",
        name = name,
        title = title,
        text = text,
        location = location,
        icon = icon
    })
end)

RegisterNetEvent("Zero:Client-Phone:PayPalContact")
AddEventHandler("Zero:Client-Phone:PayPalContact", function(AccountData)
    AddPayPalContact(AccountData)
end)

RegisterNetEvent("Zero:Client-Phone:AddMessage")
AddEventHandler("Zero:Client-Phone:AddMessage", function(index, messageData)
    AddMessage(index, messageData)
end)

RegisterNetEvent("Zero:Server-Phone:Settings")
AddEventHandler("Zero:Server-Phone:Settings", function(PhoneData)
    Config.Vars.PhoneData = PhoneData
    
    SetupPhoneData()
    SetupPhoneApps()
    SetupPhoneSettings()

    SetupPhoneContacts()
end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    
    Zero.Vars.PhoneLoaded = false
     
    while not Zero.Vars.Spawned do Wait(0) end

    Zero.Functions.GetPlayerData(function(PlayerData)

        Zero.Player = PlayerData
        
        TriggerServerEvent("Zero:Server-Phone:Settings")

        Citizen.Wait(1000)

        TriggerServerEvent("Zero:Server-Phone:TwitterSettings")

        Zero.Vars.PhoneLoaded = true
    end)
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)

        if (Config.Vars.Toggle) then
            DisableControlAction(0, Zero.Config.Keys["LEFTCTRL"], true)
            DisableControlAction(0, Zero.Config.Keys["V"], true)
            
            if toggleAllControls <= 0 then
                DisableControlAction(0, 1, true) -- Attack
                DisableControlAction(0, 2, true) -- Attack 2
                DisableControlAction(0, 4, true) -- Aim
                DisableControlAction(0, 6, true) -- Melee Attack 1
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 25, true) -- Aim
                DisableControlAction(0, 263, true) -- Melee Attack 1

                DisableControlAction(0, 199, true) -- Melee Attack 1
                DisableControlAction(0, 200, true) -- Melee Attack 1

                DisableControlAction(0, 45, true) -- Reload
                DisableControlAction(0, 21, true) -- left shift
                DisableControlAction(0, 22, true) -- Jump
                DisableControlAction(0, 44, true) -- Cover
                DisableControlAction(0, 37, true) -- Select Weapon

                DisableControlAction(0, 288,  true) -- Disable phone
                DisableControlAction(0, 245,  true) -- Disable chat
                DisableControlAction(0, 37, true) -- Inventory
                DisableControlAction(0, 170, true) -- Animations
                DisableControlAction(0, 167, true) -- Job
                DisableControlAction(0, 303, true) -- Car lock

                DisableControlAction(0, 29, true) -- B ile işaret
                DisableControlAction(0, 81, true) -- B ile işaret
                DisableControlAction(0, 26, true) -- Disable looking behind
                DisableControlAction(0, 73, true) -- Disable clearing animation
                DisableControlAction(2, 199, true) -- Disable pause screen
            else
                DisableAllControlActions(0)
            end
        else
            Citizen.Wait(250)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        toggleAllControls = toggleAllControls - 1 >= 0 and toggleAllControls - 1 or 0 
        Citizen.Wait(1000)
    end
end)


-- TWITTER
twitter_accounts = {}
twitter_myid = ""
twitter_messages = {}

RegisterNetEvent('Zero:Client-Phone:TwitterSettings')
AddEventHandler('Zero:Client-Phone:TwitterSettings', function(twitter, name)
    my_nickname = twitter.name
    my_avatar = twitter.avatar

    SendNUIMessage({
        action = "twitterSettings",
        name = my_nickname,
        avatar = my_avatar,
        rpname = name,
    })
end)

RegisterNUICallback("sendTwitterMessage", function(e)
    TriggerServerEvent("Zero:Server:SendTwitterMessage", e.message, e.type)
end)

RegisterNUICallback("SortOnName", function(e, cb)
    local _ = {}

    for k,v in pairs(twitter_messages) do

    
        if string.find(v.message, '@'..my_nickname..'') then
            table.insert(_, v)
        end
    end

    table.sort(_, function(a,b)
        return a.date > b.date
    end)

    cb(_)
end)

RegisterNUICallback("sortTwitterMessages", function(e, cb)
    local x = e.x

    local _ = {}
    for k,v in pairs(twitter_messages) do
        if string.find(v.message, x) or string.find(v.name, x) or string.find(v.nickname, x) then
            table.insert(_, v)
        end
    end

    table.sort(_, function(a,b)
        return a.date > b.date
    end)

    cb(_)
end)

RegisterNUICallback("setTwitterSettings", function(e)
    TriggerServerEvent("Zero:Server:Settings", e)
end)

RegisterNetEvent("Zero:Client-Phone:TwitterMessages")
AddEventHandler("Zero:Client-Phone:TwitterMessages", function(msg)

    table.sort(msg, function(a,b)
        return a.date > b.date
    end)

    twitter_messages = msg

    SendNUIMessage({
        action = "updateMessages",
        messages = msg,
    })
end)


-- calling 
notifications = {}
notification_index = 0 

RegisterNUICallback("removeNotificationIndex", function(ui)
    local index = ui['index']
    notifications[index] = nil

    Citizen.Wait(1000)

    if (countI(notifications) == 0) then
        SendNUIMessage({
            action = "togglePhone",
            bool = Config.Vars.Toggle,
        })
    end
end)


function countI(x)
    local c = 0
    for k,v in pairs(x) do
        c = c + 1
    end
    return c
end

RegisterNetEvent("phone:notification")
AddEventHandler("phone:notification", function(icon, title, subtitle, time, ignoreApp)
    if Config.Vars.PhoneData then
        if not Config.Vars.PhoneData.airplanemode then

            if (Zero.Functions.HasItem('phone')) then
                while (countI(notifications) >= 2) do
                    Wait(0)
                end


                notification_index = notification_index + 1


                SendNUIMessage({
                    action = "enableNotification",
                    icon = icon,
                    title = title,
                    subtitle = subtitle,
                    time = time or 3000,
                    ignoreApp = ignoreApp or "huts",
                    index = notification_index,
                })


                notifications[notification_index] = true
            end
        end
    end
end)

RegisterNetEvent("Zero:Client-Phone:cancelCalling")
AddEventHandler("Zero:Client-Phone:cancelCalling", function()
    SendNUIMessage({
        action = "disableNotification",
    })
end)

RegisterNetEvent("Zero:Client-Phone:SetCalling")
AddEventHandler("Zero:Client-Phone:SetCalling", function(Player)
    SendNUIMessage({
        action = "fadeIn",
        type = "calling-person",
    })

    SendNUIMessage({
        action = "enableNotification",
        icon = "https://i2.wp.com/iaccessibility.net/wp-content/uploads/2016/09/2013-08-26_09-38-25__Phone_iOS7_App_Icon_Rounded.png?fit=1024%2C1024&ssl=1",
        title = Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname,
        subtitle = "Bellen..",
        time = nil,
    })

    -- connect to a index for voip
end)

--[[
    RegisterNetEvent("Zero:Client-Phone:BeingCalled")
AddEventHandler("Zero:Client-Phone:BeingCalled", function(Player)
    SendNUIMessage({
        action = "fadeIn",
        type = "being-called",
    })
    

    SendNUIMessage({
        action = "enableNotification",
        icon = "https://i2.wp.com/iaccessibility.net/wp-content/uploads/2016/09/2013-08-26_09-38-25__Phone_iOS7_App_Icon_Rounded.png?fit=1024%2C1024&ssl=1",
        title = Player.PlayerData.firstname .. " " .. Player.PlayerData.lastname,
        subtitle = "Gesprek gestart..",
        time = nil,
    })

    -- connect to a index for voip
end)
]]

person_in_call = false
Citizen.CreateThread(function()
    while true do

        if person_in_call then  
            second = second+1

            if second == 60 then
                second = 0
                minute = minute + 1
            end

            if (minute < 10) then
                minute_string = "0"..minute..""
            else 
                minute_string = minute
            end
            if (second < 10) then
                second_string = "0"..second..""
            else
                second_string = second
            end

            string_ = minute_string .. ":" .. second_string .. " - Verbonden"

            SendNUIMessage({
                action = "updateCallTime",
                time = string_
            })
        end

        if (Config.Vars.Toggle) then
            local hours = GetClockHours()
            local minutes = GetClockMinutes()
            if minutes <= 9 then
                minutes = '0' .. minutes
            end
            if hours <= 9 then
                hours = '0' .. hours
            end
            SendNUIMessage({
                action = "time",
                time = hours .. ":" .. minutes
            })
        end

        Wait(1000)
    end
end)

