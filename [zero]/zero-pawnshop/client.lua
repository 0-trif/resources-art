local config = {
    model = "mp_f_freemode_01",
    location = {x = 412.236328125, y = 314.95758056641, z = 103.13272857666, h = 204.9203338623},
    skin = '{"Nose_Peak_Lenght":{"other":0.0,"main":0.0},"accessory":{"other":0,"main":2},"Jaw_Bone_Width":{"other":0.0,"main":-8},"Chimp_Bone_Lowering":{"other":0.0,"main":2},"shirts":{"other":0,"main":39},"shoes":{"other":0,"main":24},"Nose_Peak_Hight":{"other":0.0,"main":0.0},"Nose_Bone_High":{"other":0.0,"main":0.0},"Nose_Peak_Lowering":{"other":0.0,"main":0.0},"face":{"other":0,"main":25},"EyeBrown_Forward":{"other":0.0,"main":0.0},"EyeBrown_High":{"other":0.0,"main":1},"vest":{"other":0,"main":0},"Cheeks_Bone_High":{"other":0.0,"main":-20},"Chimp_Hole":{"other":0.0,"main":0.0},"decals":{"other":0,"main":0},"hair":{"other":0,"main":79},"Nose_Bone_Twist":{"other":0.0,"main":0.0},"pants":{"other":0,"main":27},"Eyes_Openning":{"other":0.0,"main":1},"Jaw_Bone_Back_Lenght":{"other":0.0,"main":-20},"makeup":{"other":1,"main":37},"Chimp_Bone_Width":{"other":0.0,"main":0.0},"Nose_Width":{"other":0.0,"main":-7},"Lips_Thickness":{"other":0.0,"main":-6},"Cheeks_Bone_Width":{"other":0.0,"main":-20},"Chimp_Bone_Lenght":{"other":0.0,"main":0.0},"Neck_Thikness":{"other":0.0,"main":-20},"Cheeks_Width":{"other":0.0,"main":0.0},"hair_color":{"other":21,"main":1},"jackets":{"other":2,"main":8}}',
}

local main = function()
    createPed()
    createBlip()
end

Citizen.CreateThread(function()
    main()
end)

function createBlip()
    local x,y,z,h = config.location.x, config.location.y, config.location.z - 1, config.location.h

    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 207)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 2)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Pandjes winkel")
    
    EndTextCommandSetBlipName(blip)
end

function clearPed
    (x,y,z)

    local entityOnLocation = GetClosestPed(x, y, z)

    if entityOnLocation then
        DeleteEntity(entityOnLocation)
    end
end

function RequestPed()
    RequestModel(config.model)
    while not HasModelLoaded(config.model) do
        Wait(0)
    end
end

function createPed
    ()

    local x,y,z,h = config.location.x, config.location.y, config.location.z - 1, config.location.h

    clearPed(x,y,z)
    RequestPed()
    
    local ped = CreatePed(24, config.model, x, y, z, h, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetPedCanBeTargetted(ped, false)
    SetEntityCanBeDamaged(ped, false)
    
    SetPedSkin(ped)
end

function SetPedSkin
    (entity)

    local ped = exports['zero-clothing_new']:ped()
    ped:code(config.skin, entity)
end


-- loop

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local ply = PlayerPedId()
        local pos = GetEntityCoords(ply)
        local x,y,z,h = config.location.x, config.location.y, config.location.z

        local distance = #(vector3(x,y,z) - pos)

        if (distance <= 5) then
            timer = 0

            TriggerEvent("interaction:show", "Openen", function()
                OpenSellMenu()
            end)
        end
        Wait(timer)
    end
end)

function OpenSellMenu()
    local ui = exports['zero-ui']:element()
    ui.set("Verkopen", {
        {
            label = "Spullen geven",
            subtitle = "Geef spullen aan koper, deze kan je later nog bestigen",
            event = "Zero:Client-Pawnshop:GiveItems"
        },
        {
            label = "Spullen verkopen",
            subtitle = "Verkoop je gegeven spullen definitief",
            event = "Zero:Client-Pawnshop:SellItems"
        },
        {
            label = "Sluiten",
            subtitle = "Sluit menu",
        }
    })
end

RegisterNetEvent("Zero:Client-Pawnshop:GiveItems")
AddEventHandler("Zero:Client-Pawnshop:GiveItems", function()
    TriggerServerEvent("Zero:Server-Pawnshop:GiveItems")
end)

RegisterNetEvent("Zero:Client-Pawnshop:SellItems")
AddEventHandler("Zero:Client-Pawnshop:SellItems", function()
    TriggerServerEvent("Zero:Server-Pawnshop:SellItems")
end)