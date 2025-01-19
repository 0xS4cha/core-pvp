Keys = {};

---Register
---@param Controls string
---@param ControlName string
---@param Description string
---@param Action function
---@return Keys
---@public

Keys = {
    keysAllow = true 
}

function Keys.Register(Controls, ControlName, Description, Action)
    local _Keys = {
        CONTROLS = Controls
    }
    RegisterKeyMapping(string.format('core-sacha-%s', ControlName), Description, "keyboard", Controls)
    RegisterCommand(string.format('core-sacha-%s', ControlName), function(source, args)
        if (Action ~= nil) then
            if Keys.keysAllow then 
               Action();

            end 
        end
    end, false)
    Console.Success(string.format('The key %s has been registered', ControlName))
    return setmetatable(_Keys, Keys)
end