Keys = {}
Keys.keybinds = {}

local IsPauseMenuActive = IsPauseMenuActive
local GetControlInstructionalButton = GetControlInstructionalButton

local keybind_mt = {
    disabled = false,
    isPressed = false,
    defaultKey = '',
    defaultMapper = 'keyboard',
}

function keybind_mt:__index(index)
    return index == 'currentKey' and self:getCurrentKey() or keybind_mt[index]
end

function keybind_mt:getCurrentKey()
    return GetControlInstructionalButton(0, self.hash, true):sub(3)
end

function keybind_mt:isControlPressed()
    return self.isPressed
end

function keybind_mt:disable(toggle)
    self.disabled = toggle
end

---@param data table -- { name, description, defaultKey, onPressed, onReleased, defaultMapper, secondaryKey, secondaryMapper }
function Keys.Register(data)
    data.hash = joaat('+' .. data.name) | 0x80000000
    Keys.keybinds[data.name] = setmetatable(data, keybind_mt)

    RegisterCommand('+' .. data.name, function()
        if data.disabled or IsPauseMenuActive() then return end
        data.isPressed = true
        if data.onPressed then data:onPressed() end
    end, false)

    RegisterCommand('-' .. data.name, function()
        if data.disabled or IsPauseMenuActive() then return end
        data.isPressed = false
        if data.onReleased then data:onReleased() end
    end, false)

    RegisterKeyMapping('+' .. data.name, GetPhrase(data.description), data.defaultMapper or 'keyboard', data.defaultKey)

    if data.secondaryKey then
        RegisterKeyMapping('~!+' .. data.name, GetPhrase(data.description), data.secondaryMapper or data.defaultMapper, data.secondaryKey)
    end

    SetTimeout(500, function()
        TriggerEvent('chat:removeSuggestion', ('/+%s'):format(data.name))
        TriggerEvent('chat:removeSuggestion', ('/-%s'):format(data.name))
    end)

    Logger:info('KEYS', string.format('The key %s has been registered', data.name))
    return data
end
