ped = {}

local FaceFeatures = {
    [1] = "Nose_Width",  
    [2] = "Nose_Peak_Hight",  
    [3] = "Nose_Peak_Lenght",  
    [4] = "Nose_Bone_High",  
    [5] = "Nose_Peak_Lowering",  
    [6] = "Nose_Bone_Twist",  
    [7] = "EyeBrown_High",  
    [8] = "EyeBrown_Forward",  
    [9] = "Cheeks_Bone_High",  
    [10] = "Cheeks_Bone_Width",  
    [11] = "Cheeks_Width",  
    [12] = "Eyes_Openning",  
    [13] = "Lips_Thickness",  
    [14] = "Jaw_Bone_Width", --Bone size to sides  
    [15] = "Jaw_Bone_Back_Lenght", --Bone size to back  
    [16] = "Chimp_Bone_Lowering", --Go Down  
    [17] = "Chimp_Bone_Lenght", --Go forward  
    [18] = "Chimp_Bone_Width",  
    [19] = "Chimp_Hole",  
    [20] = "Neck_Thikness",  
}

function ped:model(model)
    RequestModel(model)

    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end

    SetPlayerModel(PlayerId(), model)
    config.skin = {}
    
    ped:changed()
    ped:resetFace()
   
    if (model == "mp_m_freemode_01" or model == "mp_f_freemode_01") then   
        SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
        SetPedHeadBlendData(GetPlayerPed(-1), 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, true) 
    end
end

function ped:male()
    local currentModel = GetEntityModel(PlayerPedId())

    for k,v in pairs(config.models.male) do
        if GetHashKey(v) == currentModel then
            return true
        end
    end

    return false
end

