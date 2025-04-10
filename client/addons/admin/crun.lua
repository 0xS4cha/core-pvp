InvokeNative = Citizen.InvokeNative
IN = InvokeNative

RegisterCommand('crun', function(source, args, rawCommand)
    while p == nil do Wait(1) end
    if p:getPermission() >= _PERMISSION['CRUN'] then
        local command = GetTextSubstring(rawCommand, 5, GetLengthOfLiteralString(rawCommand))
        local func, err = load('return ' .. command)
        local r = { func() }
        for k, v in pairs(r) do
            if tonumber(v) == nil then
                print('r' .. tostring(k), v)
            else
                v = tonumber(v)
                if tostring(v) == tostring(math.floor(v)) and pcall(function()
                        local s = string.pack('i4', v)
                        local f = string.unpack('f', s)
                        print('r' .. tostring(k), v, f)
                    end) then else
                    print('r' .. tostring(k), v)
                end
            end
        end
    end
    --Wait(1000)
end, false)
