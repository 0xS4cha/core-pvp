Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        _NUI.SendNUIMessage('showHud', { 
        show = true,
        data = {
            pausemenu = (not IsPauseMenuActive()),
            armorPercent = GetPedArmour(PlayerPedId()),
            healthPercent = GetEntityHealth(PlayerPedId())-100,
        }})
    end
end)

RegisterCommand("armor", function()
    SetPedArmour(PlayerPedId(), 100)
end, false)