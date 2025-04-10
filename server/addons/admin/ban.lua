Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end
    RegisterServerCallback("core:admin:getBan", function(source, token)
        if CheckPlayerToken(source, token) then
            local banlisted
            MySQL.Async.fetchAll("SELECT * FROM blacklist", {}, function(result)
                banlisted = result
            end)
            while banlisted == nil do Wait(100) end
            return banlisted
            --end
        end
    end)
end)


BanList = {}
banned = {}
BannedTokens = {}
function ActualizeAllBanList()
    MySQL.Async.fetchAll("SELECT * FROM blacklist", {}, function(result)
        if #result ~= #BanList then
            BanList = {}
            BannedTokens = {}
            for i = 1, #result do
                table.insert(BanList, {
                    ID = result[i].id,
                    license = result[i].GameLicense,
                    identifier = result[i].Steam,
                    playerName = result[i].playerName,
                    bannerName = result[i].Banner,
                    liveid = result[i].live,
                    xblid = result[i].xbl,
                    discord = result[i].DiscordUID,
                    playerip = result[i].ip,
                    Expiration = result[i].Expiration,
                    reason = result[i].reason,
                    image = result[i].image
                })
                local TokenBan = json.decode(result[i].Token)
                if TokenBan ~= nil then
                    for k, v in ipairs(TokenBan) do
                        table.insert(BannedTokens, v)
                    end
                end
            end
            Logger:info('CORE', "Actualize banlist")
        end
    end)
end

CreateThread(function()
    ActualizeAllBanList()
    Wait(5000)
    while true do
        ActualizeAllBanList()
        Wait(_CONFIG.RefreshBanList * 1000)
    end
end)

RegisterNetEvent('core:admin:banoffline', function(token, uuid, raison, time, type)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source) ~= nil then
            local xPlayer = GetPlayer(source)
            if xPlayer:getPermission() < _PERMISSION['BAN'] then
                return
            end

            if GetPlayerFromId(uuid) ~= nil then
                TriggerClientEvent('core:ShowNotification', source, GetPhrase('cant_is_online'))
                return
            end
            local TargetInformation = GetPlayerBddFromId(uuid)
            type = string.lower(type)

            if type == "hours" then
                time = time * 3600
            elseif type == "days" then
                time = time * 86400
            elseif type == "perm" then
                time = 0
            end
            local expiration = time
            if expiration < os.time() and type ~= "perm" then
                expiration = os.time() + expiration
            end
            if not raison then
                raison = 'Aucune raison'
            end
            local dataOfBan = os.date("%d/%m/%Y %X")

            MySQL.Async.insert(
                'INSERT INTO blacklist (Steam, playerName, DiscordUID, DiscordTag, GameLicense, ip, xbl, live,  reason, Date, Expiration, Banner, Token) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                {
                    TargetInformation.identifier,
                    TargetInformation.playerName,
                    TargetInformation.discord,
                    '<@' .. TargetInformation.discord .. '>',
                    TargetInformation.license,
                    TargetInformation.playerip,
                    TargetInformation.xblid,
                    TargetInformation.liveid,
                    raison,
                    dataOfBan,
                    expiration,
                    GetPlayerTag(source),
                    json.encode({})
                }, function(affectedRows)
                    
                   TriggerClientEvent('core:ShowNotification', source, GetPhrase('ADMIN_BANNED_ADMIN', TargetInformation.playerName, raison))
                    Logger:info('CORE', "Ban " .. TargetInformation.playerName .. " for " .. raison)
                    ActualizeAllBanList()
                end)
        end
    end
