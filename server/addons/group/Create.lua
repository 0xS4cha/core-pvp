RegisterNetEvent("core:CreateCrew")
AddEventHandler("core:CreateCrew", function(token, data)
    local src = source
    local player = GetPlayer(src)
    if CheckPlayerToken(source, token) then
        if data ~= nil then
            if data.color then
                local create = Group.CreateGroup(src, data.name, data.color, data.description, data.rank)
                if create then
                    player:setGroupID(create)
                    player:setGroup(data.name)
                    TriggerClientEvent('core:setGroupPlayer', src, data.name, create)
                    TriggerClientEvent("core:ShowNotification", src, "Vous venez de crée le groupe ~b~<C>" .. data.name .. "</C>~s~.")
                else
                    TriggerClientEvent("core:ShowNotification", src, "~r~Une erreur est survenue lors de la création de votre groupe.")
                end
            end
        end
    end
end)