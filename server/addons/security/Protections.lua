
for k,v in pairs(_SECURITY.AntiInternal) do
    if v.webhook == "" then
        _SECURITY.AntiInternal[k].webhook = _SECURITY.Webhooks.AntiInternal
    end
    if type(v.time) ~= "number" then
        _SECURITY.AntiInternal[k].time = v.time
    end
    
    name = _SECURITY.AntiInternal[k].detection
    dispatch = _SECURITY.AntiInternal[k].dispatch
    default = _SECURITY.AntiInternal[k].default
    defaultr = _SECURITY.AntiInternal[k].defaultr
    defaults = _SECURITY.AntiInternal[k].defaults
    punish = _SECURITY.AntiInternal[k].punishType
    time = _SECURITY.AntiInternal[k].time
    if type(time) ~= "number" then
        time = v.time
    end
    limit = _SECURITY.AntiInternal[k].limit or 999
    webhook = _SECURITY.AntiInternal[k].webhook
    if webhook == "" then
        webhook = _SECURITY.Webhooks.AntiInternal
    end
    enabled = _SECURITY.AntiInternal[k].enabled
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


for k,v in pairs(_SECURITY.Protection.Simple) do
    if v.webhook == "" then
        _SECURITY.Protection.Simple[k].webhook = _SECURITY.Webhooks.Simple
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.Simple[k].time = v.time
    end
    
    name = _SECURITY.Protection.Simple[k].protection
    dispatch = _SECURITY.Protection.Simple[k].dispatch
    default = _SECURITY.Protection.Simple[k].default
    defaultr = _SECURITY.Protection.Simple[k].defaultr
    defaults = _SECURITY.Protection.Simple[k].defaults
    time = _SECURITY.Protection.Simple[k].time
    if type(time) ~= "number" then
        time = v.time
    end
    limit = _SECURITY.Protection.Simple[k].limit or 999
    webhook = _SECURITY.Protection.Simple[k].webhook
    if webhook == "" then
        webhook = _SECURITY.Webhooks.Simple
    end
    enabled = _SECURITY.Protection.Simple[k].enabled
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
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.Simple"] then _ANTICHEAT.ProtectionCount["Core.Protection.Simple"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.Simple"] = _ANTICHEAT.ProtectionCount["Core.Protection.Simple"] + 1
end


for k,v in pairs(_SECURITY.Protection.BlacklistedCommands) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedCommands[k].webhook = _SECURITY.Webhooks.BlacklistedCommands
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedCommands[k].time = v.time
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedCommands"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedCommands"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedCommands"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedCommands"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedSprites) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedSprites[k].webhook = _SECURITY.Webhooks.BlacklistedSprites
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedSprites[k].time = v.time
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedSprites"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedSprites"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedSprites"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedSprites"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedAnimDicts) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedAnimDicts[k].webhook = _SECURITY.Webhooks.BlacklistedAnimDicts
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedAnimDicts[k].time = v.time
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedAnimDicts"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedAnimDicts"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedAnimDicts"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedAnimDicts"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedExplosions) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedExplosions[k].webhook = _SECURITY.Webhooks.BlacklistedExplosions
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedExplosions[k].time = v.time
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedExplosions"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedExplosions"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedExplosions"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedExplosions"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedWeapons) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedWeapons[k].webhook = _SECURITY.Webhooks.BlacklistedWeapons
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedWeapons[k].time = v.time
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedWeapons"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedWeapons"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedWeapons"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedWeapons"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedVehicles) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedVehicles[k].webhook = _SECURITY.Webhooks.BlacklistedVehicles
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedVehicles[k].time = v.time
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedVehicles"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedVehicles"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedVehicles"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedVehicles"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedObjects) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedObjects[k].webhook = _SECURITY.Webhooks.BlacklistedObjects
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedObjects[k].time = v.time
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedObjects"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedObjects"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedObjects"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedObjects"] + 1
end


