RegisterNUICallback("airplaneMode", function(e, cb)
    TriggerServerEvent("Zero:Server-Phone:AirplaneMode")
end)

RegisterNUICallback("backgroundImage", function(e, cb)
    TriggerServerEvent("Zero:Server-Phone:BackgroundImage", e.image)
end)

RegisterNUICallback("dataPage", function(e, cb)
    TriggerServerEvent("Zero:Server-Phone:DataPage", e.email)
end)

RegisterNUICallback("toggleAllControls", function(e, cb)
    toggleAllControls = 2
end)

RegisterNUICallback("PayPalSettings", function(e, cb)
    TriggerServerEvent("Zero:Server-Phone:PayPalSettings", e)
end)

RegisterNUICallback("GetPayPalAccount", function(e, cb)
    local tag = e.tag

    Zero.Functions.TriggerCallback('Zero:Server-Phone:GetPayPalAccount', function(result)
        cb(result)
    end, tag)
end)

RegisterNUICallback("TransferMoney", function(e, cb)
    local tag = e.tag
    local amount = tonumber(e.amount)
    local reason = e.reason
    
    TriggerServerEvent("Zero:Server-Phone:TransferMoney", tag, amount, reason)
end)

RegisterNUICallback("removeContact", function(e)
    TriggerServerEvent("Zero:Server-Phone:removeContact", e.number)
end)
RegisterNUICallback("addContact", function(e)
    TriggerServerEvent("Zero:Server-Phone:AddContact", e)
end)
RegisterNUICallback("editContact", function(e)
    TriggerServerEvent("Zero:Server-Phone:editContact", e)
end)
RegisterNUICallback("GetContact", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:GetContact', function(result)
        cb(result)
    end, e.number)
end)

RegisterNUICallback("SendMessage", function(e, cb)
    TriggerServerEvent("Zero:Server-Phone:SendMessage", e.number, e.message, e.image)
end)

RegisterNUICallback("SetWhatsappSettings", function(e, cb)
    TriggerServerEvent("Zero:Server-Phone:SetWhatsappSettings", e.pf, e.background)
end)

RegisterNUICallback("GetActiveServices", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:GetActiveServices', function(result)
        cb(result)
    end)
end)

RegisterNUICallback("SearchPlayersMeos", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:SearchPlayersMeos', function(result)
        cb(result)
    end, e.input)
end)

RegisterNUICallback("CreateReport", function(e)
    TriggerServerEvent('Zero:Server-Phone:CreateReport', e)
end)

RegisterNUICallback("CreateDec", function(e)
    TriggerServerEvent('Zero:Server-Phone:CreateDec', e)
end)


RegisterNUICallback("GetPlayerDecs", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:GetPlayerDecs', function(result)
        cb(result)
    end, e.citizenid)
end)

RegisterNUICallback("GetPlayerReports", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:GetPlayerReports', function(result)
        cb(result)
    end, e.citizenid)
end)

RegisterNUICallback("EditReportMeos", function(e)
    TriggerServerEvent('Zero:Server-Phone:EditReport', e)
end)

RegisterNUICallback("EditDecMeos", function(e, cb)
    TriggerServerEvent('Zero:Server-Phone:EditDec', e)
end)

RegisterNUICallback("SearchVehicleMeos", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:SearchVehicleMeos', function(result)
        cb(result)
    end, e.plate)
end)

RegisterNUICallback("GetEmployeesMeos", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:GetEmployeesMeos', function(result)
        cb(result)
    end)
end)

RegisterNUICallback("GetPoliceFines", function(e, cb)
    TriggerEvent("Zero:Client-Police:GetFines", e.string, function(fines)
        cb(fines)
    end)
end)

RegisterNUICallback("GiveFineToPlayer", function(e, cb)
    TriggerServerEvent('Zero:Server-Phone:GiveFineToPlayer', e.citizenid, e.index)
end)

RegisterNUICallback("GetPlayerFines", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:GetPlayerFines', function(result)
        cb(result)
    end, e.citizenid)
