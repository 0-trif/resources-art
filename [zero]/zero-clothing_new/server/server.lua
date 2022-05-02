local cache = {}

RegisterServerEvent('Zero:Server-ClothingV2:SetSkin')
AddEventHandler('Zero:Server-ClothingV2:SetSkin', function(model, data)
    local src = source
    local Player = Zero.Functions.Player(src)

    Player.Functions.SetSkin({
        model = model,
        skindata = data,

    })
end)

RegisterServerEvent('Zero:Server-ClothingV2:SaveSkin')
AddEventHandler('Zero:Server-ClothingV2:SaveSkin', function(model, data, label)
    local src = source
    local Player = Zero.Functions.Player(src)
    local CID = Player.User.Citizenid
    
    cache[CID] = cache[CID] ~= nil and cache[CID] or {}

    local id = math.random(11111, 99999) .. "-" .. CID .. "" .. math.random(11, 999)

    Zero.Functions.ExecuteSQL(false, "INSERT INTO `outfits` (`citizenid`, `index`, `model`, `skindata`, `label`) VALUES (?, ?, ?, ?, ?)", {
        CID,
        id,
        model,
        json.encode(data),
        label,
    })

    cache[CID][#cache[CID]+1] = {
        model = model,
        skindata = data,
        label = label,
        index = id,
        citizenid = CID,
    }

    TriggerClientEvent("Zero:Client-ClothingV2:LoadSkins", src, cache[CID])
end)

RegisterServerEvent('Zero:Server-ClothingV2:LoadSkins')
AddEventHandler('Zero:Server-ClothingV2:LoadSkins', function()
    local src = source
    local Player = Zero.Functions.Player(src)
    local CID = Player.User.Citizenid
    
    if cache[CID] then 
        TriggerClientEvent("Zero:Client-ClothingV2:LoadSkins", src, cache[CID])
    else
        cache[CID] = {}
        Zero.Functions.ExecuteSQL(true, "SELECT * FROM `outfits` WHERE `citizenid` = ?", {
            CID,
        }, function(outfits)
            for k,v in pairs(outfits) do
                cache[CID][#cache[CID]+1] = v
                cache[CID][#cache[CID]].skindata = json.decode(v.skindata)
            end

            TriggerClientEvent("Zero:Client-ClothingV2:LoadSkins", src, cache[CID])
        end)
    end
end)

RegisterServerEvent('Zero:Server-ClothingV2:DeleteSkin')
AddEventHandler('Zero:Server-ClothingV2:DeleteSkin', function(index)
    local src = source
    local Player = Zero.Functions.Player(src)
    local CID = Player.User.Citizenid
    
    Zero.Functions.ExecuteSQL(false, "DELETE FROM `outfits` WHERE `index`= ?", {
        index,
    })
    if cache[CID] then
        for k,v in pairs(cache[CID]) do
            if v.index == index then
                table.remove(cache[CID], k)
                TriggerClientEvent("Zero:Client-ClothingV2:LoadSkins", src, cache[CID])
                return
            end
        end
    end
end)