
local Reports = {} 




RegisterNetEvent("core:admin:SendReport")
AddEventHandler("core:admin:SendReport", function(token, tableReport)
    if CheckPlayerToken(source, token) then-- TODO REMETTRE
        for k,v in pairs (Reports) do
            if v["uniqueID"] == tableReport["uniqueID"] then
                TriggerClientEvent('core:ShowNotification', source,  "Vous avez déjà un report en cours.")
                return
            end
        end
        LastReport = #Reports + 1
        tableReport["time"] = os.date("%x %Hh %Mmin %Ss")
        tableReport["alreadyTake"] = false
        Reports[LastReport] = tableReport
        if StaffInStaffMode ~= nil then
            for k,v in pairs(StaffInStaffMode) do
                TriggerClientEvent('core:ShowNotification', v,  "Nouveau report de " .. tableReport["name"] .. " ( " .. tableReport["id"] .. " / ".. tableReport["uniqueID"] .." )")
            end
        end
    end
end)

RegisterNetEvent("core:admin:claimReport")
AddEventHandler('core:admin:claimReport', function(token, reportId)
    if CheckPlayerToken(source, token) then -- TODO REMETTRE
        if Reports[reportId] ~= nil then
            local staff = GetPlayer(source)
            Reports[reportId]["alreadyTake"] = true
            Reports[reportId]["staff"] = staff:getPlayerName()
            TriggerClientEvent('core:ShowNotification', Reports[reportId]["id"], '~r~STAFF~s~', '~italic~Supported report~italic~', "Your report has been taken care of by a member of the staff.")
        end
    end
end)

RegisterNetEvent("core:admin:closeReport")
AddEventHandler('core:admin:closeReport', function(token, reportId)
    if Reports[reportId] ~= nil then
        local data = Reports[reportId]
        table.remove(Reports, reportId)
        TriggerClientEvent('core:ShowNotification', data["id"], '~r~STAFF~s~', '~italic~Report clotured~italic~', "Your report has been closed by a member of the staff.")

    end
end)

RegisterServerCallback("core:admin:GetAllReports", function(source, token)
    if CheckPlayerToken(source, token) then -- TODO REMETTRE
        return Reports
    end
end)