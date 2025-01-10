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

CreateThread(function()
    local ban = false
    while p == nil do
        Wait(100)
    end
    isFirstAttempt = true
    while true do
        Wait(5000)
        local weapon = GetSelectedPedWeapon(p:ped())
        local damageType = GetWeaponDamageType(weapon)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0)

        local explosiveDamageTypes = { 4, 5, 6, 13 }
        local isExplosive = false

        -- Check if the weapon is explosive
        for _, damage in ipairs(explosiveDamageTypes) do
            if damage == damageType then
                isExplosive = true
                break
            end
        end
        if isExplosive then
            if not ban then
                ban = true
                local weaponName = GetWeapontypeModel(weapon)
                TriggerServerEvent('core:admin:anticheat', 'Explosive weapon ('..weaponName..')')
            end
        end
        if GetPedConfigFlag(p:ped(), 223, true) then
            TriggerServerEvent('core:admin:anticheat', 'Anti tiny')
        end
        if GetPedMaxHealth(p:ped()) > 200 and not ban  then
            ban = true
            TriggerServerEvent('core:admin:anticheat', 'Give Health ('..GetPedMaxHealth(p:ped())..')')
        end
        if GetPedArmour(p:ped()) > 100 and not ban then
            ban = true
            TriggerServerEvent('core:admin:anticheat', 'Give Armour')
        end
        if not IsPedInAnyVehicle(p:ped(), false) then
            if not IsPedInAnyVehicle(p:ped(), false) then
                local coords = GetEntityCoords(PlayerPedId())

                if isFirstAttempt then
                    lastCoords = coords
                    isFirstAttempt = false
                end


                if #(coords - lastCoords) > 10.0 and GetEntityHeightAboveGround(p:ped()) > 4.0 and not IsPedFalling(p:ped()) then
                    TriggerServerEvent('core:admin:anticheat', 'Anti noclip')
                end

                lastCoords = coords
            end
        end
        if IsPlayerCamControlDisabled() ~= false then
            TriggerServerEvent('core:admin:anticheat', 'Anti Menyoo')
        end
        if NetworkIsPlayerActive(PlayerId()) then
            if not IsNuiFocused() then
                if IsScreenFadedIn() then
                    local retval, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof =
                        GetEntityProofs(p:ped())

                    -- Check various godmode conditions and punish if detected
                    if GetPlayerInvincible(PlayerId()) or GetPlayerInvincible_2(PlayerId()) and not ban then
                        TriggerServerEvent('core:admin:anticheat', 'Anti Godmode (Invincible)')
                    end
                    if retval == 1 and bulletProof == 1 and fireProof == 1 and explosionProof == 1 and collisionProof == 1 and steamProof == 1 and p7 == 1 and drownProof == 1 and not ban then
                        TriggerServerEvent('core:admin:anticheat', 'Anti Godmode (Proof)')
                    end
                    if not GetEntityCanBeDamaged(p:ped()) and not ban then
                        TriggerServerEvent('core:admin:anticheat', 'Anti Godmode (CanBeDamaged)')
                    end
                end
            end
        end
    end
end)

RegisterCommand('testheal', function()
    SetEntityHealth(p:ped(), 200)
end, false)
--[[


CreateThread(function()
    while true do
        Detect.found = false
        if IsPedArmed(p:ped(), 1) or IsPedArmed(p:ped(), 4) or IsPedArmed(p:ped(), 2) then
            for k, v in pairs(p:getInventaire()) do
                if v.name and string.find(v.name, "weapon_") then 
                    if GetSelectedPedWeapon(p:ped()) == GetHashKey(v.name) then 
                        Detect.found = true
                    end
                end
            end
            if not Detect.found then 
                if weaponHashes[GetSelectedPedWeapon(p:ped())] then
                    Detect.weapon = weaponHashes[GetSelectedPedWeapon(p:ped())]
                else
                    Detect.weapon = GetSelectedPedWeapon(p:ped()).." (Hash)"
                end
                TriggerServerEvent("sw:detect9222", "Suppression de l'arme en main du joueur car il ne l'a pas en inventaire : " ..Detect.weapon, "Gives")
                SetCurrentPedWeapon(p:ped(), GetHashKey('WEAPON_UNARMED'), true)
            end
        end
        Wait(3000)
    end
end)]]

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