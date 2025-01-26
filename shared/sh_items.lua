local itemsUsage = {
    ["kevlar"] = {
        removeOnUse = true,
        action = function(source)
            TriggerClientEvent('core:UseKevlar', source)
        end,
    },
    ["medic"] = {
        removeOnUse = true,
        action = function(source)
            TriggerClientEvent('core:UseMedic', source)
        end,
    },
}
items = {
    ['money'] = {type = 'items', label = 'Money', notStackable = false},
    ['kevlar'] = {type = 'items', label = 'Kevlar', notStackable = false},
    ['medic'] = {type = 'items', label = 'Medic', notStackable = false},
    ['medikit'] = {type = 'items', label = 'Medkit', notStackable = false},
    ['weapon_pistol'] = {type = 'weapons', label = 'Pistol', notStackable = true},
    ['weapon_pistol50'] = {type = 'weapons', label = 'Pistol50', notStackable = true},

}

function IsItemUsable(item)
    if itemsUsage[item] ~= nil then
        return true
    else
        return false
    end
end

function UseItemIfCan(source, item, slot)
    if itemsUsage[item] ~= nil then
        if itemsUsage[item].removeOnUse then
            RemoveItemToPlayer(source, item, 1, slot)
        end
        itemsUsage[item].action(source)
        return true
    else
        return false
    end
end