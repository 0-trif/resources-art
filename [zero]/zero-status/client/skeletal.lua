WeaponDamageList = {
	["WEAPON_UNARMED"] = "Fist prints",
	["WEAPON_ANIMAL"] = "Bite wound of an animal",
	["WEAPON_COUGAR"] = "Bite wound of an animal",
	["WEAPON_KNIFE"] = "Stab wound",
	["WEAPON_NIGHTSTICK"] = "Bump from a stick or something similar",
	["WEAPON_BREAD"] = "Dent in your head from a baguette!",
	["WEAPON_HAMMER"] = "Bump from a stick or something similar",
	["WEAPON_BAT"] = "Bump from a stick or something similar",
	["WEAPON_GOLFCLUB"] = "Bump from a stick or something similar",
	["WEAPON_CROWBAR"] = "Bump from a stick or something similar",
	["WEAPON_PISTOL"] = "Pistol bullets in the body",
	["WEAPON_COMBATPISTOL"] = "Pistol bullets in the body",
	["WEAPON_APPISTOL"] = "Pistol bullets in the body",
	["WEAPON_PISTOL50"] = "50 Cal Pistol bullets in the body",
	["WEAPON_MICROSMG"] = "SMG bullets in the body",
	["WEAPON_SMG"] = "SMG bullets in the body",
	["WEAPON_ASSAULTSMG"] = "SMG bullets in the body",
	["WEAPON_ASSAULTRIFLE"] = "Rifle bullets in the body",
	["WEAPON_CARBINERIFLE"] = "Rifle bullets in the body",
	["WEAPON_ADVANCEDRIFLE"] = "Rifle bullets in the body",
	["WEAPON_MG"] = "Machine Gun bullets in the body",
	["WEAPON_COMBATMG"] = "Machine Gun bullets in the body",
	["WEAPON_PUMPSHOTGUN"] = "Shotgun bullets in the body",
	["WEAPON_SAWNOFFSHOTGUN"] = "Shotgun bullets in the body",
	["WEAPON_ASSAULTSHOTGUN"] = "Shotgun bullets in the body",
	["WEAPON_BULLPUPSHOTGUN"] = "Shotgun bullets in the body",
	["WEAPON_STUNGUN"] = "Taser prints",
	["WEAPON_SNIPERRIFLE"] = "Sniper bullets in the body",
	["WEAPON_HEAVYSNIPER"] = "Sniper bullets in the body",
	["WEAPON_REMOTESNIPER"] = "Sniper bullets in the body",
	["WEAPON_GRENADELAUNCHER"] = "Burns and fragments",
	["WEAPON_GRENADELAUNCHER_SMOKE"] = "Smoke Damage",
	["WEAPON_RPG"] = "Burns and fragments",
	["WEAPON_STINGER"] = "Burns and fragments",
	["WEAPON_MINIGUN"] = "Very much bullets in the body",
	["WEAPON_GRENADE"] = "Burns and fragments",
	["WEAPON_STICKYBOMB"] = "Burns and fragments",
	["WEAPON_SMOKEGRENADE"] = "Smoke Damage",
	["WEAPON_BZGAS"] = "Gas Damage",
	["WEAPON_MOLOTOV"] = "Heavy Burns",
	["WEAPON_FIREEXTINGUISHER"] = "Sprayed on :)",
	["WEAPON_PETROLCAN"] = "Petrol Can Damage",
	["WEAPON_FLARE"] = "Flare Damage",
	["WEAPON_BARBED_WIRE"] = "Barbed Wire Damage",
	["WEAPON_DROWNING"] = "Drowned",
	["WEAPON_DROWNING_IN_VEHICLE"] = "Drowned",
	["WEAPON_BLEEDING"] = "Lost a lot of blood",
	["WEAPON_ELECTRIC_FENCE"] = "Electric Fence Wounds",
	["WEAPON_EXPLOSION"] = "Many burns (from explosives)",
	["WEAPON_FALL"] = "Broken bones",
	["WEAPON_EXHAUSTION"] = "Died of Exhaustion",
	["WEAPON_HIT_BY_WATER_CANNON"] = "Water Cannon Pelts",
	["WEAPON_RAMMED_BY_CAR"] = "Car accident",
	["WEAPON_RUN_OVER_BY_CAR"] = "Hit by a vehicle",
	["WEAPON_HELI_CRASH"] = "Helicopter crash",
	["WEAPON_FIRE"] = "Many burns",
}

