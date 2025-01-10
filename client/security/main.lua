local token = nil
AlertANTICHEAT = {}
local tokenAcces = {
    ["core"] = 200,
}
local AntiStop = {
    ['core'] = true
}
AddEventHandler("core:RequestTokenAcces", function(ressource, cb)
    while token == nil do Wait(100) end
    local granted = false
    if tokenAcces[ressource] ~= nil then
        if tokenAcces[ressource] > 0 then
            granted = true
            tokenAcces[ressource] = tokenAcces[ressource] - 1
            cb(token)
        end
    end

    if not granted then
        TriggerServerEvent("core:WrongTokenRequest", ressource)
    end
end)

LastTimePlayer = 0

function PrioEvent()
    LastTimePlayer += 1
    Wait(150*LastTimePlayer)
    return true
end

function TriggerSecurEvent(name, ...) -- Utilsier cette event
    if PrioEvent() then
        local time, idPlayer, size, fname  = tostring(GetGameTimer()), tostring(GetPlayerServerId(PlayerId())), tostring(p:getSize()), tostring(p:getFirstname())
        local message = _TRGSE(fname..time..idPlayer..size)
        LastTimePlayer -= 1
        TriggerServerEvent(name, time, message, ...)
    end
end

function TriggerSecurGiveEvent(name, token, item, count, ...)
    if PrioEvent() then
        local time, idPlayer, size, item, count2, fname =  tostring(GetGameTimer()), tostring(GetPlayerServerId(PlayerId())), tostring(p:getSize()), tostring(item), tostring(count), tostring(p:getFirstname())
        local message = _TRGSE(idPlayer..time..count2..size..item..fname)
        LastTimePlayer -= 1
        TriggerServerEvent(name, time, nil, message, item, count, ...)
    end
end



local function GeneratePlayerToken(source)
    local token = math.random(100001,9000009).."-"..math.random(100001,9000009).."-"..math.random(100001,9000009).."-"..math.random(100001,9000009)
    return token
end

Citizen.CreateThread(function()
    while p == nil do
        Wait(100)
    end
    local t = GeneratePlayerToken()
    TriggerServerEvent("core:RegisterPlayerToken", t)
    token = t
    while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end 
    while not GetEntityModel(p:ped()) do Wait(1) end 
    while not HasCollisionLoadedAroundEntity(p:ped()) do Wait(1) end 
    Wait(15000)
    TriggerServerEvent("core:secu:ImConnected")
end)

CreateThread(function()

    while true do
        HudWeaponWheelIgnoreSelection()
        HideHudComponentThisFrame(19)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
        HideHudComponentThisFrame(20)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 12, true)
        DisableControlAction(0, 13, true)
        DisableControlAction(0, 14, true)
        DisableControlAction(0, 15, true)
        DisableControlAction(0, 16, true)
        DisableControlAction(0, 17, true)
        SetPedConfigFlag(PlayerPedId(), 438, true)
        Wait(1)
    end
end)




RegisterNetEvent("core:takescreensw", function(http, id)
    exports["screenshot-basic"]:requestScreenshotUpload(http, "files[]",function(data)
        local resp = json.decode(data)
        local att = 1000
        while not resp do 
            Wait(1) 
            att = att - 1 
            if att <= 0 then 
                break 
            end 
        end
        TriggerServerEvent("core:getscreenshotsw", resp.files[1].url, id)
    end)
end)

if not _CONFIG.Debug then
    AddEventHandler('onClientResourceStop', function(resourceName)
        if AntiStop[resourceName] then
            TriggerServerEvent('core:admin:anticheat', 'Stop resource: '..resourceName)

        end
    end)

    AddEventHandler('onResourceStop', function(resourceName)
        if AntiStop[resourceName] then
            
            TriggerServerEvent('core:admin:anticheat', 'Stop resource: '..resourceName)

        end
    end)
end