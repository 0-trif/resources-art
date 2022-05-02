local key
local hotwire
local history = {}


exports['zero-core']:object(function(O) Zero = O end)

RegisterNetEvent('vehiclekeys:client:SetOwner')
AddEventHandler('vehiclekeys:client:SetOwner', function(plate)
    local VehPlate = plate
    local CurrentVehPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))

    if VehPlate == nil then
        VehPlate = CurrentVehPlate
    end

    TriggerServerEvent('vehiclekeys:server:SetVehicleOwner', VehPlate)

    if IsPedInAnyVehicle(PlayerPedId()) and plate == CurrentVehPlate then
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), true), true, false, true)
    end

    key = true
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 100

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped)
        local inVeh = IsPedInAnyVehicle(ped, true)
        local entering = GetVehiclePedIsTryingToEnter(ped)
        local plate = GetVehicleNumberPlateText(entering)
        
        if entering ~= 0 and not inVeh then
            local vehicle = entering

            key = nil

            if not GetIsVehicleEngineRunning(vehicle) then
                Zero.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
                    if result then
                        key = true
                    else
                        key = false
                    end
                end, plate)
            else
                key = true
            end

            while key == nil do
                Wait(0)
            end

            if history[plate] == nil and not key then
                history[plate] = true
                SetVehicleDoorsLocked(entering, 2)
            end
        end

        if inVeh then
            sleep = 0

            if not key then
                SetVehicleEngineOn(veh, false, false, true)
                key = false
                hotwire = false
            end

            if not hotwire and not key and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
                local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
                Zero.Functions.DrawText(x,y,z, "[H] Hotwire")

                if IsControlJustPressed(0, Zero.Config.Keys['H']) then
                    local finished = exports['zero-skill']:skill("Voertuig hotwire", math.random(2000, 12000))
                
                    if finished then
                        hotwire = true
                        key = true
                        SetVehicleEngineOn(veh, true, true, true)
                        Zero.Functions.Notification("Hotwire", "Voertuig hotwire gelukt", "success")
                    else
                        hotwire = false
                        PoliceCall()
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local timer = 750
        local ped = PlayerPedId()

        CanUseLockpick = false

        if not IsPedInAnyVehicle(ped) and GetVehiclePedIsTryingToEnter(ped) ~= nil then
            local vehicle = Zero.Functions.closestVehicle()

            if vehicle then
                if GetVehicleDoorLockStatus(vehicle) == 2 and GetPedInVehicleSeat(vehicle, -1) == 0 then
                    local distance = #(GetEntityCoords(vehicle) - GetEntityCoords(ped))

                    if distance <= 5 then
                        timer = 0

                        TriggerEvent("Zero:Client-Inventory:DisplayUsable", "lockpick")

                        CanUseLockpick = true
                    end
                end
            end
        end

        Wait(timer)
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end


RegisterKeyMapping('togglelocks', 'Toggle Vehicle Locks', 'keyboard', 'L')
RegisterCommand('togglelocks', function()
    LockVehicle()
end)

function LockVehicle()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local veh = Zero.Functions.closestVehicle(pos)
    local plate = GetVehicleNumberPlateText(veh)
    local vehpos = GetEntityCoords(veh)
    
    if IsPedInAnyVehicle(ped) then
        veh = GetVehiclePedIsIn(ped)
    end

    if veh ~= nil and #(pos - vehpos) < 7.5 then
        Zero.Functions.TriggerCallback('vehiclekeys:CheckHasKey', function(result)
            if result then
                local vehLockStatus = GetVehicleDoorLockStatus(veh)
                loadAnimDict("anim@mp_player_intmenu@key_fob@")
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
    
                if vehLockStatus == 1 then
                    Citizen.Wait(750)
                    ClearPedTasks(ped)
                 --   TriggerServerEvent("InteractSound_SV:PlayOnOne", 5, "lock", 0.3)
                    SetVehicleDoorsLocked(veh, 2)
                    if(GetVehicleDoorLockStatus(veh) == 2)then
                        SetVehicleLights(veh,2)
                        Wait(250)
                        SetVehicleLights(veh,1)
                        Wait(200)
                        SetVehicleLights(veh,0)
                        Zero.Functions.Notification("Sleutels", "Voertuig gesloten!")
                    end
                else
                    Citizen.Wait(750)
                    ClearPedTasks(ped)
                 --   TriggerServerEvent("InteractSound_SV:PlayOnOne", 5, "unlock", 0.3)
                    SetVehicleDoorsLocked(veh, 1)
                    if(GetVehicleDoorLockStatus(veh) == 1)then
                        SetVehicleLights(veh,2)
                        Wait(250)
                        SetVehicleLights(veh,1)
                        Wait(200)
                        SetVehicleLights(veh,0)
                        Zero.Functions.Notification("Sleutels","Voertuig geopend!")
                    end
                end
            else
                Zero.Functions.Notification("Sleutels",'Je hebt de sleutels van dit voertuig niet', 'error')
            end
        end, plate)
    end
