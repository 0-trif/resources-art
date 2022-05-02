Modules['taxi'] = {}
Modules['taxi'].Functions = {} 
Modules['taxi'].Config = {
    [1] = {
        ['loc'] = {x = 897.09, y = -152.83, z = 76.55, h = 328.90},
        ['text'] = "Garage",
        ['functie'] = "OpenGarage",
    },
}


Citizen.CreateThread(function()
    local coord = {x = 911.79437255859, y = -170.50433349609, z = 74.243003845215, h = 148.91293334961}
    blip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(blip, 198)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 33)

    BeginTextCommandSetBlipName("STRING")

    AddTextComponentSubstringPlayerName("Taxi")
    
    EndTextCommandSetBlipName(blip)
end)


Modules['taxi'].options = {}


Modules['taxi'].Run = function()
    local player = PlayerPedId()
    local coord = GetEntityCoords(player)
    

    for k,v in ipairs(Modules['taxi'].Config) do
        local distance = #(coord - vector3(v.loc.x, v.loc.y, v.loc.z))

        if (distance <= 5 and distance > 1) then
            timer = 0
            
            Zero.Functions.DrawMarker(v.loc.x, v.loc.y, v.loc.z)
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, v.text)
        elseif (distance < 1) then
            timer = 0
            Zero.Functions.DrawText(v.loc.x, v.loc.y, v.loc.z, "~g~E~w~ - "..v.text.."")

            if IsControlJustPressed(0, 38) then
                Modules['taxi'].Functions[v.functie]()
            end
        end
    end
end


Modules['taxi'].Functions['OpenGarage'] = function()
    if JobModule == "taxi" and JobDuty then
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            DeleteEntity(GetVehiclePedIsIn(ped))
        else
            exports['zero-garages']:openMenu(Shared.Config.taxi.Vehicles)
        end
    end
end

Modules['taxi'].Functions['OpenKloesoe'] = function()
    TriggerServerEvent("Zero:Server-Police:OpenKloesoe")
end
