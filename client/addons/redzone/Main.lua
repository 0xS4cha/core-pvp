Zones = {}
local zoneBlips, killeaderBlips = {}, {}
local isPlayerInZone, zoneIndex = false, false
local identifier, thread

Citizen.CreateThread(function()
    TriggerServerEvent("core:redzone:Identifier")
end)



RegisterNetEvent("core:redzone:UpdateZones", function(value, index, key, keyValue, keyIndex, keyIndexValue, keyIndexKey, keyIndexKeyValue)
    if index then
        if key then
            if keyIndex then
                if keyIndexKey then
                    Zones[index][key][keyIndex][keyIndexKey] = keyIndexKeyValue
                else
                    Zones[index][key][keyIndex] = keyIndexValue
                end
            else
                Zones[index][key] = keyValue
            end
        else
            Zones[index] = value
        end
    else
        Zones = value
    end
    if Zones == nil or next(Zones) == nil then
        isPlayerInZone, zoneIndex = false, false
    end
    UpdateZoneUI()
end)

RegisterNetEvent("core:redzone:CreateZone", function()
    CreateZoneBlips()
end)

RegisterNetEvent("core:redzone:RemoveZone", function()
    DeleteBlips()
end)

function CreateZoneBlips()
    for i = 1, #Zones do
        CreateBlip(_REDZONE.ZoneLocations[Zones[i].id])
    end
end

function CreateBlip(v)
    local blip = AddBlipForRadius(v.coords.x, v.coords.y, v.coords.z, v.radius)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 128)
    table.insert(zoneBlips, blip)
end

function DeleteBlips()
    for i = 1, #zoneBlips do
        RemoveBlip(zoneBlips[i])
    end
    zoneBlips = {}
end

AddEventHandler("onResourceStop", function(name)
    if name == GetCurrentResourceName() then
        DeleteBlips()
    end
end)

function enteredZone(zoneId)
    isPlayerInZone = true
    zoneIndex = zoneId
    if not Zones[zoneId].leader then
        local leaderIdentifier = GetKillLeader(Zones[zoneId].players)
        Zones[zoneId].leader = Zones[zoneId].players[leaderIdentifier]
        if not Zones[zoneId].leader then
            Zones[zoneId].leader = {
                n = "None",
                k = 0
            }
        end
    end
    _NUI.SendNUIMessage('showRedzone', {
        show = true,
        scoreboard = {
            zone = Zones[zoneId],
            identifier = identifier,
            myRank = GetMyRank(Zones[zoneId].players)
        }
    })
end

function exitedZone(zoneId)
    isPlayerInZone = false
    zoneIndex = false
    _NUI.SendNUIMessage('showRedzone', {
        show = false,
        scoreboard = {
            zone = Zones[zoneId],
            identifier = identifier,
            myRank = GetMyRank(Zones[zoneId].players)
        }
    })
end

function UpdateZoneUI()
    if isPlayerInZone and zoneIndex then
        if not Zones[zoneIndex].leader then
            local leaderIdentifier = GetKillLeader(Zones[zoneIndex].players)
            Zones[zoneIndex].leader = Zones[zoneIndex].players[leaderIdentifier]
            if not Zones[zoneIndex].leader then
                Zones[zoneIndex].leader = {
                    name = "None",
                    kill = 0
                }
            end
        end
        _NUI.SendNUIMessage('showRedzone', { --REPLACE TO UPDATE
            show = true,
            scoreboard = {
                zone = Zones[zoneIndex],
                identifier = identifier,
                myRank = GetMyRank(Zones[zoneIndex].players)
            }
        })
    end
end


