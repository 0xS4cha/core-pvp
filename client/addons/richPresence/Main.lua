Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    
    --while true do -- desactivé pour l'instant car on a rien a mêtre a jour 
        SetDiscordAppId(999247110392266773)
        SetDiscordRichPresenceAsset("ldo_logo-upscale")
        SetDiscordRichPresenceAssetText("discord.gg/9TSgWRNqXZ")

        SetDiscordRichPresenceAction(0, "Jouer", "https://discord.gg/9TSgWRNqXZ")
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/9TSgWRNqXZ")
        --Wait(60000)
    --end
end)

RegisterNetEvent("core:UpdateRichPresence")
AddEventHandler("core:UpdateRichPresence", function (number)
    SetRichPresence(_CONFIG.ServerName.." - "..number.. " joueurs connectés")
end)