initialize_protections_damage = LPH_JIT_MAX(function ()
    AddEventHandler("weaponDamageEvent", function(source, data)
        if true and data.weaponType == 3452007600 and data.weaponDamage == 512 then
            TriggerEvent('core:admin:anticheat', 'Tried to kill player using cheats (3452007600, 512)', source)
            CancelEvent()
        elseif true and data.weaponType == 133987706 and data.damageTime > 200000 and data.weaponDamage > 200 then
            TriggerEvent('core:admin:anticheat', 'Tried to kill player using cheats (133987706)', source)
            CancelEvent()
        end
    
        if true then
            if data.silenced and data.weaponDamage == 0 and data.weaponType == 2725352035 then
                TriggerEvent('core:admin:anticheat', 'Tried to kill player using cheats (2725352035)', source)
            elseif data.silenced and data.weaponDamage == 0 and data.weaponType == 3452007600 then
                TriggerEvent('core:admin:anticheat', 'Tried to kill player using cheats (3452007600)', source)

            end
        end
    end)
end)

initialize_protections_entity_lockdown = function()
    Citizen.CreateThread(function ()
        SetConvar("sv_filterRequestControl", "4")
        SetConvar("sv_entityLockdown", _SECURITY.EntityLockdownMode)
        SetConvar("onesync_distanceCullVehicles", "true")
    end)
end


RegisterNetEvent('core:admin:clearall', function()
    for i, obj in pairs(GetAllObjects()) do
        DeleteEntity(obj)
    end
    for i, ped in pairs(GetAllPeds()) do
        DeleteEntity(ped)
    end
    for i, veh in pairs(GetAllVehicles()) do
        DeleteEntity(veh)
    end
end)

local function clear()
    for i, obj in pairs(GetAllObjects()) do
        DeleteEntity(obj)
    end
    for i, ped in pairs(GetAllPeds()) do
        DeleteEntity(ped)
    end
    for i, veh in pairs(GetAllVehicles()) do
        DeleteEntity(veh)
    end
end

