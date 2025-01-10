local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

-- Fix onesync skin bug
-- https://canary.discord.com/channels/992031086555172895/992112234039881738/1067529304277274725
CreateThread(function()
    while not GetEntityModel(PlayerPedId()) do Wait(1) end
    while not TriggerServerCallback do Wait(1) end
    Wait(2000)
    local Activplayers = TriggerServerCallback("core:GetAllPlayer", token)
    print("Start experimental onesync")
    while true do 
        Wait(8000)
        local playerLoc = GetEntityCoords(PlayerPedId())
        local retval, gz = GetGroundZFor_3dCoord((playerLoc.x+0.0), (playerLoc.y+0.0), (playerLoc.z+0.0), Citizen.ReturnResultAnyway())
        SetGlobalMinBirdFlightHeight((gz+15))
    end
end)

