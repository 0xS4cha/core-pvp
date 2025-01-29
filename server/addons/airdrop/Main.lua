
--[[
CreateThread(function()
    local wait = _DROP.Global.Time * 60000
    while true do
        Wait(wait)
        InitializeAirDrop()
    end
end)
RegisterCommand('airdrop', function()
    InitializeAirDrop()
end, false)
function InitializeAirDrop()
    local chance = math.random(1,#_DROP.Global.Rewards)
    local Reward = _DROP.Global.Rewards[chance]
    local poschance = math.random(1,#_DROP.Global.Positions)
    local pos = _DROP.Global.Positions[poschance]

    TriggerClientEvent('core:airdrop:create:client', -1, Reward, pos)
end]]

