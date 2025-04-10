--[[
Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end
    RegisterServerCallback('core:leaderboard:getTop', function(source, top)
        local result = MySQL.Sync.fetchAll(('SELECT kills, death, playerName, cloths, id FROM players ORDER BY kills DESC LIMIT %s'):format(top))
        return result, os.date("%d/%m/%Y %X")
    end)
    RegisterServerCallback('core:leaderboard:getAll', function(source)
        local result = MySQL.Sync.fetchAll('SELECT kills, death, playerName, cloths, id FROM players ORDER BY kills DESC')
        return result
    end)
end)


Citizen.CreateThread(function()
    while true do
        Wait(_CONFIG.REFRESHLEADERBOARD *  6000)
        local result = MySQL.Sync.fetchAll('SELECT kills, death, playerName, cloths, id FROM players ORDER BY kills DESC LIMIT 3')
        TriggerClientEvent('core:leaderboard:refresh', -1, result, os.date("%d/%m/%Y %X"))
    end
end)--]]