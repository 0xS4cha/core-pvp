local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

function OpenStorage()
    _INVENTORY.InStorage = true
    local inv = p:getInventaire()
    local storage = p:getStorage()
    Items = {}
    for k,v in pairs(inv) do

        if v.name == 'money' then
            v.count = Utils.Round(v.count, 0)
        end
        if v.type == 'items' or v.type == 'weapons' then
        
            table.insert(Items, {
                name = v.name,
                count = v.count,
                label = GetPhrase(v.name),
                slot = v.slot or k,
                type = v.type,

            })
        end
    end
    CreateThread(function()
        start(0.5, 0.8)
    end)

    CreateThread(function()
        SetNuiFocus(true, true)
        p:setInventaire(Items)
        _NUI.SendNUIMessage('showInventory', {
            show = true,
            secondInventory = true,
            Inventory2 = {
                canLoot = true,
                canTrade = true,
                name = 'YOUR STORAGE',
                Items = storage
            },
            inventory = {
                Items = Items,
                fastItems = fastItems
            }
        })
        _INVENTORY.open = true
    end)
end

RegisterNuiCallback('dropStorage', function(data, cb)
    local response = false
    if _INVENTORY.InStorage then
        if tonumber(data.quantity) == 0 then
            data.quantity = tonumber(data.item.count)
        end
        if tonumber(data.item.count) < tonumber(data.quantity) then
            Utils.ShowNotification(GetPhrase('NotEnoughItem'))
            return
        end
        response = TriggerServerCallback("inventory:dropStorage", Token, data, _INVENTORY.TargetLoot)
    end
    if cb and response then
        cb({})
    end
end)