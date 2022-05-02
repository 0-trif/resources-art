exports("notification", function(title, message, type, time)
    local title = title ~= nil and title or nil
    local message = message ~= nil and message or nil
    local type = type ~= nil and type or "success"
    local time = time ~= nil and time or 3000
	
	if title == nil or message == nil then return end

    SendNUIMessage({action = 'notification', data = {
        title = title, 
        message = message,
        type = type,
        time = time,
    }})
end)

RegisterNetEvent("Zero-notifications:client:alert")
AddEventHandler("Zero-notifications:client:alert", function(title, message, type, time)
    exports['zero-notify']:notification(title, message, type, time)
end)

RegisterNetEvent("Zero:Client-Core:MoneyAltered")
AddEventHandler("Zero:Client-Core:MoneyAltered", function(type, bool, amount, reason, extraData)
    if (type == "cash" or type == "black") then
        SendNUIMessage({action = 'moneyNote', data = {
            bool = bool,
            amount = amount,
        }})
    elseif (type == "bank") then
        local extraData = extraData or {}
    
        local reason = extraData.title ~= nil and extraData.title or reason
        if (bool) then
            message = "Er is €"..amount.." op uw account bijgeschreven, " .. reason
        else
            message = "Er is €"..amount.." van uw account af gehaald, " .. reason
        end

        TriggerEvent("phone:notification", "https://cdn4.iconfinder.com/data/icons/logos-and-brands/512/250_Paypal_logo-512.png", "PayPal", message, 5000)
    end
end)
