
for k,v in pairs(_SECURITY.AntiInternal) do
    if v.webhook == "" then
        _SECURITY.AntiInternal[k].webhook = _SECURITY.Webhooks.AntiInternal
    end
    if type(v.time) ~= "number" then
        _SECURITY.AntiInternal[k].time = _SECURITY.BanTimes[v.time]
    end
    
    name = _SECURITY.AntiInternal[k].detection
    dispatch = _SECURITY.AntiInternal[k].dispatch
    default = _SECURITY.AntiInternal[k].default
    defaultr = _SECURITY.AntiInternal[k].defaultr
    defaults = _SECURITY.AntiInternal[k].defaults
    punish = _SECURITY.AntiInternal[k].punishType
    time = _SECURITY.AntiInternal[k].time
    if type(time) ~= "number" then
        time = _SECURITY.BanTimes[v.time]
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
        _SECURITY.Protection.Simple[k].time = _SECURITY.BanTimes[v.time]
    end
    
    name = _SECURITY.Protection.Simple[k].protection
    dispatch = _SECURITY.Protection.Simple[k].dispatch
    default = _SECURITY.Protection.Simple[k].default
    defaultr = _SECURITY.Protection.Simple[k].defaultr
    defaults = _SECURITY.Protection.Simple[k].defaults
    time = _SECURITY.Protection.Simple[k].time
    if type(time) ~= "number" then
        time = _SECURITY.BanTimes[v.time]
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
        _SECURITY.Protection.BlacklistedCommands[k].time = _SECURITY.BanTimes[v.time]
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedCommands"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedCommands"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedCommands"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedCommands"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedSprites) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedSprites[k].webhook = _SECURITY.Webhooks.BlacklistedSprites
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedSprites[k].time = _SECURITY.BanTimes[v.time]
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedSprites"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedSprites"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedSprites"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedSprites"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedAnimDicts) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedAnimDicts[k].webhook = _SECURITY.Webhooks.BlacklistedAnimDicts
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedAnimDicts[k].time = _SECURITY.BanTimes[v.time]
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedAnimDicts"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedAnimDicts"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedAnimDicts"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedAnimDicts"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedExplosions) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedExplosions[k].webhook = _SECURITY.Webhooks.BlacklistedExplosions
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedExplosions[k].time = _SECURITY.BanTimes[v.time]
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedExplosions"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedExplosions"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedExplosions"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedExplosions"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedWeapons) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedWeapons[k].webhook = _SECURITY.Webhooks.BlacklistedWeapons
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedWeapons[k].time = _SECURITY.BanTimes[v.time]
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedWeapons"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedWeapons"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedWeapons"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedWeapons"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedVehicles) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedVehicles[k].webhook = _SECURITY.Webhooks.BlacklistedVehicles
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedVehicles[k].time = _SECURITY.BanTimes[v.time]
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedVehicles"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedVehicles"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedVehicles"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedVehicles"] + 1
end

for k,v in pairs(_SECURITY.Protection.BlacklistedObjects) do
    if v.webhook == "" then
        _SECURITY.Protection.BlacklistedObjects[k].webhook = _SECURITY.Webhooks.BlacklistedObjects
    end
    if type(v.time) ~= "number" then
        _SECURITY.Protection.BlacklistedObjects[k].time = _SECURITY.BanTimes[v.time]
    end
            
    if not _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedObjects"] then _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedObjects"] = 0 end
    _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedObjects"] = _ANTICHEAT.ProtectionCount["Core.Protection.BlacklistedObjects"] + 1
end