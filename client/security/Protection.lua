function LPH_JIT_MAX(func)
    return function(...)
        return func(...)
    end
end

function LPH_NO_VIRTUALIZE(func)
    return function(...)
        return func(...)
    end
end

code = GlobalState.Events;




RegisterNetEvent("checkalive", LPH_NO_VIRTUALIZE(function()
    TriggerServerEvent("addalive")
end))

RegisterNetEvent('ANTICHEAT:receiveConfig', function(config)
    _ANTICHEAT = config
end)

-- RegisterNetEvent("SecureServeGetEntitySecurity", function (data)
--     _ANTICHEAT.EntitySecurity = data
-- end)

Citizen.CreateThread(function()
    TriggerServerEvent('ANTICHEAT:requestConfig')
end)

while not _ANTICHEAT do
    TriggerServerEvent('ANTICHEAT:requestConfig')
    Wait(10)
end

Wait(1000)


local function isWhitelisted(event_name)
    for _, whitelisted_event in ipairs(_ANTICHEAT.EventWhitelist) do
        if event_name == whitelisted_event then
            return true
        end
    end
    return false
end

exports('IsEventWhitelistedClient', LPH_NO_VIRTUALIZE(function(event_name)
    return isWhitelisted(event_name)
end))

exports('GetEventWhitelist', LPH_NO_VIRTUALIZE(function()
    return _ANTICHEAT.EventWhitelist
end))

exports('TriggeredEvent', function(event, time)
    if not time then print('banned', GetPlayerServerId(PlayerId())) end
    TriggerServerEvent('ANTICHEAT:TriggerdServerEventCheck', event, time)
end)

--> [Protections] <--
local events = nil
ProtectionCount = {}


for k, v in pairs(_ANTICHEAT.AntiInternal) do
    if v.webhook == "" then
        _ANTICHEAT.AntiInternal[k].webhook = _ANTICHEAT.Webhooks.AntiInternal
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.AntiInternal[k].time = v.time
    end

    name = _ANTICHEAT.AntiInternal[k].detection
    dispatch = _ANTICHEAT.AntiInternal[k].dispatch
    default = _ANTICHEAT.AntiInternal[k].default
    defaultr = _ANTICHEAT.AntiInternal[k].defaultr
    defaults = _ANTICHEAT.AntiInternal[k].defaults
    punish = _ANTICHEAT.AntiInternal[k].punishType
    time = _ANTICHEAT.AntiInternal[k].time
    if type(time) ~= "number" then
        time = v.time
    end
    limit = _ANTICHEAT.AntiInternal[k].limit or 999
    webhook = _ANTICHEAT.AntiInternal[k].webhook
    if webhook == "" then
        webhook = _ANTICHEAT.Webhooks.AntiInternal
    end
    enabled = _ANTICHEAT.AntiInternal[k].enabled
    if name == "Anti RedEngine" then
        Anti_RedEngine_time = time
        Anti_RedEngine_limit = limit
        Anti_RedEngine_webhook = webhook
        Anti_RedEngine_enabled = enabled
        Anti_RedEngine_punish = punish
    elseif name == "Anti Internal" then
        Anti_AntiIntrenal_time = time
        Anti_AntiIntrenal_limit = limit
        Anti_AntiIntrenal_webhook = webhook
        Anti_AntiIntrenal_enabled = enabled
        Anti_AntiIntrenal_punish = punish
    elseif name == "Destroy Input" then
        Anti_Destory_Input_time = time
        Anti_Destory_Input_limit = limit
        Anti_Destory_Input_webhook = webhook
        Anti_Destory_Input_enabled = enabled
        Anti_Destory_Input_punish = punish
    end
end


