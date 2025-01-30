local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

RegisterNUICallback('shop:Close', function(data, cb)
    SetNuiFocus(false, false)
    StopScreenEffect(_EFFECT['blur'])
    _NUI.SendNUIMessage('showShop', {
        show = false,
        data = {}
    })
    if cb then
        cb('ok')
    end
end)


RegisterNUICallback('shop:Buy', function(data, cb)
    local response = false
    local ItemList = {}
    local price = 0

    SetNuiFocus(false, false)
    StopScreenEffect(_EFFECT['blur'])
    _NUI.SendNUIMessage('showShop', {
        show = false,
        data = {}
    })
    for k,v in pairs(data) do
        if tonumber(v.quantity) > 0 then
            table.insert(ItemList, {item = v.item, quantity = tonumber(v.quantity), type = v.type})
            for key, value in pairs(_SHOP.Items[v.type].list) do
                if v.name == value.name then
                    price += value.price
                    break
                end
            end
        end
    end
    response = TriggerServerCallback('core:shop:valid', Token, ItemList, price)
    cb(response)
end)

