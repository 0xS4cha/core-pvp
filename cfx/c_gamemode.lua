AddEventHandler('onClientMapStart', function()
    setAutoSpawn(true)
    forceRespawn()

    NetworkSetFriendlyFireOption(true)

	Citizen.Wait(2500)
	setAutoSpawn(false)
end)

