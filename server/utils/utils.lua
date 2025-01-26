function GetLicense(id)
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            return v
        end
    end
    return "license:000000000000000000000000000000000000"
end

function GetSteam(id)
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            return v
        end
    end
    return "steam:00000000000000000"
end

function GetLive(id) 
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "live") then
            return v
        end
    end
    return "live:00000000000000000"
end

function GetXbl(id) 
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "xbl") then
            return v
        end
    end
    return "xbl:00000000000000000"
end

function GetPlayerTag(id)
    if GetPlayerName(id) then
        return GetPlayerName(id)
    end
    return "unvalid"
end
function GetIp(id) 
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "ip") then
            return v
        end
    end
    return "ip:00000000000000000"
end

function GetDiscord(id)
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "discord") then
            return v
        end
    end
    return "discord:000000000000000000"
end



function PlayersIdentifierToString(source)
    local identifiers = GetPlayerIdentifiers(source)
    local cb = ""
    for _, v in pairs(identifiers) do
        cb = cb..v.."\n"
    end
    return cb
end

function GetPlayerFromLicenseIfExist(license)
    local players = GetPlayers()
    for k,v in pairs(players) do
        local ids = GetPlayerIdentifiers(v)
        for _,i in pairs(ids) do
            if i == license then    
                return v
            end
        end
    end
    return false
end

function PlayersIdentifierToString(source)
    local identifiers = GetPlayerIdentifiers(source)
    local cb = ""
    for _, v in pairs(identifiers) do
        cb = cb..v.."\n"
    end
    return cb
end

function GetPlayerFromLicenseIfExist(license)
    local players = GetPlayers()
    for k,v in pairs(players) do
        local ids = GetPlayerIdentifiers(v)
        for _,i in pairs(ids) do
            if i == license then    
                return v
            end
        end
    end
    return false
end





-- Events utils

RegisterNetEvent("DeleteEntity")
AddEventHandler("DeleteEntity", function(token, table)
    if CheckPlayerToken(source, token) then
        for k,v in pairs(table) do
            DeleteEntity(NetworkGetEntityFromNetworkId(v))
        end
    end
end)



exports('getDiscord', function(id)
    return GetDiscord(id)
end)