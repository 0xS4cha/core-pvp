local function DoesItemexist(item)
    if items[item] ~= nil then
        return true
    else
        return false
    end
end

local function ItemExistInInventory(source, item)
    if GetPlayer(source):getInventaire()[item] ~= nil then
        return true
    else
        return false
    end
end

function getItemWeight(item)
    return items[item].weight
end

function getItemCols(item)
    return items[item].cols
end

function getItemRows(item)
    return items[item].rows
end

function getItemLabel(item)
    return items[item].label
end

function getItemType(item)
    return items[item].type
end

function getNumberOfKey(table)
    local count = 0
    for k, v in pairs(table) do
        count = count + 1
    end
    return count
end

function getWeaponInventorymetadatas(source, item, metadatas)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if v.name == item then
            return v
        end
    end
end

function getItemInventorymetadatas(source, item, slot)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if v.name == item then
            if slot then
                if v.slot == slot then
                    return v
                end
            else
                return v
            end
        end
    end
end

function getItemStoragemetadatas(source, item, slot)
    for k, v in pairs(GetPlayer(source):getStorage()) do
        if v.name == item then
            if slot then
                if v.slot == slot then
                    return v
                end
            else
                return v
            end
        end
    end
end

local function AreDataTheSameForOutfit(item, data1, data2)
    if item == "outfit" then
        if type(data1) == "table" and type(data2) == "table" then
            if data1.torso_1 == data2.torso_1 and data1.tshirt_1 == data2.tshirt_1 and data1.pants_1 == data2.pants_1 and data1.pants_2 == data2.pants_2 then
                return true
            end
        else
            return true
        end
    else
        return true
    end
    return false
end



function getInventoryWeight(source)
    local weight = 0
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        local itemWeight = getItemWeight(v.name)
        weight = weight + (itemWeight * v.count)
    end
    return weight
end

function getPropertyInventory(property, etage)
    local weight = 0
    for _, v in pairs(propertyList) do
        if v.id == property.id then
            for _, j in pairs(v.etage) do
                if j.id == etage.id then
                    if j.inventory then
                        for k, l in pairs(j.inventory.item) do
                            local itemWeight = getItemWeight(l.name)
                            weight = weight + (itemWeight * l.count)
                        end
                    end
                end
            end
        end
    end
    return weight
end

function getPropertyMailBox(property)
    local weight = 0
    etage = { etage = 1 }
    for _, v in pairs(propertyList) do
        if v.id == property.id then
            for _, j in pairs(v.etage) do
                if j.id == etage.id then
                    if j.mailbox then
                        if j.mailbox.item ~= nil then
                            for k, l in pairs(j.mailbox.item) do
                                local itemWeight = getItemWeight(l.name)
                                weight = weight + (itemWeight * l.count)
                            end
                        end
                    end
                end
            end
        end
    end
    return weight
end

function getInventoryWeightSociety(name)
    local weight = 0
    for k, v in pairs(society[name].inventory.item) do
        local itemWeight = getItemWeight(v.name)
        weight = weight + (itemWeight * v.count)
    end
    return weight
end

function getInventoryWeightCasier(name, id)
    local weight = 0
    for k, v in pairs(casier[name][id].inv) do
        local itemWeight = getItemWeight(v.name)
        weight = weight + (itemWeight * v.count)
    end
    return weight
end

function getInventoryWeightVehicle(plate) -- done
    local weight = 0
    local veh = GetVehicle(plate)
    for k, v in pairs(veh:getInventory().item) do
        local itemWeight = getItemWeight(v.name)
        weight = weight + (itemWeight * v.count)
    end
    return weight
end

function GetItemWeightWithCount(item, count)
    return items[item].weight * count
end

function AddItemToStorage(source, item, count, slot)
    local source = tonumber(source)
    local count = tonumber(count)
    local slot = tonumber(slot)
    local inv = GetPlayer(source):getStorage()
    if DoesItemexist(item) then
        local itemInventory = getItemStoragemetadatas(source, item)
        if itemInventory ~= nil then
            if items[item].notStackable then
                local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item), slot =
                slot }
                table.insert(inv, itemData)
                triggerEventPlayer("core:addItemStorage", source, itemData)
            else
                itemInventory.count = (itemInventory.count + count)
                triggerEventPlayer("core:addExistItemStorage", source, item, count)
            end
            return true
        elseif itemInventory == nil then
            local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item), slot =
            slot }

            table.insert(inv, itemData)
            triggerEventPlayer("core:addItemStorage", source, itemData)
            return true
        end

        return true
    end
end


function AddItemToInventory(source, item, count, slot)
    local source = tonumber(source)
    local count = tonumber(count)
    local slot = tonumber(slot)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatas(source, item)
        if itemInventory ~= nil then
            if items[item].notStackable then
                local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item), slot = slot }
                table.insert(inv, itemData)
                triggerEventPlayer("core:addItemPlayer", source, itemData)
                GetPlayer(source):setInventaire(inv)
                triggerEventPlayer('core:ShowNotification', source, GetPhrase('inventory_receive', count, itemInventory.label))
            else
                itemInventory.count = (itemInventory.count + count)
                triggerEventPlayer("core:addExistItemPlayer", source, item, count)
                triggerEventPlayer('core:ShowNotification', source, GetPhrase('inventory_receive', count, itemInventory.label))
            end

            return true
        elseif itemInventory == nil then
            if slot == nil then
                local preselectedSlot = 0
                local slotFound = true
            
                while slotFound do
                    Wait(1)
                    slotFound = false
                    for _, v in pairs(inv) do
                        if v.slot == preselectedSlot then
                            preselectedSlot = preselectedSlot + 1
                            slotFound = true
                            break
                        end
                    end
                end
                slot = preselectedSlot 
            end
            local itemData = { name = item, label = getItemLabel(item), count = count, type = getItemType(item), slot = slot }
            table.insert(inv, itemData)
            triggerEventPlayer("core:addItemPlayer", source, itemData)
            GetPlayer(source):setInventaire(inv)
            triggerEventPlayer('core:ShowNotification', source, GetPhrase('inventory_receive',count, itemData.label))
            return true
        end
    else
        return false
    end
