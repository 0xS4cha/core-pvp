_REDZONE.Zones = {}
local function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function _REDZONE.GetKillLeader(t)
    local sortedTable = {}
    for k, v in spairs(t, function(t,a,b) return t[b].k < t[a].k end) do
        if v.s ~= nil then
            if v.k > 0 then
                table.insert(sortedTable, k)
            end
        end
    end
    return sortedTable[1] ~= nil and sortedTable[1] or false
end

function _REDZONE.CreateZone()
    local pickCount = 1
    local pickedIndexes = {}
    for i = 1, pickCount do
        local id = math.random(#_REDZONE.ZoneLocations)
        while pickedIndexes[id] do
            id = math.random(#_REDZONE.ZoneLocations)
        end
        pickedIndexes[id] = true
        table.insert(_REDZONE.Zones, {
            id = id,
            totalKills = 0,
            players = {}
        })
    end

    TriggerClientEvent('core:redzone:UpdateZones', -1, _REDZONE.Zones)
    TriggerClientEvent('core:redzone:CreateZone', -1)
end

RegisterServerEvent("core:redzone:Identifier", function()
    TriggerClientEvent("core:redzone:UpdateZones", source, _REDZONE.Zones)
    TriggerClientEvent("core:redzone:CreateZone", source)
end)

function _REDZONE.DeleteZone()
    if #_REDZONE.Zones then
        for i = 1, #_REDZONE.Zones do
            local leader = _REDZONE.GetKillLeader(_REDZONE.Zones[i].players)
            if leader then
                for i = 1, #_REDZONE.Reward.Quantity do
                    GiveItemToPlayer(source, _REDZONE.Reward.Items)
                end
            end
        end
        _REDZONE.Zones = {}
        TriggerClientEvent('core:redzone:UpdateZones', -1, _REDZONE.Zones)
        TriggerClientEvent('core:redzone:RemoveZone', -1)
    end
end

function _REDZONE.RelocateZone()
    _REDZONE.DeleteZone()
    _REDZONE.CreateZone()
    TriggerClientEvent("core:ShowNotification", -1, '~r~Redzones change position.')
end

RegisterServerEvent('core:redzone:enteredZone', function(token, zoneId)
    local src = source
    local player = GetPlayer(src)
    if CheckPlayerToken(source, token) then
        if _REDZONE.Zones[zoneId].players[player:getLicense()] == nil then
            _REDZONE.Zones[zoneId].players[player:getLicense()] = {
                kill = 0,
                death = 0,
                into = true,
                source = player:getSource(),
                name = player:getPlayerName()
            }
            TriggerClientEvent('core:redzone:UpdateZones', -1, nil, zoneId, 'players', nil, player:getLicense(), _REDZONE.Zones[zoneId].players[player:getLicense()])
        else
            _REDZONE.Zones[zoneId].players[player:getLicense()].into = true
            TriggerClientEvent('core:redzone:UpdateZones', -1, nil, zoneId, 'players', nil, player:getLicense(), nil, 'in', true)
        end
    end
end)

RegisterServerEvent('core:redzone:exitedZone', function(token, zoneId)
    local src = source
    local player = GetPlayer(src)
    if CheckPlayerToken(source, token) then
        if _REDZONE.Zones[zoneId].players[player:getLicense()] ~= nil then
            _REDZONE.Zones[zoneId].players[player:getLicense()].into = false
            TriggerClientEvent('core:redzone:UpdateZones', -1, nil, zoneId, 'players', nil, player:getLicense(), nil, 'in', false)
        end
    end
end)
RegisterServerEvent("core:redzone:playerKilled", function(token, zoneId, killerId, victimId)
    local src = source
    local killer, victim = GetPlayer(killerId), GetPlayer(victimId)
    if CheckPlayerToken(source, token) then
        if _REDZONE.Zones[zoneId].players[killer:getLicense()] then
            if _REDZONE.Zones[zoneId].players[killer:getLicense()].into then
                _REDZONE.Zones[zoneId].players[killer:getLicense()].kill += 1
                _REDZONE.Zones[zoneId] += 1
                TriggerClientEvent("core:redzone:UpdateZones", -1, nil, zoneId, "players", nil, killer:getLicense(), nil, "kill", _REDZONE.Zones[zoneId].players[killer:getLicense()].kill)
                TriggerClientEvent("core:redzone:UpdateZones", -1, nil, zoneId, "totalKills", _REDZONE.Zones[zoneId].totalKills)
            end
        end
        if _REDZONE.Zones[zoneId].players[victim:getLicense()] then
            if _REDZONE.Zones[zoneId].players[victim:getLicense()].into then
                _REDZONE.Zones[zoneId].players[victim:getLicense()].death += 1
                TriggerClientEvent("core:redzone:UpdateZones", -1, nil, zoneId, "players", nil, victim:getLicense(), nil, "death", _REDZONE.Zones[zoneId].players[victim:getLicense()].death)
            end
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        _REDZONE.RelocateZone()
        Citizen.Wait(_REDZONE.ChangeZonesInterval * 1000 * 60)
    end
end)

