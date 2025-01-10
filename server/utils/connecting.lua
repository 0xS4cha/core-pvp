

function CheckTimeRemaning(time, key)
    local d = 0
    local h = 0
    local m = 0
    local unban = false

    if tonumber(time) ~= 0 then
        if (tonumber(time)) > os.time() then
            local tempsrestant = (((tonumber(time)) - os.time()) / 60)
            if tempsrestant >= 1440 then
                local day = (tempsrestant / 60) / 24
                local hrs = (day - math.floor(day)) * 24
                local minutes = (hrs - math.floor(hrs)) * 60
                d = math.floor(day)
                h = math.floor(hrs)
                m = math.ceil(minutes)
            elseif tempsrestant >= 60 and tempsrestant < 1440 then
                local day = (tempsrestant / 60) / 24
                local hrs = tempsrestant / 60
                local minutes = (hrs - math.floor(hrs)) * 60
                d = math.floor(day)
                h = math.floor(hrs)
                m = math.ceil(minutes)
            elseif tempsrestant < 60 then
                d = 0
                h = 0
                m = math.ceil(tempsrestant)
            end
        else
            unban = true
            MySQL.Async.execute('DELETE FROM blacklist where id = ?', { key })
        end
    end
    return unban, d, h, m
end


BanList = {}
BannedTokens = {}
AddEventHandler('playerConnecting', function(name, skr, data)
    _source = source
    local steamid = nil
    local license = nil
    local discord = nil
    local ip = nil
    local xbl = nil
    local live = nil
    PlayerTokens = {}
    banned = {}
    data.defer()
        if #BanList <= 0 then
        data.presentCard([==[{"type":"AdaptiveCard","version":"1.0","body":[{"type":"ColumnSet","columns":[{"type":"Column","width":"auto","items":[{"type":"Image","altText":"","url":"https://cdn.discordapp.com/attachments/1018546650668605460/1117940194595844136/ylcv2.png","size":"Medium"}]},{"type":"Column","width":"stretch","items":[{"type":"TextBlock","text":"Admin","weight":"Bolder","size":"Medium"},{"type":"TextBlock","text":"Blacklist"}]}]},{"type":"TextBlock","text":"Serveur en cours d'initialisation.","size":"Medium","weight":"Lighter"}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json"}]==], function(data, rawData)
        end)
        CancelEvent()
        return
    end
    data.presentCard([==[{"type":"AdaptiveCard","version":"1.0","body":[{"type":"ColumnSet","columns":[{"type":"Column","width":"auto","items":[{"type":"Image","altText":"","url":"https://cdn.discordapp.com/attachments/1018546650668605460/1117940194595844136/ylcv2.png","size":"Medium"}]},{"type":"Column","width":"stretch","items":[{"type":"TextBlock","text":"Admin","weight":"Bolder","size":"Medium"},{"type":"TextBlock","text":"Blacklist"}]}]},{"type":"TextBlock","text":"Initialisation de la connexion au proxy..","size":"Medium","weight":"Lighter"}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json"}]==], function(data, rawData)
    end)
    for i = 0, GetNumPlayerIdentifiers(_source) - 1 do
        local id = GetPlayerIdentifier(_source, i)
        if string.find(id, "steam") then
            steamid = id
        elseif string.find(id, "license") then
            license = id
        elseif string.find(id, "ip") then
            ip = id
        elseif string.find(id, "discord") then
            discord = id
        elseif string.find(id, "xbl") then
            xbl = id
        elseif string.find(id, "live") then
            live = id
        end
    end
    Wait(1000)
    if not license or license == "" or license == nil or not ip then
        data.presentCard([==[{"type":"AdaptiveCard","version":"1.0","body":[{"type":"ColumnSet","columns":[{"type":"Column","width":"auto","items":[{"type":"Image","altText":"","url":"https://cdn.discordapp.com/attachments/1018546650668605460/1117940194595844136/ylcv2.png","size":"Medium"}]},{"type":"Column","width":"stretch","items":[{"type":"TextBlock","text":"Admin","weight":"Bolder","size":"Medium"},{"type":"TextBlock","text":"Blacklist"}]}]},{"type":"TextBlock","text":"License invalide.","size":"Medium","weight":"Lighter"}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json"}]==], function(data, rawData)
        end)
        CancelEvent()
        return
    end
    PlayerTokens[ip] = {}
    for i = 0, GetNumPlayerTokens(_source) do
        table.insert(PlayerTokens[ip], GetPlayerToken(_source, i))
    end
    banned[ip] = {}
    local reason = nil
    local nameBan = ""
    local nameBanner = ""
    local BanId = 0
    local timeRimaing = ""
    Wait(500)
    for i = 1, #BanList, 1 do
		if ((tostring(BanList[i].license)) == tostring(license) or (tostring(BanList[i].discord)) == tostring(discord) or (tostring(BanList[i].playerip)) == tostring(ip)) then

            local unban, d, h, m = CheckTimeRemaning(BanList[i].Expiration, BanList[i].ID)
            if unban then
                banned[ip] = false
                break
            end
            banned[ip] = true
            reason = BanList[i].reason
            nameBan = BanList[i].playerName
            nameBanner = BanList[i].bannerName
            BanId = BanList[i].ID
            timeRimaing = ('%s Days %s Hours %s Minutes'):format(d, h, m)
            MySQL.Async.execute(
                'UPDATE blacklist SET Token = @Token, GameLicense = @license, DiscordUID = @discord WHERE id = @id', {
                    ["@Token"] = json.encode(PlayerTokens[ip]),
                    ["@license"] = license,
                    ["@discord"] = discord,
                    ["@id"] = BanList[i].ID,
                }
            )
            break
        else
            banned[ip] = false
		end
	end
    if not banned[ip] then 
        if json.encode(BannedTokens) ~= "[]" then 
            for i = 1, #BanList, 1 do
                for z = 1, #BannedTokens, 1 do
                    for c = 1, #PlayerTokens[ip], 1 do
                        if BannedTokens and PlayerTokens then 
                            if BannedTokens[z] ~= nil and PlayerTokens[ip][c] ~= nil then 
                                if BannedTokens[z] == PlayerTokens[ip][c] then

                                    local unban, d, h, m = CheckTimeRemaning(BanList[i].Expiration, BanList[i].ID)
                                    if unban then
                                        banned[ip] = false
                                        break
                                    end
                                    banned[ip] = true
                                    reason = BanList[i].reason
                                    nameBan = BanList[i].playerName
                                    nameBanner = BanList[i].bannerName
                                    BanId = BanList[i].ID
                                    timeRimaing = ('%s Days %s Hours %s Minutes'):format(d, h, m)
                                    MySQL.Async.execute(
                                        'UPDATE blacklist SET Token = @Token, GameLicense = @license, DiscordUID = @discord WHERE id = @id', {
                                            ["@Token"] = json.encode(PlayerTokens[ip]),
                                            ["@license"] = license,
                                            ["@discord"] = discord,
                                            ["@id"] = BanList[i].ID,
                                        }
                                    )
                                    break
                                else
                                    banned[ip] = false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if banned[ip] then
        if reason and nameBan and nameBanner and timeRimaing then
            local card = {
                type = "AdaptiveCard",
                version = "1.2",
                body = {
                    { type = "TextBlock", text = "You are blacklisted from our server !",                                                                                                                                                                                                              wrap = true,                                                                                                                                                                  horizontalAlignment = "Center", separator = true, height = "stretch", fontType = "Default", size = "Large",  weight = "Bolder", color = "Orange" },
                    { type = "TextBlock", text = "Ban Information :\nReason: " .. reason .. "\nBan ID: #" .. BanId .. "\nBy: "..nameBanner.."\nTime remaining: "..timeRimaing..".",                                                                                                                                           wrap = true,                                                                                                                                                                  horizontalAlignment = "Center", separator = true, height = "stretch", fontType = "Default", size = "Medium", weight = "Bolder", color = "Light" },
                    { type = "ActionSet", horizontalAlignment = "Center",                                                                                                                                                                                                                         actions = { { type = "Action.OpenUrl", title = "Join Discord", url = "https://discord.gg/qU7Hug7F2y", iconUrl = "https://icons.getbootstrap.com/assets/icons/discord.svg" } } },
                    { type = "Container", items = { { type = "ActionSet", horizontalAlignment = "Center", actions = { { type = "Action.OpenUrl", title = "Visit our website", url = "discord", iconUrl = "https://icons.getbootstrap.com/assets/icons/globe.svg" } } } } },
                    { type = "TextBlock", text = "This server protected by SxProtection®",                                                                                                                                                                                                              wrap = true,                                                                                                                                                                  horizontalAlignment = "Center", separator = true, height = "stretch", fontType = "Default", size = "Small",  weight = "Bolder", color = "Light" },
                }
            }
            while true do
                Wait(0)
                data.presentCard(card, "XD")
            end
        else
            data.done("\nPlease reconnect, if the problem persists, contact FrancePVP Support")
        end
        CancelEvent()
    else
        Wait(350)
        data.done()
    end
end)


