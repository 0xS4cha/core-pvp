local itemsUsage = {
    ["bread"] = {
        removeOnUse = true,
        action = function(source)
            print('ok')
        end,
    },
}
items = {
    ['bread'] = {type = 'items', label = 'Pain', notStackable = false},
    ['weapon_pistol'] = {type = 'weapons', label = 'Pain', notStackable = true},
    ['weapon_pistol50'] = {type = 'weapons', label = 'Pain', notStackable = true},

}

function IsItemUsable(item)
    if itemsUsage[item] ~= nil then
        return true
    else
        return false
    end
end

function UseItemIfCan(source, item)
    if itemsUsage[item] ~= nil then
        if itemsUsage[item].removeOnUse then
            RemoveItemToPlayer(source, item, 1)
        end
        
        return true
    else
        return false
    end
end