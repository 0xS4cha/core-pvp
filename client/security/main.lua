local token = nil
AlertANTICHEAT = {}
local tokenAcces = {
    ["core"] = 500,
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




local function GeneratePlayerToken()
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


        SetEntityProofs(PlayerPedId(), false, false, true, true, false, false, false, false)
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