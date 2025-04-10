CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(100)
    end
    RegisterServerCallback("core:admin:getAdminData", function(source, target)
        local xTarget = GetPlayer(target)
        local inStaffMode = false
        if xTarget then
        if xTarget:getPermission() > 0 then
                
                for k,v in pairs(StaffInStaffMode) do
                    if v == target then
                        inStaffMode = true
                    end
                end
            end
            return {
                isStaff = false,
                permission = xTarget:getPermission(),
                isStaffMode = inStaffMode,
            }
        end
    end)
end)