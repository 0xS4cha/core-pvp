StaffInStaffMode = {}

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end
    RegisterServerCallback("core:admin:GetAllBan", function(source, token)

        if CheckPlayerToken(source, token) then
            local banlisted = MySQL.query.await('SELECT * FROM blacklist', {})

            return banlisted
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
                    TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:GetVehicleNetwork')
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
                    TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:TakeService')
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
                TriggerEvent('core:admin:anticheat', 'Execute trigger: core:adminPlayerEvent')
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
                TriggerEvent('core:admin:anticheat', 'Execute trigger: core:admin:Teleport')
            end
        end
    end
end)