for k, v in pairs(_ANTICHEAT.Protection.Simple) do
    if v.webhook == "" then
        _ANTICHEAT.Protection.Simple[k].webhook = _ANTICHEAT.Webhooks.Simple
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.Protection.Simple[k].time = v.time
    end

    name = _ANTICHEAT.Protection.Simple[k].protection
    dispatch = _ANTICHEAT.Protection.Simple[k].dispatch
    default = _ANTICHEAT.Protection.Simple[k].default
    defaultr = _ANTICHEAT.Protection.Simple[k].defaultr
    defaults = _ANTICHEAT.Protection.Simple[k].defaults
    time = _ANTICHEAT.Protection.Simple[k].time
    if type(time) ~= "number" then
        time = v.time
    end
    limit = _ANTICHEAT.Protection.Simple[k].limit or 999
    webhook = _ANTICHEAT.Protection.Simple[k].webhook
    if webhook == "" then
        webhook = _ANTICHEAT.Webhooks.Simple
    end
    enabled = _ANTICHEAT.Protection.Simple[k].enabled
    if name == "Anti Give Weapon" then
        Anti_Give_Weapon_time = time
        Anti_Give_Weapon_limit = limit
        Anti_Give_Weapon_webhook = webhook
        Anti_Give_Weapon_enabled = enabled
    elseif name == "Anti Remove Weapon" then
        Anti_Remove_Weapon_time = time
        Anti_Remove_Weapon_limit = limit
        Anti_Remove_Weapon_webhook = webhook
        Anti_Remove_Weapon_enabled = enabled
    elseif name == "Anti Player Blips" then
        Anti_Player_Blips_time = time
        Anti_Player_Blips_limit = limit
        Anti_Player_Blips_webhook = webhook
        Anti_Player_Blips_enabled = enabled
    elseif name == "Anti Car Fly" then
        Anti_Car_Fly_time = time
        Anti_Car_Fly_limit = limit
        Anti_Car_Fly_webhook = webhook
        Anti_Car_Fly_enabled = enabled
    elseif name == "Anti Car Ram" then
        Anti_Car_Ram_time = time
        Anti_Car_Ram_limit = limit
        Anti_Car_Ram_webhook = webhook
        Anti_Car_Ram_enabled = enabled
    elseif name == "Anti Particles" then
        Anti_Particles_time = time
        Anti_Particles_limit = limit
        Anti_Particles_webhook = webhook
        Anti_Particles_enabled = enabled
    elseif name == "Anti Internal" then
        Anti_Internal_time = time
        Anti_Internal_limit = limit
        Anti_Internal_webhook = webhook
        Anti_Internal_enabled = enabled
    elseif name == "Anti Damage Modifier" then
        Anti_Damage_Modifier_default = default
        Anti_Damage_Modifier_time = time
        Anti_Damage_Modifier_limit = limit
        Anti_Damage_Modifier_webhook = webhook
        Anti_Damage_Modifier_enabled = enabled
    elseif name == "Anti Weapon Pickup" then
        Anti_Weapon_Pickup_time = time
        Anti_Weapon_Pickup_limit = limit
        Anti_Weapon_Pickup_webhook = webhook
        Anti_Weapon_Pickup_enabled = enabled
    elseif name == "Anti Remove From Car" then
        Anti_Remove_From_Car_time = time
        Anti_Remove_From_Car_limit = limit
        Anti_Remove_From_Car_webhook = webhook
        Anti_Remove_From_Car_enabled = enabled
    elseif name == "Anti Spectate" then
        Anti_Spectate_time = time
        Anti_Spectate_limit = limit
        Anti_Spectate_webhook = webhook
        Anti_Spectate_enabled = enabled
    elseif name == "Anti Freecam" then
        Anti_Freecam_time = time
        Anti_Freecam_limit = limit
        Anti_Freecam_webhook = webhook
        Anti_Freecam_enabled = enabled
    elseif name == "Anti Explosion Bullet" then
        Anti_Explosion_Bullet_time = time
        Anti_Explosion_Bullet_limit = limit
        Anti_Explosion_Bullet_webhook = webhook
        Anti_Explosion_Bullet_enabled = enabled
    elseif name == "Anti Magic Bullet" then
        Anti_Magic_Bullet_time = time
        Anti_Magic_Bullet_limit = limit
        Anti_Magic_Bullet_webhook = webhook
        Anti_Magic_Bullet_enabled = enabled
    elseif name == "Anti Night Vision" then
        Anti_Night_Vision_time = time
        Anti_Night_Vision_limit = limit
        Anti_Night_Vision_webhook = webhook
        Anti_Night_Vision_enabled = enabled
    elseif name == "Anti Thermal Vision" then
        Anti_Thermal_Vision_time = time
        Anti_Thermal_Vision_limit = limit
        Anti_Thermal_Vision_webhook = webhook
        Anti_Thermal_Vision_enabled = enabled
    elseif name == "Anti God Mode" then
        Anti_God_Mode_time = time
        Anti_God_Mode_limit = limit
        Anti_God_Mode_webhook = webhook
        Anti_God_Mode_enabled = enabled
    elseif name == "Anti Infinite Ammo" then
        Anti_Infinite_Ammo_time = time
        Anti_Infinite_Ammo_limit = limit
        Anti_Infinite_Ammo_webhook = webhook
        Anti_Infinite_Ammo_enabled = enabled
    elseif name == "Anti Teleport" then
        Anti_Teleport_time = time
        Anti_Teleport_limit = limit
        Anti_Teleport_webhook = webhook
        Anti_Teleport_enabled = enabled
    elseif name == "Anti Invisible" then
        Anti_Invisible_time = time
        Anti_Invisible_limit = limit
        Anti_Invisible_webhook = webhook
        Anti_Invisible_enabled = enabled
    elseif name == "Anti Resource Stopper" then
        Anti_Resource_Stopper_dispatch = dispatch
        Anti_Resource_Stopper_time = time
        Anti_Resource_Stopper_limit = limit
        Anti_Resource_Stopper_webhook = webhook
        Anti_Resource_Stopper_enabled = enabled
    elseif name == "Anti Resource Starter" then
        Anti_Resource_Starter_dispatch = dispatch
        Anti_Resource_Starter_time = time
        Anti_Resource_Starter_limit = limit
        Anti_Resource_Starter_webhook = webhook
        Anti_Resource_Starter_enabled = enabled
    elseif name == "Anti Vehicle God Mode" then
        Anti_Vehicle_God_Mode_time = time
        Anti_Vehicle_God_Mode_limit = limit
        Anti_Vehicle_God_Mode_webhook = webhook
        Anti_Vehicle_God_Mode_enabled = enabled
    elseif name == "Anti Vehicle Power Increase" then
        Anti_Vehicle_Power_Increase_time = time
        Anti_Vehicle_Power_Increase_limit = limit
        Anti_Vehicle_Power_Increase_webhook = webhook
        Anti_Vehicle_Power_Increase_enabled = enabled
    elseif name == "Anti Speed Hack" then
        Anti_Speed_Hack_time = time
        Anti_Speed_Hack_limit = limit
        Anti_Speed_Hack_webhook = webhook
        Anti_Speed_Hack_defaultr = defaultr
        Anti_Speed_Hack_defaults = defaults
        Anti_Speed_Hack_enabled = enabled
    elseif name == "Anti Vehicle Spawn" then
        Anti_Vehicle_Spawn_time = time
        Anti_Vehicle_Spawn_limit = limit
        Anti_Vehicle_Spawn_webhook = webhook
        Anti_Vehicle_Spawn_enabled = enabled
    elseif name == "Anti Ped Spawn" then
        Anti_Ped_Spawn_time = time
        Anti_Ped_Spawn_limit = limit
        Anti_Ped_Spawn_webhook = webhook
        Anti_Ped_Spawn_enabled = enabled
    elseif name == "Anti Plate Changer" then
        Anti_Plate_Changer_time = time
        Anti_Plate_Changer_limit = limit
        Anti_Plate_Changer_webhook = webhook
        Anti_Plate_Changer_enabled = enabled
    elseif name == "Anti Cheat Engine" then
        Anti_Cheat_Engine_time = time
        Anti_Cheat_Engine_limit = limit
        Anti_Cheat_Engine_webhook = webhook
        Anti_Cheat_Engine_enabled = enabled
    elseif name == "Anti Rage" then
        Anti_Rage_time = time
        Anti_Rage_limit = limit
        Anti_Rage_webhook = webhook
        Anti_Rage_enabled = enabled
    elseif name == "Anti Aim Assist" then
        Anti_Aim_Assist_time = time
        Anti_Aim_Assist_limit = limit
        Anti_Aim_Assist_webhook = webhook
        Anti_Aim_Assist_enabled = enabled
    elseif name == "Anti Kill All" then
        Anti_Kill_All_time = time
        Anti_Kill_All_limit = limit
        Anti_Kill_All_webhook = webhook
        Anti_Kill_All_enabled = enabled
    elseif name == "Anti Solo Session" then
        Anti_Solo_Session_time = time
        Anti_Solo_Session_limit = limit
        Anti_Solo_Session_webhook = webhook
        Anti_Solo_Session_enabled = enabled
    elseif name == "Anti AI" then
        Anti_AI_default = default
        Anti_AI_time = time
        Anti_AI_limit = limit
        Anti_AI_webhook = webhook
        Anti_AI_enabled = enabled
    elseif name == "Anti No Reload" then
        Anti_No_Reload_time = time
        Anti_No_Reload_limit = limit
        Anti_No_Reload_webhook = webhook
        Anti_No_Reload_enabled = enabled
    elseif name == "Anti Rapid Fire" then
        Anti_Rapid_Fire_time = time
        Anti_Rapid_Fire_limit = limit
        Anti_Rapid_Fire_webhook = webhook
        Anti_Rapid_Fire_enabled = enabled
    elseif name == "Anti Bigger Hitbox" then
        Anti_Bigger_Hitbox_default = default
        Anti_Bigger_Hitbox_time = time
        Anti_Bigger_Hitbox_limit = limit
        Anti_Bigger_Hitbox_webhook = webhook
        Anti_Bigger_Hitbox_enabled = enabled
    elseif name == "Anti No Recoil" then
        Anti_No_Recoil_default = default
        Anti_No_Recoil_time = time
        Anti_No_Recoil_limit = limit
        Anti_No_Recoil_webhook = webhook
        Anti_No_Recoil_enabled = enabled
    elseif name == "Anti State Bag Overflow" then
        Anti_State_Bag_Overflow_time = time
        Anti_State_Bag_Overflow_limit = limit
        Anti_State_Bag_Overflow_webhook = webhook
        Anti_State_Bag_Overflow_enabled = enabled
    elseif name == "Anti Extended NUI Devtools" then
        Anti_Extended_NUI_Devtools_time = time
        Anti_Extended_NUI_Devtools_limit = limit
        Anti_Extended_NUI_Devtools_webhook = webhook
        Anti_Extended_NUI_Devtools_enabled = enabled
    elseif name == "Anti No Ragdoll" then
        Anti_No_Ragdoll_time = time
        Anti_No_Ragdoll_limit = limit
        Anti_No_Ragdoll_webhook = webhook
        Anti_No_Ragdoll_enabled = enabled
    elseif name == "Anti Super Jump" then
        Anti_Super_Jump_time = time
        Anti_Super_Jump_limit = limit
        Anti_Super_Jump_webhook = webhook
        Anti_Super_Jump_enabled = enabled
    elseif name == "Anti Noclip" then
        Anti_Noclip_time = time
        Anti_Noclip_limit = limit
        Anti_Noclip_webhook = webhook
        Anti_Noclip_enabled = enabled
    elseif name == "Anti Infinite Stamina" then
        Anti_Infinite_Stamina_time = time
        Anti_Infinite_Stamina_limit = limit
        Anti_Infinite_Stamina_webhook = webhook
        Anti_Infinite_Stamina_enabled = enabled
    elseif name == "Anti AFK Injection" then
        Anti_AFK_time = time
        Anti_AFK_limit = limit
        Anti_AFK_webhook = webhook
        Anti_AFK_enabled = enabled
    elseif name == "Anti Play Sound" then
        Anti_Play_Sound_time = time
        Anti_Play_Sound_webhook = webhook
        Anti_Play_Sound_enabled = enabled
    end

    if not ProtectionCount["core.Protection.Simple"] then ProtectionCount["core.Protection.Simple"] = 0 end
    ProtectionCount["core.Protection.Simple"] = ProtectionCount["core.Protection.Simple"] + 1
