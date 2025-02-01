local Invitation = {}
local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

RegisterCommand('crew_invite', function()
    if p:getGroup() ~= "None" then
        local player = Utils.ChoicePlayersInZone(5.0, false)
        if player then
            TriggerServerEvent('core:crew:sendinvite', Token, GetPlayerServerId(player))
        end
    end
end, false)

RegisterCommand('crew_accept', function(source, args, rawCommand)
    if args[1] then
        if Invitation[tonumber(args[1])] then
            TriggerServerEvent('core:crew:acceptinvite', Token, tonumber(args[1]), Invitation[tonumber(args[1])])
            Invitation[tonumber(args[1])] = nil
        end
    end
    
end, false)


RegisterNetEvent("core:crew:receiveInvitation", function(name, id)
    if not Invitation[id] then
        Invitation[id] = name
        Utils.ShowNotification(GetPhrase('receiveinvite', id))
    end
end)