
local Reports = {} 
local reportId = 0

RegisterCommand('report', function(source, args, rawCommand)
    local source = source
    if source ~= 0 then
        local player = GetPlayer(source)
        if player then
            if not Reports[source] then
                Reports[source] = {}
                local data = {}
                reportId += 1
                data['id'] = reportId
                data['playerName'] = player:getPlayerName()
                data['tempId'] = source
                data['uuid'] = player:getId()
                data['reason'] = table.concat(args, " ")
                data['time'] = os.date("%x %Hh %Mmin %Ss")
                data['data'] = {
                    id = player:getSource(), 
                    name = player:getPlayerName(),
                    permission = player:getPermission(),
                }
                data['taken'] = false
                data['staff'] = ''
                Reports[source] = data
                if StaffInStaffMode ~= nil then
                    for k,v in pairs(StaffInStaffMode) do
                        TriggerClientEvent('core:ShowNotification', v,  GetPhrase('ADMIN_NEW_REPORT', data["playerName"], data['id']))
                    end
                end
            end
        end
    end
end, false)


RegisterNetEvent("core:admin:closeReport")
AddEventHandler('core:admin:closeReport', function(token, reportId, time)
    local source = source
    if CheckPlayerToken(source, token) then
        local player = GetPlayer(source)
        if player:getPermission() >= _PERMISSION['ADMINMENU'] then
            if Reports[reportId] ~= nil then
                if Reports[reportId]['time'] == time then
                    local old = Reports[reportId]
                    Reports[reportId] = nil
                    TriggerClientEvent('core:ShowNotification', reportId,  GetPhrase('ADMIN_CLOSE_REPORT'))
                    TriggerClientEvent('core:ShowNotification', source,  GetPhrase('ADMIN_CLOSE_REPORT_STAFF', old['id']))
                end
           end
        end
    end
end)

RegisterServerCallback("core:admin:GetAllReports", function(source, token)
    if CheckPlayerToken(source, token) then -- TODO REMETTRE
        return Reports
    end
end)

RegisterServerCallback("core:admin:claimReport", function(source, token, reportId, time)
    local source = source
    if CheckPlayerToken(source, token) then
        local player = GetPlayer(source)
        if player:getPermission() >= _PERMISSION['ADMINMENU'] then
            if Reports[reportId] ~= nil then
                if Reports[reportId]['time'] == time then
                    if not Reports[reportId]['taken'] then
                        Reports[reportId]['taken'] = true
                        Reports[reportId]['staff'] = player:getPlayerName()
                        return true
                    else
                        return false
                    end
                end
            end
        end
    end
end)