initialize_protections_entity_spam = LPH_JIT_MAX(function()
    local SV_VEHICLES = {}
    local SV_PEDS = {}
    local SV_OBJECT = {}
    local SV_Userver = {}


    AddEventHandler('entityCreated', function (entity)
        if DoesEntityExist(entity) then
            local POPULATION = GetEntityPopulationType(entity)
            if POPULATION == 7 or POPULATION == 0 then
                TriggerClientEvent('checkMe', -1)
            end
        end
    end)

    AddEventHandler("entityCreated", function(ENTITY)
        if DoesEntityExist(ENTITY) then
            local TYPE       = GetEntityType(ENTITY)
            local OWNER      = NetworkGetFirstEntityOwner(ENTITY)
            local POPULATION = GetEntityPopulationType(ENTITY)
            local MODEL      = GetEntityModel(ENTITY)
            local HWID       = GetPlayerToken(OWNER, 0)
            if TYPE == 2 and POPULATION == 7 then
                if SV_VEHICLES[HWID] ~= nil then
                    SV_VEHICLES[HWID].COUNT = SV_VEHICLES[HWID].COUNT + 1
                    if os.time() - SV_VEHICLES[HWID].TIME >= 10 then
                        SV_VEHICLES[HWID] = nil
                    else
                        if SV_VEHICLES[HWID].COUNT >= _SECURITY.maxVehicle then
                            for _, vehilce in ipairs(GetAllVehicles()) do
                                local ENO = NetworkGetFirstEntityOwner(vehilce)
                                if ENO == OWNER then
                                    if DoesEntityExist(vehilce) then
                                        DeleteEntity(vehilce)
                                    end
                                end
                            end
                            if not SV_Userver[HWID] then
                            SV_Userver[HWID] = true
                                clear()
                                TriggerEvent('core:admin:anticheat', 'Try To Spam Vehicles: '.. SV_VEHICLES[HWID].COUNT, OWNER, 'vehicle_anticheat')
                                CancelEvent()
                            end
                        end
                    end
                else
                    SV_VEHICLES[HWID] = {
                        COUNT = 1,
                        TIME  = os.time()
                    }
                end
            elseif TYPE == 1 and POPULATION == 7 then
                if SV_PEDS[HWID] ~= nil then
                    SV_PEDS[HWID].COUNT = SV_PEDS[HWID].COUNT + 1
                    if os.time() - SV_PEDS[HWID].TIME >= 10 then
                        SV_PEDS[HWID] = nil
                    else
                        for _, peds in ipairs(GetAllPeds()) do
                            local ENO = NetworkGetFirstEntityOwner(peds)
                            if ENO == OWNER then
                                if DoesEntityExist(peds) then
                                    DeleteEntity(peds)
                                end
                            end
                        end
                        if SV_PEDS[HWID].COUNT >= _SECURITY.maxPed then
                            if not SV_Userver[HWID] then
                            clear()
                            TriggerEvent('core:admin:anticheat', 'Try To Spam Peds: '.. SV_PEDS[HWID].COUNT, OWNER, 'ped_anticheat')

                            CancelEvent()
                            SV_Userver[HWID] = true
                            end
                        end
                    end
                else
                    SV_PEDS[HWID] = {
                        COUNT = 1,
                        TIME  = os.time()
                    }
                    
                end
            elseif TYPE == 3 and POPULATION == 7 then
                HandleAntiSpamObjects(HWID, OWNER)
            end
        end
    end)

    local COOLDOWN_TIME = 10
    function HandleAntiSpamObjects(HWID, OWNER)
    
        if SV_OBJECT[HWID] ~= nil then
            SV_OBJECT[HWID].COUNT = SV_OBJECT[HWID].COUNT + 1
            if os.time() - SV_OBJECT[HWID].TIME >= COOLDOWN_TIME then
                SV_OBJECT[HWID] = nil
            else
                if SV_OBJECT[HWID].COUNT >= _SECURITY.maxObject then
                    for _, objects in ipairs(GetAllObjects()) do
                        local ENO = NetworkGetFirstEntityOwner(objects)
                        if ENO == OWNER and DoesEntityExist(objects) then
                            DeleteEntity(objects)
                        end
                    end
                    if not SV_Userver[HWID] then
                        SV_Userver[HWID] = true
                        clear()
                        TriggerEvent('core:admin:anticheat', 'Try To Spam Objects: '.. SV_OBJECT[HWID].COUNT, OWNER, 'object_anticheat')
                        CancelEvent()
                    end
                end
            end
        else
            SV_OBJECT[HWID] = {
                COUNT = 1,
                TIME = os.time()
            }
        end
    end
    ECount = {}
end)


