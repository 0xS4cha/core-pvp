local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

vehListSelector = {}
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
    if vehListSelector[data].type == "Payant" then
        TriggerServerEvent('core:vehicle:spawn', Token, vehListSelector[data].vehicle, safeZoneId, true, vehListSelector[data].plate)
    else
        TriggerServerEvent('core:vehicle:spawn', Token, vehListSelector[data].vehicle, safeZoneId, false)
    end
    if cb then
        cb('ok')
    end
end)

RegisterNetEvent("core:vehicle:loadProps", function(vehicle, props)
    vehicleClass.setProps(vehicle, props)
end)