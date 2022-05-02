local blips = {}

function RefreshBlips()
    RemoveBlips()

    for k,v in pairs(config.locations) do    
        if v.enabled then
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(blip, 492)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.65)
            SetBlipAsShortRange(blip, true)
            SetBlipColour(blip, 84)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Woning")
            
            EndTextCommandSetBlipName(blip)
            table.insert(blips, blip)
        end
    end
end

function RemoveBlips()
    for k,v in pairs(blips) do
        RemoveBlip(v)
    end
    blips = {}
end

function UseDoorlock(index)
    local level = config.locations[index]['level']
    local amount = 5 * level

    ExecuteCommand("e pull")
    for i = 1, amount do
        local task = exports['zero-skill']:skill("Deur openbreken ("..i.."/"..amount..")", math.random(5000, 10000))

        if (task) then
            if i == amount then
                Zero.Functions.Notification('Lockpick', 'Deur geopend', 'success')
                TriggerServerEvent("Zero:Server-Houserobbery:Unlock", index)
                PoliceAlert()
                ExecuteCommand("e c")
            end
        else
            ExecuteCommand("e c")
            Zero.Functions.Notification('Lockpick', 'Mislukt', 'error')
            break
        end
    end
end

interiors = {}
function ClearInteriors()
    for k,v in pairs(interiors) do
        DeleteObject(v)
    end

    if safeObject then
        DeleteObject(safeObject)
        safeObject = nil
    end

    interiors = {}
end

function CreateInterior(model, x, y, z)
    local model = GetHashKey(model)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    RequestCollisionForModel(model)
    while not HasCollisionForModelLoaded(model) do
        Wait(10)
    end

    local house = CreateObject(model, x, y, z, false, false, false)
    FreezeEntityPosition(house, true)
    SetModelAsNoLongerNeeded(model)

    return house
end

function LeaveBuilding()
    local x,y,z = config.locations[config.vars.insideIndex].x, config.locations[config.vars.insideIndex].y, config.locations[config.vars.insideIndex].z
    TriggerEvent("InteractSound_CL:PlayOnOne", "DoorClose", 0.2)

    DoScreenFadeOut(150)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    TriggerEvent("Zero-weathersync:client:EnableSync")

    SetEntityCoords(PlayerPedId(), x, y, z)
    Wait(1000)
    DoScreenFadeIn(150)

    config.vars.insideIndex = nil 
    config.vars.inside = false

    ClearInteriors()
end

function EnterHouse(index)
    if not index then return end

    local level = config.locations[index]['level']
    local model = config.data[level]['interior']
    local x,y,z = config.locations[index]['x'], config.locations[index]['y'], config.locations[index]['z'] - 50.0

    local house = CreateInterior(model, x, y, z)

    local entrance = config.data[level]['exit']
    config.vars.exit = GetOffsetFromEntityInWorldCoords(house, entrance.x, entrance.y, entrance.z)

    DoScreenFadeOut(150)

    while not IsScreenFadedOut() do
        Wait(0)
    end
    TriggerEvent("Zero-weathersync:client:DisableSync")
    TriggerEvent("InteractSound_CL:PlayOnOne", "door", 0.2)

    SetEntityCoords(PlayerPedId(), config.vars.exit.x, config.vars.exit.y, config.vars.exit.z)
    SetEntityHeading(PlayerPedId(), entrance.h)

    Wait(1000)

    DoScreenFadeIn(150)
    
    table.insert(interiors, config.vars.house)
    config.vars.house = house
    config.vars.insideIndex = index 
    config.vars.inside = true
end

function PoliceAlert()
    local location = GetEntityCoords(PlayerPedId())
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, location.x, location.y, location.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    streetname = street1 .. ", " .. street2

    TriggerServerEvent("dispatch:public", {"police", "kmar"}, {
        taggs = {
            [1] = {
                name = "10-65",
                color = "#373636",
            },
        },
        title = "Woning inbraak",
        info = {
            [1] = {
                icon = '<i class="fa-solid fa-map-location"></i>',
                text = "Straat: " .. streetname,
            },
            [2] = {
                icon = '<i class="fa-solid fa-clock"></i>',
                text = "Tijd: paar seconden geleden",
            },
            [3] = {
                icon = '<i class="fa-solid fa-bell"></i>',
                text = "Melding: woning inbraak bezig.",
            },
        },
        type = "error",
        location = GetEntityCoords(PlayerPedId())
    })
end

function SearchIndex(index)
    if config.vars.insideIndex then
        ExecuteCommand("e mechanic3")

        Zero.Functions.Progressbar("search_x", "Bezig met zoeken..", 6000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {

        }, {}, {}, function() -- Done
            ExecuteCommand('e c')
            TriggerServerEvent("Zero:Server-Houserobbery:SearchedSpot", config.vars.insideIndex, index)

            if not givenNote then
                local random = math.random(0, 400)
                if (random > 190 and random < 197) then
                    TriggerServerEvent('Zero:Server-Houserobbery:NoteCode', config.vars.insideIndex)
                    givenNote = true
                end
            end
        end, function() -- Cancel
            ExecuteCommand('e c')
        end)
    end
end

function CreateSafe(x, y, z, h)
    givenNote = false

    local model = GetHashKey('prop_ld_int_safe_01')

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local object = CreateObject(model, x, y, z, false, false, false)
    FreezeEntityPosition(object, true)
    SetEntityHeading(object, h)

    return object
end