local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)
RegisterNUICallback('vehicleSpawner:Close', function(data, cb)

    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showRental', {
        show = false,

        data = {}
    })
    if cb then
        cb('ok')
    end
end)

RegisterNUICallback('vehicleSpawner:Spawn', function(data, cb)
    data = tonumber(data) + 1
    if data == 0 then
        cb('ok')
        return
    end
    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showRental', {
        show = false,

        data = {}
    })

    TriggerServerEvent('core:vehicle:spawn', Token, _VEHICLE.LIST.FREE[data].vehicle, safeZoneId)
    if cb then
        cb('ok')
    end
end)