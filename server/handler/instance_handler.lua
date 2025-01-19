SetRoutingBucketPopulationEnabled(0, false)


RegisterNetEvent("core:InstancePlayer")
AddEventHandler("core:InstancePlayer", function(token, instance, reason)
    local src = source
    if CheckPlayerToken(src, token) then
        SetRoutingBucketPopulationEnabled(tonumber(instance), false)
        SetPlayerRoutingBucket(src, tonumber(instance))
   

       TriggerClientEvent("Core:PrintChangeInstance", src, src, tonumber(instance), reason)
    else
        ---ACEvent
    end
end)

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(0)
    end
    RegisterServerCallback("core:CheckInstance", function(source)
        --if CheckPlayerToken(source, token) then
            if GetPlayerRoutingBucket(source) == 0 then
                return true
            else
                return false
            end
        --else
        --    ---ACEvent
        --end
    end)
    
    RegisterServerCallback("core:GetInstanceID", function(source)
        return GetPlayerRoutingBucket(source)
    end)
end)

RegisterCommand("getInstance", function(source, args, rawCommand)
    print(GetPlayerRoutingBucket(source))
end, false)

RegisterCommand("leaveinstance", function(source, args, rawCommand)
    SetPlayerRoutingBucket(source, 0)

end, false)


exports("playerIdentity", function(playerid)
    return {prenom = GetPlayer(playerid):getFirstname(), nom = GetPlayer(playerid):getLastname()}
    --return GetPlayer(playerid):getIdentity()
end)

exports("getId", function(playerid)
    return GetPlayer(playerid):getId()
end)


RegisterNetEvent("cBarber:globalEvent")
 AddEventHandler("cBarber:globalEvent", function(eventData)
     if eventData.Event == "CHAIR_BUSY" then
        Busy = eventData and source or false
     end
  TriggerClientEvent("cBarber:eventHandler", -1, eventData.Event, eventData.Data)
end)


