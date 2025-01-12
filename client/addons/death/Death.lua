AddEventHandler('core:onPlayerDeath', function(data)
    isDead = true
    print(json.encode(data))
    PlayerInComa()
end)


RegisterCommand('pistol', function()
    local playerPed = PlayerPedId() 
    local weaponHash = GetHashKey("WEAPON_PISTOL")
    GiveWeaponToPed(playerPed, weaponHash, 250, false, true)
    SetCurrentPedWeapon(playerPed, weaponHash, true)
    print(GetHashKey('WEAPON_PISTOL'))
end, false)