end

function getPropertyMaxWeight(propertyData)
    -- print("Premier print",json.encode(propertyData))
    -- for k, v in pairs(Property[etage.type].data) do
    --     print("Deuxieme print", k, " ----- k et v -----",json.encode(v))
    --     if v.name == etage.interior then
    --         return v.weight
    --     end
    -- end
    return propertyData.weight
end

function renameItem(source, item, name, metadatas)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if item == v.name then
            if v.metadatas == nil then
                v.metadatas = {}
            end
            if CompareMetadatas(v.metadatas, metadatas) then
                v.metadatas["renamed"] = name
                if not player:getNeedSave() then
                    --RefreshPlayerData(source)
                    MarkPlayerDataAsNonSaved(source)
                end
            end
        end
    end
end

function ChangeItemName(source, item, name)
    local itemInventory = getItemInventorymetadatas(source, item, nil)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if item == v.name and json.encode(itemInventory) ~= "null" then
            if v.metadatas == nil then
                v.metadatas = {}
            end
            v.metadatas["renamed"] = name
            if not player:getNeedSave() then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            end
        elseif item == v.name and json.encode(itemInventory) == "null" then
            v.metadatas["renamed"] = name
            if not player:getNeedSave() then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            end
        end
    end
end

function ChangeItemNameCloths(source, item, name, metadatas)
    local itemInventory = getItemInventorymetadatas(source, item, nil)
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if item == v.name and json.encode(itemInventory) ~= "null" and
            v.metadatas["drawableId"] == metadatas["drawableId"] and v.metadatas["renamed"] == metadatas["renamed"] then
            if v.metadatas == nil then
                v.metadatas = {}
            end
            if v.metadatas == metadatas then
                v.metadatas["renamed"] = name
                if not player:getNeedSave() then
                    --RefreshPlayerData(source)
                    MarkPlayerDataAsNonSaved(source)
                end
            end
        elseif item == v.name and json.encode(itemInventory) == "null" and
            v.metadatas["drawableId"] == metadatas["drawableId"] and v.metadatas["renamed"] == metadatas["renamed"] then
            v.metadatas["renamed"] = name
            if not player:getNeedSave() then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            end
        end
    end
end


function RemoveItemFromStorage(source, item, count, slot)
    local count = tonumber(count)
    local inv = GetPlayer(source):getStorage()

    if DoesItemexist(item) then
        local itemInventory = getItemStoragemetadatas(source, item, slot)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    if inv ~= nil then
                        for i = 1, #inv do
                            if inv[i] ~= nil then
                                if inv[i].name ~= nil then
                                    if inv[i].name == itemInventory.name then
                                        if slot then
                                            if inv[i].slot == slot then
                                                triggerEventPlayer("core:RemoveItemStorage", source, itemInventory.name, count, slot)
                                                table.remove(inv, i)
                                                GetPlayer(source):setStorage(inv)
                                                return true
                                            end
                                        else
                                            triggerEventPlayer("core:RemoveItemStorage", source, itemInventory.name,count)
                                            table.remove(inv, i)
                                            GetPlayer(source):setStorage(inv)
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                triggerEventPlayer("core:RemoveItemStorage", source, itemInventory.name, count, slot)
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function RemoveItemFromInventory(source, item, count, slot)
    local count = tonumber(count)
    local inv = GetPlayer(source):getInventaire()
    if DoesItemexist(item) then
        local itemInventory = getItemInventorymetadatas(source, item, slot)
        if itemInventory ~= nil then
            if itemInventory.count - count >= 0 then
                itemInventory.count = (itemInventory.count - count)
                if itemInventory.count == 0 then
                    if inv ~= nil then
                        for i = 1, #inv do
                            if inv[i] ~= nil then
                                if inv[i].name ~= nil then
                                    if inv[i].name == itemInventory.name then
                                        if slot then
                                            if inv[i].slot == slot then
                                                triggerEventPlayer("core:RemoveItemInventory", source, itemInventory
                                                    .name, count, slot)
                                                table.remove(inv, i)
                                                GetPlayer(source):setInventaire(inv)
                                                TriggerClientEvent('core:ShowNotification', source, GetPhrase('inventory_loose', count, itemInventory.label))
                                                return true
                                            end
                                        else
                                            triggerEventPlayer("core:RemoveItemInventory", source, itemInventory.name, count)
                                            table.remove(inv, i)
                                            GetPlayer(source):setInventaire(inv)
                                            TriggerClientEvent('core:ShowNotification', source, GetPhrase('inventory_loose', count, itemInventory.label))
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                triggerEventPlayer("core:RemoveItemInventory", source, itemInventory.name, count, slot)
                TriggerClientEvent('core:ShowNotification', source, GetPhrase('inventory_loose', count, itemInventory.label))
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function CanInventoryTakeItem(source, item, count, metadatas)
    local count = tonumber(count)
    if DoesItemexist(item) then
        if getInventoryWeight(source) + getItemWeight(item) * count <= items.maxWeight then
            return true
        else
            return false
        end
    else
        return false
    end
end