end

for k, v in pairs(_ANTICHEAT.Protection.BlacklistedCommands) do
    if v.webhook == "" then
        _ANTICHEAT.Protection.BlacklistedCommands[k].webhook = _ANTICHEAT.Webhooks.BlacklistedCommands
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.Protection.BlacklistedCommands[k].time = v.time
    end

    if not ProtectionCount["core.Protection.BlacklistedCommands"] then ProtectionCount["core.Protection.BlacklistedCommands"] = 0 end
    ProtectionCount["core.Protection.BlacklistedCommands"] = ProtectionCount["core.Protection.BlacklistedCommands"] + 1
end

for k, v in pairs(_ANTICHEAT.Protection.BlacklistedSprites) do
    if v.webhook == "" then
        _ANTICHEAT.Protection.BlacklistedSprites[k].webhook = _ANTICHEAT.Webhooks.BlacklistedSprites
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.Protection.BlacklistedSprites[k].time = v.time
    end

    if not ProtectionCount["core.Protection.BlacklistedSprites"] then ProtectionCount["core.Protection.BlacklistedSprites"] = 0 end
    ProtectionCount["core.Protection.BlacklistedSprites"] = ProtectionCount["core.Protection.BlacklistedSprites"] + 1
end

for k, v in pairs(_ANTICHEAT.Protection.BlacklistedAnimDicts) do
    if v.webhook == "" then
        _ANTICHEAT.Protection.BlacklistedAnimDicts[k].webhook = _ANTICHEAT.Webhooks.BlacklistedAnimDicts
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.Protection.BlacklistedAnimDicts[k].time = v.time
    end

    if not ProtectionCount["core.Protection.BlacklistedAnimDicts"] then ProtectionCount["core.Protection.BlacklistedAnimDicts"] = 0 end
    ProtectionCount["core.Protection.BlacklistedAnimDicts"] += 1
end


for k, v in pairs(_ANTICHEAT.Protection.BlacklistedExplosions) do
    if v.webhook == "" then
        _ANTICHEAT.Protection.BlacklistedExplosions[k].webhook = _ANTICHEAT.Webhooks.BlacklistedExplosions
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.Protection.BlacklistedExplosions[k].time = v.time
    end

    if not ProtectionCount["core.Protection.BlacklistedExplosions"] then ProtectionCount["core.Protection.BlacklistedExplosions"] = 0 end
    ProtectionCount["core.Protection.BlacklistedExplosions"] += 1
end

for k, v in pairs(_ANTICHEAT.Protection.BlacklistedWeapons) do
    if v.webhook == "" then
        _ANTICHEAT.Protection.BlacklistedWeapons[k].webhook = _ANTICHEAT.Webhooks.BlacklistedWeapons
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.Protection.BlacklistedWeapons[k].time = v.time
    end

    if not ProtectionCount["core.Protection.BlacklistedWeapons"] then ProtectionCount["core.Protection.BlacklistedWeapons"] = 0 end
    ProtectionCount["core.Protection.BlacklistedWeapons"] += 1
end

for k, v in pairs(_ANTICHEAT.Protection.BlacklistedVehicles) do
    if v.webhook == "" then
        _ANTICHEAT.Protection.BlacklistedVehicles[k].webhook = _ANTICHEAT.Webhooks.BlacklistedVehicles
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.Protection.BlacklistedVehicles[k].time = v.time
    end

    if not ProtectionCount["core.Protection.BlacklistedVehicles"] then ProtectionCount["core.Protection.BlacklistedVehicles"] = 0 end
    ProtectionCount["core.Protection.BlacklistedVehicles"] += 1
end

for k, v in pairs(_ANTICHEAT.Protection.BlacklistedObjects) do
    if v.webhook == "" then
        _ANTICHEAT.Protection.BlacklistedObjects[k].webhook = _ANTICHEAT.Webhooks.BlacklistedObjects
    end
    if type(v.time) ~= "number" then
        _ANTICHEAT.Protection.BlacklistedObjects[k].time = v.time
    end

    if not ProtectionCount["core.Protection.BlacklistedObjects"] then ProtectionCount["core.Protection.BlacklistedObjects"] = 0 end
    ProtectionCount["core.Protection.BlacklistedObjects"] = ProtectionCount["core.Protection.BlacklistedObjects"] + 1
end

--> [Events] <--


--> [Methoods] <--
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}


local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = { handle = iter, destructor = disposeFunc }
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end




RegisterNetEvent('core:admin:GetScreenShot', function(reason, type, time)
    exports['screenshot-basic']:requestScreenshotUpload(
    'https://discord.com/api/webhooks/1077657680354758676/tg2wDi4Eqsepd8kE_1w81_O0m_dBQJb8XDh9kIzcl8huuFvRH7mI7UZrAkES5mvZKawb',
        'files[]', function(data)
        local dataa = {}
        local resp = json.decode(data)
        if resp ~= nil and resp.attachments ~= nil and resp.attachments[1] ~= nil and resp.attachments[1].proxy_url ~= nil then
            SCREENSHOT_URL = resp.attachments[1].proxy_url
            dataa.image = SCREENSHOT_URL
            TriggerServerEvent('core:admin:anticheat', reason, nil, type, SCREENSHOT_URL)
        else
            TriggerServerEvent('core:admin:anticheat', reason, nil, type)
        end
    end)
end)

--> [Protections] <--
initialize_protections_aim_assist = LPH_NO_VIRTUALIZE(function()
    if Anti_Aim_Assist_enabled then
        local id = PlayerId()
        -- Citizen.CreateThread(function()
        --     while (true) do
        --         Citizen.Wait(125)
        --         SetPlayerLockon(id, false)
        --         SetPlayerLockonRangeOverride(id, 0.0)
        --         SetPlayerTargetingMode(2)
        --     end
        -- end)
    end
end)

