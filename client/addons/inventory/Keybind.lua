local weaponOut = false


Keys.Register('1', '1', GetPhrase('inventory_keybind1'), function()
    useitem(1)
end)
Keys.Register('2', '2', GetPhrase('inventory_keybind2'), function()
    useitem(2)
end)
Keys.Register('3', '3', GetPhrase('inventory_keybind3'), function()
    useitem(3)
end)
Keys.Register('4', '4', GetPhrase('inventory_keybind4'), function()
    useitem(4)
end)


function useitem(index) 
    local item = fastItems[index]
    if item.type == 'weapons' and string.find(item.name, "weapon_") then
        if weaponOut then
            TaskPlayAnim(p:ped(), "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0)
            local timer = GetGameTimer() + 1500
            while GetGameTimer() < timer do
                DisablePlayerFiring(p:ped(), true)
                Wait(0)
            end
            ClearPedTasks(p:ped())

            SetCurrentPedWeapon(p:ped(), 'WEAPON_UNARMED', true)
            weaponOut = false

            RemoveAllPedWeapons(p:ped(), 1)
        else
            Utils.LoadAnimDict("reaction@intimidation@1h")
            Utils.LoadAnimDict("weapons@pistol_1h@gang")
            Utils.LoadAnimDict("rcmjosh4")
            Utils.LoadAnimDict("reaction@intimidation@cop@unarmed")
            Utils.LoadAnimDict("weapons@pistol@")

            weaponOut = true
            TaskPlayAnim(p:ped(), "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0 )
            DisablePlayerFiring(p:ped(), true)
            Wait(1250)
            SetPedCurrentWeaponVisible(p:ped(), 1, 1, 1, 1)
            DisablePlayerFiring(p:ped(), false)
            ClearPedTasks(p:ped())
            GiveWeaponToPed(p:ped(), GetHashKey(item.name), 250, 0, true)
            SetCurrentPedWeapon(p:ped(), item.name, true)
            TriggerSecurEvent("core:RefreshInventory", nil, p:getInventaire())
        end

    end
end