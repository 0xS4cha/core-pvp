_SQUAD = _SQUAD or {}
_SQUAD.List = {}
_SQUAD.Invite = {}
local function isInSquad(source)
    for k, squad in pairs(_SQUAD.List) do
        if json.encode(squad) ~= '[]' then
            for k, player in pairs(squad.players) do
                if player.tempId == source then
                    return squad, player
                end
            end
        end
    end
    return false, false
end
function CreateSquad(source)
    local player = GetPlayer(source)
    if player then
        local discord = GetDiscordId(source)
        local data = GetUserData(discord) 
        local imgURL = _CONFIG.LOGO_LINK

        local id = #_SQUAD.List + 1
        _SQUAD.List[id] = { id = id, players = {}, private = true}
        if data then
            if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
                imgURL = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".gif";
            else 
                imgURL = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".png"
            end
        end
        table.insert(_SQUAD.List[id].players, { name = player:getPlayerName(), tempId = source, leader = true, avatar = imgURL, permId = player:getId()})
        return _SQUAD.List[id]
    end
end

function acceptInvite(source)
    local xTarget = GetPlayer(source)
    if  xTarget  then
        local squad = _SQUAD.Invite[source]
        if squad and json.encode(_SQUAD.List[squad]) ~= '[]' then
            local discord = GetDiscordId(source)
            local data = GetUserData(discord) 
            local imgURL = _CONFIG.LOGO_LINK
            if data then
                if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
                    imgURL = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".gif";
                else 
                    imgURL = "https://cdn.discordapp.com/avatars/" .. discord .. "/" .. data.avatar .. ".png"
                end
            end
            table.insert(_SQUAD.List[squad].players, { name = xTarget:getPlayerName(), tempId = source, leader = false, avatar = imgURL, permId = xTarget:getId() })
            TriggerClientEvent('core:squad:cl_create', source, _SQUAD.List[squad])
            _SQUAD.Invite[source] = nil
            for k,v in pairs(_SQUAD.List[squad].players) do
                if v.tempId ~= source then
                    TriggerClientEvent('core:ShowNotification', v.tempId, GetPhrase('squad_join', xTarget:getPlayerName()))
                    TriggerClientEvent('core:squad:update', v.tempId, _SQUAD.List[squad])
                end
            end
        end
    end
end

RegisterCommand('squad', function(source, args, rawCommand)
    local xPlayer = GetPlayer(source)
    if xPlayer then
        if json.encode(args) == '[]' then
            if isInSquad(xPlayer:getId()) then
                TriggerClientEvent('core:ShowNotification', source,
                    '~b~Help:~s~\n/squad delete ~b~[Delete your squad]~s~\n/squad invite ~b~[Invite a player to the squad]~s~\n/squad kick ~b~[kick a player from the squad]~s~\n/squad leader ~b~[Set a player leader to the squad]~s~\n/squad leave ~b~[Leave your the squad]~s~')
            else
                TriggerClientEvent('core:ShowNotification', source,
                    '~b~Help:~s~\n/squad join ~b~[Join a squad]~s~\n/squad create ~b~[Create a squad]~s~')
            end
            return
        end
        if args[1] == 'create' then
            local squad = CreateSquad(source)
            TriggerClientEvent('core:squad:cl_create', source, squad)
            TriggerClientEvent('core:ShowNotification', source, GetPhrase('squad_create', squad.id))
            Logger:info('CORE', 'A new squad was created by '..xPlayer:getPlayerName())
        elseif args[1] == 'invite'  then
            local squad, player = isInSquad(source)
            if player.leader or squad.private then
                TriggerClientEvent('core:squad:allowToInvite', source)
            end
        elseif args[1] == 'join' and _SQUAD.Invite[source] then
            acceptInvite(source)
        elseif args[1] == 'delete' then
            local squad, player = isInSquad(source)
            if player.leader then
                for k,v in pairs(_SQUAD.List[squad.id].players) do
                    TriggerClientEvent('core:squad:reset', v.tempId)
                    TriggerClientEvent('core:ShowNotification', v.tempId, GetPhrase('squad_delete'))
                end
                _SQUAD.List[squad.id] = {}
                Logger:info('CORE', 'Squad has been disbanded (#'..squad.id..') by '..xPlayer:getPlayerName())
            end
        elseif args[1] == 'kick' and args[2] ~= nil  then
            local squad, player = isInSquad(source)
            if player.leader then
                for k,v in pairs(_SQUAD.List[squad.id].players) do
                    if v.tempId == tonumber(args[2]) then
                        TriggerClientEvent('core:squad:reset', v.tempId)
                        TriggerClientEvent('core:ShowNotification', v.tempId, GetPhrase('squad_kicked'))
                        Logger:info('CORE', v.name..' has been kicked from squad #'..squad.id)
                        _SQUAD.List[squad.id].players[k] = nil
                    end
                end
                for k,v in pairs(_SQUAD.List[squad.id].players) do
                    TriggerClientEvent('core:squad:update', v.tempId, _SQUAD.List[squad.id], tonumber(args[2]))
                end
            end
        elseif args[1] == 'leader' and args[2] ~= nil then
            local squad, player = isInSquad(source)
            if player.leader then
                for k,v in pairs(_SQUAD.List[squad.id].players) do
                    if v.tempId == player.tempId and v.leader then
                        v.leader = false
                    end
                    if v.tempId == tonumber(args[2]) and not v.leader then
                        v.leader = true
                        TriggerClientEvent('core:ShowNotification', v.tempId, GetPhrase('squad_promoted', squad.id))
                    end
                end
                for k,v in pairs(_SQUAD.List[squad.id].players) do
                    TriggerClientEvent('core:squad:update', v.tempId, _SQUAD.List[squad.id])
                end
            end
        end
    end
end, false)


RegisterNetEvent("core:squad:invite", function(token, target) 
    local src = source

    if CheckPlayerToken(source, token) then
        local xPlayer = GetPlayer(src)
        local xTarget = GetPlayer(target)
        local squad, leader = isInSquad(source)
        if xPlayer and xTarget and ( not squad.private or leader.leader)  then --and not isInSquad(xTarget:getId())  then
            _SQUAD.Invite[target] = squad.id
            TriggerClientEvent('core:ShowNotification', target, GetPhrase('squad_invite', xPlayer:getPlayerName()))
        end
    end
end)