initialize_protections_afk_injection = LPH_JIT_MAX(function()
    if Anti_AFK_enabled then
        Citizen.CreateThread(function()
            while (true) do
                local pid = PlayerPedId()
                if (GetIsTaskActive(pid, 100))
                    or (GetIsTaskActive(pid, 101))
                    or (GetIsTaskActive(pid, 151))
                    or (GetIsTaskActive(pid, 221))
                    or (GetIsTaskActive(pid, 222)) then
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti AFK Injection", 'client_anticheat', time)
                end
                Wait(5000)
            end
        end)
    end
end)

-- Anti_AI_enabled

initialize_protections_AI = LPH_JIT_MAX(function()
    if Anti_AI_enabled then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(15000)
                if IsPlayerCamControlDisabled() ~= false then
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Menyoo", 'client_anticheat', time)
                end
                local weapons = {
                    `COMPONENT_COMBATPISTOL_CLIP_01`,
                    `COMPONENT_COMBATPISTOL_CLIP_02`,
                    `COMPONENT_APPISTOL_CLIP_01`,
                    `COMPONENT_APPISTOL_CLIP_02`,
                    `COMPONENT_MICROSMG_CLIP_01`,
                    `COMPONENT_MICROSMG_CLIP_02`,
                    `COMPONENT_SMG_CLIP_01`,
                    `COMPONENT_SMG_CLIP_02`,
                    `COMPONENT_ASSAULTRIFLE_CLIP_01`,
                    `COMPONENT_ASSAULTRIFLE_CLIP_02`,
                    `COMPONENT_CARBINERIFLE_CLIP_01`,
                    `COMPONENT_CARBINERIFLE_CLIP_02`,
                    `COMPONENT_ADVANCEDRIFLE_CLIP_01`,
                    `COMPONENT_ADVANCEDRIFLE_CLIP_02`,
                    `COMPONENT_MG_CLIP_01`,
                    `COMPONENT_MG_CLIP_02`,
                    `COMPONENT_COMBATMG_CLIP_01`,
                    `COMPONENT_COMBATMG_CLIP_02`,
                    `COMPONENT_PUMPSHOTGUN_CLIP_01`,
                    `COMPONENT_SAWNOFFSHOTGUN_CLIP_01`,
                    `COMPONENT_ASSAULTSHOTGUN_CLIP_01`,
                    `COMPONENT_ASSAULTSHOTGUN_CLIP_02`,
                    `COMPONENT_PISTOL50_CLIP_01`,
                    `COMPONENT_PISTOL50_CLIP_02`,
                    `COMPONENT_ASSAULTSMG_CLIP_01`,
                    `COMPONENT_ASSAULTSMG_CLIP_02`,
                    `COMPONENT_AT_RAILCOVER_01`,
                    `COMPONENT_AT_AR_AFGRIP`,
                    `COMPONENT_AT_PI_FLSH`,
                    `COMPONENT_AT_AR_FLSH`,
                    `COMPONENT_AT_SCOPE_MACRO`,
                    `COMPONENT_AT_SCOPE_SMALL`,
                    `COMPONENT_AT_SCOPE_MEDIUM`,
                    `COMPONENT_AT_SCOPE_LARGE`,
                    `COMPONENT_AT_SCOPE_MAX`,
                    `COMPONENT_AT_PI_SUPP`,
                }
                for i = 1, #weapons do
                    local dmg_mod = GetWeaponComponentDamageModifier(weapons[i])
                    local accuracy_mod = GetWeaponComponentAccuracyModifier(weapons[i])
                    local range_mod = GetWeaponComponentRangeModifier(weapons[i])
                    if dmg_mod > Anti_AI_default or accuracy_mod > Anti_AI_default or range_mod > Anti_AI_default then
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti AIS", 'client_anticheat', time)
                    end
                end
            end
        end)
    end
end)

initialize_protections_no_reload = LPH_NO_VIRTUALIZE(function()
    if Anti_No_Reload_enabled then
        Citizen.CreateThread(function()
            local lastAmmoCount = nil
            local lastWeapon = nil
            local warns = 0
            local playerPed = PlayerPedId()

            while true do
                Citizen.Wait(0)
                local weaponHash = GetSelectedPedWeapon(playerPed)
                local weaponGroup = GetWeapontypeGroup(weaponHash)

                -- Check if player is unarmed
                if weaponHash == `WEAPON_UNARMED` then
                    Citizen.Wait(2500)
                else
                    -- Only proceed if the weapon is not a melee weapon and is ready to shoot
                    if weaponGroup ~= `WEAPON_GROUP_MELEE` and IsPedWeaponReadyToShoot(playerPed) then
                        if IsPedShooting(playerPed) then
                            local currentAmmoCount = GetAmmoInPedWeapon(playerPed, weaponHash)

                            if lastAmmoCount and lastAmmoCount == currentAmmoCount then
                                warns = warns + 1
                                if warns > 7 then
                                    TriggerServerEvent("core:admin:PunishPlayer", nil,
                                        "Player tried to NoReload/infinite ammo", 'client_anticheat', time)
                                end
                            end

                            lastAmmoCount = currentAmmoCount
                            lastWeapon = weaponHash
                        end

                        if lastWeapon and GetAmmoInClip(playerPed, lastWeapon) == 0 then
                            Citizen.Wait(2000)

                            local currentAmmoCount = GetAmmoInPedWeapon(playerPed, lastWeapon)
                            if lastAmmoCount and lastAmmoCount == currentAmmoCount then
                                TriggerServerEvent("core:admin:PunishPlayer", nil, "Player tried to No Reload",
                                    'client_anticheat', time)
                            end

                            lastAmmoCount = nil
                            lastWeapon = nil
                        end
                    else
                        -- Reset if weapon is melee or not ready to shoot
                        lastAmmoCount = nil
                        lastWeapon = nil
                        warns = 0
                    end
                end
            end
        end)
    end
end)

local SafeGetEntityScript = LPH_NO_VIRTUALIZE(function(entity)
    local success, result = pcall(GetEntityScript, entity)

    if not success then
        TriggerServerEvent("core:admin:PunishPlayer", nil, "Created Suspicious Entity [Vehicle] with no script",
            'client_anticheat', time)
        return nil
    end

    if result then
        return result
    else
        return nil
    end
end)

