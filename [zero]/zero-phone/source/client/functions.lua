function SetupPhoneApps()
    Citizen.Wait(1000)

    local Apps = {}

    for k,v in pairs(Config.Apps) do
        if v.job then
            if Zero.Player.Job.name == v.job then
                table.insert(Apps, v)
            end
        else
            table.insert(Apps, v)
        end
    end

    SendNUIMessage({
        action = "hotbar",
        apps = Config.BottomApps,
    })

    SendNUIMessage({
        action = "apps",
        apps = Apps,
    })
end

function togglePhone()
    local isdead = Zero.Functions.GetPlayerData().MetaData.dead

    if isdead then return end

    Config.Vars.Toggle = not Config.Vars.Toggle

    SendNUIMessage({
        action = "togglePhone",
        bool = Config.Vars.Toggle,
    })

    
    SetNuiFocus(Config.Vars.Toggle, Config.Vars.Toggle)
    SetNuiFocusKeepInput(Config.Vars.Toggle)
    
    UpdatePlayerVehicles()
end

RegisterNetEvent('Zero:Client-Phone:Toggle')
AddEventHandler("Zero:Client-Phone:Toggle", function()
    togglePhone()
    TriggerEvent("inventory:client:close")
end)

function SetupPhoneSettings()
    Zero.Functions.GetPlayerData(function(PlayerData)
        PlayerData.Job.label = Zero.Config.Jobs[PlayerData.Job.name]['label']
        SendNUIMessage({
            action = "PlayerData",
            playerdata = PlayerData
        })
    end)
end

function SetupPhoneData()
    SendNUIMessage({
        action = "PhoneData",
        phonedata = Config.Vars.PhoneData
    })
end

function AddBankActivity(bool, amount, extra)
    moneyString = bool == true and "+ "..amount.."" or "- "..amount..""

    SendNUIMessage({
        action = "paypal-activity",
        data = {
            amount = moneyString,
            title = extra.title,
            subtitle = extra.subtitle,
            icon = extra.icon,
        }
    })
end

PayPalContacts = {}
function AddPayPalContact(Data)
    if (PayPalContacts[Data.tag]) then return end
    PayPalContacts[Data.tag] = Data
    SendNUIMessage({
        action = "PayPalContacts",
        PayPalContacts = PayPalContacts,
    })
end

function SetupPhoneContacts()
    local _ = {}

    for k,v in pairs(Config.Vars.PhoneData.Contacts) do
        local first_char = string.upper(v.firstname:sub(1, 1) )

        _[first_char] = _[first_char] ~= nil and _[first_char] or {}

        table.insert(_[first_char], v)
    end

    SendNUIMessage({
        action = "contacts",
        contacts = _,
    })
end

function AddMessage(index, Data)
    SendNUIMessage({
        action = "addMessage",
        index = index,
        data = Data,
    })
end

function SetupPhoneChats(chats)
    table.sort(chats, function(a,b) return tonumber(a.date) < tonumber(b.date) end)
    SendNUIMessage({
        action = "Chats",
        chats = chats,
    })
end

function UpdatePlayerVehicles()
    local PlayerVehicles = Zero.Functions.GetPlayerVehicles()

    for k,v in pairs(PlayerVehicles) do
        local data = exports['zero-dealership']:GetVehicleData(v.model)
        v.fuel = v.fuel or 100
        
        v.label = data.label
        v.price = "€" .. data.price
        v.fuel  = math.ceil(v.fuel) .. "%"
    end


    SendNUIMessage({
        action = "PlayerVehicles",
        vehicles = PlayerVehicles,
    })
end