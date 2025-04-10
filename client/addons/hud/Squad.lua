_SQUAD = _SQUAD or {}
_SQUAD.Data = {}
_SQUAD.InSquad = false
_SQUAD.SquadId = 0
local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

Citizen.CreateThread(function()
    local sleep
    while true do
        sleep = 10000
        if _SQUAD.SquadId > 0 then
            sleep = 1

            for k, v in pairs(_SQUAD.Data.players) do
                local ped = GetPlayerPed(GetPlayerFromServerId(v.tempId))
                _SQUAD.Data.players[k].GamerTag = CreateFakeMpGamerTag(ped, v.name, false, false, "", 0)

                SetMpGamerTagAlpha(_SQUAD.Data.players[k].GamerTag, 4, 255)
                SetMpGamerTagAlpha(_SQUAD.Data.players[k].GamerTag, 2, 255)
                SetMpGamerTagAlpha(_SQUAD.Data.players[k].GamerTag, 10, 255)
                SetMpGamerTagsUseVehicleBehavior(false)
                local isPlayerTalking = MumbleIsPlayerTalking(GetPlayerFromServerId(v.tempId))
                SetMpGamerTagColour(_SQUAD.Data.players[k].GamerTag, 0, 0)

                SetMpGamerTagVisibility(_SQUAD.Data.players[k].GamerTag, 4, isPlayerTalking)
                -- see the health
                SetMpGamerTagVisibility(_SQUAD.Data.players[k].GamerTag, 2, true)
                if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, -1)) == ped then
                    SetMpGamerTagVisibility(_SQUAD.Data.players[k].GamerTag, 8, true)
                else
                    SetMpGamerTagVisibility(_SQUAD.Data.players[k].GamerTag, 8, false)
                end
                _SQUAD.Data.players[k].health = GetEntityHealth(ped) - 100
                _SQUAD.Data.players[k].armor = GetPedArmour(ped)

                if not _SQUAD.Data.players[k].blip then
                    local blip = AddBlipForEntity(ped)
                    SetBlipSprite(blip, 1)
                    ShowFriendIndicatorOnBlip(blip, true)
                    SetBlipColour(blip, 37)
                    SetBlipScale(blip, 0.75)
                    ShowHeadingIndicatorOnBlip(blip, true)
                    SetBlipShowCone(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(v.name)
                    EndTextCommandSetBlipName(blip)
                    _SQUAD.Data.players[k].blip = blip
                end
            end
            _NUI.SendNUIMessage('updateSquad', _SQUAD.Data.players)
        end
        Wait(sleep)
    end
end)
RegisterNetEvent("core:squad:cl_create", function(data)
    _SQUAD.InSquad = true
    _SQUAD.SquadId = data.id
    _SQUAD.Data    = data
    for k, v in pairs(_SQUAD.Data.players) do
        local ped = GetPlayerPed(GetPlayerFromServerId(v.tempId))
        v.health = GetEntityHealth(ped) - 100
        v.armor = GetPedArmour(ped)
    end
    _NUI.SendNUIMessage('showSquad', {
        show = true,
        data = _SQUAD.Data.players
    })
end)

RegisterNetEvent("core:squad:reset", function()
    for i = 1, #_SQUAD.Data.players do
        local selected = _SQUAD.Data.players[i]
        if selected.blip then
            RemoveBlip(selected.blip)
        end
        if selected.GamerTag then
            RemoveMpGamerTag(selected.GamerTag)
        end
    end
    _SQUAD.Data = {}
    _SQUAD.InSquad = false
    _SQUAD.SquadId = 0
    _NUI.SendNUIMessage('showSquad', {
        show = false,
        data = {}
    })
end)
RegisterNetEvent("core:squad:update", function(data, kicked)
    local oldData = _SQUAD.Data
    _SQUAD.SquadId = data.id
    _SQUAD.Data    = data
    if kicked then
        for i = 1, #oldData.players do
            local selected = oldData.players[i]
            if selected.tempId == kicked then
                if selected.blip then
                    RemoveBlip(selected.blip)
                end
                if selected.GamerTag then
                    RemoveMpGamerTag(selected.GamerTag)
                end
            end
        end
    end
    for k, v in pairs(_SQUAD.Data.players) do
        local ped = GetPlayerPed(GetPlayerFromServerId(v.tempId))
        v.health = GetEntityHealth(ped) - 100
        v.armor = GetPedArmour(ped)
    end
    _NUI.SendNUIMessage('updateSquad', _SQUAD.Data.players)
end)

RegisterNetEvent("core:squad:allowToInvite", function()
    local player = Utils.ChoicePlayersInZone(5.0, false)
    if player then
        if not GetPlayerServerId(player) then
            return
        end
        TriggerServerEvent('core:squad:invite', Token, GetPlayerServerId(player))
    end
end)
