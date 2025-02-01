local InteractDeath = {}
RegisterNetEvent("core:onPlayerDeath")
AddEventHandler('core:onPlayerDeath', function(data)
    local source = source
    local src = GetPlayer(source)
    local weapon = data.deathCause
    local posVictime = vector3(data.victimCoords.x, data.victimCoords.y, data.victimCoords.z)
    if data.killedByPlayer then 
        local target = GetPlayer(data.killerServerId)
        local causeDeath = data.causeDeath
        local posKiller = vector3(data.killerCoords.x, data.killerCoords.y, data.killerCoords.z)
        GiveItemToPlayer(target:getSource(), 'money', 2500)
        MySQL.Async.execute("UPDATE players SET death = death + 1 WHERE license = ? AND id = ?",{src:getLicense(), src:getId()}, function() end)
        MySQL.Async.execute("UPDATE players SET kills = kills + 1 WHERE license = ? AND id = ?",{target:getLicense(), target:getId()}, function() end)
        TriggerClientEvent('core:ShowAdvancedNotification', target:getSource(), GetPhrase('newkill'), GetPhrase('KillerNotification', src:getId(), source), GetPhrase('KillerMsg', src:getPlayerName()), 'CHAR_ARTHUR', 'CHAR_ARTHUR')
        SendDiscordLog('kill', source, src:getId(), string.sub(GetDiscord(src:getSource()), 9, -1), src:getPlayerName(), json.encode(causeDeath), target:getSource(), target:getId(), string.sub(GetDiscord(target:getSource()), 9, -1), target:getPlayerName())
 
    else
        MySQL.Async.execute("UPDATE players SET death = death + 1 WHERE license = ? AND id = ?",{src:getLicense(), src:getId()}, function() end)
        SendDiscordLog('death', source, src:getId(), string.sub(GetDiscord(source), 9, -1), src:getPlayerName(), data.deathCause)
    end
end)

RegisterNetEvent('core:interact:death', function(token, target)
    local source = source
    if CheckPlayerToken(source, token) then
        local p = GetPlayer(source)
        local t = GetPlayer(target)
        if p and t then
            if InteractDeath[target] then
                local remove = RemoveItemToPlayer(source, 'medikit', 1)

                if remove then

                    TriggerClientEvent('core:StealPlayer', target)
                end
            end
        end
    end
end)
RegisterNetEvent("core:death:RequestUnregister")
AddEventHandler('core:death:RequestUnregister', function(Token)
    local source = source
    if CheckPlayerToken(source, Token) then
        InteractDeath[source] = nil
        TriggerClientEvent('core:death:UnregisterInteract', -1, source)
    end
end)
RegisterNetEvent("core:death:RequestInteract")
AddEventHandler('core:death:RequestInteract', function(Token)
    local source = source
    if CheckPlayerToken(source, Token) then
        InteractDeath[source] = true
        TriggerClientEvent('core:death:RegisterInteract', -1, source)
    end
end)
function GetDiscordId(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, "discord") then
            return string.gsub(identifier, "discord:", "" )
        end
    end
    return nil
end


Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end
    RegisterServerCallback("core:getKillerInformation", function(source, token, id)
        if CheckPlayerToken(source, token) then

            local discord = GetDiscordId(id)
            local data = GetUserData(discord) 
            local imgURL = _CONFIG.LOGO_LINK
            local killerPlayr = GetPlayer(id)
            local vip = false
            if killerPlayr then
                vip = killerPlayr:getVip()
            end
            if data then
                if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
                    imgURL = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".gif";
                else 
                    imgURL = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".png"
                end
            end
            return {
                logo = imgURL,
                name = ("%s - %s"):format(killerPlayr:getId(), GetPlayerName(id)),
                vip  = vip
            }
        end
        
    end)
end)