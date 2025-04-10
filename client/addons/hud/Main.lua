

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