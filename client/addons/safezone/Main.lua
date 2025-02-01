local leavingsafezone = false
safeZoneId = nil

local CreateThread <const> = CreateThread



--function pour disable les colision des voitures
local function disableVehicleColisions(vehicle, toggle)
    SetEntityAlpha(vehicle, toggle and 150 or 255, false)
    SetEntityNoCollisionEntity(vehicle, not toggle, true)
end






CreateThread(function()
    for k,v in pairs(_SAFEZONE.SafeZones) do
        Utils.CreateBlipCircle(v.safezone.coords, 'SafeZone', v.safezone.radius, 2, 1)
        CreateThread(function()
            while true do
                Wait(1000)
                if #(GetEntityCoords(PlayerPedId()) - v.safezone.coords) <= v.safezone.radius then
                    _SAFEZONE.enteringsafezone(k)
                else
                    _SAFEZONE.exitingsafezone(k)
                end
            end
        end)
    end
end)

--Boucle main
_SAFEZONE.inSafeZone = false

CreateThread(function()
    local wait = 0
    while true do
        wait = 1000
        if _SAFEZONE.inSafeZone or leavingsafezone then
            wait = 0
            SetEntityInvincible(PlayerPedId(), true)
            SetCanAttackFriendly(GetPlayerPed(-1), false, false)
            NetworkSetFriendlyFireOption(false)
            local carros = GetGamePool("CVehicle")
            for i = 1,#carros ,1 do
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)

                if veh ~= 0 then
                    SetEntityNoCollisionEntity(carros[i], veh, true)
                else
                    SetEntityNoCollisionEntity(carros[i], PlayerPedId(), true)
                end
            end

            for _, i in ipairs(GetActivePlayers()) do
                if i ~= PlayerId() then
                      local closestPlayerPed = GetPlayerPed(i)

                      SetEntityNoCollisionEntity(closestPlayerPed, PlayerPedId(), true)

                end
            end
        else
            SetEntityInvincible(PlayerPedId(), false)
            SetCanAttackFriendly(GetPlayerPed(-1), true, true)
            NetworkSetFriendlyFireOption(true)
        end

        Wait(wait)
    end
end)




-- Event quand le player entre en safezone
function _SAFEZONE.enteringsafezone(id)
    if not _SAFEZONE.inSafeZone then
        safeZoneId = id
        _SAFEZONE.inSafeZone = true
        leavingsafezone = false
        Utils.ShowNotification(GetPhrase("entringSafeZone"), true)
    end
end


function _SAFEZONE.exitingsafezone(id)

    if (_SAFEZONE.inSafeZone or leavingsafezone) and safeZoneId == id then
        _SAFEZONE.inSafeZone = false
        leavingsafezone = true
        safeZoneId = nil
        SetCanAttackFriendly(GetPlayerPed(-1), false, false)
        NetworkSetFriendlyFireOption(false)
        SetEntityInvincible(playerPed, true)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle ~= 0 then
            disableVehicleColisions(vehicle, true)
        end
        for i = _SAFEZONE.ExitingTime, 1, -1 do
            local notif = Utils.ShowNotification(GetPhrase('LeaveSafeZoneTime', i), false)
            Wait(1000)
        end
        leavingsafezone = false
        Utils.ShowNotification(GetPhrase('LeaveSafeZone'), false)
        SetEntityInvincible(playerPed, false)

        SetCanAttackFriendly(GetPlayerPed(-1), true, true)
        NetworkSetFriendlyFireOption(true)

        if vehicle ~= 0 then
            disableVehicleColisions(vehicle, false)
        end
    end
end