initialize_protections_entity_security = LPH_NO_VIRTUALIZE(function()
    local entitySpawned = {}
    local entitySpawnedHashes = {}
    local whitelistedResources = {}

    for _, entry in ipairs(_ANTICHEAT.EntitySecurity) do
        whitelistedResources[entry.resource] = entry.whitelist
    end

    local function deleteAllObjects()
        for object in Utils.EnumerateObjects() do
            DeleteObject(object)
        end
    end

    RegisterNetEvent('entity2', function(hash)
        entitySpawnedHashes[hash] = true
        Wait(7500)
        entitySpawnedHashes[hash] = false
    end)

    RegisterNetEvent('entityCreatedByScriptClient', function(entity, resource)
        entitySpawned[entity] = true
    end)

    RegisterNetEvent("checkMe", function()
        Wait(450)
        for veh in Utils.EnumerateVehicles() do
            local pop = GetEntityPopulationType(veh)
            if not (pop == 0 or pop == 2 or pop == 4 or pop == 5 or pop == 6) then
                if not entitySpawned[veh] and not entitySpawnedHashes[GetEntityModel(veh)] and DoesEntityExist(veh) then
                    local script = SafeGetEntityScript(veh)
                    local isWhitelisted = whitelistedResources[script] or false
                    if not isWhitelisted then
                        NetworkRegisterEntityAsNetworked(veh)
                        Citizen.Wait(100)
                        local creator = GetPlayerServerId(NetworkGetEntityOwner(veh))
                        if creator ~= 0 and creator == GetPlayerServerId(PlayerId()) and SafeGetEntityScript(veh) ~= '' and SafeGetEntityScript(veh) ~= ' ' and SafeGetEntityScript(veh) ~= nil then
                            TriggerServerEvent('clearall')
                            TriggerServerEvent("core:admin:PunishPlayer", nil,
                                "Created Suspicious Entity [Vehicle] at script: " .. script, 'client_anticheat', time)
                            DeleteEntity(veh)
                        end
                    end
                end
            end
        end


        for ped in Utils.EnumeratePeds() do
            local pop = GetEntityPopulationType(ped)
            if not (pop == 0 or pop == 2 or pop == 4 or pop == 5 or pop == 6) then
                if not entitySpawned[ped] and not entitySpawnedHashes[GetEntityModel(ped)] and DoesEntityExist(ped) then
                    local script = SafeGetEntityScript(ped)
                    local isWhitelisted = whitelistedResources[script] or false
                    local creator = GetPlayerServerId(NetworkGetEntityOwner(ped))
                    if not isWhitelisted and not IsPedAPlayer(ped) and creator == GetPlayerServerId(PlayerId()) and SafeGetEntityScript(ped) ~= '' and SafeGetEntityScript(ped) ~= ' ' and SafeGetEntityScript(ped) ~= nil then
                        if creator ~= 0 then
                            TriggerServerEvent('clearall')
                            TriggerServerEvent("core:admin:PunishPlayer", nil,
                                "Created Suspicious Entity [Ped]" .. script, 'client_anticheat', time)
                            DeleteEntity(ped)
                        end
                    end
                end
            end
        end

        for object in Utils.EnumerateObjects() do
            local pop = GetEntityPopulationType(object)
            if not (pop == 0 or pop == 2 or pop == 4 or pop == 5 or pop == 6) then
                if not entitySpawned[object] and not entitySpawnedHashes[GetEntityModel(object)] and DoesEntityExist(object) then
                    local script = SafeGetEntityScript(object)
                    local isWhitelisted = whitelistedResources[script] or false
                    if not isWhitelisted and SafeGetEntityScript(object) ~= 'ox_inventory' and DoesEntityExist(object) then
                        local creator = GetPlayerServerId(NetworkGetEntityOwner(object))
                        if creator ~= 0 and creator == GetPlayerServerId(PlayerId()) and SafeGetEntityScript(object) ~= '' and SafeGetEntityScript(object) ~= ' ' and SafeGetEntityScript(object) ~= nil then
                            TriggerServerEvent('clearall')
                            TriggerServerEvent("core:admin:PunishPlayer", nil,
                                "Created Suspicious Entity [Object] at script: " .. script, 'client_anticheat', time)
                            DeleteEntity(object)
                            deleteAllObjects()
                        end
                    end
                end
            end
        end
    end)
end)


-- RegisterNetEvent("checkMe", function()
--     Wait(450)
--     for veh in EnumerateVehicles() do
--         local pop = GetEntityPopulationType(veh)
--         if not (pop == 0 or pop == 2 or pop == 4 or pop == 5 or pop == 6) then
--             if not entitySpawned[veh] and DoesEntityExist(veh) then
--                 local script = SafeGetEntityScript(veh)
--                 local isWhitelisted = whitelistedResources[script] or false
--                 if not isWhitelisted then
--                     NetworkRegisterEntityAsNetworked(veh)
--                     Citizen.Wait(100)
--                     local creator = GetPlayerServerId(NetworkGetEntityOwner(veh))
--                     if creator ~= 0 and creator == GetPlayerServerId(PlayerId()) and SafeGetEntityScript(veh) ~= '' and SafeGetEntityScript(veh) ~= ' ' and SafeGetEntityScript(veh) ~= nil then
--                         TriggerServerEvent('clearall')
--                         TriggerServerEvent("core:admin:PunishPlayer" , nil, "Created Suspicious Entity [Vehicle] at script: " .. script, 'client_anticheat', time)
--                         DeleteEntity(veh)
--                     end
--                 end
--             end
--         end
--     end


--     for ped in EnumeratePeds() do
--         local pop = GetEntityPopulationType(ped)
--         if not (pop == 0 or pop == 2 or pop == 4 or pop == 5 or pop == 6) then
--             if not entitySpawned[ped] and DoesEntityExist(ped) then
--                 local script = SafeGetEntityScript(ped)
--                 local isWhitelisted = whitelistedResources[script] or false
--                 local creator = GetPlayerServerId(NetworkGetEntityOwner(ped))
--                 if not isWhitelisted and not IsPedAPlayer(ped) and creator == GetPlayerServerId(PlayerId()) and SafeGetEntityScript(ped) ~= '' and SafeGetEntityScript(ped) ~= ' ' and SafeGetEntityScript(ped) ~= nil then
--                     if creator ~= 0 then
--                         TriggerServerEvent('clearall')
--                         TriggerServerEvent("core:admin:PunishPlayer" , nil, "Created Suspicious Entity [Ped]" .. script, 'client_anticheat', time)
--                         DeleteEntity(ped)
--                     end
--                 end
--             end
--         end
--     end

--     for object in EnumerateObjects() do
--         local pop = GetEntityPopulationType(object)
--         if not (pop == 0 or pop == 2 or pop == 4 or pop == 5 or pop == 6) then
--             if not entitySpawned[object] and DoesEntityExist(object) then
--                 local script = SafeGetEntityScript(object)
--                 local isWhitelisted = whitelistedResources[script] or false
--                 if not isWhitelisted and SafeGetEntityScript(object) ~= 'ox_inventory' and DoesEntityExist(object) then
--                     local creator = GetPlayerServerId(NetworkGetEntityOwner(object))
--                     if creator ~= 0 and creator == GetPlayerServerId(PlayerId()) and SafeGetEntityScript(object) ~= '' and SafeGetEntityScript(object) ~= ' ' and SafeGetEntityScript(object) ~= nil then
--                         TriggerServerEvent('clearall')
--                         TriggerServerEvent("core:admin:PunishPlayer" , nil, "Created Suspicious Entity [Object] at script: " .. script, 'client_anticheat', time)
--                         DeleteEntity(object)
--                         deleteAllObjects()
--                     end
--                 end
--             end
--         end
--     end
-- end)

initialize_protections_explosive_bullets = LPH_JIT_MAX(function()
    -- if Anti_Explosion_Bullet_enabled then
    --     Citizen.CreateThread(function()
    --         while (true) do
    --             Wait(2500)
    --             local weapon = GetSelectedPedWeapon(PlayerPedId())
    --             local damageType = GetWeaponDamageType(weapon)
    --             SetWeaponDamageModifier(GetHashKey("WEAPON_EXPLOSION"), 0.0)
    --             if damageType == 4 or damageType == 5 or damageType == 6 or damageType == 13 then
    --                 TriggerServerEvent("core:admin:PunishPlayer" , nil, "Explosive ammo", 'client_anticheat', time)
    --             end
    --         end
    --     end)
    -- end
end)

initialize_protections_weapon = LPH_JIT_MAX(function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(3)
            local playerPed = PlayerPedId()
            local weapon = GetSelectedPedWeapon(playerPed)
            if weapon == GetHashKey('WEAPON_UNARMED') then
                if IsPedShooting(playerPed) then
                    TriggerServerEvent("core:admin:PunishPlayer", nil,
                        "Player tried to spawn a Safe Weapon with an Executor" .. weapon, 'client_anticheat', time)
                    break
                end
            else
                Citizen.Wait(10000)
            end
        end
    end)
