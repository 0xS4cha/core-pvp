local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)
_SETTINGS = {}
local pfp = nil
function ShowLobbySelector(canClose)
    while p == nil do Wait(1) end

    SetNuiFocus(true, true)
    if not pfp then
        pfp = TriggerServerCallback('core:GetDiscordPFP')
    end
    SendNUIMessage({
        action = 'showLobbySelector',
        data = {
            show = true,
            data = {
                canClose = canClose or false,
                permid = p:getId(),
                tempid = GetPlayerServerId(PlayerId()),
                name = p:getPlayerName(),
                pfp = pfp,
                games = _GAMES
            }
        }
    })
end

RegisterNUICallback("lobbyselector_quit", function(data, cb)
    TriggerServerEvent('core:DropMe')
end)

RegisterNUICallback('lobbyselector_games', function(data, cb)
    if data.game then
        data.game = tonumber(data.game) + 1
    end
    if data.type then
        data.type = tonumber(data.type) + 1
    end
    if data.game < 1 or not _GAMES[data.game] then
        return
    end
    if data.type then
        if not _GAMES[data.game].instance[data.type] then
            return
        end
    end
    DoScreenFadeOut(1)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'showLobbySelector',
        data = {
            show = false,
            data = {}
        }
    })
    cb('ok')
    TriggerServerEvent('core:JoinGames', Token, data)
end)


RegisterNUICallback("lobbyselector_close", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'showLobbySelector',
        data = {
            show = false,
            data = {}
        }
    })
    cb('ok')
end)


CreateThread(function()
    while RegisterClientCallback == nil do
        Wait(1)
    end

    RegisterClientCallback("core:loadSettings", function(settings, id)
        _SAFEZONE.init(id.coords, settings.pvp, 100.0)
        _SETTINGS = settings
        DoScreenFadeIn(1000)
    end)
end)


Citizen.CreateThread(function()
    local wait = 0
    SetPlayerInvincible(PlayerId(), false)
    while true do
        wait = 1000
        if not _SETTINGS.pvp  then
            wait = 0
            SetPlayerInvincible(PlayerId(), true)
            SetCanAttackFriendly(GetPlayerPed(-1), false, false)
            NetworkSetFriendlyFireOption(false)
        end
        Wait(wait)
    end
end)

Keys.Register({
    name = 'openLobbySelector',
    description = GetPhrase('Lobby'),
    defaultKey = 'F1',
    onPressed = function()
        if _SETTINGS.option then
            ShowLobbySelector(true)
        end
    end
})