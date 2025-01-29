StaffInStaffMode = {}

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end
    RegisterServerCallback("core:admin:GetAllBan", function(source, token)

        if CheckPlayerToken(source, token) then
            local banlisted = MySQL.query.await('SELECT * FROM blacklist', {})

            return banlisted
        end
    end)
    RegisterServerCallback('core:GetAllStaff', function(source, token)
        if CheckPlayerToken(source, token) then
            local staff = {}
            for k,v in pairs(GetAllplayer()) do
                local isStaff = false

                if v['permission'] > 0 then
                    for k2, inStaffMode in pairs(StaffInStaffMode) do
                        if inStaffMode == v["source"]  then
                            isStaff = true
                        end
                    end 
                    if isStaff then
                        table.insert(staff, { 
                            id = tonumber(v["id"]),
                            source = tonumber(v["source"]), 
                            name =(v["playerName"]),
                            permission = v["permission"],
                            isInStaffMode = true
                        })
                    else
                        table.insert(staff, { 
                            id = tonumber(v["id"]),
                            source = tonumber(v["source"]), 
                            name = v["playerName"],
                            permission = v["permission"],
                            isInStaffMode = false
                        })
                    end
                end
            end
            return staff
        end
    end)
    RegisterServerCallback("core:GetAllPlayer", function(source, token)
        if CheckPlayerToken(source, token) then
            local players = { count = 0, players = {} }
            local player = GetAllplayer()
            for k, v in pairs(player) do
                players.players[k] = { 
                    id = tonumber(v["source"]), 
                    name = GetPlayerName(v["source"]),
                    permission = v["permission"],
                    group = v["group"],
                    groupid = v["groupID"],
                }
                players.count += 1
            end
            return players
        end
    end)

    RegisterServerCallback('core:admin:GetAdvertList', function(source, token, tempId)
        if CheckPlayerToken(source, token) then
            local xPlayer = GetPlayer(source)
            local xTarget = GetPlayer(tempId)
            if xPlayer:getPermission() >= _PERMISSION["ADMINMENU"] then
                local advertList = MySQL.query.await('SELECT * FROM players_adverts WHERE player = @player', { ['@player'] = xTarget:getId() })
                return advertList
            else
                TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:GetAdvertList', source, 'events_anticheat')
            end
        end
    end)
    RegisterServerCallback("core:admin:GetVehicleNetwork", function(source, token, status)
        if CheckPlayerToken(source, token) then 
            if GetPlayer(source) ~= nil then
                local ply = GetPlayer(source)
                if ply:getPermission() >= _PERMISSION["ADMINMENU"] then
                    local entityList = GetGamePool('CVehicle')
                    local returnList = {}
                    for i = 1, #entityList do
                        returnList[i] = {}
                        local veh = entityList[i]
                        local coords = GetEntityCoords(veh)
                        local owner = NetworkGetEntityOwner(veh)
                        returnList[i].entity = veh
                        returnList[i].coords = coords
                        returnList[i].owner = {}
                        returnList[i].plate = GetVehicleNumberPlateText(veh)
                        returnList[i].owner.tempId = owner
                        returnList[i].owner.uuid = GetPlayer(source):getId()
                    end
                    return returnList
                else
                    TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:GetVehicleNetwork', source, 'events_anticheat')
                end
            end
        end
    end)

    RegisterServerCallback("core:admin:TakeService", function(source, token, status)
        if CheckPlayerToken(source, token) then 
            if GetPlayer(source) ~= nil then
                local ply = GetPlayer(source)
                if ply:getPermission() >= _PERMISSION["ADMINMENU"] then
                    if status then
                        table.insert(StaffInStaffMode, source)
                    else
                        for k,v in pairs(StaffInStaffMode) do
                            if v == source then
                                table.remove(StaffInStaffMode, k)
                            end
                        end
                    end
                    return true
                else
                    TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:TakeService', source, 'events_anticheat')
                end
            end
        end
    end)
end)

RegisterNetEvent("core:adminPlayerEvent")
AddEventHandler('core:adminPlayerEvent', function(name, target, token, ...)
    if CheckPlayerToken(source, token) then 
        if GetPlayer(source) ~= nil then
            local ply = GetPlayer(source)
            if ply:getPermission() >= _PERMISSION["ADMINMENU"] then
                TriggerClientEvent(name, target, ...)
            else
                TriggerEvent('core:admin:anticheat', 'Execute trigger: core:adminPlayerEvent', source)
            end
        end
    end
end)

RegisterNetEvent('core:admin:RemoveAdvertPlayer', function(token, id)
    local source = source
    if CheckPlayerToken(source, token) then 
        if GetPlayer(source) ~= nil then
            local ply = GetPlayer(source)
            local target = GetPlayer(idPlayer)
            if ply:getPermission() >= _PERMISSION["DELETE_ADVERT"] then
                MySQL.Async.execute("DELETE FROM players_adverts WHERE id = @id", { ['@id'] = id }, function(result)
                    TriggerClientEvent('core:ShowNotification', source, "You have just deleted an advert.")
                end)
            end
        end
    end
end)


