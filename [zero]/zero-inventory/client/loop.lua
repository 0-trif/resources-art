function GetInventoryWeight()
    local amount = 0

    for k,v in pairs(inventory.data.items) do
        amount = amount + (shared.config.items[v.item]['weight'] * v.amount)
    end

    return amount
end

PlayerProps = {}

function ApplyBag()
    shared.config.MaxWeight = 300

    Prop = 'p_michael_backpack_s'
    PropBone = 24818
    PropPlacement = {0.07, -0.11, -0.05, 0.0, 90.0, 175.0}

    if PlayerProps[1] == nil then
        AddPropToPlayer(Prop, PropBone, PropPlacement[1], PropPlacement[2], PropPlacement[3], PropPlacement[4], PropPlacement[5], PropPlacement[6])

        SendNUIMessage({
            action = "UpdateMax",
            data   = {
                maxweight = shared.config.MaxWeight
            }
        })
    end
end

function CancelBag()
    shared.config.MaxWeight = 200
    DestroyAllProps()

    SendNUIMessage({
        action = "UpdateMax",
        data   = {
            maxweight = shared.config.MaxWeight
        }
    })
end

function HeavyWalk()
    RequestAnimDict("anim@amb@nightclub@lazlow@lo_alone@")

    while not HasAnimDictLoaded("anim@amb@nightclub@lazlow@lo_alone@") do
        Wait(0)
    end

    if not IsEntityPlayingAnim(PlayerPedId(), "anim@amb@nightclub@lazlow@lo_alone@", "lowalone_base_laz", 3) then
        local dead = Zero.Functions.GetPlayerData().MetaData.dead
        if not dead then
            Zero.Functions.Notification('Status', 'Je hebt teveel gewicht bij je, koop een tas of gooi dingen weg', "warning", 7000)
            TaskPlayAnim(PlayerPedId(), "anim@amb@nightclub@lazlow@lo_alone@", "lowalone_base_laz", 10.0, 3.0, -1, 1, 0, 0, 0, 0)
        end
    end
end

Citizen.CreateThread(function()
    while true do

        if IsControlJustPressed(0, 20) then
            SendNUIMessage({
                action = "toggle_hotbar",
                bool = true,
            })
            
            while IsControlPressed(0, 20) do
                Wait(0)
            end
   
            SendNUIMessage({
                action = "toggle_hotbar",
                bool = false,
            })
        end

        local weight = GetInventoryWeight()

        if weight > shared.config.MaxWeight then
            HeavyWalk()
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        found = false
        for k,v in pairs(inventory.data.items) do
            if v.item == "bag" then
                ApplyBag()
                found = true
                break
            end
        end

        if not found then
            CancelBag()
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    local indexes = {
        [1] = Keys["1"],
        [2] = Keys["2"],
        [3] = Keys["3"],
        [4] = Keys["4"],
        [5] = Keys["5"],
        [6] = Keys["6"],
    }

    while true do
        
        DisableControlAction(0, Keys['TAB'])

        for i = 1, #indexes do

            if IsControlJustPressed(0, indexes[i]) then
                TriggerServerEvent("inventory:server:pressed", i)
                CancelEvent()
            end
        end

        Wait(3)
    end
end)

Citizen.CreateThread(function()
    exports['zero-eye']:looped_runtime("trunk-open", function(coords, entity)
        local entity = entity
        if (entity and IsEntityAVehicle(entity)) then
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
            local drawpos = GetOffsetFromEntityInWorldCoords(entity, 0, -2.5, 0)

            if (dist <= 3) then
                return true, drawpos
            end
        end
    end, {
        [1] = {
            name = "Open kofferbak", 
            action = function(entity) 
                TriggerEvent("disableEye")
                
                local vehicle = entity
                local numberplate = string.upper(GetVehicleNumberPlateText(vehicle))

                if GetVehicleDoorLockStatus(vehicle) == 1 then
                    OpenTrunk(vehicle)
                    TriggerServerEvent("inventory:Server:trunk", numberplate, GetVehicleClass(vehicle))
                end
            end,
        },
    }, GetCurrentResourceName(), 10)
end)

-- props

DestroyAllProps = function()
    for _,v in pairs(PlayerProps) do
      DeleteEntity(v)
    end
    PlayerProps = {}
    PlayerHasProp = false
end
  
AddPropToPlayer = function(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local Player = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(Player))
  
    if not HasModelLoaded(prop1) then
      LoadPropDict(prop1)
    end
  
    prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
end

LoadPropDict = function(model)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
      Citizen.Wait(1)
    end
end