end)

initialize_protections_god_mode = LPH_JIT_MAX(function()
    local playerSpawnTime = GetGameTimer()

    local function HasPlayerSpawnedLongerThan(seconds)
        local currentTime = GetGameTimer()
        return (currentTime - playerSpawnTime) > (seconds * 1000)
    end
    if Anti_God_Mode_enabled then
        local playerFlags = 0
        AddEventHandler("gameEventTriggered", function(name, data)
            if name == "CEventNetworkEntityDamage" then
                local victim = data[1]
                local attacker = data[2]
                local victimHealth = GetEntityHealth(victim)
                if attacker == -1 and (victimHealth == 199 or victimHealth == 0 and not IsPedDeadOrDying(victim)) and victim == PlayerPedId() then
                    playerFlags += 1
                    if playerFlags >= 15 and not Admin.isInService then
                        TriggerServerEvent("core:admin:PunishPlayer", nil,
                            "Triggered Protection Semi Godmode [Semi goddmode]", 'client_anticheat', time)
                    end
                end
            end
        end)

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(5000)

                local curPed = PlayerPedId()

                if not IsNuiFocused() and HasPlayerSpawnedLongerThan(50) then
                    if GetPlayerInvincible_2(PlayerId()) and not IsEntityVisible(curPed) and not IsEntityVisibleToScript(curPed) and not Admin.isInService then
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Triggered Protection Godmode",
                            'client_anticheat', time)
                    end
                end



                if GetEntityModel(curPed) == `mp_m_freemode_01` then
                    if GetEntityHealth(curPed) > 200 and not Admin.isInService then
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Triggered Protection Godmode [Health]",
                            'client_anticheat', time)
                    end
                end

                if GetEntityModel(curPed) == `mp_f_freemode_01` then
                    if GetEntityHealth(curPed) > 100 and not Admin.isInService then
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Triggered Protection Godmode [Health]",
                            'client_anticheat', time)
                    end
                end

                if GetPedArmour(curPed) >= 100 and not Admin.isInService then
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Triggered Protection Godmode [Armour]",
                        'client_anticheat', time)
                end

                local _, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof =
                GetEntityProofs(curPed)
                if bulletProof == 1
                    and meleeProof == 1
                    and steamProof == 1
                    and p7 == 1
                    and drownProof == 1
                then
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Triggered Protection Godmode [Proofs]",
                        'client_anticheat', time)
                end
            end
        end)
    end
end)

local connected = false

function RandomKey(length)
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomString = ""

    for i = 1, length do
        local randomIndex = math.random(1, #characters)
        randomString = randomString .. characters:sub(randomIndex, randomIndex)
    end

    return randomString
end

AddEventHandler('playerSpawned', function()
    if connected then return end
    connected = true
    TriggerServerEvent("playerSpawneda")
    TriggerEvent('allowed')
end)

TriggerServerEvent('mMkHcvct3uIg04STT16I:cbnF2cR9ZTt8NmNx2jQS', RandomKey(math.random(15, 35)))

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10 * 1000)
        TriggerServerEvent('mMkHcvct3uIg04STT16I:cbnF2cR9ZTt8NmNx2jQS', RandomKey(math.random(15, 35)))
    end
end)

initialize_protections_bigger_hitbox = LPH_JIT_MAX(function()
    if Anti_Bigger_Hitbox_enabled then
        Citizen.CreateThread(function()
            while (true) do
                local id = PlayerPedId()
                local ped = GetEntityModel(id)

                if (ped == GetHashKey('mp_m_freemode_01') or ped == GetHashKey('mp_f_freemode_01')) then
                    local min, max = GetModelDimensions(ped)
                    if (min.x > -0.58)
                        or (min.x < -0.62)
                        or (min.y < -0.252)
                        or (min.y < -0.29)
                        or (max.z > 0.98) then
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Bigger Hit Box", webhook,
                            time)
                    end
                end

                Wait(15000)
            end
        end)
    end
end)

initialize_protections_infinite_ammo = LPH_JIT_MAX(function()
    if Anti_Infinite_Ammo_enabled then
        Citizen.CreateThread(function()
            while (true) do
                Wait(5000)

                SetPedInfiniteAmmoClip(PlayerPedId(), false)
            end
        end)
    end
end)



initialize_protections_vehiclespeed = LPH_JIT_MAX(function()
    local warns = 0
    local speed = 0
    Citizen.CreateThread(function()
        while (true) do
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local G = GetVehiclePedIsIn(PlayerPedId(), false)
                local H = GetVehicleTopSpeedModifier(G)
                local MAX_SPEED = GetVehicleEstimatedMaxSpeed(G)
                local VEHSPED   = GetEntitySpeed(G)
                local TOTAL     = MAX_SPEED + 10
                if H >= 100.0 or VEHSPED > TOTAL or VEHSPED > 150 then
                    speed = VEHSPED
                    warns = warns + 1
                end
                if warns > 3 then
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Vehicle speedhack ("..speed..")", 'client_anticheat', 'Ban')
                end
            end
            Citizen.Wait(1500)
        end
    end)
end)
initialize_protections_invisible = LPH_JIT_MAX(function()
    if Anti_Invisible_enabled then
        local warns = 0
        Citizen.CreateThread(function()
            while (true) do
                local ped = PlayerPedId()

                if GetGameTimer() - 120000 > 0 then
                    if ((not IsEntityVisible(ped) and not IsEntityVisibleToScript(ped))
                            or (GetEntityAlpha(ped) <= 150 and GetEntityAlpha(ped) ~= 0)) and not Admin.isInService then
                        SetEntityVisible(GetPlayerPed(-1), true, false)
                        warns = warns + 1

                        if warns > 3 then
                            TriggerServerEvent("core:admin:PunishPlayer", nil, "Invisibility", 'client_anticheat', time)
                        end
                    end
                end

                Citizen.Wait(1500)
            end
        end)
    end
end)

initialize_protections_magic_bullet = function()
end

-- Credits: @stormm1997 ( discord )
initialize_protections_no_ragdoll = LPH_JIT_MAX(function()
    if Anti_No_Ragdoll_enabled then
        local ragdollFlags = 0
        CreateThread(function()
            while true do
                Citizen.Wait(5000)

                local playerPed = PlayerPedId()
                local canRagdoll = CanPedRagdoll(playerPed)

                if not canRagdoll and not IsEntityPositionFrozen(playerPed) and not IsPedInAnyVehicle(playerPed, false)
                    and not IsEntityDead(playerPed) and GetPedParachuteState(playerPed) ~= 2 and not IsEntityAttached(playerPed)
                    and not IsPedJacking(playerPed) and not IsPedJumpingOutOfVehicle(playerPed) then
                    Citizen.Wait(250)

                    playerPed = PlayerPedId()
                    canRagdoll = CanPedRagdoll(playerPed)

                    if not canRagdoll and not IsEntityPositionFrozen(playerPed) and not IsPedInAnyVehicle(playerPed, false)
                        and not IsEntityDead(playerPed) and GetPedParachuteState(playerPed) ~= 2 and not IsEntityAttached(playerPed)
                        and not IsPedJacking(playerPed) and not IsPedJumpingOutOfVehicle(playerPed) then
                        ragdollFlags = ragdollFlags + 1

                        if ragdollFlags >= 3 then
                            TriggerServerEvent("core:admin:PunishPlayer", nil, "No Ragdoll", 'client_anticheat', time)
                            ragdollFlags = 0
                        end
                    end
                end
            end
        end)
    end
end)