RegisterNetEvent('core:admin:kick', function(token, target, reason)
    local source = source
    if CheckPlayerToken(source, token) then 
        if GetPlayer(source) ~= nil then
            local ply = GetPlayer(source)
            if ply:getPermission() >= _PERMISSION["KICK"] then
                DropPlayer(target, reason)
            else
                TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:kick', source, 'events_anticheat')
            end
        end
    end
end)

local WaitScreen = {}
local WaitVideo = {}
RegisterNetEvent('core:admin:SendScreenShot', function(link)
    local source = source
    if WaitScreen[source] ~= nil then
        local player = GetPlayer(WaitScreen[source])
        local target = GetPlayer(source)
        TriggerClientEvent('core:admin:ShowScreenshot', WaitScreen[source], link, 'image')
        SendDiscordLogImage('screenshot_admin', source, link, string.sub(GetDiscord(WaitScreen[source]), 9, -1), link )
        WaitScreen[source] = nil
    end
    if WaitVideo[source] ~= nil then
        local player = GetPlayer(WaitVideo[source])
        local target = GetPlayer(source)
        TriggerClientEvent('core:admin:ShowScreenshot', WaitVideo[source], link, 'video')
        --SendDiscordLogImage('screenshot_admin', source, link, string.sub(GetDiscord(WaitScreen[source]), 9, -1), link )
        WaitVideo[source] = nil
    end
end)
RegisterNetEvent('core:admin:Screenshot', function(token, idplayer)
    local source = source
    if CheckPlayerToken(source, token) then 
        WaitScreen[idplayer] = source
        TriggerClientEvent('core:admin:SendScreenShot', idplayer)
    end
end)

RegisterNetEvent('core:admin:Video', function(token, idplayer, time)
    local source = source
    if CheckPlayerToken(source, token) then 
        if WaitVideo[idplayer] then
            TriggerClientEvent('core:ShowNotification', source, '~r~<C>Impossible</C>')
            return 
        end
        WaitVideo[idplayer] = source
        TriggerClientEvent('core:admin:SendVideo', idplayer, (time * 1000))
    end
end)

RegisterNetEvent('core:admin:AdvertPlayer', function(token, idPlayer, msg)
    local source = source
    if CheckPlayerToken(source, token) then 
        if GetPlayer(source) ~= nil then
            local ply = GetPlayer(source)
            local target = GetPlayer(idPlayer)
            if ply:getPermission() >= _PERMISSION["ADMINMENU"] then
                local dataOfBan = os.date("%d/%m/%Y %X")
                MySQL.Async.insert("INSERT INTO players_adverts (player, text, staff, date) VALUES (?, ?, ?, ?)"
                , {
                    target:getId(),
                    msg,
                    _PERMISSION_ROLE[ply:getPermission()].prefix..' - '..ply:getPlayerName(),
                    dataOfBan
                }, function(result)
                    TriggerClientEvent('core:ShowNotification', source, "You have just adverted ~g~<C>" .. target:getPlayerName() .. "</C>~s~ for ~g~<C>" .. msg .. "~s~</C>.")
                    TriggerClientEvent('core:admin:SendMessageToPlayer', idPlayer, ('New advert from %s: %s'):format(_PERMISSION_ROLE[ply:getPermission()].prefix..' - '..ply:getPlayerName(), msg))

            end)
            else
                TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:AdvertPlayer', source, 'events_anticheat')

            end
        end
    end
end)

RegisterNetEvent("core:admin:Teleport2", function(token, id)
    local source = source
    if CheckPlayerToken(source, token) then 
        if GetPlayer(source) ~= nil then
            local ply = GetPlayer(source)
            if ply:getPermission() >= _PERMISSION["ADMINMENU"]  then
                local target = GetPlayerPed(id)
                local player = GetPlayerPed(source)
                local coords = GetEntityCoords(target)
                SetEntityCoords(player, coords.x, coords.y, coords.z, false, false, false, false)
            end
        end
    end
end)
RegisterNetEvent("core:admin:Teleport")
AddEventHandler('core:admin:Teleport', function(token, coords, id)
    if CheckPlayerToken(source, token) then 
        if GetPlayer(source) ~= nil then
            local ply = GetPlayer(source)
            local entity
            if id then
                entity = GetPlayerPed(id)
            else
                entity = GetPlayerPed(source)
            end
            if ply:getPermission() >= _PERMISSION["ADMINMENU"] then
                SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
            else
                TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:Teleport', source, 'events_anticheat')
            end
        end
    end
end)

