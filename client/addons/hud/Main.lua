Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if IsPedArmed(PlayerPedId(), 6) then
			DisableControlAction(1, 140, true)
			   DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		end
        _NUI.SendNUIMessage('showHud', { 
        show = true,
        data = {
            pausemenu = (not IsPauseMenuActive()),
            armorPercent = GetPedArmour(PlayerPedId()),
            healthPercent = GetEntityHealth(PlayerPedId())-100,
        }})
    end
end)

CreateThread(function()
    while p == nil do
        Wait(1)
    end
    AddTextEntry('PM_PANE_CFX', '~HUD_COLOUR_PM_MITEM_HIGHLIGHT~'.._CONFIG.ServerName)
    SetCanAttackFriendly(PlayerId(), true, false)
    NetworkSetFriendlyFireOption(true)
    SetAudioFlag("PoliceScannerDisabled", true)
    for i = 0, 15 do
        EnableDispatchService(i, false)
    end

    ClearPlayerWantedLevel(PlayerId())
    SetMaxWantedLevel(0)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

end)