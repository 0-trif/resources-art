exports["zero-core"]:object(function(O) Zero = O end)

local radioMenu = false
function enableRadio(enable)
    if enable then
      SetNuiFocus(enable, enable)
      PhonePlayIn()
      SendNUIMessage({
        type = "open",
      })
      radioMenu = enable
   end
end

RegisterNetEvent("radio")
AddEventHandler("radio", function()
    enableRadio(true)
end)


RegisterNUICallback('joinRadio', function(data, cb)
  local _source = source
  local PlayerData = Zero.Functions.GetPlayerData()

  if tonumber(data.channel) <= 10000 then
    if tonumber(data.channel) <= 12 then
      if PlayerData.Job.name == 'police' or PlayerData.Job.name == 'ambulance' or PlayerData.Job.name == "mechanic" or PlayerData.Job.name == "taxi" or PlayerData.Job.name == "kmar" then
        exports['mumble-voip']:SetRadioChannel(tonumber(data.channel))
        inRadio = true
        Zero.Functions.Notification("Radio", "Je bent verbonden met de frequentie "..data.channel.."")
        TriggerServerEvent("mumble:callid")
      else
        Zero.Functions.Notification("Radio", "Je hebt geen toegang tot deze frequentie", "error")
      end
    end

    if tonumber(data.channel) > 12 then
      exports['mumble-voip']:SetRadioChannel(tonumber(data.channel))
      inRadio = true

      Zero.Functions.Notification("Radio", "Je bent verbonden met de frequentie "..data.channel.."")
    end
  else
    Zero.Functions.Notification("Radio", "Deze frequentie bestaat niet", "error")
  end
  cb('ok')
end)

RegisterNUICallback('leaveRadio', function(data, cb)
    exports['mumble-voip']:SetRadioChannel(0)
    inRadio = false
    
    Zero.Functions.Notification("Radio", "Je bent je huidige frequentie verlaten", "success")
  cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
  SetNuiFocus(false, false)
  radioMenu = false
  PhonePlayOut()
  cb('ok')
end)

function SplitStr(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end


function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end


Citizen.CreateThread(function()
    while true do
      Wait(0)
      if inRadio then
        if IsControlJustPressed(0, Zero.Config.Keys['CAPS']) then
          loadAnimDict("random@arrests")
          TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)

          while IsControlPressed(0, Zero.Config.Keys['CAPS']) do
            Wait(0)
          end

            ClearPedTasks(PlayerPedId())
        end
      end
    end
end)