end)


RegisterNUICallback("RemoveFineFromPlayer", function(e, cb)
    TriggerServerEvent('Zero:Server-Phone:RemoveFineFromPlayer', e.citizenid, e.index)
end)

RegisterNUICallback("SendSOSmessage", function(e)
    local location = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("Zero:Server-Phone:SendSOSMessage", e, location)
end)

RegisterNUICallback("GetSOSNotifications", function(e, cb)
    Zero.Functions.TriggerCallback('Zero:Server-Phone:GetSOSNotifications', function(result)
        cb(result)
    end)
end)

RegisterNUICallback("SOSsetLocation", function(data)
    local x,y,z = tonumber(data.x) + 0, tonumber(data.y) + 0, tonumber(data.z) + 0
    SetNewWaypoint(x, y)
end)

RegisterNUICallback("PayBill", function(data)
    TriggerServerEvent("Zero:Server-Phone:PayBill", data.index)
end)

-- NEW CALLING SYSTEM
RegisterNUICallback("IsInCall", function(e, cb) 
    if (countI(notifications) > 0) then
        cb(true)
    else
        cb(false)
    end
end)


RegisterNUICallback("StartPhoneCall", function(ui, cb)
    notifications['call'] = true

    calling_person = true

    Zero.Functions.TriggerCallback('Zero:Server-Phone:StartCall', function(valid)
        cb(valid)
    end, ui.number)
end)

RegisterNUICallback("DenyCaller", function(ui, cb)
    TriggerServerEvent("Zero:Server-Phone:DenyCaller", ui.number)
end)

RegisterNUICallback("AcceptCaller", function(ui, cb)
    TriggerServerEvent("Zero:Server-Phone:AcceptCaller", ui.number)
end)

RegisterNUICallback("CancelOngoingCall", function(ui, cb)
    TriggerServerEvent("Zero:Server-Phone:CancelOngoingCall", ui.number)
    calling_person = false
end)

RegisterNUICallback("CancelCallingPerson", function(ui)
    TriggerServerEvent("Zero:Server-Phone:CancelCallingPerson", ui.number)
end)

RegisterNUICallback("RemoveAllCallStatuses", function()
    TriggerServerEvent("Zero:Server-Phone:CancelAllCall")
end)

RegisterNetEvent("Zero:Client-Phone:CallDenied")
AddEventHandler("Zero:Client-Phone:CallDenied", function()
    SendNUIMessage({
        action = "calling:denied",
    })
    calling_person = false
end)

RegisterNetEvent("Zero:Client-Phone:CallCancelledByCaller")
AddEventHandler("Zero:Client-Phone:CallCancelledByCaller", function()
    SendNUIMessage({
        action = "calling:cancelled",
    })
    calling_person = false
end)

RegisterNetEvent("Zero:Client-Phone:BeingCalled")
AddEventHandler("Zero:Client-Phone:BeingCalled", function(number)
    notifications['call'] = true
    SendNUIMessage({
        action = "calling:trigger",
        number = number,
    })
    TriggerEvent("InteractSound_CL:PlayOnOne", "payphoneringing", 0.2)
end)

RegisterNetEvent("Zero:Client-Phone:AcceptedCallEvent")
AddEventHandler("Zero:Client-Phone:AcceptedCallEvent", function(number, channel)
    SendNUIMessage({
        action = "calling:accepted",
        number = number,
    })

    second = 0
    minute = 0
    person_in_call = true
    exports["mumble-voip"]:SetCallChannel(channel)
end)

RegisterNetEvent("Zero:Client-Phone:CurrentCallCanceled")
AddEventHandler("Zero:Client-Phone:CurrentCallCanceled", function(number)
    person_in_call = false
    SendNUIMessage({
        action = "calling:hangup",
        number = number,
    })
    exports["mumble-voip"]:SetCallChannel(0)
    calling_person = false
end)


RegisterNUICallback("toggleDuty", function()
    TriggerServerEvent("Zero:Server-Phone:DutyToggle")
end)