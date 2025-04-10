local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

Death = {}
local InteractDeath = {}
local damages = {}
Death.GetAllDamagePed = {}
Death.GetBonesType = {
    ["Dos"] = { 0, 23553, 56604, 57597 },
    ["Crâne"] = { 1356, 11174, 12844, 17188, 17719, 19336, 20178, 20279, 20623, 21550, 25260, 27474, 29868, 31086,
        35731, 43536, 45750, 46240, 47419, 47495, 49979, 58331, 61839, 39317 },
    ["Coude droit"] = { 2992 },
    ["Coude gauche"] = { 22711 },
    ["Main gauche"] = { 4089, 4090, 4137, 4138, 4153, 4154, 4169, 4170, 4185, 4186, 18905, 26610, 26611, 26612, 26613,
        26614, 60309 },
    ["Main droite"] = { 6286, 28422, 57005, 58866, 58867, 58868, 58869, 58870, 64016, 64017, 64064, 64065, 64080, 64081,
        64096, 64097, 64112, 64113 },
    ["Bras gauche"] = { 5232, 45509, 61007, 61163 },
    ["Bras droit"] = { 28252, 40269, 43810 },
    ["Jambe droite"] = { 6442, 16335, 51826, 36864 },
    ["Jambe gauche"] = { 23639, 46078, 58271, 63931 },
    ["Pied droit"] = { 20781, 24806, 35502, 52301 },
    ["Pied gauche"] = { 2108, 14201, 57717, 65245 },
    ["Poîtrine"] = { 10706, 64729, 24816, 24817, 24818 },
    ["Ventre"] = { 11816 }
}

Death.GetDeathType = { "Non-Identifiée", "Dégâts de mêlée", "Blessure par balle", "Chute", "Dégâts explosifs", "Feu", "Chute", "Éléctrique", "Écorchure", "Gaz", "Gaz", "Eau" }

Death.GetValueWithTable = function(value, table, number)
    if not value or not table or type(value) ~= "table" then
        return
    end
    for k, v in pairs(value) do
        if number and v[number] == table or v == table then
            return true, k
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(15000)
        if damages.hit then
            damages = {}
        end
    end
end)

local function CEventNetworkEntityDamage(victim, victimDied, damage)
	if not IsPedAPlayer(victim) then return end
	local player = PlayerId()
    local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
	local playerPed = PlayerPedId()
    damage=string.pack("i4",damage)
    damage=string.unpack("f",damage)
    damages.hit = damages.hit and (damages.hit + 1) or 1
    if GetPedArmour(victim) > 0 then
        damages.apdamage = damages.apdamage and (damages.apdamage + damage) or damage
    else
        damages.hpdamage = damages.hpdamage and (damages.hpdamage + damage) or damage
    end
	if victimDied and NetworkGetPlayerIndexFromPed(victim) == player and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim)) then
        local killerEntity = GetPedSourceOfDeath(playerPed)
        local killerServerId = NetworkGetPlayerIndexFromPed(killerEntity)
        if killerEntity ~= playerPed and killerServerId and NetworkIsPlayerActive(killerServerId) then
            PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon, damages)
        else
            PlayerKilled()
        end
	end
end

AddEventHandler('gameEventTriggered', function(event, data)
	if event ~= 'CEventNetworkEntityDamage' then return end

    CEventNetworkEntityDamage(data[1], data[4], data[3])
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon, damage)
  

    local victimCoords = GetEntityCoords(PlayerPedId())
    local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
    local distance = GetDistanceBetweenCoords(victimCoords, killerCoords, true)

    local data = {
        victimCoords = {
            x = math.round(victimCoords.x, 1),
            y = math.round(victimCoords.y, 1),
            z = math.round(victimCoords.z, 1)
        },
        killerCoords = {
            x = math.round(killerCoords.x, 1),
            y = math.round(killerCoords.y, 1),
            z = math.round(killerCoords.z, 1)
        },
        hpDamage = damage.hpdamage or 0,
        apDamage = damage.apdamage or 0,
        hit = damage.hit or 0,
        causeDeath = table.pack(p:GetAllCauseOfDeath()),
        killedByPlayer = true,
        distance = math.round(distance, 1),

        killerServerId = killerServerId,
        killerClientId = killerClientId,
    }
    TriggerEvent('core:onPlayerDeath', data)
    TriggerServerEvent('core:onPlayerDeath', data)

    local mugshot, mugshotStr = Utils.GetPedMugshot(GetPlayerPed(killerClientId))
    Utils.ShowAdvancedNotification('Vous avez été tué par', GetPlayerName(killerClientId), ('Distance: ~b~%s~s~m, Dégâts: ~b~%s~s~hp, ~b~%s~s~ap'):format(distance, damage.hpdamage, damage.apdamage), mugshotStr, mugshotStr)
    UnregisterPedheadshot(mugshot)
