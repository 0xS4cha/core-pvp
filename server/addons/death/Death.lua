
--Detection mort
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

       --#TODO: fais la logs 
       --SendDiscordLog("killPlayer", source, string.sub(GetDiscord(source), 9, -1), src:getLastname() .. " ".. src:getFirstname(), json.encode(causeDeath), posVictime, data.killerServerId, string.sub(GetDiscord(data.killerServerId), 9, -1), target:getLastname() .. " " .. target:getFirstname(), weapon, posKiller, data.distance)

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
                name = GetPlayerName(id),
                vip  = vip
            }
        end
        
    end)
end)