end

RegisterNetEvent('vehiclekeys:client:GiveKeys')
AddEventHandler('vehiclekeys:client:GiveKeys', function(target)
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
    TriggerServerEvent('vehiclekeys:server:GiveVehicleKeys', plate, target)
end)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(target)
    local item, slot, amount = Zero.Functions.HasItem("lockpick")


    if CanUseLockpick then
        if lockpicking then return end

        local random = math.random(0, 100)

        if item then
            if slot then
                lockpicking = true
                
                local finished1 = exports['zero-skill']:skill("Voertuig lockpick", math.random(8000, 15000))
                    
                if finished1 then
                    local finished2 = exports['zero-skill']:skill("Voertuig lockpick", math.random(3000, 4000))

                    if finished2 then
                        local vehicle = Zero.Functions.closestVehicle()

                        lockpicking = false
                        SetVehicleDoorsLocked(vehicle, 0)
                        Zero.Functions.Notification("Lockpick","Voertuig geopend", "success")
                    else
                        lockpicking = false
                        Zero.Functions.Notification("Lockpick","Lockpick gefaald", "error")

                        if (random > 90) then
                            TriggerServerEvent("Zero:Server-Inventory:RemoveSlot", slot)
                        end
                        if (random <= 20) then
                            PoliceCall()
                        end
                    end
                else
                    lockpicking = false
                    Zero.Functions.Notification("Lockpick","Voertuig gefaald", "error")

                    if (random > 90) then
                        TriggerServerEvent("Zero:Server-Inventory:RemoveSlot", slot)
                    end
                    if (random <= 20) then
                        PoliceCall()
                    end
                end
            end
        end
    end
end)

