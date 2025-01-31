function GiveItemToPlayer(source, item, count, slot)
    local added = AddItemToInventory(source, item, count, slot)
    if added then
        --RefreshPlayerData(source)
        MarkPlayerDataAsNonSaved(source)
    end
    return added
end

function GiveItemToStorage(source, item, count, slot)
    local added = AddItemToStorage(source, item, count, slot)
    if added then
        MarkPlayerDataAsNonSaved(source)
    end
end

exports("GiveItemToPlayer", function(source, item, count)
    return GiveItemToPlayer(source, item, count)
end)

function RemoveItemToStorage(source, item, count, slot)
    local removed = RemoveItemFromStorage(source, item, count, slot)

    if removed then
        MarkPlayerDataAsNonSaved(source)
    end
    return removed
end

function RemoveItemToPlayer(source, item, count, slot)
    -- print(json.encode(item))
    local removed = RemoveItemFromInventory(source, item, count, slot)

    if removed then
        --RefreshPlayerData(source)
        MarkPlayerDataAsNonSaved(source)
    end
    return removed
end

function DoesStorageHaveItemCount(source, item, count, slot)
    if not GetPlayer(source) then
        return false
    end
    for key, value in pairs(GetPlayer(source):getStorage()) do
        if value.name == item and tonumber(value.slot) == tonumber(slot) then
            if tonumber(value.count) >= tonumber(count) then
                return true
            else
                return false
            end
        end
    end
    return false
end

function DoesPlayerHaveItemCount(source, item, count, slot)
    if not GetPlayer(source) then
        return false
    end
    for key, value in pairs(GetPlayer(source):getInventaire()) do
        if value.name == item then
            if not slot then
                if tonumber(value.count) >= tonumber(count) then
                    return true
                else
                    return false
                end
            else
                if tonumber(value.count) >= tonumber(count) and tonumber(value.slot) == slot then
                    return true
                else
                    return false
                end
            end
        end
    end
    return false
end

function GetItemCount(source, item)
    if not GetPlayer(source) then
        return false
    end
    for key, value in pairs(GetPlayer(source):getInventaire()) do
        if value.name == item then
            return value.count
        end
    end
    return 0
end

exports("GetItemCount", function(source, item)
    return GetItemCount(source, item)
end)







RegisterNetEvent('core:RemoveItemToInventory', function(token, item, count, metadata)
    local source = source
    if CheckPlayerToken(source, token) then
        RemoveItemToPlayer(source, item, count, metadata)
        --RefreshPlayerData(source)
        MarkPlayerDataAsNonSaved(source)
    end
end)

RegisterNetEvent("core:UseItem")
AddEventHandler("core:UseItem", function(token, item, slot)
    local source = source
    if CheckPlayerToken(source, token) then
        if item == "money" then
            return
        end

        if IsItemUsable(item) then
            if UseItemIfCan(source, item, slot) then
                local itemName = getItemLabel(item)




                TriggerClientEvent("core:ShowNotification", source, GetPhrase('inventory_use', itemName))

                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            end
        end
    end
end)

