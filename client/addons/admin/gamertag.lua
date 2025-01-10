local tagBoucle = false
local data_checked = {}
local GamerTag = {}




function ToogleGamerTag()
    tagBoucle = true
    local perm
    GamerTag = {}
    Citizen.CreateThread(function()
        blips = {}
        while tagBoucle do
            for k, v in pairs(GetActivePlayers()) do
                if #(p:pos() - GetEntityCoords(GetPlayerPed(v))) < 100.0 then
                    local serverId = GetPlayerServerId(v)
                    if data_checked[serverId] == nil then
                        perm = TriggerServerCallback("core:admin:getAdminData", serverId)
                        data_checked[serverId] = perm
                    else
                        if data_checked[serverId].permission > 0 then
                            data_checked[serverId] = TriggerServerCallback("core:admin:getAdminData", serverId)
                        end
                        perm = data_checked[serverId]
                    end

                    GamerTag[serverId] = CreateFakeMpGamerTag(GetPlayerPed(v),
                        "[" ..
                        serverId ..
                        "<FONT color='#ffffff'>] [<FONT color='#" ..
                        _PERMISSION_ROLE[perm.permission].colorHex ..
                        "'>" ..
                        _PERMISSION_ROLE[perm.permission].prefix .. "<FONT color='#ffffff'>] " .. GetPlayerName(v),
                        false, false, "", 0)


                    SetMpGamerTagAlpha(GamerTag[serverId], 4, 255)
                    SetMpGamerTagAlpha(GamerTag[serverId], 2, 255)
                    SetMpGamerTagAlpha(GamerTag[serverId], 10, 255)
                    SetMpGamerTagsUseVehicleBehavior(false)
                    local isPlayerTalking = MumbleIsPlayerTalking(v)
                    SetMpGamerTagColour(GamerTag[serverId], 0, 0)

                    SetMpGamerTagVisibility(GamerTag[serverId], 4, isPlayerTalking)
                    -- see the health
                    SetMpGamerTagVisibility(GamerTag[serverId], 2, true)
                    if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(serverId))) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverId))), -1) == GetPlayerPed(GetPlayerFromServerId(serverId)) then
                        SetMpGamerTagVisibility(GamerTag[serverId], 8, true)
                    else
                        SetMpGamerTagVisibility(GamerTag[serverId], 8, false)
                    end

                    if perm.isStaffMode then
                        SetMpGamerTagVisibility(GamerTag[serverId], 7, true)
                    else
                        SetMpGamerTagVisibility(GamerTag[serverId], 7, false)
                    end
                    -- SetMpGamerTagVisibility(GamerTag[serverId], 7, true) -- VIP
                end
            end
            Wait(500)
        end
    end)
end


function DestroyGamerTag()
    for k, v in pairs(GamerTag) do
        RemoveMpGamerTag(v)
    end
    tagBoucle = false
    GamerTag = {}
end
