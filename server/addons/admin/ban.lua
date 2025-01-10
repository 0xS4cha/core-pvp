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
                })
                local TokenBan = json.decode(result[i].Token)
                if TokenBan ~= nil then
                    for k, v in ipairs(TokenBan) do
                        table.insert(BannedTokens, v)
                    end
                end
            end
            Console.Success("Actualize banlist")
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


RegisterNetEvent("core:admin:ban")
AddEventHandler('core:admin:ban', function(token, target, raison, time, type)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source) ~= nil then
            local xPlayer = GetPlayer(source)
            local xTarget = GetPlayer(target)

            type = string.lower(type)

            if type == "heures" then
                time = time * 3600
            elseif type == "jours" then
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
                TriggerClientEvent('core:ShowNotification', source, "You can't ban this player.")
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
                    GetPlayerTag(source),
                    json.encode(token)
                }, function(affectedRows)
                    TriggerClientEvent('core:ShowNotification', source, "You have just banned ~g~<C>" .. GetPlayerTag(target) .. "</C>~s~ for ~g~<C>" .. raison .. "~s~</C>.")
                    local targetName = xTarget:getPlayerName() 
                    DropPlayer(target,
                        "A component of your computer is preventing you from being able to play FiveM.\nPlease wait out your original ban (expiring in 21 days + 23:59:55) to be able to play FiveM.\nThe associated correlation ID is 78e546-cgh8j-478Jd-c832-dax9246_01cd.")

                    Console.Success("Ban " .. targetName .. " for " .. raison)
                    ActualizeAllBanList()
                end)
        end
    end
end)
RegisterNetEvent("core:admin:anticheat")
AddEventHandler('core:admin:anticheat', function(reason, src, type)
    local _source = source
    if _source == nil or _source == 0 or _source == '' then
        _source = src
    end
    local xTarget = GetPlayer(_source)
    if _PERMISSION['anticheat'] < xTarget:getPermission() then
        return
    end
    local time = os.date()
    local token = {}
    token[xTarget:getDiscord()] = {}

    for i = 0, GetNumPlayerTokens(_source) do
        table.insert(token[xTarget:getDiscord()], GetPlayerToken(_source, i))
    end

    MySQL.Async.insert(
        'INSERT INTO blacklist (Steam, playerName, DiscordUID, DiscordTag, GameLicense, ip, xbl, live,  reason, Date, Banner, Expiration, Token) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        {
            GetSteam(_source),
            GetPlayerTag(_source),
            GetDiscord(_source),
            '<@' .. GetDiscord(_source) .. '>',
            GetLicense(_source),
            GetIp(_source),
            GetXbl(_source),
            GetLive(_source),
            reason,
            time,
            'Anticheat',
            0,
            json.encode(token)
        }, function(affectedRows)
            local name = (xTarget:getSource() or GetPlayerName(_source)) or 'unknow'
            local data = {
                discord = GetDiscord(_source),
                license = GetLicense(_source)
            }
            TriggerClientEvent('core:admin:GetScreenShot', _source, data, reason, 'ban', affectedRows, type)
            Console.Success("Ban " .. name .. " for Anticheat")
            DropPlayer(xTarget:getSource(),
                "A component of your computer is preventing you from being able to play FiveM.\nPlease wait out your original ban (expiring in 21 days + 23:59:55) to be able to play FiveM.\nThe associated correlation ID is 78e546-cgh8j-478Jd-c832-dax9246_01cd.")

            ActualizeAllBanList()
        end)
end)

RegisterNetEvent("core:admin:unban")
AddEventHandler('core:admin:unban', function(token, banId, name)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source) ~= nil then
            local xPlayer = GetPlayer(source)

            if xPlayer:getPermission() >= _PERMISSION['UNBAN'] then
                MySQL.Async.execute('DELETE FROM blacklist where id = ?', { banId })
                TriggerClientEvent('core:ShowNotification', source,
                    "You have just revoked the ban of: ~g~<C>" .. name .. "</C>~s~.")
            end
        end
    end
end)