DamageList = {
	['HEAD'] = {normal = 0, bullets = 0, label = "Hoofd"},
    ['NECK'] = {normal = 0, bullets = 0, label = "Nek"},
    ['SPINE'] = {normal = 0, bullets = 0, label = "Rug"},
    ['UPPER_BODY'] = {normal = 0, bullets = 0, label = "Bovenlichaam"},
    ['LOWER_BODY'] = {normal = 0, bullets = 0, label = "Onderlichaam"},
    ['LARM'] = {normal = 0, bullets = 0, label = "Linker arm"},
    ['LHAND'] = {normal = 0, bullets = 0, label = "Linker hand"},
    ['LFINGER'] = {normal = 0, bullets = 0, label = "Linker hand"},
    ['LLEG'] = {normal = 0, bullets = 0, label = "Linker been", type = 'leg'},
    ['LFOOT'] = {normal = 0, bullets = 0, label = "Linker voet", type = 'leg'},
    ['RARM'] = {normal = 0, bullets = 0, label = "Rechter arm"},
    ['RHAND'] = {normal = 0, bullets = 0, label = "Rechter hand"},
    ['RFINGER'] = {normal = 0, bullets = 0, label = "Rechter hand"},
    ['RLEG'] = {normal = 0, bullets = 0, label = "Rechter been", type = 'leg'},
    ['RFOOT'] = {normal = 0, bullets = 0, label = "Rechter voet", type = 'leg'},
}

WoundStates = {
    'Geirriteerd',
    'Beetje pijnlijk',
    'Pijnlijk',
    'Erg pijnlijk',
}

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)
        
        if not playerHealth then
            playerHealth = health
        end
        
        local healthDamaged = (playerHealth ~= health) -- Players health was damaged
        
        local damageDone = (playerHealth - health)
        
        if healthDamaged then
            playerHealth = health
            local hit, bone = GetPedLastDamageBone(ped)
            local bodypart = Config.Bones[bone]
            local weapon = GetDamagingWeapon(ped)

            if weapon then
                ApplyWeaponDamage(bone, bodypart, weapon)
				LimbAlert()
				Citizen.Wait(3000)
            end
        end

        Wait(0)
    end
end)

function ResetLimbs()
	for k,v in pairs(DamageList) do
		v.normal = 0
		v.bullets = 0
	end
	damagedWalk = false

	ResetPedMovementClipset(PlayerPedId())
	SetPlayerSprint(PlayerId(), true)
end

function GetDamagingWeapon(ped)
    for k, v in pairs(Config.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, k, 0) then
            return v
        end
    end

    return nil
end

function ApplyWeaponDamage(bone, part, weapon)
	if not part then return end
	
    if (weapon ~= 11) then
        if DamageList[part] then
            DamageList[part].bullets = DamageList[part].bullets + 1 <= 4 and DamageList[part].bullets + 1 or 4
        end
	else
		DamageList[part].normal = DamageList[part].normal + 1 <= 4 and DamageList[part].normal + 1 or 4
    end
end

function CanBeRevived()
    if (DamageList['HEAD'].bullets > 1) then
        return false
    else
        count = 0
        for k,v in pairs(DamageList) do
            count = count + v.bullets
        end

        if (count > 5) then
            return false
        else
            return true
        end
    end
end

function LimbAlert()
	local legDamage = 0
	damagedWalk = false

	for k,v in pairs(DamageList) do
		if v.bullets > 0 then
			local painRate = WoundStates[v.bullets]

			Zero.Functions.Notification('Status', 'Je '..v.label..' is ernstig verwond!')
		elseif v.bullets == 0 and v.normal > 0 then
			local painRate = WoundStates[v.normal]

			Zero.Functions.Notification('Status', 'Je '..v.label..' voelt '..painRate..'')
		end
		
		if v.type and v.type == 'leg' then
			legDamage = legDamage + v.normal
			legDamage = legDamage + v.bullets
		end
	end


	if legDamage >= 2 then
		InjuredWalk()
	end
end

function InjuredWalk()
	damagedWalk = true
end

Citizen.CreateThread(function()
	while true do
		LimbAlert()
		
		Wait(1000 * 60)
	end
end)

Citizen.CreateThread(function ()
	while true do
		if damagedWalk then
			RequestAnimSet("move_m@injured")
			while not HasAnimSetLoaded("move_m@injured") do
				Citizen.Wait(0)
			end
			SetPedMovementClipset(PlayerPedId(), "move_m@injured", 1 )
			SetPlayerSprint(PlayerId(), false)


			Wait(10)
		else
			Wait(750)
		end
	end
end)