local isDead = false
local Token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

AddEventHandler('core:onPlayerDeath', function(data)
    isDead = true
    print(json.encode(data))
    PlayerInComa(data)
end)

function PlayerInComa(data)
    if isDead then
        SetNuiFocus(true, true)
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
            killedByPlayer = data.killedByPlayer
        })
    end
end
RegisterCommand('pistol', function()
    local playerPed = PlayerPedId() 
    local weaponHash = GetHashKey("WEAPON_PISTOL")
    GiveWeaponToPed(playerPed, weaponHash, 250, false, true)
    SetCurrentPedWeapon(playerPed, weaponHash, true)
    print(GetHashKey('WEAPON_PISTOL'))
end, false)