drops = {}

Citizen.CreateThread(function()
    show_item_names = false

    while true do
        local ply = GetPlayerPed(-1)
        local pos = GetEntityCoords(ply)

        close_items = false

        for k,v in pairs(drops) do
            local distance  = #(vector3(v.loc.x, v.loc.y, v.loc.z) - vector3(pos.x, pos.y, pos.z))


            if (distance <= 5) then
                close_items = true
                DrawMarker(2, v.loc.x, v.loc.y, v.loc.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 23, 238, 130, 130, false, true, false, false, false, false, false)
            end
        end
        if not close_items then
            Citizen.Wait(750)
        else
            Citizen.Wait(1)
        end
    end
end)

calculate_drops_in_area = function(location)
    local _ = {}
    for k, v in pairs(drops) do 
        local distance = #(vector3(location.x, location.y, location.z) - vector3(v.loc.x, v.loc.y, v.loc.z))
        if (distance <= 5) then
            table.insert(_, v)
        end
    end
    return _
end

generate_label = function(loc)
    local label = "x: "..string.format("%.2f", loc.x).." y: "..string.format("%.2f", loc.y).." z: "..string.format("%.2f", loc.z)..""
    return label
end

open_drops_inventory = function() 
    local location   = GetEntityCoords(GetPlayerPed(-1))
    local drops_area = calculate_drops_in_area(location)

    SendNUIMessage({
        action = "set_other",
        data   = {
            event = "inventory:server:drops",
            items = drops_area,
            extra = {drops = calculate_drops_in_area(location), location = location},
            label = generate_label(location),
            slots = 16,
        }
    })
    opened_ground = true
end

-- event
RegisterNetEvent("inventory:client:syncDrops")
AddEventHandler("inventory:client:syncDrops", function(x)
    drops = x

    if opened_ground then
        local location   = GetEntityCoords(GetPlayerPed(-1))
        local drops_area = calculate_drops_in_area(location)

        SendNUIMessage({
            action = "set_other",
            data   = {
                event = "inventory:server:drops",
                items = drops_area,
                extra = {drops = calculate_drops_in_area(location), location = location},
                label = generate_label(location),
                slots = 16,
            }
        })
    end
end)


debugss = function(obj, depth)
	local resource = GetCurrentResourceName()
	
    print("\x1b[4m\x1b[36m["..resource..":DEBUG]\x1b[0m")
    if type(obj) == "string" then
        print(string.format("%q", obj))
    elseif type(obj) == "table" then
        local str = "{"
        for k, v in pairs(obj) do
            if type(v) == "table" then
                for ik, iv in pairs(v) do
                    str = str.."\n["..k.."] -> ["..ik.."] -> "..tostring(iv)
                end
            else
                str = str.."\n["..k.."] -> "..tostring(v)
            end
        end
        
        print(str.."\n}")
    else
        local success, value = pcall(function() return tostring(obj) end)
        print((success and value or "<!!error in __tostring metamethod!!>"))
    end
    print("\x1b[4m\x1b[36mEND OF DEBUG\x1b[0m")
end