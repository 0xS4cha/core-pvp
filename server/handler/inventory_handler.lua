function GiveItemToPlayer(source, item, count, metadata)
    local added = AddItemToInventory(source, item, count, metadata)
    if added then
        --RefreshPlayerData(source)
        MarkPlayerDataAsNonSaved(source)
    else
        -- TriggerClientEvent("core:ShowNotification", source, "~r~Vous n'avez pas assez de place dans votre inventaire")

        TriggerClientEvent("__vision::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous n'avez plus de place. ~s" -- Phrase trop longue donc modif 2e idée "Inventaire plein"
        })
    end
    return added
end

exports("GiveItemToPlayer", function(source, item, count, metadata)
    return GiveItemToPlayer(source, item, count, metadata)
end)

function GiveItemToPlayerStaff(source, item, count, metadata)
    local added = AddItemToInventoryStaff(source, item, count, metadata)
    if added then
        --RefreshPlayerData(source)
        MarkPlayerDataAsNonSaved(source)
    else
        --TriggerClientEvent("core:ShowNotification", source, "~r~Vous n'avez pas assez de place dans votre inventaire")
        
        TriggerClientEvent("__vision::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Cet item n'existe pas ou vous n'avez plus de place dans votre inventaire. ~s"
        })

    end
    return added
end

function RemoveItemToPlayer(source, item, count, metadata)
    -- print(json.encode(item))
    local removed = false
    if item == "identitycard" then
        removed = RemoveIdentityCardFromInventory(source, item, count, metadata)
    elseif item == "bike" then
        removed = RemoveBikeFromInventory(source, item, count, metadata)
    elseif item == "outfit" then
        removed = RemoveClothFromInventory(source, item, count, metadata)
    elseif items[item].type == "weapons" then
        removed = RemoveWeaponFromInventory(source, item, count, metadata)
        TriggerClientEvent("core:RemoveWeapon", source, item)
    else
        removed = RemoveItemFromInventory(source, item, count, metadata)
    end
    if removed then
        --RefreshPlayerData(source)
        MarkPlayerDataAsNonSaved(source)
    end
    return removed
end

function DoesPlayerHaveItemCount(source, item, count)
    if not GetPlayer(source) then 
        return false
    end
    for key, value in pairs(GetPlayer(source):getInventaire()) do
        if value.name == item then
            if value.count >= count then
                return true
            else
                return false
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