function CarInformation()
    local colorNames = {
        ['0'] = "Metallic Black",
        ['1'] = "Metallic Graphite Black",
        ['2'] = "Metallic Black Steal",
        ['3'] = "Metallic Dark Silver",
        ['4'] = "Metallic Silver",
        ['5'] = "Metallic Blue Silver",
        ['6'] = "Metallic Steel Gray",
        ['7'] = "Metallic Shadow Silver",
        ['8'] = "Metallic Stone Silver",
        ['9'] = "Metallic Midnight Silver",
        ['10'] = "Metallic Gun Metal",
        ['11'] = "Metallic Anthracite Grey",
        ['12'] = "Matte Black",
        ['13'] = "Matte Gray",
        ['14'] = "Matte Light Grey",
        ['15'] = "Util Black",
        ['16'] = "Util Black Poly",
        ['17'] = "Util Dark silver",
        ['18'] = "Util Silver",
        ['19'] = "Util Gun Metal",
        ['20'] = "Util Shadow Silver",
        ['21'] = "Worn Black",
        ['22'] = "Worn Graphite",
        ['23'] = "Worn Silver Grey",
        ['24'] = "Worn Silver",
        ['25'] = "Worn Blue Silver",
        ['26'] = "Worn Shadow Silver",
        ['27'] = "Metallic Red",
        ['28'] = "Metallic Torino Red",
        ['29'] = "Metallic Formula Red",
        ['30'] = "Metallic Blaze Red",
        ['31'] = "Metallic Graceful Red",
        ['32'] = "Metallic Garnet Red",
        ['33'] = "Metallic Desert Red",
        ['34'] = "Metallic Cabernet Red",
        ['35'] = "Metallic Candy Red",
        ['36'] = "Metallic Sunrise Orange",
        ['37'] = "Metallic Classic Gold",
        ['38'] = "Metallic Orange",
        ['39'] = "Matte Red",
        ['40'] = "Matte Dark Red",
        ['41'] = "Matte Orange",
        ['42'] = "Matte Yellow",
        ['43'] = "Util Red",
        ['44'] = "Util Bright Red",
        ['45'] = "Util Garnet Red",
        ['46'] = "Worn Red",
        ['47'] = "Worn Golden Red",
        ['48'] = "Worn Dark Red",
        ['49'] = "Metallic Dark Green",
        ['50'] = "Metallic Racing Green",
        ['51'] = "Metallic Sea Green",
        ['52'] = "Metallic Olive Green",
        ['53'] = "Metallic Green",
        ['54'] = "Metallic Gasoline Blue Green",
        ['55'] = "Matte Lime Green",
        ['56'] = "Util Dark Green",
        ['57'] = "Util Green",
        ['58'] = "Worn Dark Green",
        ['59'] = "Worn Green",
        ['60'] = "Worn Sea Wash",
        ['61'] = "Metallic Midnight Blue",
        ['62'] = "Metallic Dark Blue",
        ['63'] = "Metallic Saxony Blue",
        ['64'] = "Metallic Blue",
        ['65'] = "Metallic Mariner Blue",
        ['66'] = "Metallic Harbor Blue",
        ['67'] = "Metallic Diamond Blue",
        ['68'] = "Metallic Surf Blue",
        ['69'] = "Metallic Nautical Blue",
        ['70'] = "Metallic Bright Blue",
        ['71'] = "Metallic Purple Blue",
        ['72'] = "Metallic Spinnaker Blue",
        ['73'] = "Metallic Ultra Blue",
        ['74'] = "Metallic Bright Blue",
        ['75'] = "Util Dark Blue",
        ['76'] = "Util Midnight Blue",
        ['77'] = "Util Blue",
        ['78'] = "Util Sea Foam Blue",
        ['79'] = "Uil Lightning blue",
        ['80'] = "Util Maui Blue Poly",
        ['81'] = "Util Bright Blue",
        ['82'] = "Matte Dark Blue",
        ['83'] = "Matte Blue",
        ['84'] = "Matte Midnight Blue",
        ['85'] = "Worn Dark blue",
        ['86'] = "Worn Blue",
        ['87'] = "Worn Light blue",
        ['88'] = "Metallic Taxi Yellow",
        ['89'] = "Metallic Race Yellow",
        ['90'] = "Metallic Bronze",
        ['91'] = "Metallic Yellow Bird",
        ['92'] = "Metallic Lime",
        ['93'] = "Metallic Champagne",
        ['94'] = "Metallic Pueblo Beige",
        ['95'] = "Metallic Dark Ivory",
        ['96'] = "Metallic Choco Brown",
        ['97'] = "Metallic Golden Brown",
        ['98'] = "Metallic Light Brown",
        ['99'] = "Metallic Straw Beige",
        ['100'] = "Metallic Moss Brown",
        ['101'] = "Metallic Biston Brown",
        ['102'] = "Metallic Beechwood",
        ['103'] = "Metallic Dark Beechwood",
        ['104'] = "Metallic Choco Orange",
        ['105'] = "Metallic Beach Sand",
        ['106'] = "Metallic Sun Bleeched Sand",
        ['107'] = "Metallic Cream",
        ['108'] = "Util Brown",
        ['109'] = "Util Medium Brown",
        ['110'] = "Util Light Brown",
        ['111'] = "Metallic White",
        ['112'] = "Metallic Frost White",
        ['113'] = "Worn Honey Beige",
        ['114'] = "Worn Brown",
        ['115'] = "Worn Dark Brown",
        ['116'] = "Worn straw beige",
        ['117'] = "Brushed Steel",
        ['118'] = "Brushed Black steel",
        ['119'] = "Brushed Aluminium",
        ['120'] = "Chrome",
        ['121'] = "Worn Off White",
        ['122'] = "Util Off White",
        ['123'] = "Worn Orange",
        ['124'] = "Worn Light Orange",
        ['125'] = "Metallic Securicor Green",
        ['126'] = "Worn Taxi Yellow",
        ['127'] = "police car blue",
        ['128'] = "Matte Green",
        ['129'] = "Matte Brown",
        ['130'] = "Worn Orange",
        ['131'] = "Matte White",
        ['132'] = "Worn White",
        ['133'] = "Worn Olive Army Green",
        ['134'] = "Pure White",
        ['135'] = "Hot Pink",
        ['136'] = "Salmon pink",
        ['137'] = "Metallic Vermillion Pink",
        ['138'] = "Orange",
        ['139'] = "Green",
        ['140'] = "Blue",
        ['141'] = "Mettalic Black Blue",
        ['142'] = "Metallic Black Purple",
        ['143'] = "Metallic Black Red",
        ['144'] = "hunter green",
        ['145'] = "Metallic Purple",
        ['146'] = "Metaillic V Dark Blue",
        ['147'] = "MODSHOP BLACK1",
        ['148'] = "Matte Purple",
        ['149'] = "Matte Dark Purple",
        ['150'] = "Metallic Lava Red",
        ['151'] = "Matte Forest Green",
        ['152'] = "Matte Olive Drab",
        ['153'] = "Matte Desert Brown",
        ['154'] = "Matte Desert Tan",
        ['155'] = "Matte Foilage Green",
        ['156'] = "DEFAULT ALLOY COLOR",
        ['157'] = "Epsilon Blue",
    }

    local vehicle = Zero.Functions.closestVehicle()
    local color = GetVehicleModColor_1Name(vehicle)
    
    local primary, secondary = GetVehicleColours(veh)

    primary = colorNames[tostring(primary)]
    secondary = colorNames[tostring(secondary)]

    return primary .. ", " .. secondary
end

function PoliceCall()
    local location = GetEntityCoords(PlayerPedId())
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, location.x, location.y, location.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    streetname = street1 .. ", " .. street2

    TriggerServerEvent("dispatch:public", {"police", "kmar"}, {
        taggs = {
            [1] = {
                name = "10-64",
                color = "#4E44B0",
            },
        },
        title = "Burger melding",
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
                text = "Melding: Iemand probeerd een voertuig te stelen.",
            },
            [4] = {
                icon = '<i class="fa-solid fa-car"></i>',
                text = "Voertuig informatie: "..CarInformation().."",
            },
        },
        type = "police",
        location = GetEntityCoords(PlayerPedId())
    })

end