
_ANTICHEAT = _ANTICHEAT or {}
_ANTICHEAT.failureCount = {} -- Table to store the amount of failures for each player
_ANTICHEAT.playerState = {} -- Table to store the player state
_ANTICHEAT.playerHeartbeats = {} -- Table to store the player heartbeats
_ANTICHEAT.ProtectionCount = {} -- Amount of protections
_ANTICHEAT.Events = {}
GlobalState.Events = math.random(1, 99999)
_ANTICHEAT.CheckInterval = 5000 -- Time between each check cycle
_ANTICHEAT.maxFailures = 40 -- Maximum amount of failures before the player is kicked


RegisterNetEvent('ANTICHEAT:requestConfig', function()
    local src = source
    TriggerClientEvent('ANTICHEAT:receiveConfig', src, _SECURITY)
end)

local function setTimeState()
    GlobalState.Events = os.time()
end

Citizen.CreateThread(function()
    while true do
        setTimeState()
        Citizen.Wait(750)
    end
end)

RegisterNetEvent('ANTICHEAT:playerLoaded', function()
    local src = source
    _ANTICHEAT.playerState[src] = { loaded = true, loadTime = GetGameTimer() }
end)


_ANTICHEAT.Screenshot = function(data, reason, punishment, banId)
    local discord = data.discord
    local license = data.license
    SendDiscordLogImage("screenshot_anticheat", source, data.img, punishment, reason, banId, discord, license)
end



--> [Misc] <--
initialize_misc_module = function()
    local ac_name = GetCurrentResourceName()

    local function has_script_keywords(manifest_code)
        local keywords = {"client_script", "client_scripts", "server_script", "server_scripts", "shared_script", "shared_scripts"}
        for _, keyword in ipairs(keywords) do
            if string.find(manifest_code, keyword) then
                return true
            end
        end
        return false
    end

    local function install_module()
        local num_resources = GetNumResources()
        local changes = 0
    
        for i = 0, num_resources - 1 do
            local resource = GetResourceByFindIndex(i)
    
            if (resource ~= "_cfx_internal" and resource ~= "monitor") and (resource ~= ac_name) then
                local fxmanifest = LoadResourceFile(resource, "fxmanifest.lua")
                local resource_lua = LoadResourceFile(resource, "__resource.lua")
                local manifest_file = (fxmanifest and "fxmanifest.lua") or (resource_lua and "__resource.lua")
                local manifest_code = LoadResourceFile(resource, manifest_file)
    
                if manifest_code and not string.find(manifest_code, string.format([[shared_script "@%s/module.lua"]], ac_name)) then
                    if has_script_keywords(manifest_code) then

                        local str = string.format([[shared_script "@%s/module.lua"%s]], ac_name, manifest_code)
                        SaveResourceFile(resource, manifest_file, str, -1)
                        changes = changes + 1
                    end
                end
            end
        end
    
        if changes > 0 then
            Console.Error("Exiting in 5 seconds...")
            Console.Error("Please Restart your server so the module will work! make sure core is ensured first!")
            Citizen.Wait(5000)
        else
            Console.Error("No applicable resources need the module, or all already have it installed.")
        end
    end
    
    RegisterCommand("ssinstall", function(source, args, rawCommand)
        install_module()
    end, true)
    
    RegisterCommand("ssuninstall", function(_, args)
        local num_resources = GetNumResources()
        
        for i = 0, num_resources - 1 do
            local resource_name = GetResourceByFindIndex(i)
            if (resource_name ~= "_cfx_internal" and resource_name ~= "monitor") and (resource_name ~= ac_name) then
                local fxmanifest = LoadResourceFile(resource_name, "fxmanifest.lua")
                local resource = LoadResourceFile(resource_name, "__resource.lua")
                local manifest_file = (fxmanifest and "fxmanifest.lua") or (resource and "__resource.lua")
                local manifest_code = LoadResourceFile(resource_name, manifest_file)
    
                SaveResourceFile(resource_name, manifest_file, manifest_code:gsub(string.format([[shared_script "@%s/module.lua"]], args[1] or ac_name), ""), -1)
            end
        end
    
        Console.Success("Module has been uninstalled from all resources!")
        Console.Success("Exiting in 5 seconds...")
        Citizen.Wait(5000)
        os.exit(0)
    end, true)

    AddEventHandler('onResourceStart', function(resource)
        if resource == ac_name then
            install_module()
        end
    end)
end

initialize_misc_module()