initialize_protections_no_recoil = LPH_JIT_MAX(function()
    local spawnTime = GetGameTimer()
    if Anti_No_Recoil_enabled then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(2500)

                local pid = PlayerPedId()
                local playerPed = GetPlayerPed(-1)
                local weapon_hash = GetSelectedPedWeapon(pid)
                local recoil = GetWeaponRecoilShakeAmplitude(weapon_hash)
                local focused = IsNuiFocused()

                local hasBeenSpawnedLongEnough = spawnTime and (GetGameTimer() - spawnTime) > 0

                if hasBeenSpawnedLongEnough and weapon_hash and weapon_hash ~= GetHashKey("weapon_unarmed") and not IsPedInAnyVehicle(pid, false) then
                    if recoil <= 0.0
                        and GetGameplayCamRelativePitch() == 0.0
                        and playerPed ~= nil
                        and weapon_hash ~= -1569615261
                        and not focused
                        and not IsPedArmed(playerPed, 1)
                        and not IsPauseMenuActive()
                        and IsPedShooting(playerPed) then
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti No Recoil", 'client_anticheat', time)
                    end
                end
            end
        end)
    end
end)

local spawnTime = nil

AddEventHandler('playerSpawned', function()
    spawnTime = GetGameTimer()
end)

initialize_protections_noclip = LPH_JIT_MAX(function()
    if Anti_Noclip_enabled then
        Citizen.CreateThread(function()
            local noclipwarns = 0
            while true do
                Wait(100)

                local ped = PlayerPedId()
                local posx, posy, posz = table.unpack(GetEntityCoords(ped, true))
                local still = IsPedStill(ped)
                local vel = GetEntitySpeed(ped)

                Wait(1500)

                local newx, newy, newz = table.unpack(GetEntityCoords(ped, true))
                local newPed = PlayerPedId()

                -- Check if the player has been spawned for more than 1 minute
                local hasBeenSpawnedLongEnough = spawnTime and (GetGameTimer() - spawnTime) > 5000
                if hasBeenSpawnedLongEnough and

                    ((GetDistanceBetweenCoords(posx, posy, posz, newx, newy, newz) > 16) and
                        (still == IsPedStill(ped)) and
                        (vel == GetEntitySpeed(ped)) and
                        not (IsPedInParachuteFreeFall(ped)) and
                        not (IsPedJumpingOutOfVehicle(ped)) and
                        (ped == newPed)) and
                    not IsPedInVehicle(newPed) and
                    not IsPedJumping(newPed) then
                    if not Admin.isInService and (not IsEntityAttached(ped) == 1 or not IsEntityAttached(ped) == true) and
                        not IsEntityPlayingAnim(ped, 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 3) and not IsEntityPlayingAnim(ped, 'amb@world_human_bum_slumped@male@laying_on_left_side@base', 'base', 3) and not IsEntityPlayingAnim(ped, 'nm', 'firemans_carry', 3) then
                        noclipwarns = noclipwarns + 1
                    end
                end
                if (noclipwarns > 3) then
                    noclipwarns = 0
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Noclip", 'client_anticheat', time)
                end
            end
        end)
    end
end)


initialize_protections_player_blips = LPH_JIT_MAX(function()
    if Anti_Player_Blips_enabled then
        Citizen.CreateThread(function()
            while (true) do
                local pid = PlayerId()
                local active_players = GetActivePlayers()

                for i = 1, #active_players do
                    if i ~= pid then
                        local player_ped = GetPlayerPed(i)
                        local blip = GetBlipFromEntity(player_ped)

                        if DoesBlipExist(blip) then
                            TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Player Blips", 'client_anticheat',
                                time)
                        end
                    end
                end

                Citizen.Wait(15000)
            end
        end)
    end
end)

initialize_protections_resources = LPH_JIT_MAX(function()
    if Anti_Resource_Starter_enabled then
        AddEventHandler('onClientResourceStart', function(resourceName)
            local stoppedByServer, startedResources, restarted = TriggerServerCallback('SecureServe:Server_Callbacks:Protections:GetResourceStatus', resourceName)
            if not stoppedByServer and not startedResources and not restarted then
                TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Start Resource " .. resourceName,
                    Anti_Resource_Starter_webhook, Anti_Resource_Starter_time)
            end
        end)
    end

    if Anti_Resource_Stopper_enabled then
        AddEventHandler('onClientResourceStop', function(resourceName)
            local stoppedByServer, startedResources, restarted = TriggerServerCallback('SecureServe:Server_Callbacks:Protections:GetResourceStatus', resourceName)
            if not stoppedByServer and not restarted and not startedResources then
                TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Stop Resource " .. resourceName, 'events_anticheat', Anti_Resource_Stopper_time)
            end
        end)
    end
end)



initialize_protections_spectate = LPH_JIT_MAX(function()
    -- if Anti_Spectate_enabled then
    --     Citizen.CreateThread(function()
    --         while (true) do
    --             Wait(2500)

    --             if (NetworkIsInSpectatorMode()) then
    --                 if not IsAdmin(GetPlayerServerId(PlayerId())) then
    --                     TriggerServerEvent("core:admin:PunishPlayer" , nil, "Anti Spectate", 'client_anticheat', time)
    --                 end
    --             end
    --         end
    --     end)
    -- end
end)

initialize_protections_speed_hack = LPH_JIT_MAX(function()
    if Anti_Speed_Hack_enabled then
        Citizen.CreateThread(function()
            while (true) do
                Citizen.Wait(2750)

                local ped = PlayerPedId()
                if (IsPedInAnyVehicle(ped, false)) then
                    local vehicle = GetVehiclePedIsIn(ped, 0)
                    if (GetVehicleTopSpeedModifier(vehicle) > -1.0) then
                        if GetVehiclePedIsIn(GetPlayerPed(-1), false) then return end

                        DeleteEntity(vehicle)
                        if not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedFalling(PlayerPedId()) then
                            TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Speed Hack", 'client_anticheat',
                                time)
                        end
                    end

                    SetVehicleTyresCanBurst(vehicle, true)
                    SetEntityInvincible(vehicle, false)
                end
            end
        end)
    end
end)

initialize_protections_spoof_shot = LPH_JIT_MAX(function()
    AddEventHandler("gameEventTriggered", function(name, data)
        if name == "CEventNetworkEntityDamage" then
            local victim = data[1]
            local attacker = data[2]
            local hash = data[5]
            local dist = #(GetEntityCoords(victim) - GetEntityCoords(attacker))
            local weapon = GetSelectedPedWeapon(attacker)
            local ped = PlayerPedId()
            if hash ~= weapon and weapon == GetHashKey('WEAPON_UNARMED') and hash ~= GetHashKey('WEAPON_UNARMED') then
                if attacker == ped and not IsPedInAnyVehicle(ped, false) and not attacker == victim and IsPedStill(ped) then
                    if dist >= 10.0 then
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Spoof shot", 'client_anticheat', time)
                    end
                end
            end
        end
    end)
end)

initialize_protections_state_bag_overflow = LPH_JIT_MAX(function()
    AddStateBagChangeHandler(nil, nil, function(bagName, key, value)
        if #key > 131072 then
            if Anti_State_Bag_Overflow_enabled then
                TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti State Bag Overflow",
                    Anti_State_Bag_Overflow_webhook, Anti_State_Bag_Overflow_time)
            end
        end
    end)
