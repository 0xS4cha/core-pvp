local createThread <const> = Citizen.CreateThread

createThread(function()
    while RegisterServerCallback == nil do Wait(100) end
    RegisterServerCallback("core:GetWeaponSave", function(source, token)
        if CheckPlayerToken(source, token) then
            if GetPlayer(source) == nil then return end
            return GetPlayer(source):getWeapons()
        else
            TriggerEvent('core:admin:anticheat', 'Execute trigger: core:GetWeaponSave', source)
        end
    end)
end)