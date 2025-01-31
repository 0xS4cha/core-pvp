local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)
_INVENTORY = _INVENTORY or {}
_INVENTORY.open = false
_INVENTORY.TargetLoot = nil
_INVENTORY.InStorage = false
Weapons = {}
Items = {}
fastItems = {
    [1] = { label = "", name = "", slot = 1 },
    [2] = { label = "", name = "", slot = 2 },
    [3] = { label = "", name = "", slot = 3 },
    [4] = { label = "", name = "", slot = 4 },
}
local CreateThread <const> = CreateThread


function LootPlayer(player)
    local inv = p:getInventaire()
    local inv2 = nil
    local try = 0
    _INVENTORY.TargetLoot = player
    while inv2 == nil do
        inv2 = TriggerServerCallback("inventory:GetOtherPlayerInventory", player)
        try += 1
        if try > 10 then
            return
        end
        Wait(100)
    end


    Items = {}
    for k, v in pairs(inv) do
        if v.name == 'money' then
            v.count = Utils.Round(v.count, 0)
        end
        if v.type == 'items' or v.type == 'weapons' then
            table.insert(Items, {
                name = v.name,
                count = v.count,
                label = GetPhrase(v.name),
                slot = v.slot or k,
                type = v.type,

            })
        end
    end
    CreateThread(function()
        start(0.5, 0.8)
    end)

    CreateThread(function()
        SetNuiFocus(true, true)
        p:setInventaire(Items)
        _NUI.SendNUIMessage('showInventory', {
            show = true,
            secondInventory = true,
            translation = {
                backpack = GetPhrase('inventory_backpack')
            },
            Inventory2 = {
                canLoot = true,
                name = 'LOOT PLAYER',
                Items = inv2
            },
            inventory = {
                Items = Items,
                fastItems = fastItems
            }
        })
        _INVENTORY.open = true
    end)

    return
end

function CloseInventory()
    if _INVENTORY.open then
        _INVENTORY.open = false
        SetNuiFocus(false, false)
        DeleteEntity(clonedPed)
        if _INVENTORY.InStorage then
            _INVENTORY.InStorage = false
        end
        clonedPed = nil
        _NUI.SendNUIMessage('showInventory', {
            show = false
        })
    end
end

function OpenInventory()
    if not _INVENTORY.open then
        local inv = p:getInventaire()

        CreateThread(function()
            while _INVENTORY.open do
                Wait(0)
                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 1, true)  -- LookLeftRight
                DisableControlAction(0, 2, true)  -- LookUpDown
                DisableControlAction(0, 142, _INVENTORY.open)
                DisableControlAction(0, 18, _INVENTORY.open)
                DisableControlAction(0, 322, _INVENTORY.open)
                DisableControlAction(0, 106, _INVENTORY.open)
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 142, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
            end
        end)
        Items = {}
        for k, v in pairs(inv) do
            if v.name == 'money' then
                v.count = Utils.Round(v.count, 0)
            end
            if v.type == 'items' or v.type == 'weapons' then
                table.insert(Items, {
                    name = v.name,
                    count = v.count,
                    label = GetPhrase(v.name),
                    slot = v.slot or k,
                    type = v.type,

                })
            end
        end
        CreateThread(function()
            start(0.5, 0.8)
        end)

        CreateThread(function()
            SetNuiFocus(true, true)
            p:setInventaire(Items)
            _NUI.SendNUIMessage('showInventory', {
                show = true,
                secondInventory = false,
                translation = {
                    backpack = GetPhrase('inventory_backpack')
                },
                inventory = {
                    Items = Items,
                    fastItems = fastItems
                }
            })
            _INVENTORY.open = true
        end)

        return
    else
        _INVENTORY.open = false
        SetNuiFocus(false, false)
        DeleteEntity(clonedPed)
        clonedPed = nil
        _NUI.SendNUIMessage('showInventory', {
            show = false
        })
        return
    end
end

RegisterNUICallback('dropFastItem', function(data, cb)
    Items = {}
    local inv = p:getInventaire()

    data.slot = tonumber(data.slot) + 1
    for k, v in pairs(inv) do
        if v.name == 'money' then
            v.count = Utils.Round(v.count, 0)
        end
        if v.type == 'items' or v.type == 'weapons' then
            table.insert(Items, {
                name = v.name,
                count = v.count,
                label = GetPhrase(v.name),
                slot = v.slot or k,
                type = v.type,

            })
        end
    end
    fastItems[data.slot] = data.item
    CreateThread(function()
        p:setInventaire(Items)
        _NUI.SendNUIMessage('updateInventory', {
            inventory = {
                Items = Items,
                fastItems = fastItems,
                weapons = Weapons
            }
        })
    end)
end)

