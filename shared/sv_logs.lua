_LOGS = {
    ["connexion"] = {
        hook = "https://discord.com/api/webhooks/1203114300286439424/BEXkC3BePt0IkIlbH852E7gjUa274ABwz-cDHxcHMhLINZ6s2WglEYM1zUtBsTkmILPW",--
        color = 0x03fc20,
        title = "Connexion",
        text = "Id du joueur: **%d**\nDiscord: <@%s>\nNom prénom RP: **%s**\nIdenfiants:\n%s",
    },
    ["deconnexion"] = {
        hook = "https://discord.com/api/webhooks/1203114300286439424/BEXkC3BePt0IkIlbH852E7gjUa274ABwz-cDHxcHMhLINZ6s2WglEYM1zUtBsTkmILPW",--
        color = 0xf44336,
        title = "Déconnexion",
        text = "Id du joueur: **%d**\nDiscord: <@%s>\nNom prénom RP: **%s**\nRaison: **%s**\nIdenfiants:\n%s",
    },

    ["screenshot_admin"] = {
        hook = "https://discord.com/api/webhooks/1203114300286439424/BEXkC3BePt0IkIlbH852E7gjUa274ABwz-cDHxcHMhLINZ6s2WglEYM1zUtBsTkmILPW",--
        color = 0x03fc20,
        title = "Screen Admin",
        text = "Id du joueur: %d\nLicense du joueur: %s\nImage: \n%s \nScreen fait par: %s",
    },

    
    ["screenshot_anticheat"] = {
        hook = "https://discord.com/api/webhooks/1203114300286439424/BEXkC3BePt0IkIlbH852E7gjUa274ABwz-cDHxcHMhLINZ6s2WglEYM1zUtBsTkmILPW",--
        color = 0x03fc20,
        title = "Screen Anticheat",
        text = "Punishment Method: %s\nReason: %s\nBan ID: %s\nDiscord: <@%s>\nUUID: %d\nLicense: %s\nImage: \n%s\n",
    },
}


function SendDiscordLog(type, source, ...)
    --print(type, logs[type].text, source)
    if _LOGS[type] ~= nil  then
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
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.png",

                },
            }
        }
        PerformHttpRequest(_LOGS[type].hook, function(err, text, headers) end, 'POST',
            json.encode({ username = "LOG", embeds = embed,
                avatar_url = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.png" })
            , { ['Content-Type'] = 'application/json' })
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
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.png",

                },
                ["image"] = {
                    ["url"] = url,
                } 


            }
        }
        PerformHttpRequest(_LOGS[type].hook, function(err, text, headers) end, 'POST',
            json.encode({ username = "LOG", embeds = embed,
                avatar_url = "https://cdn.discordapp.com/attachments/791407719948091442/1010676021063843850/server_icon.png" })
            , { ['Content-Type'] = 'application/json' })
    end
end
