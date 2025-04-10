Logger = {}
Logger.Enabled = true

local function parseArguments(...)
    local arguments = {...}
    local parsedArguments = {}

    for _,v in pairs(arguments) do
        if type(v) == "table" then
            parsedArguments[#parsedArguments + 1] = TableToString(v)
        else
            parsedArguments[#parsedArguments + 1] = tostring(v)
        end
    end

    return parsedArguments
end

function Logger:error(module, ...)
    if not self.Enabled then return end

    print("^1[ERROR] ^6[" .. string.upper(module) .. "] > ^5" .. table.concat(parseArguments(...), " ") .. "^0")
end

function Logger:info(module, ...)
    if not self.Enabled then return end

    print("^2[INFO] ^6[" .. string.upper(module) .. "] > ^5" .. table.concat(parseArguments(...), " ") .. "^0")
end

function Logger:warn(module, ...)
    if not self.Enabled then return end

    print("^3[WARN] ^6[" .. string.upper(module) .. "] > ^5" .. table.concat(parseArguments(...), " ") .. "^0")
end


function Logger:debug(module, data)
    local function cpy(t)
        local seen = {}
        local function _cpy(t)
            if type(t) ~= "table" then
                return tostring(t)
            elseif seen[t] then
                return seen[t]
            end
            local s = {}
            seen[t] = s
            for k, v in pairs(t) do
                s[_cpy(k)] = _cpy(v)
            end
            return setmetatable(s, getmetatable(t))
        end
        return _cpy(t)
    end
    print("^8[TRACE] ^6[" .. string.upper(module) .. "] > ^5" .. json.encode(cpy(data), { indent = true }) .. "^0")
end

