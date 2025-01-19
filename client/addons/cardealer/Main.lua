local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

RegisterNUICallback('cardealer:buy', function(data, cb)
    data.car = tonumber(data.car) + 1
    TriggerServerEvent('core:vehicle:buy', Token, data.tab, data.car)
    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showCardealer', {
        show = false,

        data = {}
    })
    if cb then
        cb('ok')
    end
end)

RegisterNUICallback('cardealer:Close', function(data, cb)

    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showCardealer', {
        show = false,

        data = {}
    })
    if cb then
        cb('ok')
    end
end)
