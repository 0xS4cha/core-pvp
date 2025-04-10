_SAFEZONE = _SAFEZONE or {}

local leavingsafezone = false
local CreateThread <const> = CreateThread
local blip = nil
local firstInit = true
local safezoneCoords = vector(0.0, 0.0, 0.0)
local removeInvincible = false
--function pour disable les colision des voitures
local function disableVehicleColisions(vehicle, toggle)
    SetEntityAlpha(vehicle, toggle and 150 or 255, false)
    SetEntityNoCollisionEntity(vehicle, not toggle, true)
end

function _SAFEZONE.init(coords, pvp, radius)
    if blip then
        RemoveBlip(blip)
    end
    removeInvincible = pvp
    safezoneCoords = coords
    blip = Utils.CreateBlipCircle(safezoneCoords, 'SafeZone', radius, 2, 1)
    if firstInit then
        firstInit = false
        CreateThread(function()
            while true do
                Wait(1000)
                if #(GetEntityCoords(PlayerPedId()) - safezoneCoords) <= radius then
                    _SAFEZONE.enteringsafezone()
                else
                    _SAFEZONE.exitingsafezone()
                end
            end
        end)
    end
end

--Boucle main
_SAFEZONE.inSafeZone = false

CreateThread(function()
    local wait = 0
    while true do
        wait = 1000
        if removeInvincible then
            if _SAFEZONE.inSafeZone or leavingsafezone then
                wait = 0
                SetEntityInvincible(p:ped(), true)
                SetCanAttackFriendly(GetPlayerPed(-1), false, false)
                NetworkSetFriendlyFireOption(false)
                local carros = GetGamePool("CVehicle")
                for i = 1, #carros, 1 do
                    local veh = GetVehiclePedIsIn(p:ped(), false)

                    if veh ~= 0 then
                        SetEntityNoCollisionEntity(carros[i], veh, true)
                    else
                        SetEntityNoCollisionEntity(carros[i], p:ped(), true)
                    end
                end

                for _, i in ipairs(GetActivePlayers()) do
                    if i ~= PlayerId() then
                        local closestPlayerPed = GetPlayerPed(i)

                        SetEntityNoCollisionEntity(closestPlayerPed, p:ped(), true)
                    end
                end
            else
                SetEntityInvincible(p:ped(), false)
                SetCanAttackFriendly(GetPlayerPed(-1), true, true)
                NetworkSetFriendlyFireOption(true)
            end
        end
        Wait(wait)
    end
end)




-- Event quand le player entre en safezone
function _SAFEZONE.enteringsafezone()
    if not _SAFEZONE.inSafeZone then
        _SAFEZONE.inSafeZone = true
        leavingsafezone = false
    end
end

function _SAFEZONE.exitingsafezone()
    if (_SAFEZONE.inSafeZone or leavingsafezone) then
        _SAFEZONE.inSafeZone = false
        leavingsafezone = true
        SetCanAttackFriendly(GetPlayerPed(-1), false, false)
        NetworkSetFriendlyFireOption(false)
        SetEntityInvincible(p:ped(), true)
        local vehicle = GetVehiclePedIsIn(p:ped(), false)
        if vehicle ~= 0 then
            disableVehicleColisions(vehicle, true)
        end
        leavingsafezone = false
        SetEntityInvincible(p:ped(), false)

        SetCanAttackFriendly(GetPlayerPed(-1), true, true)
        NetworkSetFriendlyFireOption(true)

        if vehicle ~= 0 then
            disableVehicleColisions(vehicle, false)
        end
    end
end
