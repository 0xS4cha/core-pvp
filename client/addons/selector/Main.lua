RegisterNUICallback('spawnSelector:Select', function(data, cb)
    local zone = {}
    for k,v in pairs(_SAFEZONE.SafeZones) do
        table.insert(zone, {
            Name = v.Name,
            Description = v.Description,
            Image = v.Image,
        })
    end
    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showSpawnSelector', {
        show = false,
        translation = {
            select = GetPhrase('SELECT')
        },
        lobby = zone
    })
    InitPositionHandler(_SAFEZONE.SafeZones[data].safezone.coords)
    if cb then
        cb('ok')
    end
end)


RegisterNUICallback('spawnSelector:Close', function(data, cb)
    local zone = {}
    for k,v in pairs(_SAFEZONE.SafeZones) do
        table.insert(zone, {
            Name = v.Name,
            Description = v.Description,
            Image = v.Image,
        })
    end
    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showSpawnSelector', {
        show = false,
        translation = {
            select = GetPhrase('SELECT')
        },
        lobby = zone
    })
    if cb then
        cb('ok')
    end
end)

