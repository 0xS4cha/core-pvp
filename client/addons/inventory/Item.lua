local AlreadyUse = false

RegisterNetEvent('core:UseKevlar', function()
    if p:haveItemWithCount('kevlar', 1) and not AlreadyUse then
        AlreadyUse = true
        Utils.RequestAndWaitDict("clothingtie")
        TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_positive_a", 8.0, -8, -1, 48, 0, 0, 0, 0)
        CreateProgressBar('setup_kevlar', 5000)
        Wait(5000)
        p:setShield(99)
        AlreadyUse = false
    end
end)

RegisterNetEvent('core:UseMedic', function()
    if p:haveItemWithCount('medic', 1) and not AlreadyUse then
        AlreadyUse = true
        Utils.RequestAndWaitDict("clothingtie")
        TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_positive_a", 8.0, -8, -1, 48, 0, 0, 0, 0)
        CreateProgressBar('setup_medic', 5000)
        Wait(5000)
        p:setHealth(200)
        AlreadyUse = false
    end
end)