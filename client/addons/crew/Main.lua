_CREW = _CREW or {}
local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)
--[[
debugData([
  {
    action: "crew:manage",
    data: {
      show: true,
      PlayersData: [
        {playerName: 'Sxcha', id_rank: 1, id_player: 1},
        {playerName: 'Jbik', id_rank: 2, id_player: 13},
      ],
      deaths: 33,
      kills: 10,
      ranks: {
        1: {rank: 1, id_rank: 38, name: 'Boss', permission: {"addPlayer":true,"removePlayer":true,"changeRank":true,"deleteRank":true,"changePerm":true,"changeCrewPerm":true}},
        2: {rank: 2,  id_rank: 39, name: 'Sous-boss', permission: {"addPlayer":false,"removePlayer":false,"changeRank":true,"deleteRank":true,"changePerm":true,"changeCrewPerm":false}},
      },
      ranksId: ['Boss', 'Sous-boss'],
      permission: []

    }
  }
])]]
function _CREW:Watch()
    if p:getGroup() ~= "None" then
        local Response, BeforePlayerData, ranksId, permission, BeforeRanks, kills, deaths, name, logo =
            TriggerServerCallback('core:crew:requestInformation')
        while Response == nil do Wait(100) end
        if Response then
            Console.debugPrint({
                PlayersData = BeforePlayerData,
                deaths = deaths,
                kills = kills,
                ranks = BeforeRanks,
                ranksId = ranksId,
                permission = permission
            })
            StartScreenEffect(_EFFECT['blur'], 1, true)
            SetNuiFocus(true, true)
            _NUI.SendNUIMessage('crew:manage', {
                show = true,
                PlayersData = BeforePlayerData,
                deaths = deaths,
                kills = kills,
                playerName = name,
                CrewName = p:getGroup(),
                PlayerLogo = logo,
                ranks = BeforeRanks,
                ranksId = ranksId,
                permission = permission
            })
        end
    else
        StartScreenEffect(_EFFECT['blur'], 1, true)
        SetNuiFocus(true, true)
        _NUI.SendNUIMessage('showGroupCreator', {
            show = true,
            translation = {
                save = GetPhrase('save'),
                create = GetPhrase('crew_create'),
                cancel = GetPhrase('cancel'),
                add_grade = GetPhrase('add_grade'),
                description = GetPhrase('description'),
                descriptionText = GetPhrase('descriptionText'),
                color = GetPhrase('color'),
                name = GetPhrase('name_group'),
                nameText = GetPhrase('nameText'),
                listgrade = GetPhrase('listgrade')
            }
        })
    end
end

RegisterCommand('crew', function()
    _CREW:Watch()
end, false)

RegisterNUICallback('Group:Create', function(_, cb)
    StopScreenEffect(_EFFECT['blur'])
    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showGroupCreator', {
        show = false,
    })
    TriggerServerEvent('core:CreateCrew', Token, _)
    cb('ok')
end)

RegisterNUICallback('crew:create:close', function(_, cb)
    StopScreenEffect(_EFFECT['blur'])
    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('showGroupCreator', {
        show = false,
    })
    cb('ok')
end)

RegisterNUICallback('crew:manage:close', function(_, cb)
    StopScreenEffect(_EFFECT['blur'])
    SetNuiFocus(false, false)
    _NUI.SendNUIMessage('crew:manage', {
        show = false,
        PlayersData = {},
        deaths = 0,
        kills = 0,
        playerName = '',
        CrewName = '',
        PlayerLogo = '',
        ranks = {},
        ranksId = {},
        permission = {}
    })
    cb('ok')
end)

-- crew:manage:deleterank
-- crew:manage:saverank
-- crew:manage:savemembers
-- crew:manage:kickmembers

RegisterNUICallback('crew:manage:saverank', function(_, cb)
    Console.debugPrint(_)
end)

RegisterNUICallback('crew:manage:deleterank', function(_, cb)
    Console.debugPrint(_)
end)
RegisterNUICallback('crew:manage:savemembers', function(_, cb)
    Console.debugPrint(_)
end)
RegisterNUICallback('crew:manage:kickmembers', function(_, cb)
    Console.debugPrint(_)
end)