RegisterCommand('redzone', function()
    _NUI.SendNUIMessage('showRedzone', { --REPLACE TO UPDATE
    show = true,
    scoreboard = {
        identifier = "steam:11000010",
        myRank = 4,
        zone = {
          leader = {
            name ="Danny Brian",
            kill = 20,
          },
          totalKills = 100,
          players = {
            ["steam:11000010"] = {
              kill = 20,
            },
          },
        },

          
    }
})
end, false)
Citizen.CreateThread(function()
    local enteredEventSend, exitedEventSend, zoneId = false, true, 1
    while true do
        local sleep, inZone = 750, false
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for i = 1, #Zones do
            local zoneData = _REDZONE.ZoneLocations[Zones[i].id]
            local distance = #(zoneData.coords - coords)
            if distance <= zoneData.radius then
                inZone = true
                zoneId = i
            end
        end
        if inZone and not enteredEventSend then
            enteredEventSend = true
            exitedEventSend = false
            enteredZone(zoneId)
            TriggerServerEvent("core:redzone:enteredZone", zoneId)
        elseif not inZone and not exitedEventSend then
            enteredEventSend = false
            exitedEventSend = true
            exitedZone(zoneId)
            TriggerServerEvent("core:redzone:exitedZone", zoneId)
        end
        Citizen.Wait(sleep)
    end
end)

function IsAnyPlayerInVehicle(vehicle)
    for i = 1, 10 do
        if GetPedInVehicleSeat(vehicle, i) ~= 0 then
            return true
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(math.random(5, 15)*1000)
        RemoveKilleaderBlips()
        for i = 1, #Zones do
            local leaderIdentifier = GetKillLeader(Zones[i].players)
            Zones[i].leader = Zones[i].players[leaderIdentifier]
            local leader = Zones[i].players[leaderIdentifier]
            if leader then
                local playerIdx = GetPlayerFromServerId(leader.s)
                if playerIdx ~= - 1 then
                    local ped = GetPlayerPed(playerIdx)
                    if ped ~= -1 then
                        local blip = AddKillerLeaderBlips(GetEntityCoords(ped))
                        SetBlipInfo(leader, blip, Zones[i].totalKills)
                    end
                end
            end
        end
    end
end)

function SetBlipInfo(leader, blip, total)
    RequestStreamedTextureDict("gfx_logo", 1)
    while not HasStreamedTextureDictLoaded("gfx_logo") do
        Wait(0)
    end
    SetBlipInfoTitle(blip, "Redzone Kill Leader", false)
    SetBlipInfoImage(blip, "gfx_logo", "gfx_logo")
    AddBlipInfoText(blip, "Leader", leader.n)
    AddBlipInfoText(blip, "Killed Player By Leader", tostring(leader.k))
    AddBlipInfoText(blip, "Total Kills", tostring(total))
    AddBlipInfoHeader(blip, "")
    AddBlipInfoText(blip, "This Blip Show The Kill Leader Of The Redzone")
end

function AddKillerLeaderBlips(coords)
    local blip = AddBlipForCoord(coords.x,coords.y,coords.z)
    SetBlipSprite(blip, 310)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.0)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip,true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Kill Leader")
    EndTextCommandSetBlipName(blip)
    table.insert(killeaderBlips, blip)
    return blip
end

function RemoveKilleaderBlips()
    for i = 1, #killeaderBlips do
        RemoveBlip(killeaderBlips[i])
    end
    killeaderBlips = {}
end

function GetKillLeader(t)
    local sortedTable = {}
    for k, v in spairs(t, function(t,a,b) return t[b].k < t[a].k end) do
        if v.s ~= nil then
            if v.i and v.k > 0 then
                table.insert(sortedTable, k)
            end
        end
    end
    return sortedTable[1] ~= nil and sortedTable[1] or false
end

function GetMyRank(t)
    local sortedTable = {}
    for k, v in spairs(t, function(t,a,b) return t[b].k < t[a].k end) do
        if v.s ~= nil then
            if v.i and v.k > 0 then
                table.insert(sortedTable, k)
            end
        end
    end
    local myRank = "None"
    for i = 1, #sortedTable do
        if sortedTable[i] == identifier then
            myRank = i
            break
        end
    end
    return myRank
end

function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end



AddEventHandler('gameEventTriggered', function(name, eventData)
    if name == "CEventNetworkEntityDamage" then
        local ped, victim, killer, isFatal = PlayerPedId(), eventData[1], eventData[2], eventData[6] == 1
        local killerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer))
        local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim)) or tostring(victim==-1 and " " or victim)
        if ped == victim and isFatal then
            if isPlayerInZone and zoneIndex then
                TriggerServerEvent("core:redzone:playerKilled", zoneIndex, killerId, victimId)
            end
        end
    end
end)