initialize_protections_explosions = LPH_JIT_MAX(function()
    local whitelist = {}

    RegisterNetEvent("core:Explosions:Whitelist", function(data)
        whitelist[data.source] = true
    end)

    local explosions = {}
    local detected = {}
    local false_explosions = {
        [11] = true,
        [12] = true,
        [13] = true,
        [24] = true,
        [30] = true,
    }

    AddEventHandler('explosionEvent', function(sender, ev)
        explosions[sender] = explosions[sender] or {}

        local explosionType = ev.explosionType
        local explosionPos = ev.posX and ev.posY and ev.posZ and vector3(ev.posX, ev.posY, ev.posZ) or "Unknown"
        local explosionDamage = ev.damageScale or "Unknown"
        local explosionOwner = GetPlayerName(sender) or "Unknown"

        print(string.format("Explosion detected! Type: %s | Position: %s | Damage Scale: %s | Owner: %s", 
            explosionType, explosionPos, explosionDamage, explosionOwner))
        local resourceName = GetInvokingResource()
        if GetPlayerPing(sender) > 0  then
            if whitelist[sender] or _SECURITY.ExplosionsWhitelist[resourceName] then
                whitelist[sender] = false
            else

                    _ANTICHEAT.punish_player(sender, string.format("Explosion Details: Type: %s, Position: %s, Damage Scale: %s",  explosionType, explosionPos, explosionDamage), 'Ban', 'explosion_anticheat')
                    CancelEvent()
            end
        end

        for k, v in pairs(_SECURITY.Protection.BlacklistedExplosions) do
            if ev.explosionType == v.id then
                local explosionInfo = string.format("Explosion Type: %d, Position: (%.2f, %.2f, %.2f)", ev.explosionType, ev.posX, ev.posY, ev.posZ)

                if v.limit and explosions[sender][v.id] and explosions[sender][v.id] >= v.limit then
                    _ANTICHEAT.punish_player(sender, "Exceeded explosion limit at explosion: " .. v.id .. ". " .. explosionInfo, v.time,'explosion_anticheat')
                    CancelEvent()
                    return
                end

                explosions[sender][v.id] = (explosions[sender][v.id] or 0) + 1

                if v.limit and explosions[sender][v.id] > v.limit then
                    _ANTICHEAT.punish_player(sender, "Exceeded explosion limit at explosion: " .. v.id .. ". " .. explosionInfo, v.time,'explosion_anticheat')
                    CancelEvent()
                    return
                end

                if v.limit then
                    if explosions[sender][v.id] > v.limit then
                        if false_explosions[ev.explosionType] then return end
                        if not detected[sender] then
                            detected[sender] = true
                            CancelEvent()
                            _ANTICHEAT.punish_player(sender, "Exceeded explosion limit at explosion: " .. v.id .. ". " .. explosionInfo, v.time,'explosion_anticheat')
                        end
                    end
                end

                if v.audio and ev.isAudible == false then
                    _ANTICHEAT.punish_player(sender, "Used inaudible explosion. " .. explosionInfo, v.time,'explosion_anticheat')
                    CancelEvent()
                    return
                end

                if v.invisible and ev.isInvisible == true then
                    _ANTICHEAT.punish_player(sender, "Used invisible explosion. " .. explosionInfo, v.time,'explosion_anticheat')
                   CancelEvent()
                    return
                end

                if v.damageScale and ev.damageScale > 1.0 then
                    _ANTICHEAT.punish_player(sender, "Used boosted explosion. " .. explosionInfo, v.time,'explosion_anticheat')
                   return
                end

                if _SECURITY.Protection.CancelOtherExplosions then
                    for k, v in pairs(_SECURITY.Protection.BlacklistedExplosions) do
                        if ev.explosionType ~= v.id then
                            CancelEvent()
                        end
                    end
                end
            end
        end

        if ev.ownerNetId == 0 then
            CancelEvent()
        end
    end)


--[[
    AddEventHandler('explosionEvent', function(sender, ev)
        explosions[sender] = explosions[sender] or {}
        
        
        if GetPlayerPing(sender) > 0 then
            if whitelist[sender] then
                whitelist[sender] = false
            else
                -- punish_player(sender, "Try To Spam Objects: ", webhook, time)
                Console.Warn("Beta explosion detected source", sender)
            end
        end

        for k, v in pairs(_SECURITY.Protection.BlacklistedExplosions) do
            if ev.explosionType == v.id then
                local explosionInfo = string.format("Explosion Type: %d, Position: (%.2f, %.2f, %.2f)", ev.explosionType, ev.posX, ev.posY, ev.posZ)

                if v.limit and explosions[sender][v.id] and explosions[sender][v.id] >= v.limit then
                    TriggerEvent('core:admin:anticheat', 'Try To Spam Explosions: '.. explosions[sender][v.id], sender, 'explosion_anticheat')
                    CancelEvent()
                    return
                end

                explosions[sender][v.id] = (explosions[sender][v.id] or 0) + 1

                if v.limit and explosions[sender][v.id] > v.limit then
                    TriggerEvent('core:admin:anticheat', 'Try To Spam Explosions: '.. explosions[sender][v.id], sender, 'explosion_anticheat')
                    CancelEvent()
                    return
                end

                if v.limit then
                    if explosions[sender][v.id] > v.limit then
                        if false_explosions[ev.explosionType] then return end
                        if not detected[sender] then
                            detected[sender] = true
                            CancelEvent()
                            TriggerEvent('core:admin:anticheat', 'Try To Spam Explosions: '.. explosions[sender][v.id], sender, 'explosion_anticheat')
                            CancelEvent()
                            return
                        end
                    end
                end

                if v.audio and ev.isAudible == false then
                    TriggerEvent('core:admin:anticheat', 'Used inaudible explosion. ' .. explosionInfo, sender, 'explosion_anticheat')
                    CancelEvent()
                    return
                end

                if v.invisible and ev.isInvisible == true then
                    TriggerEvent('core:admin:anticheat', 'Used invisible explosion. ' .. explosionInfo, sender, 'explosion_anticheat')
                    CancelEvent()
                    return
                end

                if v.damageScale and ev.damageScale > 1.0 then
                    TriggerEvent('core:admin:anticheat', 'Used boosted explosion. ' .. explosionInfo, sender, 'explosion_anticheat')
                    CancelEvent()
                    return
                end

                if _SECURITY.Protection.CancelOtherExplosions then
                    for k, v in pairs(_SECURITY.Protection.BlacklistedExplosions) do
                        if ev.explosionType ~= v.id then
                            
                            CancelEvent()
                        end
                    end
                end
            end
        end

        if ev.ownerNetId == 0 then
            CancelEvent()
        end
    end)--]]

end)



