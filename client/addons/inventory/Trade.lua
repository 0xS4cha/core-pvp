RegisterNUICallback('SendTrade', function(data, cb)
    local response = false
    if tonumber(data.quantity) == 0 then
        data.quantity = tonumber(data.item.count)
    end
    CloseInventory()
    Utils.ChoicePlayersInZone(5.0, false)
    cb(response)
end)