RegisterNetEvent("core:GiveItemToPlayer")
AddEventHandler("core:GiveItemToPlayer", function(time, secu, item, metadatas, count, target)
    local src = source
    if CheckTrigger(source, time, secu, "core:GiveItemToPlayer - Item : " .. item .. " " .. count) then
        local itemWeight = GetItemWeightWithCount(item, count)
        if getInventoryWeight(target) + itemWeight <= items.maxWeight then
            local removed = RemoveItemToPlayer(src, item, count, metadatas)
            if removed then
                for k, v in pairs(GetPlayer(src):getInventaire()) do
                    if not DoesPlayerHaveItemCount(target, item, count) then
                        GiveItemToPlayer(target, item, count, metadatas)
                        TriggerClientEvent("core:playeTakeAnim", target)


                        TriggerClientEvent('core:ShowNotification', src,
                            "Vous avez donné ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')
                        TriggerClientEvent('core:ShowNotification', target,
                            "Vous avez reçu ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')


                        --RefreshPlayerData(src)
                        MarkPlayerDataAsNonSaved(src)
                        --RefreshPlayerData(target)
                        MarkPlayerDataAsNonSaved(target)
                        SendDiscordLog("give", src, string.sub(GetDiscord(src), 9, -1),
                            GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), target,
                            string.sub(GetDiscord(target), 9, -1),
                            GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(), item,
                            count)
                        return
                    elseif items[item].type == "weapons" then
                        GiveItemToPlayer(target, item, count, metadatas)
                        TriggerClientEvent("core:playeTakeAnim", target)

                        -- New notification
                        TriggerClientEvent('core:ShowNotification', src,
                            "Vous avez donné ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')
                        TriggerClientEvent('core:ShowNotification', target,
                            "Vous avez reçu ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')

                        --RefreshPlayerData(src)
                        MarkPlayerDataAsNonSaved(src)
                        --RefreshPlayerData(target)
                        MarkPlayerDataAsNonSaved(target)
                        SendDiscordLog("give", src, string.sub(GetDiscord(src), 9, -1),
                            GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), target,
                            string.sub(GetDiscord(target), 9, -1),
                            GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(), item,
                            count)
                        return
                    elseif v.name == "money" and v.name == item then
                        GiveItemToPlayer(target, item, count, v.metadatas)
                        TriggerClientEvent("core:playeTakeAnim", target)

                        -- New notification
                        TriggerClientEvent('core:ShowNotification', src,
                            "Vous avez donné ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')
                        TriggerClientEvent('core:ShowNotification', target,
                            "Vous avez reçu ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')

                        --RefreshPlayerData(src)
                        MarkPlayerDataAsNonSaved(src)
                        --RefreshPlayerData(target)
                        MarkPlayerDataAsNonSaved(target)
                        SendDiscordLog("give", src, string.sub(GetDiscord(src), 9, -1),
                            GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), target,
                            string.sub(GetDiscord(target), 9, -1),
                            GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(), item,
                            count)
                        return
                    elseif v.name == item and v.metadatas ~= nil then
                        GiveItemToPlayer(target, item, count, v.metadatas)
                        TriggerClientEvent("core:playeTakeAnim", target)


                        TriggerClientEvent('core:ShowNotification', src,
                            "Vous avez donné ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')
                        TriggerClientEvent('core:ShowNotification', target,
                            "Vous avez reçu ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')

                        --RefreshPlayerData(src)
                        MarkPlayerDataAsNonSaved(src)
                        --RefreshPlayerData(target)
                        MarkPlayerDataAsNonSaved(target)
                        SendDiscordLog("give", src, string.sub(GetDiscord(src), 9, -1),
                            GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), target,
                            string.sub(GetDiscord(target), 9, -1),
                            GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(), item,
                            count)
                        return
                    elseif v.name == item and v.metadatas == nil then
                        if json.encode(metadatas) == "[]" or metadatas == nil then
                            metadatas = {}
                        end
                        GiveItemToPlayer(target, item, count, metadatas)
                        TriggerClientEvent("core:playeTakeAnim", target)

                        -- New notification
                        TriggerClientEvent('core:ShowNotification', src,
                            "Vous avez donné ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')
                        TriggerClientEvent('core:ShowNotification', target,
                            "Vous avez reçu ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')

                        --RefreshPlayerData(src)
                        MarkPlayerDataAsNonSaved(src)
                        --RefreshPlayerData(target)
                        MarkPlayerDataAsNonSaved(target)
                        SendDiscordLog("give", src, string.sub(GetDiscord(src), 9, -1),
                            GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), target,
                            string.sub(GetDiscord(target), 9, -1),
                            GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(), item,
                            count)
                        return
                    elseif v.name ~= item then
                        if json.encode(metadatas) == "[]" then
                            metadatas = {}
                        end
                        GiveItemToPlayer(target, item, count, metadatas)
                        TriggerClientEvent("core:playeTakeAnim", target)

                        -- New notification
                        TriggerClientEvent('core:ShowNotification', src,
                            "Vous avez donné ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')
                        TriggerClientEvent('core:ShowNotification', target,
                            "Vous avez reçu ~b~<C> x" .. count .. " " .. getItemLabel(item) .. '</C>')

                        --RefreshPlayerData(src)
                        MarkPlayerDataAsNonSaved(src)
                        --RefreshPlayerData(target)
                        MarkPlayerDataAsNonSaved(target)
                        SendDiscordLog("give", src, string.sub(GetDiscord(src), 9, -1),
                            GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), target,
                            string.sub(GetDiscord(target), 9, -1),
                            GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(), item,
                            count)
                        return
                    end
                end
            end
        end
    end
end)

-- Callbacks

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end

    RegisterServerCallback("inventory:GetOtherPlayerInventory", function(source, target)
        local player = GetPlayer(target)
        return player:getInventaire()
    end)

    RegisterServerCallback("inventory:swapItem", function(source, data)
        local player = GetPlayer(source)
        local inventory = player:getInventaire()
        local resp = false
        if data.slot and data.item.slot then
            Items = {}
            for k, v in pairs(inventory) do
                if v.slot == data.slot then
                    v.slot = data.item.slot
                    goto continue
                end

                if v.slot == data.item.slot then
                    v.slot = data.slot
                end

                ::continue::
                if v.type == 'items' or v.type == 'weapons' then
                    table.insert(Items, {
                        name = v.name,
                        count = v.count,
                        label = v.label,
                        slot = tonumber(v.slot) or k,
                        type = v.type,

                    })
                end
            end
            player:setInventaire(Items)
            MarkPlayerDataAsNonSaved(source)
            resp = true
        end
        return resp, player:getInventaire()
    end)

    RegisterServerCallback('inventory:dropStorage', function(source, token, data)
        local resp = false
        if CheckPlayerToken(source, token) then
            local p = GetPlayer(source)
            if p then
                if DoesPlayerHaveItemCount(source, data.item.name, data.quantity, data.item.slot) then
                    local remove = RemoveItemToPlayer(source, data.item.name, tonumber(data.quantity),
                        tonumber(data.item.slot))
                    if remove then
                        GiveItemToStorage(source, data.item.name, data.quantity, data.slot)
                    end
                end
            end
        end
        return resp
    end)
    RegisterServerCallback('inventory:lootStorage', function(source, token, data)
        if CheckPlayerToken(source, token) then
            local p = GetPlayer(source)
            if p then
                if tonumber(data.quantity) > tonumber(data.item.count) then
                    _ANTICHEAT.punish_player(source,
                        "Trigger Event with an excutor : inventory:lootItem (Quantity > count)", 'events_anticheat',
                        'Ban')
                    return
                end
                if DoesStorageHaveItemCount(source, data.item.name, data.quantity, data.item.slot) then
                    local remove = RemoveItemToStorage(source, data.item.name, tonumber(data.quantity),
                        tonumber(data.item.slot))
                    if remove then
                        GiveItemToPlayer(source, data.item.name, data.quantity, data.slot)
                    end
                end
            end
        end
    end)
    RegisterServerCallback('inventory:tradeItem', function(source, token, data, target)
        local resp = false
        if CheckPlayerToken(source, token) then
            local p = GetPlayer(source)
            local t = GetPlayer(target)
            if p and t then
                if tonumber(data.quantity) > tonumber(data.item.count) then
                    _ANTICHEAT.punish_player(source,
                        "Trigger Event with an excutor : inventory:lootItem (Quantity > count)", 'events_anticheat',
                        'Ban')
                    return
                end
                if DoesPlayerHaveItemCount(source, data.item.name, data.quantity, data.item.slot) then
                    local remove = RemoveItemToPlayer(source, data.item.name, tonumber(data.quantity),
                        tonumber(data.item.slot))
                    if remove then
                        GiveItemToPlayer(target, data.item.name, data.quantity, data.slot)
                    end
                end
            end
        end
        return resp
    end)

    RegisterServerCallback('core:shop:valid', function(source, token, data, price)
        local resp = false
        if CheckPlayerToken(source, token) then
            local p = GetPlayer(source)
            if p then
                local TotalPrice = 0
                for k, v in pairs(data) do
                    for k2, v2 in pairs(_SHOP.Items[v.type].list) do
                        if v2.item == v.item then
                            TotalPrice += (v2.price * v.quantity)
                            break
                        end
                    end
                end
                if TotalPrice ~= price then
                    _ANTICHEAT.punish_player(source, "Trigger Event with an excutor : core:shop:valid",
                        'events_anticheat', 'Ban')
                    return
                end
                if DoesPlayerHaveItemCount(source, 'money', TotalPrice) then
                    local remove = RemoveItemToPlayer(source, 'money', TotalPrice)
                    if remove then
                        for k, v in pairs(data) do
                            GiveItemToPlayer(source, v.item, v.quantity)
                            resp = true
                        end
                    end
                end
            end
        end
        return resp
    end)

    RegisterServerCallback("inventory:lootItem", function(source, token, data, target)
        local resp = false
        if CheckPlayerToken(source, token) then
            local p = GetPlayer(source)
            local t = GetPlayer(target)

            if tonumber(data.quantity) == 0 then
                data.quantity = tonumber(data.item.count)
            end
            if p and t then
                if data.item.name == 'money' and tonumber(data.quantity) > _CONFIG.MAXMONEYLOOT then
                    _ANTICHEAT.punish_player(source,
                        "Trigger Event with an excutor : inventory:lootItem (money > maxloot)", 'events_anticheat', 'Ban')
                    return
                end
                if tonumber(data.quantity) > tonumber(data.item.count) then
                    _ANTICHEAT.punish_player(source,
                        "Trigger Event with an excutor : inventory:lootItem (Quantity > count)", 'events_anticheat',
                        'Ban')
                    return
                end
                if DoesPlayerHaveItemCount(target, data.item.name, data.quantity, data.item.slot) then
                    local remove = RemoveItemToPlayer(target, data.item.name, tonumber(data.quantity),
                        tonumber(data.item.slot))
                    if remove then
                        TriggerClientEvent('core:inventory:refreshInv2', source, GetPlayer(target):getInventaire())
                        GiveItemToPlayer(source, data.item.name, data.quantity, data.slot)
                    end
                end
            end
        end
        return resp
    end)



    RegisterServerCallback("core:GetInventory", function(source, token)
        if CheckPlayerToken(source, token) then
            return GetPlayer(source):getInventaire()
        end
    end)
    RegisterServerCallback("core:RefreshInventory", function(source, token, inv)
        if CheckPlayerToken(source, token) then
            if inv ~= nil then
                GetPlayer(source):setInventaire(inv)
                return true
            end
        end
        return false
    end)

    RegisterNetEvent("core:RefreshInventory", function(time, secu, token, inv)
        local src = source
        --if CheckPlayerToken(src, token) then
        if CheckTrigger(src, time, secu, "core:RefreshInventory") then
            if inv ~= nil then
                GetPlayer(src):setInventaire(inv)
            end
        end
        --end
    end)



    RegisterServerCallback("core:pay", function(source, token, amount)
        if CheckPlayerToken(source, token) then
            local removed = false
            for key, value in pairs(GetPlayer(source):getInventaire()) do
                if value.name == "money" then
                    removed = RemoveItemFromInventory(source, 'money', tonumber(amount), value.metadatas)
                end
            end
            if removed then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            else
                local account = Bank.GetAllPlayerAccount(source)
                for k, v in pairs(account) do
                    if (v.balance - amount) > 0 then
                        local balance = v.balance
                        local result = balance - amount
                        TriggerClientEvent("core:updateBankPhoneValue", source, result)
                        Bank.setMoneyAccount(v.account_number, result)
                        removed = true
                    else
                        removed = false
                    end
                end
            end
            return removed
        end
    end)

    RegisterServerCallback("core:payLiquide", function(source, token, amount)
        if CheckPlayerToken(source, token) then
            local removed = false
            for key, value in pairs(GetPlayer(source):getInventaire()) do
                if value.name == "money" then
                    removed = RemoveItemFromInventory(source, 'money', tonumber(amount), value.metadatas)
                end
            end
            if removed then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            end
            return removed
        end
    end)
end)


-- RegisterCommand("Secret", function(source)
--     DropPlayer(source, "Coucou j'espère tu vas bien je te fais plein de bisous")
-- end)