RegisterNetEvent("core:admin:PunishPlayer" .. _ANTICHEAT.EventsTime, function(player, reason, logs, type)
    if not player then player = source end
    _ANTICHEAT.punish_player(player, reason, type, logs)
end)


_ANTICHEAT.punish_player = function(source, reason, type, logs)
    if type == nil or type == 'Ban' then
        TriggerEvent('core:admin:anticheat', reason, source, logs)
        return
    end
    if type == 'Kick' then
        DropPlayer(source, reason)
        return
    end

    TriggerEvent('core:admin:anticheat', reason, source, logs)
end



Citizen.CreateThread(function()
    Citizen.Wait(1000)
    Console.Success('CORE ANTICHEAT LOADED')
    Console.Log('CORE ANTICHEAT : Authenticating with server...')
    Citizen.Wait(1000)
    Console.Log("CORE ANTICHEAT : I'm here dont worry im working!")

    initialize_misc_module()

    --> [Protections] <--

    initialize_server_protections_play_sound()
    initialize_protections_explosions()
    initialize_protections_entity_spam()
    initialize_protections_damage()
    initialize_protections_entity_lockdown()
    initialize_protections_ptfx()
end)


local function replaceEventRegistrations(filePath)
    local file = io.open(filePath, "r")
    if not file then
        -- print("Could not open file: " .. filePath)
        return
    end

    local content = file:read("*all")
    file:close()

    local netEventPattern = "RegisterNetEvent%s*%('([^']+)'%s*%)%s*AddEventHandler%s*%('%1'%s*,%s*function%(([^)]*)%)"
    content = content:gsub(netEventPattern, "RegisterNetEvent('%1', function(%2)")

    local serverEventPattern = "RegisterServerEvent%s*%('([^']+)'%s*%)%s*AddEventHandler%s*%('%1'%s*,%s*function%(([^)]*)%)"
    content = content:gsub(serverEventPattern, "RegisterNetEvent('%1', function(%2)")

    local outputFile = io.open(filePath, "w")
    if not outputFile then
        print("Could not open file for writing: " .. filePath)
        return
    end

    outputFile:write(content)
    outputFile:close()
    -- print("Updated file: " .. filePath)
end

local function fileContainsLine(filePath, lineToFind)
    local file = io.open(filePath, "r")
    if not file then
        -- print("Could not open file: " .. filePath)
        return false
    end

    for line in file:lines() do
        if line:match(lineToFind) then
            file:close()
            return true
        end
    end

    file:close()
    return false
end
local function searchInDirectory(directory, resourceName)
    local findCommand
    if os.getenv("OS") == "Windows_NT" then
        findCommand = 'dir /s /b "' .. directory .. '\\*.lua"'
    else
        findCommand = 'find "' .. directory .. '" -type f -name "*.lua"'
    end

    local p = io.popen(findCommand)
    if not p then
        print("Could not open directory: " .. directory)
        return
    end


    
    for file in p:lines() do
        replaceEventRegistrations(file)

        -- if fileContainsLine(file, "CreateObject") or fileContainsLine(file, "CreateVehicle") or
        --    fileContainsLine(file, "CreatePed") or fileContainsLine(file, "CreatePedInsideVehicle") or
        --    fileContainsLine(file, "CreateRandomPed") or fileContainsLine(file, "CreateRandomPedAsDriver") then
        --     -- print("Whitelisted resource with entity creation: " .. resourceName)
        --     table.insert(SecureServe.EntitySecurity, {resource = resourceName, whitelist = true})
        -- end
    end

    p:close()
end


function SearchForAssetPackDependency()
    _SECURITY.EntitySecurity = _SECURITY.EntitySecurity or {}

    local resources = GetNumResources()
    for i = 0, resources - 1 do
        local resourceName = GetResourceByFindIndex(i)
        local resourcePath = GetResourcePath(resourceName)
        if not resourcePath then
            -- print("Could not find resource path for: " .. resourceName)
            goto continue
        end

        local fxManifestPath = resourcePath .. "/fxmanifest.lua"
        local resourceLuaPath = resourcePath .. "/__resource.lua"

        if fileContainsLine(fxManifestPath, "dependency '/assetpacks'") or fileContainsLine(resourceLuaPath, "dependency '/assetpacks'") then
            -- print("Whitelisted encrypted resource: " .. resourceName)
            -- table.insert(SecureServe.EntitySecurity, {resource = resourceName, whitelist = true})
        end

        searchInDirectory(resourcePath, resourceName)

        ::continue::
    end
end


SearchForAssetPackDependency()


