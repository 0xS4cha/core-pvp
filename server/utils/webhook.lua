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
        PerformHttpRequest(_LOGS[type].hook, function(err, text, headers) end, 'POST',
            json.encode({
                username = "LOG",
                embeds = embed,
                avatar_url = "https://sacha-dev.fr/ldo_logo.PNG"
            })
            , { ['Content-Type'] = 'application/json' })
    else
        Console.Warn("Webhook not found for type: " .. type)
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
        Console.Warn("Webhook not found for type: " .. type)
    end
end