AddEventHandler('entityCreating', function(entity)
    local model
    local owner
    local entityType

    if not DoesEntityExist(entity) then
        CancelEvent()
        return
    end

    if DoesEntityExist(entity) then
        model = GetEntityModel(entity)
        entityType = GetEntityType(entity)
        owner = NetworkGetEntityOwner(entity)
    end
    if entityType == 3 then
        for _, player in pairs(GetPlayers()) do
            local playerPed = GetPlayerPed(player)
            local playerCoords = GetEntityCoords(playerPed)
            local entityCoords = GetEntityCoords(entity)
            local distance = #(playerCoords - entityCoords)

            if distance < 5 then
                CancelEvent()
            end
        end
    end
end)


local function onPlayerDisconnected()
    local playerId = source
    _ANTICHEAT.playerHeartbeats[playerId] = nil
end
AddEventHandler("playerDropped", onPlayerDisconnected)

RegisterNetEvent("mMkHcvct3uIg04STT16I:cbnF2cR9ZTt8NmNx2jQS", function(key)
    local playerId = source
    if string.len(key) < 15 or string.len(key) > 35 or key == nil then
        _ANTICHEAT.punish_player(playerId, "Tried to stop the anticheat",  'Ban', "event_anticheat")    
    else
        _ANTICHEAT.playerHeartbeats[playerId] = os.time()
    end
end)

Citizen.CreateThread(LPH_JIT_MAX(function()
    while true do
        Citizen.Wait(10 * 1000)
        for playerId, lastHeartbeatTime in pairs(_ANTICHEAT.playerHeartbeats) do
            if lastHeartbeatTime == nil then return end
            local currentTime = os.time()
            local timeSinceLastHeartbeat = currentTime - lastHeartbeatTime
            if timeSinceLastHeartbeat > 15 * 1000 then
                Console.Warn(("Player [%s] %s didn't sent any heartbeat to the server in required time. Last response: %s seconds ago"):format(playerId, GetPlayerName(playerId), timeSinceLastHeartbeat), "info")
                TriggerEvent('core:admin:anticheat', 'Tried to stop the anticheat', playerId)
                _ANTICHEAT.playerHeartbeats[playerId] = nil
            end
        end
    end
end))


initialize_server_protections_play_sound = function()
    if (Anti_Play_Sound_enabled) then
        if (GetConvar("sv_enableNetworkedSounds", "true") == "false") then return end
        SetConvar("sv_enableNetworkedSounds", "false")
    end
end


initialize_protections_ptfx = LPH_JIT_MAX(function()
    local particlesSpawned = {}
    AddEventHandler('ptFxEvent', function(sender, data)
        if (Anti_Particles_enabled) then
            particlesSpawned[sender] = (particlesSpawned[sender] or 0) + 1
            if (particlesSpawned[sender] > Anti_Particles_limit) then
                CancelEvent()
                _ANTICHEAT.punish_player(sender, "Anti Particle Spam",  Anti_Particles_time, "particle_anticheat")                
                return
            end
            if (data.effectHash == 2341015072) then
                CancelEvent()
                _ANTICHEAT.punish_player(sender, "Anti Fire Player",  Anti_Particles_time, "fire_anticheat")                
            end
            CancelEvent()
        end
    end)
end)