end

function PlayerKilled()
    local playerPed = p:ped()
    local victimCoords = p:pos()

    local data = {
        victimCoords = {
            x = math.round(victimCoords.x, 1),
            y = math.round(victimCoords.y, 1),
            z = math.round(victimCoords.z, 1)
        },

        killedByPlayer = false,
        deathCause = GetPedCauseOfDeath(playerPed)
        
    }

    TriggerEvent('core:onPlayerDeath', data)
    TriggerServerEvent('core:onPlayerDeath', data)
end

AddEventHandler('baseevents:onPlayerKilled', function(event, data)
	if event ~= 'CEventNetworkEntityDamage' then return end
    --print("CEventNetworkEntityDamage")
    CEventNetworkEntityDamage(data[1], data[4])
end)

RegisterNetEvent("core:death:UnregisterInteract")
AddEventHandler("core:death:UnregisterInteract", function(player)
    local entity =  GetPlayerPed(GetPlayerFromServerId(player))
    if not InteractDeath[entity] then
        return
    end
    InteractAPI.removeInteraction(InteractDeath[entity])
    InteractAPI.removeInteractionByEntity(entity)
    InteractDeath[entity] = nil
end)

RegisterNetEvent("core:death:RegisterInteract")
AddEventHandler("core:death:RegisterInteract", function(player)
    local entity =  GetPlayerPed(GetPlayerFromServerId(player))
    if GetPlayerServerId(PlayerId()) == player then
        return
    end
    InteractDeath[entity] = InteractAPI.addEntityInteraction({
        netId = entity,
        distance = 10.0,
        interactDst = 10.0,
        offset = vec(0.0, 0.0, 0.0),
        options = {
            {
                label = GetPhrase('Carry'),
                canInteract = function(entity, coords, args)
                    return not isDead
                end,
                action = function(entity, coords, args)
                    CarryPeople(entity)
                end,
            },

            {
                label = GetPhrase('Loot'),
                canInteract = function(entity, coords, args)
                    return not isDead
                end,
                action = function(entity, coords, args)
                    CloseInventory()
                    Citizen.CreateThread(function()
                        CreateProgressBar('steal_target', _CONFIG.STEALTIME * 1000)
                        Wait(_CONFIG.STEALTIME * 1000)
                        LootPlayer(player)
                        Citizen.CreateThread(function()
                            while _INVENTORY.open do
                                local dist = #(GetEntityCoords(entity) - GetEntityCoords(PlayerPedId()))
                                if dist > 5.0 then
                                    _INVENTORY.TargetLoot = nil
                                    CloseInventory()
                                end
                                Wait(1)
                            end
                        end)
                    end)
                end,
            },
            {
                label = GetPhrase('Revive'),
                canInteract = function(entity, coords, args)
                    return not isDead and p:haveItemWithCount('medikit', 1)
                end,
                action = function(entity, coords, args)
                    CloseInventory()
                    Citizen.CreateThread(function()
                        CreateProgressBar('Revive', _CONFIG.REVIVETIME * 1000)
                        Wait(_CONFIG.REVIVETIME * 1000)
                        if not _INVENTORY.open then
                            TriggerServerEvent('core:interact:death', Token, player)
                        end
                    end)
                end,
            },

        }
    })
end)