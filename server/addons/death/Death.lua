
--Detection mort
RegisterNetEvent("core:onPlayerDeath")
AddEventHandler('core:onPlayerDeath', function(data)
    local source = source
    local src = GetPlayer(source)
    local weapon = data.deathCause
    local posVictime = vector3(data.victimCoords.x, data.victimCoords.y, data.victimCoords.z)
    print(json.encode(data))
    if data.killedByPlayer then 
        local target = GetPlayer(data.killerServerId)
        local causeDeath = data.causeDeath
        local posKiller = vector3(data.killerCoords.x, data.killerCoords.y, data.killerCoords.z)

       --#TODO: fais la logs 
       --SendDiscordLog("killPlayer", source, string.sub(GetDiscord(source), 9, -1), src:getLastname() .. " ".. src:getFirstname(), json.encode(causeDeath), posVictime, data.killerServerId, string.sub(GetDiscord(data.killerServerId), 9, -1), target:getLastname() .. " " .. target:getFirstname(), weapon, posKiller, data.distance)

    end

end)