local token
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local tempSkinTable = {}
function LoadNewCharCreator(AlReadyHasSkin)
    DoScreenFadeOut(100)
    TriggerServerEvent("core:InstancePlayer", token, GetPlayerServerId(PlayerId()), "new_char_creator")
    Wait(1000)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(),1.1499674320221, -62.840278625488, 17.523738861084)
    SetEntityHeading(PlayerPedId(),176.03915405273)
    SetEntityInvincible(PlayerPedId(), true)
    if not AlReadyHasSkin then

        local persoHash = GetHashKey("mp_m_freemode_01")
        RequestModel(persoHash)
        while not HasModelLoaded(persoHash) do
            Wait(10)
        end


        SetPlayerModel(PlayerId(), persoHash)
        SetModelAsNoLongerNeeded(persoHash)
    end
    Wait(2000)
    TriggerEvent("skinchanger:change", "arms", 15)
    TriggerEvent("skinchanger:change", "arms_2", 0)
    TriggerEvent("skinchanger:change", "torso_1", 15)
    TriggerEvent("skinchanger:change", "tshirt_1", 15)
    TriggerEvent("skinchanger:change", "pants_1", 61)
    TriggerEvent("skinchanger:change", "pants_2", 4)
    TriggerEvent("skinchanger:change", "shoes_1", 34)
    TriggerEvent("skinchanger:change", "glasses_1", 0)
    TriggerEvent("skinchanger:change", "skin", 5 / 10)
    TriggerEvent("skinchanger:change", "face", 5 / 10) 
    TriggerEvent("skinchanger:change", "sex", 0)
    ClearPedDecorations(PlayerId())
    Wait(600)
    pedCoords = GetEntityCoords(PlayerPedId())
    Cam.create("body_cam")
    Cam.setPos("body_cam", vector3(pedCoords.x,pedCoords.y-2.0,pedCoords.z+0.5))
    Cam.setFov("body_cam", 40.0)
    Cam.lookAtCoords("body_cam", vector3(pedCoords.x-0.4,pedCoords.y,pedCoords.z+0.2))
    Cam.render("body_cam", true, false, 0)
    loadNUICharcreator()
end

function loadNUICharcreator()
    SetTimecycleModifier('MP_corona_heist_DOF')
    SetTimecycleModifierStrength(1.0)

    RequestAnimDict("anim@heists@heist_corona@team_idles@male_a")
    while not HasAnimDictLoaded("anim@heists@heist_corona@team_idles@male_a") do
        Wait(1)
    end
    local data = {}
    local components, maxVals = getMaxValues()
    for i = 1, #components, 1 do
        data[components[i].name] = {
            value = components[i].value,
            min = components[i].min,
        }
        for k, v in pairs(maxVals) do
            if k == components[i].name then
                data[k].max = v
                break
            end
        end
    end
    tempSkinTable = Character
    TaskPlayAnim(PlayerPedId(), "anim@heists@heist_corona@team_idles@male_a", "idle", 8.0, 0.0, -1, 1,0, 0, 0, 0)
    DisplayRadar(false)
    SendNUIMessage({
        action = 'setDatasCharCreator',
        data = {
            logo = _CONFIG.LOGO_LINK,
            data = data
        },
    })
    Wait(200)
    DoScreenFadeIn(100)
    _NUI.SendNUIMessage('setVisibleCharCreator', {
        visible = true
    })
    SetNuiFocus(true, true)
    Cam.setDof("body_cam")
end


RegisterNUICallback("change", function(data, cb)
    tempSkinTable[data.type] = tonumber(data.new)

    ApplySkin(tempSkinTable)
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb("ok")
end)


RegisterNUICallback("reset", function(data, cb)

    TriggerEvent("core:openCreator", true)
    cb('ok')
end)

RegisterNUICallback("save", function(data, cb)
    DoScreenFadeOut(100)
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    Cam.delete('body_cam')
    SendNUIMessage({
        action = "setVisibleCharCreator",
        data = {
            visible = false
        }
    })

    Wait(1000)
    TriggerServerEvent("core:InstancePlayer", token, 0, "new_char_creator : Ligne 1177")
    local newSkin = SkinChangerGetSkin()
    p:setSkin(newSkin)
    p:saveSkin()
    ClearPedTasks(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
    InitPositionHandler(_CONFIG.Lobby)
    
    SetEntityInvincible(PlayerPedId(), false)
    FreezeEntityPosition(PlayerPedId(), false)
    ClearTimecycleModifier()
    DoScreenFadeIn(100)
end)


RegisterCommand('register', function()
    TriggerEvent("core:openCreator", true)
end, false)
RegisterNetEvent('core:openCreator', function(isAlreadyHaveSkin)
    LoadNewCharCreator(isAlreadyHaveSkin)
end)


