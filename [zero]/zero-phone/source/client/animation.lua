
Citizen.CreateThread(function()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	local object = GetClosestObjectOfType(x, y, z, 10.0, GetHashKey("prop_amb_phone"))
	if object then DeleteEntity(object) end

	while true do
		Citizen.Wait(250)
		local ped = PlayerPedId()

		RequestAnimDict("cellphone@")
		while not HasAnimDictLoaded("cellphone@") do
		  Citizen.Wait(0)
		end

		
		if (Config.Vars.Toggle) then
			if not DoesEntityExist(attachedPropPhone) then
				TriggerEvent("attachItemPhone")
			end

			if calling_person == false then
				person_in_call = false
			end

			if (person_in_call or calling_person) then
			    if not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_call_listen_base", 3) and not IsPedRagdoll(PlayerPedId()) then
					TaskPlayAnim(ped, "cellphone@", "cellphone_call_listen_base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
				end 
			else
				foundAn = false
		 		if not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_text_read_base", 3) and not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_swipe_screen", 3) then
        			TaskPlayAnim(ped, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
      			end    
			end
		else
			if IsEntityPlayingAnim(ped, "cellphone@", "cellphone_text_read_base", 3) and not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_swipe_screen", 3) then
				ClearPedTasks(ped)
				if DoesEntityExist(attachedPropPhone) then
					removeAttachedPropPhone()
				end  
			end  
		end
	end
end)

PhoneA = {["model"] = "prop_amb_phone", ["bone"] = 57005, ["x"] = 0.14,["y"] = 0.01,["z"] = -0.02,["xR"] = 110.0,["yR"] = 120.0, ["zR"] = -15.0}

RegisterNetEvent('attachItemPhone')
AddEventHandler('attachItemPhone', function()
	TriggerEvent("attachPropPhone", PhoneA.model, PhoneA["bone"], PhoneA["x"], PhoneA["y"], PhoneA["z"], PhoneA["xR"], PhoneA["yR"], PhoneA["zR"])
end)

RegisterNetEvent('attachPropPhone')
AddEventHandler('attachPropPhone', function(model,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedPropPhone()

	attachModelPhone = GetHashKey(model)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModelPhone)
	while not HasModelLoaded(attachModelPhone) do
		Citizen.Wait(100)
		
	end
	attachedPropPhone = CreateObject(attachModelPhone, 1.0, 1.0, 1.0, 1, 1, 0)

	AttachEntityToEntity(attachedPropPhone, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)

attachedPropPhone = 0
function removeAttachedPropPhone()
	if DoesEntityExist(attachedPropPhone) then
		DeleteEntity(attachedPropPhone)
		attachedPropPhone = 0
	end
end

function LoadAnimation(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end