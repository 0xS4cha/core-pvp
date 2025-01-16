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