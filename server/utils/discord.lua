local function request(url)
    local result = nil

    -- Sending the HTTP request
    PerformHttpRequest("https://discord.com/api/" .. url, function(code, data, headers)
        result = {
            code = code,
            data = data,
            headers = headers
        }
    end, "GET", "",
    {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bot ".._CONFIG.Discord.Token
    })

    -- Wait for the request to complete
    while result == nil do
        Citizen.Wait(0)
    end

    return result
end

function GetUserRoles(discord)
    if not discord then return false end

    local url = "guilds/".._CONFIG.Discord.Guild.."/members/"..discord
    local result = request(url)
    if result.code ~= 200 then return false end

    local data = json.decode(result.data)
    return data.roles
end

function GetUserData(discord)
    if not discord then return false end

    local url = "v9/users/"..discord
    local result = request(url)
    if result.code ~= 200 then return false end

    local data = json.decode(result.data)
    return data
end


function IsPlayerInDiscordVoiceChannel(discord, voice, callback)

    if not discord then return callback(false) end

    local endpoint = string.format("https://discord.com/api/v9/guilds/%s/voice-states/%s", _CONFIG.Discord.Guild, discord)
    local headers = {
        ["Authorization"] = "Bot " .. _CONFIG.Discord.Token,
        ["Content-Type"] = "application/json"
    }

    PerformHttpRequest(endpoint, function(statusCode, response)
        if statusCode == 200 and response then
            local data = json.decode(response)
            callback(data.channel_id and data.channel_id == voice)
        else
            callback(false)
        end
    end, 'GET', "", headers)
end