AddEventHandler('entityCreating', function(entity)
    local model
    local owner
    local entityType
  
    if not DoesEntityExist(entity) then
      CancelEvent()
      return
    end
  
    if DoesEntityExist(entity) then
      model = GetEntityModel(entity)
      entityType = GetEntityType(entity)
      owner = NetworkGetEntityOwner(entity)
    end
    if entityType == 2 and DoesEntityExist(entity) then
        local src = NetworkGetEntityOwner(entity)
        local entityPopulationType = GetEntityPopulationType(entity)
    
        if src == nil or owner == nil then
          CancelEvent()
        end

        for k, v in pairs(_SECURITY.Protection.BlacklistedVehicles) do
            if model == GetHashKey(v.name) then
                _ANTICHEAT.punish_player(src, "Blacklisted Vehicle (" .. v.name .. ")",  'Ban', "vehicle_anticheat")     
                CancelEvent()
            end
        end
    end
end)  


local playerProximitySpawns = {}
local proximityThreshold = 10.0 -- Distance in meters to consider an entity spawn "near" a player
local timeWindow = 60000 -- 60 seconds
local maxProximitySpawns = 15 -- Maximum allowed nearby spawns within the time window
local cooldownPeriod = 1000 -- 1 second cooldown between allowed spawns

local function initializePlayerData(playerId)
    playerProximitySpawns[playerId] = {
        spawns = {},
        lastSpawnTime = 0
    }
end

local function isEntityNearAnyPlayer(entity)
    local entityCoords = GetEntityCoords(entity)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local playerPed = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - entityCoords)
        if distance <= proximityThreshold then
            return true, playerId
        end
    end
    return false, nil
end

local function updateProximitySpawns(playerId, currentTime)
    local playerData = playerProximitySpawns[playerId]
    
    -- Remove old spawn entries
    for i = #playerData.spawns, 1, -1 do
        if currentTime - playerData.spawns[i] > timeWindow then
            table.remove(playerData.spawns, i)
        else
            break -- Assuming spawns are stored in chronological order
        end
    end
    
    -- Add new spawn
    table.insert(playerData.spawns, currentTime)
    
    return #playerData.spawns
end


AddEventHandler('entityCreating', function(entity)
    local ownerPlayerId = NetworkGetEntityOwner(entity)
    local isNearPlayer, nearestPlayerId = isEntityNearAnyPlayer(entity)
    
    if isNearPlayer then
        if not playerProximitySpawns[ownerPlayerId] then
            initializePlayerData(ownerPlayerId)
        end

        local playerData = playerProximitySpawns[ownerPlayerId]
        local currentTime = GetGameTimer()

        if currentTime - playerData.lastSpawnTime < cooldownPeriod then
            CancelEvent()
            Console.Warn(tostring(ownerPlayerId), "Entity spawning too quickly near players", 'this is a beta funciton please update us if its not working corretely')
            return
        end

        local proximitySpawnCount = updateProximitySpawns(ownerPlayerId, currentTime)

        if proximitySpawnCount > maxProximitySpawns then
            CancelEvent()
            Console.Warn(tostring(ownerPlayerId), "Excessive entity spawning near players detected: " .. proximitySpawnCount .. " spawns in " .. timeWindow/1000 .. " seconds", 'this is a beta funciton please update us if its not working corretely')
            return
        end

        playerData.lastSpawnTime = currentTime

        if proximitySpawnCount == maxProximitySpawns - 3 then
            Console.Warn(tostring(ownerPlayerId), "You are approaching the entity spawn limit near players", 'this is a beta funciton please update us if its not working corretely')
        end

        if nearestPlayerId ~= ownerPlayerId then
            Console.Warn(nearestPlayerId, "An entity was spawned near you by another player", 'this is a beta funciton please update us if its not working corretely')
        end
    end
end)

AddEventHandler('playerDropped', function()
    local playerId = source
    playerProximitySpawns[playerId] = nil
end)