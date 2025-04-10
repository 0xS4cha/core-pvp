RegisterNetEvent("core:JoinGames")
AddEventHandler('core:JoinGames', function(Token, data)
    local source = source
    if CheckPlayerToken(source, Token) then
        local player = GetPlayer(source)
        if data.game < 1 or not _GAMES[data.game] then
            return
        end
        if data.type then
            if not _GAMES[data.game].instance[data.type] then
                return
            end
        end

        if data.type then
            local Game = _GAMES[data.game].instance[data.type]
            if not Game.Players then
                Game.Players = {}
            end
            player:setInstance(Game.instanceId)
            table.insert(Game.Players, source)
            for k, v in pairs(Game.Players) do
                TriggerClientEvent('core:ShowNotification', v, ('Nous souhaitons la bienvenue à ~g~<C>%s</C>~s~ !\nNous sommes maintenant ~g~<C>%s</C>~s~ dans le lobby'):format(player:getPlayerName(), #Game.Players))
            end

            local canTeleport = TriggerClientCallback(source, "core:loadSettings", Game.settings, Game)
            SetEntityCoords(GetPlayerPed(source), Game.coords.x, Game.coords.y, Game.coords.z)
        else
            if not _GAMES[data.game].Players then
                _GAMES[data.game].Players = {}
            end
            table.insert(_GAMES[data.game].Players, source)
        end
    end
end)


RegisterNetEvent("core:send_message")
AddEventHandler('core:send_message', function(Token, text, target)
    local source = source
    if CheckPlayerToken(source, Token) then
        local xPlayer = GetPlayer(source)
        local xTarget = GetPlayer(target)
        if xPlayer and xTarget then
            TriggerClientEvent('core:SendMessageToPlayer', target,
                ('~b~<C>%s</C>~s~ - %s'):format(xPlayer:getPlayerName(), text))
        end
    end
end)

RegisterNetEvent("core:teleport_to_player")
AddEventHandler('core:teleport_to_player', function(Token, target)
    local source = source
    if CheckPlayerToken(source, Token) then
        local xPlayer = GetPlayer(source)
        local xTarget = GetPlayer(target)
        if xPlayer and xTarget then
            local coords = GetEntityCoords(GetPlayerPed(target))
            SetEntityCoords(GetPlayerPed(source), coords.x, coords.y, coords.z)
        end
    end
end)

RegisterNetEvent("core:save_skin")
AddEventHandler('core:save_skin', function(Token, skin, name)
    local source = source
    if CheckPlayerToken(source, Token) then
        local xPlayer = GetPlayer(source)
        MySQL.Async.insert("INSERT INTO players_skin (player, label, skin) VALUES (?, ?, ?)"
        , {
            xPlayer:getId(),
            name,
            json.encode(skin)
        }, function(result)
            TriggerClientEvent('core:ShowNotification', source, GetPhrase('SKIN_SAVE'))
        end)
    end
end)

RegisterNetEvent("core:save_vehicle")
AddEventHandler('core:save_vehicle', function(Token, label, vehName, vehProps)
    local source = source
    if CheckPlayerToken(source, Token) then
        local xPlayer = GetPlayer(source)
        MySQL.Async.insert("INSERT INTO players_vehicle (player, label, vehicle, props) VALUES (?, ?, ?, ?)"
        , {
            xPlayer:getId(),
            label,
            vehName,
            json.encode(vehProps)
        }, function(result)
            TriggerClientEvent('core:ShowNotification', source, GetPhrase('SKIN_SAVE'))
        end)
    end
end)

RegisterNetEvent("core:delete_skin")
AddEventHandler('core:delete_skin', function(Token, id)
    local source = source
    if CheckPlayerToken(source, Token) then
        local xPlayer = GetPlayer(source)
        MySQL.Async.execute("DELETE FROM players_skin WHERE id = @id AND player = @player", { ['@id'] = id, ['player'] = xPlayer:getId() }, function(result)
            TriggerClientEvent('core:ShowNotification', source, GetPhrase('SKIN_DELETE'))
        end)
    end
end)

RegisterNetEvent("core:delete_vehicle")
AddEventHandler('core:delete_vehicle', function(Token, id)
    local source = source
    if CheckPlayerToken(source, Token) then
        local xPlayer = GetPlayer(source)
        MySQL.Async.execute("DELETE FROM players_vehicle WHERE id = @id AND player = @player", { ['@id'] = id, ['player'] = xPlayer:getId() }, function(result)
            TriggerClientEvent('core:ShowNotification', source, GetPhrase('SKIN_DELETE'))
        end)
    end
end)

local function GetDiscordId(source)
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
    RegisterServerCallback("core:getSkinSaved", function(source, token)
        if CheckPlayerToken(source, token) then
            local xPlayer = GetPlayer(source)
            local skinList = MySQL.query.await('SELECT * FROM players_skin WHERE player = @player', { ['@player'] = xPlayer:getId() })
            return skinList
        end
    end)
    RegisterServerCallback("core:GetDiscordPFP", function(source)
        local discord = GetDiscordId(source)
        local data = GetUserData(discord) 
        local imgURL = _CONFIG.LOGO_LINK

        if data then
            if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
                imgURL = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".gif";
            else 
                imgURL = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".png"
            end
        end
        return imgURL
    end)

    RegisterServerCallback("core:getVehicleSaved", function(source, token)
        if CheckPlayerToken(source, token) then
            local xPlayer = GetPlayer(source)
            local vehicleList = MySQL.query.await('SELECT * FROM players_vehicle WHERE player = @player', { ['@player'] = xPlayer:getId() })
            return vehicleList
        end
    end)
    RegisterServerCallback('core:getScenesList', function(source, token)
        if CheckPlayerToken(source, token) then
            local xPlayer = GetPlayer(source)
            local sceneList = MySQL.query.await('SELECT * FROM players_scene WHERE player = @player', { ['@player'] = xPlayer:getId() })
            return sceneList
        end
    end)
    RegisterServerCallback("core:createScene", function(source, token, text)
        if CheckPlayerToken(source, token) then
            local xPlayer = GetPlayer(source)
            local id = MySQL.Sync.insert("INSERT INTO players_scene (player, label, props) VALUES (?, ?, ?)"
            , {
                xPlayer:getId(),
                text,
                json.encode({})
            })
            return id
        end
    end)
end)