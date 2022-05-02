local Player = nil
local CruisedSpeed, CruisedSpeedKm, VehicleVectorY = 0, 0, 0
local vehicleClasses = {
  [0] = true,
  [1] = true,
  [2] = true,
  [3] = true,
  [4] = true,
  [5] = true,
  [6] = true,
  [7] = true,
  [8] = true,
  [9] = true,
  [10] = true,
  [11] = true,
  [12] = true,
  [13] = false,
  [14] = false,
  [15] = false,
  [16] = false,
  [17] = true,
  [18] = true,
  [19] = true,
  [20] = true,
  [21] = false,
}

anchor = false

CreateThread(function()
  while true do
      Wait(0)
      local veh = GetVehiclePedIsIn(PlayerPedId())
      local vehClass = GetVehicleClass(veh)
      if IsPedInAnyVehicle(PlayerPedId()) then
        if IsControlJustPressed(1, 246) and IsDriver() then
            if vehicleClasses[vehClass] then
                Player = PlayerPedId()
                TriggerCruiseControl()
            end
        end

        if IsControlJustPressed(1, Zero.Config.Keys['Y']) and IsDriver() then
            if vehClass == 14 then
              anchor = not anchor

              SetBoatAnchor(veh, anchor)
              SetBoatFrozenWhenAnchored(veh, anchor)

              if anchor then
                Zero.Functions.Notification('Anker', 'Anker is nu uit')
              else
                Zero.Functions.Notification('Anker', 'Anker is nu in')
              end
            end
        end
      else
          Citizen.Wait(250)
       end
    end
end)

function TriggerCruiseControl ()
  if CruisedSpeed == 0 and IsDriving() then
    if GetVehiculeSpeed() > 0 and GetVehicleCurrentGear(GetVehicle()) > 0  then
      CruisedSpeed = GetVehiculeSpeed()
      CruisedSpeedMph = TransformToMph(CruisedSpeed)

      TriggerEvent('seatbelt:client:ToggleCruise')
      Zero.Functions.Notification("Begrenzing", "Cruise Activated: " .. CruisedSpeedMph ..  " MP/H") -- Comment me for km/h


      Citizen.CreateThread(function ()
        while CruisedSpeed > 0 and IsInVehicle() == Player do
          Wait(0)

          if not IsTurningOrHandBraking() and GetVehiculeSpeed() < (CruisedSpeed - 1.5) then
            CruisedSpeed = 0
            TriggerEvent('seatbelt:client:ToggleCruise')
            Zero.Functions.Notification("Begrenzing", "Begrenzer uit")
            Wait(2000)
            break
          end

          if not IsTurningOrHandBraking() and IsVehicleOnAllWheels(GetVehicle()) and GetVehiculeSpeed() < CruisedSpeed then
            SetVehicleForwardSpeed(GetVehicle(), CruisedSpeed)
          end

          if IsControlJustPressed(1, 246) then
            TriggerEvent('seatbelt:client:ToggleCruise')
            CruisedSpeed = GetVehiculeSpeed()
            CruisedSpeedKm = TransformToKm(CruisedSpeed)
          end

          if IsControlJustPressed(2, 72) then
            CruisedSpeed = 0
            TriggerEvent('seatbelt:client:ToggleCruise')
            Zero.Functions.Notification("Begrenzing", "Begrenzer uit")
            Wait(2000)
            break
          end
        end
      end)
    end
  end
end

function IsTurningOrHandBraking ()
  return IsControlPressed(2, 76) or IsControlPressed(2, 63) or IsControlPressed(2, 64)
end

function IsDriving ()
  return IsPedInAnyVehicle(Player, false)
end

function GetVehicle ()
  return GetVehiclePedIsIn(PlayerPedId(), false)
end

function IsInVehicle ()
  return GetPedInVehicleSeat(GetVehicle(), -1)
end

function IsDriver ()
  return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

function GetVehiculeSpeed ()
  return GetEntitySpeed(GetVehicle())
end

function TransformToKm (speed)
  return math.floor(speed * 3.6 + 0.5)
end

function TransformToMph (speed)
  return math.floor(speed * 2.2369 + 0.5)
end
