function SendDiscordLog(type, source, ...)
    if _LOGS[type] ~= nil then
        text        = string.format(_LOGS[type].text, source, ...)
        color       = _LOGS[type].color
        local url   = url
        local embed = {
            {
                ["color"] = color,
                ["title"] = _LOGS[type].title,

                ["description"] = text,
                ["footer"] = {
                    ["text"] = os.date("%Y/%m/%d %X"),
                    ["icon_url"] = "https://sacha-dev.fr/ldo_logo.PNG",

                },
            }
        }
        if _LOGS[type].player then
            local p = GetPlayer(source)
            embed = {
                {
                    ["color"] = color,
                    ["title"] = _LOGS[type].title,
    
                    ["description"] = ('%s\n\n```💾 Information du joueur :```'):format(text),
                    ['fields'] = {
                        {
                            ['name'] = 'Discord',
                            ['value'] = ('<@%s>'):format(string.sub(GetDiscord(source), 9, -1)),
                        },
                        {
                            ['name'] = 'TempID',
                            ['value'] = ('```%s```'):format(source),
                        },
                        {
                            ['name'] = 'UUID',
                            ['value'] = ('```%s```'):format(p:getId()),
                        },
                        {
                            ['name'] = 'Pseudo',
                            ['value'] = ('```%s```'):format(p:getPlayerName()),
                        },
                    },

                    ["footer"] = {
                        ["text"] = os.date("%Y/%m/%d %X"),
                        ["icon_url"] = "https://sacha-dev.fr/ldo_logo.PNG",
    
                    },
                }
            }
        end
        PerformHttpRequest(_LOGS[type].hook, function(err, text, headers) end, 'POST',
            json.encode({
                username = "LOG",
                embeds = embed,
                avatar_url = "https://sacha-dev.fr/ldo_logo.PNG"
            })
            , { ['Content-Type'] = 'application/json' })
    else
        Logger:warn('CORE', "Webhook not found for type: " .. type)
    end
end

function SendDiscordLogImage(type, source, url, ...)
    if _LOGS[type] ~= nil then
        text        = string.format(_LOGS[type].text, source, ...)
        color       = _LOGS[type].color
        local url   = url
        local embed = {
            {
                ["color"] = color,
                ["title"] = _LOGS[type].title,

                ["description"] = text,
                ["footer"] = {
                    ["text"] = os.date("%Y/%m/%d %X"),
                    ["icon_url"] = "https://sacha-dev.fr/ldo_logo.PNG",

                },
                ["image"] = {
                    ["url"] = url,
                }


            }
        }
        PerformHttpRequest(_LOGS[type].hook, function(err, text, headers) end, 'POST',
            json.encode({
                username = "LOG",
                embeds = embed,
                avatar_url = "https://sacha-dev.fr/ldo_logo.PNG"
            })
            , { ['Content-Type'] = 'application/json' })
    else
        Logger:warn('CORE', "Webhook not found for type: " .. type)
    end
end

function SendDiscordLogVideo(type, source, url, ...)
    if _LOGS[type] ~= nil then
        text        = string.format(_LOGS[type].text, source, ...)
        color       = _LOGS[type].color
        local url   = url
        local embed = {
            {
                ["color"] = color,
                ["title"] = _LOGS[type].title,

                ["description"] = text,
                ["footer"] = {
                    ["text"] = os.date("%Y/%m/%d %X"),
                    ["icon_url"] = "https://sacha-dev.fr/ldo_logo.PNG",

                },

            }
        }
        PerformHttpRequest(_LOGS[type].hook, function(err, text, headers) end, 'POST',
        json.encode({
            username = "LOG",
            content = url,
            avatar_url = "https://sacha-dev.fr/ldo_logo.PNG"
            
        })
        , { ['Content-Type'] = 'application/json' })
        Wait(100)
        PerformHttpRequest(_LOGS[type].hook, function(err, text, headers) end, 'POST',
            json.encode({
                username = "LOG",
                embeds = embed,
                avatar_url = "https://sacha-dev.fr/ldo_logo.PNG"
            })
            , { ['Content-Type'] = 'application/json' })
    else
        Logger:warn('CORE', "Webhook not found for type: " .. type)
    end
end
