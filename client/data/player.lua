---@diagnostic disable: lowercase-global
playerData = {}
globalData = {}
loaded = false

RegisterNetEvent("core:RefreshPlayerData")
AddEventHandler("core:RefreshPlayerData", function(data)
    playerData = data
    Logger:info('CORE', "Mise à jour des données du joueur")
    player:new(data)
    TriggerEvent("core:RefreshData", playerData)
end)

RegisterNetEvent("core:InitPlayer")
AddEventHandler("core:InitPlayer", function(globalDatas)
    globalData = globalDatas
end)




AddEventHandler("playerSpawned", function()
    while p == nil do Wait(1000) end
    DisableIdleCamera(true)
    FreezeEntityPosition(p:ped(), true)
    DisablePlayerVehicleRewards(p:ped())
    ShutdownLoadingScreenNui()
    SetEntityInvincible(p:ped(), true)
    RequestAllIpls()
    if json.encode(p:getCloths().skin) == "[]" then
        LoadNewCharCreator()
    elseif json.encode(p:getCloths().skin) ~= "" then
        LoadPlayerData(false)
        TriggerEvent("skinchanger:loadSkin", p:getCloths().skin)
        -- TriggerEvent('rcore_tattoos:applyOwnedTattoos')
        FreezeEntityPosition(p:ped(), false)
    end
    SetPedInfiniteAmmo(PlayerPedId(), true)
    TriggerScreenblurFadeOut(10)
end)

function LoadPlayerData(fromCharCreator) -- Tout les init irons ici
    ShowLobbySelector()
end

TriggerServerEvent("core:InitPlayer")


-- function ToggleSound(state)
--     if state then
--         StartAudioScene("MP_LEADERBOARD_SCENE");
--     else
--         StopAudioScene("MP_LEADERBOARD_SCENE");
--     end
-- end

-- function InitialSetup()
--     ToggleSound(muteSound)
--     if not IsPlayerSwitchInProgress() then
--         SwitchOutPlayer(PlayerPedId(), 0, 1)
--     end
-- end

-- function ClearScreen()
--     SetCloudHatOpacity(cloudOpacity)
--     HideHudAndRadarThisFrame()
--     SetDrawOrigin(0.0, 0.0, 0.0, 0)
-- end



-- evt refresh



RegisterNetEvent("core:setStatusPlayer")
AddEventHandler("core:setStatusPlayer", function(hunger, thirst, health)
    p:updateStatus(hunger, thirst, health)
end)

RegisterNetEvent("core:addClothPlayer")
AddEventHandler("core:addClothPlayer", function(name, data)
    table.insert(p:getCloths().cloths, { name = name, data = data })
end)

RegisterNetEvent("core:removeClothPlayer")
AddEventHandler("core:removeClothPlayer", function(key)
    table.remove(p:getCloths().cloths, key)
end)

RegisterNetEvent("core:renameClothPlayer")
AddEventHandler("core:renameClothPlayer", function(key, name)
    p:getCloths().cloths[key].name = name
end)


RegisterNetEvent("core:setSkinPlayer")
AddEventHandler("core:setSkinPlayer", function(skin)
    p:setSkin(skin)
end)




