RegisterNUICallback('screenshot:Close', function(data, cb)
    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showScreenshot', {
        show = false,
        data = {
            screen = '',
            translation = {
                close = GetPhrase('CLOSE')
            }
        }
    })
    if cb then
        cb('ok')
    end
end)

function ShowScreenShot(link)
    SetNuiFocus(true, true)
    _NUI.SendNUIMessage('showScreenshot', {
        show = true,
        data = {
            screen = link,
            translation = {
                close = GetPhrase('CLOSE')
            }
        }
    })
end

RegisterNetEvent('core:admin:ShowScreenshot', function(link)
    Console.Success('ShowScreenshot', link)
    ShowScreenShot(link)
end)

RegisterNetEvent('core:admin:SendScreenShot', function()
    exports['screenshot-basic']:requestScreenshotUpload(
    'https://discord.com/api/webhooks/1077657680354758676/tg2wDi4Eqsepd8kE_1w81_O0m_dBQJb8XDh9kIzcl8huuFvRH7mI7UZrAkES5mvZKawb',
        'files[]', function(data)
        local resp = json.decode(data)
        if resp ~= nil and resp.attachments ~= nil and resp.attachments[1] ~= nil and resp.attachments[1].proxy_url ~= nil then
            SCREENSHOT_URL = resp.attachments[1].proxy_url
            Console.Debug('SCREENSHOT_URL', SCREENSHOT_URL)
            TriggerServerEvent('core:admin:SendScreenShot', SCREENSHOT_URL)
        end
    end)
end)