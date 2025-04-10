
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



        SendDiscordLog('kill', source, src:getId(), string.sub(GetDiscord(src:getSource()), 9, -1), src:getPlayerName(),
            json.encode(causeDeath), target:getSource(), target:getId(),
            string.sub(GetDiscord(target:getSource()), 9, -1), target:getPlayerName())
    else
        SendDiscordLog('death', source, src:getId(), string.sub(GetDiscord(source), 9, -1), src:getPlayerName(),
            data.deathCause)
    end
end)