RegisterNUICallback('lootItem', function(data, cb)
    local response = false
    if _INVENTORY.InStorage then
        if tonumber(data.quantity) == 0 then
            data.quantity = tonumber(data.item.count)
        end


        response = TriggerServerCallback("inventory:lootStorage", Token, data)
    elseif _INVENTORY.TargetLoot then
        if tonumber(data.quantity) == 0 then
            data.quantity = tonumber(data.item.count)
        end
        if data.item.name == 'money' and tonumber(data.quantity) > _CONFIG.MAXMONEYLOOT then
            Utils.ShowNotification(GetPhrase('MaxMoneyLoot', data.quantity, _CONFIG.MAXMONEYLOOT))
            return
        end
        if tonumber(data.item.count) < tonumber(data.quantity) then
            Utils.ShowNotification(GetPhrase('NotEnoughItem'))
            return
        end
        response = TriggerServerCallback("inventory:lootItem", Token, data, _INVENTORY.TargetLoot)
    end


    if cb then
        cb(response)
    end
end)

RegisterNetEvent("core:inventory:refreshInv2", function(inv)
    RefreshInventory2(inv)
end)
RegisterNetEvent("core:addExistItemPlayer", function(item, quantity)
    local inv = p:getInventaire()
    for k, v in pairs(inv) do
        if item == v.name then
            v.count += quantity
            break
        end
    end
    p:setInventaire(inv)
    RefreshInventory()
end)

RegisterNetEvent("core:addItemStorage", function(item)
    local inv = p:getStorage()
    table.insert(inv, item)
    p:setStorage(inv)
    RefreshInventory2(p:getStorage(), GetPhrase('your_storage'))
end)

RegisterNetEvent('core:addExistItemStorage', function(item, quantity)
    local inv = p:getStorage()
    for k, v in pairs(inv) do
        if item == v.name then
            v.count += quantity
            break
        end
    end
    p:setStorage(inv)
    RefreshInventory2(p:getStorage(), GetPhrase('your_storage'))
end)
function RefreshInventory()
    local inv = p:getInventaire()
    Items = {}
    for k, v in pairs(inv) do
        if v.name == 'money' then
            v.count = Utils.Round(v.count, 0)
        end
        if v.type == 'items' or v.type == 'weapons' then
            table.insert(Items, {
                name = v.name,
                count = v.count,
                label = GetPhrase(v.name),
                slot = v.slot or k,
                type = v.type,

            })
        end
    end

    CreateThread(function()
        p:setInventaire(Items)
        _NUI.SendNUIMessage('updateInventory', {

            inventory = {
                Items = Items,
                fastItems = fastItems,
                weapons = Weapons
            }
        })
    end)
end

function RefreshInventory2(inv, text)
    _NUI.SendNUIMessage('updateInventory2', {
        inventory = {
            canLoot = true,
            canTrade = _INVENTORY.InStorage,
            name = text or GetPhrase('loot_player'),
            Items = inv
        },
    })
end

RegisterNUICallback('dropItem', function(data, cb)
    local response, newInv = TriggerServerCallback("inventory:swapItem", data)
    if response then
        p:setInventaire(newInv)
        RefreshInventory()
    end
    if cb then
        cb('ok')
    end
end)

RegisterNetEvent("inventory:refreshInventory", function(data)
    if data then
        p:setInventaire(data)
        RefreshInventory()
    end
end)

RegisterNUICallback('inventory-use-item', function(data, cb)
    if data.item.type ~= 'items' then
        return
    end
    TriggerServerEvent("core:UseItem", Token, data.item.name, data.item.slot)
end)



RegisterNUICallback('closeInventory', function(data, cb)
    SetNuiFocus(false, false)
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 24, true)
    EnableControlAction(0, 25, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 142, true)
    EnableControlAction(0, 18, true)
    EnableControlAction(0, 322, true)
    EnableControlAction(0, 106, true)
    DeleteEntity(clonedPed)
    clonedPed = nil
    SetNuiFocus(false, false)
    if _INVENTORY.TargetLoot then
        _INVENTORY.TargetLoot = nil
    end
    _NUI.SendNUIMessage('showInventory', {
        show = false
    })
    if _INVENTORY.InStorage then
        _INVENTORY.InStorage = false
    end
    _INVENTORY.open = false
    if cb then
        cb('ok')
    end
end)
