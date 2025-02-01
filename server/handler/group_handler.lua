local CrewInvite = {}
Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end
    RegisterServerCallback("core:crew:requestInformation", function(source)
        local response = false
        local player = GetPlayer(source)
        local BeforePlayerData = nil
        local ranksId = nil
        local permission = nil
        local BeforeRanks = nil
        local kills = nil
        local logo = nil
        local deaths = nil
        local discord = GetDiscordId(source)
        local data = GetUserData(discord)
        if player then
            if player:getGroup() ~= 'None' and player:getGroupID() ~= 0 then
                permission = Group.getPermssionCrewFromPlayer(player:getId())
                kills, deaths = Group.getStats(player:getGroupID())
                BeforeRanks, ranksId = Group.getRanksId(player:getGroupID())
                BeforePlayerData = Group.getMembers(player:getGroupID())
                response = true
            end
            if data then
                if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
                    logo = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".gif";
                else 
                    logo = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".png"
                end
            end
        end
        return response, BeforePlayerData, ranksId, permission, BeforeRanks, kills, deaths, player:getPlayerName(), logo
    end)
end)

RegisterNetEvent("core:crew:sendinvite", function(token, target)
    local source = source
    if CheckPlayerToken(source, token) then
        local xPlayer = GetPlayer(source)
        local xTarget = GetPlayer(target)
        if xPlayer and xTarget then
            if xPlayer:getGroup() ~= 'None' and xPlayer:getGroupID() ~= 0 then
                if xTarget:getGroup() == 'None' and xTarget:getGroupID() == 0 then
                    if CrewInvite[xTarget:getSource()] then
                        if not CrewInvite[xTarget:getSource()][xPlayer:getGroupID()] then
                            CrewInvite[xTarget:getSource()][xPlayer:getGroupID()] = true
                            TriggerClientEvent('core:crew:receiveInvitation', xTarget:getSource(), xPlayer:getGroup(), xPlayer:getGroupID())
                        else
                            TriggerClientEvent('core:ShowNotification', source, GetPhrase('TARGET_ALREADY_SEND_INVITE'))
                        end
                    else
                        CrewInvite[xTarget:getSource()] = {}
                        CrewInvite[xTarget:getSource()][xPlayer:getGroupID()] = true
                        TriggerClientEvent('core:crew:receiveInvitation', xTarget:getSource(), xPlayer:getGroup(), xPlayer:getGroupID())
                    end
                else
                    TriggerClientEvent('core:ShowNotification', source, GetPhrase('TARGET_HAS_A_CREW'))
                end
            else
                TriggerClientEvent('core:ShowNotification', source, GetPhrase('YOU_HAVE_NOT_A_CREW'))
            end
        end
    end
end)

RegisterNetEvent("core:crew:acceptinvite", function(token, id, name)
    local source = source
    if CheckPlayerToken(source, token) then
        local xPlayer = GetPlayer(source)
        if xPlayer then
            if CrewInvite[source] then
                if CrewInvite[source][id] then
                    if xPlayer:getGroup() == 'None' and xPlayer:getGroupID() == 0 then
                        local response = Group.joinGroup(source, id)
                        if response then
                            CrewInvite[source][id] = nil
                            xPlayer:setGroupID(id)
                            xPlayer:setGroup(name)
                            TriggerClientEvent('core:setGroupPlayer', source, name, id)
                            TriggerClientEvent('core:ShowNotification', source, GetPhrase('JoinCrewInvitation', name))
                        end
                    end
                end
            end
        end
    end
end)