
--> [EVENTS] <--
local encryption_key = "c4a2ec5dc103a3f730460948f2e3c01df39ea4212bc2c82f"

local xor_encrypt = _ANTICHEAT.MODULE.LPH_NO_VIRTUALIZE(function(text, key)
    local res = {}
    local key_len = #key
    for i = 1, #text do
        local xor_byte = string.byte(text, i) ~ string.byte(key, (i - 1) % key_len + 1)
        res[i] = string.char(xor_byte)
    end
    return table.concat(res)
end)

local encryptEventName = _ANTICHEAT.MODULE.LPH_NO_VIRTUALIZE(function(event_name, key)
    local encrypted = xor_encrypt(event_name, key)
    local result = ""
    for i = 1, #encrypted do
        result = result .. string.format("%03d", string.byte(encrypted, i))
    end
    return result
end)

local xor_decrypt = _ANTICHEAT.MODULE.LPH_NO_VIRTUALIZE(function(encrypted_text, key)
    local res = {}
    local key_len = #key
    for i = 1, #encrypted_text do
        local xor_byte = string.byte(encrypted_text, i) ~ string.byte(key, (i - 1) % key_len + 1)
        res[i] = string.char(xor_byte)
    end
    return table.concat(res)
end)

local decryptEventName = _ANTICHEAT.MODULE.LPH_NO_VIRTUALIZE(function(encrypted_name, key)
    local encrypted = {}
    for i = 1, #encrypted_name, 3 do
        local byte_str = encrypted_name:sub(i, i + 2)
        local byte = tonumber(byte_str)
   
        if byte and byte >= 0 and byte <= 255 then
            table.insert(encrypted, string.char(byte))
        else
            return nil
        end
    end
    return xor_decrypt(table.concat(encrypted), key)
end)




RegisterNetEvent("ANTICHEAT:TriggerdServerEventCheck", function(event, time)
    _ANTICHEAT.Events[event] = time
end)

function _ANTICHEAT.isWhitelisted(event_name)
    if not _SECURITY or not _SECURITY.EventWhitelist or type(_SECURITY.EventWhitelist) ~= "table" then
        Console.Error("Error: EventWhitelist is missing or not a table.")
        return false
    end

    if not event_name or type(event_name) ~= "string" then
        Console.Error("Error: Invalid event_name. Expected a non-empty string.", event_name)
        return false
    end

    for _, whitelisted_event in ipairs(_SECURITY.EventWhitelist) do
        if type(whitelisted_event) == "string" then
            if event_name == whitelisted_event or event_name == encryptEventName(whitelisted_event, encryption_key) then
                return true
            end
        else
            Console.Warn("Warning: Non-string value found in EventWhitelist. Skipping.")

        end
    end

    return false
end

exports('CheckTime', function(event ,time, source)
    Wait(1000)
    if event == nil then
        TriggerEvent('core:admin:anticheat', 'Trigger Event with an excutor '.. event, source, 'events_anticheat')
    end

    local playerState = _ANTICHEAT.playerState[source]
    if playerState and playerState.loaded then
        if _ANTICHEAT.Events[event] == nil and _ANTICHEAT.isWhitelisted(event) == false then
            Wait(500)
            if _ANTICHEAT.Events[event] == nil then
                Wait(500)
                if _ANTICHEAT.Events[event] == nil and _ANTICHEAT.Events[encryptEventName(event, encryption_key)] == nil then
                    TriggerEvent('core:admin:anticheat', 'Trigger Event with an excutor '.. event, source, 'events_anticheat')
                end
            end
        else
            local eventTime = _ANTICHEAT.Events[event]
            local currentTime = time
            if not (math.abs(currentTime - eventTime) < 10) then
                if source and GetPlayerPing(source) > 0 then
                    TriggerEvent('core:admin:anticheat', 'Exceeded time stamp at trigger: '.. event .. " time: ".. currentTime - eventTime, source, 'events_anticheat')
                end
            end
        end
    end
end)


exports('IsEventWhitelisted', _ANTICHEAT.MODULE.LPH_NO_VIRTUALIZE(function(event_name)
    return _ANTICHEAT.isWhitelisted(event_name)
end))