end)
RegisterNetEvent("core:admin:ban")
AddEventHandler('core:admin:ban', function(token, target, raison, time, type)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source) ~= nil then
            local xPlayer = GetPlayer(source)
            if xPlayer:getPermission() < _PERMISSION['BAN'] then
                return
            end

            local xTarget = GetPlayer(target)

            type = string.lower(type)

            if type == "hours" then
                time = time * 3600
            elseif type == "days" then
                time = time * 86400
            elseif type == "perm" then
                time = 0
            end
            local expiration = time
            if expiration < os.time() and type ~= "perm" then
                expiration = os.time() + expiration
            end
            if not raison then
                raison = 'Aucune raison'
            end
            if xPlayer:getPermission() <= xTarget:getPermission() and not _CONFIG.Debug then
                TriggerClientEvent('core:ShowNotification', source, GetPhrase('ADMIN_CANT_BAN'))
                return
            end
            local dataOfBan = os.date("%d/%m/%Y %X")
            local token = {}
            token[GetDiscord(target)] = {}

            for i = 0, GetNumPlayerTokens(target) do
                table.insert(token[GetDiscord(target)], GetPlayerToken(target, i))
            end

            MySQL.Async.insert(
                'INSERT INTO blacklist (Steam, playerName, DiscordUID, DiscordTag, GameLicense, ip, xbl, live,  reason, Date, Expiration, Banner, Token) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                {
                    GetSteam(target),
                    GetPlayerTag(target),
                    GetDiscord(target),
                    '<@' .. GetDiscord(target) .. '>',
                    GetLicense(target),
                    GetIp(target),
                    GetXbl(target),
                    GetLive(target),
                    raison,
                    dataOfBan,
                    expiration,
                    _PERMISSION_ROLE[xPlayer:getPermission()].prefix..' - '..xPlayer:getPlayerName(),
                    json.encode(token)
                }, function(affectedRows)
                    TriggerClientEvent('core:ShowNotification', source, GetPhrase('ADMIN_BANNED_ADMIN', GetPlayerTag(target), raison))
                    local targetName = xTarget:getPlayerName() 
                    DropPlayer(target,"A component of your computer is preventing you from being able to play FiveM.\nPlease wait out your original ban (expiring in 21 days + 23:59:55) to be able to play FiveM.\nThe associated correlation ID is 78e546-cgh8j-478Jd-c832-dax9246_01cd.")

                    Logger:info('CORE', "Ban " .. targetName .. " for " .. raison)
                    ActualizeAllBanList()
                end)
        end
    end
end)
RegisterNetEvent("core:admin:anticheat")
AddEventHandler('core:admin:anticheat', function(reason, src, type, img)
    local _source = source
    local UUID = 0
    if _source == nil or _source == 0 or _source == '' then
        _source = src
    end
    local xTarget = GetPlayer(_source)
    if xTarget ~= nil then
        UUID = xTarget:getId()
        if _PERMISSION['ANTICHEAT'] < xTarget:getPermission() then
            return
        end
    end
    local time = os.date()
    local token = {}
    token[GetDiscord(_source)] = {}
 
    for i = 0, GetNumPlayerTokens(_source) do
        table.insert(token[GetDiscord(_source)], GetPlayerToken(_source, i))
    end

    MySQL.Async.insert(
        'INSERT INTO blacklist (Steam, playerName, DiscordUID, DiscordTag, GameLicense, ip, xbl, live,  reason, Date, Banner, Expiration, Token, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        {
            GetSteam(_source),
            GetPlayerTag(_source),
            GetDiscord(_source),
            '<@' .. GetDiscord(_source):gsub("discord:", "") .. '>',
            GetLicense(_source),
            GetIp(_source),
            GetXbl(_source),
            GetLive(_source),
            reason,
            time,
            'Anticheat',
            0,
            json.encode(token),
            img or ''
        }, function(affectedRows)
            local name = GetPlayerName(_source) or 'unknow'
   
            Logger:info('CORE', "Ban " .. name .. " for Anticheat")
            if type ~= nil then
                if img ~= nil then

                    SendDiscordLogImage('screenshot_anticheat', _source, img, UUID, 'Ban', name, reason, affectedRows, GetDiscord(_source):gsub("discord:", ""),  img )
                    SendDiscordLogImage(type, _source, img, UUID, 'Ban', name, reason, affectedRows, GetDiscord(_source):gsub("discord:", ""),  img )
                else
                    SendDiscordLog(type, _source, 'Ban', name, reason, affectedRows, GetDiscord(_source):gsub("discord:", ""), UUID, GetLicense(_source), 'No Image')
                end
            end
            DropPlayer(_source, "A component of your computer is preventing you from being able to play FiveM.\nPlease wait out your original ban (expiring in 21 days + 23:59:55) to be able to play FiveM.\nThe associated correlation ID is 78e546-cgh8j-478Jd-c832-dax9246_01cd.")

            ActualizeAllBanList()
        end)
end)

RegisterNetEvent("core:admin:unban")
AddEventHandler('core:admin:unban', function(token, banId, name)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source) ~= nil then
            local xPlayer = GetPlayer(source)

            if xPlayer:getPermission() >= _PERMISSION['UNBAN'] then
                MySQL.Async.fetchAll("SELECT * FROM blacklist WHERE id = ?", {banId}, function(result)
                    result = result[1]
                    MySQL.Async.execute('DELETE FROM blacklist WHERE id = ?', { banId })
                    TriggerClientEvent('core:ShowNotification', source, GetPhrase('ADMIN_REVOKE_BAN', name))
                    SendDiscordLog('unban_admin', source)
                    ActualizeAllBanList()
                end)
            end
        end
    end
end)