end)

initialize_protections_visions = LPH_JIT_MAX(function()
    if not Anti_Thermal_Vision_enabled and not Anti_Night_Vision_enabled then return end
    Citizen.CreateThread(function()
        while (true) do
            Wait(6500)
            if Anti_Thermal_Vision_enabled then
                if (GetUsingseethrough()) then
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Thermal Vision", 'client_anticheat', time)
                end
            end
            if Anti_Night_Vision_enabled then
                if (GetUsingnightvision()) then
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Anti Night Vision", 'client_anticheat', time)
                end
            end
        end
    end)
end)

initialize_protections_weapon_pickup = LPH_JIT_MAX(function()
    if Anti_Weapon_Pickup_enabled then
        Citizen.CreateThread(function()
            while (true) do
                Wait(1750)

                RemoveAllPickupsOfType(GetHashKey("PICKUP_ARMOUR_STANDARD"))
                RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_ARMOUR_STANDARD"))
                RemoveAllPickupsOfType(GetHashKey("PICKUP_HEALTH_SNACK"))
                RemoveAllPickupsOfType(GetHashKey("PICKUP_HEALTH_STANDARD"))
                RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_HEALTH_STANDARD"))
                RemoveAllPickupsOfType(GetHashKey("PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW"))
            end
        end)
    end
end)
--> [Blacklists] <--

initialize_blacklists_commands = LPH_JIT_MAX(function()
    Citizen.CreateThread(function()
        while (true) do
            local registered_commands = GetRegisteredCommands()
            for _, k in pairs(_ANTICHEAT.Protection.BlacklistedCommands) do
                for _, v in pairs(registered_commands) do
                    if k.command == v.name then
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Blacklisted Command (" .. k.command .. ")",
                            'client_anticheat', time)
                    end
                end
            end

            Citizen.Wait(7600)
        end
    end)
end)

initialize_blacklists_sprites = LPH_JIT_MAX(function()
    Citizen.CreateThread(function()
        while (true) do
            for k, v in pairs(_ANTICHEAT.Protection.BlacklistedSprites) do
                if HasStreamedTextureDictLoaded(v.sprite) then
                    TriggerServerEvent("core:admin:PunishPlayer", nil, "Blacklisted Sprite (" .. v.name .. ")",
                        'client_anticheat', time)
                end
            end

            Citizen.Wait(5700)
        end
    end)
end)

initialize_blacklists_weapon = LPH_JIT_MAX(function()
    Citizen.CreateThread(function()
        while (true) do
            Citizen.Wait(9000)

            local player = PlayerPedId()
            local weapon = GetSelectedPedWeapon(player)
            local weapon_name = nil

            for k, v in pairs(_ANTICHEAT.Protection.BlacklistedWeapons) do
                if (weapon == GetHashKey(v.name)) then
                    RemoveWeaponFromPed(player, weapon)
                end
            end
        end
    end)
end)

RegisterCommand("video", function()
    -- duration, webhook
    exports['screenshot-basic']:requestVideoUpload(5000, "https://discord.com/api/webhooks/1077657680354758676/tg2wDi4Eqsepd8kE_1w81_O0m_dBQJb8XDh9kIzcl8huuFvRH7mI7UZrAkES5mvZKawb", "files[]", function(data)
        local videoUrl= json.decode(data).attachments[1].proxy_url
   end)
end, false)

initialize_ocr = LPH_NO_VIRTUALIZE(function()
    local isBusy = false
    RegisterNUICallback("checktext", function(data)
        if data.image and data.text then
            for index, word in next, _ANTICHEAT.OCR, nil do
                if string.find(string.lower(data.text), string.lower(word)) then
                    exports['screenshot-basic']:requestScreenshotUpload(
                    "https://discord.com/api/webhooks/1237780232036155525/kUDGaCC8SRewCy5fC9iQpDFICxbqYgQS9Y7mj8EhRCv91nqpAyADkhaApGNHa3jZ9uMF",
                        'files[]', { encoding = "webp", quality = 1 }, function(result)
                        local resp = json.decode(result)
                        TriggerServerEvent("core:admin:PunishPlayer", nil, "Found word on screen [OCR]: " .. word,
                            'client_anticheat', time)
                    end)
                    break
                end
            end
        end
        isBusy = false
    end)

    Citizen.CreateThread(function()
        Citizen.Wait(5000)
        while true do
            if not isBusy and not IsPauseMenuActive() then
                exports["screenshot-basic"]:requestScreenshot(function(data)
                    Citizen.Wait(1000)
                    SendNUIMessage({
                        action = GetCurrentResourceName() .. ":checkString",
                        image = data
                    })
                end)
                isBusy = true
            end
            Citizen.Wait(5500)
        end
    end)
end)



--> [Init] <--
RegisterCommand('sp', function()
    TriggerEvent('playerSpawned')
end, false)

AddEventHandler('playerSpawned', LPH_NO_VIRTUALIZE(function()
    Citizen.CreateThread(function()
        -- TriggerServerCallback {
        --     eventName = 'SecureServe:Server_Callbacks:Protections:GetConfig',
        --     args = {},
        --     callback = function(result)
        --         SecureServe = result
        --     end
        -- }

        -- while SecureServe == nil do
        --     Wait(0)
        -- end
        -- SecureServe = SecureServe

        --> [Inits] <--
        -- initialize_protections_internal()
        initialize_protections_noclip()
        initialize_protections_entity_security()
        initialize_protections_resources()
        initialize_protections_no_recoil()
        initialize_protections_weapon_pickup()
        initialize_protections_invisible()
        initialize_protections_vehiclespeed()
        initialize_ocr()
        initialize_protections_god_mode()
        initialize_protections_state_bag_overflow()
        initialize_protections_spoof_shot()
        initialize_protections_speed_hack()
        initialize_protections_spectate()
        initialize_protections_no_reload()
        initialize_protections_AI()
        -- initialize_protections_rapid_fire()
        initialize_protections_no_ragdoll()
        initialize_protections_player_blips()
        initialize_protections_magic_bullet()
        initialize_protections_visions()
        initialize_protections_infinite_ammo()
        initialize_protections_bigger_hitbox()
        initialize_protections_explosive_bullets()
        initialize_protections_afk_injection()
        initialize_protections_aim_assist()

        --> [Blacklists] <--
        initialize_blacklists_commands()
        initialize_blacklists_sprites()
        initialize_blacklists_weapon()

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0) -- Run every frame
                local playerPed = PlayerPedId()
                SetEntityProofs(playerPed, false, true, true, true, false, false, false, false)
            end
        end)
    end)
end))


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Check every second
        TriggerServerEvent('playerLoaded')
        break
    end
end)


RegisterNetEvent('SecureServe:checkTaze', function()
    if not HasPedGotWeapon(PlayerPedId(), `WEAPON_STUNGUN`, false) then
        TriggerServerEvent("core:admin:PunishPlayer", nil, "Tried To taze through menu", webhook, 2147483647)
    end
end)

AddEventHandler("gameEventTriggered", function(name, args)
    if name == 'CEventNetworkPlayerCollectedPickup' then
        CancelEvent()
    end
end)


RegisterNUICallback(GetCurrentResourceName(), function()
    TriggerServerEvent("core:admin:PunishPlayer", nil, "Tried To Use Nui Dev Tool", webhook, 2147483647)
end)
