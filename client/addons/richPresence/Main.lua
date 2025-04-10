Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    SetDiscordAppId(1073173549361135626)
    SetDiscordRichPresenceAsset("quality-upscale")
    SetDiscordRichPresenceAssetText("discord.gg/SOON")

    SetDiscordRichPresenceAction(0, "Jouer", "https://discord.gg/qkS9DnkweQ")
    SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/qkS9DnkweQ")
    while true do 
        SetRichPresence(_CONFIG.ServerName .. " - " .. GlobalState["nbJoueur"] .. " " .. GetPhrase('Player_Connected'))
        Wait(15000)
    end
end)