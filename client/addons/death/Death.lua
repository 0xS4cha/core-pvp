isDead = false

local canRespawn = false
local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

AddEventHandler('core:onPlayerDeath', function(data)
    isDead = true
    PlayerInComa(data)
end)

function PlayerInComa(data)
    if isDead then
        canRespawn = false
        if _INVENTORY.open then
            
            _INVENTORY.open = false
            SetNuiFocus(false, false)
            DeleteEntity(clonedPed)
            clonedPed = nil
            _NUI.SendNUIMessage('showInventory', {
                show = false
            })
        end
        SetNuiFocus(true, true)
        TriggerServerEvent('core:death:RequestInteract', Token)
        Citizen.CreateThread(function()
            Citizen.Wait(_CONFIG.RESPAWNTIME * 1000)
            canRespawn = true
        end)
        if data.killedByPlayer then
            local killerInformation = TriggerServerCallback("core:getKillerInformation", Token, data.killerServerId)
            while killerInformation == nil do Wait(100) end
            _NUI.SendNUIMessage('killerInformation', {
                killerName = killerInformation.name,
                killerImage = killerInformation.logo,
                killerVip = killerInformation.vip,
                hit = data.hit,
                apDamage = data.apDamage,
                hpDamage = data.hpDamage,
            })
        end
        _NUI.SendNUIMessage('showDeath', {
            show = true,
            timeleft = _CONFIG.RESPAWNTIME,
            killedByPlayer = data.killedByPlayer,
            translation = {
                killername = GetPhrase('killername'),
                respawn = GetPhrase('respawn'),
                unconscious = GetPhrase('unconscious'),
                you_are = GetPhrase('you_are')
            }
        })
        TriggerScreenblurFadeIn(10)

    end
end

RegisterNUICallback('death:respawn', function(data, cb)
    if canRespawn then

        TriggerScreenblurFadeOut(10)
        SetNuiFocus(false, false)
        TriggerEvent('core:RevivePlayer')

        _NUI.SendNUIMessage('showDeath', {
            show = false,
            timeleft = _CONFIG.RESPAWNTIME,
            killedByPlayer = false
        })
    end
end)

RegisterNetEvent("core:RevivePlayer")
AddEventHandler("core:RevivePlayer", function()
    --enlever le screen du coma au mec ici
    Death.GetAllDamagePed = {}
    isDead = false
    _NUI.SendNUIMessage('showDeath', {
        show = false,
        timeleft = _CONFIG.RESPAWNTIME,
        killedByPlayer = false
    })
    ForceStopCarry()
    TriggerScreenblurFadeOut(10)
    local pos = _SAFEZONE.SafeZones[1].safezone.coords
    SetEntityCoordsNoOffset(p:ped(), pos.x, pos.y, pos.z, false, false, false, true)
    NetworkResurrectLocalPlayer(pos, 0.0, true, false)
    TriggerServerEvent('core:death:RequestUnregister', Token)
    p:setHealth(200)
end)

RegisterNetEvent("core:StealPlayer")
AddEventHandler("core:StealPlayer", function()

    Death.GetAllDamagePed = {}
    isDead = false
    _NUI.SendNUIMessage('showDeath', {
        show = false,
        timeleft = _CONFIG.RESPAWNTIME,
        killedByPlayer = false
    })
    SetNuiFocus(false, false)
    ForceStopCarry()
    TriggerScreenblurFadeOut(10)
    local pos = GetEntityCoords(p:ped())
    SetEntityCoordsNoOffset(p:ped(), pos.x, pos.y, pos.z, false, false, false, true)
    NetworkResurrectLocalPlayer(pos, 0.0, true, false)
    TriggerServerEvent('core:death:RequestUnregister', Token)
    p:setHealth(200)
end)

RegisterCommand('revive', function()
    Death.GetAllDamagePed = {}
    isDead = false
    _NUI.SendNUIMessage('showDeath', {
        show = false,
        timeleft = _CONFIG.RESPAWNTIME,
        killedByPlayer = false
    })
    SetNuiFocus(false, false)
    ForceStopCarry()
    TriggerScreenblurFadeOut(10)
    local pos = GetEntityCoords(p:ped())
    SetEntityCoordsNoOffset(p:ped(), pos.x, pos.y, pos.z, false, false, false, true)
    NetworkResurrectLocalPlayer(pos, 0.0, true, false)
    TriggerServerEvent('core:death:RequestUnregister', Token)
    p:setHealth(200)
end, false)