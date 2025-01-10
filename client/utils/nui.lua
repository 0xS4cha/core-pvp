
_NUI = _NUI or {}
function _NUI.SendNUIMessage(name, datas)

    SendNUIMessage({ action = name, data = datas })
end

function _NUI.SetVisible(name, visible, settings)
    if settings.mouse ~= nil or settings.focus ~= nil then
        if settings.focus == nil then settings.focus = true end
        if settings.mouse == nil then settings.mouse = true end
        Console.Debug('NUI focus:'..tostring(settings.focus)..', mouse:'..tostring(settings.mouse))
        SetNuiFocus(settings.focus, settings.mouse)
    end
    Console.Debug("NUI show:".. name ..", "..tostring(visible)) 
    _NUI.SendNUIMessage('show' .. name, visible)
end

function _NUI.Copy(data)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'requestToCopy', data = data })
end

RegisterCommand('test', function()
    _NUI.Copy('TEST COPY')
end, false)