function ped:findModelRight(model)
    for k,v in pairs(config.models.male) do
        if (GetHashKey(v) == model) then
            if (config.models.male[k + 1]) then
                return config.models.male[k + 1]
            else
                return config.models.male[#config.models.male]
            end
        end
    end

    for k,v in pairs(config.models.female) do
        if (GetHashKey(v) == model) then
            if (config.models.female[k + 1]) then
          
                return config.models.female[k + 1]
            else
                return config.models.female[#config.models.female]
            end
        end
    end
end

function ped:findModelLeft(model)
    for k,v in pairs(config.models.male) do
        if (GetHashKey(v) == model) then
            if (config.models.male[k - 1]) then
                return config.models.male[k - 1]
            else
                return config.models.male[1]
            end
        end
    end

    for k,v in pairs(config.models.female) do
        if (GetHashKey(v) == model) then
            if (config.models.female[k - 1]) then
                return config.models.female[k - 1]
            else
                return config.models.female[1]
            end
        end
    end
end

function ped:changed()
    ped:max()

    SendNUIMessage({
        action = "setupMaxValues",
        values = config.variations,
    })
end

function ped:max()
    local player = GetPlayerPed(-1)

    for k,v in pairs(config.variations) do
        if (v.type == "face") then
            v.main = GetNumberOfPedDrawableVariations(player, v.id)
            v.current = ped:getVariation(k)
            v.otherCurrent = ped:getVariation(k, true)
            v.other = 6
        elseif (v.type == "hair") then
            v.main = GetNumberOfPedDrawableVariations(player, v.id)
            v.current = ped:getVariation(k)
            v.otherCurrent = ped:getVariation(k, true)
            v.other = 45
        elseif (v.type == "overlay") then
            v.main = GetNumHeadOverlayValues(v.id)
            v.current = ped:getVariation(k)
            v.otherCurrent = ped:getVariation(k, true)
            v.other = 45
        elseif (v.type == "variation") then
            v.main = GetNumberOfPedDrawableVariations(player, v.id)
            v.current = ped:getVariation(k)
            v.otherCurrent = ped:getVariation(k, true)
            v.other = GetNumberOfPedTextureVariations(player, v.id, GetPedDrawableVariation(player, v.id))
        elseif (v.type == "prop") then
            v.main = GetNumberOfPedPropDrawableVariations(player, v.id)
            v.current = ped:getVariation(k)
            v.otherCurrent = ped:getVariation(k, true)
            v.other = GetNumberOfPedPropTextureVariations(player, v.id, GetPedPropIndex(player, v.id))
        elseif (v.type == "facefeature") then
            v.main = 20
            v.current = GetPedFaceFeature(player, v.id) * 10 ~= nil and GetPedFaceFeature(player, v.id) * 10 or 0.0
        end
    end
end

function ped:getVariation(type, bool)
    if (config.skin[type]) then
        if bool then
            return config.skin[type]['other']
        else
            return config.skin[type]['main']
        end
    end

    if bool then
        return config.variations[type]['default_main']
    else
        return config.variations[type]['default_other']
    end
end

function ped:default(variation)
    if (config.variations[variation]) then
        return {
            main = config.variations[variation]['default_main'],
            other = config.variations[variation]['default_other']
        }
    end
end

function ped:ApplyVariation(variation, value, type, playerP)
    local player = playerP ~= nil and playerP or PlayerPedId()

    ped:CheckFaceF(player)

    config.skin[variation] = config.skin[variation] ~= nil and config.skin[variation] or ped:default(variation)

    if config.skin[variation] then
        if (variation == "face") then
            if (type == "main") then
                SetPedHeadBlendData(player, value, value, value, config.skin[variation]['other'], config.skin[variation]['other'], config.skin[variation]['other'])
                config.skin[variation]['main'] = value
            else
                print(value)
                SetPedHeadBlendData(player, config.skin[variation]['main'], config.skin[variation]['main'], config.skin[variation]['main'], value, value, value)
                config.skin[variation]['other'] = value
            end
        elseif (config.variations[variation]['type'] == "variation") then
            if (type == "main") then
                SetPedComponentVariation(player, config.variations[variation]['id'], value, 0)
                config.skin[variation]['main'] = value
                config.skin[variation]['other'] = 0
            else
                SetPedComponentVariation(player, config.variations[variation]['id'], config.skin[variation]['main'], value)
                config.skin[variation]['other'] = value
            end
        elseif (config.variations[variation]['type'] == "prop") then
            if value == -1 then
                ClearPedProp(player, config.variations[variation]['id'])
                config.skin[variation].main = value
            else
                if (type == "main") then
                    SetPedPropIndex(player, config.variations[variation]['id'], value, config.skin[variation]['other'], true)
                    config.skin[variation].main = value
                else
                    SetPedPropIndex(player, config.variations[variation]['id'], config.skin[variation]['main'], value, true)
                    config.skin[variation].other = value
                end
            end
        elseif (config.variations[variation]['type'] == "hair") then
            if (type == "main") then
                SetPedHairColor(player, value, config.skin[variation]['other'])
                config.skin[variation]['main'] = value
            else
                SetPedHairColor(player, config.skin[variation]['main'], value)
                config.skin[variation]['other'] = value
            end
        elseif (config.variations[variation]['type'] == "overlay") then
            if (type == "main") then
                SetPedHeadOverlay(player, config.variations[variation]['id'], value, 1.0)
                SetPedHeadOverlayColor(player, config.variations[variation]['id'], config.skin[variation]['other'], value, 0)

                config.skin[variation]['main'] = value
            else
                SetPedHeadOverlayColor(player, config.variations[variation]['id'], 1, value, 0)
                config.skin[variation]['other'] = value
            end
        elseif (config.variations[variation]['type'] == "facefeature") then
            if type == "main" then
                local newval = value
                newval = (newval)
    
                local featureType = config.variations[variation]['id']
                config.skin[variation]['main'] = newval
    
                featureType = tonumber(featureType)
                newval = tonumber(newval)

                SetPedFaceFeature(player, featureType, newval / 10)
            end
        end

        ped:changed()
    end
end

function ped:resetFace()
    for k, v in pairs(FaceFeatures) do
        local ped = GetPlayerPed(-1)
        local newval = 0.0
        local id = (k - 1)

        config.skin[v] = config.skin[v] ~= nil and config.skin[v] or {['main'] = 0.0, ['other'] = 0.0}
        config.skin[v]['main'] = newval

        SetPedFaceFeature(ped, id, config.skin[v]['main'])
    end
end

function ped:CheckFaceF(player)
    for k, v in pairs(FaceFeatures) do
        local ped = player ~= nil and player or GetPlayerPed(-1)
        local newval = 0.0
        local id = (k - 1)

        config.variations[v] = config.variations[v] ~= nil and config.variations[v] or {type = "facefeature", main = 0, id = id, default_main = 1}
        config.skin[v] = config.skin[v] ~= nil and config.skin[v] or {['main'] = 0.0, ['other'] = 0.0}
        
        --SetPedFaceFeature(ped, id, config.skin[v].main)
    end
end

function ped:LoadVariation(data, entity)
    local player = entity ~= nil and entity or PlayerPedId()

    for k,v in pairs(data) do
        ped:ApplyVariation(k, v.main, "main", player)
        ped:ApplyVariation(k, v.other, "other", player)
    end
end

function ped:getModel()
    local model = GetEntityModel(PlayerPedId())

    for k,v in pairs(config.models.male) do
        if (model == GetHashKey(v)) then
            return v
        end
    end
     
    for k,v in pairs(config.models.female) do
        if (model == GetHashKey(v)) then
            return v
        end
    end
end

function ped:save(title)
    local data  = config.skin
    local model = GetEntityModel(PlayerPedId())
    local model_name = ped:getModel()

    TriggerServerEvent("Zero:Server-ClothingV2:SaveSkin", model_name, data, title)
    TriggerServerEvent("Zero:Server-ClothingV2:SetSkin", model_name, data)

    ExecuteCommand("e adjust")
end

function ped:sort(outfits, bool)
    local _ = {}

    local gender = Zero.Functions.GetPlayerData().PlayerData.gender
    local level = Zero.Functions.GetPlayerData().Job.grade

    if outfits then
        if outfits.items then
            for k,v in pairs(outfits.items) do
                if bool then
                    if (level >= v.level and v.extra) then
                        _[#_+1] = {
                            label  = v.subtitle,
                            skindata = v['settings'][gender],
                        }
                    end
                else
                    if (level >= v.level) then
                        _[#_+1] = {
                            label  = v.subtitle,
                            skindata = v['settings'][gender],
                        }
                    end
                end
            end
        end
    end

    return _
end

function count(x)
    local _ = 0

    for k,v in pairs(x) do
        _ = _ + 1
    end

    return _
end

function ped:jobOutfit(index)
    local job = Zero.Functions.GetPlayerData().Job.name
    local gender = Zero.Functions.GetPlayerData().PlayerData.gender
    
    local outfits = config.jobOutfits[job] ~= nil and config.jobOutfits[job] or {}
    local sorted = ped:sort(outfits, clothing_extra)

    local index = tonumber(index) + 1
    local outfit = sorted[index]

    if gender == "m" then
         --ped:model("mp_m_freemode_01")
    else
        --ped:model("mp_f_freemode_01")
    end

    for k,v in pairs(outfit.skindata) do
        if (count(outfit.skindata) == 1) then
            if config.skin[k] then
                if config.skin[k]['main'] == v.main and config.skin[k]['other'] == v.other then
                    ped:ApplyVariation(k, -1, "main")
                    ped:ApplyVariation(k, 0, "other")
                else
                    ped:ApplyVariation(k, v.main, "main")
                    ped:ApplyVariation(k, v.other, "other")
                end
            else
                ped:ApplyVariation(k, v.main, "main")
                ped:ApplyVariation(k, v.other, "other")
            end
        else
            ped:ApplyVariation(k, v.main, "main")
            ped:ApplyVariation(k, v.other, "other")
        end
    end

    ExecuteCommand("e adjust")
end

function ped:setupUIclasses()
    local _ = {}

    for k,v in pairs(config.variations) do
        _[k] = false
    end

    SendNUIMessage({
        action = "SettingsClasses",
        classes = _,
    })
end

function ped:code(code, entity)
    if code then
        if (type(code) == "string") then
            local decoded = json.decode(code)

            if (type(decoded) == "table") then
                ped:LoadVariation(decoded, entity)
            end
        end
    end
end

exports("ped", function() 
    return ped
end)
