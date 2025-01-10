
function SendDiscordLog(type, source, ...)
    --print(type, logs[type].text, source)
    if logs[type] ~= nil and isProduction then
        text        = string.format(logs[type].text, source, ...)
        color       = logs[type].color
        local url   = url
        local embed = {
            {
                ["color"] = color,
                ["title"] = logs[type].title,

                ["description"] = text,
                ["footer"] = {
                    ["text"] = os.date("%Y/%m/%d %X"),
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.png",

                },
            }
        }
        PerformHttpRequest(logs[type].hook, function(err, text, headers) end, 'POST',
            json.encode({ username = "LOG", embeds = embed,
                avatar_url = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.png" })
            , { ['Content-Type'] = 'application/json' })
    end
end
