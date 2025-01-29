local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)
RegisterNUICallback('SendTrade', function(data, cb)
    local response = false
    if tonumber(data.quantity) == 0 then
        data.quantity = tonumber(data.item.count)
    end
    CloseInventory()
    local player = Utils.ChoicePlayersInZone(5.0, false)
    if player then
        if not GetPlayerServerId(player) then
            return
        end
        if tonumber(data.quantity) == 0 then
            data.quantity = tonumber(data.item.count)
        end
        if tonumber(data.item.count) < tonumber(data.quantity) then
            Utils.ShowNotification(GetPhrase('NotEnoughItem'))
            return
        end

        response = TriggerServerCallback("inventory:tradeItem", Token, data, GetPlayerServerId(player))
    end
    cb(response)
end)