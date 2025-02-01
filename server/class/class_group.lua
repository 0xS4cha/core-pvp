allGroup = {}

local groupPermission = {
    ["addPlayer"] = false,
    ["removePlayer"] = false,
    ["changeRank"] = false,
    ["changePerm"] = false,
    ["deleteRank"] = false,
    ["changeCrewPerm"] = false,
}

local bossDefaultPermission = {
    ["addPlayer"] = true,
    ["removePlayer"] = true,
    ["changeRank"] = true,
    ["changePerm"] = true,
    ["deleteRank"] = true,
    ["changeCrewPerm"] = true,
}
Group = {

    loadAllGroup = function()
        MySQL.Async.fetchAll("SELECT * FROM group_list", {}, function(result)
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    allGroup[result[k].id_group] = {}
                    allGroup[result[k].id_group].id = result[k].id_group
                    allGroup[result[k].id_group].name = result[k].name
                    allGroup[result[k].id_group].description = result[k].description

                    Console.Success("Loaded group ^2" .. allGroup[result[k].id_group].name .. "^7")
                end
            else
                Console.Warn("No group found")
            end
        end)
    end,

    newLoadAllGroup = function()
        MySQL.Async.fetchAll("SELECT * FROM group_list", {}, function(result)
            if result[1] ~= nil then
                allGroup = {}
                for k, v in pairs(result) do
                    allGroup[result[k].id_group] = {}
                    allGroup[result[k].id_group].id = result[k].id_group
                    allGroup[result[k].id_group].name = result[k].name
                    allGroup[result[k].id_group].color = result[k].rgb
                    allGroup[result[k].id_group].devise = result[k].description
                    Console.Success("Loaded group ^2" .. allGroup[result[k].id_group].name .. "^7")
                end
            else
                Console.Warn("No group found")
            end
        end)
    end,

    DoesGroupExist = function(name)
        for k, v in pairs(allGroup) do
            if string.upper(v.name) == string.upper(name) then
                return true
            end
        end
        return false
    end,

    DoesGroupExistId = function(id)
        for k, v in pairs(allGroup) do
            if v.id == id then
                return true
            end
        end
        return false
    end,

    getGroupId = function(name)
        local result = MySQL.Sync.fetchScalar("SELECT * FROM group_list WHERE group_list.name = @name", {
            ['@name'] = name
        })
        if result then
            return result
        else
            return nil
        end
    end,

    getGroupRankId = function(groupId, rank)
        local result = MySQL.Sync.fetchScalar(
            "SELECT * FROM group_rank WHERE group_rank.id_group= @groupId and `rank` = @rank"
            , {
                ['@groupId'] = groupId,
                ['@rank'] = rank
            })
        if result then
            return result
        else
            return nil
        end
    end,


    CreateGroup = function(source, name, rgb, description, rank)
        local source = source
        if not Group.DoesGroupExist(name) then
            local id = 0
            local result = MySQL.Sync.insert(
                "INSERT INTO group_list (`name`, `description`, `rgb`) VALUES (@name, @description,  @rgb)"
                , {
                    ['@name'] = name,
                    ['@rgb'] = json.encode(rgb),
                    ['@description'] = description
                })
            if result then
                id = result[1].id_group
                Console.Success("Group ^2" .. name .. "^7 created")
                TriggerClientEvent("core:ShowNotification", source, "~b~Création du groupe en cours...")
                allGroup[result] = {}
                allGroup[result].id = result
                allGroup[result].name = name
                allGroup[result].devise = description
                allGroup[result].color = rgb
                for k, v in pairs(rank) do
                    local perm = groupPermission
                    if k == 1 then
                        perm = bossDefaultPermission
                    end
                    MySQL.Sync.insert('INSERT INTO group_rank (name, rank, id_group, permission) VALUES(?, ?, ?, ?)', {
                        v,
                        k,
                        result,
                        json.encode(perm)
                    })
                end
                Wait(100)
                MySQL.Sync.insert('INSERT INTO group_members (id_player, label, id_rank, id_group) VALUES(?, ?, ?, ?)', {
                    GetPlayer(source):getId(),
                    GetPlayer(source):getPlayerName(),
                    1,
                    result
                })
                return id
            else
                TriggerClientEvent("core:ShowNotification", source, "~r~Il y a eu une erreur, veuillez réessayer")
                Console.Error("Error while creating crew" .. name)
                return false
            end
        else
            return false
        end
    end,

    createRank = function(groupName, name, rank)
        if Group.DoesGroupExist(groupName) then
            local result = MySQL.Sync.insert(
                "INSERT INTO group_rank (name, rank, id_group, permission) VALUES (?, ?, ?, ?)"
                , {
                    name,
                    rank,
                    Group.getCrewId(groupName),
                    json.encode(groupPermission),
                })
            if result then
                -- CorePrint("Rank ^2" .. name .. "^7 created")
                return true
            else
                Console.Error("Error while creating rank")
                return false
            end
        else
            return false
        end
    end,

    setPermRank = function(groupName, rank, perm)
        if Group.DoesGroupExist(groupName) then
            local result = MySQL.Sync.execute(
                "UPDATE group_rank SET perm = @perm WHERE id_group = @groupId AND `rank` = @rank"
                , {
                    ['@groupId'] = Group.getCrewId(groupName),
                    ['@rank'] = tonumber(rank),
                    ['@perm'] = json.encode(perm),
                })
            if result then
                -- CorePrint("Perm set for rank ^2" .. rank .. "^7")
                return true
            else
                Console.Error("Error while setting perm for : " .. groupName .. " rank : " .. rank .. " perm : " .. perm)
                return false
            end
        else
            return false
        end
    end,

    deleteGroup = function(groupName)
        if Group.DoesGroupExist(groupName) then
            local result = MySQL.Sync.execute("DELETE FROM group_list WHERE name = @groupId"
            , {
                ['@groupId'] = groupName,
            })
            if result then
                Console.Success("Group ^2" .. groupName .. "^7 deleted")
                return true
            else
                Console.Error("Error while deleting Group : " .. groupName)
                return false
            end
        else
            return false
        end
    end,

    deleteRank = function(groupName, rank)
        if Group.DoesGroupExist(groupName) then
            if rank == 1 then
                TriggerClientEvent("core:ShowNotification", source, "~r~Vous ne pouvez pas supprimer ce grade")
                return false
            end
            local result = MySQL.Sync.execute("DELETE FROM group_rank WHERE group_id = @GroupId AND `rank` = @rank"
            , {
                ['@GroupId'] = Group.getGroupId(groupName),
                ['@rank'] = rank,
            })
            if result then
                Console.Success("Rank ^2" .. rank .. "^7 deleted")
                return true
            else
                Console.Error("Error while deleting rank")
                return false
            end
        else
            return false
        end
    end,

    addPlayerInGroup = function(source, groupId, rank)
        MySQL.Async.execute("INSERT INTO group_members (id_player, label, id_rank, id_group) VALUES (?, ?, ?, ?)"
        , {
            GetPlayer(source):getId(),
            GetPlayer(source):getPlayerName(),
            Group.getGroupRankId(groupId, rank),
            groupId

        }, function(affectedRows)
            Console.Success("Player added in group")
        end)
        return true
    end,

    joinGroup = function(source, groupId)
        local result = MySQL.Sync.fetchAll(
        'SELECT rank from group_rank WHERE id_group = @GroupId ORDER BY rank DESC LIMIT 1', {
            ['@GroupId'] = groupId,
        })
        MySQL.Async.execute("INSERT INTO group_members (id_player, label, id_rank, id_group) VALUES (?, ?, ?, ?)"
        , {
            GetPlayer(source):getId(),
            GetPlayer(source):getPlayerName(),
            result[1]['rank'],
            groupId

        }, function(affectedRows)
            Console.Success("Player added in group")
        end)
        return true
    end,

    changePlayerRankInGroup = function(playerId, groupId, rank)
        MySQL.Async.execute(
            "UPDATE group_members SET id_rank = @rankId WHERE id_group = @groupId AND id_player = @playerId"
            , {
                ['@groupId'] = groupId,
                ['@id_player'] = playerId,
                ['@rankId'] = Group.getGroupRankId(groupId, rank)
            }, function(affectedRows)
                Console.Success("Player rank changed in crew")
            end)
        return true
    end,

    removePlayerInGroup = function(playerId, groupId)
        MySQL.Async.execute("DELETE FROM group_members WHERE id_group = @groupId AND id_player = @playerId", {
            ['@groupId'] = groupId,
            ['@playerId'] = playerId
        }, function(affectedRows)
            Console.Success("Player removed from group")
        end)
        return true
    end,

    deleteMembers = function(groupId)
        MySQL.Async.execute("DELETE FROM group_members WHERE id_group = @groupId", {
            ['@groupId'] = groupId
        }, function(affectedRows)
            Console.Success("Members removed from group")
        end)
        return true
    end,

    getPlayerGroup = function(playerId)
        local result = MySQL.Sync.fetchAll(
            "SELECT * FROM group_members LEFT JOIN group_list ON group_members.id_group = group_list.id_group WHERE group_members.id_player = @playerId",
            {
                ['@playerId'] = playerId
            })
        if result[1] ~= nil then
            return result[1].name, result[1].id_group
        else
            return "None"
        end
    end,
    getPermssionCrewFromPlayer = function(playerId)
        local result = MySQL.Sync.fetchAll(
            "SELECT group_members.*, group_list.*, group_rank.permission FROM group_members LEFT JOIN group_list ON group_members.id_group = group_list.id_group LEFT JOIN group_rank ON group_members.id_rank = group_rank.rank AND group_members.id_group = group_rank.id_group WHERE group_members.id_player = @playerId ",
            {
                ['@playerId'] = playerId
            })
        if result[1] ~= nil then
            return json.decode(result[1].permission)
        else
            return false
        end
    end,

    getStats = function(groupId)
        if Group.DoesGroupExistId(groupId) then
            local result = MySQL.Sync.fetchAll("SELECT deaths, kills FROM group_list WHERE id_group = @GroupId"
            , {
                ['@GroupId'] = groupId,
            })
            if result[1] ~= nil then
                return tonumber(result[1].kills), tonumber(result[1].deaths)
            end
        end
    end,
    getMembers = function(groupId)
        if Group.DoesGroupExistId(groupId) then
            local result = MySQL.Sync.fetchAll("SELECT * FROM group_members WHERE id_group = @GroupId"
            , {
                ['@GroupId'] = groupId,
            })
            if result ~= nil then
                return result
            end
        end
    end,
    getRanksId = function(groupId)
        if Group.DoesGroupExistId(groupId) then
            local result = MySQL.Sync.fetchAll("SELECT * FROM group_rank WHERE id_group = @GroupId"
            , {
                ['@GroupId'] = groupId,
            })
            if result ~= nil then
                local RanksId = {}
                local RanksList = {}
                for k, v in pairs(result) do
                    RanksId[k] = {value = k, label = v.name}
                    RanksList[k] = {name = v.name, permission = json.decode(v.permission), rank = v.rank, id_rank = v.id_rank, id_group = v.id_group}
                end
                return RanksList, RanksId
            end
        end
    end,
    getAllGroupInfoByName = function(groupName)
        if Group.DoesGroupExist(groupName) then
            if allGroup[Group.getGroupId(groupName)] then
                return allGroup[Group.getGroupId(groupName)]
            else
                return nil
            end
        else
            return nil
        end
    end,

    getAllGroupMembersBygroupName = function(groupName)
        if Group.DoesGroupExist(groupName) then
            local result = MySQL.Sync.fetchAll(
                "SELECT * FROM group_members LEFT JOIN players ON group_members.id_player = players.id LEFT JOIN group_rank ON group_members.id_rank = group_rank.id WHERE group_members.id_group = @groupId"
                , {
                    ['@groupId'] = Group.getGroupId(groupName)
                })
            if result ~= nil then
                return result
            else
                return nil
            end
        else
            return nil
        end
    end,

    getAllGroupGradeBygroupName = function(groupName)
        if Group.DoesGroupExist(groupName) then
            local result = MySQL.Sync.fetchAll(
                "SELECT * FROM group_list LEFT JOIN group_rank ON group_list.id = group_rank.id_group WHERE group_list.id = @groupId"
                , {
                    ['@groupId'] = Group.getGroupId(groupName)
                })
            if result ~= nil then
                return result
            else
                return nil
            end
        else
            return nil
        end
    end,

    getAllGroupVehByName = function(groupName)
        if Group.DoesGroupExist(groupName) then
            local result = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE vente = @groupName"
            , {
                ['@groupName'] = groupName
            })
            if result ~= nil then
                return result
            else
                return nil
            end
        else
            return nil
        end
    end,

    getAllGroupPropertyByName = function(groupName)
        if Group.DoesGroupExist(groupName) then
            local result = MySQL.Sync.fetchAll("SELECT * FROM property WHERE crew = @groupName"
            , {
                ['@groupName'] = groupName
            })
            if result ~= nil then
                return result
            else
                return nil
            end
        else
            return nil
        end
    end,

}

--crew.loadAllCrew()
Group.newLoadAllGroup()
