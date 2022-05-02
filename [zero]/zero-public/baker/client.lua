local locations = {
    ['inventory'] = {x = 812.49835205078, y = -754.83715820313, z = 26.780843734741,h = 183.3109588623},
    ['furnace'] = {x = 813.31237792969, y = -752.89459228516, z = 26.780847549438,h = 282.36883544922},
}

local CurrentOrderLocation
local last_point_chef

RegisterNetEvent("StartJob")
AddEventHandler("StartJob", function(playerJob)
    if (playerJob == "chef") then
        if not CurrentOrderLocation then
            CreateNewOrder()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local location = Config.Locations['chef']

        if GlobalJob and GlobalJob == "chef" then
            local ply = PlayerPedId()
            local position = GetEntityCoords(ply)

            local renderDistance = #(location - position)

            if (renderDistance <= 50) then
                timer = 0

                local distance_inventory = #(position - vector3(locations.inventory.x, locations.inventory.y, locations.inventory.z))
                if distance_inventory <= 1 then
                    Zero.Functions.DrawText(locations.inventory.x, locations.inventory.y, locations.inventory.z, "~g~E~w~ - Ingredienten")

                    if IsControlJustPressed(0, Zero.Config.Keys['E']) then
                        openIngredients()
                    end
                end

                local distance_furnace = #(position - vector3(locations.furnace.x, locations.furnace.y, locations.furnace.z))
                if distance_furnace <= 1 then
                    Zero.Functions.DrawText(locations.furnace.x, locations.furnace.y, locations.furnace.z, "~g~E~w~ - Oven")

                    if IsControlJustPressed(0, Zero.Config.Keys['E']) then
                        openFurance()
                    end
                end
            end 
        end

        Citizen.Wait(timer)
    end
end)

function openIngredients()
    TriggerEvent("inventory:client:toggle")
    exports['zero-inventory']:shop({
        action = "create_shop",
        items = Config.Jobs.chef.Ingredients,
        extra = {},
        event = "Zero:Server-Public:GrabItemchef",
        slots = #Config.Jobs.chef.Ingredients,
        label = "Ingredienten",
    })
end

function openFurance()
    TriggerEvent("Zero:Client-Inventory:CustomCrafting", Config.Jobs.chef.Craftables, "Zero:Server-Public:CraftFoodItem")
end

Citizen.CreateThread(function()
    exports['vehicleHire']:createHirePoint(793.06951904297, -754.83465576172, 26.841779708862, 87.518356323242, {
        [1] = {
            label = "Scooter",
            model = 'faggio3',
            price = 150,
            loc = {x = 786.97412109375, y = -759.58203125, z = 26.555265426636,h = 177.39553833008},
        },
    }, "s_m_m_migrant_01")
end)

local delivery_points = {
    {x = 198.42237854004, y = -1276.7043457031, z = 29.325057983398,h = 259.58734130859},
    {x = 278.82357788086, y = -1118.2260742188, z = 29.419662475586,h = 174.53799438477},
    {x = 418.51837158203, y = -767.54382324219, z = 29.429534912109,h = 73.202796936035},
    {x = 281.99377441406, y = -1694.7783203125, z = 29.647914886475,h = 54.657958984375},
    {x = 781.19897460938, y = -1278.6142578125, z = 26.881353378296,h = 267.50091552734},
    {x = 1229.4407958984, y = -725.34643554688, z = 60.955726623535,h = 102.80725097656},
    {x = 773.75134277344, y = -150.00550842285, z = 75.621887207031,h = 127.36280059814},
    {x = -472.1701965332, y = -18.356983184814, z = 45.758365631104,h = 357.98959350586},
    {x = -1230.0137939453, y = -285.78170776367, z = 37.734252929688,h = 223.40748596191},
    {x = -638.69787597656, y = -1249.7509765625, z = 11.810454368591,h = 171.03207397461},
    {x = 868.68872070313, y = -1629.1948242188, z = 30.248971939087,h = 93.390922546387},
    {x = -1426.1040039063, y = -99.332695007324, z = 51.782627105713,h = 21.924491882324}
}

function CreateNewCoord()
    while true do
        local random = math.random(1, #delivery_points)

        if (random ~= last_point_chef) then
            last_point_chef = random
            return delivery_points[last_point_chef]
        end

        Wait(0)
    end
end


function CreateNewOrder()
    local coord = CreateNewCoord()
    CurrentOrderLocation = coord
    createchefMailLocation(CurrentOrderLocation)
end

function createchefMailLocation(CurrentOrderLocation)
    local items = Config.Jobs.chef.Requests
    local random = math.random(1, 4)

    local order = {}

    for i = 1, random do
        local item = items[math.random(1, #items)]
        order[item] = order[item] ~= nil and order[item] + 1 or 1
    end

    local config = exports['zero-inventory']:config()

    local order_text = "Bestelling:"
    for k,v in pairs(order) do
        order_text = order_text .. "<br> "..config.items[k]['label']..": "..v.."x"
    end

    CurrentOrderItems = order

    TriggerEvent("phone:notification", "./images/logos/chef.png", "Nieuwe bestelling", "Er is zojuist een nieuwe bestelling gemaakt die moet worden afgeleverd.", 5000) 
    TriggerEvent("Zero:Client-Phone:AddMail", "Nieuwe klant (bestelling)", "Nieuwe bestelling en aflever locatie", "Hallo, <br><br> Hieronder staat een lijst met gerechten die zojuist besteld zijn en een locatie om het te bezorgen <br><br> "..order_text.."", CurrentOrderLocation, "./images/logos/chef.png")
end

function createchefNPC(x,y,z,h)
    local models = {
        "s_m_m_migrant_01"
    }

    local model = models[math.random(1, #models)]
    local hash = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    local ped = CreatePed(12, hash, x, y, z - 1, h, false, false)
    FreezeEntityPosition(ped, true)
    SetPedCanBeTargetted(ped, false)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    SetPedAlertness(ped, 0)
    SetEntityInvincible(ped, true)
    SetPedComponentVariation(ped, 0, 0, 0, 2)

    return ped
end

function FinishOrder()
    TriggerServerEvent("Zero:Server-Public:FinishOrder", CurrentOrderItems)
    
    CurrentOrderLocation = nil
    CurrentOrderItems = nil
    SetPedAsNoLongerNeeded(sellNpcchef)
    FreezeEntityPosition(sellNpcchef, false)
    sellNpcchef = nil
end

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("delivery-job", function(coords, entity)
        local player = PlayerPedId()
        local plyc = GetEntityCoords(player)

        if entity and IsEntityAPed(entity) and sellNpcchef then
            if (entity == sellNpcchef) then
                return true, GetEntityCoords(sellNpcchef)
            end
        end
    end, {
       [1] = {
           name = "Bestelling afgeven",
           action = function()
                FinishOrder()
           end
       },
    }, GetCurrentResourceName(), 5)

    while true do
        if CurrentOrderLocation then
            local ply = PlayerPedId()
            local pos = GetEntityCoords(ply)

            local distance = #(pos - vector3(CurrentOrderLocation.x, CurrentOrderLocation.y, CurrentOrderLocation.z))

            if distance <= 20 then
                if not DoesEntityExist(sellNpcchef) then
                    sellNpcchef = createchefNPC(CurrentOrderLocation.x, CurrentOrderLocation.y, CurrentOrderLocation.z, CurrentOrderLocation.h)
                end
            end
        else
            Citizen.Wait(750)
        end
        
        Citizen.Wait(0)
    end
end)