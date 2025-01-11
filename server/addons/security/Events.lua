
--> [EVENTS] <--
local encryption_key = "c4a2ec5dc103a3f730460948f2e3c01df39ea4212bc2c82f"

local xor_encrypt = LPH_NO_VIRTUALIZE(function(text, key)
    local res = {}
    local key_len = #key
    for i = 1, #text do
        local xor_byte = string.byte(text, i) ~ string.byte(key, (i - 1) % key_len + 1)
        res[i] = string.char(xor_byte)
    end
    return table.concat(res)
end)

local encryptEventName = LPH_NO_VIRTUALIZE(function(event_name, key)
    local encrypted = xor_encrypt(event_name, key)
    local result = ""
    for i = 1, #encrypted do
        result = result .. string.format("%03d", string.byte(encrypted, i))
    end
    return result
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


exports('IsEventWhitelisted', LPH_NO_VIRTUALIZE(function(event_name)
    return _ANTICHEAT.isWhitelisted(event_name)
end))