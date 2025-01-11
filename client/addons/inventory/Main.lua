local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)
_INVENTORY = _INVENTORY or {}
_INVENTORY.open = false
Weapons = {}
Items = {}

local CreateThread <const> = CreateThread

function OpenInventory()
    weapons = TriggerServerCallback('core:GetWeaponSave', Token)

    if not _INVENTORY.open then

        local inv = p:getInventaire()

        CreateThread(function()
            while _INVENTORY.open do
                Wait(0)
                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 1, true) -- LookLeftRight
                DisableControlAction(0, 2, true) -- LookUpDown
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
        for k,v in pairs(inv) do
            if v.name == 'money' then
                v.count = Utils.Round(v.count, 0)
            end
            if v.type == 'items' or v.type == 'weapons' then
                table.insert(Items, {
                    name = v.name,
                    count = v.count,
                    label = v.label,
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
                inventory = {
                    Items = Items,
                    fastItems = {
                        [1] =  { label = "", name = "", slot = 1 },
                        [2] = { label = "", name = "", slot = 2},
                        [3] = { label = "", name = "", slot = 3 },
                        [4] = { label = "", name = "", slot = 4 },
                    },
                    weapons = Weapons
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


RegisterNUICallback('dropItem', function(data, cb)
    Items = {}
    local inv = p:getInventaire()
    for k,v in pairs(inv) do

        if v.name == data.item.name then
            v.slot = data.slot
        end
        if v.slot == data.slot then
            v.slot = data.item.slot
        end
        if v.name == 'money' then
            v.count = Utils.Round(v.count, 0)
        end
        if v.type == 'items' or v.type == 'weapons' then
            table.insert(Items, {
                name = v.name,
                count = v.count,
                label = v.label,
                slot =  v.slot or k,
                type = v.type,

            })
        end
    end
    -- Construire la table des items actuels
    CreateThread(function()

        p:setInventaire(Items)
        _NUI.SendNUIMessage('showInventory', {
            show = true,
            inventory = {
                Items = Items,
                fastItems = {
                    [1] =  { label = "", name = "", slot = 1 },
                    [2] = { label = "", name = "", slot = 2},
                    [3] = { label = "", name = "", slot = 3 },
                    [4] = { label = "", name = "", slot = 4 },
                },
                weapons = Weapons
            }
        })
    end)

    -- Retourner une réponse
    if cb then
        cb('ok')
    end
end)


RegisterNUICallback('closeInventory', function(data, cb)
    _INVENTORY.open = false
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
    _NUI.SendNUIMessage('showInventory', {
        show = false
    })
    if cb then
        cb('ok')
    end
end)



RegisterKeyMapping("+inventory", "Ouvrir l'inventaire", "keyboard", "TAB")
RegisterCommand("+inventory", function()
    OpenInventory()
end)
